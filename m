Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3S7Rl2u024573
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 03:27:47 -0400
Received: from rv-out-0506.google.com (rv-out-0708.google.com [209.85.198.240])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3S7RZcJ012047
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 03:27:36 -0400
Received: by rv-out-0506.google.com with SMTP id b17so2735424rvf.51
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 00:27:35 -0700 (PDT)
Date: Mon, 28 Apr 2008 00:26:55 -0700
From: Brandon Philips <brandon@ifup.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080428072655.GB782@plankton.ifup.org>
References: <20080417012354.GH18929@outflux.net>
	<200804212310.47130.laurent.pinchart@skynet.be>
	<20080421214717.GJ18865@outflux.net>
	<200804250055.45118.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <200804250055.45118.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] v4l: Introduce "stream" attribute for persistent
	video4linux device nodes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Disclaimer: I am not attached to the name, "stream".  Open to suggestion.

Kees introduced a patch set last week that attempts to get stable device naming
for v4l.  The set used a string attribute called function to allow udev to
assemble a unique and stable path for device nodes.

This patch is similar.  However, instead of a string an integer is used called
"stream".  If the driver calls video_register_device in the same order every
time it is loaded then we can end up with something like this with the right
udev rules[1]:

/dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video0
/dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video1
/dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video2

# ls -la /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video0 
lrwxrwxrwx 1 root root 12 2008-04-28 00:02 /dev/v4l/by-path/pci-0000:00:1d.2-usb-0:1:1.0-video0 -> ../../video1

Kees: I don't have a device that creates multiple device nodes.  Please
test with ivtv.  :D

video_register_device_stream is available to drivers to request a specific
stream number.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
[1] Place the attached udev rules in /etc/udev/rules.d/60-persistent-v4l.rules

 linux/drivers/media/video/videodev.c |   96 ++++++++++++++++++++++++++++++++++-
 linux/include/media/v4l2-dev.h       |    4 +
 2 files changed, 98 insertions(+), 2 deletions(-)

Index: v4l-dvb-clean/linux/drivers/media/video/videodev.c
===================================================================
--- v4l-dvb-clean.orig/linux/drivers/media/video/videodev.c
+++ v4l-dvb-clean/linux/drivers/media/video/videodev.c
@@ -428,6 +428,14 @@ EXPORT_SYMBOL(v4l_printk_ioctl);
  *	sysfs stuff
  */
 
+static ssize_t show_stream(struct device *cd,
+			 struct device_attribute *attr, char *buf)
+{
+	struct video_device *vfd = container_of(cd, struct video_device,
+						class_dev);
+	return sprintf(buf, "%i\n", vfd->stream);
+}
+
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,13)
 static ssize_t show_name(struct class_device *cd, char *buf)
 #else
@@ -486,6 +494,7 @@ static void video_release(struct device 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,13)
 static struct device_attribute video_device_attrs[] = {
 	__ATTR(name, S_IRUGO, show_name, NULL),
+	__ATTR(stream, S_IRUGO, show_stream, NULL),
 	__ATTR_NULL
 };
 #endif
@@ -2013,8 +2022,81 @@ out:
 }
 EXPORT_SYMBOL(video_ioctl2);
 
+struct stream_number_info {
+	struct device *dev;
+	unsigned int used[VIDEO_NUM_DEVICES];
+};
+
+static int __fill_stream_number_info(struct device *cd, void *data)
+{
+	struct stream_number_info *info = data;
+	struct video_device *vfd = container_of(cd, struct video_device,
+						class_dev);
+
+	if (info->dev == vfd->dev)
+		info->used[vfd->stream] = 1;
+
+	return 0;
+}
+
+/**
+ * assign_stream_number - assign stream number based on parent device
+ * @vdev: video_device to assign stream number to, vdev->dev should be assigned
+ * @num: -1 if auto assign, requested number otherwise
+ *
+ *
+ * returns -ENFILE if num is already in use, a free stream number if
+ * successful.
+ */
+static int get_stream_number(struct video_device *vdev, int num)
+{
+	struct stream_number_info *info;
+	int i;
+	int ret = 0;
+
+	if (num >= VIDEO_NUM_DEVICES)
+		return -EINVAL;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->dev = vdev->dev;
+
+	ret = class_for_each_device(&video_class, &info,
+					__fill_stream_number_info);
+
+	if (ret < 0)
+		goto out;
+
+	if (num >= 0) {
+		if (!info->used[num])
+			ret = num;
+		else
+			ret = -ENFILE;
+
+		goto out;
+	}
+
+	for (i = 0; i < VIDEO_NUM_DEVICES; i++) {
+		if (!info->used[i])
+			ret = i;
+		goto out;
+	}
+
+out:
+	kfree(info);
+	return ret;
+}
+
 static const struct file_operations video_fops;
 
+int video_register_device(struct video_device *vfd, int type, int nr)
+{
+	return video_register_device_stream(vfd, type, nr, -1);
+}
+EXPORT_SYMBOL(video_register_device);
+
 /**
  *	video_register_device - register video4linux devices
  *	@vfd:  video device structure we want to register
@@ -2040,7 +2122,8 @@ static const struct file_operations vide
  *	%VFL_TYPE_RADIO - A radio card
  */
 
-int video_register_device(struct video_device *vfd, int type, int nr)
+int video_register_device_stream(struct video_device *vfd, int type, int nr,
+					int stream)
 {
 	int i=0;
 	int base;
@@ -2143,6 +2226,15 @@ int video_register_device(struct video_d
 	}
 #endif
 
+	ret = get_stream_number(vfd, stream);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: get_stream_number failed\n",
+		       __func__);
+		goto fail_minor;
+	}
+
+	vfd->stream = ret;
+
 #if 1 /* keep */
 	/* needed until all drivers are fixed */
 	if (!vfd->release)
@@ -2159,7 +2251,7 @@ fail_minor:
 	mutex_unlock(&videodev_lock);
 	return ret;
 }
-EXPORT_SYMBOL(video_register_device);
+EXPORT_SYMBOL(video_register_device_stream);
 
 /**
  *	video_unregister_device - unregister a video4linux device
Index: v4l-dvb-clean/linux/include/media/v4l2-dev.h
===================================================================
--- v4l-dvb-clean.orig/linux/include/media/v4l2-dev.h
+++ v4l-dvb-clean/linux/include/media/v4l2-dev.h
@@ -113,6 +113,8 @@ struct video_device
 	int type;       /* v4l1 */
 	int type2;      /* v4l2 */
 	int minor;
+	/* attribute to diferentiate multiple streams on one physical device */
+	int stream;
 
 	int debug;	/* Activates debug level*/
 
@@ -373,6 +375,8 @@ void *priv;
 
 /* Version 2 functions */
 extern int video_register_device(struct video_device *vfd, int type, int nr);
+int video_register_device_stream(struct video_device *vfd, int type, int nr,
+					int stream);
 void video_unregister_device(struct video_device *);
 extern int video_ioctl2(struct inode *inode, struct file *file,
 			  unsigned int cmd, unsigned long arg);

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="60-persistent-v4l.rules"

# do not edit this file, it will be overwritten on update

ACTION!="add|change", GOTO="persistent_v4l_end"
SUBSYSTEM!="video4linux", GOTO="persistent_v4l_end"

# check for valid "stream" number
TEST!="stream", GOTO="persistent_v4l_end"
ATTR{stream}!="?*", GOTO="persistent_v4l_end"

IMPORT{program}="path_id %p"
ENV{ID_PATH}=="?*", KERNEL=="video*", SYMLINK+="v4l/by-path/$env{ID_PATH}-video$attr{stream}"
ENV{ID_PATH}=="?*", KERNEL=="audio*", SYMLINK+="v4l/by-path/$env{ID_PATH}-audio$attr{stream}"

LABEL="persistent_v4l_end"


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--EeQfGwPcQSOJBaQU--

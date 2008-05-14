Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4EG9VkL028619
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 12:09:31 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4EG9Bm6028546
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 12:09:11 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1801663ywb.81
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 09:09:09 -0700 (PDT)
Date: Wed, 14 May 2008 09:09:01 -0700
From: Brandon Philips <brandon@ifup.org>
To: Kees Cook <kees@outflux.net>
Message-ID: <20080514160901.GA5884@plankton.ifup.org>
References: <20080417012354.GH18929@outflux.net>
	<200804212310.47130.laurent.pinchart@skynet.be>
	<20080421214717.GJ18865@outflux.net>
	<200804250055.45118.laurent.pinchart@skynet.be>
	<20080428072655.GB782@plankton.ifup.org>
	<20080503193903.GM12850@outflux.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20080503193903.GM12850@outflux.net>
Cc: video4linux-list@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] v4l: Introduce "stream" attribute for persistent
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


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 12:39 Sat 03 May 2008, Kees Cook wrote:
> On Mon, Apr 28, 2008 at 12:26:55AM -0700, Brandon Philips wrote:
> > Kees: I don't have a device that creates multiple device nodes.  Please
> > test with ivtv.  :D
> 
> Unfortunately, this doesn't work with ivtv -- each device has a streamid
> of 0.  (video0, video24, video32 all on the same PCI path reported
> stream 0)

Could you please try this one?  I think I see the problem.  Updated
60-persistent-v4l.rules attached.

[PATCH] v4l: Introduce "index" attribute for persistent video4linux device nodes

Kees introduced a patch set last week that attempts to get stable device naming
for v4l.  The set used a string attribute called function to allow udev to
assemble a unique and stable path for device nodes.

This patch is similar.  However, instead of a string an integer is used called
"index".  If the driver calls video_register_device in the same order every
time it is loaded then we should end up with something like this with the right
udev rules:

/dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video0
/dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video1
/dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video2

# ls -la /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video0 
lrwxrwxrwx 1 root root 12 2008-04-28 00:02 /dev/v4l/by-path/pci-0000:00:1d.2-usb-0:1:1.0-video0 -> ../../video1

However, I don't have a device that creates multiple indexes.  Kees, please
test with ivtv.  :D

video_register_device_index is available to drivers to request a specific
index number.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 drivers/media/video/videodev.c |   98 ++++++++++++++++++++++++++++++++++++++++-
 include/media/v4l2-dev.h       |    4 +
 2 files changed, 100 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/media/video/videodev.c
===================================================================
--- linux-2.6.orig/drivers/media/video/videodev.c
+++ linux-2.6/drivers/media/video/videodev.c
@@ -424,6 +424,14 @@ EXPORT_SYMBOL(v4l_printk_ioctl);
  *	sysfs stuff
  */
 
+static ssize_t show_index(struct device *cd,
+			 struct device_attribute *attr, char *buf)
+{
+	struct video_device *vfd = container_of(cd, struct video_device,
+						class_dev);
+	return sprintf(buf, "%i\n", vfd->index);
+}
+
 static ssize_t show_name(struct device *cd,
 			 struct device_attribute *attr, char *buf)
 {
@@ -462,6 +470,7 @@ static void video_release(struct device 
 
 static struct device_attribute video_device_attrs[] = {
 	__ATTR(name, S_IRUGO, show_name, NULL),
+	__ATTR(index, S_IRUGO, show_index, NULL),
 	__ATTR_NULL
 };
 
@@ -1976,8 +1985,82 @@ out:
 }
 EXPORT_SYMBOL(video_ioctl2);
 
+static struct index_info {
+	struct device *dev;
+	unsigned int used[VIDEO_NUM_DEVICES];
+};
+
+static int __fill_index_info(struct device *cd, void *data)
+{
+	struct index_info *info = data;
+	struct video_device *vfd = container_of(cd, struct video_device,
+						class_dev);
+
+	if (info->dev == vfd->dev)
+		info->used[vfd->index] = 1;
+
+	return 0;
+}
+
+/**
+ * assign_index - assign stream number based on parent device
+ * @vdev: video_device to assign index number to, vdev->dev should be assigned
+ * @num: -1 if auto assign, requested number otherwise
+ *
+ *
+ * returns -ENFILE if num is already in use, a free index number if
+ * successful.
+ */
+static int get_index(struct video_device *vdev, int num)
+{
+	struct index_info *info;
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
+					__fill_index_info);
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
+		if (info->used[i])
+			continue;
+		ret = i;
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
+	return video_register_device_index(vfd, type, nr, -1);
+}
+EXPORT_SYMBOL(video_register_device);
+
 /**
  *	video_register_device - register video4linux devices
  *	@vfd:  video device structure we want to register
@@ -2003,7 +2086,8 @@ static const struct file_operations vide
  *	%VFL_TYPE_RADIO - A radio card
  */
 
-int video_register_device(struct video_device *vfd, int type, int nr)
+int video_register_device_index(struct video_device *vfd, int type, int nr,
+					int index)
 {
 	int i=0;
 	int base;
@@ -2060,6 +2144,16 @@ int video_register_device(struct video_d
 	}
 	video_device[i]=vfd;
 	vfd->minor=i;
+
+	ret = get_index(vfd, index);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: get_index failed\n",
+		       __func__);
+		goto fail_minor;
+	}
+
+	vfd->index = ret;
+
 	mutex_unlock(&videodev_lock);
 	mutex_init(&vfd->lock);
 
@@ -2093,7 +2187,7 @@ fail_minor:
 	mutex_unlock(&videodev_lock);
 	return ret;
 }
-EXPORT_SYMBOL(video_register_device);
+EXPORT_SYMBOL(video_register_device_index);
 
 /**
  *	video_unregister_device - unregister a video4linux device
Index: linux-2.6/include/media/v4l2-dev.h
===================================================================
--- linux-2.6.orig/include/media/v4l2-dev.h
+++ linux-2.6/include/media/v4l2-dev.h
@@ -97,6 +97,8 @@ struct video_device
 	int type;       /* v4l1 */
 	int type2;      /* v4l2 */
 	int minor;
+	/* attribute to diferentiate multiple indexs on one physical device */
+	int index;
 
 	int debug;	/* Activates debug level*/
 
@@ -343,6 +345,8 @@ void *priv;
 
 /* Version 2 functions */
 extern int video_register_device(struct video_device *vfd, int type, int nr);
+int video_register_device_index(struct video_device *vfd, int type, int nr,
+					int index);
 void video_unregister_device(struct video_device *);
 extern int video_ioctl2(struct inode *inode, struct file *file,
 			  unsigned int cmd, unsigned long arg);

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="60-persistent-v4l.rules"

# do not edit this file, it will be overwritten on update

ACTION!="add|change", GOTO="persistent_v4l_end"
SUBSYSTEM!="video4linux", GOTO="persistent_v4l_end"

# check for valid "index" number
TEST!="index", GOTO="persistent_v4l_end"
ATTR{index}!="?*", GOTO="persistent_v4l_end"

IMPORT{program}="path_id %p"
ENV{ID_PATH}=="?*", KERNEL=="video*", SYMLINK+="v4l/by-path/$env{ID_PATH}-video$attr{index}"
ENV{ID_PATH}=="?*", KERNEL=="audio*", SYMLINK+="v4l/by-path/$env{ID_PATH}-audio$attr{index}"

LABEL="persistent_v4l_end"


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--HlL+5n6rz5pIUxbD--

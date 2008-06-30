Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5ULSnlt029950
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 17:28:49 -0400
Received: from mail11b.verio-web.com (mail11b.verio-web.com [204.202.242.87])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5ULSaLh004570
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 17:28:36 -0400
Received: from mx59.stngva01.us.mxservers.net (204.202.242.112)
	by mail11b.verio-web.com (RS ver 1.0.95vs) with SMTP id 1-0421621316
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 17:28:36 -0400 (EDT)
Date: Mon, 30 Jun 2008 14:28:34 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
To: mchehab@infradead.org, greg@kroah.com, v4l-vdb-maintainer@linuxtv.org,
	video4linux-list@redhat.com, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-ID: <tkrat.5cc12a6138632636@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Cc: dean@sensoray.com
Subject: [PATCH] Sensoray 2255 V4l driver checkpatch fixes
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

From: Dean Anderson <dean@sensoray.com>

This patch fixes some coding style issues.
It also fixes a NULL de-reference on driver unload.
The permissions for the module parameters were changed to 0644.

Signed-off-by: Dean Anderson <dean@sensoray.com>
---

Diff from v4l-dvb development tree.


diff -r cb6162341029 linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Sun Jun 29 08:54:08 2008 -0300
+++ b/linux/drivers/media/video/s2255drv.c	Mon Jun 30 13:56:21 2008 -0700
@@ -68,17 +68,17 @@
 /* maximum time for DSP to start responding after last FW word loaded(ms) */
 #define S2255_DSP_BOOTTIME      400
 /* maximum time to wait for firmware to load (ms) */
-#define S2255_LOAD_TIMEOUT      (5000+S2255_DSP_BOOTTIME)
+#define S2255_LOAD_TIMEOUT      (5000 + S2255_DSP_BOOTTIME)
 #define S2255_DEF_BUFS          16
 #define MAX_CHANNELS		4
 #define FRAME_MARKER		0x2255DA4AL
-#define MAX_PIPE_USBBLOCK	(40*1024)
-#define DEFAULT_PIPE_USBBLOCK	(16*1024)
+#define MAX_PIPE_USBBLOCK	(40 * 1024)
+#define DEFAULT_PIPE_USBBLOCK	(16 * 1024)
 #define MAX_CHANNELS		4
 #define MAX_PIPE_BUFFERS	1
 #define SYS_FRAMES		4
 /* maximum size is PAL full size plus room for the marker header(s) */
-#define SYS_FRAMES_MAXSIZE	(720*288*2*2 + 4096)
+#define SYS_FRAMES_MAXSIZE	(720 * 288 * 2 * 2 + 4096)
 #define DEF_USB_BLOCK		(4096)
 #define LINE_SZ_4CIFS_NTSC	640
 #define LINE_SZ_2CIFS_NTSC	640
@@ -169,7 +169,7 @@ struct s2255_bufferi {
 
 #define DEF_MODEI_NTSC_CONT	{FORMAT_NTSC, DEF_SCALE, DEF_COLOR,	\
 			DEF_FDEC, DEF_BRIGHT, DEF_CONTRAST, DEF_SATURATION, \
-			DEF_HUE, 0, DEF_USB_BLOCK, 0 }
+			DEF_HUE, 0, DEF_USB_BLOCK, 0}
 
 struct s2255_dmaqueue {
 	struct list_head	active;
@@ -276,6 +276,10 @@ struct s2255_fh {
 	struct s2255_mode	mode;
 };
 
+/*
+ * TODO: fixme S2255_MAX_USERS. Do not limit open driver handles.
+ * Limit V4L to one stream at a time.
+ */
 #define S2255_MAX_USERS         1
 
 #define CUR_USB_FWVER	774	/* current cypress EEPROM firmware version */
@@ -294,7 +298,7 @@ struct s2255_fh {
 #define PREFIX_SIZE		512
 
 /* Channels on box are in reverse order */
-static unsigned long G_chnmap[MAX_CHANNELS] = { 3, 2, 1, 0 };
+static unsigned long G_chnmap[MAX_CHANNELS] = {3, 2, 1, 0};
 
 static LIST_HEAD(s2255_devlist);
 
@@ -330,11 +334,11 @@ static unsigned int vid_limit = 16;	/* V
 /* start video number */
 static int video_nr = -1;	/* /dev/videoN, -1 for autodetect */
 
-module_param(debug, int, 0);
+module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level(0-100) default 0");
-module_param(vid_limit, int, 0);
+module_param(vid_limit, int, 0644);
 MODULE_PARM_DESC(vid_limit, "video memory limit(Mb)");
-module_param(video_nr, int, 0);
+module_param(video_nr, int, 0644);
 MODULE_PARM_DESC(video_nr, "start video minor(-1 default autodetect)");
 
 /* USB device table */
@@ -438,7 +442,10 @@ static int norm_minh(struct video_device
 }
 
 
-/* converts 2255 planar format to yuyv or uyvy */
+/*
+ * TODO: fixme: move YUV reordering to hardware
+ * converts 2255 planar format to yuyv or uyvy
+ */
 static void planar422p_to_yuv_packed(const unsigned char *in,
 				     unsigned char *out,
 				     int width, int height,
@@ -503,7 +510,7 @@ static void s2255_fwchunk_complete(struc
 	struct usb_device *udev = urb->dev;
 	int len;
 	dprintk(100, "udev %p urb %p", udev, urb);
-
+	/* TODO: fixme.  reflect change in status */
 	if (urb->status) {
 		dev_err(&udev->dev, "URB failed with status %d", urb->status);
 		return;
@@ -683,7 +690,7 @@ static int buffer_setup(struct videobuf_
 	if (0 == *count)
 		*count = S2255_DEF_BUFS;
 
-	while (*size * *count > vid_limit * 1024 * 1024)
+	while (*size * (*count) > vid_limit * 1024 * 1024)
 		(*count)--;
 
 	return 0;
@@ -790,7 +797,7 @@ static int res_get(struct s2255_dev *dev
 
 static int res_locked(struct s2255_dev *dev, struct s2255_fh *fh)
 {
-	return (dev->resources[fh->channel]);
+	return dev->resources[fh->channel];
 }
 
 static void res_free(struct s2255_dev *dev, struct s2255_fh *fh)
@@ -807,7 +814,8 @@ static int vidioc_querycap(struct file *
 	struct s2255_dev *dev = fh->dev;
 	strlcpy(cap->driver, "s2255", sizeof(cap->driver));
 	strlcpy(cap->card, "s2255", sizeof(cap->card));
-	strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));
+	strlcpy(cap->bus_info, dev_name(&dev->udev->dev),
+		sizeof(cap->bus_info));
 	cap->version = S2255_VERSION;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	return 0;
@@ -840,8 +848,7 @@ static int vidioc_g_fmt_vid_cap(struct f
 	f->fmt.pix.pixelformat = fh->fmt->fourcc;
 	f->fmt.pix.bytesperline = f->fmt.pix.width * (fh->fmt->depth >> 3);
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
-
-	return (0);
+	return 0;
 }
 
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
@@ -962,7 +969,7 @@ static int vidioc_s_fmt_vid_cap(struct f
 	ret = vidioc_try_fmt_vid_cap(file, fh, f);
 
 	if (ret < 0)
-		return (ret);
+		return ret;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 
@@ -1337,7 +1344,7 @@ static int vidioc_enum_input(struct file
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
 	inp->std = S2255_NORMS;
 	strlcpy(inp->name, "Camera", sizeof(inp->name));
-	return (0);
+	return 0;
 }
 
 static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
@@ -1361,7 +1368,7 @@ static int vidioc_queryctrl(struct file 
 	for (i = 0; i < ARRAY_SIZE(s2255_qctrl); i++)
 		if (qc->id && qc->id == s2255_qctrl[i].id) {
 			memcpy(qc, &(s2255_qctrl[i]), sizeof(*qc));
-			return (0);
+			return 0;
 		}
 
 	dprintk(4, "query_ctrl -EINVAL %d\n", qc->id);
@@ -1376,7 +1383,7 @@ static int vidioc_g_ctrl(struct file *fi
 	for (i = 0; i < ARRAY_SIZE(s2255_qctrl); i++)
 		if (ctrl->id == s2255_qctrl[i].id) {
 			ctrl->value = qctl_regs[i];
-			return (0);
+			return 0;
 		}
 	dprintk(4, "g_ctrl -EINVAL\n");
 
@@ -1396,7 +1403,7 @@ static int vidioc_s_ctrl(struct file *fi
 		if (ctrl->id == s2255_qctrl[i].id) {
 			if (ctrl->value < s2255_qctrl[i].minimum ||
 			    ctrl->value > s2255_qctrl[i].maximum)
-				return (-ERANGE);
+				return -ERANGE;
 
 			qctl_regs[i] = ctrl->value;
 			/* update the mode to the corresponding value */
@@ -1572,6 +1579,11 @@ static void s2255_destroy(struct kref *k
 		usb_free_urb(dev->fw_data->fw_urb);
 		dev->fw_data->fw_urb = NULL;
 	}
+	/*
+	 * TODO: fixme(above, below): potentially leaving timers alive.
+	 *                            do not ignore timeout below if
+	 *                            it occurs.
+	 */
 
 	/* make sure we aren't waiting for the DSP */
 	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_LOADED_DSPWAIT) {
@@ -1583,13 +1595,10 @@ static void s2255_destroy(struct kref *k
 	}
 
 	if (dev->fw_data) {
+		if (dev->fw_data->fw)
+			release_firmware(dev->fw_data->fw);
 		kfree(dev->fw_data->pfw_data);
 		kfree(dev->fw_data);
-	}
-
-	if (dev->fw_data->fw) {
-		release_firmware(dev->fw_data->fw);
-		dev->fw_data->fw = NULL;
 	}
 
 	usb_put_dev(dev->udev);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

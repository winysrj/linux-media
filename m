Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway05.websitewelcome.com ([69.56.195.29]:47955 "HELO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755358Ab0CEXCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 18:02:54 -0500
Date: Fri, 5 Mar 2010 14:59:48 -0800 (PST)
From: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv: support for 2257 device
To: linux-media@vger.kernel.org
Message-ID: <tkrat.51e98e0adddfd2f1@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <dean@sensoray.com>
# Date 1267829723 28800
# Node ID 54b44c52d908b363f69488fed84f1e8b9ccaf038
# Parent  bdfee5ee52c800a24e1231cd52eeeb91636c013c
s2255drv: support for 2257 device

From: Dean Anderson <dean@sensoray.com>

2257 is 2255 with 2 svideo inputs

Priority: normal

Signed-off-by: Dean Anderson <dean@sensoray.com>

diff -r bdfee5ee52c8 -r 54b44c52d908 linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Fri Mar 05 09:26:08 2010 -0800
+++ b/linux/drivers/media/video/s2255drv.c	Fri Mar 05 14:55:23 2010 -0800
@@ -120,9 +120,10 @@
 #define COLOR_YUVPK	2	/* YUV packed */
 #define COLOR_Y8	4	/* monochrome */
 #define COLOR_JPG       5       /* JPEG */
-#define MASK_COLOR      0xff
-#define MASK_JPG_QUALITY 0xff00
 
+#define MASK_COLOR       0x000000ff
+#define MASK_JPG_QUALITY 0x0000ff00
+#define MASK_INPUT_TYPE  0x000f0000
 /* frame decimation. Not implemented by V4L yet(experimental in V4L) */
 #define FDEC_1		1	/* capture every frame. default */
 #define FDEC_2		2	/* capture every 2nd frame */
@@ -196,7 +197,6 @@
 #define S2255_FW_SUCCESS	2
 #define S2255_FW_FAILED		3
 #define S2255_FW_DISCONNECTING  4
-
 #define S2255_FW_MARKER		cpu_to_le32(0x22552f2f)
 /* 2255 read states */
 #define S2255_READ_IDLE         0
@@ -267,12 +267,12 @@
 	int                     vidstatus[MAX_CHANNELS];
 	wait_queue_head_t       wait_vidstatus[MAX_CHANNELS];
 	int                     vidstatus_ready[MAX_CHANNELS];
-
 	int                     chn_ready;
-	struct kref		kref;
 	spinlock_t              slock;
 	/* dsp firmware version (f2255usb.bin) */
 	int                     dsp_fw_ver;
+	u16                     pid; /* product id */
+	struct kref		kref;
 };
 #define to_s2255_dev(d) container_of(d, struct s2255_dev, kref)
 
@@ -306,20 +306,49 @@
 /* current cypress EEPROM firmware version */
 #define S2255_CUR_USB_FWVER	((3 << 8) | 6)
 /* current DSP FW version */
-#define S2255_CUR_DSP_FWVER     5
+#define S2255_CUR_DSP_FWVER     8
 /* Need DSP version 5+ for video status feature */
-#define S2255_MIN_DSP_STATUS    5
+#define S2255_MIN_DSP_STATUS      5
+#define S2255_MIN_DSP_COLORFILTER 8
 #define S2255_MAJOR_VERSION	1
-#define S2255_MINOR_VERSION	17
+#define S2255_MINOR_VERSION	18
 #define S2255_RELEASE		0
 #define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
 					       S2255_MINOR_VERSION, \
 					       S2255_RELEASE)
 
-/* vendor ids */
-#define USB_S2255_VENDOR_ID	0x1943
-#define USB_S2255_PRODUCT_ID	0x2255
 #define S2255_NORMS		(V4L2_STD_PAL | V4L2_STD_NTSC)
+
+/* private V4L2 controls */
+
+/*
+ * The following chart displays how COLORFILTER should be set
+ *  =========================================================
+ *  =     fourcc              =     COLORFILTER             =
+ *  =                         ===============================
+ *  =                         =   0             =    1      =
+ *  =========================================================
+ *  =  V4L2_PIX_FMT_GREY(Y8)  = monochrome from = monochrome=
+ *  =                         = s-video or      = composite =
+ *  =                         = B/W camera      = input     =
+ *  =========================================================
+ *  =    other                = color, svideo   = color,    =
+ *  =                         =                 = composite =
+ *  =========================================================
+ *
+ * Notes:
+ *   channels 0-3 on 2255 are composite
+ *   channels 0-1 on 2257 are composite, 2-3 are s-video
+ * If COLORFILTER is 0 with a composite color camera connected,
+ * the output will appear monochrome but hatching
+ * will occur.
+ * COLORFILTER is different from "color killer" and "color effects"
+ * for reasons above.
+ */
+#define S2255_V4L2_YC_ON  1
+#define S2255_V4L2_YC_OFF 0
+#define V4L2_CID_PRIVATE_COLORFILTER (V4L2_CID_PRIVATE_BASE + 0)
+
 /* frame prefix size (sent once every frame) */
 #define PREFIX_SIZE		512
 
@@ -360,7 +389,6 @@
 
 static struct usb_driver s2255_driver;
 
-
 /* Declare static vars that will be used as parameters */
 static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
 
@@ -375,13 +403,14 @@
 MODULE_PARM_DESC(video_nr, "start video minor(-1 default autodetect)");
 
 /* USB device table */
+#define USB_SENSORAY_VID	0x1943
 static struct usb_device_id s2255_table[] = {
-	{USB_DEVICE(USB_S2255_VENDOR_ID, USB_S2255_PRODUCT_ID)},
+	{USB_DEVICE(USB_SENSORAY_VID, 0x2255)},
+	{USB_DEVICE(USB_SENSORAY_VID, 0x2257)}, /*same family as 2255*/
 	{ }			/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, s2255_table);
 
-
 #define BUFFER_TIMEOUT msecs_to_jiffies(400)
 
 /* image formats.  */
@@ -798,6 +827,28 @@
 	dprintk(1, "res: put\n");
 }
 
+static int vidioc_querymenu(struct file *file, void *priv,
+			    struct v4l2_querymenu *qmenu)
+{
+	static const char *colorfilter[] = {
+		"Off",
+		"On",
+		NULL
+	};
+	if (qmenu->id == V4L2_CID_PRIVATE_COLORFILTER) {
+		int i;
+		const char **menu_items = colorfilter;
+		for (i = 0; i < qmenu->index && menu_items[i]; i++)
+			; /* do nothing (from v4l2-common.c) */
+		if (menu_items[i] == NULL || menu_items[i][0] == '\0')
+			return -EINVAL;
+		strlcpy(qmenu->name, menu_items[qmenu->index],
+			sizeof(qmenu->name));
+		return 0;
+	}
+	return v4l2_ctrl_query_menu(qmenu, NULL, NULL);
+}
+
 
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
@@ -1007,19 +1058,23 @@
 	/* color mode */
 	switch (fh->fmt->fourcc) {
 	case V4L2_PIX_FMT_GREY:
-		fh->mode.color = COLOR_Y8;
+		fh->mode.color &= ~MASK_COLOR;
+		fh->mode.color |= COLOR_Y8;
 		break;
 	case V4L2_PIX_FMT_JPEG:
-		fh->mode.color = COLOR_JPG |
-			(fh->dev->jc[fh->channel].quality << 8);
+		fh->mode.color &= ~MASK_COLOR;
+		fh->mode.color |= COLOR_JPG;
+		fh->mode.color |= (fh->dev->jc[fh->channel].quality << 8);
 		break;
 	case V4L2_PIX_FMT_YUV422P:
-		fh->mode.color = COLOR_YUVPL;
+		fh->mode.color &= ~MASK_COLOR;
+		fh->mode.color |= COLOR_YUVPL;
 		break;
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
 	default:
-		fh->mode.color = COLOR_YUVPK;
+		fh->mode.color &= ~MASK_COLOR;
+		fh->mode.color |= COLOR_YUVPK;
 		break;
 	}
 	ret = 0;
@@ -1186,8 +1241,12 @@
 	dprintk(2, "mode contrast %x\n", mode->contrast);
 
 	/* if JPEG, set the quality */
-	if ((mode->color & MASK_COLOR) == COLOR_JPG)
-		mode->color = (dev->jc[chn].quality << 8) | COLOR_JPG;
+	if ((mode->color & MASK_COLOR) == COLOR_JPG) {
+		mode->color &= ~MASK_COLOR;
+		mode->color |= COLOR_JPG;
+		mode->color &= ~MASK_JPG_QUALITY;
+		mode->color |= (dev->jc[chn].quality << 8);
+	}
 
 	/* save the mode */
 	dev->mode[chn] = *mode;
@@ -1296,7 +1355,7 @@
 	new_mode = &fh->mode;
 	old_mode = &fh->dev->mode[chn];
 
-	if (new_mode->color != old_mode->color)
+	if ((new_mode->color & MASK_COLOR) != (old_mode->color & MASK_COLOR))
 		new_mode->restart = 1;
 	else if (new_mode->scale != old_mode->scale)
 		new_mode->restart = 1;
@@ -1354,6 +1413,7 @@
 	int ret = 0;
 
 	mutex_lock(&q->vb_lock);
+
 	if (videobuf_queue_is_busy(q)) {
 		dprintk(1, "queue busy\n");
 		ret = -EBUSY;
@@ -1366,7 +1426,6 @@
 		goto out_s_std;
 	}
 	mode = &fh->mode;
-
 	if (*i & V4L2_STD_NTSC) {
 		dprintk(4, "vidioc_s_std NTSC\n");
 		mode->format = FORMAT_NTSC;
@@ -1409,7 +1468,16 @@
 			inp->status =  (status & 0x01) ? 0
 				: V4L2_IN_ST_NO_SIGNAL;
 	}
-	strlcpy(inp->name, "Camera", sizeof(inp->name));
+	switch (dev->pid) {
+	case 0x2255:
+	default:
+		strlcpy(inp->name, "Composite", sizeof(inp->name));
+		break;
+	case 0x2257:
+		strlcpy(inp->name, (fh->channel < 2) ? "Composite" : "S-Video",
+			sizeof(inp->name));
+		break;
+	}
 	return 0;
 }
 
@@ -1429,6 +1497,8 @@
 static int vidioc_queryctrl(struct file *file, void *priv,
 			    struct v4l2_queryctrl *qc)
 {
+	struct s2255_fh *fh = priv;
+	struct s2255_dev *dev = fh->dev;
 	switch (qc->id) {
 	case V4L2_CID_BRIGHTNESS:
 		v4l2_ctrl_query_fill(qc, -127, 127, 1, DEF_BRIGHT);
@@ -1442,6 +1512,19 @@
 	case V4L2_CID_HUE:
 		v4l2_ctrl_query_fill(qc, 0, 255, 1, DEF_HUE);
 		break;
+	case V4L2_CID_PRIVATE_COLORFILTER:
+		if (dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
+			return -EINVAL;
+		if ((dev->pid == 0x2257) && (fh->channel > 1))
+			return -EINVAL;
+		strlcpy(qc->name, "Color Filter", sizeof(qc->name));
+		qc->type = V4L2_CTRL_TYPE_MENU;
+		qc->minimum = 0;
+		qc->maximum = 1;
+		qc->step = 1;
+		qc->default_value = 1;
+		qc->flags = 0;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1453,6 +1536,7 @@
 			 struct v4l2_control *ctrl)
 {
 	struct s2255_fh *fh = priv;
+	struct s2255_dev *dev = fh->dev;
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
 		ctrl->value = fh->mode.bright;
@@ -1466,6 +1550,13 @@
 	case V4L2_CID_HUE:
 		ctrl->value = fh->mode.hue;
 		break;
+	case V4L2_CID_PRIVATE_COLORFILTER:
+		if (dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
+			return -EINVAL;
+		if ((dev->pid == 0x2257) && (fh->channel > 1))
+			return -EINVAL;
+		ctrl->value = !((fh->mode.color & MASK_INPUT_TYPE) >> 16);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1495,6 +1586,14 @@
 	case V4L2_CID_SATURATION:
 		mode->saturation = ctrl->value;
 		break;
+	case V4L2_CID_PRIVATE_COLORFILTER:
+		if (dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
+			return -EINVAL;
+		if ((dev->pid == 0x2257) && (fh->channel > 1))
+			return -EINVAL;
+		mode->color &= ~MASK_INPUT_TYPE;
+		mode->color |= ((ctrl->value ? 0 : 1) << 16);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1807,6 +1906,7 @@
 };
 
 static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
+	.vidioc_querymenu = vidioc_querymenu,
 	.vidioc_querycap = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
@@ -2230,6 +2330,8 @@
 	for (j = 0; j < MAX_CHANNELS; j++) {
 		dev->b_acquire[j] = 0;
 		dev->mode[j] = mode_def;
+		if (dev->pid == 0x2257 && j > 1)
+			dev->mode[j].color |= (1 << 16);
 		dev->jc[j].quality = S2255_DEF_JPEG_QUAL;
 		dev->cur_fmt[j] = &formats[0];
 		dev->mode[j].restart = 1;
@@ -2506,7 +2608,7 @@
 		s2255_dev_err(&interface->dev, "out of memory\n");
 		goto error;
 	}
-
+	dev->pid = id->idProduct;
 	dev->fw_data = kzalloc(sizeof(struct s2255_fw), GFP_KERNEL);
 	if (!dev->fw_data)
 		goto error;
@@ -2589,6 +2691,8 @@
 		dev->dsp_fw_ver = *pRel;
 		if (*pRel < S2255_CUR_DSP_FWVER)
 			printk(KERN_INFO "s2255: f2255usb.bin out of date.\n");
+		if (dev->pid == 0x2257 && *pRel < S2255_MIN_DSP_COLORFILTER)
+			printk(KERN_WARNING "s2255: 2257 requires firmware 8 or above.\n");
 	}
 	/* loads v4l specific */
 	s2255_probe_v4l(dev);


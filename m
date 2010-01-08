Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:33899 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab0AHWZZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 17:25:25 -0500
Received: by ywh6 with SMTP id 6so19923670ywh.4
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2010 14:25:24 -0800 (PST)
Message-ID: <4B47B0EB.6000102@gmail.com>
Date: Fri, 08 Jan 2010 17:25:47 -0500
From: TJ <one.timothy.jones@gmail.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: go7007 driver -- which program you use for capture
References: <4B47828B.9050000@gmail.com> <be3a4a1001081217s1bec67c8odb26bb793700242b@mail.gmail.com>
In-Reply-To: <be3a4a1001081217s1bec67c8odb26bb793700242b@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080201070201030801040105"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080201070201030801040105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

jelle, that you?

Here's the patch against go7007 driver in 2.6.32 kernel (run with -p1).

The main purpose of the patch is to include support for ADS Tech DVD Xpress DX2
usb capture card and make it usable with v4l2-ctl utility.

I also did a general clean-up in a few areas and *temporarily* added back in
proprietary go7007 ioctls, so current mythtv users can take advantage of it and
to make the gorecord program from wis-go7007 package now work again.

Also attached is a stripped down version of gorecord from which I removed all
parameter-setting stuff. This version is meant to be used in conjunction with
v4l2-ctl or other means of configuring capture parameters.

I will try to do mythtv patches next so that it starts using standard v4l2 ioctl
calls and we can drop all proprietary stuff in the driver.

Please try it and lemme know if it works for you. I've run into a few Ubuntuers
as well who were trying to get their boards working as well.

-TJ

Jarod Wilson wrote:
> On Fri, Jan 8, 2010 at 2:07 PM, TJ <one.timothy.jones@gmail.com> wrote:
>> Pete and anybody else out there with go7007 devices, what do you use for capture?
>>
>> Without GO7007 ioctls, I was only able to get vlc to capture in MJPEG format.
> 
> Never actually used one myself, but MythTV has support for at least
> the Plextor ConvertX go7007-based devices.
> 

--------------080201070201030801040105
Content-Type: text/plain;
 name="go7007-dx2-prop-ioctl.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="go7007-dx2-prop-ioctl.diff"

diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/Kconfig linux-2.6.32-gentoo_DX2/drivers/staging/go7007/Kconfig
--- linux-2.6.32-gentoo/drivers/staging/go7007/Kconfig	2010-01-08 16:20:20.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/Kconfig	2010-01-08 10:24:34.000000000 -0500
@@ -77,6 +77,16 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called wis-tw9903
 
+config VIDEO_GO7007_TW9906
+	tristate "TW9906 subdev support"
+	depends on VIDEO_GO7007
+	default N
+	---help---
+	  This is a video4linux driver for the TW9906 sub-device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wis-tw9906
+
 config VIDEO_GO7007_UDA1342
 	tristate "UDA1342 subdev support"
 	depends on VIDEO_GO7007
diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/go7007-driver.c linux-2.6.32-gentoo_DX2/drivers/staging/go7007/go7007-driver.c
--- linux-2.6.32-gentoo/drivers/staging/go7007/go7007-driver.c	2010-01-08 16:20:20.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/go7007-driver.c	2010-01-08 10:24:34.000000000 -0500
@@ -170,6 +171,17 @@
 		/* Set GPIO pin 0 to be an output (audio clock control) */
 		go7007_write_addr(go, 0x3c82, 0x0001);
 		go7007_write_addr(go, 0x3c80, 0x00fe);
+		break;
+	case GO7007_BOARDID_ADS_USBAV_709:
+		/* GPIO pin 0: audio clock control */
+		/*      pin 2: TW9906 reset */
+		/*      pin 3: capture LED */
+		go7007_write_addr(go, 0x3c82, 0x000d);
+		go7007_write_addr(go, 0x3c80, 0x00f2);
+		break;
+	default:
+		/* No special setup */
+		break;
 	}
 	return 0;
 }
@@ -212,6 +224,9 @@
 	case I2C_DRIVERID_WIS_TW9903:
 		modname = "wis-tw9903";
 		break;
+	case I2C_DRIVERID_WIS_TW9906:
+		modname = "wis-tw9906";
+		break;
 	case I2C_DRIVERID_WIS_TW2804:
 		modname = "wis-tw2804";
 		break;
@@ -269,6 +284,12 @@
 		go->i2c_adapter_online = 1;
 	}
 	if (go->i2c_adapter_online) {
+		if (go->board_id == GO7007_BOARDID_ADS_USBAV_709) {
+			/* Reset the TW9906 */
+			go7007_write_addr(go, 0x3c82, 0x0009);
+			msleep(50);
+			go7007_write_addr(go, 0x3c82, 0x000d);
+		}
 		for (i = 0; i < go->board_info->num_i2c_devs; ++i)
 			init_i2c_module(&go->i2c_adapter,
 					go->board_info->i2c_devs[i].type,
diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/go7007-usb.c linux-2.6.32-gentoo_DX2/drivers/staging/go7007/go7007-usb.c
--- linux-2.6.32-gentoo/drivers/staging/go7007/go7007-usb.c	2010-01-08 16:20:20.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/go7007-usb.c	2010-01-08 10:24:34.000000000 -0500
@@ -444,6 +444,44 @@
 	},
 };
 
+static struct go7007_usb_board board_ads_usbav_709 = {
+	.flags		= GO7007_USB_EZUSB,
+	.main_info	= {
+		.firmware	 = "go7007tv.bin",
+		.flags		 = GO7007_BOARD_HAS_AUDIO |
+					GO7007_BOARD_USE_ONBOARD_I2C,
+		.audio_flags	 = GO7007_AUDIO_I2S_MODE_1 |
+					GO7007_AUDIO_I2S_MASTER |
+					GO7007_AUDIO_WORD_16,
+		.audio_rate	 = 48000,
+		.audio_bclk_div	 = 8,
+		.audio_main_div	 = 2,
+		.hpi_buffer_cap  = 7,
+		.sensor_flags	 = GO7007_SENSOR_656 |
+					GO7007_SENSOR_TV |
+					GO7007_SENSOR_VBI,
+		.num_i2c_devs	 = 1,
+		.i2c_devs	 = {
+			{
+				.type	= "wis_tw9906",
+				.id	= I2C_DRIVERID_WIS_TW9906,
+				.addr	= 0x44,
+			},
+		},
+		.num_inputs	 = 2,
+		.inputs 	 = {
+			{
+				.video_input	= 0,
+				.name		= "Composite",
+			},
+			{
+				.video_input	= 10,
+				.name		= "S-Video",
+			},
+		},
+	},
+};
+
 static struct usb_device_id go7007_usb_id_table[] = {
 	{
 		.match_flags	= USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION |
@@ -545,6 +583,14 @@
 		.bcdDevice_hi	= 0x1,
 		.driver_info	= (kernel_ulong_t)GO7007_BOARDID_SENSORAY_2250,
 	},
+	{
+		.match_flags	= USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION,
+		.idVendor	= 0x06e1,  /* Vendor ID of ADS Technologies */
+		.idProduct	= 0x0709,  /* Product ID of DVD Xpress DX2 */
+		.bcdDevice_lo	= 0x204,
+		.bcdDevice_hi	= 0x204,
+		.driver_info	= (kernel_ulong_t)GO7007_BOARDID_ADS_USBAV_709,
+	},
 	{ }					/* Terminating entry */
 };
 
@@ -1023,6 +1069,10 @@
 		name = "Sensoray 2250/2251";
 		board = &board_sensoray_2250;
 		break;
+	case GO7007_BOARDID_ADS_USBAV_709:
+		name = "ADS Tech DVD Xpress DX2";
+		board = &board_ads_usbav_709;
+		break;
 	default:
 		printk(KERN_ERR "go7007-usb: unknown board ID %d!\n",
 				(unsigned int)id->driver_info);
diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/go7007-v4l2.c linux-2.6.32-gentoo_DX2/drivers/staging/go7007/go7007-v4l2.c
--- linux-2.6.32-gentoo/drivers/staging/go7007/go7007-v4l2.c	2010-01-08 16:20:20.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/go7007-v4l2.c	2010-01-08 16:50:34.000000000 -0500
@@ -43,9 +43,39 @@
 #define	V4L2_MPEG_STREAM_TYPE_MPEG_ELEM   6 /* MPEG elementary stream */
 #endif
 #ifndef V4L2_MPEG_VIDEO_ENCODING_MPEG_4
-#define	V4L2_MPEG_VIDEO_ENCODING_MPEG_4   3
+#define V4L2_MPEG_VIDEO_ENCODING_MPEG_4   2
+#endif
+#ifndef V4L2_MPEG_VIDEO_ENCODING_NONE
+#define V4L2_MPEG_VIDEO_ENCODING_NONE     3
 #endif
 
+/* Must be sorted from low to high control ID! */
+static const u32 user_ctrls[] = {
+	V4L2_CID_USER_CLASS,
+	V4L2_CID_BRIGHTNESS,
+	V4L2_CID_CONTRAST,
+	V4L2_CID_SATURATION,
+	V4L2_CID_HUE,
+	0
+};
+
+static const u32 mpeg_ctrls[] = {
+	V4L2_CID_MPEG_CLASS,
+	V4L2_CID_MPEG_STREAM_TYPE,
+	V4L2_CID_MPEG_VIDEO_ENCODING,
+	V4L2_CID_MPEG_VIDEO_ASPECT,
+	V4L2_CID_MPEG_VIDEO_GOP_SIZE,
+	V4L2_CID_MPEG_VIDEO_GOP_CLOSURE,
+	V4L2_CID_MPEG_VIDEO_BITRATE,
+	0
+};
+
+static const u32 *ctrl_classes[] = {
+	user_ctrls,
+	mpeg_ctrls,
+	NULL
+};
+
 static void deactivate_buffer(struct go7007_buffer *gobuf)
 {
 	int i;
@@ -387,23 +417,6 @@
 
 static int mpeg_queryctrl(struct v4l2_queryctrl *ctrl)
 {
-	static const u32 mpeg_ctrls[] = {
-		V4L2_CID_MPEG_CLASS,
-		V4L2_CID_MPEG_STREAM_TYPE,
-		V4L2_CID_MPEG_VIDEO_ENCODING,
-		V4L2_CID_MPEG_VIDEO_ASPECT,
-		V4L2_CID_MPEG_VIDEO_GOP_SIZE,
-		V4L2_CID_MPEG_VIDEO_GOP_CLOSURE,
-		V4L2_CID_MPEG_VIDEO_BITRATE,
-		0
-	};
-	static const u32 *ctrl_classes[] = {
-		mpeg_ctrls,
-		NULL
-	};
-
-	ctrl->id = v4l2_ctrl_next(ctrl_classes, ctrl->id);
-
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_CLASS:
 		return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
@@ -415,8 +428,8 @@
 	case V4L2_CID_MPEG_VIDEO_ENCODING:
 		return v4l2_ctrl_query_fill(ctrl,
 				V4L2_MPEG_VIDEO_ENCODING_MPEG_1,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_4, 1,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
+				V4L2_MPEG_VIDEO_ENCODING_NONE, 1,
+				V4L2_MPEG_VIDEO_ENCODING_NONE);
 	case V4L2_CID_MPEG_VIDEO_ASPECT:
 		return v4l2_ctrl_query_fill(ctrl,
 				V4L2_MPEG_VIDEO_ASPECT_1x1,
@@ -556,6 +570,9 @@
 		case GO7007_FORMAT_MPEG4:
 			ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_4;
 			break;
+		case GO7007_FORMAT_MJPEG:
+			ctrl->value = V4L2_MPEG_VIDEO_ENCODING_NONE;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -858,7 +875,6 @@
 	return retval;
 }
 
-
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
 	struct go7007_file *gofh = priv;
@@ -977,11 +993,61 @@
 	if (!go->i2c_adapter_online)
 		return -EIO;
 
+	query->id = v4l2_ctrl_next(ctrl_classes, query->id);
+
 	i2c_clients_command(&go->i2c_adapter, VIDIOC_QUERYCTRL, query);
 
 	return (!query->name[0]) ? mpeg_queryctrl(query) : 0;
 }
 
+const char **go7007_ctrl_get_menu(void *priv, u32 id)
+{
+    static const char *mpeg_stream_type[] = {
+	"",
+	"",
+	"",
+	"MPEG-2 DVD-compatible Stream",
+	"",
+	"",
+	"MPEG-2 Elementary Stream",
+	NULL
+    };
+    static const char *mpeg_video_encoding[] = {
+	"MPEG-1",
+	"MPEG-2",
+	"MPEG-4",
+	"None (Motion-JPEG)",
+        NULL
+    };
+    static const char *mpeg_video_aspect[] = {
+	"1x1",
+	"4x3",
+	"16x9",
+        NULL
+    };
+
+    switch (id) {
+        case V4L2_CID_MPEG_VIDEO_ENCODING:
+	    return mpeg_video_encoding;
+        case V4L2_CID_MPEG_VIDEO_ASPECT:
+	    return mpeg_video_aspect;
+        case V4L2_CID_MPEG_STREAM_TYPE:
+	    return mpeg_stream_type;
+        default:
+	    return NULL;
+    }
+}
+
+int vidioc_querymenu(struct file *file, void *priv, struct v4l2_querymenu *qmenu)
+{
+    struct v4l2_queryctrl qctrl;
+
+    qctrl.id = qmenu->id;
+    vidioc_queryctrl(file, priv, &qctrl);
+    
+    return v4l2_ctrl_query_menu(qmenu, &qctrl, go7007_ctrl_get_menu(priv, qmenu->id));
+}
+
 static int vidioc_g_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
@@ -1020,6 +1086,46 @@
 	return 0;
 }
 
+int vidioc_g_ext_ctrls(struct file *file, void *priv, struct v4l2_ext_controls *c)
+{
+	struct v4l2_control ctrl;
+
+	int i;
+	int err = 0;
+
+	for (i = 0; i < c->count; i++) {
+		ctrl.id = c->controls[i].id;
+		ctrl.value = c->controls[i].value;
+		err = vidioc_g_ctrl(file, priv, &ctrl);
+		c->controls[i].value = ctrl.value;
+		if (err) {
+			c->error_idx = i;
+			break;
+		}
+	}
+	return err;
+}
+
+int vidioc_s_ext_ctrls(struct file *file, void *priv, struct v4l2_ext_controls *c)
+{
+	struct v4l2_control ctrl;
+
+	int i;
+	int err = 0;
+
+	for (i = 0; i < c->count; i++) {
+		ctrl.id = c->controls[i].id;
+		ctrl.value = c->controls[i].value;
+		err = vidioc_s_ctrl(file, priv, &ctrl);
+		c->controls[i].value = ctrl.value;
+		if (err) {
+			c->error_idx = i;
+			break;
+		}
+	}
+	return err;
+}
+
 static int vidioc_g_parm(struct file *filp, void *priv,
 		struct v4l2_streamparm *parm)
 {
@@ -1440,7 +1546,13 @@
 	and vidioc_s_ext_ctrls()
  */
 
-#if 0
+static long go7007_prop_ioctl(struct file *file,
+		unsigned int cmd, void *arg)
+{
+	struct go7007 *go = ((struct go7007_file *) file->private_data)->go;
+
+	switch (cmd) {
+#if 1
 	/* Temporary ioctls for controlling compression characteristics */
 	case GO7007IOC_S_BITRATE:
 	{
@@ -1578,10 +1690,9 @@
 			go->gop_header_enable =
 				mpeg->flags & GO7007_MPEG_OMIT_GOP_HEADER
 				? 0 : 1;
-			if (mpeg->flags & GO7007_MPEG_REPEAT_SEQHEADER)
-				go->repeat_seqhead = 1;
-			else
-				go->repeat_seqhead = 0;
+			go->repeat_seqhead =
+				mpeg->flags & GO7007_MPEG_REPEAT_SEQHEADER
+				? 1 : 0;
 			go->dvd_mode = 0;
 		}
 		/* fall-through */
@@ -1661,6 +1772,25 @@
 		return clip_to_modet_map(go, region->region, region->clips);
 	}
 #endif
+	}
+	return -EINVAL;
+}
+
+
+static long go7007_ioctl(struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	struct go7007 *go = ((struct go7007_file *) file->private_data)->go;
+	int retval;
+
+	if (go->status != STATUS_ONLINE)
+		return -EIO;
+
+	retval = video_ioctl2(file, cmd, arg);
+	if (retval < 0)
+		retval = video_usercopy(file, cmd, arg, (v4l2_kioctl)go7007_prop_ioctl);
+        return retval;
+}
 
 static ssize_t go7007_read(struct file *file, char __user *data,
 		size_t count, loff_t *ppos)
Files linux-2.6.32-gentoo/drivers/staging/go7007/go7007-v4l2.o and linux-2.6.32-gentoo_DX2/drivers/staging/go7007/go7007-v4l2.o differ
Files linux-2.6.32-gentoo/drivers/staging/go7007/go7007.ko and linux-2.6.32-gentoo_DX2/drivers/staging/go7007/go7007.ko differ
Files linux-2.6.32-gentoo/drivers/staging/go7007/go7007.o and linux-2.6.32-gentoo_DX2/drivers/staging/go7007/go7007.o differ
diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/s2250-board.c linux-2.6.32-gentoo_DX2/drivers/staging/go7007/s2250-board.c
--- linux-2.6.32-gentoo/drivers/staging/go7007/s2250-board.c	2010-01-08 16:20:20.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/s2250-board.c	2010-01-08 10:24:34.000000000 -0500
@@ -357,32 +357,18 @@
 	case VIDIOC_QUERYCTRL:
 	{
 		struct v4l2_queryctrl *ctrl = arg;
-		static const u32 user_ctrls[] = {
-			V4L2_CID_BRIGHTNESS,
-			V4L2_CID_CONTRAST,
-			V4L2_CID_SATURATION,
-			V4L2_CID_HUE,
-			0
-		};
-		static const u32 *ctrl_classes[] = {
-			user_ctrls,
-			NULL
-		};
 
-		ctrl->id = v4l2_ctrl_next(ctrl_classes, ctrl->id);
 		switch (ctrl->id) {
+		case V4L2_CID_USER_CLASS:
+			return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
 		case V4L2_CID_BRIGHTNESS:
-			v4l2_ctrl_query_fill(ctrl, 0, 100, 1, 50);
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 100, 1, 50);
 		case V4L2_CID_CONTRAST:
-			v4l2_ctrl_query_fill(ctrl, 0, 100, 1, 50);
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 100, 1, 50);
 		case V4L2_CID_SATURATION:
-			v4l2_ctrl_query_fill(ctrl, 0, 100, 1, 50);
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 100, 1, 50);
 		case V4L2_CID_HUE:
-			v4l2_ctrl_query_fill(ctrl, -50, 50, 1, 0);
-			break;
+			return v4l2_ctrl_query_fill(ctrl, -50, 50, 1, 0);
 		default:
 			ctrl->name[0] = '\0';
 			return -EINVAL;
diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/wis-i2c.h linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-i2c.h
--- linux-2.6.32-gentoo/drivers/staging/go7007/wis-i2c.h	2010-01-08 16:20:20.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-i2c.h	2010-01-08 10:24:34.000000000 -0500
@@ -24,6 +24,7 @@
 #define	I2C_DRIVERID_WIS_OV7640		0xf0f5
 #define	I2C_DRIVERID_WIS_TW2804		0xf0f6
 #define	I2C_DRIVERID_S2250		0xf0f7
+#define	I2C_DRIVERID_WIS_TW9906		0xf0f9
 
 /* Flag to indicate that the client needs to be accessed with SCCB semantics */
 /* We re-use the I2C_M_TEN value so the flag passes through the masks in the
diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/wis-saa7113.c linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-saa7113.c
--- linux-2.6.32-gentoo/drivers/staging/go7007/wis-saa7113.c	2010-01-08 16:20:20.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-saa7113.c	2010-01-08 10:24:34.000000000 -0500
@@ -152,42 +152,19 @@
 		struct v4l2_queryctrl *ctrl = arg;
 
 		switch (ctrl->id) {
+		case V4L2_CID_USER_CLASS:
+			return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
 		case V4L2_CID_BRIGHTNESS:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Brightness", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 255, 1, 128);
 		case V4L2_CID_CONTRAST:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Contrast", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 127;
-			ctrl->step = 1;
-			ctrl->default_value = 71;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 127, 1, 71);
 		case V4L2_CID_SATURATION:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Saturation", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 127;
-			ctrl->step = 1;
-			ctrl->default_value = 64;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 127, 1, 64);
 		case V4L2_CID_HUE:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Hue", sizeof(ctrl->name));
-			ctrl->minimum = -128;
-			ctrl->maximum = 127;
-			ctrl->step = 1;
-			ctrl->default_value = 0;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, -128, 127, 1, 0);
+		default:
+			ctrl->name[0] = '\0';
+			return -EINVAL;
 		}
 		break;
 	}
diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/wis-saa7115.c linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-saa7115.c
--- linux-2.6.32-gentoo/drivers/staging/go7007/wis-saa7115.c	2010-01-08 16:20:20.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-saa7115.c	2010-01-08 10:24:34.000000000 -0500
@@ -285,42 +285,19 @@
 		struct v4l2_queryctrl *ctrl = arg;
 
 		switch (ctrl->id) {
+		case V4L2_CID_USER_CLASS:
+			return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
 		case V4L2_CID_BRIGHTNESS:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Brightness", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 255, 1, 128);
 		case V4L2_CID_CONTRAST:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Contrast", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 127;
-			ctrl->step = 1;
-			ctrl->default_value = 64;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 127, 1, 64);
 		case V4L2_CID_SATURATION:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Saturation", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 127;
-			ctrl->step = 1;
-			ctrl->default_value = 64;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 127, 1, 64);
 		case V4L2_CID_HUE:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Hue", sizeof(ctrl->name));
-			ctrl->minimum = -128;
-			ctrl->maximum = 127;
-			ctrl->step = 1;
-			ctrl->default_value = 0;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, -128, 127, 1, 0);
+		default:
+			ctrl->name[0] = '\0';
+			return -EINVAL;
 		}
 		break;
 	}
diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/wis-tw2804.c linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-tw2804.c
--- linux-2.6.32-gentoo/drivers/staging/go7007/wis-tw2804.c	2010-01-08 16:20:20.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-tw2804.c	2010-01-08 10:24:34.000000000 -0500
@@ -182,42 +182,19 @@
 		struct v4l2_queryctrl *ctrl = arg;
 
 		switch (ctrl->id) {
+		case V4L2_CID_USER_CLASS:
+			return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
 		case V4L2_CID_BRIGHTNESS:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Brightness", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 255, 1, 128);
 		case V4L2_CID_CONTRAST:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Contrast", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 255, 1, 128);
 		case V4L2_CID_SATURATION:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Saturation", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 255, 1, 128);
 		case V4L2_CID_HUE:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Hue", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, 0, 255, 1, 128);
+		default:
+			ctrl->name[0] = '\0';
+			return -EINVAL;
 		}
 		break;
 	}
diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/wis-tw9903.c linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-tw9903.c
--- linux-2.6.32-gentoo/drivers/staging/go7007/wis-tw9903.c	2010-01-08 16:20:20.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-tw9903.c	2010-01-08 10:24:34.000000000 -0500
@@ -152,45 +152,23 @@
 		struct v4l2_queryctrl *ctrl = arg;
 
 		switch (ctrl->id) {
+		case V4L2_CID_USER_CLASS:
+			return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
 		case V4L2_CID_BRIGHTNESS:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Brightness", sizeof(ctrl->name));
-			ctrl->minimum = -128;
-			ctrl->maximum = 127;
-			ctrl->step = 1;
-			ctrl->default_value = 0x00;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, -128, 127, 1, 0x0);
 		case V4L2_CID_CONTRAST:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Contrast", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 0x60;
-			ctrl->flags = 0;
-			break;
-#if 0
-		/* I don't understand how the Chroma Gain registers work... */
+			return v4l2_ctrl_query_fill(ctrl, 0, 255, 1, 0x60);
 		case V4L2_CID_SATURATION:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Saturation", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 127;
-			ctrl->step = 1;
-			ctrl->default_value = 64;
-			ctrl->flags = 0;
-			break;
-#endif
+		{
+			int ret = v4l2_ctrl_query_fill(ctrl, 0, 127, 1, 64);
+			ctrl->flags |= V4L2_CTRL_FLAG_DISABLED; // I don't understand how the Chroma Gain registers work...
+			return ret;
+		}
 		case V4L2_CID_HUE:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Hue", sizeof(ctrl->name));
-			ctrl->minimum = -128;
-			ctrl->maximum = 127;
-			ctrl->step = 1;
-			ctrl->default_value = 0;
-			ctrl->flags = 0;
-			break;
+			return v4l2_ctrl_query_fill(ctrl, -128, 127, 1, 0);
+		default:
+			ctrl->name[0] = '\0';
+			return -EINVAL;
 		}
 		break;
 	}
diff -U 3 -H -d -I' ' -x' .*' -r -N -- linux-2.6.32-gentoo/drivers/staging/go7007/wis-tw9906.c linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-tw9906.c
--- linux-2.6.32-gentoo/drivers/staging/go7007/wis-tw9906.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.32-gentoo_DX2/drivers/staging/go7007/wis-tw9906.c	2010-01-08 10:24:34.000000000 -0500
@@ -0,0 +1,261 @@
+/*
+ * Copyright (C) 2005-2006 Micronas USA Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (Version 2) as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-common.h>
+
+#include "wis-i2c.h"
+
+struct wis_tw9906 {
+	int norm;
+	int brightness;
+	int contrast;
+	int hue;
+};
+
+static u8 initial_registers[] =
+{
+	0x02, 0x40, /* input 0, composite */
+	0x03, 0xa2, /* correct digital format */
+	0x05, 0x81, /* or 0x01 for PAL */
+	0x07, 0x02, /* window */
+	0x08, 0x14, /* window */
+	0x09, 0xf0, /* window */
+	0x0a, 0x10, /* window */
+	0x0b, 0xd0, /* window */
+	0x0d, 0x00, /* scaling */
+	0x0e, 0x11, /* scaling */
+	0x0f, 0x00, /* scaling */
+	0x10, 0x00, /* brightness */
+	0x11, 0x60, /* contrast */
+	0x12, 0x11, /* sharpness */
+	0x13, 0x7e, /* U gain */
+	0x14, 0x7e, /* V gain */
+	0x15, 0x00, /* hue */
+	0x19, 0x57, /* vbi */
+	0x1a, 0x0f,
+	0x1b, 0x40,
+	0x29, 0x03,
+	0x55, 0x00,
+	0x6b, 0x26,
+	0x6c, 0x36,
+	0x6d, 0xf0,
+	0x6e, 0x41,
+	0x6f, 0x13,
+	0xad, 0x70,
+	0x00, 0x00, /* Terminator (reg 0x00 is read-only) */
+};
+
+static int write_reg(struct i2c_client *client, u8 reg, u8 value)
+{
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+static int write_regs(struct i2c_client *client, u8 *regs)
+{
+	int i;
+
+	for (i = 0; regs[i] != 0x00; i += 2)
+		if (i2c_smbus_write_byte_data(client, regs[i], regs[i + 1]) < 0)
+			return -1;
+	return 0;
+}
+
+static int wis_tw9906_command(struct i2c_client *client,
+				unsigned int cmd, void *arg)
+{
+	struct wis_tw9906 *dec = i2c_get_clientdata(client);
+
+	switch (cmd) {
+	case VIDIOC_S_INPUT:
+	{
+		int *input = arg;
+
+		i2c_smbus_write_byte_data(client, 0x02, 0x40 | (*input << 1));
+		break;
+	}
+	case VIDIOC_S_STD:
+	{
+		v4l2_std_id *input = arg;
+		u8 regs[] = {
+			0x05, *input & V4L2_STD_NTSC ? 0x81 : 0x01,
+			0x07, *input & V4L2_STD_NTSC ? 0x02 : 0x12,
+			0x08, *input & V4L2_STD_NTSC ? 0x14 : 0x18,
+			0x09, *input & V4L2_STD_NTSC ? 0xf0 : 0x20,
+			0,	0,
+		};
+		write_regs(client, regs);
+		dec->norm = *input;
+		break;
+	}
+	case VIDIOC_QUERYCTRL:
+	{
+		struct v4l2_queryctrl *ctrl = arg;
+
+		switch (ctrl->id) {
+		case V4L2_CID_USER_CLASS:
+			return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
+		case V4L2_CID_BRIGHTNESS:
+			return v4l2_ctrl_query_fill(ctrl, -128, 127, 1, 0x0);
+		case V4L2_CID_CONTRAST:
+			return v4l2_ctrl_query_fill(ctrl, 0, 255, 1, 0x60);
+		case V4L2_CID_SATURATION:
+		{
+			int ret = v4l2_ctrl_query_fill(ctrl, 0, 127, 1, 64);
+			ctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
+			return ret;
+		}
+		case V4L2_CID_HUE:
+			return v4l2_ctrl_query_fill(ctrl, -128, 127, 1, 0);
+		default:
+			ctrl->name[0] = '\0';
+			return -EINVAL;
+		}
+		break;
+	}
+	case VIDIOC_S_CTRL:
+	{
+		struct v4l2_control *ctrl = arg;
+
+		switch (ctrl->id) {
+		case V4L2_CID_BRIGHTNESS:
+			if (ctrl->value > 127)
+				dec->brightness = 127;
+			else if (ctrl->value < -128)
+				dec->brightness = -128;
+			else
+				dec->brightness = ctrl->value;
+			write_reg(client, 0x10, dec->brightness);
+			break;
+		case V4L2_CID_CONTRAST:
+			if (ctrl->value > 255)
+				dec->contrast = 255;
+			else if (ctrl->value < 0)
+				dec->contrast = 0;
+			else
+				dec->contrast = ctrl->value;
+			write_reg(client, 0x11, dec->contrast);
+			break;
+		case V4L2_CID_HUE:
+			if (ctrl->value > 127)
+				dec->hue = 127;
+			else if (ctrl->value < -128)
+				dec->hue = -128;
+			else
+				dec->hue = ctrl->value;
+			write_reg(client, 0x15, dec->hue);
+			break;
+		}
+		break;
+	}
+	case VIDIOC_G_CTRL:
+	{
+		struct v4l2_control *ctrl = arg;
+
+		switch (ctrl->id) {
+		case V4L2_CID_BRIGHTNESS:
+			ctrl->value = dec->brightness;
+			break;
+		case V4L2_CID_CONTRAST:
+			ctrl->value = dec->contrast;
+			break;
+		case V4L2_CID_HUE:
+			ctrl->value = dec->hue;
+			break;
+		}
+		break;
+	}
+	default:
+		break;
+	}
+	return 0;
+}
+
+static int wis_tw9906_probe(struct i2c_client *client,
+			    const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	struct wis_tw9906 *dec;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	dec = kmalloc(sizeof(struct wis_tw9906), GFP_KERNEL);
+	if (dec == NULL)
+		return -ENOMEM;
+
+	dec->norm = V4L2_STD_NTSC;
+	dec->brightness = 0;
+	dec->contrast = 0x60;
+	dec->hue = 0;
+	i2c_set_clientdata(client, dec);
+
+	printk(KERN_DEBUG
+		"wis-tw9906: initializing TW9906 at address %d on %s\n",
+		client->addr, adapter->name);
+
+	if (write_regs(client, initial_registers) < 0) {
+		printk(KERN_ERR "wis-tw9906: error initializing TW9906\n");
+		kfree(dec);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int wis_tw9906_remove(struct i2c_client *client)
+{
+
+	struct wis_tw9906 *dec = i2c_get_clientdata(client);
+
+	i2c_set_clientdata(client, NULL);
+	kfree(dec);
+	return 0;
+}
+
+static struct i2c_device_id wis_tw9906_id[] = {
+	{ "wis_tw9906", 0 },
+	{ }
+};
+
+static struct i2c_driver wis_tw9906_driver = {
+	.driver = {
+		.name	= "WIS TW9906 I2C driver",
+	},
+	.probe		= wis_tw9906_probe,
+	.remove		= wis_tw9906_remove,
+	.command	= wis_tw9906_command,
+	.id_table	= wis_tw9906_id,
+};
+
+static int __init wis_tw9906_init(void)
+{
+	return i2c_add_driver(&wis_tw9906_driver);
+}
+
+static void __exit wis_tw9906_cleanup(void)
+{
+	i2c_del_driver(&wis_tw9906_driver);
+}
+
+module_init(wis_tw9906_init);
+module_exit(wis_tw9906_cleanup);
+
+MODULE_LICENSE("GPL v2");

--------------080201070201030801040105
Content-Type: text/x-c;
 name="gorecord.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gorecord.c"

/*
 * Copyright (C) 2005-2006 Micronas USA Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and the associated README documentation file (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
/* May 27, 2005 
 * A-V Sync by Timo Pylvanainen, tpyl+nosa at iki <dot> fi  */
/* July 23, 2006
 * Playable AVI while recording 
 * by Francois Beerten, avrecord dot 10 dot fb at spamgourmet dot com */

#include <sys/types.h>
#include <sys/stat.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <dirent.h>
#include <linux/videodev.h>
#include <linux/soundcard.h>
#include <errno.h>
#include <math.h>

#include "go7007.h"

/* Note: little-endian */
#define PUT_16(p,v) ((p)[0]=(v)&0xff,(p)[1]=((v)>>8)&0xff)
#define PUT_32(p,v) ((p)[0]=(v)&0xff,(p)[1]=((v)>>8)&0xff,(p)[2]=((v)>>16)&0xff,(p)[3]=((v)>>24)&0xff)
#define FOURCC(c) (((c)[3]<<24)|((c)[2]<<16)|((c)[1]<<8)|(c)[0])

#define MAX_BUFFERS	32
#define AUDIO_BUF_LEN	(256*1024)
#define MIN_SYNC_STEP 16

#ifndef V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC
    #define V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC 2
#endif

char *vdevice = NULL, *adevice = NULL, *avibase = NULL;
char avifile[PATH_MAX];
int vidfd = -1, audfd = -1, avifd = -1, idxfd = -1;
int buf_count = 0;
unsigned long long int avi_frame_count = 0;
unsigned long long int total_frames = 0;
int total_av_corr = 0;
double av_offset = 0;
double fps=29.97;
int duration = -1;
unsigned int sequence;
int frame_limit = -1;
int max_frame_length = 0;
unsigned long long int max_file_size = 0;
unsigned long long int vbytes = 0, abytes = 0;
unsigned char audio_buffer[AUDIO_BUF_LEN];
unsigned char audio_sync_buffer[AUDIO_BUF_LEN];
int audio_len = 0;
int nowrite = 0;
int probe = 0;
int verbose = 0;
int input = 0;
int width = 0, height = 0;
struct v4l2_fract frameperiod;
enum {
	FMT_MJPEG,
	FMT_MPEG1,
	FMT_MPEG2,
	FMT_MPEG4,
} format = FMT_MPEG4;
int interrupted = 0;
unsigned char *buffers[MAX_BUFFERS];

void usage(char *progname)
{
	printf(
"gorecord captures video and audio from a WIS GO7007 video encoder and\n"
"writes it to an AVI file.  Capturing continues until the specified frame\n"
"limit has been reached or the maximum AVI file size is exceeded.\n\n"
"Usage: gorecord [OPTION]... -frames <n> [<AVI file name>]\n\n"
""
"Control options:\n"
"  -verbose                      Verbosely describe all operations\n"
"  -duration <n>                 Stop capturing after <n> seconds\n"
"  -frames <n>                   Stop capturing after <n> video frames\n"
"  -maxsize <n>                  Stop capturing after <n> Megabytes (2^20 bytes)\n"
"  -noaudio                      Do not capture audio; only video\n"
"  -nowrite                      Do not write captured video/audio to a file\n"
"  -vdevice <V4L2 device path>   Explicitly specify the V4L2 device to use\n"
"  -adevice <OSS device path>    Explicitly specify the OSS device to use\n"
""
"Other Options:\n"
"  Use \"%%d\" in the filename in conjunction with the -maxsize option to\n"
"  create a new file every <n> Megabytes. eg. gorecord filename-\"%%d\".avi\n");
	exit(1);
}

void find_devices(int noaudio)
{
	struct stat si;
	struct dirent *ent;
	int i, minor = -1;
	DIR *dir;
	FILE *file;
	char line[128], sympath[PATH_MAX], canonpath[PATH_MAX], gopath[PATH_MAX];
	static char vdev[PATH_MAX], adev[PATH_MAX];

	/* Make sure sysfs is mounted and the driver is loaded */
	if (stat("/sys/bus/usb/drivers", &si) < 0) {
		fprintf(stderr, "Unable to read /sys/bus/usb/drivers: %s\n",
				strerror(errno));
		fprintf(stderr, "Is sysfs mounted on /sys?\n");
		exit(1);
	}
	if (stat("/sys/bus/usb/drivers/go7007", &si) < 0) {
		fprintf(stderr, "Unable to read /sys/bus/usb/drivers/go7007: "
				"%s\n", strerror(errno));
		fprintf(stderr, "Is the go7007-usb kernel module loaded?\n");
		exit(1);
	}

	/* Find a Video4Linux device associated with the go7007 driver */
	for (i = 0; i < 20; ++i) {
		sprintf(sympath,
			"/sys/class/video4linux/video%d/device/driver", i);
		if (realpath(sympath, canonpath) == NULL)
			continue;
		if (!strcmp(strrchr(canonpath, '/') + 1, "go7007"))
			break;
	}
	sprintf(sympath, "/sys/class/video4linux/video%d/device", i);
	if (i == 20 || realpath(sympath, gopath) == NULL) {
		fprintf(stderr,
			"Driver loaded but no GO7007 devices found.\n");
		fprintf(stderr, "Is the device connected properly?\n");
		exit(1);
	}
	sprintf(vdev, "/dev/video%d", i);
	vdevice = vdev;
	fprintf(stderr, "%s is a GO7007 device at USB address %s\n",
			vdev, strrchr(gopath, '/') + 1);

	if (noaudio)
		return;

	/* Find the ALSA device associated with this USB address */
	fprintf(stderr, "Attempting to determine audio device...");
	for (i = 0; i < 20; ++i) {
		sprintf(sympath, "/sys/class/sound/pcmC%dD0c/device/device", i);
		if (realpath(sympath, canonpath) == NULL)
			continue;
		if (!strcmp(gopath, canonpath))
			break;
	}
	if (i == 20) {
		fprintf(stderr,
			"\nUnable to find associated ALSA device node\n");
		exit(1);
	}

	/* Find the OSS emulation minor number for this ALSA device */
	file = fopen("/proc/asound/oss/devices", "r");
	if (file == NULL) {
		fprintf(stderr,
			"\nUnable to open /proc/asound/oss/devices: %s\n",
			strerror(errno));
		fprintf(stderr, "Is the snd_pcm_oss module loaded?\n");
		exit(1);
	}
	while ((fgets(line, sizeof(line), file)) != NULL) {
		unsigned int n;
		int m;
		char *c;

		if ((c = strrchr(line, ':')) == NULL ||
				strcmp(c, ": digital audio\n") ||
				sscanf(line, "%d: [%u-%*u]:", &m, &n) != 2)
			continue;
		if (n == i) {
			minor = m;
			break;
		}
	}
	fclose(file);
	if (minor < 0) {
		fprintf(stderr, "\nUnable to find emulated OSS device node\n");
		exit(1);
	}
	dir = opendir("/sys/class/sound");
	if (dir == NULL) {
		fprintf(stderr, "\nUnable to read /sys/class/sound: %s\n",
				strerror(errno));
		exit(1);
	}
	while ((ent = readdir(dir)) != NULL) {
		int m = -1;

		if (strncmp(ent->d_name, "dsp", 3))
			continue;
		sprintf(adev, "/sys/class/sound/%s/dev", ent->d_name);
		file = fopen(adev, "r");
		if (file == NULL)
			continue;
		if ((fgets(line, sizeof(line), file)) != NULL)
			sscanf(line, "%*d:%d\n", &m);
		fclose(file);
		if (m == minor)
			break;
	}
	if (ent == NULL) {
		fprintf(stderr, "\nUnable to find emulated OSS device.\n");
		exit(1);
	}
	sprintf(adev, "/dev/%s", ent->d_name);
	closedir(dir);
	adevice = adev;
	fprintf(stderr, "using audio device %s\n", adev);
}

void parse_opts(int argc, char **argv)
{
	int i, noaudio = 0;

	for (i = 1; i < argc && argv[i][0] == '-'; ++i) {
		if (!strcmp(argv[i], "-help"))
			usage(argv[0]);
		else if (!strcmp(argv[i], "-nosound")) {
			noaudio = 1;
		} else if (!strcmp(argv[i], "-noaudio")) {
			noaudio = 1;
		} else if (!strcmp(argv[i], "-verbose")) {
			verbose = 1;
		} else if (!strcmp(argv[i], "-nowrite")) {
			nowrite = 1;
		} else if (i + 1 >= argc) {
			usage(argv[0]);
	/* options that take an argument go below here */
		} else if (!strcmp(argv[i], "-vdevice")) {
			vdevice = argv[++i];
		} else if (!strcmp(argv[i], "-adevice")) {
			adevice = argv[++i];
		} else if (!strcmp(argv[i], "-frames")) {
			frame_limit = atoi(argv[++i]);
		} else if (!strcmp(argv[i], "-duration")) {
			duration = atoi(argv[++i]);
		} else if (!strcmp(argv[i], "-maxsize")) {
			max_file_size = atoi(argv[++i]) *1024*1024;
		} else {
			usage(argv[0]);
		}
	}
	if (nowrite) {
		if (i != argc)
			usage(argv[0]);
	} else {
		if (i == argc) {
			nowrite = 1;
			verbose = 1;
			probe = 1;
			avibase = NULL;
		} else if (i + 1 != argc)
			usage(argv[0]);
		else
			avibase = argv[i];
	}
	if (noaudio)
		adevice = NULL;
	if (vdevice != NULL) {
		if (adevice == NULL && !noaudio) {
			fprintf(stderr, "If -vdevice is used, please also "
				"specify an audio device with -adevice or "
				"use -noaudio.\n");
			exit(1);
		}
	} else {
		if (adevice != NULL) {
			fprintf(stderr, "If -adevice is used, please also "
				"specify a video device with -vdevice.\n");
			exit(1);
		}
		find_devices(noaudio);
	}
}

int add_video_stream_header(unsigned char *hdr)
{
	unsigned int video_fourcc;

	switch (format) {
	case FMT_MJPEG:
		video_fourcc = FOURCC("mjpg");
		break;
	case FMT_MPEG1:
		video_fourcc = FOURCC("mpg1");
		break;
	case FMT_MPEG2:
		video_fourcc = FOURCC("mpg2");
		break;
	case FMT_MPEG4:
		video_fourcc = FOURCC("DX50");
		break;
	default:
		video_fourcc = 0;
		break;
	}

	PUT_32(hdr, FOURCC("LIST"));
	PUT_32(hdr + 4, 12 - 8 + 64 + 48);
	PUT_32(hdr + 8, FOURCC("strl"));
	PUT_32(hdr + 12, FOURCC("strh"));
	PUT_32(hdr + 12 + 4, 64 - 8);
	PUT_32(hdr + 12 + 8, FOURCC("vids"));
	PUT_32(hdr + 12 + 12, video_fourcc);
	PUT_32(hdr + 12 + 28, frameperiod.numerator);
	PUT_32(hdr + 12 + 32, frameperiod.denominator);
	PUT_32(hdr + 12 + 40, avi_frame_count);
	PUT_32(hdr + 12 + 44, max_frame_length);
	PUT_16(hdr + 12 + 60, width);
	PUT_16(hdr + 12 + 62, height);
	PUT_32(hdr + 12 + 64, FOURCC("strf"));
	PUT_32(hdr + 12 + 64 + 4, 48 - 8);
	PUT_32(hdr + 12 + 64 + 8, 48 - 8);
	PUT_32(hdr + 12 + 64 + 12, width);
	PUT_32(hdr + 12 + 64 + 16, height);
	PUT_32(hdr + 12 + 64 + 20, 1);
	PUT_32(hdr + 12 + 64 + 22, 24);
	PUT_32(hdr + 12 + 64 + 24, video_fourcc);
	PUT_32(hdr + 12 + 64 + 28, width * height * 3);
	return 12 + 64 + 48;
}

int add_audio_stream_header(unsigned char *hdr)
{
	PUT_32(hdr, FOURCC("LIST"));
	PUT_32(hdr + 4, 12 - 8 + 64 + 26);
	PUT_32(hdr + 8, FOURCC("strl"));

	PUT_32(hdr + 12, FOURCC("strh"));
	PUT_32(hdr + 12 + 4, 64 - 8);
	PUT_32(hdr + 12 + 8, FOURCC("auds"));
	PUT_32(hdr + 12 + 12, 1);
	PUT_32(hdr + 12 + 28, 4);
	PUT_32(hdr + 12 + 32, 48000 << 2);
	PUT_32(hdr + 12 + 40, abytes >> 2);
	PUT_32(hdr + 12 + 44, 48000 << 1);
	PUT_32(hdr + 12 + 52, 4);

	PUT_32(hdr + 12 + 64, FOURCC("strf"));
	PUT_32(hdr + 12 + 64 + 4, 26 - 8);
	PUT_16(hdr + 12 + 64 + 8, 1);
	PUT_16(hdr + 12 + 64 + 10, 2);
	PUT_32(hdr + 12 + 64 + 12, 48000);
	PUT_32(hdr + 12 + 64 + 16, 48000 << 2);
	PUT_16(hdr + 12 + 64 + 20, 4);
	PUT_16(hdr + 12 + 64 + 22, 16);
	return 12 + 64 + 26;
}

void open_avifile(void)
{
	/* First open the temporary file we'll store the index in */
	idxfd = open(avifile, O_RDWR | O_CREAT | O_TRUNC, 0666);
	if (idxfd < 0) {
		fprintf(stderr, "Unable to open %s: %s\n", avifile,
				strerror(errno));
		exit(1);
	}
	unlink(avifile);
	/* Then open the real AVI destination file */
	avifd = open(avifile, O_RDWR | O_CREAT | O_TRUNC, 0666);
	if (avifd < 0) {
		fprintf(stderr, "Unable to open %s: %s\n", avifile,
				strerror(errno));
		exit(1);
	}

	int movielen, off;
	unsigned char hdr[1024 + 12];

	memset(hdr, 0, sizeof(hdr));
	PUT_32(hdr, FOURCC("RIFF"));
	PUT_32(hdr + 4, lseek(avifd, 0, SEEK_CUR) - 8);
	PUT_32(hdr + 8, FOURCC("AVI "));
	PUT_32(hdr + 12, FOURCC("LIST"));
	PUT_32(hdr + 12 + 8, FOURCC("hdrl"));
	PUT_32(hdr + 12 + 12, FOURCC("avih"));
	PUT_32(hdr + 12 + 12 + 4, 64 - 8);
	/* bizarre math to do microsecond arithmetic in 32-bit ints */
	/* =>   1000000 * frameperiod.numerator / frameperiod.denominator */
	PUT_32(hdr + 12 + 12 + 8, (frameperiod.numerator * 15625 /
						frameperiod.denominator) * 64 +
					((frameperiod.numerator * 15625) %
					 	frameperiod.denominator) * 64 /
					frameperiod.denominator);
	PUT_32(hdr + 12 + 12 + 20, 2320);
	PUT_32(hdr + 12 + 12 + 24, avi_frame_count);
	PUT_32(hdr + 12 + 12 + 32, audfd < 0 ? 1 : 2);
	PUT_32(hdr + 12 + 12 + 36, 128*1024);
	PUT_32(hdr + 12 + 12 + 40, width);
	PUT_32(hdr + 12 + 12 + 44, height);
	off = 64;
	off += add_video_stream_header(hdr + 12 + 12 + off);
	if (audfd >= 0)
		off += add_audio_stream_header(hdr + 12 + 12 + off);
	PUT_32(hdr + 12 + 4, 12 - 8 + off);

	PUT_32(hdr + 12 + 12 + off, FOURCC("JUNK"));
	PUT_32(hdr + 12 + 12 + off + 4, 1024 - 12 - 12 - off - 8);
	PUT_32(hdr + 1024, FOURCC("LIST"));
	PUT_32(hdr + 1024 + 4, movielen - 1024 - 8);
	PUT_32(hdr + 1024 + 8, FOURCC("movi"));
	lseek(avifd, 0, SEEK_SET);
	write(avifd, hdr, 1024 + 12);

	lseek(avifd, 1024 + 12, SEEK_SET);
}

void open_devices(void)
{
	vidfd = open(vdevice, O_RDWR);
	if (vidfd < 0) {
		fprintf(stderr, "Unable to open %s: %s\n", vdevice,
				strerror(errno));
		exit(1);
	}
	if (adevice == NULL)
		return;
	audfd = open(adevice, O_RDONLY);
	if (audfd < 0) {
		fprintf(stderr, "Unable to open %s: %s\n", adevice,
				strerror(errno));
		exit(1);
	}
	fcntl(audfd, F_SETFL, O_NONBLOCK);
}

void alsa_init(void)
{
	int arg;

	arg = AFMT_S16_LE;
	if (ioctl(audfd, SNDCTL_DSP_SETFMT, &arg) < 0) {
		perror("SNDCTL_DSP_SETFMT");
		exit(1);
	}
	arg = 48000;
	if (ioctl(audfd, SNDCTL_DSP_SPEED, &arg) < 0) {
		perror("SNDCTL_DSP_SPEED");
		exit(1);
	}
	arg = 1;
	if (ioctl(audfd, SNDCTL_DSP_STEREO, &arg) < 0) {
		perror("SNDCTL_DSP_STEREO");
		exit(1);
	}
}

void v4l2_init(void)
{
	struct v4l2_capability cap;
	struct v4l2_streamparm parm;
	struct v4l2_format fmt;
	struct v4l2_requestbuffers req;
	struct v4l2_buffer buf;
	struct v4l2_input inp;
	__u32 i;

	/* First query the capabilities of the video capture device */
	if (ioctl(vidfd, VIDIOC_QUERYCAP, &cap) < 0) {
		perror("VIDIOC_QUERYCAP");
		exit(1);
	}
	if (verbose) {
		printf("\nDriver:   %s\n", cap.driver);
		printf("Card:     %s\n", cap.card);
		printf("Version:  %u.%u.%u\n\n", (cap.version >> 16) & 0xff,
				(cap.version >> 8) & 0xff, cap.version & 0xff);
	}

	if (probe)
		return;

    /* Print some info about the input port */
    if (ioctl(vidfd, VIDIOC_G_INPUT, &input) < 0) {
        fprintf(stderr, "Unable to get input port\n");
        exit(1);
    }

    memset(&inp, 0, sizeof(inp));
    inp.index = input;
    if (ioctl(vidfd, VIDIOC_ENUMINPUT, &inp) < 0) {
        fprintf(stderr,
            "Input port %d does not exist on this hardware\n",
            input);
        exit(1);
    }
	if(verbose) fprintf(stderr, "Using input port %s\n", inp.name);

	/* Get the format and read width and height */
	memset(&fmt, 0, sizeof(fmt));
	fmt.type= V4L2_BUF_TYPE_VIDEO_CAPTURE;
	if (ioctl(vidfd, VIDIOC_G_FMT, &fmt) < 0) {
		fprintf(stderr, "Unable to get format\n");
		exit(1);
	}
	width = fmt.fmt.pix.width;
	height = fmt.fmt.pix.height;

	if(fmt.fmt.pix.pixelformat==V4L2_PIX_FMT_MJPEG)
	    format = FMT_MJPEG;
	else {
	    struct v4l2_ext_control ctrl;
	    struct v4l2_ext_controls ctrls;

	    memset(&ctrl, 0, sizeof(ctrl));
	    memset(&ctrls, 0, sizeof(ctrls));
	    ctrl.id = V4L2_CID_MPEG_VIDEO_ENCODING;
	    ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
	    ctrls.count = 1;
	    ctrls.controls = &ctrl;

        if (ioctl(vidfd, VIDIOC_G_EXT_CTRLS, &ctrls) < 0) {
            fprintf(stderr, "Unable to get video encoding format\n");
            exit(1);
        }

        switch (ctrl.value) {
        case V4L2_MPEG_VIDEO_ENCODING_MPEG_1:
            format = FMT_MPEG1;
            break;
        case V4L2_MPEG_VIDEO_ENCODING_MPEG_2:
            format = FMT_MPEG2;
            break;
        case V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC:
            format = FMT_MPEG4;
            break;
        default:
            break;
        }
    }

	/* Get the frame period */
	memset(&parm, 0, sizeof(parm));
	parm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	if (ioctl(vidfd, VIDIOC_G_PARM, &parm) < 0) {
		fprintf(stderr, "Unable to query the frame rate\n");
		exit(1);
	}
	frameperiod = parm.parm.capture.timeperframe;

	if(verbose) fprintf(stderr, "Capturing video at %dx%d, %.2f FPS\n", width, height,
			(double)frameperiod.denominator /
			(double)frameperiod.numerator);

	/* Request that buffers be allocated for memory mapping */
	memset(&req, 0, sizeof(req));
	req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	req.memory = V4L2_MEMORY_MMAP;
	req.count = MAX_BUFFERS;
	if (ioctl(vidfd, VIDIOC_REQBUFS, &req) < 0) {
		perror("VIDIOC_REQBUFS");
		exit(1);
	}
	if (verbose)
		printf("Received %d buffers\n", req.count);
	buf_count = req.count;

	/* Map each of the buffers into this process's memory */
	for (i = 0; i < buf_count; ++i) {
		memset(&buf, 0, sizeof(buf));
		buf.index = i;
		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		if (ioctl(vidfd, VIDIOC_QUERYBUF, &buf) < 0) {
			perror("VIDIOC_QUERYBUF");
			exit(1);
		}
		buffers[buf.index] = (unsigned char *)mmap(NULL, buf.length,
				PROT_READ | PROT_WRITE, MAP_SHARED,
				vidfd, buf.m.offset);
	}

	/* Queue all of the buffers for frame capture */
	for (i = 0; i < buf_count; ++i) {
		memset(&buf, 0, sizeof(buf));
		buf.index = i;
		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory = V4L2_MEMORY_MMAP;
		if (ioctl(vidfd, VIDIOC_QBUF, &buf) < 0) {
			perror("VIDIOC_QBUF");
			exit(1);
		}
	}
}

void v4l2_start(void)
{
	int arg = V4L2_BUF_TYPE_VIDEO_CAPTURE;

	sequence = 0;
	if (ioctl(vidfd, VIDIOC_STREAMON, &arg) < 0) {
		perror("VIDIOC_STREAMON");
		exit(1);
	}
}

void v4l2_stop(void)
{
	int arg = V4L2_BUF_TYPE_VIDEO_CAPTURE;

	if (ioctl(vidfd, VIDIOC_STREAMOFF, &arg) < 0) {
		perror("VIDIOC_STREAMOFF");
		exit(1);
	}
}

void write_frame(unsigned char *data, int length, unsigned int fourcc, int key)
{
	unsigned char hdr[16];
	unsigned int offset;

	if (avifd < 0)
		return;

	/* Write the AVI index record */
	PUT_32(hdr, fourcc);
	PUT_32(hdr + 4, key ? 0x10 : 0);
	offset = lseek(avifd, 0, SEEK_CUR);
	PUT_32(hdr + 8, offset - 1024 - 8);
	PUT_32(hdr + 12, length);
	write(idxfd, hdr, 16);

	/* Write the frame data to the AVI file */
	PUT_32(hdr + 4, length);
	write(avifd, hdr, 8);
	write(avifd, data, (length + 1) & ~0x1); /* word-align with junk */
}

int alsa_read(void)
{
	int ret;

	ret = read(audfd, audio_buffer + audio_len,
			sizeof(audio_buffer) - audio_len);
	if (ret < 0) {
		if (errno == EAGAIN)
			return 0;
		perror("Unexpected error reading from audio device");
		return ret;
	}
	if (interrupted) return 0;
	audio_len += ret;
	return ret;
}


void average16b(unsigned char* dst, unsigned char* src1, unsigned char* src2)
{
	int16_t a,b,c;
	
	a = (((u_int16_t)*(src1+1)) << 8) | (u_int16_t)*(src1);
	b = (((u_int16_t)*(src2+1)) << 8) | (u_int16_t)*(src2);

	c = a/2+b/2 + (a&b&0x1);
	*dst = ((u_int16_t)c)&0xFF;
	*(dst+1) = (((u_int16_t)c)>>8)&0xFF;
}
	

int audio_video_sync(void)
{
	int i=0;
	int j=0;
	int k=0;
	static int sync_step=0;
	
	
	while(i<audio_len && j < AUDIO_BUF_LEN) {
		/* If av_offset more than about 50ms and sync_step reached */
		if(fabs(av_offset) > 4000 && 
		   sync_step > (int)(192000.0/fabs(av_offset)) && sync_step > MIN_SYNC_STEP ) {
			/* If audio lagging, i.e. too many audio bytes, and
			 * enough audio_buffer left to average samples then do that */
			if(av_offset < 0 && i < audio_len-4) {
				/* Merge two samples into one */
				for(k=0;k<2;k++) {
					average16b(&audio_sync_buffer[j], &audio_buffer[i], &audio_buffer[i+4]);
					i+=2;
					j+=2;
				}
				i+=4;
				/* Offset now reduced by 4 bytes */
				av_offset += 4;
				total_av_corr -= 4;
				/* Correction performed */
				sync_step = 0;
			} else if(av_offset > 0 && j < AUDIO_BUF_LEN-4) {
				/* Audio running, i.e. too few audio bytes, then insert
				 * samples */
				
				for(k=0;k<2;k++) {
					/* Copy first words */
					audio_sync_buffer[j] = audio_buffer[i];
					audio_sync_buffer[j+1] = audio_buffer[i+1];
					
					/* Create second words */
					average16b(&audio_sync_buffer[j+4], &audio_buffer[i], &audio_buffer[i+4]); 
					i+=2;
					j+=2;
				}
				j+=4;
				/* Four bytes added */
				av_offset -= 4;
				total_av_corr += 4;
				/* Correction performed */
				sync_step = 0;
			} else { /* To make sure something is always done */
				for(k=0;k<4&&i<audio_len;k++) {
					audio_sync_buffer[j] = audio_buffer[i];
					j++;
					i++;
				}
			}
		} else {
			/* No sync correction, move forward in both buffers */
			for(k=0;k<4&&i<audio_len;k++) {
				audio_sync_buffer[j] = audio_buffer[i];
				j++;
				i++;
			}
		}
		sync_step++;
		if(interrupted) {
			return 0;
		}
	}
	return j;
}


int v4l2_frame_capture(struct timeval *capture_time)
{
	struct v4l2_buffer buf;
	int length;
	int key;

	/* Retrieve the filled buffer from the kernel */
	memset(&buf, 0, sizeof(buf));
	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	buf.memory = V4L2_MEMORY_MMAP;
	if (ioctl(vidfd, VIDIOC_DQBUF, &buf) < 0) {
		if (interrupted) return 0;
		perror("VIDIOC_DQBUF");
		return -1;
	}

	/* Get the capture timestamp and length of the frame data */
	*capture_time = buf.timestamp;
	key = buf.flags & V4L2_BUF_FLAG_KEYFRAME;
	length = buf.bytesused;
	if (sequence != 0)
		while (++sequence != buf.sequence)
			fprintf(stderr, "Dropped a frame!\n");

	/* First write the accumulated audio */
	if (audfd >= 0) {
		alsa_read();
		if (interrupted) return 0;
		/* Must be careful to update av_offset before 
		 * calling audio_video_sync */
		av_offset -= (double)audio_len;
		audio_len = audio_video_sync();
		if(interrupted) return 0;
		write_frame(audio_sync_buffer, audio_len, FOURCC("01wb"), 1);
		abytes += audio_len;
		audio_len = 0;
	}

	/* Then write the video frame */
	write_frame(buffers[buf.index], length, FOURCC("00dc"), key);

	/* Update global variables */
	if (length > max_frame_length)
		max_frame_length = length;
	vbytes += length;

	/* Send the frame back to the kernel to be filled again */
	if (ioctl(vidfd, VIDIOC_QBUF, &buf) < 0) {
		perror("VIDIOC_QBUF");
		exit(1);
	}
	return length;
}


void avi_finish(void)
{
	unsigned long long int filelen;
	int i, movielen, off;
	unsigned char hdr[1024 + 12];

	movielen = lseek(avifd, 0, SEEK_CUR);

	PUT_32(hdr, FOURCC("idx1"));
	PUT_32(hdr + 4, lseek(idxfd, 0, SEEK_CUR));
	write(avifd, hdr, 8);
	lseek(idxfd, 0, SEEK_SET);
	while ((i = read(idxfd, hdr, sizeof(hdr))) > 0)
		if (write(avifd, hdr, i) < 0) {
			perror("Unable to write index data to AVI file");
			exit(1);
		}
	close(idxfd);

	filelen = lseek(avifd, 0, SEEK_CUR);

	memset(hdr, 0, sizeof(hdr));
	PUT_32(hdr, FOURCC("RIFF"));
	PUT_32(hdr + 4, lseek(avifd, 0, SEEK_CUR) - 8);
	PUT_32(hdr + 8, FOURCC("AVI "));
	PUT_32(hdr + 12, FOURCC("LIST"));
	PUT_32(hdr + 12 + 8, FOURCC("hdrl"));
	PUT_32(hdr + 12 + 12, FOURCC("avih"));
	PUT_32(hdr + 12 + 12 + 4, 64 - 8);
	/* bizarre math to do microsecond arithmetic in 32-bit ints */
	/* =>   1000000 * frameperiod.numerator / frameperiod.denominator */
	PUT_32(hdr + 12 + 12 + 8, (frameperiod.numerator * 15625 /
						frameperiod.denominator) * 64 +
					((frameperiod.numerator * 15625) %
					 	frameperiod.denominator) * 64 /
					frameperiod.denominator);
	PUT_32(hdr + 12 + 12 + 20, 2320);
	PUT_32(hdr + 12 + 12 + 24, avi_frame_count);
	PUT_32(hdr + 12 + 12 + 32, audfd < 0 ? 1 : 2);
	PUT_32(hdr + 12 + 12 + 36, 128*1024);
	PUT_32(hdr + 12 + 12 + 40, width);
	PUT_32(hdr + 12 + 12 + 44, height);
	off = 64;
	off += add_video_stream_header(hdr + 12 + 12 + off);
	if (audfd >= 0)
		off += add_audio_stream_header(hdr + 12 + 12 + off);
	PUT_32(hdr + 12 + 4, 12 - 8 + off);

	PUT_32(hdr + 12 + 12 + off, FOURCC("JUNK"));
	PUT_32(hdr + 12 + 12 + off + 4, 1024 - 12 - 12 - off - 8);
	PUT_32(hdr + 1024, FOURCC("LIST"));
	PUT_32(hdr + 1024 + 4, movielen - 1024 - 8);
	PUT_32(hdr + 1024 + 8, FOURCC("movi"));
	lseek(avifd, 0, SEEK_SET);
	write(avifd, hdr, 1024 + 12);
	close(avifd);

	fprintf(stderr,
		"\n    Video data written to file: %llu bytes of ", vbytes);
	switch (format) {
	case FMT_MJPEG:
		fprintf(stderr, "Motion-JPEG\n");
		break;
	case FMT_MPEG1:
		fprintf(stderr, "MPEG1\n");
		break;
	case FMT_MPEG2:
		fprintf(stderr, "MPEG2\n");
		break;
	case FMT_MPEG4:
		fprintf(stderr, "MPEG4\n");
		break;
	}
	if (abytes > 0)
		fprintf(stderr,
			"    Audio data written to file: %llu bytes of %s\n",
			abytes, "uncompressed PCM");
	fprintf(stderr, "    AVI file format overhead  : %llu bytes\n",
			filelen - vbytes - abytes);
	fprintf(stderr, "    Total file size           : %llu bytes\n",
			filelen);
	fprintf(stderr, "    Total A/V correction      : %d bytes\n\n",
			total_av_corr );
}

void interrupt_handler(int signal)
{
	interrupted = 1;
}

int main(int argc, char **argv)
{
	struct sigaction sa;
	struct timeval cur, start, mmark;
	unsigned long long int csec, filesize;
	int vframe_len;
	int file_count = 1, mrate = 0;
	unsigned long long int mcount = 0, mbytes = 0;

	memset(&sa, 0, sizeof(sa));
	sa.sa_handler = interrupt_handler;
	sa.sa_flags = SA_RESTART;
	sigaction(SIGINT, &sa, NULL);
	sigaction(SIGTERM, &sa, NULL);
	sigaction(SIGHUP, &sa, NULL);
	sigaction(SIGPIPE, &sa, NULL);

	memset(audio_buffer, 0, sizeof(audio_buffer));
	parse_opts(argc, argv);

	open_devices();
	v4l2_init();
	if (audfd >= 0)
		alsa_init();
	if (probe) {
		printf("For usage help, run `%s -help`\n", argv[0]);
		return 0;
	}

	if (!nowrite) {
		if (strstr(avibase, "%d"))
			sprintf(avifile, avibase, file_count);
		else
			strcpy(avifile, avibase);
		open_avifile();
	}

	v4l2_start();
	/* This will set the audiosync to be in line with the initial sync */
	av_offset += 192000.0*2.0/fps;

	for (;;) {
		/* Retrieve a new video frame and audio frame */
		vframe_len = v4l2_frame_capture(&cur);
		if (interrupted) break;
		if (vframe_len < 0)
			break;

		/* Display file length, timestamp, and frame count */
		if (avifd < 0)
			filesize = vbytes + abytes;
		else
			filesize = lseek(avifd, 0, SEEK_CUR);
		++avi_frame_count;
		av_offset += 192000.0/fps;
		if (total_frames++ == 0)
			mmark = start = cur;
		csec = 100 * (cur.tv_sec - start.tv_sec) +
			(cur.tv_usec - start.tv_usec) / 10000;
		fprintf(stderr,
			"\r %02llu:%02llu:%02llu.%02llu  Frames: %5llu  "
			"AVI size: %3lluMB  A-V: %7.2fms", csec / 360000 % 60, csec / 6000 % 60,
    			csec / 100 % 60, csec % 100, total_frames, filesize / 1024 / 1024, -av_offset/192);


		/* Calculate and display video bitrate */
		if (mcount++ == 50) {
			csec = 100 * (cur.tv_sec - mmark.tv_sec) +
				(cur.tv_usec - mmark.tv_usec) / 10000;
			mrate = (4 * mbytes) / (5 * csec);
			mbytes = 0;
			mcount = 1;
			mmark = cur;
		}
		mbytes += vframe_len;
		if (mrate > 0)
			fprintf(stderr, "  Video: %5dkbps", mrate);

		/* If we've reached the maximum AVI length, make a new file
		 * if we were given a filename with %d, or otherwise stop
		 * recording */
		if (avifd >= 0 && filesize >= max_file_size && max_file_size > 0) { 
			if(strstr(avibase, "%d")) {
				avi_finish();
				++file_count;
				sprintf(avifile, avibase, file_count);
				avi_frame_count = 0;
				max_frame_length = 0;
				abytes = 0;
				vbytes = 0;
				open_avifile();
			} else {
				fprintf(stderr,
					"\nAVI file size limit reached\n");
				break;
			}
		}

		/* If we've reached the user-specified maximum number of
		 * frames to record, stop */
		if (frame_limit >= 0 && total_frames == frame_limit)
			break;
		/* If we've reached the user-specified maximum duration, stop */
		if (duration >= 0 && cur.tv_sec >= start.tv_sec + duration &&
				cur.tv_usec >= start.tv_usec)
			break;
		/* If we've reached the max file size, stop unless "%d" is in the filename */
		if (max_file_size > 0 && filesize >= max_file_size && ! strstr(avibase, "%d"))
			break;
	}
	fprintf(stderr, "\n");
	v4l2_stop();
	if (avifd >= 0)
		avi_finish();
	return 0;
};

--------------080201070201030801040105--

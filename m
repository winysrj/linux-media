Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49651 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755490AbcKVXDx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 18:03:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] v4l: uvcvideo: Remove format descriptions
Date: Wed, 23 Nov 2016 01:04:06 +0200
Message-Id: <1479855846-8390-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1479855846-8390-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1479855846-8390-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 core fills format description on its own, there's no need to
duplicate the descriptions in the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 137 +++++++++++--------------------------
 drivers/media/usb/uvc/uvc_v4l2.c   |   2 -
 drivers/media/usb/uvc/uvcvideo.h   |   3 -
 3 files changed, 39 insertions(+), 103 deletions(-)

Hans, after this patch the uvcvideo driver debug messages can only print the
fourcc as a 32-bit hex value instead of the previously printed description. Do
you think it would make sense to export the v4l_fill_fmtdesc() function (or
possibly just the part of it that translates fourcc to string) so it could be
used by the uvcvideo driver ?

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 04bf35063c4c..6a114ffea5be 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -44,147 +44,90 @@ unsigned int uvc_timeout_param = UVC_CTRL_STREAMING_TIMEOUT;
 
 static struct uvc_format_desc uvc_fmts[] = {
 	{
-		.name		= "YUV 4:2:2 (YUYV)",
 		.guid		= UVC_GUID_FORMAT_YUY2,
 		.fcc		= V4L2_PIX_FMT_YUYV,
-	},
-	{
-		.name		= "YUV 4:2:2 (YUYV)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_YUY2_ISIGHT,
 		.fcc		= V4L2_PIX_FMT_YUYV,
-	},
-	{
-		.name		= "YUV 4:2:0 (NV12)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_NV12,
 		.fcc		= V4L2_PIX_FMT_NV12,
-	},
-	{
-		.name		= "MJPEG",
+	}, {
 		.guid		= UVC_GUID_FORMAT_MJPEG,
 		.fcc		= V4L2_PIX_FMT_MJPEG,
-	},
-	{
-		.name		= "YVU 4:2:0 (YV12)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_YV12,
 		.fcc		= V4L2_PIX_FMT_YVU420,
-	},
-	{
-		.name		= "YUV 4:2:0 (I420)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_I420,
 		.fcc		= V4L2_PIX_FMT_YUV420,
-	},
-	{
-		.name		= "YUV 4:2:0 (M420)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_M420,
 		.fcc		= V4L2_PIX_FMT_M420,
-	},
-	{
-		.name		= "YUV 4:2:2 (UYVY)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_UYVY,
 		.fcc		= V4L2_PIX_FMT_UYVY,
-	},
-	{
-		.name		= "Greyscale 8-bit (Y800)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_Y800,
 		.fcc		= V4L2_PIX_FMT_GREY,
-	},
-	{
-		.name		= "Greyscale 8-bit (Y8  )",
+	}, {
 		.guid		= UVC_GUID_FORMAT_Y8,
 		.fcc		= V4L2_PIX_FMT_GREY,
-	},
-	{
-		.name		= "Greyscale 10-bit (Y10 )",
+	}, {
 		.guid		= UVC_GUID_FORMAT_Y10,
 		.fcc		= V4L2_PIX_FMT_Y10,
-	},
-	{
-		.name		= "Greyscale 12-bit (Y12 )",
+	}, {
 		.guid		= UVC_GUID_FORMAT_Y12,
 		.fcc		= V4L2_PIX_FMT_Y12,
-	},
-	{
-		.name		= "Greyscale 16-bit (Y16 )",
+	}, {
 		.guid		= UVC_GUID_FORMAT_Y16,
 		.fcc		= V4L2_PIX_FMT_Y16,
-	},
-	{
-		.name		= "BGGR Bayer (BY8 )",
+	}, {
 		.guid		= UVC_GUID_FORMAT_BY8,
 		.fcc		= V4L2_PIX_FMT_SBGGR8,
-	},
-	{
-		.name		= "BGGR Bayer (BA81)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_BA81,
 		.fcc		= V4L2_PIX_FMT_SBGGR8,
-	},
-	{
-		.name		= "GBRG Bayer (GBRG)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_GBRG,
 		.fcc		= V4L2_PIX_FMT_SGBRG8,
-	},
-	{
-		.name		= "GRBG Bayer (GRBG)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_GRBG,
 		.fcc		= V4L2_PIX_FMT_SGRBG8,
-	},
-	{
-		.name		= "RGGB Bayer (RGGB)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_RGGB,
 		.fcc		= V4L2_PIX_FMT_SRGGB8,
-	},
-	{
-		.name		= "RGB565",
+	}, {
 		.guid		= UVC_GUID_FORMAT_RGBP,
 		.fcc		= V4L2_PIX_FMT_RGB565,
-	},
-	{
-		.name		= "BGR 8:8:8 (BGR3)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_BGR3,
 		.fcc		= V4L2_PIX_FMT_BGR24,
-	},
-	{
-		.name		= "H.264",
+	}, {
 		.guid		= UVC_GUID_FORMAT_H264,
 		.fcc		= V4L2_PIX_FMT_H264,
-	},
-	{
-		.name		= "Greyscale 8 L/R (Y8I)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_Y8I,
 		.fcc		= V4L2_PIX_FMT_Y8I,
-	},
-	{
-		.name		= "Greyscale 12 L/R (Y12I)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_Y12I,
 		.fcc		= V4L2_PIX_FMT_Y12I,
-	},
-	{
-		.name		= "Depth data 16-bit (Z16)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_Z16,
 		.fcc		= V4L2_PIX_FMT_Z16,
-	},
-	{
-		.name		= "Bayer 10-bit (SRGGB10P)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_RW10,
 		.fcc		= V4L2_PIX_FMT_SRGGB10P,
-	},
-	{
-		.name		= "Bayer 16-bit (SBGGR16)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_BG16,
 		.fcc		= V4L2_PIX_FMT_SBGGR16,
-	},
-	{
-		.name		= "Bayer 16-bit (SGBRG16)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_GB16,
 		.fcc		= V4L2_PIX_FMT_SGBRG16,
-	},
-	{
-		.name		= "Bayer 16-bit (SRGGB16)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_RG16,
 		.fcc		= V4L2_PIX_FMT_SRGGB16,
-	},
-	{
-		.name		= "Bayer 16-bit (SGRBG16)",
+	}, {
 		.guid		= UVC_GUID_FORMAT_GR16,
 		.fcc		= V4L2_PIX_FMT_SGRBG16,
 	},
@@ -380,6 +323,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 	unsigned int width_multiplier = 1;
 	unsigned int interval;
 	unsigned int i, n;
+	char fmtname[12] = { 0, };
 	__u8 ftype;
 
 	format->type = buffer[2];
@@ -401,14 +345,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 		fmtdesc = uvc_format_by_guid(&buffer[5]);
 
 		if (fmtdesc != NULL) {
-			strlcpy(format->name, fmtdesc->name,
-				sizeof format->name);
 			format->fcc = fmtdesc->fcc;
 		} else {
 			uvc_printk(KERN_INFO, "Unknown video format %pUl\n",
 				&buffer[5]);
-			snprintf(format->name, sizeof(format->name), "%pUl\n",
-				&buffer[5]);
 			format->fcc = 0;
 		}
 
@@ -419,8 +359,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 		 */
 		if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
 			if (format->fcc == V4L2_PIX_FMT_YUYV) {
-				strlcpy(format->name, "Greyscale 8-bit (Y8  )",
-					sizeof(format->name));
 				format->fcc = V4L2_PIX_FMT_GREY;
 				format->bpp = 8;
 				width_multiplier = 2;
@@ -445,7 +383,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strlcpy(format->name, "MJPEG", sizeof format->name);
 		format->fcc = V4L2_PIX_FMT_MJPEG;
 		format->flags = UVC_FMT_FLAG_COMPRESSED;
 		format->bpp = 0;
@@ -463,13 +400,13 @@ static int uvc_parse_format(struct uvc_device *dev,
 
 		switch (buffer[8] & 0x7f) {
 		case 0:
-			strlcpy(format->name, "SD-DV", sizeof format->name);
+			strcpy(fmtname, "SD-DV");
 			break;
 		case 1:
-			strlcpy(format->name, "SDL-DV", sizeof format->name);
+			strcpy(fmtname, "SDL-DV");
 			break;
 		case 2:
-			strlcpy(format->name, "HD-DV", sizeof format->name);
+			strcpy(fmtname, "HD-DV");
 			break;
 		default:
 			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
@@ -479,8 +416,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strlcat(format->name, buffer[8] & (1 << 7) ? " 60Hz" : " 50Hz",
-			sizeof format->name);
+		strcat(fmtname, buffer[8] & (1 << 7) ? " 60Hz" : " 50Hz");
 
 		format->fcc = V4L2_PIX_FMT_DV;
 		format->flags = UVC_FMT_FLAG_COMPRESSED | UVC_FMT_FLAG_STREAM;
@@ -508,7 +444,12 @@ static int uvc_parse_format(struct uvc_device *dev,
 		return -EINVAL;
 	}
 
-	uvc_trace(UVC_TRACE_DESCR, "Found format %s.\n", format->name);
+	if (format->fcc) {
+		if (!fmtname[0])
+			sprintf(fmtname, "0x%08x", format->fcc);
+
+		uvc_trace(UVC_TRACE_DESCR, "Found format %s.\n", fmtname);
+	}
 
 	buflen -= buffer[0];
 	buffer += buffer[0];
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 05eed4be25df..b2ccd9e7e848 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -599,8 +599,6 @@ static int uvc_ioctl_enum_fmt(struct uvc_streaming *stream,
 	fmt->flags = 0;
 	if (format->flags & UVC_FMT_FLAG_COMPRESSED)
 		fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
-	strlcpy(fmt->description, format->name, sizeof(fmt->description));
-	fmt->description[sizeof(fmt->description) - 1] = 0;
 	fmt->pixelformat = format->fcc;
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 3d6cc62f3cd2..ae59917aa8a2 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -244,7 +244,6 @@ struct uvc_control {
 };
 
 struct uvc_format_desc {
-	char *name;
 	__u8 guid[16];
 	__u32 fcc;
 };
@@ -349,8 +348,6 @@ struct uvc_format {
 	__u32 fcc;
 	__u32 flags;
 
-	char name[32];
-
 	unsigned int nframes;
 	struct uvc_frame *frame;
 };
-- 
Regards,

Laurent Pinchart


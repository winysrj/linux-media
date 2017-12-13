Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:50379 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750745AbdLMXoo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 18:44:44 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mike Isely <isely@pobox.com>
Cc: Oleksandr Ostrenko <oleksandr.ostrenko@tu-dresden.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pvrusb2: correctly return V4L2_PIX_FMT_MPEG in enum_fmt
Message-ID: <3c98b33d-c92d-6fd1-ac69-215fa70de1b7@xs4all.nl>
Date: Thu, 14 Dec 2017 00:44:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pvrusb2 code appears to have a some old workaround code for xawtv that causes a
WARN() due to an unrecognized pixelformat 0 in v4l2_ioctl.c.

Since all other MPEG drivers fill this in correctly, it is a safe assumption that
this particular problem no longer exists.

While I'm at it, clean up the code a bit.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
I'll try to give this a spin in the morning with xawtv and my ivtv card (that also
uses V4L2_PIX_FMT_MPEG), just to make sure xawtv no longer breaks if it sees it.

Oleksandr, are you able to test this as well on your pvrusb2?

Regards,

	Hans
---
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 4320bda9352d..cc90be364a30 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -78,18 +78,6 @@ static int vbi_nr[PVR_NUM] = {[0 ... PVR_NUM-1] = -1};
 module_param_array(vbi_nr, int, NULL, 0444);
 MODULE_PARM_DESC(vbi_nr, "Offset for device's vbi dev minor");

-static struct v4l2_fmtdesc pvr_fmtdesc [] = {
-	{
-		.index          = 0,
-		.type           = V4L2_BUF_TYPE_VIDEO_CAPTURE,
-		.flags          = V4L2_FMT_FLAG_COMPRESSED,
-		.description    = "MPEG1/2",
-		// This should really be V4L2_PIX_FMT_MPEG, but xawtv
-		// breaks when I do that.
-		.pixelformat    = 0, // V4L2_PIX_FMT_MPEG,
-	}
-};
-
 #define PVR_FORMAT_PIX  0
 #define PVR_FORMAT_VBI  1

@@ -99,17 +87,11 @@ static struct v4l2_format pvr_format [] = {
 		.fmt    = {
 			.pix        = {
 				.width          = 720,
-				.height             = 576,
-				// This should really be V4L2_PIX_FMT_MPEG,
-				// but xawtv breaks when I do that.
-				.pixelformat    = 0, // V4L2_PIX_FMT_MPEG,
+				.height         = 576,
+				.pixelformat    = V4L2_PIX_FMT_MPEG,
 				.field          = V4L2_FIELD_INTERLACED,
-				.bytesperline   = 0,  // doesn't make sense
-						      // here
-				//FIXME : Don't know what to put here...
-				.sizeimage          = (32*1024),
-				.colorspace     = 0, // doesn't make sense here
-				.priv           = 0
+				/* FIXME : Don't know what to put here... */
+				.sizeimage      = 32 * 1024,
 			}
 		}
 	},
@@ -407,11 +389,11 @@ static int pvr2_g_frequency(struct file *file, void *priv, struct v4l2_frequency

 static int pvr2_enum_fmt_vid_cap(struct file *file, void *priv, struct v4l2_fmtdesc *fd)
 {
-	/* Only one format is supported : mpeg.*/
-	if (fd->index != 0)
+	/* Only one format is supported: MPEG. */
+	if (fd->index)
 		return -EINVAL;

-	memcpy(fd, pvr_fmtdesc, sizeof(struct v4l2_fmtdesc));
+	fd->pixelformat = V4L2_PIX_FMT_MPEG;
 	return 0;
 }

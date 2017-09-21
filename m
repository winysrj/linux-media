Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:58802 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751709AbdIUTZ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 15:25:26 -0400
Subject: [PATCH 2/3] [media] uvcvideo: Adjust 14 checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <20a8d1a5-45f1-2f98-e4b3-cfc24e9c04b0@users.sourceforge.net>
Message-ID: <9f123108-2ef7-83ec-9981-280a24502771@users.sourceforge.net>
Date: Thu, 21 Sep 2017 21:25:20 +0200
MIME-Version: 1.0
In-Reply-To: <20a8d1a5-45f1-2f98-e4b3-cfc24e9c04b0@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 21 Sep 2017 21:00:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 6ec2b255c44a..184edf8a0885 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -41,7 +41,7 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 	int ret;
 
 	map = kzalloc(sizeof *map, GFP_KERNEL);
-	if (map == NULL)
+	if (!map)
 		return -ENOMEM;
 
 	map->id = xmap->id;
@@ -211,7 +211,7 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 			break;
 	}
 
-	if (frame == NULL) {
+	if (!frame) {
 		uvc_trace(UVC_TRACE_FORMAT, "Unsupported size %ux%u.\n",
 				fmt->fmt.pix.width, fmt->fmt.pix.height);
 		return -EINVAL;
@@ -260,9 +260,9 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 	fmt->fmt.pix.colorspace = format->colorspace;
 	fmt->fmt.pix.priv = 0;
 
-	if (uvc_format != NULL)
+	if (uvc_format)
 		*uvc_format = format;
-	if (uvc_frame != NULL)
+	if (uvc_frame)
 		*uvc_frame = frame;
 
 done:
@@ -282,8 +282,7 @@ static int uvc_v4l2_get_format(struct uvc_streaming *stream,
 	mutex_lock(&stream->mutex);
 	format = stream->cur_format;
 	frame = stream->cur_frame;
-
-	if (format == NULL || frame == NULL) {
+	if (!format || !frame) {
 		ret = -EINVAL;
 		goto done;
 	}
@@ -499,7 +498,7 @@ static int uvc_v4l2_open(struct file *file)
 
 	/* Create the device handle. */
 	handle = kzalloc(sizeof *handle, GFP_KERNEL);
-	if (handle == NULL) {
+	if (!handle) {
 		usb_autopm_put_interface(stream->dev->intf);
 		return -ENOMEM;
 	}
@@ -811,7 +810,7 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
 	u32 index = input->index;
 	int pin = 0;
 
-	if (selector == NULL ||
+	if (!selector ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
 		if (index != 0)
 			return -EINVAL;
@@ -830,7 +829,7 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
 		}
 	}
 
-	if (iterm == NULL || iterm->id != pin)
+	if (!iterm || iterm->id != pin)
 		return -EINVAL;
 
 	memset(input, 0, sizeof(*input));
@@ -849,7 +848,7 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
 	int ret;
 	u8 i;
 
-	if (chain->selector == NULL ||
+	if (!chain->selector ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
 		*input = 0;
 		return 0;
@@ -876,7 +875,7 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
 	if (ret < 0)
 		return ret;
 
-	if (chain->selector == NULL ||
+	if (!chain->selector ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
 		if (input)
 			return -EINVAL;
@@ -1160,7 +1159,7 @@ static int uvc_ioctl_enum_framesizes(struct file *file, void *fh,
 			break;
 		}
 	}
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	if (fsize->index >= format->nframes)
@@ -1189,7 +1188,7 @@ static int uvc_ioctl_enum_frameintervals(struct file *file, void *fh,
 			break;
 		}
 	}
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	for (i = 0; i < format->nframes; i++) {
@@ -1199,7 +1198,7 @@ static int uvc_ioctl_enum_frameintervals(struct file *file, void *fh,
 			break;
 		}
 	}
-	if (frame == NULL)
+	if (!frame)
 		return -EINVAL;
 
 	if (frame->bFrameIntervalType) {
-- 
2.14.1

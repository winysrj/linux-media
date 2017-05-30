Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49935 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbdE3TIg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 15:08:36 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH] [media] v4l2-subdev: check colorimetry in link validate
Date: Tue, 30 May 2017 16:08:08 -0300
Message-Id: <1496171288-28656-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

colorspace, ycbcr_enc, quantization and xfer_func must match across the
link.
Check if they match in v4l2_subdev_link_validate_default unless they are
set as _DEFAULT.

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Hi,

I think we should validate colorimetry as having different colorimetry
across a link doesn't make sense.
But I am confused about what to do when they are set to _DEFAULT, what
do you think?

Thanks
---
 drivers/media/v4l2-core/v4l2-subdev.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index da78497..784ae92 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -502,10 +502,27 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 				      struct v4l2_subdev_format *source_fmt,
 				      struct v4l2_subdev_format *sink_fmt)
 {
-	/* The width, height and code must match. */
+	/* The width, height, code and colorspace must match. */
 	if (source_fmt->format.width != sink_fmt->format.width
 	    || source_fmt->format.height != sink_fmt->format.height
-	    || source_fmt->format.code != sink_fmt->format.code)
+	    || source_fmt->format.code != sink_fmt->format.code
+	    || source_fmt->format.colorspace != sink_fmt->format.colorspace)
+		return -EPIPE;
+
+	/* Colorimetry must match if they are not set to DEFAULT */
+	if (source_fmt->format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
+	    && sink_fmt->format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
+	    && source_fmt->format.ycbcr_enc != sink_fmt->format.ycbcr_enc)
+		return -EPIPE;
+
+	if (source_fmt->format.quantization != V4L2_QUANTIZATION_DEFAULT
+	    && sink_fmt->format.quantization != V4L2_QUANTIZATION_DEFAULT
+	    && source_fmt->format.quantization != sink_fmt->format.quantization)
+		return -EPIPE;
+
+	if (source_fmt->format.xfer_func != V4L2_XFER_FUNC_DEFAULT
+	    && sink_fmt->format.xfer_func != V4L2_XFER_FUNC_DEFAULT
+	    && source_fmt->format.xfer_func != sink_fmt->format.xfer_func)
 		return -EPIPE;
 
 	/* The field order must match, or the sink field order must be NONE
-- 
2.7.4

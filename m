Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50701 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdFHRFb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 13:05:31 -0400
From: Helen Koike <helen.koike@collabora.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2] [media] v4l2-subdev: check colorimetry in link validate
Date: Thu,  8 Jun 2017 14:05:08 -0300
Message-Id: <1496941513-29040-1-git-send-email-helen.koike@collabora.com>
In-Reply-To: <fe95a0c2-aebc-c4a8-e771-6c4eb2d0f340@collabora.com>
References: <fe95a0c2-aebc-c4a8-e771-6c4eb2d0f340@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

colorspace, ycbcr_enc, quantization and xfer_func must match
across the link.
Check if they match in v4l2_subdev_link_validate_default
unless they are set as _DEFAULT.

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Hi,

As discussed previously, I added a warn message instead of returning
error to give drivers some time to adapt.
But the problem is that: as the format is set by userspace, it is
possible that userspace will set the wrong format at pads and see these
messages when there is no error in the driver's code at all (or maybe
this is not a problem, just noise in the log).

Helen
---
 drivers/media/v4l2-core/v4l2-subdev.c | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index da78497..1a642c7 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -508,6 +508,44 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 	    || source_fmt->format.code != sink_fmt->format.code)
 		return -EPIPE;
 
+	/*
+	 * TODO: return -EPIPE instead of printing a warning in the following
+	 * checks. As colorimetry properties were added after most of the
+	 * drivers, only a warning was added to avoid potential regressions
+	 */
+
+	/* colorspace match. */
+	if (source_fmt->format.colorspace != sink_fmt->format.colorspace)
+		dev_warn(sd->v4l2_dev->dev,
+			 "colorspace doesn't match in link \"%s\":%d->\"%s\":%d\n",
+			link->source->entity->name, link->source->index,
+			link->sink->entity->name, link->sink->index);
+
+	/* Colorimetry must match if they are not set to DEFAULT */
+	if (source_fmt->format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
+	    && sink_fmt->format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
+	    && source_fmt->format.ycbcr_enc != sink_fmt->format.ycbcr_enc)
+		dev_warn(sd->v4l2_dev->dev,
+			 "YCbCr encoding doesn't match in link \"%s\":%d->\"%s\":%d\n",
+			link->source->entity->name, link->source->index,
+			link->sink->entity->name, link->sink->index);
+
+	if (source_fmt->format.quantization != V4L2_QUANTIZATION_DEFAULT
+	    && sink_fmt->format.quantization != V4L2_QUANTIZATION_DEFAULT
+	    && source_fmt->format.quantization != sink_fmt->format.quantization)
+		dev_warn(sd->v4l2_dev->dev,
+			 "quantization doesn't match in link \"%s\":%d->\"%s\":%d\n",
+			link->source->entity->name, link->source->index,
+			link->sink->entity->name, link->sink->index);
+
+	if (source_fmt->format.xfer_func != V4L2_XFER_FUNC_DEFAULT
+	    && sink_fmt->format.xfer_func != V4L2_XFER_FUNC_DEFAULT
+	    && source_fmt->format.xfer_func != sink_fmt->format.xfer_func)
+		dev_warn(sd->v4l2_dev->dev,
+			 "transfer function doesn't match in link \"%s\":%d->\"%s\":%d\n",
+			link->source->entity->name, link->source->index,
+			link->sink->entity->name, link->sink->index);
+
 	/* The field order must match, or the sink field order must be NONE
 	 * to support interlaced hardware connected to bridges that support
 	 * progressive formats only.
-- 
2.7.4

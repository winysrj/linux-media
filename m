Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55292 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbeJSAKd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 20:10:33 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 1/2] vicodec: Have decoder propagate changes to the CAPTURE queue
Date: Thu, 18 Oct 2018 13:08:40 -0300
Message-Id: <20181018160841.17674-2-ezequiel@collabora.com>
In-Reply-To: <20181018160841.17674-1-ezequiel@collabora.com>
References: <20181018160841.17674-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The decoder interface (not yet merged) specifies that
width and height values set on the OUTPUT queue, must
be propagated to the CAPTURE queue.

This is not enough to comply with the specification,
which would require to properly support stream resolution
changes detection and notification.

However, it's a relatively small change, which fixes behavior
required by some applications such as gstreamer.

With this change, it's possible to run a simple T(T⁻¹) pipeline:

gst-launch-1.0 videotestsrc ! v4l2fwhtenc ! v4l2fwhtdec ! fakevideosink

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 1eb9132bfc85..a2c487b4b80d 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -673,6 +673,13 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		q_data->width = pix->width;
 		q_data->height = pix->height;
 		q_data->sizeimage = pix->sizeimage;
+
+		/* Propagate changes to CAPTURE queue */
+		if (!ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type)) {
+			ctx->q_data[V4L2_M2M_DST].width = pix->width;
+			ctx->q_data[V4L2_M2M_DST].height = pix->height;
+			ctx->q_data[V4L2_M2M_DST].sizeimage = pix->sizeimage;
+		}
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
@@ -693,6 +700,14 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		q_data->width = pix_mp->width;
 		q_data->height = pix_mp->height;
 		q_data->sizeimage = pix_mp->plane_fmt[0].sizeimage;
+
+		/* Propagate changes to CAPTURE queue */
+		if (!ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type)) {
+			ctx->q_data[V4L2_M2M_DST].width = pix_mp->width;
+			ctx->q_data[V4L2_M2M_DST].height = pix_mp->height;
+			ctx->q_data[V4L2_M2M_DST].sizeimage =
+				pix_mp->plane_fmt[0].sizeimage;
+		}
 		break;
 	default:
 		return -EINVAL;
-- 
2.19.1

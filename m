Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35052 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbeKCBAQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:00:16 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 3/4] vicodec: Propagate changes to the CAPTURE queue
Date: Fri,  2 Nov 2018 12:52:05 -0300
Message-Id: <20181102155206.13681-4-ezequiel@collabora.com>
In-Reply-To: <20181102155206.13681-1-ezequiel@collabora.com>
References: <20181102155206.13681-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For stateful codecs, width and height values set
on the OUTPUT queue, must be propagated to the CAPTURE queue.

This is not enough to fully comply with the specification,
which would require to properly support stream resolution
changes detection and notification.

However, it's a relatively small change, which fixes behavior
required by some applications such as gstreamer.

With this change, it's possible to run a simple T(T⁻¹) pipeline:

gst-launch-1.0 videotestsrc ! v4l2fwhtenc ! v4l2fwhtdec ! fakevideosink

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index dbc8b68894e7..cffd41c3fc17 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -636,6 +636,17 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		q_data->width = pix->width;
 		q_data->height = pix->height;
 		q_data->sizeimage = pix->sizeimage;
+
+		/* Propagate changes to CAPTURE queue */
+		if (V4L2_TYPE_IS_OUTPUT(f->type)) {
+			struct v4l2_pix_format dst_pix;
+
+			v4l2_fill_pixfmt(&dst_pix, ctx->q_data[V4L2_M2M_DST].info->id,
+					pix->width, pix->height);
+			ctx->q_data[V4L2_M2M_DST].width = pix->width;
+			ctx->q_data[V4L2_M2M_DST].height = pix->height;
+			ctx->q_data[V4L2_M2M_DST].sizeimage = dst_pix.sizeimage;
+		}
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
@@ -656,6 +667,17 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		q_data->width = pix_mp->width;
 		q_data->height = pix_mp->height;
 		q_data->sizeimage = pix_mp->plane_fmt[0].sizeimage;
+
+		/* Propagate changes to CAPTURE queue */
+		if (V4L2_TYPE_IS_OUTPUT(f->type)) {
+			struct v4l2_pix_format_mplane dst_pix;
+
+			v4l2_fill_pixfmt_mp(&dst_pix, ctx->q_data[V4L2_M2M_DST].info->id,
+					pix_mp->width, pix_mp->height);
+			ctx->q_data[V4L2_M2M_DST].width = pix_mp->width;
+			ctx->q_data[V4L2_M2M_DST].height = pix_mp->height;
+			ctx->q_data[V4L2_M2M_DST].sizeimage = dst_pix.plane_fmt[0].sizeimage;
+		}
 		break;
 	default:
 		return -EINVAL;
-- 
2.19.1

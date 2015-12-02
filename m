Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:53983 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758877AbbLBRAV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2015 12:00:21 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5/5] [media] coda: enable MPEG-2 ES decoding
Date: Wed,  2 Dec 2015 17:58:54 +0100
Message-Id: <1449075534-8072-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1449075534-8072-1-git-send-email-p.zabel@pengutronix.de>
References: <1449075534-8072-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hook up the MPEG-2 ES decoder.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 2452f46..2197032 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -131,6 +131,7 @@ static const struct coda_codec coda7_codecs[] = {
 	CODA_CODEC(CODA7_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1280, 720),
 	CODA_CODEC(CODA7_MODE_ENCODE_MJPG, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_JPEG,   8192, 8192),
 	CODA_CODEC(CODA7_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1088),
+	CODA_CODEC(CODA7_MODE_DECODE_MP2,  V4L2_PIX_FMT_MPEG2,  V4L2_PIX_FMT_YUV420, 1920, 1088),
 	CODA_CODEC(CODA7_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1088),
 	CODA_CODEC(CODA7_MODE_DECODE_MJPG, V4L2_PIX_FMT_JPEG,   V4L2_PIX_FMT_YUV420, 8192, 8192),
 };
@@ -139,6 +140,7 @@ static const struct coda_codec coda9_codecs[] = {
 	CODA_CODEC(CODA9_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1920, 1088),
 	CODA_CODEC(CODA9_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1920, 1088),
 	CODA_CODEC(CODA9_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1088),
+	CODA_CODEC(CODA9_MODE_DECODE_MP2,  V4L2_PIX_FMT_MPEG2,  V4L2_PIX_FMT_YUV420, 1920, 1088),
 	CODA_CODEC(CODA9_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1088),
 };
 
@@ -187,6 +189,7 @@ static const struct coda_video_device coda_bit_decoder = {
 	.ops = &coda_bit_decode_ops,
 	.src_formats = {
 		V4L2_PIX_FMT_H264,
+		V4L2_PIX_FMT_MPEG2,
 		V4L2_PIX_FMT_MPEG4,
 	},
 	.dst_formats = {
@@ -470,6 +473,7 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 		/* fallthrough */
 	case V4L2_PIX_FMT_H264:
 	case V4L2_PIX_FMT_MPEG4:
+	case V4L2_PIX_FMT_MPEG2:
 		f->fmt.pix.bytesperline = 0;
 		f->fmt.pix.sizeimage = coda_estimate_sizeimage(ctx,
 							f->fmt.pix.sizeimage,
-- 
2.6.2


Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52233 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaHERAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:42 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 09/15] [media] coda: increase max vertical frame size to 1088
Date: Tue,  5 Aug 2014 19:00:14 +0200
Message-Id: <1407258020-12078-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch increases the maximum vertical frame size reported
by enum_fmt and accepted by try_fmt/s_fmt from 1080 to 1088.
Since for 16x16-pixel macroblocks 1080p will be rounded up to
this anyway, we may as well admit that we support it.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 3bf30b8..6020e33 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -39,7 +39,6 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "coda.h"
-#include "coda_regs.h"
 
 #define CODA_NAME		"coda"
 
@@ -122,15 +121,15 @@ static const struct coda_codec codadx6_codecs[] = {
 static const struct coda_codec coda7_codecs[] = {
 	CODA_CODEC(CODA7_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1280, 720),
 	CODA_CODEC(CODA7_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1280, 720),
-	CODA_CODEC(CODA7_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1080),
-	CODA_CODEC(CODA7_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1080),
+	CODA_CODEC(CODA7_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1088),
+	CODA_CODEC(CODA7_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1088),
 };
 
 static const struct coda_codec coda9_codecs[] = {
-	CODA_CODEC(CODA9_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1920, 1080),
-	CODA_CODEC(CODA9_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1920, 1080),
-	CODA_CODEC(CODA9_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1080),
-	CODA_CODEC(CODA9_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1080),
+	CODA_CODEC(CODA9_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1920, 1088),
+	CODA_CODEC(CODA9_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1920, 1088),
+	CODA_CODEC(CODA9_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1088),
+	CODA_CODEC(CODA9_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1088),
 };
 
 static bool coda_format_is_yuv(u32 fourcc)
-- 
2.0.1


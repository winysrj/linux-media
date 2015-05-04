Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:36479 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbEDIHk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 04:07:40 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/4] media/vivid: Add support for Y16 format
Date: Mon,  4 May 2015 10:07:29 +0200
Message-Id: <1430726852-11715-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for V4L2_PIX_FMT_Y16, a 16 bit greyscale format.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 9 ++++++++-
 drivers/media/platform/vivid/vivid-vid-common.c | 8 ++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 4df755aa7e48..9e50303a19c5 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -220,6 +220,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_ABGR32:
 	case V4L2_PIX_FMT_GREY:
+	case V4L2_PIX_FMT_Y16:
 		tpg->is_yuv = false;
 		break;
 	case V4L2_PIX_FMT_YUV444:
@@ -313,6 +314,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_YUV444:
 	case V4L2_PIX_FMT_YUV555:
 	case V4L2_PIX_FMT_YUV565:
+	case V4L2_PIX_FMT_Y16:
 		tpg->twopixelsize[0] = 2 * 2;
 		break;
 	case V4L2_PIX_FMT_RGB24:
@@ -712,7 +714,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		g <<= 4;
 		b <<= 4;
 	}
-	if (tpg->qual == TPG_QUAL_GRAY || tpg->fourcc == V4L2_PIX_FMT_GREY) {
+	if (tpg->qual == TPG_QUAL_GRAY || tpg->fourcc == V4L2_PIX_FMT_GREY ||
+	    tpg->fourcc == V4L2_PIX_FMT_Y16) {
 		/* Rec. 709 Luma function */
 		/* (0.2126, 0.7152, 0.0722) * (255 * 256) */
 		r = g = b = (13879 * r + 46688 * g + 4713 * b) >> 16;
@@ -895,6 +898,10 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_GREY:
 		buf[0][offset] = r_y;
 		break;
+	case V4L2_PIX_FMT_Y16:
+		buf[0][offset] = 0;
+		buf[0][offset+1] = r_y;
+		break;
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YUV420M:
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 6ba874420485..96ccd3c38dd2 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -189,6 +189,14 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
+		.fourcc   = V4L2_PIX_FMT_Y16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.is_yuv   = true,
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
 		.fourcc   = V4L2_PIX_FMT_RGB332, /* rrrgggbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 8 },
-- 
2.1.4


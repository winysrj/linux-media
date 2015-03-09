Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:35261 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbbCIPrh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:47:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 17/29] vivid-tpg: add support for V4L2_PIX_FMT_GREY
Date: Mon,  9 Mar 2015 16:44:39 +0100
Message-Id: <1425915891-1017-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add monochrome support to the TPG.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 19b5806..766cbf5 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -199,6 +199,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_XBGR32:
 	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_ABGR32:
+	case V4L2_PIX_FMT_GREY:
 		tpg->is_yuv = false;
 		break;
 	case V4L2_PIX_FMT_YUV420M:
@@ -279,6 +280,9 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_ABGR32:
 		tpg->twopixelsize[0] = 2 * 4;
 		break;
+	case V4L2_PIX_FMT_GREY:
+		tpg->twopixelsize[0] = 2;
+		break;
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV12M:
@@ -598,7 +602,7 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		g <<= 4;
 		b <<= 4;
 	}
-	if (tpg->qual == TPG_QUAL_GRAY) {
+	if (tpg->qual == TPG_QUAL_GRAY || tpg->fourcc == V4L2_PIX_FMT_GREY) {
 		/* Rec. 709 Luma function */
 		/* (0.2126, 0.7152, 0.0722) * (255 * 256) */
 		r = g = b = (13879 * r + 46688 * g + 4713 * b) >> 16;
@@ -739,6 +743,9 @@ static void gen_twopix(struct tpg_data *tpg,
 	b_v = tpg->colors[color][2]; /* B or precalculated V */
 
 	switch (tpg->fourcc) {
+	case V4L2_PIX_FMT_GREY:
+		buf[0][offset] = r_y;
+		break;
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YUV420M:
-- 
2.1.4


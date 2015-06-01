Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44623 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbbFAHGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 03:06:05 -0400
Message-ID: <556C0455.30101@xs4all.nl>
Date: Mon, 01 Jun 2015 09:05:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] Improve Y16 color setup
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the colors for the Y16 and Y16_BE pixelformats are in the range
0x0000-0xff00. So pure white (0xffff) is never created.

Improve this by using the same byte for both LSB and MSB so the full range
is achieved.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index b1147f2..e28f32b 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -896,16 +896,12 @@ static void gen_twopix(struct tpg_data *tpg,
 	b_v = tpg->colors[color][2]; /* B or precalculated V */
 
 	switch (tpg->fourcc) {
-	case V4L2_PIX_FMT_GREY:
-		buf[0][offset] = r_y;
-		break;
 	case V4L2_PIX_FMT_Y16:
-		buf[0][offset] = 0;
-		buf[0][offset+1] = r_y;
-		break;
 	case V4L2_PIX_FMT_Y16_BE:
+		buf[0][offset+1] = r_y;
+		/* fall through */
+	case V4L2_PIX_FMT_GREY:
 		buf[0][offset] = r_y;
-		buf[0][offset+1] = 0;
 		break;
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:

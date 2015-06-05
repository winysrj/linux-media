Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52519 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932204AbbFEGpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 02:45:50 -0400
Message-ID: <55714592.8090902@xs4all.nl>
Date: Fri, 05 Jun 2015 08:45:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv2] Improve Y16 color setup
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the colors for the Y16 and Y16_BE pixelformats are in the range
0x0000-0xff00. So pure white (0xffff) is never created.

Improve this by making white really white. For other colors the lsb remains 0
so vivid can be used to detect endian problems.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index b1147f2..1b94503 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -900,12 +900,19 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset] = r_y;
 		break;
 	case V4L2_PIX_FMT_Y16:
-		buf[0][offset] = 0;
+		/*
+		 * Ideally both bytes should be set to r_y, but then you won't
+		 * be able to detect endian problems. So keep it 0 except for
+		 * the corner case where r_y is 0xff so white really will be
+		 * white (0xffff).
+		 */
+		buf[0][offset] = r_y == 0xff ? r_y : 0;
 		buf[0][offset+1] = r_y;
 		break;
 	case V4L2_PIX_FMT_Y16_BE:
+		/* See comment for V4L2_PIX_FMT_Y16 above */
 		buf[0][offset] = r_y;
-		buf[0][offset+1] = 0;
+		buf[0][offset+1] = r_y == 0xff ? r_y : 0;
 		break;
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:

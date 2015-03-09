Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37375 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754315AbbCIPq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:46:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/29] vivid-tpg: correctly average the two pixels in gen_twopix()
Date: Mon,  9 Mar 2015 16:44:35 +0100
Message-Id: <1425915891-1017-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

gen_twopix() is always called twice: once for the first and once for
the second pixel. Improve the code to properly average the two if the
format requires horizontal downsampling.

This is necessary for patterns like 1x1 red/blue checkers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 48 ++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index d7531d3..9001b9a 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -687,28 +687,64 @@ static void gen_twopix(struct tpg_data *tpg,
 	switch (tpg->fourcc) {
 	case V4L2_PIX_FMT_NV16M:
 		buf[0][offset] = r_y;
-		buf[1][offset] = odd ? b_v : g_u;
+		if (odd) {
+			buf[1][0] = (buf[1][0] + g_u) / 2;
+			buf[1][1] = (buf[1][1] + b_v) / 2;
+			break;
+		}
+		buf[1][0] = g_u;
+		buf[1][1] = b_v;
 		break;
 	case V4L2_PIX_FMT_NV61M:
 		buf[0][offset] = r_y;
-		buf[1][offset] = odd ? g_u : b_v;
+		if (odd) {
+			buf[1][0] = (buf[1][0] + b_v) / 2;
+			buf[1][1] = (buf[1][1] + g_u) / 2;
+			break;
+		}
+		buf[1][0] = b_v;
+		buf[1][1] = g_u;
 		break;
 
 	case V4L2_PIX_FMT_YUYV:
 		buf[0][offset] = r_y;
-		buf[0][offset + 1] = odd ? b_v : g_u;
+		if (odd) {
+			buf[0][1] = (buf[0][1] + g_u) / 2;
+			buf[0][3] = (buf[0][3] + b_v) / 2;
+			break;
+		}
+		buf[0][1] = g_u;
+		buf[0][3] = b_v;
 		break;
 	case V4L2_PIX_FMT_UYVY:
-		buf[0][offset] = odd ? b_v : g_u;
 		buf[0][offset + 1] = r_y;
+		if (odd) {
+			buf[0][0] = (buf[0][0] + g_u) / 2;
+			buf[0][2] = (buf[0][2] + b_v) / 2;
+			break;
+		}
+		buf[0][0] = g_u;
+		buf[0][2] = b_v;
 		break;
 	case V4L2_PIX_FMT_YVYU:
 		buf[0][offset] = r_y;
-		buf[0][offset + 1] = odd ? g_u : b_v;
+		if (odd) {
+			buf[0][1] = (buf[0][1] + b_v) / 2;
+			buf[0][3] = (buf[0][3] + g_u) / 2;
+			break;
+		}
+		buf[0][1] = b_v;
+		buf[0][3] = g_u;
 		break;
 	case V4L2_PIX_FMT_VYUY:
-		buf[0][offset] = odd ? g_u : b_v;
 		buf[0][offset + 1] = r_y;
+		if (odd) {
+			buf[0][0] = (buf[0][0] + b_v) / 2;
+			buf[0][2] = (buf[0][2] + g_u) / 2;
+			break;
+		}
+		buf[0][0] = b_v;
+		buf[0][2] = g_u;
 		break;
 	case V4L2_PIX_FMT_RGB565:
 		buf[0][offset] = (g_u << 5) | b_v;
-- 
2.1.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:16934 "EHLO
	mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbbERRyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 13:54:45 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1 linux-next] omap_vout: use swap() in omapvid_init()
Date: Mon, 18 May 2015 19:54:17 +0200
Message-Id: <1431971658-20986-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kernel.h macro definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/platform/omap/omap_vout.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 17b189a..f09c5f1 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -445,7 +445,7 @@ static int omapvid_init(struct omap_vout_device *vout, u32 addr)
 	int ret = 0, i;
 	struct v4l2_window *win;
 	struct omap_overlay *ovl;
-	int posx, posy, outw, outh, temp;
+	int posx, posy, outw, outh;
 	struct omap_video_timings *timing;
 	struct omapvideo_info *ovid = &vout->vid_info;
 
@@ -468,9 +468,7 @@ static int omapvid_init(struct omap_vout_device *vout, u32 addr)
 			/* Invert the height and width for 90
 			 * and 270 degree rotation
 			 */
-			temp = outw;
-			outw = outh;
-			outh = temp;
+			swap(outw, outh);
 			posy = (timing->y_res - win->w.width) - win->w.left;
 			posx = win->w.top;
 			break;
@@ -481,9 +479,7 @@ static int omapvid_init(struct omap_vout_device *vout, u32 addr)
 			break;
 
 		case dss_rotation_270_degree:
-			temp = outw;
-			outw = outh;
-			outh = temp;
+			swap(outw, outh);
 			posy = win->w.left;
 			posx = (timing->x_res - win->w.height) - win->w.top;
 			break;
-- 
2.4.0


Return-path: <mchehab@pedra>
Received: from p5498B625.dip.t-dialin.net ([84.152.182.37]:54654 "EHLO
	obermaier-johannes.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751282Ab1FBPI3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 11:08:29 -0400
From: Johannes Obermaier <johannes.obermaier@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Johannes Obermaier <johannes.obermaier@gmail.com>
Subject: [PATCH 1/1] V4L/DVB: mt9v011: Fixed incorrect value for the first valid column
Date: Thu,  2 Jun 2011 17:07:35 +0200
Message-Id: <1307027255-30189-1-git-send-email-johannes.obermaier@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

According to the datasheet (page 8), the first optical clear pixel-column is not at position 14. The correct/recommended value is 20. Without this patch there is a dark line on the left side of the image.

Signed-off-by: Johannes Obermaier <johannes.obermaier@gmail.com>
---
 drivers/media/video/mt9v011.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9v011.c b/drivers/media/video/mt9v011.c
index 4904d25..a6cf05a 100644
--- a/drivers/media/video/mt9v011.c
+++ b/drivers/media/video/mt9v011.c
@@ -286,7 +286,7 @@ static void set_res(struct v4l2_subdev *sd)
 	 * be missing.
 	 */
 
-	hstart = 14 + (640 - core->width) / 2;
+	hstart = 20 + (640 - core->width) / 2;
 	mt9v011_write(sd, R02_MT9V011_COLSTART, hstart);
 	mt9v011_write(sd, R04_MT9V011_WIDTH, core->width);
 	mt9v011_write(sd, R05_MT9V011_HBLANK, 771 - core->width);
-- 
1.6.4.2


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:56998 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbbBHW3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2015 17:29:15 -0500
From: Luis de Bethencourt <luis@debethencourt.com>
Date: Sun, 8 Feb 2015 22:29:11 +0000
To: linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	mchehab@osg.samsung.com, gregkh@linuxfoundation.org,
	hans.verkuil@cisco.com, pavel@ucw.cz, pali.rohar@gmail.com,
	wsa@the-dreams.de, luke.hart@birchleys.eu, askb23@gmail.com
Subject: [PATCH] media: bcm2048: remove unused return of function
Message-ID: <20150208222911.GA18445@turing>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Integer return of bcm2048_parse_rds_rt () is never used, changing the return
type to void.

Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 5382506..7f3d528 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -1579,7 +1579,7 @@ static void bcm2048_parse_rt_match_d(struct bcm2048_device *bdev, int i,
 		bcm2048_parse_rds_rt_block(bdev, i, index+2, crc);
 }
 
-static int bcm2048_parse_rds_rt(struct bcm2048_device *bdev)
+static void bcm2048_parse_rds_rt(struct bcm2048_device *bdev)
 {
 	int i, index = 0, crc, match_b = 0, match_c = 0, match_d = 0;
 
@@ -1615,8 +1615,6 @@ static int bcm2048_parse_rds_rt(struct bcm2048_device *bdev)
 					match_b = 1;
 		}
 	}
-
-	return 0;
 }
 
 static void bcm2048_parse_rds_ps_block(struct bcm2048_device *bdev, int i,
-- 
2.1.0


Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58435 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2BZD1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 22:27:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH 09/11] mt9m032: Remove unneeded register read
Date: Sun, 26 Feb 2012 04:27:35 +0100
Message-Id: <1330226857-8651-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's not need to read register MT9M032_READ_MODE1 when setting up the
PLL. Remove the read call.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index b636ad4..8109bf1 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -223,7 +223,7 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
 	unsigned int pre_div;
 	unsigned int pll_out_div;
 	unsigned int pll_mul;
-	int res, ret;
+	int ret;
 
 	pre_div = 6;
 
@@ -244,9 +244,6 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
 							/* more reserved, Continuous */
 							/* Master Mode */
 	if (!ret)
-		res = mt9m032_read_reg(client, MT9M032_READ_MODE1);
-
-	if (!ret)
 		ret = mt9m032_write_reg(client, MT9M032_FORMATTER1, 0x111e);
 					/* Set 14-bit mode, select 7 divider */
 
-- 
1.7.3.4


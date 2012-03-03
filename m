Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33412 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2CCP2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2012 10:28:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 08/10] mt9m032: Remove unneeded register read
Date: Sat,  3 Mar 2012 16:28:13 +0100
Message-Id: <1330788495-18762-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's not need to read register MT9M032_READ_MODE1 when setting up the
PLL. Remove the read call.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index 6bd4280..4cde779 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -226,7 +226,7 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
 	struct mt9m032_platform_data* pdata = sensor->pdata;
 	u16 reg_pll1;
 	unsigned int pre_div;
-	int res, ret;
+	int ret;
 
 	/* TODO: also support other pre-div values */
 	if (pdata->pll_pre_div != 6) {
@@ -253,9 +253,6 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
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


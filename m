Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42214 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaBJVxw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 16:53:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH 4/5] mt9p031: Fix typo in comment
Date: Mon, 10 Feb 2014 22:54:43 +0100
Message-Id: <1392069284-18024-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1392069284-18024-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392069284-18024-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 05278f5..14a616e 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -288,7 +288,7 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 	if (ret < 0)
 		return ret;
 
-	/* Emable clock */
+	/* Enable clock */
 	if (mt9p031->clk) {
 		ret = clk_prepare_enable(mt9p031->clk);
 		if (ret) {
-- 
1.8.3.2


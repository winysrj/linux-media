Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33799 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab2JRNa5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Oct 2012 09:30:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] smiapp-pll: Add missing trailing newlines to warning messages
Date: Thu, 18 Oct 2012 15:31:44 +0200
Message-Id: <1350567104-6533-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two warning messages are missing a trailing newline. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/smiapp-pll.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index a577614..169f305 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -194,7 +194,7 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 
 	if (more_mul_min > more_mul_max) {
 		dev_warn(dev,
-			 "unable to compute more_mul_min and more_mul_max");
+			 "unable to compute more_mul_min and more_mul_max\n");
 		return -EINVAL;
 	}
 
@@ -209,7 +209,7 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 
 	dev_dbg(dev, "final more_mul: %d\n", i);
 	if (i > more_mul_max) {
-		dev_warn(dev, "final more_mul is bad, max %d", more_mul_max);
+		dev_warn(dev, "final more_mul is bad, max %d\n", more_mul_max);
 		return -EINVAL;
 	}
 
-- 
1.7.8.6


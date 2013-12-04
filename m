Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab3LDA4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:32 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CBE8E36401
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:39 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 12/25] v4l: omap4iss: csi2: Enable automatic ULP mode transition
Date: Wed,  4 Dec 2013 01:56:12 +0100
Message-Id: <1386118585-12449-13-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Automatically switch between ULP and ON states based on ULPM signal from
complex I/O.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_csiphy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c b/drivers/staging/media/omap4iss/iss_csiphy.c
index 25e6f89..d5c7cec 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.c
+++ b/drivers/staging/media/omap4iss/iss_csiphy.c
@@ -63,8 +63,8 @@ static int csiphy_set_power(struct iss_csiphy *phy, u32 power)
 
 	writel((readl(phy->cfg_regs + CSI2_COMPLEXIO_CFG) &
 		~CSI2_COMPLEXIO_CFG_PWD_CMD_MASK) |
-		power,
-		phy->cfg_regs + CSI2_COMPLEXIO_CFG);
+	       power | CSI2_COMPLEXIO_CFG_PWR_AUTO,
+	       phy->cfg_regs + CSI2_COMPLEXIO_CFG);
 
 	retry_count = 0;
 	do {
-- 
1.8.3.2


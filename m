Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45611 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1LAAPP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 19:15:15 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<sakari.ailus@iki.fi>, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH v2 01/11] TWL6030: Add mapping for auxiliary regs
Date: Wed, 30 Nov 2011 18:14:50 -0600
Message-ID: <1322698500-29924-2-git-send-email-saaguirre@ti.com>
In-Reply-To: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/mfd/twl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index bfbd660..e26b564 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -323,7 +323,7 @@ static struct twl_mapping twl6030_map[] = {
 	{ SUB_CHIP_ID0, TWL6030_BASEADD_ZERO },
 	{ SUB_CHIP_ID1, TWL6030_BASEADD_ZERO },
 
-	{ SUB_CHIP_ID2, TWL6030_BASEADD_ZERO },
+	{ SUB_CHIP_ID1, TWL6030_BASEADD_AUX },
 	{ SUB_CHIP_ID2, TWL6030_BASEADD_ZERO },
 	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
 	{ SUB_CHIP_ID2, TWL6030_BASEADD_RSV },
-- 
1.7.7.4


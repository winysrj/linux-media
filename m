Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37795 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab0BWIel (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 03:34:41 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V1 04/10] AM3517 CCDC: Debug register read prints removed
Date: Tue, 23 Feb 2010 14:04:27 +0530
Message-Id: <1266914073-30135-5-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/ti-media/dm644x_ccdc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ti-media/dm644x_ccdc.c b/drivers/media/video/ti-media/dm644x_ccdc.c
index 727f7e1..a011d40 100644
--- a/drivers/media/video/ti-media/dm644x_ccdc.c
+++ b/drivers/media/video/ti-media/dm644x_ccdc.c
@@ -434,7 +434,6 @@ void ccdc_config_ycbcr(void)

 	ccdc_sbl_reset();
 	dev_dbg(ccdc_cfg.dev, "\nEnd of ccdc_config_ycbcr...\n");
-	ccdc_readregs();
 }

 static void ccdc_config_black_clamp(struct ccdc_black_clamp *bclamp)
--
1.6.2.4


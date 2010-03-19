Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47808 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0CSGEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 02:04:21 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o2J64ISX010387
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 01:04:20 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V2 1/7] AM3517 CCDC: Debug register read prints removed
Date: Fri, 19 Mar 2010 11:34:07 +0530
Message-Id: <1268978653-32710-2-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/davinci/dm644x_ccdc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index 0c394ca..840eee9 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -434,7 +434,6 @@ void ccdc_config_ycbcr(void)

 	ccdc_sbl_reset();
 	dev_dbg(ccdc_cfg.dev, "\nEnd of ccdc_config_ycbcr...\n");
-	ccdc_readregs();
 }

 static void ccdc_config_black_clamp(struct ccdc_black_clamp *bclamp)
--
1.6.2.4


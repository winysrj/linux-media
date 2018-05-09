Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50542 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935548AbeEIUbc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 16:31:32 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org, maxime.ripard@bootlin.com
Subject: [PATCH 1/1] cadence: csi2rx: Fix csi2rx_start error handling
Date: Wed,  9 May 2018 23:31:30 +0300
Message-Id: <20180509203130.12852-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clocks enabled by csi2rx_start function are intended to be disabled in
an error path but there are two issues:

1) the loop condition is always true and

2) the first clock disabled is the the one enabling of which failed.

Fix these two bugs by changing the loop condition as well as only disabling
the clocks that were actually enabled.

Reported-by: Mauro Chehab <mchehab@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Mauro, Maxime,

Let me know if you're happy with this. It's intended to fix the following
warnings (C=1 W=1):

drivers/media/platform/cadence/cdns-csi2rx.c: In function ‘csi2rx_start’:
drivers/media/platform/cadence/cdns-csi2rx.c:177:11: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]

 drivers/media/platform/cadence/cdns-csi2rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media/platform/cadence/cdns-csi2rx.c
index fe612ec1f99f..a0f02916006b 100644
--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -174,8 +174,8 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 	return 0;
 
 err_disable_pixclk:
-	for (; i >= 0; i--)
-		clk_disable_unprepare(csi2rx->pixel_clk[i]);
+	for (; i > 0; i--)
+		clk_disable_unprepare(csi2rx->pixel_clk[i - 1]);
 
 err_disable_pclk:
 	clk_disable_unprepare(csi2rx->p_clk);
-- 
2.11.0

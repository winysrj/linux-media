Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:51091 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753588AbdCOLbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 07:31:40 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Patrice Chotard <patrice.chotard@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 04/14] [media] st_rc: simplify optional reset handling
Date: Wed, 15 Mar 2017 12:31:36 +0100
Message-Id: <20170315113136.15147-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As of commit bb475230b8e5 ("reset: make optional functions really
optional"), the reset framework API calls use NULL pointers to describe
optional, non-present reset controls.

This allows to return errors from reset_control_get_optional and to call
reset_control_(de)assert unconditionally.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/media/rc/st_rc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index f0d7190e39195..0ac1879f75069 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -165,8 +165,7 @@ static void st_rc_hardware_init(struct st_rc_device *dev)
 	unsigned int rx_sampling_freq_div;
 
 	/* Enable the IP */
-	if (dev->rstc)
-		reset_control_deassert(dev->rstc);
+	reset_control_deassert(dev->rstc);
 
 	clk_prepare_enable(dev->sys_clock);
 	baseclock = clk_get_rate(dev->sys_clock);
@@ -281,10 +280,11 @@ static int st_rc_probe(struct platform_device *pdev)
 	else
 		rc_dev->rx_base = rc_dev->base;
 
-
 	rc_dev->rstc = reset_control_get_optional(dev, NULL);
-	if (IS_ERR(rc_dev->rstc))
-		rc_dev->rstc = NULL;
+	if (IS_ERR(rc_dev->rstc)) {
+		ret = PTR_ERR(rc_dev->rstc);
+		goto err;
+	}
 
 	rc_dev->dev = dev;
 	platform_set_drvdata(pdev, rc_dev);
@@ -352,8 +352,7 @@ static int st_rc_suspend(struct device *dev)
 		writel(0x00, rc_dev->rx_base + IRB_RX_EN);
 		writel(0x00, rc_dev->rx_base + IRB_RX_INT_EN);
 		clk_disable_unprepare(rc_dev->sys_clock);
-		if (rc_dev->rstc)
-			reset_control_assert(rc_dev->rstc);
+		reset_control_assert(rc_dev->rstc);
 	}
 
 	return 0;
-- 
2.11.0

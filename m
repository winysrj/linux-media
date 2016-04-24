Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35740 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbcDXVKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:31 -0400
Received: by mail-wm0-f67.google.com with SMTP id e201so17587634wme.2
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:30 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 17/24] smiapp: add CCP2 support
Date: Mon, 25 Apr 2016 00:08:17 +0300
Message-Id: <1461532104-24032-18-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sebastian Reichel <sre@kernel.org>

Add support for CCP2 connected SMIA sensors as found
on the Nokia N900.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index c6a897b..ec19532 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -3016,13 +3016,19 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	switch (bus_cfg->bus_type) {
 	case V4L2_MBUS_CSI2:
 		pdata->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
+		pdata->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
+		break;
+	case V4L2_MBUS_CCP2:
+		pdata->csi_signalling_mode = (bus_cfg->bus.mipi_csi1.strobe) ?
+		SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE :
+		SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK;
+		pdata->lanes = 1;
 		break;
-		/* FIXME: add CCP2 support. */
 	default:
+		dev_err(dev, "unknown bus protocol\n");
 		goto out_err;
 	}
 
-	pdata->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
 	dev_dbg(dev, "lanes %u\n", pdata->lanes);
 
 	/* xshutdown GPIO is optional */
@@ -3039,7 +3045,7 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 		goto out_err;
 	}
 
-	dev_dbg(dev, "reset %d, nvm %d, clk %d, csi %d\n", pdata->xshutdown,
+	dev_dbg(dev, "reset %d, nvm %d, clk %d, mode %d\n", pdata->xshutdown,
 		pdata->nvm_size, pdata->ext_clk, pdata->csi_signalling_mode);
 
 	if (!bus_cfg->nr_of_link_frequencies) {
-- 
1.9.1


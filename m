Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33263 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbcDXVKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:36 -0400
Received: by mail-wm0-f65.google.com with SMTP id r12so17689283wme.0
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:36 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [RFC PATCH 23/24] [media] omap3isp: Make sure CSI1 interface is enabled in CPP2 mode
Date: Mon, 25 Apr 2016 00:08:23 +0300
Message-Id: <1461532104-24032-24-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OMAP3430 needs various syscon CONTROL_CSIRXFE bits set in order to operate.
Implement the missing functionality.

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/media/platform/omap3isp/ispccp2.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 7bb7feb..833eed4 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -21,6 +21,7 @@
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/regulator/consumer.h>
+#include <linux/regmap.h>
 
 #include "isp.h"
 #include "ispreg.h"
@@ -160,6 +161,32 @@ static int ccp2_if_enable(struct isp_ccp2_device *ccp2, u8 enable)
 			return ret;
 	}
 
+	if (isp->revision == ISP_REVISION_2_0) {
+		struct media_pad *pad;
+		struct v4l2_subdev *sensor;
+		const struct isp_ccp2_cfg *buscfg;
+		u32 csirxfe;
+
+		pad = media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
+		sensor = media_entity_to_v4l2_subdev(pad->entity);
+		buscfg = &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
+
+
+		if (enable) {
+			csirxfe = OMAP343X_CONTROL_CSIRXFE_PWRDNZ |
+				  OMAP343X_CONTROL_CSIRXFE_RESET;
+
+			if (buscfg->phy_layer)
+				csirxfe |= OMAP343X_CONTROL_CSIRXFE_SELFORM;
+
+			if (buscfg->strobe_clk_pol)
+				csirxfe |= OMAP343X_CONTROL_CSIRXFE_CSIB_INV;
+		} else
+			csirxfe = 0;
+
+		regmap_write(isp->syscon, isp->syscon_offset, csirxfe);
+	}
+
 	/* Enable/Disable all the LCx channels */
 	for (i = 0; i < CCP2_LCx_CHANS_NUM; i++)
 		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCx_CTRL(i),
-- 
1.9.1


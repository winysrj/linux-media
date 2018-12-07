Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F5EC64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7514720837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7514720837
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbeLGN4p (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:56:45 -0500
Received: from mail.bootlin.com ([62.4.15.54]:58743 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbeLGN4D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 08:56:03 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id C6C0820CE3; Fri,  7 Dec 2018 14:56:01 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id C001F20CE8;
        Fri,  7 Dec 2018 14:55:43 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v3 06/10] phy: Move Allwinner A31 D-PHY driver to drivers/phy/
Date:   Fri,  7 Dec 2018 14:55:33 +0100
Message-Id: <20181207135541.30901-1-maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
References: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now that our MIPI D-PHY driver has been converted to the phy framework,
let's move it into the drivers/phy directory.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/sun4i/Kconfig                        | 10 +---------
 drivers/gpu/drm/sun4i/Makefile                       |  1 -
 drivers/phy/allwinner/Kconfig                        | 12 ++++++++++++
 drivers/phy/allwinner/Makefile                       |  1 +
 .../allwinner/phy-sun6i-mipi-dphy.c}                 |  0
 5 files changed, 14 insertions(+), 10 deletions(-)
 rename drivers/{gpu/drm/sun4i/sun6i_mipi_dphy.c => phy/allwinner/phy-sun6i-mipi-dphy.c} (100%)

diff --git a/drivers/gpu/drm/sun4i/Kconfig b/drivers/gpu/drm/sun4i/Kconfig
index 2b8db82c4bab..1dbbc3a1b763 100644
--- a/drivers/gpu/drm/sun4i/Kconfig
+++ b/drivers/gpu/drm/sun4i/Kconfig
@@ -45,20 +45,12 @@ config DRM_SUN6I_DSI
 	default MACH_SUN8I
 	select CRC_CCITT
 	select DRM_MIPI_DSI
-	select DRM_SUN6I_DPHY
+	select PHY_SUN6I_MIPI_DPHY
 	help
 	  Choose this option if you want have an Allwinner SoC with
 	  MIPI-DSI support. If M is selected the module will be called
 	  sun6i_mipi_dsi.
 
-config DRM_SUN6I_DPHY
-	tristate "Allwinner A31 MIPI D-PHY Support"
-	select GENERIC_PHY_MIPI_DPHY
-	help
-	  Choose this option if you have an Allwinner SoC with
-	  MIPI-DSI support. If M is selected, the module will be
-	  called sun6i_mipi_dphy.
-
 config DRM_SUN8I_DW_HDMI
 	tristate "Support for Allwinner version of DesignWare HDMI"
 	depends on DRM_SUN4I
diff --git a/drivers/gpu/drm/sun4i/Makefile b/drivers/gpu/drm/sun4i/Makefile
index 1e2320d824b5..0d04f2447b01 100644
--- a/drivers/gpu/drm/sun4i/Makefile
+++ b/drivers/gpu/drm/sun4i/Makefile
@@ -34,7 +34,6 @@ ifdef CONFIG_DRM_SUN4I_BACKEND
 obj-$(CONFIG_DRM_SUN4I)		+= sun4i-frontend.o
 endif
 obj-$(CONFIG_DRM_SUN4I_HDMI)	+= sun4i-drm-hdmi.o
-obj-$(CONFIG_DRM_SUN6I_DPHY)	+= sun6i_mipi_dphy.o
 obj-$(CONFIG_DRM_SUN6I_DSI)	+= sun6i_mipi_dsi.o
 obj-$(CONFIG_DRM_SUN8I_DW_HDMI)	+= sun8i-drm-hdmi.o
 obj-$(CONFIG_DRM_SUN8I_MIXER)	+= sun8i-mixer.o
diff --git a/drivers/phy/allwinner/Kconfig b/drivers/phy/allwinner/Kconfig
index cdc1e745ba47..fb1204bcc454 100644
--- a/drivers/phy/allwinner/Kconfig
+++ b/drivers/phy/allwinner/Kconfig
@@ -17,6 +17,18 @@ config PHY_SUN4I_USB
 	  This driver controls the entire USB PHY block, both the USB OTG
 	  parts, as well as the 2 regular USB 2 host PHYs.
 
+config PHY_SUN6I_MIPI_DPHY
+	tristate "Allwinner A31 MIPI D-PHY Support"
+	depends on ARCH_SUNXI && HAS_IOMEM && OF
+	depends on RESET_CONTROLLER
+	select GENERIC_PHY
+	select GENERIC_PHY_MIPI_DPHY
+	select REGMAP_MMIO
+	help
+	  Choose this option if you have an Allwinner SoC with
+	  MIPI-DSI support. If M is selected, the module will be
+	  called sun6i_mipi_dphy.
+
 config PHY_SUN9I_USB
 	tristate "Allwinner sun9i SoC USB PHY driver"
 	depends on ARCH_SUNXI && HAS_IOMEM && OF
diff --git a/drivers/phy/allwinner/Makefile b/drivers/phy/allwinner/Makefile
index 8605529c01a1..7d0053efbfaa 100644
--- a/drivers/phy/allwinner/Makefile
+++ b/drivers/phy/allwinner/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_PHY_SUN4I_USB)		+= phy-sun4i-usb.o
+obj-$(CONFIG_PHY_SUN6I_MIPI_DPHY)	+= phy-sun6i-mipi-dphy.o
 obj-$(CONFIG_PHY_SUN9I_USB)		+= phy-sun9i-usb.o
diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c b/drivers/phy/allwinner/phy-sun6i-mipi-dphy.c
similarity index 100%
rename from drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
rename to drivers/phy/allwinner/phy-sun6i-mipi-dphy.c
-- 
2.19.2


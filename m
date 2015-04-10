Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:57533 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbbDJUUg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 16:20:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Cc: Tero Kristo <t-kristo@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH] [media] omap4iss: avoid broken OMAP4 dependency
Date: Fri, 10 Apr 2015 22:20:20 +0200
Message-ID: <3292592.cickJMVhRq@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap4iss driver uses an interface that used to be provided
by OMAP4 but has now been removed and replaced with a WARN_ON(1)
statement, which likely broke the iss_csiphy code at runtime.

It also broke compiling the driver when CONFIG_ARCH_OMAP2PLUS
is set, which is implied by OMAP4:

drivers/staging/media/omap4iss/iss_csiphy.c: In function 'omap4iss_csiphy_config':
drivers/staging/media/omap4iss/iss_csiphy.c:167:2: error: implicit declaration of function 'omap4_ctrl_pad_writel' [-Werror=implicit-function-declaration]
  omap4_ctrl_pad_writel(cam_rx_ctrl,

In turn, this broke ARM allyesconfig builds. Replacing the
omap4_ctrl_pad_writel call with WARN_ON(1) won't make the
situation any worse than it already is, but fixes the build
problem.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: efde234674d9 ("ARM: OMAP4+: control: remove support for legacy pad read/write")
---
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c b/drivers/staging/media/omap4iss/iss_csiphy.c
index 7c3d55d811ef..24f56ed90ac3 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.c
+++ b/drivers/staging/media/omap4iss/iss_csiphy.c

@@ -140,9 +140,7 @@ int omap4iss_csiphy_config(struct iss_device *iss,
 	 * - bit [18] : CSIPHY1 CTRLCLK enable
 	 * - bit [17:16] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
 	 */
-	cam_rx_ctrl = omap4_ctrl_pad_readl(
-			OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX);
-
+	cam_rx_ctrl = WARN_ON(1);
 
 	if (subdevs->interface == ISS_INTERFACE_CSI2A_PHY1) {
 		cam_rx_ctrl &= ~(OMAP4_CAMERARX_CSI21_LANEENABLE_MASK |
@@ -166,8 +164,7 @@ int omap4iss_csiphy_config(struct iss_device *iss,
 		cam_rx_ctrl |= OMAP4_CAMERARX_CSI22_CTRLCLKEN_MASK;
 	}
 
-	omap4_ctrl_pad_writel(cam_rx_ctrl,
-		 OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX);
+	WARN_ON(1);
 
 	/* Reset used lane count */
 	csi2->phy->used_data_lanes = 0;


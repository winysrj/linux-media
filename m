Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:52472 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725198AbeIOEGv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 00:06:51 -0400
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: all-jpinto-org-pt02@synopsys.com,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 1/5] media: platform: Add DesignWare MIPI CSI2 Host placeholder
Date: Sat, 15 Sep 2018 00:48:37 +0200
Message-Id: <20180914224849.27173-2-lolivei@synopsys.com>
In-Reply-To: <20180914224849.27173-1-lolivei@synopsys.com>
References: <20180914224849.27173-1-lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch has the intention of make the patchseries more clear by creating
a dwc folder and a Kconfig variable that sets dependencies.

Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
---
 drivers/media/platform/Kconfig     |  1 +
 drivers/media/platform/Makefile    |  3 +++
 drivers/media/platform/dwc/Kconfig | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+)
 create mode 100644 drivers/media/platform/dwc/Kconfig

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f627587..f627a27 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -137,6 +137,7 @@ source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
 source "drivers/media/platform/rcar-vin/Kconfig"
 source "drivers/media/platform/atmel/Kconfig"
+source "drivers/media/platform/dwc/Kconfig"
 
 config VIDEO_TI_CAL
 	tristate "TI CAL (Camera Adaptation Layer) driver"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 6ab6200..def2f33 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -98,3 +98,6 @@ obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
 obj-y					+= meson/
 
 obj-y					+= cros-ec-cec/
+
+obj-y					+= dwc/
+
diff --git a/drivers/media/platform/dwc/Kconfig b/drivers/media/platform/dwc/Kconfig
new file mode 100644
index 0000000..6b1e985
--- /dev/null
+++ b/drivers/media/platform/dwc/Kconfig
@@ -0,0 +1,19 @@
+#
+#  Synopsys DWC Platform drivers
+#	Most drivers here are currently for MIPI CSI-2 and MIPI DPHY support
+
+config DWC_MIPI_CSI2_HOST
+	bool "Synopsys Designware CSI-2 Host Controller and DPHY-RX support"
+	select VIDEO_DEV
+	select VIDEO_V4L2
+	select VIDEO_V4L2_SUBDEV_API
+	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DMA_CONTIG
+	select GENERIC_PHY
+	select VIDEO_OV5647
+	help
+   	 This selects the CSI-2 host controller support.
+	 If you have a controller with this interface, say Y
+
+	  If unsure, say N.
+
-- 
2.9.3

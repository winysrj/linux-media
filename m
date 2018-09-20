Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:35838 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732512AbeITRCD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 13:02:03 -0400
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joao.Pinto@synopsys.com, festevam@gmail.com,
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
Subject: [V2, 1/5] media: platform: Add a DesignWare folder to have Synopsys drivers
Date: Thu, 20 Sep 2018 13:16:39 +0200
Message-Id: <20180920111648.27000-2-lolivei@synopsys.com>
In-Reply-To: <20180920111648.27000-1-lolivei@synopsys.com>
References: <20180920111648.27000-1-lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch has the intention of make the patch series more clear by creating
a dwc folder.

Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
---
Changelog
v2:
- Fix Kbuild error with no Makefile present

 drivers/media/platform/Kconfig      | 1 +
 drivers/media/platform/Makefile     | 3 +++
 drivers/media/platform/dwc/Kconfig  | 0
 drivers/media/platform/dwc/Makefile | 0
 4 files changed, 4 insertions(+)
 create mode 100644 drivers/media/platform/dwc/Kconfig
 create mode 100644 drivers/media/platform/dwc/Makefile

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
index 0000000..e69de29
diff --git a/drivers/media/platform/dwc/Makefile b/drivers/media/platform/dwc/Makefile
new file mode 100644
index 0000000..e69de29
-- 
2.9.3

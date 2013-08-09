Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54860 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031447Ab3HIXCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:22 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 01/19] OMAPDSS: panels: Rename Kconfig options to OMAP2_DISPLAY_*
Date: Sat, 10 Aug 2013 01:03:00 +0200
Message-Id: <1376089398-13322-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DISPLAY_ prefix will clash with the Common Display Framework, rename
it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/video/omap2/displays-new/Kconfig  | 24 ++++++++++++------------
 drivers/video/omap2/displays-new/Makefile | 24 ++++++++++++------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/video/omap2/displays-new/Kconfig b/drivers/video/omap2/displays-new/Kconfig
index 6c90885..2a44b41 100644
--- a/drivers/video/omap2/displays-new/Kconfig
+++ b/drivers/video/omap2/displays-new/Kconfig
@@ -1,68 +1,68 @@
 menu "OMAP Display Device Drivers (new device model)"
         depends on OMAP2_DSS
 
-config DISPLAY_ENCODER_TFP410
+config OMAP2_DISPLAY_ENCODER_TFP410
         tristate "TFP410 DPI to DVI Encoder"
 	help
 	  Driver for TFP410 DPI to DVI encoder.
 
-config DISPLAY_ENCODER_TPD12S015
+config OMAP2_DISPLAY_ENCODER_TPD12S015
         tristate "TPD12S015 HDMI ESD protection and level shifter"
 	help
 	  Driver for TPD12S015, which offers HDMI ESD protection and level
 	  shifting.
 
-config DISPLAY_CONNECTOR_DVI
+config OMAP2_DISPLAY_CONNECTOR_DVI
         tristate "DVI Connector"
 	depends on I2C
 	help
 	  Driver for a generic DVI connector.
 
-config DISPLAY_CONNECTOR_HDMI
+config OMAP2_DISPLAY_CONNECTOR_HDMI
         tristate "HDMI Connector"
 	help
 	  Driver for a generic HDMI connector.
 
-config DISPLAY_CONNECTOR_ANALOG_TV
+config OMAP2_DISPLAY_CONNECTOR_ANALOG_TV
         tristate "Analog TV Connector"
 	help
 	  Driver for a generic analog TV connector.
 
-config DISPLAY_PANEL_DPI
+config OMAP2_DISPLAY_PANEL_DPI
 	tristate "Generic DPI panel"
 	help
 	  Driver for generic DPI panels.
 
-config DISPLAY_PANEL_DSI_CM
+config OMAP2_DISPLAY_PANEL_DSI_CM
 	tristate "Generic DSI Command Mode Panel"
 	help
 	  Driver for generic DSI command mode panels.
 
-config DISPLAY_PANEL_SONY_ACX565AKM
+config OMAP2_DISPLAY_PANEL_SONY_ACX565AKM
 	tristate "ACX565AKM Panel"
 	depends on SPI && BACKLIGHT_CLASS_DEVICE
 	help
 	  This is the LCD panel used on Nokia N900
 
-config DISPLAY_PANEL_LGPHILIPS_LB035Q02
+config OMAP2_DISPLAY_PANEL_LGPHILIPS_LB035Q02
 	tristate "LG.Philips LB035Q02 LCD Panel"
 	depends on SPI
 	help
 	  LCD Panel used on the Gumstix Overo Palo35
 
-config DISPLAY_PANEL_SHARP_LS037V7DW01
+config OMAP2_DISPLAY_PANEL_SHARP_LS037V7DW01
         tristate "Sharp LS037V7DW01 LCD Panel"
         depends on BACKLIGHT_CLASS_DEVICE
         help
           LCD Panel used in TI's SDP3430 and EVM boards
 
-config DISPLAY_PANEL_TPO_TD043MTEA1
+config OMAP2_DISPLAY_PANEL_TPO_TD043MTEA1
         tristate "TPO TD043MTEA1 LCD Panel"
         depends on SPI
         help
           LCD Panel used in OMAP3 Pandora
 
-config DISPLAY_PANEL_NEC_NL8048HL11
+config OMAP2_DISPLAY_PANEL_NEC_NL8048HL11
 	tristate "NEC NL8048HL11 Panel"
 	depends on SPI
 	depends on BACKLIGHT_CLASS_DEVICE
diff --git a/drivers/video/omap2/displays-new/Makefile b/drivers/video/omap2/displays-new/Makefile
index 5aeb11b..768ad94 100644
--- a/drivers/video/omap2/displays-new/Makefile
+++ b/drivers/video/omap2/displays-new/Makefile
@@ -1,12 +1,12 @@
-obj-$(CONFIG_DISPLAY_ENCODER_TFP410) += encoder-tfp410.o
-obj-$(CONFIG_DISPLAY_ENCODER_TPD12S015) += encoder-tpd12s015.o
-obj-$(CONFIG_DISPLAY_CONNECTOR_DVI) += connector-dvi.o
-obj-$(CONFIG_DISPLAY_CONNECTOR_HDMI) += connector-hdmi.o
-obj-$(CONFIG_DISPLAY_CONNECTOR_ANALOG_TV) += connector-analog-tv.o
-obj-$(CONFIG_DISPLAY_PANEL_DPI) += panel-dpi.o
-obj-$(CONFIG_DISPLAY_PANEL_DSI_CM) += panel-dsi-cm.o
-obj-$(CONFIG_DISPLAY_PANEL_SONY_ACX565AKM) += panel-sony-acx565akm.o
-obj-$(CONFIG_DISPLAY_PANEL_LGPHILIPS_LB035Q02) += panel-lgphilips-lb035q02.o
-obj-$(CONFIG_DISPLAY_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o
-obj-$(CONFIG_DISPLAY_PANEL_TPO_TD043MTEA1) += panel-tpo-td043mtea1.o
-obj-$(CONFIG_DISPLAY_PANEL_NEC_NL8048HL11) += panel-nec-nl8048hl11.o
+obj-$(CONFIG_OMAP2_DISPLAY_ENCODER_TFP410) += encoder-tfp410.o
+obj-$(CONFIG_OMAP2_DISPLAY_ENCODER_TPD12S015) += encoder-tpd12s015.o
+obj-$(CONFIG_OMAP2_DISPLAY_CONNECTOR_DVI) += connector-dvi.o
+obj-$(CONFIG_OMAP2_DISPLAY_CONNECTOR_HDMI) += connector-hdmi.o
+obj-$(CONFIG_OMAP2_DISPLAY_CONNECTOR_ANALOG_TV) += connector-analog-tv.o
+obj-$(CONFIG_OMAP2_DISPLAY_PANEL_DPI) += panel-dpi.o
+obj-$(CONFIG_OMAP2_DISPLAY_PANEL_DSI_CM) += panel-dsi-cm.o
+obj-$(CONFIG_OMAP2_DISPLAY_PANEL_SONY_ACX565AKM) += panel-sony-acx565akm.o
+obj-$(CONFIG_OMAP2_DISPLAY_PANEL_LGPHILIPS_LB035Q02) += panel-lgphilips-lb035q02.o
+obj-$(CONFIG_OMAP2_DISPLAY_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o
+obj-$(CONFIG_OMAP2_DISPLAY_PANEL_TPO_TD043MTEA1) += panel-tpo-td043mtea1.o
+obj-$(CONFIG_OMAP2_DISPLAY_PANEL_NEC_NL8048HL11) += panel-nec-nl8048hl11.o
-- 
1.8.1.5


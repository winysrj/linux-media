Return-path: <mchehab@pedra>
Received: from blu0-omc2-s33.blu0.hotmail.com ([65.55.111.108]:15520 "EHLO
	blu0-omc2-s33.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab1FKI4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 04:56:19 -0400
Message-ID: <BLU0-SMTP64FB9E0850D1B2C42CF36DD8670@phx.gbl>
From: Manoel Pinheiro <pinusdtv@hotmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] [media] Add support for TBS-Tech ISDB-T Full Seg DTB08
Date: Sat, 11 Jun 2011 05:56:03 -0300
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
---
 drivers/media/dvb/dvb-usb/Kconfig  |    8 ++++++++
 drivers/media/dvb/dvb-usb/Makefile |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index e85304c..dd922c9 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -373,3 +373,11 @@ config DVB_USB_TECHNISAT_USB2
 	select DVB_STV6110x if !DVB_FE_CUSTOMISE
 	help
 	  Say Y here to support the Technisat USB2 DVB-S/S2 device
+
+config DVB_USB_TBSDTB08
+        tristate "TBS-Tech ISDB-T Full Seg DTB08 USB2.0 support"
+        depends on DVB_USB
+        select DVB_MB86A20S
+        select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
+        help
+          Say Y here to support the TBS-Tech Full Seg DTB08 ISDB-T USB2.0 receivers
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 4bac13d..bd449fa 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -94,6 +94,9 @@ obj-$(CONFIG_DVB_USB_LME2510) += dvb-usb-lmedm04.o
 dvb-usb-technisat-usb2-objs = technisat-usb2.o
 obj-$(CONFIG_DVB_USB_TECHNISAT_USB2) += dvb-usb-technisat-usb2.o
 
+dvb-usb-tbsdtb08-objs = tbs-dtb08.o
+obj-$(CONFIG_DVB_USB_TBSDTB08) += dvb-usb-tbsdtb08.o
+
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
 # due to tuner-xc3028
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
-- 
1.7.3.4


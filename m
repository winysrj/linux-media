Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:50822 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751082Ab1GCQ5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 12:57:41 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 06/16] DRX-K, TDA18271c2: Add build support
Date: Sun, 3 Jul 2011 18:51:43 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031851.44285@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add both drivers to Makefile and Kconfig.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/frontends/Kconfig  |   21 +++++++++++++++++++++
 drivers/media/dvb/frontends/Makefile |    3 +++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 44b816f..32e08e3 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -49,6 +49,27 @@ config DVB_STV6110x
 	help
 	  A Silicon tuner that supports DVB-S and DVB-S2 modes
 
+comment "Multistandard (cable + terrestrial) frontends"
+	depends on DVB_CORE
+
+config DVB_DRXK
+	tristate "Micronas DRXK based"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  Micronas DRX-K DVB-C/T demodulator.
+
+	  Say Y when you want to support this frontend.
+
+config DVB_TDA18271C2DD
+	tristate "NXP TDA18271C2 silicon tuner"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  NXP TDA18271 silicon tuner.
+
+	  Say Y when you want to support this tuner.
+
 comment "DVB-S (satellite) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index 2f3a6f7..6a6ba05 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -10,6 +10,7 @@ stv0900-objs = stv0900_core.o stv0900_sw.o
 au8522-objs = au8522_dig.o au8522_decoder.o
 drxd-objs = drxd_firm.o drxd_hard.o
 cxd2820r-objs = cxd2820r_core.o cxd2820r_c.o cxd2820r_t.o cxd2820r_t2.o
+drxk-objs := drxk_hard.o
 
 obj-$(CONFIG_DVB_PLL) += dvb-pll.o
 obj-$(CONFIG_DVB_STV0299) += stv0299.o
@@ -88,4 +89,6 @@ obj-$(CONFIG_DVB_MB86A20S) += mb86a20s.o
 obj-$(CONFIG_DVB_IX2505V) += ix2505v.o
 obj-$(CONFIG_DVB_STV0367) += stv0367.o
 obj-$(CONFIG_DVB_CXD2820R) += cxd2820r.o
+obj-$(CONFIG_DVB_DRXK) += drxk.o
+obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
 
-- 
1.7.4.1


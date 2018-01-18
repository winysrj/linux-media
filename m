Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-cys01nam02on0138.outbound.protection.outlook.com ([104.47.37.138]:62435
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754996AbeARI4l (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 03:56:41 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Yasunari.Takiguchi@sony.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v5 12/12] [media] cxd2880: Add all Makefile, Kconfig files and Update MAINTAINERS file for the driver
Date: Thu, 18 Jan 2018 17:59:42 +0900
Message-ID: <20180118085942.21969-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20180118084016.20689-1-Yasunari.Takiguchi@sony.com>
References: <20180118084016.20689-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the Makefile, Kconfig files of driver 
and MAINTAINERS file update about the driver 
for the Sony CXD2880 DVB-T2/T tuner + demodulator.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---

[Change list]
Changes in V5
   drivers/media/dvb-frontends/cxd2880/Makefile
       -Using SPDX-License-Identifier
       -removed cxd2880_stopwatch_port.o
   drivers/media/dvb-frontends/cxd2880/Kconfig
       -Using SPDX-License-Identifier

Changes in V4
   We put [PATCH v3 12/14], [PATCH v3 13/14] and [PATCH v3 14/14]
   in [PATCH v4 12/12].
   
   drivers/media/dvb-frontends/cxd2880/Makefile
      -removed cxd2880_integ_dvbt2.o and cxd2880_integ_dvbt.o 

Changes in V3
   drivers/media/dvb-frontends/cxd2880/Makefile
      -removed cxd2880_math.o 

 MAINTAINERS                                  |  9 +++++++++
 drivers/media/dvb-frontends/Kconfig          |  2 ++
 drivers/media/dvb-frontends/Makefile         |  1 +
 drivers/media/dvb-frontends/cxd2880/Kconfig  |  8 ++++++++
 drivers/media/dvb-frontends/cxd2880/Makefile | 19 +++++++++++++++++++
 drivers/media/spi/Kconfig                    | 14 ++++++++++++++
 drivers/media/spi/Makefile                   |  5 +++++
 7 files changed, 58 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Kconfig
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 18994806e441..fcdbd7874ffb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8549,6 +8549,15 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Supported
 F:	drivers/media/dvb-frontends/cxd2841er*
 
+MEDIA DRIVERS FOR CXD2880
+M:	Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+T:	git git://linuxtv.org/media_tree.git
+S:	Supported
+F:	drivers/media/dvb-frontends/cxd2880/*
+F:	drivers/media/spi/cxd2880*
+
 MEDIA DRIVERS FOR DIGITAL DEVICES PCIE DEVICES
 M:	Daniel Scheller <d.scheller.oss@gmail.com>
 L:	linux-media@vger.kernel.org
diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index d17722eb4456..7fb626c00a39 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -546,6 +546,8 @@ config DVB_GP8PSK_FE
 	depends on DVB_CORE
 	default DVB_USB_GP8PSK
 
+source "drivers/media/dvb-frontends/cxd2880/Kconfig"
+
 comment "DVB-C (cable) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index d025eb373842..7c7aca05678a 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -130,3 +130,4 @@ obj-$(CONFIG_DVB_HORUS3A) += horus3a.o
 obj-$(CONFIG_DVB_ASCOT2E) += ascot2e.o
 obj-$(CONFIG_DVB_HELENE) += helene.o
 obj-$(CONFIG_DVB_ZD1301_DEMOD) += zd1301_demod.o
+obj-$(CONFIG_DVB_CXD2880) += cxd2880/
diff --git a/drivers/media/dvb-frontends/cxd2880/Kconfig b/drivers/media/dvb-frontends/cxd2880/Kconfig
new file mode 100644
index 000000000000..9d989676e800
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/Kconfig
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+
+config DVB_CXD2880
+	tristate "Sony CXD2880 DVB-T2/T tuner + demodulator"
+	depends on DVB_CORE && SPI
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Say Y when you want to support this frontend.
\ No newline at end of file
diff --git a/drivers/media/dvb-frontends/cxd2880/Makefile b/drivers/media/dvb-frontends/cxd2880/Makefile
new file mode 100644
index 000000000000..65a5d37f28cc
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/Makefile
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0
+
+cxd2880-objs := cxd2880_common.o \
+		cxd2880_devio_spi.o \
+		cxd2880_integ.o \
+		cxd2880_io.o \
+		cxd2880_spi_device.o \
+		cxd2880_tnrdmd.o \
+		cxd2880_tnrdmd_dvbt2.o \
+		cxd2880_tnrdmd_dvbt2_mon.o \
+		cxd2880_tnrdmd_dvbt.o \
+		cxd2880_tnrdmd_dvbt_mon.o\
+		cxd2880_tnrdmd_mon.o\
+		cxd2880_top.o
+
+obj-$(CONFIG_DVB_CXD2880) += cxd2880.o
+
+ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/spi/Kconfig b/drivers/media/spi/Kconfig
index a21f5a39a440..b07ac86fc53c 100644
--- a/drivers/media/spi/Kconfig
+++ b/drivers/media/spi/Kconfig
@@ -12,3 +12,17 @@ config VIDEO_GS1662
 endmenu
 
 endif
+
+if SPI
+menu "Media SPI Adapters"
+
+config CXD2880_SPI_DRV
+	tristate "Sony CXD2880 SPI support"
+	depends on DVB_CORE && SPI
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Choose if you would like to have SPI interface support for Sony CXD2880.
+
+endmenu
+
+endif
diff --git a/drivers/media/spi/Makefile b/drivers/media/spi/Makefile
index ea64013d16cc..9e536777a330 100644
--- a/drivers/media/spi/Makefile
+++ b/drivers/media/spi/Makefile
@@ -1 +1,6 @@
 obj-$(CONFIG_VIDEO_GS1662) += gs1662.o
+obj-$(CONFIG_CXD2880_SPI_DRV) += cxd2880-spi.o
+
+ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/dvb-frontends
+ccflags-y += -Idrivers/media/dvb-frontends/cxd2880
-- 
2.15.1

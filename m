Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0102.outbound.protection.outlook.com ([104.47.40.102]:52454
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751423AbdDNCmV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 22:42:21 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v2 13/15]  [media] cxd2880: Add all Makefile files for the driver
Date: Fri, 14 Apr 2017 11:44:22 +0900
Message-ID: <20170414024422.18181-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the Makefile files of driver
for the Sony CXD2880 DVB-T2/T tuner + demodulator.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
 drivers/media/dvb-frontends/Makefile         |  1 +
 drivers/media/dvb-frontends/cxd2880/Makefile | 21 +++++++++++++++++++++
 drivers/media/spi/Makefile                   |  5 +++++
 3 files changed, 27 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Makefile

diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index 3fccaf34ef52..d298c7954699 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -126,3 +126,4 @@ obj-$(CONFIG_DVB_HORUS3A) += horus3a.o
 obj-$(CONFIG_DVB_ASCOT2E) += ascot2e.o
 obj-$(CONFIG_DVB_HELENE) += helene.o
 obj-$(CONFIG_DVB_ZD1301_DEMOD) += zd1301_demod.o
+obj-$(CONFIG_DVB_CXD2880) += cxd2880/
diff --git a/drivers/media/dvb-frontends/cxd2880/Makefile b/drivers/media/dvb-frontends/cxd2880/Makefile
new file mode 100644
index 000000000000..2672c4a3d65c
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/Makefile
@@ -0,0 +1,21 @@
+cxd2880-objs := cxd2880_common.o \
+		cxd2880_devio_spi.o \
+		cxd2880_integ.o \
+		cxd2880_integ_dvbt2.o \
+		cxd2880_integ_dvbt.o \
+		cxd2880_io.o \
+		cxd2880_spi_device.o \
+		cxd2880_stopwatch_port.o \
+		cxd2880_tnrdmd.o \
+		cxd2880_tnrdmd_dvbt2.o \
+		cxd2880_tnrdmd_dvbt2_mon.o \
+		cxd2880_tnrdmd_dvbt.o \
+		cxd2880_tnrdmd_dvbt_mon.o\
+		cxd2880_tnrdmd_mon.o\
+		cxd2880_math.o \
+		cxd2880_top.o
+
+obj-$(CONFIG_DVB_CXD2880) += cxd2880.o
+
+ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/spi/Makefile b/drivers/media/spi/Makefile
index ea64013d16cc..40e0f88d9f6c 100644
--- a/drivers/media/spi/Makefile
+++ b/drivers/media/spi/Makefile
@@ -1 +1,6 @@
 obj-$(CONFIG_VIDEO_GS1662) += gs1662.o
+obj-$(CONFIG_CXD2880_SPI_DRV) += cxd2880-spi.o
+
+ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/dvb-frontends
+ccflags-y += -Idrivers/media/dvb-frontends/cxd2880
\ No newline at end of file
-- 
2.11.0

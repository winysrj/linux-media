Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0105.outbound.protection.outlook.com ([104.47.38.105]:15872
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752628AbdDNCoh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 22:44:37 -0400
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
Subject: [PATCH v2 14/15] [media] cxd2880: Add all Kconfig files for the driver
Date: Fri, 14 Apr 2017 11:47:03 +0900
Message-ID: <20170414024703.18388-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the Kconfig files of driver for
the Sony CXD2880 DVB-T2/T tuner + demodulator driver.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
 drivers/media/dvb-frontends/Kconfig         |  2 ++
 drivers/media/dvb-frontends/cxd2880/Kconfig |  6 ++++++
 drivers/media/spi/Kconfig                   | 14 ++++++++++++++
 3 files changed, 22 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Kconfig

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index e8c6554a47aa..3a3a7129a150 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -518,6 +518,8 @@ config DVB_GP8PSK_FE
 	depends on DVB_CORE
 	default DVB_USB_GP8PSK
 
+source "drivers/media/dvb-frontends/cxd2880/Kconfig"
+
 comment "DVB-C (cable) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/cxd2880/Kconfig b/drivers/media/dvb-frontends/cxd2880/Kconfig
new file mode 100644
index 000000000000..36b8b6f7c4f7
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/Kconfig
@@ -0,0 +1,6 @@
+config DVB_CXD2880
+	tristate "Sony CXD2880 DVB-T2/T tuner + demodulator"
+	depends on DVB_CORE && SPI
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Say Y when you want to support this frontend.
\ No newline at end of file
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
-- 
2.11.0

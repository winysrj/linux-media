Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0098.outbound.protection.outlook.com ([104.47.38.98]:9856
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754473AbdCGBYk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 20:24:40 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: [RFC PATCH 1/5] Document: Add document file for Sony CXD2880 DVB-T2/T tuner + demodulator
Date: Tue, 7 Mar 2017 10:07:45 +0900
Message-ID: <1488848865-8428-1-git-send-email-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the driver for Sony CXD2880 DVB-T2/T tuner + demodulator.

Regarding this third Beta Release, the status is:
- Tested on Raspberry Pi 3.
- The DVB-API operates under dvbv5 tools.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
 .../devicetree/bindings/media/spi/sony-cxd2880.txt |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt

diff --git a/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt b/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
new file mode 100644
index 0000000..bdbb047
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
@@ -0,0 +1,16 @@
+Sony CXD2880 DVB-T2/T tuner + demodulator driver SPI adapter
+
+Required properties:
+- compatible: Should be "sony,cxd2880".
+- reg: SPI chip select number for the device.
+- spi-max-frequency: Maximum bus speed, should be set to <55000000> (55MHz).
+- status: Should be "okay"
+
+Example:
+
+cxd2880@0 {
+	compatible = "sony,cxd2880";
+	reg = <0>; /* CE0 */
+	spi-max-frequency = <55000000>; /* 55MHz */
+	status = "okay";
+};
-- 
1.7.9.5

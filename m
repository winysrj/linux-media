Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0135.outbound.protection.outlook.com ([104.47.40.135]:17344
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750827AbdHPEVA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 00:21:00 -0400
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
Subject: [PATCH v3 01/14] [dt-bindings] [media] Add document file for CXD2880 SPI I/F
Date: Wed, 16 Aug 2017 13:24:12 +0900
Message-ID: <20170816042412.20712-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20170816041714.20551-1-Yasunari.Takiguchi@sony.com>
References: <20170816041714.20551-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the document file for Sony CXD2880 DVB-T2/T tuner + demodulator.
It contains the description of the SPI adapter binding.

No change since version 1. I should have carried the ack forward:
Acked-by: Rob Herring <robh@kernel.org>

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
 .../devicetree/bindings/media/spi/sony-cxd2880.txt         | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt

diff --git a/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt b/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
new file mode 100644
index 000000000000..fc5aa263abe5
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
@@ -0,0 +1,14 @@
+Sony CXD2880 DVB-T2/T tuner + demodulator driver SPI adapter
+
+Required properties:
+- compatible: Should be "sony,cxd2880".
+- reg: SPI chip select number for the device.
+- spi-max-frequency: Maximum bus speed, should be set to <55000000> (55MHz).
+
+Example:
+
+cxd2880@0 {
+	compatible = "sony,cxd2880";
+	reg = <0>; /* CE0 */
+	spi-max-frequency = <55000000>; /* 55MHz */
+};
-- 
2.13.0

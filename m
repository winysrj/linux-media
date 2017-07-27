Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34323 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751593AbdG0PUi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 11:20:38 -0400
Received: by mail-wm0-f42.google.com with SMTP id t138so3581279wmt.1
        for <linux-media@vger.kernel.org>; Thu, 27 Jul 2017 08:20:37 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: mchehab@kernel.org, hans.verkuil@cisco.com
Cc: Neil Armstrong <narmstrong@baylibre.com>,
        linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 2/2] dt-bindings: media: Add Amlogic Meson AO-CEC bindings
Date: Thu, 27 Jul 2017 17:20:30 +0200
Message-Id: <1501168830-5308-3-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1501168830-5308-1-git-send-email-narmstrong@baylibre.com>
References: <1501168830-5308-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Amlogic SoCs embeds a standalone CEC Controller, this patch adds this
device bindings.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 .../devicetree/bindings/media/meson-ao-cec.txt     | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/meson-ao-cec.txt

diff --git a/Documentation/devicetree/bindings/media/meson-ao-cec.txt b/Documentation/devicetree/bindings/media/meson-ao-cec.txt
new file mode 100644
index 0000000..8671bdb
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/meson-ao-cec.txt
@@ -0,0 +1,28 @@
+* Amlogic Meson AO-CEC driver
+
+The Amlogic Meson AO-CEC module is present is Amlogic SoCs and its purpose is
+to handle communication between HDMI connected devices over the CEC bus.
+
+Required properties:
+  - compatible : value should be following
+	"amlogic,meson-gx-ao-cec"
+
+  - reg : Physical base address of the IP registers and length of memory
+	  mapped region.
+
+  - interrupts : AO-CEC interrupt number to the CPU.
+  - clocks : from common clock binding: handle to AO-CEC clock.
+  - clock-names : from common clock binding: must contain "core",
+		  corresponding to entry in the clocks property.
+  - hdmi-phandle: phandle to the HDMI controller
+
+Example:
+
+cec_AO: cec@100 {
+	compatible = "amlogic,meson-gx-ao-cec";
+	reg = <0x0 0x00100 0x0 0x14>;
+	interrupts = <GIC_SPI 199 IRQ_TYPE_EDGE_RISING>;
+	clocks = <&clkc_AO CLKID_AO_CEC_32K>;
+	clock-names = "core";
+	hdmi-phandle = <&hdmi_tx>;
+};
-- 
1.9.1

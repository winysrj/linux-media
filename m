Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:55327 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750998AbdHaLB6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 07:01:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 3/5] dt-bindings: document the CEC GPIO bindings
Date: Thu, 31 Aug 2017 13:01:54 +0200
Message-Id: <20170831110156.11018-4-hverkuil@xs4all.nl>
In-Reply-To: <20170831110156.11018-1-hverkuil@xs4all.nl>
References: <20170831110156.11018-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the bindings for the cec-gpio module for hardware where the
CEC line and optionally the HPD line are connected to GPIO lines.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../devicetree/bindings/media/cec-gpio.txt         | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt

diff --git a/Documentation/devicetree/bindings/media/cec-gpio.txt b/Documentation/devicetree/bindings/media/cec-gpio.txt
new file mode 100644
index 000000000000..db20a7452dbd
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/cec-gpio.txt
@@ -0,0 +1,22 @@
+* HDMI CEC GPIO driver
+
+The HDMI CEC GPIO module supports CEC implementations where the CEC line
+is hooked up to a pull-up GPIO line and - optionally - the HPD line is
+hooked up to another GPIO line.
+
+Required properties:
+  - compatible: value must be "cec-gpio"
+  - cec-gpio: gpio that the CEC line is connected to
+
+Optional property:
+  - hpd-gpio: gpio that the HPD line is connected to
+
+Example for the Raspberry Pi 3 where the CEC line is connected to
+pin 26 aka BCM7 aka CE1 on the GPIO pin header and the HPD line is
+connected to pin 11 aka BCM17:
+
+cec-gpio@7 {
+       compatible = "cec-gpio";
+       cec-gpio = <&gpio 7 GPIO_OPEN_DRAIN>;
+       hpd-gpio = <&gpio 17 GPIO_ACTIVE_HIGH>;
+};
-- 
2.14.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:39214 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752330AbdHBImr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:42:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Eric Anholt <eric@anholt.net>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] dt-bindings: document the CEC GPIO bindings
Date: Wed,  2 Aug 2017 10:42:40 +0200
Message-Id: <20170802084242.14947-2-hverkuil@xs4all.nl>
In-Reply-To: <20170802084242.14947-1-hverkuil@xs4all.nl>
References: <20170802084242.14947-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the bindings for the cec-gpio module for hardware where the
CEC pin is connected to a GPIO pin.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/devicetree/bindings/media/cec-gpio.txt | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt

diff --git a/Documentation/devicetree/bindings/media/cec-gpio.txt b/Documentation/devicetree/bindings/media/cec-gpio.txt
new file mode 100644
index 000000000000..58fa56080cda
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/cec-gpio.txt
@@ -0,0 +1,18 @@
+* HDMI CEC GPIO driver
+
+The HDMI CEC GPIO module supports CEC implementations where the CEC pin
+is hooked up to a pull-up GPIO pin.
+
+The CEC GPIO
+
+Required properties:
+  - compatible: value must be "cec-gpio"
+  - gpio: gpio that the CEC line is connected to
+
+Example for the Raspberry Pi 3 where the CEC line is connected to
+pin 7 aka BCM4 aka GPCLK0 on the GPIO pin header:
+
+cec-gpio {
+       compatible = "cec-gpio";
+       gpio = <&gpio 4 GPIO_ACTIVE_HIGH>;
+};
-- 
2.13.2

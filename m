Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:45681 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbeAUPPk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Jan 2018 10:15:40 -0500
Received: by mail-pf0-f195.google.com with SMTP id a88so5089381pfe.12
        for <linux-media@vger.kernel.org>; Sun, 21 Jan 2018 07:15:40 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v3 3/3] media: ov9650: add device tree binding
Date: Mon, 22 Jan 2018 00:14:16 +0900
Message-Id: <1516547656-3879-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1516547656-3879-1-git-send-email-akinobu.mita@gmail.com>
References: <1516547656-3879-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now the ov9650 driver supports device tree probing.  So this adds a
device tree binding documentation.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacopo Mondi <jacopo@jmondi.org>
Cc: H. Nikolaus Schaller <hns@goldelico.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Rob Herring <robh@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* Changelog v3
- Add Reviewed-by: tag
- Add F: line in MAINTAINERS

* Changelog v2
- Split binding documentation, suggested by Rob Herring and Jacopo Mondi
- Improve the wording for compatible property in the binding documentation,
  suggested by Jacopo Mondi
- Improve the description for the device node in the binding documentation,
  suggested by Sakari Ailus

 .../devicetree/bindings/media/i2c/ov9650.txt       | 36 ++++++++++++++++++++++
 MAINTAINERS                                        |  1 +
 2 files changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov9650.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov9650.txt b/Documentation/devicetree/bindings/media/i2c/ov9650.txt
new file mode 100644
index 0000000..506dfc5
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov9650.txt
@@ -0,0 +1,36 @@
+* Omnivision OV9650/OV9652 CMOS sensor
+
+Required Properties:
+- compatible: shall be one of
+	"ovti,ov9650"
+	"ovti,ov9652"
+- clocks: reference to the xvclk input clock.
+
+Optional Properties:
+- reset-gpios: reference to the GPIO connected to the resetb pin, if any.
+  Active is high.
+- powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
+  Active is high.
+
+The device node shall contain one 'port' child node with one child 'endpoint'
+subnode for its digital output video port, in accordance with the video
+interface bindings defined in Documentation/devicetree/bindings/media/
+video-interfaces.txt.
+
+Example:
+
+&i2c0 {
+	ov9650: camera@30 {
+		compatible = "ovti,ov9650";
+		reg = <0x30>;
+		reset-gpios = <&axi_gpio_0 0 GPIO_ACTIVE_HIGH>;
+		powerdown-gpios = <&axi_gpio_0 1 GPIO_ACTIVE_HIGH>;
+		clocks = <&xclk>;
+
+		port {
+			ov9650_0: endpoint {
+				remote-endpoint = <&vcap1_in0>;
+			};
+		};
+	};
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index 8924e39..876c0f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10060,6 +10060,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/i2c/ov9650.c
+F:	Documentation/devicetree/bindings/media/i2c/ov9650.txt
 
 ONENAND FLASH DRIVER
 M:	Kyungmin Park <kyungmin.park@samsung.com>
-- 
2.7.4

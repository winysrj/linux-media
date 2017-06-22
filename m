Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:4953 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751458AbdFVPGm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 11:06:42 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        " H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera module
Date: Thu, 22 Jun 2017 17:05:37 +0200
Message-ID: <1498143942-12682-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "H. Nikolaus Schaller" <hns@goldelico.com>

This adds documentation of device tree bindings
for the OV965X family camera sensor module.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 .../devicetree/bindings/media/i2c/ov965x.txt       | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov965x.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov965x.txt b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
new file mode 100644
index 0000000..0e0de1f
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
@@ -0,0 +1,37 @@
+* Omnivision OV9650/9652/9655 CMOS sensor
+
+The Omnivision OV965x sensor support multiple resolutions output, such as
+CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
+output format.
+
+Required Properties:
+- compatible: should be one of
+	"ovti,ov9650"
+	"ovti,ov9652"
+	"ovti,ov9655"
+- clocks: reference to the mclk input clock.
+
+Optional Properties:
+- resetb-gpios: reference to the GPIO connected to the resetb pin, if any.
+- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.
+
+The device node must contain one 'port' child node for its digital output
+video port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+&i2c2 {
+	ov9655: camera@30 {
+		compatible = "ovti,ov9655";
+		reg = <0x30>;
+		pwdn-gpios = <&gpioh 13 GPIO_ACTIVE_HIGH>;
+		clocks = <&clk_ext_camera>;
+
+		port {
+			ov9655: endpoint {
+				remote-endpoint = <&dcmi_0>;
+			};
+		};
+	};
+};
-- 
1.9.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f171.google.com ([209.85.210.171]:36179 "EHLO
        mail-wj0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755323AbcLORaL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 12:30:11 -0500
Received: by mail-wj0-f171.google.com with SMTP id tk12so72715500wjb.3
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2016 09:30:10 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH v5 2/9] doc: DT: venus: binding document for Qualcomm video driver
Date: Thu, 15 Dec 2016 19:22:17 +0200
Message-Id: <1481822544-29900-3-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1481822544-29900-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1481822544-29900-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add binding document for Venus video encoder/decoder driver

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 .../devicetree/bindings/media/qcom,venus.txt       | 68 ++++++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt

diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
new file mode 100644
index 000000000000..7b77dff52b0f
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
@@ -0,0 +1,68 @@
+* Qualcomm Venus video encode/decode accelerator
+
+- compatible:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Value should contain one of:
+		- "qcom,msm8916-venus"
+		- "qcom,msm8996-venus"
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Register base address and length of the register map.
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Should contain interrupt line number.
+- clocks:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A List of phandle and clock specifier pairs as listed
+		    in clock-names property.
+- clock-names:
+	Usage: required for msm8916
+	Value type: <stringlist>
+	Definition: Should contain the following entries:
+		- "core"	Core video accelerator clock
+		- "iface"	Video accelerator AHB clock
+		- "bus"		Video accelerator AXI clock
+- clock-names:
+	Usage: required for msm8996
+	Value type: <stringlist>
+	Definition: Should contain the following entries:
+		- "core"	Core video accelerator clock
+		- "iface"	Video accelerator AHB clock
+		- "bus"		Video accelerator AXI clock
+		- "subcore0"	Subcore0 (decoder) video accelerator clock
+		- "subcore1"	Subcore1 (encoder) video accelerator clock
+		- "mbus"	Video MAXI clock
+- power-domains:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A phandle and power domain specifier pairs to the
+		    power domain which is responsible for collapsing
+		    and restoring power to the peripheral.
+- rproc:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A phandle to remote processor responsible for
+		    firmware loading and processor booting.
+
+- iommus:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A list of phandle and IOMMU specifier pairs.
+
+* An Example
+	video-codec@1d00000 {
+		compatible = "qcom,msm8916-venus";
+		reg = <0x01d00000 0xff000>;
+		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&gcc GCC_VENUS0_VCODEC0_CLK>,
+			 <&gcc GCC_VENUS0_AHB_CLK>,
+			 <&gcc GCC_VENUS0_AXI_CLK>;
+		clock-names = "core", "iface", "bus";
+		power-domains = <&gcc VENUS_GDSC>;
+		rproc = <&venus_rproc>;
+		iommus = <&apps_iommu 5>;
+	};
-- 
2.7.4


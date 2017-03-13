Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34509 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbdCMQiG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 12:38:06 -0400
Received: by mail-wr0-f173.google.com with SMTP id l37so107513489wrc.1
        for <linux-media@vger.kernel.org>; Mon, 13 Mar 2017 09:38:04 -0700 (PDT)
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
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v7 2/9] doc: DT: venus: binding document for Qualcomm video driver
Date: Mon, 13 Mar 2017 18:37:31 +0200
Message-Id: <1489423058-12492-3-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add binding document for Venus video encoder/decoder driver

Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 .../devicetree/bindings/media/qcom,venus.txt       | 107 +++++++++++++++++++++
 1 file changed, 107 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt

diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
new file mode 100644
index 000000000000..2693449daf73
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
@@ -0,0 +1,107 @@
+* Qualcomm Venus video encoder/decoder accelerators
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
+		- "mbus"	Video MAXI clock
+- power-domains:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A phandle and power domain specifier pairs to the
+		    power domain which is responsible for collapsing
+		    and restoring power to the peripheral.
+- iommus:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A list of phandle and IOMMU specifier pairs.
+- memory-region:
+	Usage: required
+	Value type: <phandle>
+	Definition: reference to the reserved-memory for the firmware
+		    memory region.
+
+* Subnodes
+The Venus video-codec node must contain two subnodes representing
+video-decoder and video-encoder.
+
+Every of video-encoder or video-decoder subnode should have:
+
+- compatible:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Value should contain "venus-decoder" or "venus-encoder"
+- clocks:
+	Usage: required for msm8996
+	Value type: <prop-encoded-array>
+	Definition: A List of phandle and clock specifier pairs as listed
+		    in clock-names property.
+- clock-names:
+	Usage: required for msm8996
+	Value type: <stringlist>
+	Definition: Should contain the following entries:
+		- "core"	Subcore video accelerator clock
+
+- power-domains:
+	Usage: required for msm8996
+	Value type: <prop-encoded-array>
+	Definition: A phandle and power domain specifier pairs to the
+		    power domain which is responsible for collapsing
+		    and restoring power to the subcore.
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
+		iommus = <&apps_iommu 5>;
+		memory-region = <&venus_mem>;
+
+		video-decoder {
+			compatible = "venus-decoder";
+			clocks = <&mmcc VIDEO_SUBCORE0_CLK>;
+			clock-names = "core";
+			power-domains = <&mmcc VENUS_CORE0_GDSC>;
+		};
+
+		video-encoder {
+			compatible = "venus-encoder";
+			clocks = <&mmcc VIDEO_SUBCORE1_CLK>;
+			clock-names = "core";
+			power-domains = <&mmcc VENUS_CORE1_GDSC>;
+		};
+	};
-- 
2.7.4

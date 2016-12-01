Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f175.google.com ([209.85.210.175]:34472 "EHLO
        mail-wj0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932371AbcLAJMO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 04:12:14 -0500
Received: by mail-wj0-f175.google.com with SMTP id mp19so198971234wjc.1
        for <linux-media@vger.kernel.org>; Thu, 01 Dec 2016 01:12:13 -0800 (PST)
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
Subject: [PATCH v4 2/9] doc: DT: venus: binding document for Qualcomm video driver
Date: Thu,  1 Dec 2016 11:03:14 +0200
Message-Id: <1480583001-32236-3-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1480583001-32236-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1480583001-32236-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add binding document for Venus video encoder/decoder driver

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
Rob, I have removed vmem clocks, interrupts and reg properties
for vmem thing. Probably I will come with a separate platform
driver fro that and pass the video memory DT node as phandle.

 .../devicetree/bindings/media/qcom,venus.txt       | 82 ++++++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt

diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
new file mode 100644
index 000000000000..a64b4ea1ebba
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
@@ -0,0 +1,82 @@
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
+	Definition: Register ranges as listed in the reg-names property.
+- reg-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Should contain following entries:
+		- "base"	Venus register base
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Should contain interrupts as listed in the interrupt-names
+		    property.
+- interrupt-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Should contain following entries:
+		- "venus"	Venus interrupt line
+- clocks:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A List of phandle and clock specifier pairs as listed
+		    in clock-names property.
+- clock-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Should contain the following entries:
+		- "core"	Core video accelerator clock
+		- "iface"	Video accelerator AHB clock
+		- "bus"		Video accelerator AXI clock
+- clock-names:
+	Usage: required for msm8996
+	Value type: <stringlist>
+	Definition: Should contain the following entries:
+		- "subcore0"		Subcore0 video accelerator clock
+		- "subcore1"		Subcore1 video accelerator clock
+		- "mmssnoc_axi"		Multimedia subsystem NOC AXI clock
+		- "mmss_mmagic_iface"	Multimedia subsystem MMAGIC AHB clock
+		- "mmss_mmagic_mbus"	Multimedia subsystem MMAGIC MAXI clock
+		- "mmagic_video_bus"	MMAGIC video AXI clock
+		- "video_mbus"		Video MAXI clock
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
+		reg-names = "base";
+		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "venus";
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


Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC076C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 10:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C886206C0
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 10:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfCZKEF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 06:04:05 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:65482 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbfCZKEE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 06:04:04 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2Q9ugbw026877;
        Tue, 26 Mar 2019 11:03:54 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2rddhbgpqe-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 26 Mar 2019 11:03:54 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 476E63A;
        Tue, 26 Mar 2019 10:03:50 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas23.st.com [10.75.90.46])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 1A4CA516B;
        Tue, 26 Mar 2019 10:03:50 +0000 (GMT)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by SAFEX1HUBCAS23.st.com
 (10.75.90.46) with Microsoft SMTP Server (TLS) id 14.3.435.0; Tue, 26 Mar
 2019 11:03:50 +0100
Received: from localhost (10.129.172.100) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.361.1; Tue, 26 Mar 2019 11:03:49
 +0100
From:   Mickael Guene <mickael.guene@st.com>
To:     <linux-media@vger.kernel.org>
CC:     <hugues.fruchet@st.com>, Mickael Guene <mickael.guene@st.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Mark Rutland" <mark.rutland@arm.com>
Subject: [PATCH v3 1/2] dt-bindings: Document MIPID02 bindings
Date:   Tue, 26 Mar 2019 11:03:39 +0100
Message-ID: <1553594620-88280-2-git-send-email-mickael.guene@st.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1553594620-88280-1-git-send-email-mickael.guene@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-1-git-send-email-mickael.guene@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.129.172.100]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-26_05:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This adds documentation of device tree for MIPID02 CSI-2 to PARALLEL
bridge.

Signed-off-by: Mickael Guene <mickael.guene@st.com>
---

Changes in v3: None
Changes in v2:
- Add precision about first CSI-2 port data rate
- Document endpoints supported properties
- Rename 'mipid02@14' into generic 'csi2rx@14' in example

 .../bindings/media/i2c/st,st-mipid02.txt           | 83 ++++++++++++++++++++++
 MAINTAINERS                                        |  7 ++
 2 files changed, 90 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
new file mode 100644
index 0000000..dfeab45
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
@@ -0,0 +1,83 @@
+STMicroelectronics MIPID02 CSI-2 to PARALLEL bridge
+
+MIPID02 has two CSI-2 input ports, only one of those ports can be active at a
+time. Active port input stream will be de-serialized and its content outputted
+through PARALLEL output port.
+CSI-2 first input port is a dual lane 800Mbps per lane whereas CSI-2 second
+input port is a single lane 800Mbps. Both ports support clock and data lane
+polarity swap. First port also supports data lane swap.
+PARALLEL output port has a maximum width of 12 bits.
+Supported formats are RAW6, RAW7, RAW8, RAW10, RAW12, RGB565, RGB888, RGB444,
+YUV420 8-bit, YUV422 8-bit and YUV420 10-bit.
+
+Required Properties:
+- compatible: should be "st,st-mipid02"
+- clocks: reference to the xclk input clock.
+- clock-names: should be "xclk".
+- VDDE-supply: sensor digital IO supply. Must be 1.8 volts.
+- VDDIN-supply: sensor internal regulator supply. Must be 1.8 volts.
+
+Optional Properties:
+- reset-gpios: reference to the GPIO connected to the xsdn pin, if any.
+	       This is an active low signal to the mipid02.
+
+Required subnodes:
+  - ports: A ports node with one port child node per device input and output
+	   port, in accordance with the video interface bindings defined in
+	   Documentation/devicetree/bindings/media/video-interfaces.txt. The
+	   port nodes are numbered as follows:
+
+	   Port Description
+	   -----------------------------
+	   0    CSI-2 first input port
+	   1    CSI-2 second input port
+	   2    PARALLEL output
+
+Endpoint node optional properties for CSI-2 connection are:
+- bus-type: if present should be 4 - MIPI CSI-2 D-PHY.
+- clock-lanes: should be set to <0> if present (clock lane on hardware lane 0).
+- data-lanes: if present should be <1> for Port 1. for Port 0 dual-lane
+operation should be <1 2> or <2 1>. For Port 0 single-lane operation should be
+<1> or <2>.
+- lane-polarities: any lane can be inverted.
+
+Endpoint node optional properties for PARALLEL connection are:
+- bus-type: if present should be 5 - Parallel.
+- bus-width: shall be set to <6>, <7>, <8>, <10> or <12>.
+- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
+- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
+
+Example:
+
+mipid02: csi2rx@14 {
+	compatible = "st,st-mipid02";
+	reg = <0x14>;
+	status = "okay";
+	clocks = <&clk_ext_camera_12>;
+	clock-names = "xclk";
+	VDDE-supply = <&vdd>;
+	VDDIN-supply = <&vdd>;
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		port@0 {
+			reg = <0>;
+
+			ep0: endpoint {
+				clock-lanes = <0>;
+				data-lanes = <1 2>;
+				remote-endpoint = <&mipi_csi2_in>;
+			};
+		};
+		port@2 {
+			reg = <2>;
+
+			ep2: endpoint {
+				bus-width = <8>;
+				hsync-active = <0>;
+				vsync-active = <0>;
+				remote-endpoint = <&parallel_out>;
+			};
+		};
+	};
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index e17ebf7..74da99d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14668,6 +14668,13 @@ S:	Maintained
 F:	drivers/iio/imu/st_lsm6dsx/
 F:	Documentation/devicetree/bindings/iio/imu/st_lsm6dsx.txt
 
+ST MIPID02 CSI-2 TO PARALLEL BRIDGE DRIVER
+M:	Mickael Guene <mickael.guene@st.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
+
 ST STM32 I2C/SMBUS DRIVER
 M:	Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
 L:	linux-i2c@vger.kernel.org
-- 
2.7.4


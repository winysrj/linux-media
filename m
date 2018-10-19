Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:50616 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbeJSU7Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:59:25 -0400
From: Luis Oliveira <luis.oliveira@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: joao.pinto@synopsys.com, festevam@gmail.com,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        devicetree@vger.kernel.org
Subject: [V3, 3/4] Documentation: dt-bindings: media: Document bindings for DW MIPI CSI-2 Host
Date: Fri, 19 Oct 2018 14:52:25 +0200
Message-Id: <1539953556-35762-4-git-send-email-lolivei@synopsys.com>
In-Reply-To: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings for Synopsys DesignWare MIPI CSI-2 host.

Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
---
Changelog
v2-V3
- removed IPI settings

 .../devicetree/bindings/media/snps,dw-csi-plat.txt | 52 ++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt

diff --git a/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt b/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
new file mode 100644
index 0000000..be3da05
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
@@ -0,0 +1,52 @@
+Synopsys DesignWare CSI-2 Host controller
+
+Description
+-----------
+
+This HW block is used to receive image coming from an MIPI CSI-2 compatible
+camera.
+
+Required properties:
+- compatible: shall be "snps,dw-csi-plat"
+- reg			: physical base address and size of the device memory mapped
+  registers;
+- interrupts		: CSI-2 Host interrupt
+- snps,output-type	: Core output to be used (IPI-> 0 or IDI->1 or BOTH->2)
+			  These  values choose which of the Core outputs will be used,
+			  it can be Image Data Interface or Image Pixel Interface.
+- phys			: List of one PHY specifier (as defined in
+			  Documentation/devicetree/bindings/phy/phy-bindings.txt).
+			  This PHY is a MIPI DPHY working in RX mode.
+- resets		: Reference to a reset controller (optional)
+
+The per-board settings:
+ - port sub-node describing a single endpoint connected to the camera as
+   described in video-interfaces.txt[1].
+
+Example:
+
+	csi2_1: csi2@3000 {
+		compatible = "snps,dw-csi-plat";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = < 0x03000 0x7FF>;
+		interrupts = <2>;
+		output-type = <2>;
+		resets = <&dw_rst 1>;
+		phys = <&mipi_dphy_rx1 0>;
+		phy-names = "csi2-dphy";
+
+		/* CSI-2 per-board settings */
+		port@1 {
+			reg = <1>;
+			csi1_ep1: endpoint {
+				remote-endpoint = <&camera_1>;
+				data-lanes = <1 2>;
+			};
+		};
+		port@2 {
+			csi1_ep2: endpoint {
+				remote-endpoint = <&vif1_ep>;
+			};
+		};
+	};
--
2.7.4

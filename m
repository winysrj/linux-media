Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:45670 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725198AbeIOEHh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 00:07:37 -0400
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: all-jpinto-org-pt02@synopsys.com,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 4/5] Documentation: dt-bindings: Document bindings for DW MIPI CSI-2 Host
Date: Sat, 15 Sep 2018 00:48:40 +0200
Message-Id: <20180914224849.27173-5-lolivei@synopsys.com>
In-Reply-To: <20180914224849.27173-1-lolivei@synopsys.com>
References: <20180914224849.27173-1-lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings for Synopsys DesignWare MIPI CSI-2 host.

Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
---
 .../devicetree/bindings/media/snps,dw-csi-plat.txt | 74 ++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt

diff --git a/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt b/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
new file mode 100644
index 0000000..0cc2915
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
@@ -0,0 +1,74 @@
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
+- snps,output-type	: Core output to be used (IPI-> 0 or IDI->1 or BOTH->2) These
+  			  values choose which of the Core outputs will be used, it
+			  can be Image Data Interface or Image Pixel Interface.
+- phys			: List of one PHY specifier (as defined in
+			  Documentation/devicetree/bindings/phy/phy-bindings.txt).
+			  This PHY is a MIPI DPHY working in RX mode.
+- resets		: Reference to a reset controller (optional)
+
+Optional properties(if in IPI mode):
+- snps,ipi-mode 	: Mode to be used when in IPI(Camera -> 0 or Controller -> 1)
+			  This property defines if the controller will use the video
+			  timings available
+			  in the video stream or if it will use pre-defined ones.
+- snps,ipi-color-mode	: Bus depth to be used in IPI (48 bits -> 0 or 16 bits -> 1)
+			  This property defines the width of the IPI bus.
+- snps,ipi-auto-flush	: Data auto-flush (1 -> Yes or 0 -> No). This property defines
+			  if the data is automatically flushed in each vsync or if
+			  this process is done manually
+- snps,virtual-channel	: Virtual channel where data is present when in IPI mode. This
+			  property chooses the virtual channel which IPI will use to
+			  retrieve the video stream.
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
+		/* IPI optional Configurations */
+		snps,ipi-mode = <0>;
+		snps,ipi-color-mode = <0>;
+		snps,ipi-auto-flush = <1>;
+		snps,virtual-channel = <0>;
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
+
+
-- 
2.9.3

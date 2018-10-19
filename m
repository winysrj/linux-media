Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:47906 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbeJSU67 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:58:59 -0400
From: Luis Oliveira <luis.oliveira@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: joao.pinto@synopsys.com, festevam@gmail.com,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
Subject: [V3, 1/4] Documentation: dt-bindings: phy: Document the Synopsys MIPI DPHY Rx bindings
Date: Fri, 19 Oct 2018 14:52:23 +0200
Message-Id: <1539953556-35762-2-git-send-email-lolivei@synopsys.com>
In-Reply-To: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device-tree bindings documentation for SNPS DesignWare MIPI D-PHY in
RX mode.

Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
---
Changelog
v2-V3
- removed gpios reference - it was for a separated driver
- changed address to show complete address

 .../devicetree/bindings/phy/snps,dphy-rx.txt       | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/snps,dphy-rx.txt

diff --git a/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt b/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
new file mode 100644
index 0000000..03d17ab
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
@@ -0,0 +1,28 @@
+Synopsys DesignWare MIPI Rx D-PHY block details
+
+Description
+-----------
+
+The Synopsys MIPI D-PHY controller supports MIPI-DPHY in receiver mode.
+Please refer to phy-bindings.txt for more information.
+
+Required properties:
+- compatible		: Shall be "snps,dphy-rx".
+- #phy-cells		: Must be 1.
+- snps,dphy-frequency	: Output frequency of the D-PHY.
+- snps,dphy-te-len	: Size of the communication interface (8 bits->8 or 12bits->12).
+- reg			: Physical base address and size of the device memory mapped
+		 	  registers;
+
+Example:
+
+	mipi_dphy_rx1: dphy@d00003040 {
+		compatible = "snps,dphy-rx";
+		#phy-cells = <1>;
+		snps,dphy-frequency = <300000>;
+		snps,dphy-te-len = <12>;
+		reg = < 0xd0003040 0x20
+			0xd0008000 0x100
+			0xd0009000 0x100>;
+	};
+
--
2.7.4

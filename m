Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:42001 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbdFMKB7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 06:01:59 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 4/4] dt-bindings: media: Document Synopsys Designware HDMI RX
Date: Tue, 13 Jun 2017 11:01:18 +0100
Message-Id: <ad60769b10c01fd61ae4a396001ca475bea0a6ca.1497347657.git.joabreu@synopsys.com>
In-Reply-To: <cover.1497347657.git.joabreu@synopsys.com>
References: <cover.1497347657.git.joabreu@synopsys.com>
In-Reply-To: <cover.1497347657.git.joabreu@synopsys.com>
References: <cover.1497347657.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the bindings for the Synopsys Designware HDMI RX.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Rob Herring <robh+dt@kernel.org>
---
 .../devicetree/bindings/media/snps,dw-hdmi-rx.txt  | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt

diff --git a/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt b/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
new file mode 100644
index 0000000..9e877de
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
@@ -0,0 +1,41 @@
+Synopsys DesignWare HDMI RX Decoder
+===================================
+
+This document defines device tree properties for the Synopsys DesignWare HDMI
+RX Descoder (DWC HDMI RX). It doesn't constitute a device tree binding
+specification by itself but is meant to be referenced by platform-specific
+device tree bindings.
+
+When referenced from platform device tree bindings the properties defined in
+this document are defined as follows.
+
+- reg: Memory mapped base address and length of the DWC HDMI RX registers.
+
+- interrupts: Reference to the DWC HDMI RX interrupt and 5v sense interrupt.
+
+- snps,hdmi-phy-jtag-addr: JTAG address of the phy to be used.
+
+- snps,hdmi-phy-version: Version of the phy to be used.
+
+- snps,hdmi-phy-cfg-clk: Value of the cfg clk that is delivered to phy.
+
+- snps,hdmi-phy-driver: *Exact* name of the phy driver to be used.
+
+- snps,hdmi-ctl-cfg-clk: Value of the cfg clk that is delivered to the
+controller.
+
+A sample binding is now provided. The compatible string is for a wrapper driver
+which then instantiates the Synopsys Designware HDMI RX decoder driver.
+
+Example:
+
+dw_hdmi_wrapper: dw-hdmi-wrapper@0 {
+	compatible = "snps,dw-hdmi-rx-wrapper";
+	reg = <0x0 0x10000>; /* controller regbank */
+	interrupts = <1 3>; /* controller interrupt + 5v sense interrupt */
+	snps,hdmi-phy-driver = "dw-hdmi-phy-e405";
+	snps,hdmi-phy-version = <405>;
+	snps,hdmi-phy-cfg-clk = <25>; /* MHz */
+	snps,hdmi-ctl-cfg-clk = <25>; /* MHz */
+	snps,hdmi-phy-jtag-addr = /bits/ 8 <0xfc>;
+};
-- 
1.9.1

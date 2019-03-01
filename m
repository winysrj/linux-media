Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B305C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 15:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 140B020851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 15:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388807AbfCAP1Z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 10:27:25 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41319 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388785AbfCAP1Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 10:27:25 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.lab.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mtr@pengutronix.de>)
        id 1gzk4J-0007Qi-2D; Fri, 01 Mar 2019 16:27:23 +0100
Received: from mtr by dude02.lab.pengutronix.de with local (Exim 4.89)
        (envelope-from <mtr@pengutronix.de>)
        id 1gzk4G-00061v-Oq; Fri, 01 Mar 2019 16:27:20 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, dshah@xilinx.com, hverkuil@xs4all.nl,
        Michael Tretter <m.tretter@pengutronix.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v4 1/3] media: dt-bindings: media: document allegro-dvt bindings
Date:   Fri,  1 Mar 2019 16:27:16 +0100
Message-Id: <20190301152718.23134-2-m.tretter@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190301152718.23134-1-m.tretter@pengutronix.de>
References: <20190301152718.23134-1-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mtr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add device-tree bindings for the Allegro DVT video IP core found on the
Xilinx ZynqMP EV family.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Reviewed-by: Rob Herring <robh@kernel.org>
---
v3 -> v4:
none

v2 -> v3:
- rename node to video-codec
- drop interrupt-names
- fix compatible in example
- add clocks to required properties

v1 -> v2:
none
---
 .../devicetree/bindings/media/allegro.txt     | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/allegro.txt

diff --git a/Documentation/devicetree/bindings/media/allegro.txt b/Documentation/devicetree/bindings/media/allegro.txt
new file mode 100644
index 000000000000..a92e2fbf26c9
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/allegro.txt
@@ -0,0 +1,43 @@
+Device-tree bindings for the Allegro DVT video IP codecs present in the Xilinx
+ZynqMP SoC. The IP core may either be a H.264/H.265 encoder or H.264/H.265
+decoder ip core.
+
+Each actual codec engines is controlled by a microcontroller (MCU). Host
+software uses a provided mailbox interface to communicate with the MCU. The
+MCU share an interrupt.
+
+Required properties:
+  - compatible: value should be one of the following
+    "allegro,al5e-1.1", "allegro,al5e": encoder IP core
+    "allegro,al5d-1.1", "allegro,al5d": decoder IP core
+  - reg: base and length of the memory mapped register region and base and
+    length of the memory mapped sram
+  - reg-names: must include "regs" and "sram"
+  - interrupts: shared interrupt from the MCUs to the processing system
+  - clocks: must contain an entry for each entry in clock-names
+  - clock-names: must include "core_clk", "mcu_clk", "m_axi_core_aclk",
+    "m_axi_mcu_aclk", "s_axi_lite_aclk"
+
+Example:
+	al5e: video-codec@a0009000 {
+		compatible = "allegro,al5e-1.1", "allegro,al5e";
+		reg = <0 0xa0009000 0 0x1000>,
+		      <0 0xa0000000 0 0x8000>;
+		reg-names = "regs", "sram";
+		interrupts = <0 96 4>;
+		clocks = <&xlnx_vcu 0>, <&xlnx_vcu 1>,
+			 <&clkc 71>, <&clkc 71>, <&clkc 71>;
+		clock-names = "core_clk", "mcu_clk", "m_axi_core_aclk",
+			      "m_axi_mcu_aclk", "s_axi_lite_aclk"
+	};
+	al5d: video-codec@a0029000 {
+		compatible = "allegro,al5d-1.1", "allegro,al5d";
+		reg = <0 0xa0029000 0 0x1000>,
+		      <0 0xa0020000 0 0x8000>;
+		reg-names = "regs", "sram";
+		interrupts = <0 96 4>;
+		clocks = <&xlnx_vcu 2>, <&xlnx_vcu 3>,
+			 <&clkc 71>, <&clkc 71>, <&clkc 71>;
+		clock-names = "core_clk", "mcu_clk", "m_axi_core_aclk",
+			      "m_axi_mcu_aclk", "s_axi_lite_aclk"
+	};
-- 
2.20.1


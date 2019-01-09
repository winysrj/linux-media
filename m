Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DE7C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7E41217F9
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbfAILbC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:31:02 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44561 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730732AbfAILbC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 06:31:02 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mtr@pengutronix.de>)
        id 1ghC4a-0005Ca-K5; Wed, 09 Jan 2019 12:31:00 +0100
Received: from mtr by dude.hi.pengutronix.de with local (Exim 4.91)
        (envelope-from <mtr@pengutronix.de>)
        id 1ghC4a-0003JT-CP; Wed, 09 Jan 2019 12:31:00 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH 1/3] media: dt-bindings: media: document allegro-dvt bindings
Date:   Wed,  9 Jan 2019 12:30:35 +0100
Message-Id: <20190109113037.28430-2-m.tretter@pengutronix.de>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190109113037.28430-1-m.tretter@pengutronix.de>
References: <20190109113037.28430-1-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
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
---
 .../devicetree/bindings/media/allegro.txt     | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/allegro.txt

diff --git a/Documentation/devicetree/bindings/media/allegro.txt b/Documentation/devicetree/bindings/media/allegro.txt
new file mode 100644
index 000000000000..765f4b0c1a57
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/allegro.txt
@@ -0,0 +1,35 @@
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
+  - interrupt-names: "vcu_host_interrupt"
+
+Example:
+	al5e: al5e@a0009000 {
+		compatible = "allegro,al5e";
+		reg = <0 0xa0009000 0 0x1000>,
+		      <0 0xa0000000 0 0x8000>;
+		reg-names = "regs", "sram";
+		interrupt-names = "vcu_host_interrupt";
+		interrupts = <0 96 4>;
+	};
+	al5d: al5d@a0029000 {
+		compatible = "allegro,al5d";
+		reg = <0 0xa0029000 0 0x1000>,
+		      <0 0xa0020000 0 0x8000>;
+		reg-names = "regs", "sram";
+		interrupt-names = "vcu_host_interrupt";
+		interrupts = <0 96 4>;
+	};
-- 
2.19.1


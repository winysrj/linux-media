Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56750 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730473AbeKMGzj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 01:55:39 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wACKhoIb113158
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 16:00:42 -0500
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2nqfmtuj55-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 16:00:41 -0500
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.ibm.com>;
        Mon, 12 Nov 2018 21:00:40 -0000
From: Eddie James <eajames@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, robh+dt@kernel.org, andrew@aj.id.au,
        linux-aspeed@lists.ozlabs.org, devicetree@vger.kernel.org,
        mark.rutland@arm.com, Eddie James <eajames@linux.ibm.com>
Subject: [PATCH v5 1/2] dt-bindings: media: Add Aspeed Video Engine binding documentation
Date: Mon, 12 Nov 2018 15:00:30 -0600
In-Reply-To: <1542056431-18146-1-git-send-email-eajames@linux.ibm.com>
References: <1542056431-18146-1-git-send-email-eajames@linux.ibm.com>
Message-Id: <1542056431-18146-2-git-send-email-eajames@linux.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the bindings.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/media/aspeed-video.txt     | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt

diff --git a/Documentation/devicetree/bindings/media/aspeed-video.txt b/Documentation/devicetree/bindings/media/aspeed-video.txt
new file mode 100644
index 0000000..78b464a
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/aspeed-video.txt
@@ -0,0 +1,26 @@
+* Device tree bindings for Aspeed Video Engine
+
+The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs can
+capture and compress video data from digital or analog sources.
+
+Required properties:
+ - compatible:		"aspeed,ast2400-video-engine" or
+			"aspeed,ast2500-video-engine"
+ - reg:			contains the offset and length of the VE memory region
+ - clocks:		clock specifiers for the syscon clocks associated with
+			the VE (ordering must match the clock-names property)
+ - clock-names:		"vclk" and "eclk"
+ - resets:		reset specifier for the syscon reset associated with
+			the VE
+ - interrupts:		the interrupt associated with the VE on this platform
+
+Example:
+
+video-engine@1e700000 {
+    compatible = "aspeed,ast2500-video-engine";
+    reg = <0x1e700000 0x20000>;
+    clocks = <&syscon ASPEED_CLK_GATE_VCLK>, <&syscon ASPEED_CLK_GATE_ECLK>;
+    clock-names = "vclk", "eclk";
+    resets = <&syscon ASPEED_RESET_VIDEO>;
+    interrupts = <7>;
+};
-- 
1.8.3.1

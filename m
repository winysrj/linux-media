Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34831 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915AbcE0RTd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 13:19:33 -0400
Received: by mail-wm0-f67.google.com with SMTP id e3so239920wme.2
        for <linux-media@vger.kernel.org>; Fri, 27 May 2016 10:19:32 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: laurent.pinchart@ideasonboard.com,
	linux-renesas-soc@vger.kernel.org, kieran@ksquared.org.uk
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: [PATCH 3/4] dt-bindings: Document Renesas R-Car FCP power-domains usage
Date: Fri, 27 May 2016 18:19:24 +0100
Message-Id: <1464369565-12259-5-git-send-email-kieran@bingham.xyz>
In-Reply-To: <1464369565-12259-1-git-send-email-kieran@bingham.xyz>
References: <1464369565-12259-1-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The example misses the power-domains usage, and documentation that the
property is used by the node.

Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
---
 Documentation/devicetree/bindings/media/renesas,fcp.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
index 1c0718b501ef..464bb7ae4b92 100644
--- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
+++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
@@ -21,6 +21,8 @@ are paired with. These DT bindings currently support the FCPV and FCPF.
 
  - reg: the register base and size for the device registers
  - clocks: Reference to the functional clock
+ - power-domains : power-domain property defined with a phandle
+                           to respective power domain.
 
 
 Device node example
@@ -30,4 +32,5 @@ Device node example
 		compatible = "renesas,r8a7795-fcpv", "renesas,fcpv";
 		reg = <0 0xfea2f000 0 0x200>;
 		clocks = <&cpg CPG_MOD 602>;
+		power-domains = <&sysc R8A7795_PD_A3VP>;
 	};
-- 
2.5.0


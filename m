Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32931 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbcF3Quh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 12:50:37 -0400
Received: by mail-wm0-f68.google.com with SMTP id r201so24354050wme.0
        for <linux-media@vger.kernel.org>; Thu, 30 Jun 2016 09:50:36 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: laurent.pinchart@ideasonboard.com, robh+dt@kernel.org,
	mark.rutland@arm.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	kieran@ksquared.org.uk
Subject: [PATCH v2 2/3] dt-bindings: Document Renesas R-Car FCP power-domains usage
Date: Thu, 30 Jun 2016 17:50:29 +0100
Message-Id: <1467305430-25660-3-git-send-email-kieran@bingham.xyz>
In-Reply-To: <1467305430-25660-1-git-send-email-kieran@bingham.xyz>
References: <1467305430-25660-1-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The power domain must be specified to bring the device out of module
standby. Document this in the bindings provided, so that new additions
are not missed.

Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
---
 Documentation/devicetree/bindings/media/renesas,fcp.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
index 271dcfdb5a76..5be21b6411ba 100644
--- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
+++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
@@ -23,6 +23,10 @@ are paired with. These DT bindings currently support the FCPV and FCPF.
  - reg: the register base and size for the device registers
  - clocks: Reference to the functional clock
 
+Optional properties:
+ - power-domains : power-domain property defined with a power domain specifier
+                            to respective power domain.
+
 
 Device node example
 -------------------
@@ -31,4 +35,5 @@ Device node example
 		compatible = "renesas,r8a7795-fcpv", "renesas,fcpv";
 		reg = <0 0xfea2f000 0 0x200>;
 		clocks = <&cpg CPG_MOD 602>;
+		power-domains = <&sysc R8A7795_PD_A3VP>;
 	};
-- 
2.7.4


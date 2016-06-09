Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33689 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbcFINll (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2016 09:41:41 -0400
Received: by mail-wm0-f65.google.com with SMTP id r5so10839420wmr.0
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2016 06:41:41 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	linux-media@vger.kernel.org (open list:MEDIA DRIVERS FOR RENESAS - FCP),
	linux-renesas-soc@vger.kernel.org (open list:MEDIA DRIVERS FOR RENESAS
	- FCP),
	devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
	DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc: Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH 1/3] dt-bindings: Update Renesas R-Car FCP DT binding
Date: Thu,  9 Jun 2016 14:41:32 +0100
Message-Id: <1465479695-18644-2-git-send-email-kieran@bingham.xyz>
In-Reply-To: <1465479695-18644-1-git-send-email-kieran@bingham.xyz>
References: <1465479695-18644-1-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FCP driver, can also support the FCPF variant for FDP1 compatible
processing.

Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
---
 Documentation/devicetree/bindings/media/renesas,fcp.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
index 6a12960609d8..271dcfdb5a76 100644
--- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
+++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
@@ -7,12 +7,14 @@ conversion of AXI transactions in order to reduce the memory bandwidth.
 
 There are three types of FCP: FCP for Codec (FCPC), FCP for VSP (FCPV) and FCP
 for FDP (FCPF). Their configuration and behaviour depend on the module they
-are paired with. These DT bindings currently support the FCPV only.
+are paired with. These DT bindings currently support the FCPV and FCPF.
 
  - compatible: Must be one or more of the following
 
    - "renesas,r8a7795-fcpv" for R8A7795 (R-Car H3) compatible 'FCP for VSP'
+   - "renesas,r8a7795-fcpf" for R8A7795 (R-Car H3) compatible 'FCP for FDP'
    - "renesas,fcpv" for generic compatible 'FCP for VSP'
+   - "renesas,fcpf" for generic compatible 'FCP for FDP'
 
    When compatible with the generic version, nodes must list the
    SoC-specific version corresponding to the platform first, followed by the
-- 
2.7.4


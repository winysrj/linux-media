Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:45267 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbcCOAko (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 20:40:44 -0400
From: Simon Horman <horms+renesas@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH v4 2/2] media: soc_camera: rcar_vin: add device tree support for r8a7792
Date: Tue, 15 Mar 2016 09:40:27 +0900
Message-Id: <1458002427-3063-3-git-send-email-horms+renesas@verge.net.au>
In-Reply-To: <1458002427-3063-1-git-send-email-horms+renesas@verge.net.au>
References: <1458002427-3063-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simply document new compatibility string.
As a previous patch adds a generic R-Car Gen2 compatibility string
there appears to be no need for a driver updates.

By documenting this compat string it may be used in DTSs shipped, for
example as part of ROMs. It must be used in conjunction with the Gen2
fallback compat string. At this time there are no known differences between
the r8a7792 IP block and that implemented by the driver for the Gen2
fallback compat string. Thus there is no need to update the driver as the
use of the Gen2 fallback compat string will activate the correct code in
the current driver while leaving the option for r8a7792-specific driver
code to be activated in an updated driver should the need arise.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v4
* s/sting/string/ in changelog
* Added Ack from Geert Uytterhoeven

v3
* New patch
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 4266123888ed..6a4e61cbe011 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -9,6 +9,7 @@ channel which can be either RGB, YUYV or BT656.
    - "renesas,vin-r8a7795" for the R8A7795 device
    - "renesas,vin-r8a7794" for the R8A7794 device
    - "renesas,vin-r8a7793" for the R8A7793 device
+   - "renesas,vin-r8a7792" for the R8A7792 device
    - "renesas,vin-r8a7791" for the R8A7791 device
    - "renesas,vin-r8a7790" for the R8A7790 device
    - "renesas,vin-r8a7779" for the R8A7779 device
-- 
2.1.4


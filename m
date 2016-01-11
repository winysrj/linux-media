Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36353 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307AbcAKSAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 13:00:46 -0500
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH 2/3] media: soc_camera: rcar_vin: Add R-Car Gen3 support
Date: Tue, 12 Jan 2016 03:00:10 +0900
Message-Id: <1452535211-4869-3-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1452535211-4869-1-git-send-email-ykaneko0929@gmail.com>
References: <1452535211-4869-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>

Simply documents new compatibility string.
As a previous patch adds a generic R-Car Gen3 compatibility string
there appears to be no need for a driver updates.

Signed-off-by: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index c13ec5a..e1a92c9 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -8,6 +8,7 @@ channel which can be either RGB, YUYV or BT656.
  - compatible: Must be one of the following
    - "renesas,rcar-gen2-vin" for R-Car Gen2 Series
    - "renesas,rcar-gen3-vin" for R-Car Gen3 Series
+   - "renesas,vin-r8a7795" for the R8A7795 device
    - "renesas,vin-r8a7794" for the R8A7794 device
    - "renesas,vin-r8a7793" for the R8A7793 device
    - "renesas,vin-r8a7791" for the R8A7791 device
-- 
1.9.1


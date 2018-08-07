Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60426 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403877AbeHGSJz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 14:09:55 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH] media: dt: adv7604: Fix slave map documentation
Date: Tue,  7 Aug 2018 16:54:52 +0100
Message-Id: <20180807155452.797-1-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The reg-names property in the documentation is missing an '='. Add it.

Fixes: 9feb786876c7 ("media: dt-bindings: media: adv7604: Extend
bindings to allow specifying slave map addresses")

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 Documentation/devicetree/bindings/media/i2c/adv7604.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index dcf57e7c60eb..b3e688b77a38 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -66,7 +66,7 @@ Example:
 		 * other maps will retain their default addresses.
 		 */
 		reg = <0x4c>, <0x66>;
-		reg-names "main", "edid";
+		reg-names = "main", "edid";
 
 		reset-gpios = <&ioexp 0 GPIO_ACTIVE_LOW>;
 		hpd-gpios = <&ioexp 2 GPIO_ACTIVE_HIGH>;
-- 
2.17.1

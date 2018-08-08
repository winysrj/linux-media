Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:33370 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbeHHSyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 14:54:25 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: mchehab@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2] dt-bindings: media: adv7604: Fix slave map documentation
Date: Wed,  8 Aug 2018 17:33:51 +0100
Message-Id: <20180808163351.28852-1-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The reg-names property in the documentation is missing an '='. Add it.

Fixes: 9feb786876c7 ("media: dt-bindings: media: adv7604: Extend
bindings to allow specifying slave map addresses")

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

---
v2:
 - Commit title changed to prefix as "dt-bindings: media:"

If this is collected through a DT tree, I assume therefore this will be
fine, but if it is to go through the media-tree, please update as
necessaary to prevent the redundant dual "media:" tagging.

(I'll leave it to the maintainers to decide whose tree thise should go
through)

Thanks

Kieran

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

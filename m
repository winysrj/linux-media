Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47387 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751940AbeDSJb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 05:31:29 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, daniel@ffwll.ch,
        peda@axentia.se, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] dt-bindings: display: bridge: thc63lvd1024: Add lvds map property
Date: Thu, 19 Apr 2018 11:31:03 +0200
Message-Id: <1524130269-32688-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The THC63LVD1024 LVDS to RGB bridge supports two different input mapping
modes, selectable by means of an external pin.

Describe the LVDS mode map through a newly defined mandatory property in
device tree bindings.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 .../devicetree/bindings/display/bridge/thine,thc63lvd1024.txt          | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt b/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
index 37f0c04..0937595 100644
--- a/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
+++ b/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
@@ -12,6 +12,8 @@ Required properties:
 - compatible: Shall be "thine,thc63lvd1024"
 - vcc-supply: Power supply for TTL output, TTL CLOCKOUT signal, LVDS input,
   PPL and digital circuitry
+- thine,map: LVDS mapping mode selection signal, pin name "MAP". Shall be <1>
+  for mapping mode 1, <0> for mapping mode 2
 
 Optional properties:
 - powerdown-gpios: Power down GPIO signal, pin name "/PDWN". Active low
@@ -36,6 +38,7 @@ Example:
 
 		vcc-supply = <&reg_lvds_vcc>;
 		powerdown-gpios = <&gpio4 15 GPIO_ACTIVE_LOW>;
+		thine,map = <1>;
 
 		ports {
 			#address-cells = <1>;
-- 
2.7.4

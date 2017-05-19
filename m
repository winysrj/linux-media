Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:32931 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755324AbdESNHR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 09:07:17 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, geert@linux-m68k.org,
        magnus.damm@gmail.com, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, sergei.shtylyov@cogentembedded.com,
        horms@verge.net.au, devicetree@vger.kernel.org,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v3 3/4] media: adv7180: Add adv7180cp, adv7180st bindings
Date: Fri, 19 May 2017 15:07:03 +0200
Message-Id: <1495199224-16337-4-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To differentiate between two classes of chip packages that have
different numbers of input ports.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 Documentation/devicetree/bindings/media/i2c/adv7180.txt | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7180.txt b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
index 4da486f..552b6a8 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7180.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
@@ -6,6 +6,8 @@ digital interfaces like MIPI CSI-2 or parallel video.
 Required Properties :
 - compatible : value must be one of
 		"adi,adv7180"
+		"adi,adv7180cp"
+		"adi,adv7180st"
 		"adi,adv7182"
 		"adi,adv7280"
 		"adi,adv7280-m"
@@ -15,6 +17,19 @@ Required Properties :
 		"adi,adv7282"
 		"adi,adv7282-m"
 
+Device nodes of "adi,adv7180cp" and "adi,adv7180st" must contain one
+'port' child node per device input and output port, in accordance with the
+video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt. The port
+nodes are numbered as follows.
+
+  Port		adv7180cp	adv7180st
+-------------------------------------------------------------------
+  Input		0-2		0-5
+  Output	3		6
+
+The digital output port node must contain at least one endpoint.
+
 Optional Properties :
 - powerdown-gpios: reference to the GPIO connected to the powerdown pin,
   if any.
-- 
2.7.4

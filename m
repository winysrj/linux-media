Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35056 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933389AbcIVNTR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 09:19:17 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com
Cc: niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        ulrich.hecht+renesas@gmail.com, laurent.pinchart@ideasonboard.com,
        william.towle@codethink.co.uk, devicetree@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
Subject: [PATCH v2 1/2] media: adv7604: fix bindings inconsistency for default-input
Date: Thu, 22 Sep 2016 15:18:59 +0200
Message-Id: <1474550340-31455-2-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1474550340-31455-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1474550340-31455-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The text states that default-input is an endpoint property, but in the
example it is a device property.

The default input is a property of the chip, not of a particular port, so
the example makes more sense.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/devicetree/bindings/media/i2c/adv7604.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index 8337f75..9cbd92e 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -34,6 +34,7 @@ The digital output port node must contain at least one endpoint.
 Optional Properties:
 
   - reset-gpios: Reference to the GPIO connected to the device's reset pin.
+  - default-input: Select which input is selected after reset.
 
 Optional Endpoint Properties:
 
@@ -47,8 +48,6 @@ Optional Endpoint Properties:
   If none of hsync-active, vsync-active and pclk-sample is specified the
   endpoint will use embedded BT.656 synchronization.
 
-  - default-input: Select which input is selected after reset.
-
 Example:
 
 	hdmi_receiver@4c {
-- 
2.7.4


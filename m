Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56514 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753677AbbEUJDI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:03:08 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 04/20] media: adv7604: document support for ADV7612 dual HDMI input decoder
Date: Wed, 20 May 2015 17:39:24 +0100
Message-Id: <1432139980-12619-5-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ian Molton <ian.molton@codethink.co.uk>

This documentation accompanies the patch adding support for the ADV7612
dual HDMI decoder / repeater chip.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 .../devicetree/bindings/media/i2c/adv7604.txt        |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index c27cede..7eafdbc 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -1,15 +1,17 @@
-* Analog Devices ADV7604/11 video decoder with HDMI receiver
+* Analog Devices ADV7604/11/12 video decoder with HDMI receiver
 
-The ADV7604 and ADV7611 are multiformat video decoders with an integrated HDMI
-receiver. The ADV7604 has four multiplexed HDMI inputs and one analog input,
-and the ADV7611 has one HDMI input and no analog input.
+The ADV7604 and ADV7611/12 are multiformat video decoders with an integrated
+HDMI receiver. The ADV7604 has four multiplexed HDMI inputs and one analog
+input, and the ADV7611 has one HDMI input and no analog input. The 7612 is
+similar to the 7611 but has 2 HDMI inputs.
 
-These device tree bindings support the ADV7611 only at the moment.
+These device tree bindings support the ADV7611/12 only at the moment.
 
 Required Properties:
 
   - compatible: Must contain one of the following
     - "adi,adv7611" for the ADV7611
+    - "adi,adv7612" for the ADV7612
 
   - reg: I2C slave address
 
@@ -22,10 +24,10 @@ port, in accordance with the video interface bindings defined in
 Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
 are numbered as follows.
 
-  Port			ADV7611
+  Port			ADV7611    ADV7612
 ------------------------------------------------------------
-  HDMI			0
-  Digital output	1
+  HDMI			0             0, 1
+  Digital output	1                2
 
 The digital output port node must contain at least one endpoint.
 
-- 
1.7.10.4


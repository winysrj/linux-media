Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:55507 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752830AbbA2QTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:19:52 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 3/8] WmT: document "adi,adv7612"
Date: Thu, 29 Jan 2015 16:19:43 +0000
Message-Id: <1422548388-28861-4-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 Documentation/devicetree/bindings/media/i2c/adv7604.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index bc50da2..1ca6e5a 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -1,4 +1,4 @@
-* Analog Devices ADV7604/11 video decoder with HDMI receiver
+* Analog Devices ADV7604/11/12 video decoder with HDMI receiver
 
 The ADV7604 and ADV7611 are multiformat video decoders with an integrated HDMI
 receiver. The ADV7604 has four multiplexed HDMI inputs and one analog input,
@@ -10,6 +10,7 @@ Required Properties:
 
   - compatible: Must contain one of the following
     - "adi,adv7611" for the ADV7611
+    - "adi,adv7612" for the ADV7612
 
   - reg: I2C slave address
 
-- 
1.7.10.4


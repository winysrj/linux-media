Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49193 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGKOFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:12 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Stephen Warren <swarren@nvidia.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v4 11/21] DT: leds: Add flash led devices related properties
Date: Fri, 11 Jul 2014 16:04:14 +0200
Message-id: <1405087464-13762-12-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Addition of a LED Flash Class extension entails the need for flash led
specific device tree properties. The properties being added are:
iout-torch, iout-flash, iout-indicator and flash-timeout.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/leds/common.txt |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
index 2d88816..40f4b9a 100644
--- a/Documentation/devicetree/bindings/leds/common.txt
+++ b/Documentation/devicetree/bindings/leds/common.txt
@@ -3,6 +3,17 @@ Common leds properties.
 Optional properties for child nodes:
 - label : The label for this LED.  If omitted, the label is
   taken from the node name (excluding the unit address).
+- iout-torch : Array of maximum intensities in microamperes of the torch
+	led currents in order from sub-led 0 to N-1, where N is the number
+	of torch sub-leds exposed by the device
+- iout-flash : Array of maximum intensities in microamperes of the flash
+	led currents in order from sub-led 0 to N-1, where N is the number
+	of flash sub-leds exposed by the device
+- iout-indicator : Array of maximum intensities in microamperes of
+	the indicator led currents in order from sub-led 0 to N-1,
+	where N is the number of indicator sub-leds exposed by the device
+- flash-timeout : timeout in microseconds after which flash led
+	is turned off
 
 - linux,default-trigger :  This parameter, if present, is a
     string defining the trigger assigned to the LED.  Current triggers are:
@@ -19,5 +30,10 @@ Examples:
 system-status {
 	label = "Status";
 	linux,default-trigger = "heartbeat";
+	iout-torch = <500 500>;
+	iout-flash = <1000 1000>;
+	iout-indicator = <100 100>;
+	flash-timeout = <1000>;
+
 	...
 };
-- 
1.7.9.5


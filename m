Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:38692 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbbETOLY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 10:11:24 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	devicetree@vger.kernel.org
Subject: [PATCH v8 6/8] DT: s5c73m3: Add documentation for samsung,flash-led
 property
Date: Wed, 20 May 2015 16:10:13 +0200
Message-id: <1432131015-22397-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a description of 'samsung,flash-led' property
to the samsung-s5c73m3.txt.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/media/samsung-s5c73m3.txt  |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt b/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
index 2c85c45..8a413c0 100644
--- a/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
+++ b/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
@@ -32,6 +32,10 @@ Optional properties:
 - clock-frequency   : the frequency at which the "cis_extclk" clock should be
 		      configured to operate, in Hz; if this property is not
 		      specified default 24 MHz value will be used.
+- samsung,flash-led : phandle to the flash LED associated with this sensor.
+		      Flash LED is represented by the child node of a flash LED
+		      device
+		      (see Documentation/devicetree/bindings/leds/common.txt).
 
 The common video interfaces bindings (see video-interfaces.txt) should be used
 to specify link from the S5C73M3 to an external image data receiver. The S5C73M3
@@ -78,6 +82,7 @@ i2c@138A000000 {
 		clock-names = "cis_extclk";
 		reset-gpios = <&gpf1 3 1>;
 		standby-gpios = <&gpm0 1 1>;
+		samsung,flash-led = <&camera1_flash>;
 		port {
 			s5c73m3_ep: endpoint {
 				remote-endpoint = <&csis0_ep>;
-- 
1.7.9.5


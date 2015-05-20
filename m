Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:37051 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbbETOLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 10:11:34 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	devicetree@vger.kernel.org
Subject: [PATCH v8 7/8] DT: s5k6a3: Add documentation for samsung,flash-led
 property
Date: Wed, 20 May 2015 16:10:14 +0200
Message-id: <1432131015-22397-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a description of 'samsung,flash-led' property
to the samsung-s5k6a3.txt.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/media/samsung-s5k6a3.txt   |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
index cce01e8..25f2e82 100644
--- a/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
+++ b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
@@ -22,6 +22,10 @@ Optional properties:
 - clock-frequency : the frequency at which the "extclk" clock should be
 		    configured to operate, in Hz; if this property is not
 		    specified default 24 MHz value will be used.
+- samsung,flash-led : phandle to the flash LED associated with this sensor.
+		      Flash LED is represented by the child node of a flash LED
+		      device
+		      (see Documentation/devicetree/bindings/leds/common.txt).
 
 The common video interfaces bindings (see video-interfaces.txt) should be
 used to specify link to the image data receiver. The S5K6A3(YX) device
-- 
1.7.9.5


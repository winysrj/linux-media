Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:12914 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbCTPET (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 11:04:19 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v1 09/11] DT: Add documentation for exynos4-is 'flashes'
 property
Date: Fri, 20 Mar 2015 16:03:29 +0100
Message-id: <1426863811-12516-10-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a description of 'flashes' property
to the samsung-fimc.txt.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 922d6f8..cb0e263 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -40,6 +40,13 @@ should be inactive. For the "active-a" state the camera port A must be activated
 and the port B deactivated and for the state "active-b" it should be the other
 way around.
 
+Optional properties:
+
+- flashes - Array of phandles to the flash LEDs that can be controlled by the
+	    sub-devices contained in this media device. Flash LED is
+	    represented by a child node of a flash LED device
+	    (see Documentation/devicetree/bindings/leds/common.txt).
+
 The 'camera' node must include at least one 'fimc' child node.
 
 
@@ -166,6 +173,7 @@ Example:
 		clock-output-names = "cam_a_clkout", "cam_b_clkout";
 		pinctrl-names = "default";
 		pinctrl-0 = <&cam_port_a_clk_active>;
+		flashes = <&camera_flash>, <&system_torch>;
 		status = "okay";
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.9.5


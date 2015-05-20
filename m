Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:37066 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbbETOLo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 10:11:44 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	devicetree@vger.kernel.org
Subject: [PATCH v8 8/8] DT: samsung-fimc: Add examples for samsung,flash-led
 property
Date: Wed, 20 May 2015 16:10:15 +0200
Message-id: <1432131015-22397-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds examples for samsung,flash-led property to the
samsung-fimc.txt.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/media/samsung-fimc.txt     |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 922d6f8..57edffa 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -126,6 +126,8 @@ Example:
 			clocks = <&camera 1>;
 			clock-names = "mclk";
 
+			samsung,flash-led = <&front_cam_flash>;
+
 			port {
 				s5k6aa_ep: endpoint {
 					remote-endpoint = <&fimc0_ep>;
@@ -147,6 +149,8 @@ Example:
 			clocks = <&camera 0>;
 			clock-names = "mclk";
 
+			samsung,flash-led = <&rear_cam_flash>;
+
 			port {
 				s5c73m3_1: endpoint {
 					data-lanes = <1 2 3 4>;
-- 
1.7.9.5


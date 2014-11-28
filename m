Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53654 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaK1JVN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 04:21:13 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH/RFC v8 14/14] DT: Add documentation for the Skyworks AAT1290
Date: Fri, 28 Nov 2014 10:18:06 +0100
Message-id: <1417166286-27685-15-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree binding documentation for
1.5A Step-Up Current Regulator for Flash LEDs.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
---
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-aat1290.txt b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
new file mode 100644
index 0000000..8f001dd
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
@@ -0,0 +1,17 @@
+* Skyworks Solutions, Inc. AAT1290 Current Regulator for Flash LEDs
+
+Required properties:
+
+- compatible : should be "skyworks,aat1290"
+- gpios : two gpio pins in order FLEN, EN/SET
+- flash-timeout-microsec : maximum flash timeout in microseconds -
+			   it can be calculated using following formula:
+			   T = 8.82 * 10^9 * Ct
+
+Example:
+
+flash_led: flash-led {
+	compatible = "skyworks,aat1290";
+	gpios = <&gpj1 1 0>, <&gpj1 2 0>;
+	flash-timeout-microsec = <1940000>;
+}
-- 
1.7.9.5


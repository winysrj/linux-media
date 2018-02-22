Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62262 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbeBVMEE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 07:04:04 -0500
From: Claudiu Beznea <claudiu.beznea@microchip.com>
To: <thierry.reding@gmail.com>, <shc_work@mail.ru>, <kgene@kernel.org>,
        <krzk@kernel.org>, <linux@armlinux.org.uk>,
        <mturquette@baylibre.com>, <sboyd@codeaurora.org>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <airlied@linux.ie>, <kamil@wypas.org>,
        <b.zolnierkie@samsung.com>, <jdelvare@suse.com>,
        <linux@roeck-us.net>, <dmitry.torokhov@gmail.com>,
        <rpurdie@rpsys.net>, <jacek.anaszewski@gmail.com>, <pavel@ucw.cz>,
        <mchehab@kernel.org>, <sean@mess.org>, <lee.jones@linaro.org>,
        <daniel.thompson@linaro.org>, <jingoohan1@gmail.com>,
        <milo.kim@ti.com>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <corbet@lwn.net>, <nicolas.ferre@microchip.com>,
        <alexandre.belloni@free-electrons.com>
CC: <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-leds@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v3 09/10] pwm: add documentation for pwm push-pull mode
Date: Thu, 22 Feb 2018 14:01:20 +0200
Message-ID: <1519300881-8136-10-git-send-email-claudiu.beznea@microchip.com>
In-Reply-To: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for PWM push-pull mode.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/pwm/pwm.txt |  2 ++
 Documentation/pwm.txt                         | 16 ++++++++++++++++
 include/dt-bindings/pwm/pwm.h                 |  1 +
 3 files changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/pwm/pwm.txt b/Documentation/devicetree/bindings/pwm/pwm.txt
index c2b4b9ba0e3f..968dd786ad7c 100644
--- a/Documentation/devicetree/bindings/pwm/pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm.txt
@@ -49,6 +49,8 @@ Optionally, the pwm-specifier can encode a number of flags (defined in
 - PWM_DTMODE_COMPLEMENTARY: PWM complementary working mode (for PWM
 channels two outputs); if not specified, the default for PWM channel will
 be used
+- PWM_DTMODE_PUSH_PULL: PWM push-pull working modes (for PWM channels with
+two outputs); if not specified the default for PWM channel will be used
 
 Example with optional PWM specifier for inverse polarity and complementary
 mode:
diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
index 59592f8cc381..174c371583b6 100644
--- a/Documentation/pwm.txt
+++ b/Documentation/pwm.txt
@@ -128,6 +128,22 @@ channel that was exported. The following properties will then be available:
     PWML1   |__|  |__|  |__|  |__|
             <--T-->
 
+    Push-pull mode - for PWM channels with two outputs; output waveforms
+        for a PWM channel with 2 outputs, in push-pull mode, with normal
+        polarity looks like this:
+            __          __
+    PWMH __|  |________|  |________
+                  __          __
+    PWML ________|  |________|  |__
+           <--T-->
+
+    If polarity is inversed:
+         __    ________    ________
+    PWMH   |__|        |__|
+         ________    ________    __
+    PWML         |__|        |__|
+           <--T-->
+
     Where T is the signal period.
 
 Implementing a PWM driver
diff --git a/include/dt-bindings/pwm/pwm.h b/include/dt-bindings/pwm/pwm.h
index b4d61269aced..674dfdd59595 100644
--- a/include/dt-bindings/pwm/pwm.h
+++ b/include/dt-bindings/pwm/pwm.h
@@ -12,5 +12,6 @@
 
 #define PWM_POLARITY_INVERTED			(1 << 0)
 #define PWM_DTMODE_COMPLEMENTARY		(1 << 1)
+#define PWM_DTMODE_PUSH_PULL			(1 << 2)
 
 #endif
-- 
2.7.4

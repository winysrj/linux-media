Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62205 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932121AbeBVMDf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 07:03:35 -0500
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
Subject: [PATCH v3 06/10] pwm: add PWM modes
Date: Thu, 22 Feb 2018 14:01:17 +0200
Message-ID: <1519300881-8136-7-git-send-email-claudiu.beznea@microchip.com>
In-Reply-To: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add PWM normal and complementary modes.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 Documentation/devicetree/bindings/pwm/pwm.txt |  9 +++++++--
 Documentation/pwm.txt                         | 26 +++++++++++++++++++++++---
 include/dt-bindings/pwm/pwm.h                 |  1 +
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm.txt b/Documentation/devicetree/bindings/pwm/pwm.txt
index 8556263b8502..c2b4b9ba0e3f 100644
--- a/Documentation/devicetree/bindings/pwm/pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm.txt
@@ -46,11 +46,16 @@ period in nanoseconds.
 Optionally, the pwm-specifier can encode a number of flags (defined in
 <dt-bindings/pwm/pwm.h>) in a third cell:
 - PWM_POLARITY_INVERTED: invert the PWM signal polarity
+- PWM_DTMODE_COMPLEMENTARY: PWM complementary working mode (for PWM
+channels two outputs); if not specified, the default for PWM channel will
+be used
 
-Example with optional PWM specifier for inverse polarity
+Example with optional PWM specifier for inverse polarity and complementary
+mode:
 
 	bl: backlight {
-		pwms = <&pwm 0 5000000 PWM_POLARITY_INVERTED>;
+		pwms = <&pwm 0 5000000
+			(PWM_DTMODE_COMPLEMENTARY | PWM_POLARITY_INVERTED)>;
 		pwm-names = "backlight";
 	};
 
diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
index 8fbf0aa3ba2d..59592f8cc381 100644
--- a/Documentation/pwm.txt
+++ b/Documentation/pwm.txt
@@ -61,9 +61,9 @@ In addition to the PWM state, the PWM API also exposes PWM arguments, which
 are the reference PWM config one should use on this PWM.
 PWM arguments are usually platform-specific and allows the PWM user to only
 care about dutycycle relatively to the full period (like, duty = 50% of the
-period). struct pwm_args contains 2 fields (period and polarity) and should
-be used to set the initial PWM config (usually done in the probe function
-of the PWM user). PWM arguments are retrieved with pwm_get_args().
+period). struct pwm_args contains 3 fields (period, polarity and mode) and
+should be used to set the initial PWM config (usually done in the probe
+function of the PWM user). PWM arguments are retrieved with pwm_get_args().
 
 Using PWMs with the sysfs interface
 -----------------------------------
@@ -110,6 +110,26 @@ channel that was exported. The following properties will then be available:
 	- 0 - disabled
 	- 1 - enabled
 
+  mode
+    Get/set PWM channel working mode.
+
+    Normal mode - for PWM channels with one output; this should be the
+        default working mode for every PWM channel; output waveforms looks
+        like this:
+             __    __    __    __
+    PWM   __|  |__|  |__|  |__|  |__
+            <--T-->
+
+    Complementary mode - for PWM channels two outputs; output waveforms
+        looks line this:
+             __    __    __    __
+    PWMH1 __|  |__|  |__|  |__|  |__
+          __    __    __    __    __
+    PWML1   |__|  |__|  |__|  |__|
+            <--T-->
+
+    Where T is the signal period.
+
 Implementing a PWM driver
 -------------------------
 
diff --git a/include/dt-bindings/pwm/pwm.h b/include/dt-bindings/pwm/pwm.h
index ab9a077e3c7d..b4d61269aced 100644
--- a/include/dt-bindings/pwm/pwm.h
+++ b/include/dt-bindings/pwm/pwm.h
@@ -11,5 +11,6 @@
 #define _DT_BINDINGS_PWM_PWM_H
 
 #define PWM_POLARITY_INVERTED			(1 << 0)
+#define PWM_DTMODE_COMPLEMENTARY		(1 << 1)
 
 #endif
-- 
2.7.4

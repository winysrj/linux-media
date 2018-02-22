Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62237 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbeBVMDy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 07:03:54 -0500
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
Subject: [PATCH v3 08/10] pwm: add push-pull mode support
Date: Thu, 22 Feb 2018 14:01:19 +0200
Message-ID: <1519300881-8136-9-git-send-email-claudiu.beznea@microchip.com>
In-Reply-To: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add push-pull mode support. In push-pull mode the channels' outputs have
same polarities and the edges are complementary delayed for one period.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 include/linux/pwm.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 0ba416ab2772..765d760ef82d 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -29,11 +29,14 @@ enum pwm_polarity {
  * PWM modes
  * @PWM_MODE_NORMAL_BIT: PWM has one output
  * @PWM_MODE_COMPLEMENTARY_BIT: PWM has 2 outputs with opposite polarities
+ * @PWM_MODE_PUSH_PULL_BIT: PWM has 2 outputs with same polarities and the edges
+ * are complementary delayed for one period
  * @PWM_MODE_CNT: PWM modes count
  */
 enum {
 	PWM_MODE_NORMAL_BIT,
 	PWM_MODE_COMPLEMENTARY_BIT,
+	PWM_MODE_PUSH_PULL_BIT,
 	PWM_MODE_CNT,
 };
 
@@ -481,7 +484,11 @@ static inline bool pwm_caps_valid(struct pwm_caps caps)
 
 static inline const char * const pwm_mode_desc(unsigned long mode)
 {
-	static const char * const modes[] = { "normal", "complementary"	};
+	static const char * const modes[] = {
+		"normal",
+		"complementary",
+		"push-pull",
+	};
 
 	if (!pwm_mode_valid(mode))
 		return "invalid";
-- 
2.7.4

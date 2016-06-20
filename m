Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:45802 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbcFTWVy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 18:21:54 -0400
Subject: [PATCH] leds: Add no-op gpio_led_register_device when LED subsystem
 is disabled
To: Jacek Anaszewski <j.anaszewski@samsung.com>
References: <20160613200211.14790-1-afd@ti.com>
 <20160613200211.14790-13-afd@ti.com> <5760FA52.7010806@samsung.com>
 <57647DBD.2010406@ti.com> <57679E38.3080901@samsung.com>
CC: Russell King <linux@armlinux.org.uk>,
	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sre@kernel.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Richard Purdie <rpurdie@rpsys.net>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>, <linux-pwm@vger.kernel.org>,
	<lguest@lists.ozlabs.org>, <linux-wireless@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-leds@vger.kernel.org>,
	<linux-media@vger.kernel.org>
From: "Andrew F. Davis" <afd@ti.com>
Message-ID: <57686A94.2010704@ti.com>
Date: Mon, 20 Jun 2016 17:13:40 -0500
MIME-Version: 1.0
In-Reply-To: <57679E38.3080901@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some systems use 'gpio_led_register_device' to make an in-memory copy of
their LED device table so the original can be removed as .init.rodata.
When the LED subsystem is not enabled source in the led directory is not
built and so this function may be undefined. Fix this here.

Signed-off-by: Andrew F. Davis <afd@ti.com>
---
 include/linux/leds.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index d2b1306..a4a3da6 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -386,8 +386,16 @@ struct gpio_led_platform_data {
                                        unsigned long *delay_off);
 };

+#ifdef CONFIG_NEW_LEDS
 struct platform_device *gpio_led_register_device(
                int id, const struct gpio_led_platform_data *pdata);
+#else
+static inline struct platform_device *gpio_led_register_device(
+               int id, const struct gpio_led_platform_data *pdata)
+{
+       return 0;
+}
+#endif

 enum cpu_led_event {
        CPU_LED_IDLE_START,     /* CPU enters idle */
-- 
2.9.0

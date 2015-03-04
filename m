Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:12591 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110AbbCDQQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 11:16:22 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Lee Jones <lee.jones@linaro.org>
Subject: [PATCH/RFC v12 06/19] mfd: max77693: Remove struct
 max77693_led_platform_data
Date: Wed, 04 Mar 2015 17:14:27 +0100
Message-id: <1425485680-8417-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The flash part of the max77693 device will depend only on OF, and thus
will not use board files. Since there are no other users of the
struct max77693_led_platform_data its existence is unjustified.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/max77693.h |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index f0b6585..ce894b6 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -87,19 +87,6 @@ enum max77693_led_boost_mode {
 	MAX77693_LED_BOOST_FIXED,
 };
 
-struct max77693_led_platform_data {
-	u32 fleds[2];
-	u32 iout_torch[2];
-	u32 iout_flash[2];
-	u32 trigger[2];
-	u32 trigger_type[2];
-	u32 num_leds;
-	u32 boost_mode;
-	u32 flash_timeout;
-	u32 boost_vout;
-	u32 low_vsys;
-};
-
 /* MAX77693 */
 
 struct max77693_platform_data {
-- 
1.7.9.5


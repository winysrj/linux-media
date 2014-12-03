Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26299 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaLCQIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 11:08:43 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Lee Jones <lee.jones@linaro.org>
Subject: [PATCH/RFC v9 04/19] mfd: max77693: adjust max77693_led_platform_data
Date: Wed, 03 Dec 2014 17:06:39 +0100
Message-id: <1417622814-10845-5-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add "label" array for Device Tree strings with the name of a LED device
and make flash_timeout a two element array, for caching the sub-led
related flash timeout. Added is also an array for caching pointers to the
sub-nodes representing sub-leds.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/max77693.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index f0b6585..c80ee99 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -88,16 +88,18 @@ enum max77693_led_boost_mode {
 };
 
 struct max77693_led_platform_data {
+	const char *label[2];
 	u32 fleds[2];
 	u32 iout_torch[2];
 	u32 iout_flash[2];
 	u32 trigger[2];
 	u32 trigger_type[2];
+	u32 flash_timeout[2];
 	u32 num_leds;
 	u32 boost_mode;
-	u32 flash_timeout;
 	u32 boost_vout;
 	u32 low_vsys;
+	struct device_node *sub_nodes[2];
 };
 
 /* MAX77693 */
-- 
1.7.9.5


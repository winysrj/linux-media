Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:59785 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbbFSHdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 03:33:00 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH] leds: aat1290: Add 'static' modifier to init_mm_current_scale
Date: Fri, 19 Jun 2015 09:32:44 +0200
Message-id: <1434699164-5750-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix sparse warning by adding static modifier to the function
init_mm_current_scale.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
---
 drivers/leds/leds-aat1290.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
index 8635404..b055882 100644
--- a/drivers/leds/leds-aat1290.c
+++ b/drivers/leds/leds-aat1290.c
@@ -308,7 +308,7 @@ static void aat1290_led_validate_mm_current(struct aat1290_led *led,
 	cfg->max_brightness = b + 1;
 }
 
-int init_mm_current_scale(struct aat1290_led *led,
+static int init_mm_current_scale(struct aat1290_led *led,
 			struct aat1290_led_config_data *cfg)
 {
 	int max_mm_current_percent[] = { 20, 22, 25, 28, 32, 36, 40, 45, 50, 56,
-- 
1.7.9.5


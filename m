Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62429 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbBRQVl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 11:21:41 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v11 02/20] leds: flash: Improve sync strobe related sysfs
 attributes
Date: Wed, 18 Feb 2015 17:20:23 +0100
Message-id: <1424276441-3969-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current format of synchronized strobe related attributes introduces
problems when it comes to parsing. Avoding the usage of square brackets
and colons makes the parsing more convenient.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class-flash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
index 4a19fd4..a2da52e 100644
--- a/drivers/leds/led-class-flash.c
+++ b/drivers/leds/led-class-flash.c
@@ -224,11 +224,11 @@ static ssize_t available_sync_leds_show(struct device *dev,
 	char *pbuf = buf;
 	int i, buf_len;
 
-	buf_len = sprintf(pbuf, "[0: none] ");
+	buf_len = sprintf(pbuf, "0.none ");
 	pbuf += buf_len;
 
 	for (i = 0; i < fled_cdev->num_sync_leds; ++i) {
-		buf_len = sprintf(pbuf, "[%d: %s] ", i + 1,
+		buf_len = sprintf(pbuf, "%d.%s ", i + 1,
 				  fled_cdev->sync_leds[i]->led_cdev.name);
 		pbuf += buf_len;
 	}
@@ -281,7 +281,7 @@ static ssize_t flash_sync_strobe_show(struct device *dev,
 		sync_led_name = (char *)
 			fled_cdev->sync_leds[sled_id - 1]->led_cdev.name;
 
-	return sprintf(buf, "[%d: %s]\n", sled_id, sync_led_name);
+	return sprintf(buf, "%d.%s\n", sled_id, sync_led_name);
 }
 static DEVICE_ATTR_RW(flash_sync_strobe);
 
-- 
1.7.9.5


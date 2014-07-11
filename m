Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49142 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaGKOEf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:35 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 01/21] leds: make brightness type consistent across
 whole subsystem
Date: Fri, 11 Jul 2014 16:04:04 +0200
Message-id: <1405087464-13762-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentations states that brightness units type is enum led_brightness
and this is the type used by the led API functions. Adjust the type
of brightness variables in the struct led_classdev accordingly.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 include/linux/leds.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index e436864..995f933 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -31,8 +31,8 @@ enum led_brightness {
 
 struct led_classdev {
 	const char		*name;
-	int			 brightness;
-	int			 max_brightness;
+	enum led_brightness	 brightness;
+	enum led_brightness	 max_brightness;
 	int			 flags;
 
 	/* Lower 16 bits reflect status */
-- 
1.7.9.5


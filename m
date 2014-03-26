Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45397 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaCZC07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 22:26:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] adv7611: Set HPD GPIO direction to output
Date: Wed, 26 Mar 2014 03:28:49 +0100
Message-Id: <1395800929-17036-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HPD GPIO is used as an output but its direction is never set. Fix
it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

This patch applies on top of the ADV7611 support series queued for v3.16.

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 51f14ab..b38ebb9 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2845,7 +2845,7 @@ static int adv7604_probe(struct i2c_client *client,
 		if (IS_ERR(state->hpd_gpio[i]))
 			continue;
 
-		gpiod_set_value_cansleep(state->hpd_gpio[i], 0);
+		gpiod_direction_output(state->hpd_gpio[i], 0);
 
 		v4l_info(client, "Handling HPD %u GPIO\n", i);
 	}
-- 
Regards,

Laurent Pinchart


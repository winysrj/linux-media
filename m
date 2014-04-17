Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaDQONp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 48/49] adv7604: Set HPD GPIO direction to output
Date: Thu, 17 Apr 2014 16:13:19 +0200
Message-Id: <1397744000-23967-49-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HPD GPIO is used as an output but its direction is never set. Fix
it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 63f036f..51029e1 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2798,7 +2798,7 @@ static int adv7604_probe(struct i2c_client *client,
 		if (IS_ERR(state->hpd_gpio[i]))
 			continue;
 
-		gpiod_set_value_cansleep(state->hpd_gpio[i], 0);
+		gpiod_direction_output(state->hpd_gpio[i], 0);
 
 		v4l_info(client, "Handling HPD %u GPIO\n", i);
 	}
-- 
1.8.3.2


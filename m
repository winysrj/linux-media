Return-path: <linux-media-owner@vger.kernel.org>
Received: from gromit.nocabal.de ([78.46.53.8]:58923 "EHLO gromit.nocabal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbcAIUYz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 15:24:55 -0500
From: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
To: linux-media@vger.kernel.org
Cc: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
Subject: [PATCH 2/5] [media] ts2020: cancel_delayed_work_sync before device removal / kfree
Date: Sat,  9 Jan 2016 21:18:44 +0100
Message-Id: <1452370727-23128-3-git-send-email-emw-linux-kernel@nocabal.de>
In-Reply-To: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
References: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ts2020_remove  was  calling  kfree(dev)  with  possibly  still  active
schedule_delayed_work(dev->stat_work).  A similar bug in si2157 caused
kernel panics in call_timer_fn e.g. after rmmod cx23885.

Signed-off-by: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
---
 drivers/media/dvb-frontends/ts2020.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 7979e5d..14b410f 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -712,6 +712,10 @@ static int ts2020_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
+	/* stop statistics polling */
+	if (!dev->dont_poll)
+		cancel_delayed_work_sync(&dev->stat_work);
+
 	regmap_exit(dev->regmap);
 	kfree(dev);
 	return 0;
-- 
2.5.0


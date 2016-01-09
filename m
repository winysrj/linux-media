Return-path: <linux-media-owner@vger.kernel.org>
Received: from gromit.nocabal.de ([78.46.53.8]:45933 "EHLO gromit.nocabal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbcAIUY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 15:24:56 -0500
From: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
To: linux-media@vger.kernel.org
Cc: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
Subject: [PATCH 5/5] [media] rtl2830: cancel_delayed_work_sync before device removal / kfree
Date: Sat,  9 Jan 2016 21:18:47 +0100
Message-Id: <1452370727-23128-6-git-send-email-emw-linux-kernel@nocabal.de>
In-Reply-To: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
References: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rtl2830_remove  was  calling  kfree(dev) with  possibly  still  active
schedule_delayed_work(&dev->stat_work).   A  similar   bug  in  si2157
caused kernel panics in call_timer_fn e.g. after rmmod cx23885.

Signed-off-by: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
---
 drivers/media/dvb-frontends/rtl2830.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index b792f30..74b7712 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -900,6 +900,9 @@ static int rtl2830_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
+	/* stop statistics polling */
+	cancel_delayed_work_sync(&dev->stat_work);
+
 	i2c_del_mux_adapter(dev->adapter);
 	regmap_exit(dev->regmap);
 	kfree(dev);
-- 
2.5.0


Return-path: <linux-media-owner@vger.kernel.org>
Received: from gromit.nocabal.de ([78.46.53.8]:37724 "EHLO gromit.nocabal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394AbcAIUYz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 15:24:55 -0500
From: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
To: linux-media@vger.kernel.org
Cc: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
Subject: [PATCH 4/5] [media] af9033: cancel_delayed_work_sync before device removal / kfree
Date: Sat,  9 Jan 2016 21:18:46 +0100
Message-Id: <1452370727-23128-5-git-send-email-emw-linux-kernel@nocabal.de>
In-Reply-To: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
References: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

af9033_remove  was  calling  kfree(dev)  with  possibly  still  active
schedule_delayed_work(&dev->stat_work).   A  similar   bug  in  si2157
caused kernel panics in call_timer_fn e.g. after rmmod cx23885.

Signed-off-by: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
---
 drivers/media/dvb-frontends/af9033.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index bc35206..8b328d1 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -1372,6 +1372,9 @@ static int af9033_remove(struct i2c_client *client)
 
 	dev_dbg(&dev->client->dev, "\n");
 
+	/* stop statistics polling */
+	cancel_delayed_work_sync(&dev->stat_work);
+
 	dev->fe.ops.release = NULL;
 	dev->fe.demodulator_priv = NULL;
 	kfree(dev);
-- 
2.5.0


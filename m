Return-path: <linux-media-owner@vger.kernel.org>
Received: from gromit.nocabal.de ([78.46.53.8]:56372 "EHLO gromit.nocabal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbcAIUYz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 15:24:55 -0500
From: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
To: linux-media@vger.kernel.org
Cc: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
Subject: [PATCH 1/5] [media] si2157: cancel_delayed_work_sync before device removal / kfree
Date: Sat,  9 Jan 2016 21:18:43 +0100
Message-Id: <1452370727-23128-2-git-send-email-emw-linux-kernel@nocabal.de>
In-Reply-To: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
References: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

si2157_remove  was  calling  kfree(dev)  with  possibly  still  active
schedule_delayed_work(dev->stat_work).  This  caused kernel  panics in
call_timer_fn e.g. after rmmod cx23885.

Signed-off-by: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
---
 drivers/media/tuners/si2157.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index ce157ed..bfb1d59 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -457,6 +457,9 @@ static int si2157_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
+	/* stop statistics polling */
+	cancel_delayed_work_sync(&dev->stat_work);
+
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
 	kfree(dev);
-- 
2.5.0


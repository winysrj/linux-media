Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35019 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753584AbdGJImL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 04:42:11 -0400
Received: by mail-it0-f66.google.com with SMTP id v193so12182015itc.2
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 01:42:10 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] media/dvb: earth-pt3: fix hang-up in a rare case
Date: Mon, 10 Jul 2017 17:40:13 +0900
Message-Id: <20170710084013.4321-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

When a user starts and stops filtering at a demux device too quickly
in a very short interval, the user process hangs in uninterruptible sleep,
due to an inconsistency of kthread status in the driver.
The kthread can be stopped before it starts running its thread function,
but the invocation status was partly managed in the kthread function,
which resulted in a double kthread_stop() of one kthread.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/pci/pt3/pt3.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index e8b5d099215..34044a45fec 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -472,7 +472,6 @@ static int pt3_fetch_thread(void *data)
 	}
 	dev_dbg(adap->dvb_adap.device, "PT3: [%s] exited\n",
 		adap->thread->comm);
-	adap->thread = NULL;
 	return 0;
 }
 
@@ -486,6 +485,7 @@ static int pt3_start_streaming(struct pt3_adapter *adap)
 	if (IS_ERR(thread)) {
 		int ret = PTR_ERR(thread);
 
+		adap->thread = NULL;
 		dev_warn(adap->dvb_adap.device,
 			 "PT3 (adap:%d, dmx:%d): failed to start kthread\n",
 			 adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
@@ -508,6 +508,7 @@ static int pt3_stop_streaming(struct pt3_adapter *adap)
 
 	/* kill the fetching thread */
 	ret = kthread_stop(adap->thread);
+	adap->thread = NULL;
 	return ret;
 }
 
@@ -520,14 +521,8 @@ static int pt3_start_feed(struct dvb_demux_feed *feed)
 
 	adap = container_of(feed->demux, struct pt3_adapter, demux);
 	adap->num_feeds++;
-	if (adap->thread)
+	if (adap->num_feeds > 1)
 		return 0;
-	if (adap->num_feeds != 1) {
-		dev_warn(adap->dvb_adap.device,
-			 "%s: unmatched start/stop_feed in adap:%i/dmx:%i\n",
-			 __func__, adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
-		adap->num_feeds = 1;
-	}
 
 	return pt3_start_streaming(adap);
 
-- 
2.13.2

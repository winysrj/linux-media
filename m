Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp509.mail.kks.yahoo.co.jp ([114.111.99.158]:23442 "HELO
	smtp509.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755376Ab2CJPpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 10:45:34 -0500
From: tskd2@yahoo.co.jp
To: linux-media@vger.kernel.org
Cc: Akihiro Tsukada <tskd2@yahoo.co.jp>
Subject: [PATCH 4/4] dvb: earth-pt1: remove unsupported net subdevices
Date: Sun, 11 Mar 2012 00:38:16 +0900
Message-Id: <1331393896-17902-4-git-send-email-tskd2@yahoo.co.jp>
In-Reply-To: <1331393896-17902-1-git-send-email-tskd2@yahoo.co.jp>
References: <1331393896-17902-1-git-send-email-tskd2@yahoo.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd2@yahoo.co.jp>

PT1 and PT2 do not have net functions.

Signed-off-by: Akihiro Tsukada <tskd2@yahoo.co.jp>
---
 drivers/media/dvb/pt1/pt1.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/pt1/pt1.c b/drivers/media/dvb/pt1/pt1.c
index 9cd161c..15b35c4 100644
--- a/drivers/media/dvb/pt1/pt1.c
+++ b/drivers/media/dvb/pt1/pt1.c
@@ -99,7 +99,6 @@ struct pt1_adapter {
 	struct dvb_demux demux;
 	int users;
 	struct dmxdev dmxdev;
-	struct dvb_net net;
 	struct dvb_frontend *fe;
 	int (*orig_set_voltage)(struct dvb_frontend *fe,
 				fe_sec_voltage_t voltage);
@@ -624,7 +623,6 @@ static int pt1_wakeup(struct dvb_frontend *fe)
 
 static void pt1_free_adapter(struct pt1_adapter *adap)
 {
-	dvb_net_release(&adap->net);
 	adap->demux.dmx.close(&adap->demux.dmx);
 	dvb_dmxdev_release(&adap->dmxdev);
 	dvb_dmx_release(&adap->demux);
@@ -694,8 +692,6 @@ pt1_alloc_adapter(struct pt1 *pt1)
 	if (ret < 0)
 		goto err_dmx_release;
 
-	dvb_net_init(dvb_adap, &adap->net, &demux->dmx);
-
 	return adap;
 
 err_dmx_release:
-- 
1.7.7.6


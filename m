Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:25874 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758183Ab1BRBVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:21:44 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1LUpv022934
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:21:36 GMT
Subject: [PATCH 12/13] lirc_zilog: Fix somewhat confusing information
 messages in ir_probe()
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:21:43 -0500
Message-ID: <1297992103.9399.28.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


The total sequence of messages emitted by the ir_porbe() calls
for a transceiver's two i2c_clients was confusing.  Clean it up a bit.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index a59d32d..40195ef 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -1597,6 +1597,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		ret = -EBADRQC;
 		goto out_put_xx;
 	}
+	zilog_info("IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
+		   adap->name, adap->nr, ir->l.minor);
 
 out_ok:
 	if (rx != NULL)
@@ -1604,7 +1606,7 @@ out_ok:
 	if (tx != NULL)
 		put_ir_tx(tx, true);
 	put_ir_device(ir, true);
-	zilog_info("probe of IR %s on %s (i2c-%d) done. IR unit ready.\n",
+	zilog_info("probe of IR %s on %s (i2c-%d) done\n",
 		   tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
 	mutex_unlock(&ir_devices_lock);
 	return 0;
-- 
1.7.2.1




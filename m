Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:21079 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757892Ab0GTBPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:15:54 -0400
Subject: [PATCH 01/17] cx23885: Return -ENXIO on slave nack
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Steven Toth <stoth@kernellabs.com>,
	Jean Delvare <khali@linux-fr.org>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:08:58 -0400
Message-ID: <1279588138.28153.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean Delvare <khali@linux-fr.org>

Documentation/i2c/fault-codes says that i2c adapter drivers should
return -ENXIO when no slave acks an address byte.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-i2c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-i2c.c b/drivers/media/video/cx23885/cx23885-i2c.c
index d4746e0..154c914 100644
--- a/drivers/media/video/cx23885/cx23885-i2c.c
+++ b/drivers/media/video/cx23885/cx23885-i2c.c
@@ -99,7 +99,7 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 		if (!i2c_wait_done(i2c_adap))
 			return -EIO;
 		if (!i2c_slave_did_ack(i2c_adap))
-			return -EIO;
+			return -ENXIO;
 
 		dprintk(1, "%s() returns 0\n", __func__);
 		return 0;
@@ -185,7 +185,7 @@ static int i2c_readbytes(struct i2c_adapter *i2c_adap,
 		if (!i2c_wait_done(i2c_adap))
 			return -EIO;
 		if (!i2c_slave_did_ack(i2c_adap))
-			return -EIO;
+			return -ENXIO;
 

 		dprintk(1, "%s() returns 0\n", __func__);
-- 
1.7.1.1



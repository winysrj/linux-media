Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:23940 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758087Ab0GTBQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:16:07 -0400
Subject: [PATCH 02/17] cx23885: Check for slave nack on all transactions
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Steven Toth <stoth@kernellabs.com>,
	Jean Delvare <khali@linux-fr.org>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:09:31 -0400
Message-ID: <1279588171.28153.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean Delvare <khali@linux-fr.org>

Don't just check for nacks on zero-length transactions. Check on
other transactions too.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-i2c.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-i2c.c b/drivers/media/video/cx23885/cx23885-i2c.c
index 154c914..afb8d6f 100644
--- a/drivers/media/video/cx23885/cx23885-i2c.c
+++ b/drivers/media/video/cx23885/cx23885-i2c.c
@@ -125,6 +125,10 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 		goto err;
 	if (retval == 0)
 		goto eio;
+	if (!i2c_slave_did_ack(i2c_adap)) {
+		retval = -ENXIO;
+		goto err;
+	}
 	if (i2c_debug) {
 		printk(" <W %02x %02x", msg->addr << 1, msg->buf[0]);
 		if (!(ctrl & I2C_NOSTOP))
@@ -214,6 +218,10 @@ static int i2c_readbytes(struct i2c_adapter *i2c_adap,
 			goto err;
 		if (retval == 0)
 			goto eio;
+		if (cnt == 0 && !i2c_slave_did_ack(i2c_adap)) {
+			retval = -ENXIO;
+			goto err;
+		}
 		msg->buf[cnt] = cx_read(bus->reg_rdata) & 0xff;
 		if (i2c_debug) {
 			dprintk(1, " %02x", msg->buf[cnt]);
-- 
1.7.1.1



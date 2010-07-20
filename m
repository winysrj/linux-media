Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:26217 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757044Ab0GTBQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:16:15 -0400
Subject: [PATCH 03/17] cx23885: i2c_wait_done returns 0 or 1, don't check
 for < 0 return value
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Steven Toth <stoth@kernellabs.com>,
	Jean Delvare <khali@linux-fr.org>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:10:04 -0400
Message-ID: <1279588204.28153.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean Delvare <khali@linux-fr.org>

Function i2c_wait_done() never returns negative values, so there is no
point in checking for them.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-i2c.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-i2c.c b/drivers/media/video/cx23885/cx23885-i2c.c
index afb8d6f..1a39148 100644
--- a/drivers/media/video/cx23885/cx23885-i2c.c
+++ b/drivers/media/video/cx23885/cx23885-i2c.c
@@ -120,10 +120,7 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 	cx_write(bus->reg_wdata, wdata);
 	cx_write(bus->reg_ctrl, ctrl);
 
-	retval = i2c_wait_done(i2c_adap);
-	if (retval < 0)
-		goto err;
-	if (retval == 0)
+	if (!i2c_wait_done(i2c_adap))
 		goto eio;
 	if (!i2c_slave_did_ack(i2c_adap)) {
 		retval = -ENXIO;
@@ -149,10 +146,7 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 		cx_write(bus->reg_wdata, wdata);
 		cx_write(bus->reg_ctrl, ctrl);
 
-		retval = i2c_wait_done(i2c_adap);
-		if (retval < 0)
-			goto err;
-		if (retval == 0)
+		if (!i2c_wait_done(i2c_adap))
 			goto eio;
 		if (i2c_debug) {
 			dprintk(1, " %02x", msg->buf[cnt]);
@@ -213,10 +207,7 @@ static int i2c_readbytes(struct i2c_adapter *i2c_adap,
 		cx_write(bus->reg_addr, msg->addr << 25);
 		cx_write(bus->reg_ctrl, ctrl);
 
-		retval = i2c_wait_done(i2c_adap);
-		if (retval < 0)
-			goto err;
-		if (retval == 0)
+		if (!i2c_wait_done(i2c_adap))
 			goto eio;
 		if (cnt == 0 && !i2c_slave_did_ack(i2c_adap)) {
 			retval = -ENXIO;
-- 
1.7.1.1



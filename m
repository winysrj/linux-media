Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35879 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933887AbeEIOZX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 10:25:23 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [RFC PATCH] i2c: add I2C_M_FORCE_STOP
Date: Wed,  9 May 2018 23:24:37 +0900
Message-Id: <1525875877-10164-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a new I2C_M_FORCE_STOP flag that forces a stop condition after
the message in a combined transaction.

This flag is intended to be used by the devices that don't support
repeated starts like SCCB (Serial Camera Control Bus) devices.

Here is an example usage for ov772x driver that needs to issue two
separated I2C messages as the ov772x device doesn't support repeated
starts.

static int ov772x_read(struct i2c_client *client, u8 addr)
{
        u8 val;
        struct i2c_msg msg[] = {
                {
                        .addr = client->addr,
                        .flags = I2C_M_FORCE_STOP,
                        .len = 1,
                        .buf = &addr,
                },
                {
                        .addr = client->addr,
                        .flags = I2C_M_RD,
                        .len = 1,
                        .buf = &val,
                },
        };
        int ret;

        ret = i2c_transfer(client->adapter, msg, 2);
        if (ret != 2)
                return (ret < 0) ? ret : -EIO;

        return val;
}

This is another approach based on Mauro's advise for the initial attempt
(http://patchwork.ozlabs.org/patch/905192/).

Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/i2c/i2c-core-base.c | 46 ++++++++++++++++++++++++++++++++++-----------
 include/uapi/linux/i2c.h    |  1 +
 2 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 1ba40bb..6b73484 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1828,6 +1828,25 @@ static int i2c_check_for_quirks(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	return 0;
 }
 
+static int i2c_transfer_nolock(struct i2c_adapter *adap, struct i2c_msg *msgs,
+			       int num)
+{
+	unsigned long orig_jiffies;
+	int ret, try;
+
+	/* Retry automatically on arbitration loss */
+	orig_jiffies = jiffies;
+	for (ret = 0, try = 0; try <= adap->retries; try++) {
+		ret = adap->algo->master_xfer(adap, msgs, num);
+		if (ret != -EAGAIN)
+			break;
+		if (time_after(jiffies, orig_jiffies + adap->timeout))
+			break;
+	}
+
+	return ret;
+}
+
 /**
  * __i2c_transfer - unlocked flavor of i2c_transfer
  * @adap: Handle to I2C bus
@@ -1842,8 +1861,8 @@ static int i2c_check_for_quirks(struct i2c_adapter *adap, struct i2c_msg *msgs,
  */
 int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
-	unsigned long orig_jiffies;
-	int ret, try;
+	int ret;
+	int i, n;
 
 	if (WARN_ON(!msgs || num < 1))
 		return -EINVAL;
@@ -1857,7 +1876,6 @@ int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	 * being executed when not needed.
 	 */
 	if (static_branch_unlikely(&i2c_trace_msg_key)) {
-		int i;
 		for (i = 0; i < num; i++)
 			if (msgs[i].flags & I2C_M_RD)
 				trace_i2c_read(adap, &msgs[i], i);
@@ -1865,18 +1883,24 @@ int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 				trace_i2c_write(adap, &msgs[i], i);
 	}
 
-	/* Retry automatically on arbitration loss */
-	orig_jiffies = jiffies;
-	for (ret = 0, try = 0; try <= adap->retries; try++) {
-		ret = adap->algo->master_xfer(adap, msgs, num);
-		if (ret != -EAGAIN)
-			break;
-		if (time_after(jiffies, orig_jiffies + adap->timeout))
+	for (i = 0; i < num; i += n) {
+		for (n = 0; i + n < num; n++) {
+			if (msgs[i + n].flags & I2C_M_FORCE_STOP) {
+				n++;
+				break;
+			}
+		}
+
+		ret = i2c_transfer_nolock(adap, &msgs[i], n);
+		if (ret != n) {
+			if (i > 0)
+				ret = (ret < 0) ? i : i + ret;
 			break;
+		}
+		ret = i + n;
 	}
 
 	if (static_branch_unlikely(&i2c_trace_msg_key)) {
-		int i;
 		for (i = 0; i < ret; i++)
 			if (msgs[i].flags & I2C_M_RD)
 				trace_i2c_reply(adap, &msgs[i], i);
diff --git a/include/uapi/linux/i2c.h b/include/uapi/linux/i2c.h
index f71a175..36e8c7c 100644
--- a/include/uapi/linux/i2c.h
+++ b/include/uapi/linux/i2c.h
@@ -72,6 +72,7 @@ struct i2c_msg {
 #define I2C_M_RD		0x0001	/* read data, from slave to master */
 					/* I2C_M_RD is guaranteed to be 0x0001! */
 #define I2C_M_TEN		0x0010	/* this is a ten bit chip address */
+#define I2C_M_FORCE_STOP	0x0100	/* force a stop condition after the message */
 #define I2C_M_DMA_SAFE		0x0200	/* the buffer of this message is DMA safe */
 					/* makes only sense in kernelspace */
 					/* userspace buffers are copied anyway */
-- 
2.7.4

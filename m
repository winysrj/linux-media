Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55002 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751015Ab0L2Crn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 21:47:43 -0500
Subject: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id field
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <1293587067.3098.10.camel@localhost>
References: <1293587067.3098.10.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 20:49:50 -0500
Message-ID: <1293587390.3098.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Remove use of deprecated struct i2c_adapter.id field.  In the process,
perform different detection of the HD PVR's Z8 IR microcontroller versus
the other Hauppauge cards with the Z8 IR microcontroller.

Also added a comment about probe() function behavior that needs to be
fixed.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |   47 ++++++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 52be6de..ad29bb1 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -66,6 +66,7 @@ struct IR {
 	/* Device info */
 	struct mutex ir_lock;
 	int open;
+	bool is_hdpvr;
 
 	/* RX device */
 	struct i2c_client c_rx;
@@ -206,16 +207,12 @@ static int add_to_buf(struct IR *ir)
 		}
 
 		/* key pressed ? */
-#ifdef I2C_HW_B_HDPVR
-		if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR) {
+		if (ir->is_hdpvr) {
 			if (got_data && (keybuf[0] == 0x80))
 				return 0;
 			else if (got_data && (keybuf[0] == 0x00))
 				return -ENODATA;
 		} else if ((ir->b[0] & 0x80) == 0)
-#else
-		if ((ir->b[0] & 0x80) == 0)
-#endif
 			return got_data ? 0 : -ENODATA;
 
 		/* look what we have */
@@ -841,15 +838,15 @@ static int send_code(struct IR *ir, unsigned int code, unsigned int key)
 		return ret < 0 ? ret : -EFAULT;
 	}
 
-#ifdef I2C_HW_B_HDPVR
 	/*
 	 * The sleep bits aren't necessary on the HD PVR, and in fact, the
 	 * last i2c_master_recv always fails with a -5, so for now, we're
 	 * going to skip this whole mess and say we're done on the HD PVR
 	 */
-	if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
-		goto done;
-#endif
+	if (ir->is_hdpvr) {
+		dprintk("sent code %u, key %u\n", code, key);
+		return 0;
+	}
 
 	/*
 	 * This bit NAKs until the device is ready, so we retry it
@@ -1111,12 +1108,14 @@ static int ir_remove(struct i2c_client *client);
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id);
 static int ir_command(struct i2c_client *client, unsigned int cmd, void *arg);
 
+#define ID_FLAG_TX	0x01
+#define ID_FLAG_HDPVR	0x02
+
 static const struct i2c_device_id ir_transceiver_id[] = {
-	/* Generic entry for any IR transceiver */
-	{ "ir_video", 0 },
-	/* IR device specific entries should be added here */
-	{ "ir_tx_z8f0811_haup", 0 },
-	{ "ir_rx_z8f0811_haup", 0 },
+	{ "ir_tx_z8f0811_haup",  ID_FLAG_TX                 },
+	{ "ir_rx_z8f0811_haup",  0                          },
+	{ "ir_tx_z8f0811_hdpvr", ID_FLAG_HDPVR | ID_FLAG_TX },
+	{ "ir_rx_z8f0811_hdpvr", ID_FLAG_HDPVR              },
 	{ }
 };
 
@@ -1196,10 +1195,25 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	int ret;
 	int have_rx = 0, have_tx = 0;
 
-	dprintk("%s: adapter id=0x%x, client addr=0x%02x\n",
-		__func__, adap->id, client->addr);
+	dprintk("%s: adapter name (%s) nr %d, i2c_device_id name (%s), "
+		"client addr=0x%02x\n",
+		__func__, adap->name, adap->nr, id->name, client->addr);
 
 	/*
+	 * FIXME - This probe function probes both the Tx and Rx
+	 * addresses of the IR microcontroller.
+	 *
+	 * However, the I2C subsystem is passing along one I2C client at a
+	 * time, based on matches to the ir_transceiver_id[] table above.
+	 * The expectation is that each i2c_client address will be probed
+	 * individually by drivers so the I2C subsystem can mark all client
+	 * addresses as claimed or not.
+	 *
+	 * This probe routine causes only one of the client addresses, TX or RX,
+	 * to be claimed.  This will cause a problem if the I2C subsystem is
+	 * subsequently triggered to probe unclaimed clients again.
+	 */
+	/*
 	 * The external IR receiver is at i2c address 0x71.
 	 * The IR transmitter is at 0x70.
 	 */
@@ -1241,6 +1255,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	mutex_init(&ir->ir_lock);
 	mutex_init(&ir->buf_lock);
 	ir->need_boot = 1;
+	ir->is_hdpvr = (id->driver_data & ID_FLAG_HDPVR) ? true : false;
 
 	memcpy(&ir->l, &lirc_template, sizeof(struct lirc_driver));
 	ir->l.minor = -1;
-- 
1.7.2.1




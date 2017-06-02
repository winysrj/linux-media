Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:9887 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751125AbdFBMTI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 08:19:08 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v52CDLsa011757
        for <linux-media@vger.kernel.org>; Fri, 2 Jun 2017 13:19:07 +0100
Received: from mail-wm0-f69.google.com (mail-wm0-f69.google.com [74.125.82.69])
        by mx07-00252a01.pphosted.com with ESMTP id 2apxuyawfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 13:19:07 +0100
Received: by mail-wm0-f69.google.com with SMTP id 10so16808578wml.4
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 05:19:07 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH 3/3] [media] tc358743: Add support for platforms without IRQ line
Date: Fri,  2 Jun 2017 13:18:14 +0100
Message-Id: <c9ceccba7d296434f9bb941dd71b4cfb42759fa7.1496398217.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
References: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1496398217.git.dave.stevenson@raspberrypi.org>
References: <cover.1496398217.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

interrupts is listed as an optional property in the DT
binding, but in reality the driver didn't work without it.
The existing driver relied on having the interrupt line
connected to the SoC to trigger handling various events.

Add the option to poll the interrupt status register via
a timer if no interrupt source is defined.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---
 drivers/media/i2c/tc358743.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 2f5763d..654aac2 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -33,6 +33,7 @@
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
+#include <linux/timer.h>
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <linux/v4l2-dv-timings.h>
@@ -61,6 +62,8 @@ MODULE_LICENSE("GPL");
 
 #define I2C_MAX_XFER_SIZE  (EDID_BLOCK_SIZE + 2)
 
+#define POLL_INTERVAL_MS	1000
+
 static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
@@ -91,6 +94,9 @@ struct tc358743_state {
 
 	struct delayed_work delayed_work_enable_hotplug;
 
+	struct timer_list timer;
+	struct work_struct work_i2c_poll;
+
 	/* edid  */
 	u8 edid_blocks_written;
 
@@ -1319,6 +1325,24 @@ static irqreturn_t tc358743_irq_handler(int irq, void *dev_id)
 	return handled ? IRQ_HANDLED : IRQ_NONE;
 }
 
+static void tc358743_irq_poll_timer(unsigned long arg)
+{
+	struct tc358743_state *state = (struct tc358743_state *)arg;
+
+	schedule_work(&state->work_i2c_poll);
+
+	mod_timer(&state->timer, jiffies + msecs_to_jiffies(POLL_INTERVAL_MS));
+}
+
+static void tc358743_work_i2c_poll(struct work_struct *work)
+{
+	struct tc358743_state *state = container_of(work,
+			struct tc358743_state, work_i2c_poll);
+	bool handled;
+
+	tc358743_isr(&state->sd, 0, &handled);
+}
+
 static int tc358743_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 				    struct v4l2_event_subscription *sub)
 {
@@ -1933,6 +1957,14 @@ static int tc358743_probe(struct i2c_client *client,
 						"tc358743", state);
 		if (err)
 			goto err_work_queues;
+	} else {
+		INIT_WORK(&state->work_i2c_poll,
+			  tc358743_work_i2c_poll);
+		state->timer.data = (unsigned long)state;
+		state->timer.function = tc358743_irq_poll_timer;
+		state->timer.expires = jiffies +
+				       msecs_to_jiffies(POLL_INTERVAL_MS);
+		add_timer(&state->timer);
 	}
 
 	tc358743_enable_interrupts(sd, tx_5v_power_present(sd));
@@ -1948,6 +1980,8 @@ static int tc358743_probe(struct i2c_client *client,
 	return 0;
 
 err_work_queues:
+	if (!state->i2c_client->irq)
+		flush_work(&state->work_i2c_poll);
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	mutex_destroy(&state->confctl_mutex);
 err_hdl:
@@ -1961,6 +1995,10 @@ static int tc358743_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct tc358743_state *state = to_state(sd);
 
+	if (!state->i2c_client->irq) {
+		del_timer_sync(&state->timer);
+		flush_work(&state->work_i2c_poll);
+	}
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	v4l2_async_unregister_subdev(sd);
 	v4l2_device_unregister_subdev(sd);
-- 
2.7.4

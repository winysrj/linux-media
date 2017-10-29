Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56533 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbdJ2U6f (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:58:35 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Andy Walls <awalls.cx18@gmail.com>
Subject: [PATCH 05/28] media: rc: implement zilog transmitter
Date: Sun, 29 Oct 2017 20:58:33 +0000
Message-Id: <e8ea699d2e817236664083f8da1063afe114d039.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code implements the transmitter which is currently implemented
in the staging lirc_zilog driver.

The new code does not need a signal database, iow. the
haup-ir-blaster.bin firmware file is no longer needed, and the driver
does not know anything about the keycodes in that file.

Instead, the new driver can send raw IR, but the hardware is limited
o few different lengths of pulse and spaces, so it is best to use
generated IR rather than recorded IR.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/i2c/ir-kbd-i2c.c | 436 ++++++++++++++++++++++++++++++++++++++++-
 include/media/i2c/ir-kbd-i2c.h |   5 +
 2 files changed, 433 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index ec669ec4cfc5..b656c8ec31ca 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -18,6 +18,20 @@
  *      Brian Rogers <brian_rogers@comcast.net>
  * modified for AVerMedia Cardbus by
  *      Oldrich Jedlicka <oldium.pro@seznam.cz>
+ * Zilog Transmitter portions/ideas were derived from GPLv2+ sources:
+ *  - drivers/char/pctv_zilogir.[ch] from Hauppauge Broadway product
+ *	Copyright 2011 Hauppauge Computer works
+ *  - drivers/staging/media/lirc/lirc_zilog.c
+ *	Copyright (c) 2000 Gerd Knorr <kraxel@goldbach.in-berlin.de>
+ *	Michal Kochanowicz <mkochano@pld.org.pl>
+ *	Christoph Bartelmus <lirc@bartelmus.de>
+ *	Ulrich Mueller <ulrich.mueller42@web.de>
+ *	Stefan Jahn <stefan@lkcc.org>
+ *	Jerome Brock <jbrock@users.sourceforge.net>
+ *	Thomas Reitmayr (treitmayr@yahoo.com)
+ *	Mark Weaver <mark@npsl.co.uk>
+ *	Jarod Wilson <jarod@redhat.com>
+ *	Copyright (C) 2011 Andy Walls <awalls@md.metrocast.net>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -46,6 +60,8 @@
 #include <media/rc-core.h>
 #include <media/i2c/ir-kbd-i2c.h>
 
+#define FLAG_TX		1
+#define FLAG_HDPVR	2
 
 static int get_key_haup_common(struct IR_i2c *ir, enum rc_proto *protocol,
 			       u32 *scancode, u8 *ptoggle, int size)
@@ -288,11 +304,18 @@ static void ir_work(struct work_struct *work)
 	int rc;
 	struct IR_i2c *ir = container_of(work, struct IR_i2c, work.work);
 
-	rc = ir_key_poll(ir);
-	if (rc == -ENODEV) {
-		rc_unregister_device(ir->rc);
-		ir->rc = NULL;
-		return;
+	/*
+	 * If the transmit code is holding the lock, skip polling for
+	 * IR, we'll get it to it next time round
+	 */
+	if (mutex_trylock(&ir->lock)) {
+		rc = ir_key_poll(ir);
+		mutex_unlock(&ir->lock);
+		if (rc == -ENODEV) {
+			rc_unregister_device(ir->rc);
+			ir->rc = NULL;
+			return;
+		}
 	}
 
 	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling_interval));
@@ -314,7 +337,383 @@ static void ir_close(struct rc_dev *dev)
 	cancel_delayed_work_sync(&ir->work);
 }
 
-/* ----------------------------------------------------------------------- */
+/* Zilog Transmit Interface */
+#define XTAL_FREQ		18432000
+
+#define ZILOG_SEND		0x80
+#define ZILOG_UIR_END		0x40
+#define ZILOG_INIT_END		0x20
+#define ZILOG_LIR_END		0x10
+
+#define ZILOG_STATUS_OK		0x80
+#define ZILOG_STATUS_TX		0x40
+#define ZILOG_STATUS_SET	0x20
+
+/*
+ * As you can see here, very few different lengths of pulse and space
+ * can be encoded. This means that the hardware does not work well with
+ * recorded IR. It's best to work with generated IR, like from ir-ctl or
+ * the in-kernel encoders.
+ */
+struct code_block {
+	u8	length;
+	u16	pulse[7];	/* not aligned */
+	u8	carrier_pulse;
+	u8	carrier_space;
+	u16	space[8];	/* not aligned */
+	u8	codes[61];
+	u8	csum[2];
+} __packed;
+
+static int send_data_block(struct IR_i2c *ir, int cmd,
+			   struct code_block *code_block)
+{
+	int i, j, ret;
+	u8 buf[5], *p;
+
+	p = &code_block->length;
+	for (i = 0; p < code_block->csum; i++)
+		code_block->csum[i & 1] ^= *p++;
+
+	p = &code_block->length;
+
+	for (i = 0; i < sizeof(*code_block);) {
+		int tosend = sizeof(*code_block) - i;
+
+		if (tosend > 4)
+			tosend = 4;
+		buf[0] = i + 1;
+		for (j = 0; j < tosend; ++j)
+			buf[1 + j] = p[i + j];
+		dev_dbg(&ir->rc->dev, "%*ph", tosend + 1, buf);
+		ret = i2c_master_send(ir->tx_c, buf, tosend + 1);
+		if (ret != tosend + 1) {
+			dev_dbg(&ir->rc->dev,
+				"i2c_master_send failed with %d\n", ret);
+			return ret < 0 ? ret : -EIO;
+		}
+		i += tosend;
+	}
+
+	buf[0] = 0;
+	buf[1] = cmd;
+	ret = i2c_master_send(ir->tx_c, buf, 2);
+	if (ret != 2) {
+		dev_err(&ir->rc->dev, "i2c_master_send failed with %d\n", ret);
+		return ret < 0 ? ret : -EIO;
+	}
+
+	msleep(10);
+
+	ret = i2c_master_send(ir->tx_c, buf, 1);
+	if (ret != 1) {
+		dev_err(&ir->rc->dev, "i2c_master_send failed with %d\n", ret);
+		return ret < 0 ? ret : -EIO;
+	}
+
+	return 0;
+}
+
+static int zilog_init(struct IR_i2c *ir)
+{
+	struct code_block code_block = { .length = sizeof(code_block) };
+	u8 buf[4];
+	int ret;
+
+	put_unaligned_be16(0x1000, &code_block.pulse[3]);
+
+	ret = send_data_block(ir, ZILOG_INIT_END, &code_block);
+	if (ret)
+		return ret;
+
+	ret = i2c_master_recv(ir->tx_c, buf, 4);
+	if (ret != 4) {
+		dev_err(&ir->c->dev, "failed to retrieve firmware version: %d\n",
+			ret);
+		return ret < 0 ? ret : -EIO;
+	}
+
+	dev_info(&ir->c->dev, "Zilog/Hauppauge IR blaster firmware version %d.%d.%d\n",
+		 buf[1], buf[2], buf[3]);
+
+	return 0;
+}
+
+/*
+ * If the last slot for pulse is the same as the current slot for pulse,
+ * then use slot no 7.
+ */
+static void copy_codes(u8 *dst, u8 *src, unsigned int count)
+{
+	u8 c, last = 0xff;
+
+	while (count--) {
+		c = *src++;
+		if ((c & 0xf0) == last) {
+			*dst++ = 0x70 | (c & 0xf);
+		} else {
+			*dst++ = c;
+			last = c & 0xf0;
+		}
+	}
+}
+
+/*
+ * When looking for repeats, we don't care about the trailing space. This
+ * is set to the shortest possible anyway.
+ */
+static int cmp_no_trail(u8 *a, u8 *b, unsigned int count)
+{
+	while (--count) {
+		if (*a++ != *b++)
+			return 1;
+	}
+
+	return (*a & 0xf0) - (*b & 0xf0);
+}
+
+static int find_slot(u16 *array, unsigned int size, u16 val)
+{
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (get_unaligned_be16(&array[i]) == val) {
+			return i;
+		} else if (!array[i]) {
+			put_unaligned_be16(val, &array[i]);
+			return i;
+		}
+	}
+
+	return -1;
+}
+
+static int zilog_ir_format(struct rc_dev *rcdev, unsigned int *txbuf,
+			   unsigned int count, struct code_block *code_block)
+{
+	struct IR_i2c *ir = rcdev->priv;
+	int rep, i, l, p = 0, s, c = 0;
+	bool repeating;
+	u8 codes[174];
+
+	code_block->carrier_pulse = DIV_ROUND_CLOSEST(
+			ir->duty_cycle * XTAL_FREQ / 1000, ir->carrier);
+	code_block->carrier_space = DIV_ROUND_CLOSEST(
+			(100 - ir->duty_cycle) * XTAL_FREQ / 1000, ir->carrier);
+
+	for (i = 0; i < count; i++) {
+		if (c >= ARRAY_SIZE(codes) - 1) {
+			dev_warn(&rcdev->dev, "IR too long, cannot transmit\n");
+			return -EINVAL;
+		}
+
+		/*
+		 * Lengths more than 142220us cannot be encoded; also
+		 * this checks for multiply overflow
+		 */
+		if (txbuf[i] > 142220)
+			return -EINVAL;
+
+		l = DIV_ROUND_CLOSEST((XTAL_FREQ / 1000) * txbuf[i], 40000);
+
+		if (i & 1) {
+			s = find_slot(code_block->space,
+				      ARRAY_SIZE(code_block->space), l);
+			if (s == -1) {
+				dev_warn(&rcdev->dev, "Too many different lengths spaces, cannot transmit");
+				return -EINVAL;
+			}
+
+			/* We have a pulse and space */
+			codes[c++] = (p << 4) | s;
+		} else {
+			p = find_slot(code_block->pulse,
+				      ARRAY_SIZE(code_block->pulse), l);
+			if (p == -1) {
+				dev_warn(&rcdev->dev, "Too many different lengths pulses, cannot transmit");
+				return -EINVAL;
+			}
+		}
+	}
+
+	/* We have to encode the trailing pulse. Find the shortest space */
+	s = 0;
+	for (i = 1; i < ARRAY_SIZE(code_block->space); i++) {
+		u16 d = get_unaligned_be16(&code_block->space[i]);
+
+		if (get_unaligned_be16(&code_block->space[s]) > d)
+			s = i;
+	}
+
+	codes[c++] = (p << 4) | s;
+
+	dev_dbg(&rcdev->dev, "generated %d codes\n", c);
+
+	/*
+	 * Are the last N codes (so pulse + space) repeating 3 times?
+	 * if so we can shorten the codes list and use code 0xc0 to repeat
+	 * them.
+	 */
+	repeating = false;
+
+	for (rep = c / 3; rep >= 1; rep--) {
+		if (!memcmp(&codes[c - rep * 3], &codes[c - rep * 2], rep) &&
+		    !cmp_no_trail(&codes[c - rep], &codes[c - rep * 2], rep)) {
+			repeating = true;
+			break;
+		}
+	}
+
+	if (repeating) {
+		/* first copy any leading non-repeating */
+		int leading = c - rep * 3;
+
+		if (leading + rep >= ARRAY_SIZE(code_block->codes) - 3) {
+			dev_warn(&rcdev->dev, "IR too long, cannot transmit\n");
+			return -EINVAL;
+		}
+
+		dev_dbg(&rcdev->dev, "found trailing %d repeat\n", rep);
+		copy_codes(code_block->codes, codes, leading);
+		code_block->codes[leading] = 0x82;
+		copy_codes(code_block->codes + leading + 1, codes + leading,
+			   rep);
+		c = leading + 1 + rep;
+		code_block->codes[c++] = 0xc0;
+	} else {
+		if (c >= ARRAY_SIZE(code_block->codes) - 3) {
+			dev_warn(&rcdev->dev, "IR too long, cannot transmit\n");
+			return -EINVAL;
+		}
+
+		dev_dbg(&rcdev->dev, "found no trailing repeat\n");
+		code_block->codes[0] = 0x82;
+		copy_codes(code_block->codes + 1, codes, c);
+		c++;
+		code_block->codes[c++] = 0xc4;
+	}
+
+	while (c < ARRAY_SIZE(code_block->codes))
+		code_block->codes[c++] = 0x83;
+
+	return 0;
+}
+
+static int zilog_tx(struct rc_dev *rcdev, unsigned int *txbuf,
+		    unsigned int count)
+{
+	struct IR_i2c *ir = rcdev->priv;
+	struct code_block code_block = { .length = sizeof(code_block) };
+	u8 buf[2];
+	int ret, i;
+
+	ret = zilog_ir_format(rcdev, txbuf, count, &code_block);
+	if (ret)
+		return ret;
+
+	ret = mutex_lock_interruptible(&ir->lock);
+	if (ret)
+		return ret;
+
+	ret = send_data_block(ir, ZILOG_UIR_END, &code_block);
+	if (ret)
+		goto out_unlock;
+
+	ret = i2c_master_recv(ir->tx_c, buf, 1);
+	if (ret != 1) {
+		dev_err(&ir->rc->dev, "i2c_master_recv failed with %d\n", ret);
+		goto out_unlock;
+	}
+
+	dev_dbg(&ir->rc->dev, "code set status: %02x\n", buf[0]);
+
+	if (buf[0] != (ZILOG_STATUS_OK | ZILOG_STATUS_SET)) {
+		dev_err(&ir->rc->dev, "unexpected IR TX response %02x\n",
+			buf[0]);
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	buf[0] = 0x00;
+	buf[1] = ZILOG_SEND;
+
+	ret = i2c_master_send(ir->tx_c, buf, 2);
+	if (ret != 2) {
+		dev_err(&ir->rc->dev, "i2c_master_send failed with %d\n", ret);
+		if (ret >= 0)
+			ret = -EIO;
+		goto out_unlock;
+	}
+
+	dev_dbg(&ir->rc->dev, "send command sent\n");
+
+	/*
+	 * This bit NAKs until the device is ready, so we retry it
+	 * sleeping a bit each time.  This seems to be what the windows
+	 * driver does, approximately.
+	 * Try for up to 1s.
+	 */
+	for (i = 0; i < 20; ++i) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(50));
+		ret = i2c_master_send(ir->tx_c, buf, 1);
+		if (ret == 1)
+			break;
+		dev_dbg(&ir->rc->dev,
+			"NAK expected: i2c_master_send failed with %d (try %d)\n",
+			ret, i + 1);
+	}
+
+	if (ret != 1) {
+		dev_err(&ir->rc->dev,
+			"IR TX chip never got ready: last i2c_master_send failed with %d\n",
+			ret);
+		if (ret >= 0)
+			ret = -EIO;
+		goto out_unlock;
+	}
+
+	i = i2c_master_recv(ir->tx_c, buf, 1);
+	if (i != 1) {
+		dev_err(&ir->rc->dev, "i2c_master_recv failed with %d\n", ret);
+		ret = -EIO;
+		goto out_unlock;
+	} else if (buf[0] != ZILOG_STATUS_OK) {
+		dev_err(&ir->rc->dev, "unexpected IR TX response #2: %02x\n",
+			buf[0]);
+		ret = -EIO;
+		goto out_unlock;
+	}
+	dev_dbg(&ir->rc->dev, "transmit complete\n");
+
+	/* Oh good, it worked */
+	ret = count;
+out_unlock:
+	mutex_unlock(&ir->lock);
+
+	return ret;
+}
+
+static int zilog_tx_carrier(struct rc_dev *dev, u32 carrier)
+{
+	struct IR_i2c *ir = dev->priv;
+
+	if (carrier > 500000 || carrier < 20000)
+		return -EINVAL;
+
+	ir->carrier = carrier;
+
+	return 0;
+}
+
+static int zilog_tx_duty_cycle(struct rc_dev *dev, u32 duty_cycle)
+{
+	struct IR_i2c *ir = dev->priv;
+
+	ir->duty_cycle = duty_cycle;
+
+	return 0;
+}
 
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
@@ -469,8 +868,23 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (!rc->driver_name)
 		rc->driver_name = KBUILD_MODNAME;
 
+	mutex_init(&ir->lock);
+
 	INIT_DELAYED_WORK(&ir->work, ir_work);
 
+	if (id->driver_data & FLAG_TX) {
+		ir->tx_c = i2c_new_dummy(client->adapter, 0x70);
+		if (!ir->tx_c) {
+			dev_err(&client->dev, "failed to setup tx i2c address");
+		} else if (!zilog_init(ir)) {
+			ir->carrier = 38000;
+			ir->duty_cycle = 40;
+			rc->tx_ir = zilog_tx;
+			rc->s_tx_carrier = zilog_tx_carrier;
+			rc->s_tx_duty_cycle = zilog_tx_duty_cycle;
+		}
+	}
+
 	err = rc_register_device(rc);
 	if (err)
 		goto err_out_free;
@@ -478,6 +892,9 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	return 0;
 
  err_out_free:
+	if (ir->tx_c)
+		i2c_unregister_device(ir->tx_c);
+
 	/* Only frees rc if it were allocated internally */
 	rc_free_device(rc);
 	return err;
@@ -490,6 +907,9 @@ static int ir_remove(struct i2c_client *client)
 	/* kill outstanding polls */
 	cancel_delayed_work_sync(&ir->work);
 
+	if (ir->tx_c)
+		i2c_unregister_device(ir->tx_c);
+
 	/* unregister device */
 	rc_unregister_device(ir->rc);
 
@@ -501,8 +921,8 @@ static const struct i2c_device_id ir_kbd_id[] = {
 	/* Generic entry for any IR receiver */
 	{ "ir_video", 0 },
 	/* IR device specific entries should be added here */
-	{ "ir_z8f0811_haup", 0 },
-	{ "ir_z8f0811_hdpvr", 0 },
+	{ "ir_z8f0811_haup", FLAG_TX },
+	{ "ir_z8f0811_hdpvr", FLAG_TX | FLAG_HDPVR },
 	{ }
 };
 
diff --git a/include/media/i2c/ir-kbd-i2c.h b/include/media/i2c/ir-kbd-i2c.h
index 092ab44da7e0..8b26a801f6c4 100644
--- a/include/media/i2c/ir-kbd-i2c.h
+++ b/include/media/i2c/ir-kbd-i2c.h
@@ -22,6 +22,11 @@ struct IR_i2c {
 	int                    (*get_key)(struct IR_i2c *ir,
 					  enum rc_proto *protocol,
 					  u32 *scancode, u8 *toggle);
+	/* tx */
+	struct i2c_client      *tx_c;
+	struct mutex	       lock;	/* do not poll Rx during Tx */
+	unsigned int	       carrier;
+	unsigned int	       duty_cycle;
 };
 
 enum ir_kbd_get_key_fn {
-- 
2.13.6

Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39699 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751966AbcJKKe4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:34:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH v2 21/31] pctv452e: don't do DMA on stack
Date: Tue, 11 Oct 2016 07:09:36 -0300
Message-Id: <3d1b8538200afb6823b82c2720d038d229c60b7a.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/pctv452e.c | 129 ++++++++++++++++++++---------------
 1 file changed, 74 insertions(+), 55 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index c05de1b088a4..58b685094904 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -97,13 +97,14 @@ struct pctv452e_state {
 	u8 c;	   /* transaction counter, wraps around...  */
 	u8 initialized; /* set to 1 if 0x15 has been sent */
 	u16 last_rc_key;
+
+	unsigned char data[80];
 };
 
 static int tt3650_ci_msg(struct dvb_usb_device *d, u8 cmd, u8 *data,
 			 unsigned int write_len, unsigned int read_len)
 {
 	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
-	u8 buf[64];
 	u8 id;
 	unsigned int rlen;
 	int ret;
@@ -112,33 +113,36 @@ static int tt3650_ci_msg(struct dvb_usb_device *d, u8 cmd, u8 *data,
 	BUG_ON(write_len > 64 - 4);
 	BUG_ON(read_len > 64 - 4);
 
+	mutex_lock(&state->ca_mutex);
 	id = state->c++;
 
-	buf[0] = SYNC_BYTE_OUT;
-	buf[1] = id;
-	buf[2] = cmd;
-	buf[3] = write_len;
+	state->data[0] = SYNC_BYTE_OUT;
+	state->data[1] = id;
+	state->data[2] = cmd;
+	state->data[3] = write_len;
 
-	memcpy(buf + 4, data, write_len);
+	memcpy(state->data + 4, data, write_len);
 
 	rlen = (read_len > 0) ? 64 : 0;
-	ret = dvb_usb_generic_rw(d, buf, 4 + write_len,
-				  buf, rlen, /* delay_ms */ 0);
+	ret = dvb_usb_generic_rw(d, state->data, 4 + write_len,
+				  state->data, rlen, /* delay_ms */ 0);
 	if (0 != ret)
 		goto failed;
 
 	ret = -EIO;
-	if (SYNC_BYTE_IN != buf[0] || id != buf[1])
+	if (SYNC_BYTE_IN != state->data[0] || id != state->data[1])
 		goto failed;
 
-	memcpy(data, buf + 4, read_len);
+	memcpy(data, state->data + 4, read_len);
 
+	mutex_unlock(&state->ca_mutex);
 	return 0;
 
 failed:
 	err("CI error %d; %02X %02X %02X -> %*ph.",
-	     ret, SYNC_BYTE_OUT, id, cmd, 3, buf);
+	     ret, SYNC_BYTE_OUT, id, cmd, 3, state->data);
 
+	mutex_unlock(&state->ca_mutex);
 	return ret;
 }
 
@@ -405,52 +409,53 @@ static int pctv452e_i2c_msg(struct dvb_usb_device *d, u8 addr,
 				u8 *rcv_buf, u8 rcv_len)
 {
 	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
-	u8 buf[64];
 	u8 id;
 	int ret;
 
+	mutex_lock(&state->ca_mutex);
 	id = state->c++;
 
 	ret = -EINVAL;
 	if (snd_len > 64 - 7 || rcv_len > 64 - 7)
 		goto failed;
 
-	buf[0] = SYNC_BYTE_OUT;
-	buf[1] = id;
-	buf[2] = PCTV_CMD_I2C;
-	buf[3] = snd_len + 3;
-	buf[4] = addr << 1;
-	buf[5] = snd_len;
-	buf[6] = rcv_len;
+	state->data[0] = SYNC_BYTE_OUT;
+	state->data[1] = id;
+	state->data[2] = PCTV_CMD_I2C;
+	state->data[3] = snd_len + 3;
+	state->data[4] = addr << 1;
+	state->data[5] = snd_len;
+	state->data[6] = rcv_len;
 
-	memcpy(buf + 7, snd_buf, snd_len);
+	memcpy(state->data + 7, snd_buf, snd_len);
 
-	ret = dvb_usb_generic_rw(d, buf, 7 + snd_len,
-				  buf, /* rcv_len */ 64,
+	ret = dvb_usb_generic_rw(d, state->data, 7 + snd_len,
+				  state->data, /* rcv_len */ 64,
 				  /* delay_ms */ 0);
 	if (ret < 0)
 		goto failed;
 
 	/* TT USB protocol error. */
 	ret = -EIO;
-	if (SYNC_BYTE_IN != buf[0] || id != buf[1])
+	if (SYNC_BYTE_IN != state->data[0] || id != state->data[1])
 		goto failed;
 
 	/* I2C device didn't respond as expected. */
 	ret = -EREMOTEIO;
-	if (buf[5] < snd_len || buf[6] < rcv_len)
+	if (state->data[5] < snd_len || state->data[6] < rcv_len)
 		goto failed;
 
-	memcpy(rcv_buf, buf + 7, rcv_len);
+	memcpy(rcv_buf, state->data + 7, rcv_len);
+	mutex_unlock(&state->ca_mutex);
 
 	return rcv_len;
 
 failed:
-	err("I2C error %d; %02X %02X  %02X %02X %02X -> "
-	     "%02X %02X  %02X %02X %02X.",
+	err("I2C error %d; %02X %02X  %02X %02X %02X -> %*ph",
 	     ret, SYNC_BYTE_OUT, id, addr << 1, snd_len, rcv_len,
-	     buf[0], buf[1], buf[4], buf[5], buf[6]);
+	     7, state->data);
 
+	mutex_unlock(&state->ca_mutex);
 	return ret;
 }
 
@@ -499,8 +504,7 @@ static u32 pctv452e_i2c_func(struct i2c_adapter *adapter)
 static int pctv452e_power_ctrl(struct dvb_usb_device *d, int i)
 {
 	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
-	u8 b0[] = { 0xaa, 0, PCTV_CMD_RESET, 1, 0 };
-	u8 rx[PCTV_ANSWER_LEN];
+	u8 *rx;
 	int ret;
 
 	info("%s: %d\n", __func__, i);
@@ -511,6 +515,11 @@ static int pctv452e_power_ctrl(struct dvb_usb_device *d, int i)
 	if (state->initialized)
 		return 0;
 
+	rx = kmalloc(PCTV_ANSWER_LEN, GFP_KERNEL);
+	if (!rx)
+		return -ENOMEM;
+
+	mutex_lock(&state->ca_mutex);
 	/* hmm where shoud this should go? */
 	ret = usb_set_interface(d->udev, 0, ISOC_INTERFACE_ALTERNATIVE);
 	if (ret != 0)
@@ -518,65 +527,75 @@ static int pctv452e_power_ctrl(struct dvb_usb_device *d, int i)
 			__func__, ret);
 
 	/* this is a one-time initialization, dont know where to put */
-	b0[1] = state->c++;
+	state->data[0] = 0xaa;
+	state->data[1] = state->c++;
+	state->data[2] = PCTV_CMD_RESET;
+	state->data[3] = 1;
+	state->data[4] = 0;
 	/* reset board */
-	ret = dvb_usb_generic_rw(d, b0, sizeof(b0), rx, PCTV_ANSWER_LEN, 0);
+	ret = dvb_usb_generic_rw(d, state->data, 5, rx, PCTV_ANSWER_LEN, 0);
 	if (ret)
-		return ret;
+		goto ret;
 
-	b0[1] = state->c++;
-	b0[4] = 1;
+	state->data[1] = state->c++;
+	state->data[4] = 1;
 	/* reset board (again?) */
-	ret = dvb_usb_generic_rw(d, b0, sizeof(b0), rx, PCTV_ANSWER_LEN, 0);
+	ret = dvb_usb_generic_rw(d, state->data, 5, rx, PCTV_ANSWER_LEN, 0);
 	if (ret)
-		return ret;
+		goto ret;
 
 	state->initialized = 1;
 
-	return 0;
+ret:
+	mutex_unlock(&state->ca_mutex);
+	kfree(rx);
+	return ret;
 }
 
 static int pctv452e_rc_query(struct dvb_usb_device *d)
 {
 	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
-	u8 b[CMD_BUFFER_SIZE];
-	u8 rx[PCTV_ANSWER_LEN];
 	int ret, i;
-	u8 id = state->c++;
+	u8 id;
+
+	mutex_lock(&state->ca_mutex);
+	id = state->c++;
 
 	/* prepare command header  */
-	b[0] = SYNC_BYTE_OUT;
-	b[1] = id;
-	b[2] = PCTV_CMD_IR;
-	b[3] = 0;
+	state->data[0] = SYNC_BYTE_OUT;
+	state->data[1] = id;
+	state->data[2] = PCTV_CMD_IR;
+	state->data[3] = 0;
 
 	/* send ir request */
-	ret = dvb_usb_generic_rw(d, b, 4, rx, PCTV_ANSWER_LEN, 0);
+	ret = dvb_usb_generic_rw(d, state->data, 4,
+				 state->data, PCTV_ANSWER_LEN, 0);
 	if (ret != 0)
-		return ret;
+		goto ret;
 
 	if (debug > 3) {
-		info("%s: read: %2d: %*ph: ", __func__, ret, 3, rx);
-		for (i = 0; (i < rx[3]) && ((i+3) < PCTV_ANSWER_LEN); i++)
-			info(" %02x", rx[i+3]);
+		info("%s: read: %2d: %*ph: ", __func__, ret, 3, state->data);
+		for (i = 0; (i < state->data[3]) && ((i + 3) < PCTV_ANSWER_LEN); i++)
+			info(" %02x", state->data[i + 3]);
 
 		info("\n");
 	}
 
-	if ((rx[3] == 9) &&  (rx[12] & 0x01)) {
+	if ((state->data[3] == 9) &&  (state->data[12] & 0x01)) {
 		/* got a "press" event */
-		state->last_rc_key = RC_SCANCODE_RC5(rx[7], rx[6]);
+		state->last_rc_key = RC_SCANCODE_RC5(state->data[7], state->data[6]);
 		if (debug > 2)
 			info("%s: cmd=0x%02x sys=0x%02x\n",
-				__func__, rx[6], rx[7]);
+				__func__, state->data[6], state->data[7]);
 
 		rc_keydown(d->rc_dev, RC_TYPE_RC5, state->last_rc_key, 0);
 	} else if (state->last_rc_key) {
 		rc_keyup(d->rc_dev);
 		state->last_rc_key = 0;
 	}
-
-	return 0;
+ret:
+	mutex_unlock(&state->ca_mutex);
+	return ret;
 }
 
 static int pctv452e_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
-- 
2.7.4



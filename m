Return-path: <linux-media-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:41712 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab1HYWMF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 18:12:05 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, error27@gmail.com,
	pboettcher@kernellabs.com, florian@mickler.org,
	Markus_Stephan@freenet.de, jirislaby@gmail.com
Subject: [PATCH v2] [media] vp702x: fix buffer handling
Date: Fri, 26 Aug 2011 00:11:15 +0200
Message-Id: <1314310275-30960-1-git-send-email-florian@mickler.org>
In-Reply-To: <1312300213-29099-1-git-send-email-florian@mickler.org>
References: <1312300213-29099-1-git-send-email-florian@mickler.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In my previous change to this driver, I was not aware, that dvb_usb_device_init
calls the frontend_attach routine which needs a transfer
buffer. So we can not setup anything private in the probe routine beforehand but
have to allocate when needed. This means also that we cannot use a private
buffer mutex to serialize that buffer but instead need to use the
dvb_usb_device's usb_mutex.

Fixes: https://bugzilla.novell.com/show_bug.cgi?id=709440

Tested-by: Markus Stephan <Markus_Stephan@freenet.de>
Signed-off-by: Florian Mickler <florian@mickler.org>
---

So, someone who could test that driver found me after all.

I renamed the functions to get rid of that ugly and pointless _unlocked suffix I
deliriously added earlier. Markus tested this patch modulo function renaming. I am
so shure that this version will still work for him, that I already added his
Tested-by. *fingerscrossed*

 drivers/media/dvb/dvb-usb/vp702x-fe.c |   92 +++++++++++----
 drivers/media/dvb/dvb-usb/vp702x.c    |  211 ++++++++++++++++++---------------
 drivers/media/dvb/dvb-usb/vp702x.h    |   13 ++-
 3 files changed, 193 insertions(+), 123 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/dvb/dvb-usb/vp702x-fe.c
index 2bb8d4c..ad16455 100644
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -43,21 +43,30 @@ static int vp702x_fe_refresh_state(struct vp702x_fe_state *st)
 {
 	struct vp702x_device_state *dst = st->d->priv;
 	u8 *buf;
+	int ret;
 
 	if (time_after(jiffies, st->next_status_check)) {
-		mutex_lock(&dst->buf_mutex);
-		buf = dst->buf;
+		ret = mutex_lock_interruptible(&st->d->usb_mutex);
+		if (ret < 0)
+			return ret;
+
+		ret = vp702x_buffer_setup(dst, &buf, 10);
+		if (ret)
+			goto unlock;
 
 		vp702x_usb_in_op(st->d, READ_STATUS, 0, 0, buf, 10);
 		st->lock = buf[4];
 
-		vp702x_usb_in_op(st->d, READ_TUNER_REG_REQ, 0x11, 0, buf, 1);
+		vp702x_usb_in_op(st->d, READ_TUNER_REG_REQ, 0x11, 0,
+				buf, 1);
 		st->snr = buf[0];
 
-		vp702x_usb_in_op(st->d, READ_TUNER_REG_REQ, 0x15, 0, buf, 1);
+		vp702x_usb_in_op(st->d, READ_TUNER_REG_REQ, 0x15, 0,
+				buf, 1);
 		st->sig = buf[0];
 
-		mutex_unlock(&dst->buf_mutex);
+unlock:
+		mutex_unlock(&st->d->usb_mutex);
 		st->next_status_check = jiffies + (st->status_check_interval*HZ)/1000;
 	}
 	return 0;
@@ -145,11 +154,15 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
 /*	u16 frequencyRef[16] = { 2, 4, 8, 16, 32, 64, 128, 256, 24, 5, 10, 20, 40, 80, 160, 320 }; */
 	u64 sr;
 	u8 *cmd;
+	int ret;
 
-	mutex_lock(&dst->buf_mutex);
+	ret = mutex_lock_interruptible(&st->d->usb_mutex);
+	if (ret < 0)
+		return ret;
 
-	cmd = dst->buf;
-	memset(cmd, 0, 10);
+	ret = vp702x_buffer_setup(dst, &cmd, 10);
+	if (ret)
+		goto unlock;
 
 	cmd[0] = (freq >> 8) & 0x7f;
 	cmd[1] =  freq       & 0xff;
@@ -191,17 +204,25 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
 		deb_fe("tuning failed.\n");
 	else
 		deb_fe("tuning succeeded.\n");
+	ret = 0;
 
-	mutex_unlock(&dst->buf_mutex);
-
-	return 0;
+unlock:
+	mutex_unlock(&st->d->usb_mutex);
+	return ret;
 }
 
 static int vp702x_fe_init(struct dvb_frontend *fe)
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
+	int ret;
+
 	deb_fe("%s\n",__func__);
+	ret = mutex_lock_interruptible(&st->d->usb_mutex);
+	if (ret < 0)
+		return ret;
 	vp702x_usb_in_op(st->d, RESET_TUNER, 0, 0, NULL, 0);
+
+	mutex_unlock(&st->d->usb_mutex);
 	return 0;
 }
 
@@ -224,15 +245,21 @@ static int vp702x_fe_send_diseqc_msg (struct dvb_frontend* fe,
 	u8 *cmd;
 	struct vp702x_fe_state *st = fe->demodulator_priv;
 	struct vp702x_device_state *dst = st->d->priv;
+	int ret;
 
 	deb_fe("%s\n",__func__);
 
 	if (m->msg_len > 4)
 		return -EINVAL;
 
-	mutex_lock(&dst->buf_mutex);
+	ret = mutex_lock_interruptible(&st->d->usb_mutex);
+	if (ret < 0)
+		return ret;
+
+	ret = vp702x_buffer_setup(dst, &cmd, 10);
+	if (ret)
+		goto unlock;
 
-	cmd = dst->buf;
 	cmd[1] = SET_DISEQC_CMD;
 	cmd[2] = m->msg_len;
 	memcpy(&cmd[3], m->msg, m->msg_len);
@@ -244,10 +271,12 @@ static int vp702x_fe_send_diseqc_msg (struct dvb_frontend* fe,
 		deb_fe("diseqc cmd failed.\n");
 	else
 		deb_fe("diseqc cmd succeeded.\n");
+	ret = 0;
 
-	mutex_unlock(&dst->buf_mutex);
+unlock:
+	mutex_unlock(&st->d->usb_mutex);
 
-	return 0;
+	return ret;
 }
 
 static int vp702x_fe_send_diseqc_burst (struct dvb_frontend* fe, fe_sec_mini_cmd_t burst)
@@ -261,6 +290,7 @@ static int vp702x_fe_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 	struct vp702x_fe_state *st = fe->demodulator_priv;
 	struct vp702x_device_state *dst = st->d->priv;
 	u8 *buf;
+	int ret;
 
 	deb_fe("%s\n",__func__);
 
@@ -273,9 +303,14 @@ static int vp702x_fe_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 
 	st->lnb_buf[7] = vp702x_chksum(st->lnb_buf, 0, 7);
 
-	mutex_lock(&dst->buf_mutex);
+	ret = mutex_lock_interruptible(&st->d->usb_mutex);
+	if (ret < 0)
+		return ret;
+
+	ret = vp702x_buffer_setup(dst, &buf, 10);
+	if (ret)
+		goto unlock;
 
-	buf = dst->buf;
 	memcpy(buf, st->lnb_buf, 8);
 
 	vp702x_usb_inout_op(st->d, buf, 8, buf, 10, 100);
@@ -283,10 +318,11 @@ static int vp702x_fe_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 		deb_fe("set_tone cmd failed.\n");
 	else
 		deb_fe("set_tone cmd succeeded.\n");
+	ret = 0;
+unlock:
+	mutex_unlock(&st->d->usb_mutex);
 
-	mutex_unlock(&dst->buf_mutex);
-
-	return 0;
+	return ret;
 }
 
 static int vp702x_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t
@@ -295,6 +331,7 @@ static int vp702x_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t
 	struct vp702x_fe_state *st = fe->demodulator_priv;
 	struct vp702x_device_state *dst = st->d->priv;
 	u8 *buf;
+	int ret;
 	deb_fe("%s\n",__func__);
 
 	st->voltage = voltage;
@@ -306,9 +343,13 @@ static int vp702x_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t
 
 	st->lnb_buf[7] = vp702x_chksum(st->lnb_buf, 0, 7);
 
-	mutex_lock(&dst->buf_mutex);
+	ret = mutex_lock_interruptible(&st->d->usb_mutex);
+	if (ret < 0)
+		return ret;
+	ret = vp702x_buffer_setup(dst, &buf, 10);
+	if (ret)
+		goto unlock;
 
-	buf = dst->buf;
 	memcpy(buf, st->lnb_buf, 8);
 
 	vp702x_usb_inout_op(st->d, buf, 8, buf, 10, 100);
@@ -316,9 +357,10 @@ static int vp702x_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t
 		deb_fe("set_voltage cmd failed.\n");
 	else
 		deb_fe("set_voltage cmd succeeded.\n");
-
-	mutex_unlock(&dst->buf_mutex);
-	return 0;
+	ret = 0;
+unlock:
+	mutex_unlock(&st->d->usb_mutex);
+	return ret;
 }
 
 static void vp702x_fe_release(struct dvb_frontend* fe)
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 54355f8..1ff2296 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -30,7 +30,7 @@ struct vp702x_adapter_state {
 	u8  pid_filter_state;
 };
 
-static int vp702x_usb_in_op_unlocked(struct dvb_usb_device *d, u8 req,
+int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req,
 				     u16 value, u16 index, u8 *b, int blen)
 {
 	int ret;
@@ -55,20 +55,8 @@ static int vp702x_usb_in_op_unlocked(struct dvb_usb_device *d, u8 req,
 	return ret;
 }
 
-int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value,
-			    u16 index, u8 *b, int blen)
-{
-	int ret;
-
-	mutex_lock(&d->usb_mutex);
-	ret = vp702x_usb_in_op_unlocked(d, req, value, index, b, blen);
-	mutex_unlock(&d->usb_mutex);
-
-	return ret;
-}
-
-int vp702x_usb_out_op_unlocked(struct dvb_usb_device *d, u8 req, u16 value,
-				      u16 index, u8 *b, int blen)
+static int vp702x_usb_out_op(struct dvb_usb_device *d, u8 req,
+		u16 value, u16 index, u8 *b, int blen)
 {
 	int ret;
 	deb_xfer("out: req. %02x, val: %04x, ind: %04x, buffer: ",req,value,index);
@@ -86,33 +74,51 @@ int vp702x_usb_out_op_unlocked(struct dvb_usb_device *d, u8 req, u16 value,
 		return 0;
 }
 
-int vp702x_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
-			     u16 index, u8 *b, int blen)
+static int vp702x_usb_out_op2(struct dvb_usb_device *d, u8 req, u16 val, u16 idx)
 {
 	int ret;
+	ret = mutex_lock_interruptible(&d->usb_mutex);
+	if (ret < 0)
+		return ret;
 
-	mutex_lock(&d->usb_mutex);
-	ret = vp702x_usb_out_op_unlocked(d, req, value, index, b, blen);
-	mutex_unlock(&d->usb_mutex);
+	vp702x_usb_out_op(d, req, val, idx, NULL, 0);
 
-	return ret;
+	mutex_unlock(&d->usb_mutex);
+	return 0;
 }
 
-int vp702x_usb_inout_op(struct dvb_usb_device *d, u8 *o, int olen, u8 *i, int ilen, int msec)
+int vp702x_usb_inout_op(struct dvb_usb_device *d, u8 *o, int olen,
+		u8 *i, int ilen, int msec)
 {
 	int ret;
 
-	if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
-		return ret;
-
-	ret = vp702x_usb_out_op_unlocked(d, REQUEST_OUT, 0, 0, o, olen);
+	ret = vp702x_usb_out_op(d, REQUEST_OUT, 0, 0, o, olen);
 	msleep(msec);
-	ret = vp702x_usb_in_op_unlocked(d, REQUEST_IN, 0, 0, i, ilen);
+	ret = vp702x_usb_in_op(d, REQUEST_IN, 0, 0, i, ilen);
 
-	mutex_unlock(&d->usb_mutex);
 	return ret;
 }
 
+/*
+ * any buffer access has to be protected by dvb_usb_device.usb_mutex
+ */
+int vp702x_buffer_setup(struct vp702x_device_state *st, u8 **bufp,
+		int buflen)
+{
+	if (buflen > st->buf_len) {
+		*bufp = kmalloc(buflen, GFP_KERNEL);
+		if (!*bufp)
+			return -ENOMEM;
+		info("successfully reallocated a bigger buffer");
+		kfree(st->buf);
+		st->buf = *bufp;
+		st->buf_len = buflen;
+	} else {
+		*bufp = st->buf;
+	}
+	return 0;
+}
+
 static int vp702x_usb_inout_cmd(struct dvb_usb_device *d, u8 cmd, u8 *o,
 				int olen, u8 *i, int ilen, int msec)
 {
@@ -121,23 +127,13 @@ static int vp702x_usb_inout_cmd(struct dvb_usb_device *d, u8 cmd, u8 *o,
 	u8 *buf;
 	int buflen = max(olen + 2, ilen + 1);
 
-	ret = mutex_lock_interruptible(&st->buf_mutex);
+	ret = mutex_lock_interruptible(&d->usb_mutex);
 	if (ret < 0)
 		return ret;
 
-	if (buflen > st->buf_len) {
-		buf = kmalloc(buflen, GFP_KERNEL);
-		if (!buf) {
-			mutex_unlock(&st->buf_mutex);
-			return -ENOMEM;
-		}
-		info("successfully reallocated a bigger buffer");
-		kfree(st->buf);
-		st->buf = buf;
-		st->buf_len = buflen;
-	} else {
-		buf = st->buf;
-	}
+	ret = vp702x_buffer_setup(st, &buf, buflen);
+	if (ret)
+		goto unlock;
 
 	buf[0] = 0x00;
 	buf[1] = cmd;
@@ -147,8 +143,8 @@ static int vp702x_usb_inout_cmd(struct dvb_usb_device *d, u8 cmd, u8 *o,
 
 	if (ret == 0)
 		memcpy(i, &buf[1], ilen);
-	mutex_unlock(&st->buf_mutex);
-
+unlock:
+	mutex_unlock(&d->usb_mutex);
 	return ret;
 }
 
@@ -158,14 +154,19 @@ static int vp702x_set_pld_mode(struct dvb_usb_adapter *adap, u8 bypass)
 	struct vp702x_device_state *st = adap->dev->priv;
 	u8 *buf;
 
-	mutex_lock(&st->buf_mutex);
+	ret = mutex_lock_interruptible(&adap->dev->usb_mutex);
+	if (ret < 0)
+		return ret;
 
-	buf = st->buf;
-	memset(buf, 0, 16);
+	ret = vp702x_buffer_setup(st, &buf, 16);
+	if (ret)
+		goto unlock;
 
+	memset(buf, 0, 16);
 	ret = vp702x_usb_in_op(adap->dev, 0xe0, (bypass << 8) | 0x0e,
 			0, buf, 16);
-	mutex_unlock(&st->buf_mutex);
+unlock:
+	mutex_unlock(&adap->dev->usb_mutex);
 	return ret;
 }
 
@@ -175,15 +176,20 @@ static int vp702x_set_pld_state(struct dvb_usb_adapter *adap, u8 state)
 	struct vp702x_device_state *st = adap->dev->priv;
 	u8 *buf;
 
-	mutex_lock(&st->buf_mutex);
+	ret = mutex_lock_interruptible(&adap->dev->usb_mutex);
+	if (ret < 0)
+		return ret;
+
+	ret = vp702x_buffer_setup(st, &buf, 16);
+	if (ret)
+		goto unlock;
 
-	buf = st->buf;
 	memset(buf, 0, 16);
 	ret = vp702x_usb_in_op(adap->dev, 0xe0, (state << 8) | 0x0f,
 			0, buf, 16);
 
-	mutex_unlock(&st->buf_mutex);
-
+unlock:
+	mutex_unlock(&adap->dev->usb_mutex);
 	return ret;
 }
 
@@ -192,6 +198,7 @@ static int vp702x_set_pid(struct dvb_usb_adapter *adap, u16 pid, u8 id, int onof
 	struct vp702x_adapter_state *st = adap->priv;
 	struct vp702x_device_state *dst = adap->dev->priv;
 	u8 *buf;
+	int ret;
 
 	if (onoff)
 		st->pid_filter_state |=  (1 << id);
@@ -204,16 +211,23 @@ static int vp702x_set_pid(struct dvb_usb_adapter *adap, u16 pid, u8 id, int onof
 
 	vp702x_set_pld_state(adap, st->pid_filter_state);
 
-	mutex_lock(&dst->buf_mutex);
+	ret = mutex_lock_interruptible(&adap->dev->usb_mutex);
+	if (ret < 0)
+		return ret;
 
-	buf = dst->buf;
-	memset(buf, 0, 16);
-	vp702x_usb_in_op(adap->dev, 0xe0, (((pid >> 8) & 0xff) << 8) | (id), 0, buf, 16);
-	vp702x_usb_in_op(adap->dev, 0xe0, (((pid     ) & 0xff) << 8) | (id+1), 0, buf, 16);
+	ret = vp702x_buffer_setup(dst, &buf, 16);
+	if (ret)
+		goto unlock;
 
-	mutex_unlock(&dst->buf_mutex);
+	memset(buf, 0, 16);
+	vp702x_usb_in_op(adap->dev, 0xe0,
+			(((pid >> 8) & 0xff) << 8) | (id), 0, buf, 16);
+	vp702x_usb_in_op(adap->dev, 0xe0,
+			(((pid     ) & 0xff) << 8) | (id+1), 0, buf, 16);
 
-	return 0;
+unlock:
+	mutex_unlock(&adap->dev->usb_mutex);
+	return ret;
 }
 
 
@@ -223,6 +237,7 @@ static int vp702x_init_pid_filter(struct dvb_usb_adapter *adap)
 	struct vp702x_device_state *dst = adap->dev->priv;
 	int i;
 	u8 *b;
+	int ret;
 
 	st->pid_filter_count = 8;
 	st->pid_filter_can_bypass = 1;
@@ -233,16 +248,23 @@ static int vp702x_init_pid_filter(struct dvb_usb_adapter *adap)
 	for (i = 0; i < st->pid_filter_count; i++)
 		vp702x_set_pid(adap, 0xffff, i, 1);
 
-	mutex_lock(&dst->buf_mutex);
-	b = dst->buf;
+	ret = mutex_lock_interruptible(&adap->dev->usb_mutex);
+	if (ret < 0)
+		return ret;
+
+	ret = vp702x_buffer_setup(dst, &b, 10);
+	if (ret)
+		goto unlock;
+
 	memset(b, 0, 10);
 	vp702x_usb_in_op(adap->dev, 0xb5, 3, 0, b, 10);
 	vp702x_usb_in_op(adap->dev, 0xb5, 0, 0, b, 10);
 	vp702x_usb_in_op(adap->dev, 0xb5, 1, 0, b, 10);
-	mutex_unlock(&dst->buf_mutex);
 	/*vp702x_set_pld_mode(d, 0); // filter */
 
-	return 0;
+unlock:
+	mutex_unlock(&adap->dev->usb_mutex);
+	return ret;
 }
 
 static int vp702x_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
@@ -261,6 +283,7 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 *key;
 	int i;
+	int ret;
 
 /* remove the following return to enabled remote querying */
 	return 0;
@@ -269,7 +292,11 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	if (!key)
 		return -ENOMEM;
 
-	vp702x_usb_in_op(d,READ_REMOTE_REQ,0,0,key,10);
+	ret = mutex_lock_interruptible(&d->usb_mutex);
+	if (ret < 0)
+		return ret;
+	vp702x_usb_in_op(d, READ_REMOTE_REQ, 0, 0, key, 10);
+	mutex_unlock(&d->usb_mutex);
 
 	deb_rc("remote query key: %x %d\n",key[1],key[1]);
 
@@ -294,22 +321,32 @@ static int vp702x_read_mac_addr(struct dvb_usb_device *d,u8 mac[6])
 {
 	u8 i, *buf;
 	struct vp702x_device_state *st = d->priv;
+	int ret;
+
+	ret = mutex_lock_interruptible(&d->usb_mutex);
+	if (ret < 0)
+		return ret;
+
+	ret = vp702x_buffer_setup(st, &buf, 6);
+	if (ret)
+		goto unlock;
 
-	mutex_lock(&st->buf_mutex);
-	buf = st->buf;
 	for (i = 6; i < 12; i++)
-		vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1, &buf[i - 6], 1);
+		vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1,
+				&buf[i - 6], 1);
 
 	memcpy(mac, buf, 6);
-	mutex_unlock(&st->buf_mutex);
-	return 0;
+
+unlock:
+	mutex_unlock(&d->usb_mutex);
+	return ret;
 }
 
 static int vp702x_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	u8 buf[10] = { 0 };
 
-	vp702x_usb_out_op(adap->dev, SET_TUNER_POWER_REQ, 0, 7, NULL, 0);
+	vp702x_usb_out_op2(adap->dev, SET_TUNER_POWER_REQ, 0, 7);
 
 	if (vp702x_usb_inout_cmd(adap->dev, GET_SYSTEM_STRING, NULL, 0,
 				   buf, 10, 10))
@@ -321,7 +358,8 @@ static int vp702x_frontend_attach(struct dvb_usb_adapter *adap)
 	vp702x_init_pid_filter(adap);
 
 	adap->fe = vp702x_fe_attach(adap->dev);
-	vp702x_usb_out_op(adap->dev, SET_TUNER_POWER_REQ, 1, 7, NULL, 0);
+
+	vp702x_usb_out_op2(adap->dev, SET_TUNER_POWER_REQ, 1, 7);
 
 	return 0;
 }
@@ -331,37 +369,20 @@ static struct dvb_usb_device_properties vp702x_properties;
 static int vp702x_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	struct dvb_usb_device *d;
-	struct vp702x_device_state *st;
-	int ret;
-
-	ret = dvb_usb_device_init(intf, &vp702x_properties,
-				   THIS_MODULE, &d, adapter_nr);
-	if (ret)
-		goto out;
-
-	st = d->priv;
-	st->buf_len = 16;
-	st->buf = kmalloc(st->buf_len, GFP_KERNEL);
-	if (!st->buf) {
-		ret = -ENOMEM;
-		dvb_usb_device_exit(intf);
-		goto out;
-	}
-	mutex_init(&st->buf_mutex);
-
-out:
-	return ret;
-
+	return dvb_usb_device_init(intf, &vp702x_properties,
+				   THIS_MODULE, NULL, adapter_nr);
 }
 
 static void vp702x_usb_disconnect(struct usb_interface *intf)
 {
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
 	struct vp702x_device_state *st = d->priv;
-	mutex_lock(&st->buf_mutex);
+
+	mutex_lock(&d->usb_mutex);
+	st->buf_len = 0;
 	kfree(st->buf);
-	mutex_unlock(&st->buf_mutex);
+	mutex_unlock(&d->usb_mutex);
+
 	dvb_usb_device_exit(intf);
 }
 
diff --git a/drivers/media/dvb/dvb-usb/vp702x.h b/drivers/media/dvb/dvb-usb/vp702x.h
index 20b9005..f7a39d6 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.h
+++ b/drivers/media/dvb/dvb-usb/vp702x.h
@@ -99,7 +99,10 @@ extern int dvb_usb_vp702x_debug;
 /* IN  i: 0, v: 0, no extra buffer */
 
 struct vp702x_device_state {
-	struct mutex buf_mutex;
+	/*
+	 * access to these has to be protected by
+	 * dvb_usb_device.usb_mutex
+	 */
 	int buf_len;
 	u8 *buf;
 };
@@ -107,7 +110,11 @@ struct vp702x_device_state {
 
 extern struct dvb_frontend * vp702x_fe_attach(struct dvb_usb_device *d);
 
-extern int vp702x_usb_inout_op(struct dvb_usb_device *d, u8 *o, int olen, u8 *i, int ilen, int msec);
-extern int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen);
+extern int vp702x_usb_inout_op(struct dvb_usb_device *d, u8 *o, int olen, u8 *i,
+		int ilen, int msec);
+extern int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req,
+		u16 value, u16 index, u8 *b, int blen);
+extern int vp702x_buffer_setup(struct vp702x_device_state *st, u8 **buf,
+		int len);
 
 #endif
-- 
1.7.6


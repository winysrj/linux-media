Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:55114 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754242Ab2ATVTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 16:19:21 -0500
From: Gordon Hecker <ghecker@gmx.de>
To: linux-media@vger.kernel.org
Cc: Gordon Hecker <ghecker@gmx.de>
Subject: [PATCH] af9013: fix i2c failures for dual-tuner devices
Date: Fri, 20 Jan 2012 22:18:57 +0100
Message-Id: <1327094337-12483-1-git-send-email-ghecker@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the following error messages with a
Terratec Cinergy T Stick Dual RC DVB-T device.

af9013: i2c wr failed=-1 reg=d607 len=1
af9015: command failed:2
af9013: i2c rd failed=-1 reg=d607 len=1
af9015: command failed:1

It implements exclusive access to i2c for only one frontend at a time
through a use-counter that is increased for each af9013_i2c_gate_ctrl-enable
or i2c-read/write and decreased accordingly. The use-counter remains
incremented after af9013_i2c_gate_ctrl-enable until the corresponding
disable.

Debug output was added.

ToDo:
 * Replace frontend by adapter (the dual-tuner devices do actually
   provide two adapters with one frontend each)
 * move af9013_i2c_gate_mutex, locked_fe, af9013_i2c_gate_ctrl_usecnt
   to the usb device
---
 drivers/media/dvb/frontends/af9013.c |   93 +++++++++++++++++++++++++++++-----
 1 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 6bcbcf5..ab69585 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -28,6 +28,54 @@ int af9013_debug;
 module_param_named(debug, af9013_debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 
+static DEFINE_MUTEX(af9013_i2c_gate_mutex);
+static struct dvb_frontend *locked_fe = 0;
+static int af9013_i2c_gate_ctrl_usecnt = 0;
+
+#define GATE_NOOP    0
+#define GATE_ENABLE  1
+#define GATE_DISABLE 2
+
+static int af9013_i2c_gate_inc_use_count(struct dvb_frontend *fe, int gate_op)
+{
+	int success = 0;
+	while (1) {
+		if (mutex_lock_interruptible(&af9013_i2c_gate_mutex) != 0) {
+			return -EAGAIN;
+		}
+		if (af9013_i2c_gate_ctrl_usecnt == 0 || locked_fe == fe) {
+			success = 1;
+			locked_fe = fe;
+			if (gate_op != GATE_DISABLE) {
+				af9013_i2c_gate_ctrl_usecnt++;
+			}
+		}
+		mutex_unlock(&af9013_i2c_gate_mutex);
+		if (success) {
+			break;
+		}
+		schedule();
+	}
+	dbg("%s: %d (%d)", __func__, af9013_i2c_gate_ctrl_usecnt, fe->dvb->num);
+	return 0;
+}
+
+static int af9013_i2c_gate_dec_use_count(struct dvb_frontend *fe, int gate_op)
+{
+	if (mutex_lock_interruptible(&af9013_i2c_gate_mutex) != 0) {
+		return -EAGAIN;
+	}
+	if (gate_op != GATE_ENABLE) {
+		af9013_i2c_gate_ctrl_usecnt--;
+	}
+	if (af9013_i2c_gate_ctrl_usecnt == 0) {
+		locked_fe = 0;
+	}
+	mutex_unlock(&af9013_i2c_gate_mutex);
+	dbg("%s: %d (%d)", __func__, af9013_i2c_gate_ctrl_usecnt, fe->dvb->num);
+	return 0;
+}
+
 struct af9013_state {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
@@ -44,7 +92,6 @@ struct af9013_state {
 	unsigned long set_frontend_jiffies;
 	unsigned long read_status_jiffies;
 	bool first_tune;
-	bool i2c_gate_state;
 	unsigned int statistics_step:3;
 	struct delayed_work statistics_work;
 };
@@ -54,6 +101,7 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	const u8 *val, int len)
 {
 	int ret;
+	struct dvb_frontend *fe = &(priv->fe);
 	u8 buf[3+len];
 	struct i2c_msg msg[1] = {
 		{
@@ -69,6 +117,10 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	buf[2] = mbox;
 	memcpy(&buf[3], val, len);
 
+	if (af9013_i2c_gate_inc_use_count(fe, GATE_NOOP) != 0) {
+		return -EAGAIN;
+	}
+	dbg("%s: I2C write reg:%04x (%d)", __func__, reg, fe->dvb->num);
 	ret = i2c_transfer(priv->i2c, msg, 1);
 	if (ret == 1) {
 		ret = 0;
@@ -76,6 +128,10 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 		warn("i2c wr failed=%d reg=%04x len=%d", ret, reg, len);
 		ret = -EREMOTEIO;
 	}
+
+	if (af9013_i2c_gate_dec_use_count(fe, GATE_NOOP) != 0) {
+		return -EAGAIN;
+	}
 	return ret;
 }
 
@@ -84,6 +140,7 @@ static int af9013_rd_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	u8 *val, int len)
 {
 	int ret;
+	struct dvb_frontend *fe = &(priv->fe);
 	u8 buf[3];
 	struct i2c_msg msg[2] = {
 		{
@@ -103,6 +160,10 @@ static int af9013_rd_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	buf[1] = (reg >> 0) & 0xff;
 	buf[2] = mbox;
 
+	if (af9013_i2c_gate_inc_use_count(fe, GATE_NOOP) != 0) {
+		return -EAGAIN;
+	}
+	dbg("%s: I2C read reg:%04x (%d)", __func__, reg, priv->fe.dvb->num);
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		ret = 0;
@@ -110,6 +171,9 @@ static int af9013_rd_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 		warn("i2c rd failed=%d reg=%04x len=%d", ret, reg, len);
 		ret = -EREMOTEIO;
 	}
+	if (af9013_i2c_gate_dec_use_count(fe, GATE_NOOP) != 0) {
+		return -EAGAIN;
+	}
 	return ret;
 }
 
@@ -1297,25 +1361,28 @@ static int af9013_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	int ret;
 	struct af9013_state *state = fe->demodulator_priv;
 
-	dbg("%s: enable=%d", __func__, enable);
-
-	/* gate already open or close */
-	if (state->i2c_gate_state == enable)
-		return 0;
+	if (af9013_i2c_gate_inc_use_count(fe,
+				enable ? GATE_ENABLE : GATE_DISABLE) != 0) {
+		return -EAGAIN;
+	}
+	dbg("%s: enable:%d (%d)", __func__, enable, fe->dvb->num);
 
 	if (state->config.ts_mode == AF9013_TS_USB)
 		ret = af9013_wr_reg_bits(state, 0xd417, 3, 1, enable);
 	else
 		ret = af9013_wr_reg_bits(state, 0xd607, 2, 1, enable);
-	if (ret)
-		goto err;
-
-	state->i2c_gate_state = enable;
+	
+	if (ret) {
+		dbg("%s: failed=%d", __func__, ret);
+	}
+	
+	if (!enable) {
+		if (af9013_i2c_gate_dec_use_count(fe, GATE_DISABLE) != 0) {
+			return -EAGAIN;
+		}
+	}
 
 	return ret;
-err:
-	dbg("%s: failed=%d", __func__, ret);
-	return ret;
 }
 
 static void af9013_release(struct dvb_frontend *fe)
-- 
1.7.5.4


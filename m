Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49674 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753751AbcKPQnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 23/35] [media] dib9000: use pr_foo() instead of printk()
Date: Wed, 16 Nov 2016 14:42:55 -0200
Message-Id: <bfb2c03ba7540d888b942ebef39e80ec66c0d35b.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dprintk() macro relies on continuation lines. This is not
a good practice and will break after commit 563873318d32
("Merge branch 'printk-cleanups").

So, instead of directly calling printk(), use pr_foo() macros,
adding a \n leading char on each macro call.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/dib9000.c | 171 ++++++++++++++++++----------------
 1 file changed, 89 insertions(+), 82 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index 5897977d2d00..6e023c0e4f24 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -7,6 +7,9 @@
  *	modify it under the terms of the GNU General Public License as
  *	published by the Free Software Foundation, version 2.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
@@ -21,7 +24,12 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "turn on debugging (default: 0)");
 
-#define dprintk(args...) do { if (debug) { printk(KERN_DEBUG "DiB9000: "); printk(args); printk("\n"); } } while (0)
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__ , ##arg);				\
+} while(0)
+
 #define MAX_NUMBER_OF_FRONTENDS 6
 
 struct i2c_device {
@@ -258,7 +266,7 @@ static int dib9000_read16_attr(struct dib9000_state *state, u16 reg, u8 *b, u32
 		state->msg[1].buf = b;
 		ret = i2c_transfer(state->i2c.i2c_adap, state->msg, 2) != 2 ? -EREMOTEIO : 0;
 		if (ret != 0) {
-			dprintk("i2c read error on %d", reg);
+			dprintk("i2c read error on %d\n", reg);
 			return -EREMOTEIO;
 		}
 
@@ -285,7 +293,7 @@ static u16 dib9000_i2c_read16(struct i2c_device *i2c, u16 reg)
 	i2c->i2c_write_buffer[1] = reg & 0xff;
 
 	if (i2c_transfer(i2c->i2c_adap, msg, 2) != 2) {
-		dprintk("read register %x error", reg);
+		dprintk("read register %x error\n", reg);
 		return 0;
 	}
 
@@ -440,7 +448,7 @@ static int dib9000_risc_mem_read(struct dib9000_state *state, u8 cmd, u8 * b, u1
 		return -EIO;
 
 	if (mutex_lock_interruptible(&state->platform.risc.mem_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 	dib9000_risc_mem_setup(state, cmd | 0x80);
@@ -456,7 +464,7 @@ static int dib9000_risc_mem_write(struct dib9000_state *state, u8 cmd, const u8
 		return -EIO;
 
 	if (mutex_lock_interruptible(&state->platform.risc.mem_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 	dib9000_risc_mem_setup(state, cmd);
@@ -479,13 +487,13 @@ static int dib9000_firmware_download(struct dib9000_state *state, u8 risc_id, u1
 	dib9000_write_word(state, 1025 + offs, 0);
 	dib9000_write_word(state, 1031 + offs, key);
 
-	dprintk("going to download %dB of microcode", len);
+	dprintk("going to download %dB of microcode\n", len);
 	if (dib9000_write16_noinc(state, 1026 + offs, (u8 *) code, (u16) len) != 0) {
-		dprintk("error while downloading microcode for RISC %c", 'A' + risc_id);
+		dprintk("error while downloading microcode for RISC %c\n", 'A' + risc_id);
 		return -EIO;
 	}
 
-	dprintk("Microcode for RISC %c loaded", 'A' + risc_id);
+	dprintk("Microcode for RISC %c loaded\n", 'A' + risc_id);
 
 	return 0;
 }
@@ -511,10 +519,10 @@ static int dib9000_mbx_host_init(struct dib9000_state *state, u8 risc_id)
 	} while ((reset_reg & 0x8000) && --tries);
 
 	if (reset_reg & 0x8000) {
-		dprintk("MBX: init ERROR, no response from RISC %c", 'A' + risc_id);
+		dprintk("MBX: init ERROR, no response from RISC %c\n", 'A' + risc_id);
 		return -EIO;
 	}
-	dprintk("MBX: initialized");
+	dprintk("MBX: initialized\n");
 	return 0;
 }
 
@@ -531,30 +539,27 @@ static int dib9000_mbx_send_attr(struct dib9000_state *state, u8 id, u16 * data,
 		return -EINVAL;
 
 	if (mutex_lock_interruptible(&state->platform.risc.mbx_if_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 	tmp = MAX_MAILBOX_TRY;
 	do {
 		size = dib9000_read_word_attr(state, 1043, attr) & 0xff;
 		if ((size + len + 1) > MBX_MAX_WORDS && --tmp) {
-			dprintk("MBX: RISC mbx full, retrying");
+			dprintk("MBX: RISC mbx full, retrying\n");
 			msleep(100);
 		} else
 			break;
 	} while (1);
 
-	/*dprintk( "MBX: size: %d", size); */
+	/*dprintk( "MBX: size: %d\n", size); */
 
 	if (tmp == 0) {
 		ret = -EINVAL;
 		goto out;
 	}
 #ifdef DUMP_MSG
-	dprintk("--> %02x %d ", id, len + 1);
-	for (i = 0; i < len; i++)
-		dprintk("%04x ", data[i]);
-	dprintk("\n");
+	dprintk("--> %02x %d %*ph\n", id, len + 1, len, data);
 #endif
 
 	/* byte-order conversion - works on big (where it is not necessary) or little endian */
@@ -596,7 +601,7 @@ static u8 dib9000_mbx_read(struct dib9000_state *state, u16 * data, u8 risc_id,
 		return 0;
 
 	if (mutex_lock_interruptible(&state->platform.risc.mbx_if_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return 0;
 	}
 	if (risc_id == 1)
@@ -622,13 +627,13 @@ static u8 dib9000_mbx_read(struct dib9000_state *state, u16 * data, u8 risc_id,
 		}
 
 #ifdef DUMP_MSG
-		dprintk("<-- ");
+		dprintk("<-- \n");
 		for (i = 0; i < size + 1; i++)
-			dprintk("%04x ", d[i]);
+			dprintk("%04x \n", d[i]);
 		dprintk("\n");
 #endif
 	} else {
-		dprintk("MBX: message is too big for message cache (%d), flushing message", size);
+		dprintk("MBX: message is too big for message cache (%d), flushing message\n", size);
 		size--;		/* Initial word already read */
 		while (size--)
 			dib9000_read16_noinc_attr(state, 1029 + mc_base, (u8 *) data, 2, attr);
@@ -649,9 +654,11 @@ static int dib9000_risc_debug_buf(struct dib9000_state *state, u16 * data, u8 si
 	b[2 * (size - 2) - 1] = '\0';	/* Bullet proof the buffer */
 	if (*b == '~') {
 		b++;
-		dprintk("%s", b);
+		dprintk("%s\n", b);
 	} else
-		dprintk("RISC%d: %d.%04d %s", state->fe_id, ts / 10000, ts % 10000, *b ? b : "<empty>");
+		dprintk("RISC%d: %d.%04d %s\n",
+			state->fe_id,
+			ts / 10000, ts % 10000, *b ? b : "<empty>");
 	return 1;
 }
 
@@ -666,7 +673,7 @@ static int dib9000_mbx_fetch_to_cache(struct dib9000_state *state, u16 attr)
 		if (*block == 0) {
 			size = dib9000_mbx_read(state, block, 1, attr);
 
-/*                      dprintk( "MBX: fetched %04x message to cache", *block); */
+/*                      dprintk( "MBX: fetched %04x message to cache\n", *block); */
 
 			switch (*block >> 8) {
 			case IN_MSG_DEBUG_BUF:
@@ -686,7 +693,7 @@ static int dib9000_mbx_fetch_to_cache(struct dib9000_state *state, u16 attr)
 			return 1;
 		}
 	}
-	dprintk("MBX: no free cache-slot found for new message...");
+	dprintk("MBX: no free cache-slot found for new message...\n");
 	return -1;
 }
 
@@ -706,7 +713,7 @@ static int dib9000_mbx_process(struct dib9000_state *state, u16 attr)
 		return -1;
 
 	if (mutex_lock_interruptible(&state->platform.risc.mbx_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -1;
 	}
 
@@ -715,7 +722,7 @@ static int dib9000_mbx_process(struct dib9000_state *state, u16 attr)
 
 	dib9000_read_word_attr(state, 1229, attr);	/* Clear the IRQ */
 /*      if (tmp) */
-/*              dprintk( "cleared IRQ: %x", tmp); */
+/*              dprintk( "cleared IRQ: %x\n", tmp); */
 	mutex_unlock(&state->platform.risc.mbx_lock);
 
 	return ret;
@@ -750,7 +757,7 @@ static int dib9000_mbx_get_message_attr(struct dib9000_state *state, u16 id, u16
 	} while (--timeout);
 
 	if (timeout == 0) {
-		dprintk("waiting for message %d timed out", id);
+		dprintk("waiting for message %d timed out\n", id);
 		return -1;
 	}
 
@@ -770,7 +777,7 @@ static int dib9000_risc_check_version(struct dib9000_state *state)
 		return -EIO;
 
 	fw_version = (r[0] << 8) | r[1];
-	dprintk("RISC: ver: %d.%02d (IC: %d)", fw_version >> 10, fw_version & 0x3ff, (r[2] << 8) | r[3]);
+	dprintk("RISC: ver: %d.%02d (IC: %d)\n", fw_version >> 10, fw_version & 0x3ff, (r[2] << 8) | r[3]);
 
 	if ((fw_version >> 10) != 7)
 		return -EINVAL;
@@ -850,40 +857,40 @@ static u16 dib9000_identify(struct i2c_device *client)
 
 	value = dib9000_i2c_read16(client, 896);
 	if (value != 0x01b3) {
-		dprintk("wrong Vendor ID (0x%x)", value);
+		dprintk("wrong Vendor ID (0x%x)\n", value);
 		return 0;
 	}
 
 	value = dib9000_i2c_read16(client, 897);
 	if (value != 0x4000 && value != 0x4001 && value != 0x4002 && value != 0x4003 && value != 0x4004 && value != 0x4005) {
-		dprintk("wrong Device ID (0x%x)", value);
+		dprintk("wrong Device ID (0x%x)\n", value);
 		return 0;
 	}
 
 	/* protect this driver to be used with 7000PC */
 	if (value == 0x4000 && dib9000_i2c_read16(client, 769) == 0x4000) {
-		dprintk("this driver does not work with DiB7000PC");
+		dprintk("this driver does not work with DiB7000PC\n");
 		return 0;
 	}
 
 	switch (value) {
 	case 0x4000:
-		dprintk("found DiB7000MA/PA/MB/PB");
+		dprintk("found DiB7000MA/PA/MB/PB\n");
 		break;
 	case 0x4001:
-		dprintk("found DiB7000HC");
+		dprintk("found DiB7000HC\n");
 		break;
 	case 0x4002:
-		dprintk("found DiB7000MC");
+		dprintk("found DiB7000MC\n");
 		break;
 	case 0x4003:
-		dprintk("found DiB9000A");
+		dprintk("found DiB9000A\n");
 		break;
 	case 0x4004:
-		dprintk("found DiB9000H");
+		dprintk("found DiB9000H\n");
 		break;
 	case 0x4005:
-		dprintk("found DiB9000M");
+		dprintk("found DiB9000M\n");
 		break;
 	}
 
@@ -1013,7 +1020,7 @@ static int dib9000_risc_apb_access_read(struct dib9000_state *state, u32 address
 	if (address >= 1024 || !state->platform.risc.fw_is_running)
 		return -EINVAL;
 
-	/* dprintk( "APB access thru rd fw %d %x", address, attribute); */
+	/* dprintk( "APB access thru rd fw %d %x\n", address, attribute); */
 
 	mb[0] = (u16) address;
 	mb[1] = len / 2;
@@ -1043,7 +1050,7 @@ static int dib9000_risc_apb_access_write(struct dib9000_state *state, u32 addres
 	if (len > 18)
 		return -EINVAL;
 
-	/* dprintk( "APB access thru wr fw %d %x", address, attribute); */
+	/* dprintk( "APB access thru wr fw %d %x\n", address, attribute); */
 
 	mb[0] = (u16)address;
 	for (i = 0; i + 1 < len; i += 2)
@@ -1191,7 +1198,7 @@ static int dib9000_fw_get_channel(struct dvb_frontend *fe)
 	int ret = 0;
 
 	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
@@ -1534,7 +1541,7 @@ static int dib9000_fw_set_output_mode(struct dvb_frontend *fe, int mode)
 	struct dib9000_state *state = fe->demodulator_priv;
 	u16 outreg, smo_mode;
 
-	dprintk("setting output mode for demod %p to %d", fe, mode);
+	dprintk("setting output mode for demod %p to %d\n", fe, mode);
 
 	switch (mode) {
 	case OUTMODE_MPEG2_PAR_GATED_CLK:
@@ -1556,7 +1563,7 @@ static int dib9000_fw_set_output_mode(struct dvb_frontend *fe, int mode)
 		outreg = 0;
 		break;
 	default:
-		dprintk("Unhandled output_mode passed to be set for demod %p", &state->fe[0]);
+		dprintk("Unhandled output_mode passed to be set for demod %p\n", &state->fe[0]);
 		return -EINVAL;
 	}
 
@@ -1590,7 +1597,7 @@ static int dib9000_tuner_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg msg[]
 				len = 16;
 
 			if (dib9000_read_word(state, 790) != 0)
-				dprintk("TunerITF: read busy");
+				dprintk("TunerITF: read busy\n");
 
 			dib9000_write_word(state, 784, (u16) (msg[index_msg].addr));
 			dib9000_write_word(state, 787, (len / 2) - 1);
@@ -1601,7 +1608,7 @@ static int dib9000_tuner_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg msg[]
 				i--;
 
 			if (i == 0)
-				dprintk("TunerITF: read failed");
+				dprintk("TunerITF: read failed\n");
 
 			for (i = 0; i < len; i += 2) {
 				t = dib9000_read_word(state, 785);
@@ -1609,13 +1616,13 @@ static int dib9000_tuner_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg msg[]
 				msg[index_msg].buf[i + 1] = (t) & 0xff;
 			}
 			if (dib9000_read_word(state, 790) != 0)
-				dprintk("TunerITF: read more data than expected");
+				dprintk("TunerITF: read more data than expected\n");
 		} else {
 			i = 1000;
 			while (dib9000_read_word(state, 789) && i)
 				i--;
 			if (i == 0)
-				dprintk("TunerITF: write busy");
+				dprintk("TunerITF: write busy\n");
 
 			len = msg[index_msg].len;
 			if (len > 16)
@@ -1631,7 +1638,7 @@ static int dib9000_tuner_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg msg[]
 			while (dib9000_read_word(state, 791) > 0 && i)
 				i--;
 			if (i == 0)
-				dprintk("TunerITF: write failed");
+				dprintk("TunerITF: write failed\n");
 		}
 	}
 	return num;
@@ -1676,7 +1683,7 @@ static int dib9000_fw_component_bus_xfer(struct i2c_adapter *i2c_adap, struct i2
 	}
 
 	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return 0;
 	}
 
@@ -1759,7 +1766,7 @@ static int dib9000_cfg_gpio(struct dib9000_state *st, u8 num, u8 dir, u8 val)
 	st->gpio_val |= (val & 0x01) << num;	/* set the new value */
 	dib9000_write_word(st, 774, st->gpio_val);
 
-	dprintk("gpio dir: %04x: gpio val: %04x", st->gpio_dir, st->gpio_val);
+	dprintk("gpio dir: %04x: gpio val: %04x\n", st->gpio_dir, st->gpio_val);
 
 	return 0;
 }
@@ -1779,7 +1786,7 @@ int dib9000_fw_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 
 	if ((state->pid_ctrl_index != -2) && (state->pid_ctrl_index < 9)) {
 		/* postpone the pid filtering cmd */
-		dprintk("pid filter cmd postpone");
+		dprintk("pid filter cmd postpone\n");
 		state->pid_ctrl_index++;
 		state->pid_ctrl[state->pid_ctrl_index].cmd = DIB9000_PID_FILTER_CTRL;
 		state->pid_ctrl[state->pid_ctrl_index].onoff = onoff;
@@ -1787,14 +1794,14 @@ int dib9000_fw_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 	}
 
 	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 
 	val = dib9000_read_word(state, 294 + 1) & 0xffef;
 	val |= (onoff & 0x1) << 4;
 
-	dprintk("PID filter enabled %d", onoff);
+	dprintk("PID filter enabled %d\n", onoff);
 	ret = dib9000_write_word(state, 294 + 1, val);
 	mutex_unlock(&state->demod_lock);
 	return ret;
@@ -1809,7 +1816,7 @@ int dib9000_fw_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 
 	if (state->pid_ctrl_index != -2) {
 		/* postpone the pid filtering cmd */
-		dprintk("pid filter postpone");
+		dprintk("pid filter postpone\n");
 		if (state->pid_ctrl_index < 9) {
 			state->pid_ctrl_index++;
 			state->pid_ctrl[state->pid_ctrl_index].cmd = DIB9000_PID_FILTER;
@@ -1817,15 +1824,15 @@ int dib9000_fw_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 			state->pid_ctrl[state->pid_ctrl_index].pid = pid;
 			state->pid_ctrl[state->pid_ctrl_index].onoff = onoff;
 		} else
-			dprintk("can not add any more pid ctrl cmd");
+			dprintk("can not add any more pid ctrl cmd\n");
 		return 0;
 	}
 
 	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
-	dprintk("Index %x, PID %d, OnOff %d", id, pid, onoff);
+	dprintk("Index %x, PID %d, OnOff %d\n", id, pid, onoff);
 	ret = dib9000_write_word(state, 300 + 1 + id,
 			onoff ? (1 << 13) | pid : 0);
 	mutex_unlock(&state->demod_lock);
@@ -1868,7 +1875,7 @@ static int dib9000_sleep(struct dvb_frontend *fe)
 	int ret = 0;
 
 	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
@@ -1899,7 +1906,7 @@ static int dib9000_get_frontend(struct dvb_frontend *fe,
 
 	if (state->get_frontend_internal == 0) {
 		if (mutex_lock_interruptible(&state->demod_lock) < 0) {
-			dprintk("could not get the lock");
+			dprintk("could not get the lock\n");
 			return -EINTR;
 		}
 	}
@@ -1907,7 +1914,7 @@ static int dib9000_get_frontend(struct dvb_frontend *fe,
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 		state->fe[index_frontend]->ops.read_status(state->fe[index_frontend], &stat);
 		if (stat & FE_HAS_SYNC) {
-			dprintk("TPS lock on the slave%i", index_frontend);
+			dprintk("TPS lock on the slave%i\n", index_frontend);
 
 			/* synchronize the cache with the other frontends */
 			state->fe[index_frontend]->ops.get_frontend(state->fe[index_frontend], c);
@@ -1995,18 +2002,18 @@ static int dib9000_set_frontend(struct dvb_frontend *fe)
 
 	/* check that the correct parameters are set */
 	if (state->fe[0]->dtv_property_cache.frequency == 0) {
-		dprintk("dib9000: must specify frequency ");
+		dprintk("dib9000: must specify frequency \n");
 		return 0;
 	}
 
 	if (state->fe[0]->dtv_property_cache.bandwidth_hz == 0) {
-		dprintk("dib9000: must specify bandwidth ");
+		dprintk("dib9000: must specify bandwidth \n");
 		return 0;
 	}
 
 	state->pid_ctrl_index = -1; /* postpone the pid filtering cmd */
 	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return 0;
 	}
 
@@ -2073,14 +2080,14 @@ static int dib9000_set_frontend(struct dvb_frontend *fe)
 
 	/* check the tune result */
 	if (exit_condition == 1) {	/* tune failed */
-		dprintk("tune failed");
+		dprintk("tune failed\n");
 		mutex_unlock(&state->demod_lock);
 		/* tune failed; put all the pid filtering cmd to junk */
 		state->pid_ctrl_index = -1;
 		return 0;
 	}
 
-	dprintk("tune success on frontend%i", index_frontend_success);
+	dprintk("tune success on frontend%i\n", index_frontend_success);
 
 	/* synchronize all the channel cache */
 	state->get_frontend_internal = 1;
@@ -2169,7 +2176,7 @@ static int dib9000_read_status(struct dvb_frontend *fe, enum fe_status *stat)
 	u16 lock = 0, lock_slave = 0;
 
 	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++)
@@ -2202,11 +2209,11 @@ static int dib9000_read_ber(struct dvb_frontend *fe, u32 * ber)
 	int ret = 0;
 
 	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		ret = -EINTR;
 		goto error;
 	}
@@ -2237,7 +2244,7 @@ static int dib9000_read_signal_strength(struct dvb_frontend *fe, u16 * strength)
 	int ret = 0;
 
 	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 	*strength = 0;
@@ -2250,7 +2257,7 @@ static int dib9000_read_signal_strength(struct dvb_frontend *fe, u16 * strength)
 	}
 
 	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		ret = -EINTR;
 		goto error;
 	}
@@ -2281,7 +2288,7 @@ static u32 dib9000_get_snr(struct dvb_frontend *fe)
 	u16 val;
 
 	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return 0;
 	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
@@ -2320,7 +2327,7 @@ static int dib9000_read_snr(struct dvb_frontend *fe, u16 * snr)
 	u32 snr_master;
 
 	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 	snr_master = dib9000_get_snr(fe);
@@ -2345,11 +2352,11 @@ static int dib9000_read_unc_blocks(struct dvb_frontend *fe, u32 * unc)
 	int ret = 0;
 
 	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		return -EINTR;
 	}
 	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
-		dprintk("could not get the lock");
+		dprintk("could not get the lock\n");
 		ret = -EINTR;
 		goto error;
 	}
@@ -2376,12 +2383,12 @@ int dib9000_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 defaul
 
 	client.i2c_write_buffer = kzalloc(4 * sizeof(u8), GFP_KERNEL);
 	if (!client.i2c_write_buffer) {
-		dprintk("%s: not enough memory", __func__);
+		dprintk("%s: not enough memory\n", __func__);
 		return -ENOMEM;
 	}
 	client.i2c_read_buffer = kzalloc(4 * sizeof(u8), GFP_KERNEL);
 	if (!client.i2c_read_buffer) {
-		dprintk("%s: not enough memory", __func__);
+		dprintk("%s: not enough memory\n", __func__);
 		ret = -ENOMEM;
 		goto error_memory;
 	}
@@ -2408,7 +2415,7 @@ int dib9000_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 defaul
 		if (dib9000_identify(&client) == 0) {
 			client.i2c_addr = default_addr;
 			if (dib9000_identify(&client) == 0) {
-				dprintk("DiB9000 #%d: not identified", k);
+				dprintk("DiB9000 #%d: not identified\n", k);
 				ret = -EIO;
 				goto error;
 			}
@@ -2417,7 +2424,7 @@ int dib9000_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 defaul
 		dib9000_i2c_write16(&client, 1795, (1 << 10) | (4 << 6));
 		dib9000_i2c_write16(&client, 1794, (new_addr << 2) | 2);
 
-		dprintk("IC %d initialized (to i2c_address 0x%x)", k, new_addr);
+		dprintk("IC %d initialized (to i2c_address 0x%x)\n", k, new_addr);
 	}
 
 	for (k = 0; k < no_of_demods; k++) {
@@ -2445,12 +2452,12 @@ int dib9000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_frontend *fe_
 	while ((index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL))
 		index_frontend++;
 	if (index_frontend < MAX_NUMBER_OF_FRONTENDS) {
-		dprintk("set slave fe %p to index %i", fe_slave, index_frontend);
+		dprintk("set slave fe %p to index %i\n", fe_slave, index_frontend);
 		state->fe[index_frontend] = fe_slave;
 		return 0;
 	}
 
-	dprintk("too many slave frontend");
+	dprintk("too many slave frontend\n");
 	return -ENOMEM;
 }
 EXPORT_SYMBOL(dib9000_set_slave_frontend);
@@ -2463,12 +2470,12 @@ int dib9000_remove_slave_frontend(struct dvb_frontend *fe)
 	while ((index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL))
 		index_frontend++;
 	if (index_frontend != 1) {
-		dprintk("remove slave fe %p (index %i)", state->fe[index_frontend - 1], index_frontend - 1);
+		dprintk("remove slave fe %p (index %i)\n", state->fe[index_frontend - 1], index_frontend - 1);
 		state->fe[index_frontend] = NULL;
 		return 0;
 	}
 
-	dprintk("no frontend to be removed");
+	dprintk("no frontend to be removed\n");
 	return -ENODEV;
 }
 EXPORT_SYMBOL(dib9000_remove_slave_frontend);
-- 
2.7.4



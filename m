Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbaJ1PBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:01:00 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 07/13] [media] lbdt3306a: rework at printk macros
Date: Tue, 28 Oct 2014 13:00:42 -0200
Message-Id: <db25bb81ab10956db75d93e414f2cd738d8e29bf.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use pr_foo() where there's a direct replacement. For debug, use
custom-made macros, for now, as there are 3 different debug levels.

We should get rid of those some day, specially since several such
macros can be just removed, as Kernel trace would provide about
the same output.

This gets rid of some checkpatch errors:

WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
+#define lg_info(fmt, arg...)	printk(KERN_INFO "lgdt3306a: " fmt, ##arg)

ERROR: Macros with complex values should be enclosed in parentheses
+#define lg_dbg(fmt, arg...) if (debug & DBG_INFO)			\
+				lg_printk(KERN_DEBUG,         fmt, ##arg)

ERROR: Macros with complex values should be enclosed in parentheses
+#define lg_reg(fmt, arg...) if (debug & DBG_REG)			\
+				lg_printk(KERN_DEBUG,         fmt, ##arg)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 54c2c282e97e..85fc9c63e3ca 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -16,6 +16,8 @@
  *    GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/div64.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_math.h"
@@ -30,23 +32,27 @@ MODULE_PARM_DESC(debug, "set debug level (info=1, reg=2 (or-able))");
 #define DBG_REG  2
 #define DBG_DUMP 4 /* FGR - comment out to remove dump code */
 
-#define lg_printk(kern, fmt, arg...)					\
-	printk(kern "%s(): " fmt, __func__, ##arg)
+#define lg_debug(fmt, arg...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ## arg)
 
-#define lg_info(fmt, arg...)	printk(KERN_INFO "lgdt3306a: " fmt, ##arg)
-#define lg_warn(fmt, arg...)	lg_printk(KERN_WARNING,       fmt, ##arg)
-#define lg_err(fmt, arg...)	lg_printk(KERN_ERR,           fmt, ##arg)
-#define lg_dbg(fmt, arg...) if (debug & DBG_INFO)			\
-				lg_printk(KERN_DEBUG,         fmt, ##arg)
-#define lg_reg(fmt, arg...) if (debug & DBG_REG)			\
-				lg_printk(KERN_DEBUG,         fmt, ##arg)
+#define dbg_info(fmt, arg...)					\
+	do {							\
+		if (debug & DBG_INFO)				\
+			lg_debug(fmt, ## arg);			\
+	} while (0)
+
+#define dbg_reg(fmt, arg...)					\
+	do {							\
+		if (debug & DBG_REG)				\
+			lg_debug(fmt, ## arg);			\
+	} while (0)
 
 #define lg_chkerr(ret)							\
 ({									\
 	int __ret;							\
 	__ret = (ret < 0);						\
 	if (__ret)							\
-		lg_err("error %d on line %d\n",	ret, __LINE__);		\
+		pr_err("error %d on line %d\n",	ret, __LINE__);		\
 	__ret;								\
 })
 
@@ -116,12 +122,12 @@ static int lgdt3306a_write_reg(struct lgdt3306a_state *state, u16 reg, u8 val)
 		.buf = buf, .len = 3,
 	};
 
-	lg_reg("reg: 0x%04x, val: 0x%02x\n", reg, val);
+	dbg_reg("reg: 0x%04x, val: 0x%02x\n", reg, val);
 
 	ret = i2c_transfer(state->i2c_adap, &msg, 1);
 
 	if (ret != 1) {
-		lg_err("error (addr %02x %02x <- %02x, err = %i)\n",
+		pr_err("error (addr %02x %02x <- %02x, err = %i)\n",
 		       msg.buf[0], msg.buf[1], msg.buf[2], ret);
 		if (ret < 0)
 			return ret;
@@ -145,14 +151,14 @@ static int lgdt3306a_read_reg(struct lgdt3306a_state *state, u16 reg, u8 *val)
 	ret = i2c_transfer(state->i2c_adap, msg, 2);
 
 	if (ret != 2) {
-		lg_err("error (addr %02x reg %04x error (ret == %i)\n",
+		pr_err("error (addr %02x reg %04x error (ret == %i)\n",
 		       state->cfg->i2c_addr, reg, ret);
 		if (ret < 0)
 			return ret;
 		else
 			return -EREMOTEIO;
 	}
-	lg_reg("reg: 0x%04x, val: 0x%02x\n", reg, *val);
+	dbg_reg("reg: 0x%04x, val: 0x%02x\n", reg, *val);
 
 	return 0;
 }
@@ -172,7 +178,7 @@ static int lgdt3306a_set_reg_bit(struct lgdt3306a_state *state,
 	u8 val;
 	int ret;
 
-	lg_reg("reg: 0x%04x, bit: %d, level: %d\n", reg, bit, onoff);
+	dbg_reg("reg: 0x%04x, bit: %d, level: %d\n", reg, bit, onoff);
 
 	ret = lgdt3306a_read_reg(state, reg, &val);
 	if (lg_chkerr(ret))
@@ -193,7 +199,7 @@ static int lgdt3306a_soft_reset(struct lgdt3306a_state *state)
 {
 	int ret;
 
-	lg_dbg("\n");
+	dbg_info("\n");
 
 	ret = lgdt3306a_set_reg_bit(state, 0x0000, 7, 0);
 	if (lg_chkerr(ret))
@@ -213,7 +219,7 @@ static int lgdt3306a_mpeg_mode(struct lgdt3306a_state *state,
 	u8 val;
 	int ret;
 
-	lg_dbg("(%d)\n", mode);
+	dbg_info("(%d)\n", mode);
 	/* transport packet format */
 	ret = lgdt3306a_set_reg_bit(state, 0x0071, 7, mode == LGDT3306A_MPEG_PARALLEL?1:0); /* TPSENB=0x80 */
 	if (lg_chkerr(ret))
@@ -247,7 +253,7 @@ static int lgdt3306a_mpeg_mode_polarity(struct lgdt3306a_state *state,
 	u8 val;
 	int ret;
 
-	lg_dbg("edge=%d, valid=%d\n", edge, valid);
+	dbg_info("edge=%d, valid=%d\n", edge, valid);
 
 	ret = lgdt3306a_read_reg(state, 0x0070, &val);
 	if (lg_chkerr(ret))
@@ -273,7 +279,7 @@ static int lgdt3306a_mpeg_tristate(struct lgdt3306a_state *state,
 	u8 val;
 	int ret;
 
-	lg_dbg("(%d)\n", mode);
+	dbg_info("(%d)\n", mode);
 
 	if (mode) {
 		ret = lgdt3306a_read_reg(state, 0x0070, &val);
@@ -311,7 +317,7 @@ static int lgdt3306a_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 {
 	struct lgdt3306a_state *state = fe->demodulator_priv;
 
-	lg_dbg("acquire=%d\n", acquire);
+	dbg_info("acquire=%d\n", acquire);
 
 	return lgdt3306a_mpeg_tristate(state, acquire ? 0 : 1);
 
@@ -322,7 +328,7 @@ static int lgdt3306a_power(struct lgdt3306a_state *state,
 {
 	int ret;
 
-	lg_dbg("(%d)\n", mode);
+	dbg_info("(%d)\n", mode);
 
 	if (mode == 0) {
 		ret = lgdt3306a_set_reg_bit(state, 0x0000, 7, 0); /* into reset */
@@ -356,7 +362,7 @@ static int lgdt3306a_set_vsb(struct lgdt3306a_state *state)
 	u8 val;
 	int ret;
 
-	lg_dbg("\n");
+	dbg_info("\n");
 
 	/* 0. Spectrum inversion detection manual; spectrum inverted */
 	ret = lgdt3306a_read_reg(state, 0x0002, &val);
@@ -506,7 +512,7 @@ static int lgdt3306a_set_vsb(struct lgdt3306a_state *state)
 	if (lg_chkerr(ret))
 		goto fail;
 
-	lg_dbg("complete\n");
+	dbg_info("complete\n");
 fail:
 	return ret;
 }
@@ -516,7 +522,7 @@ static int lgdt3306a_set_qam(struct lgdt3306a_state *state, int modulation)
 	u8 val;
 	int ret;
 
-	lg_dbg("modulation=%d\n", modulation);
+	dbg_info("modulation=%d\n", modulation);
 
 	/* 1. Selection of standard mode(0x08=QAM, 0x80=VSB) */
 	ret = lgdt3306a_write_reg(state, 0x0008, 0x08);
@@ -578,7 +584,7 @@ static int lgdt3306a_set_qam(struct lgdt3306a_state *state, int modulation)
 	if (lg_chkerr(ret))
 		goto fail;
 
-	lg_dbg("complete\n");
+	dbg_info("complete\n");
 fail:
 	return ret;
 }
@@ -588,7 +594,7 @@ static int lgdt3306a_set_modulation(struct lgdt3306a_state *state,
 {
 	int ret;
 
-	lg_dbg("\n");
+	dbg_info("\n");
 
 	switch (p->modulation) {
 	case VSB_8:
@@ -618,7 +624,7 @@ static int lgdt3306a_agc_setup(struct lgdt3306a_state *state,
 			      struct dtv_frontend_properties *p)
 {
 	/* TODO: anything we want to do here??? */
-	lg_dbg("\n");
+	dbg_info("\n");
 
 	switch (p->modulation) {
 	case VSB_8:
@@ -639,7 +645,7 @@ static int lgdt3306a_set_inversion(struct lgdt3306a_state *state,
 {
 	int ret;
 
-	lg_dbg("(%d)\n", inversion);
+	dbg_info("(%d)\n", inversion);
 
 	ret = lgdt3306a_set_reg_bit(state, 0x0002, 2, inversion ? 1 : 0);
 	return ret;
@@ -650,7 +656,7 @@ static int lgdt3306a_set_inversion_auto(struct lgdt3306a_state *state,
 {
 	int ret;
 
-	lg_dbg("(%d)\n", enabled);
+	dbg_info("(%d)\n", enabled);
 
 	/* 0=Manual 1=Auto(QAM only) */
 	ret = lgdt3306a_set_reg_bit(state, 0x0002, 3, enabled);/* SPECINVAUTO=0x04 */
@@ -663,7 +669,7 @@ static int lgdt3306a_spectral_inversion(struct lgdt3306a_state *state,
 {
 	int ret = 0;
 
-	lg_dbg("(%d)\n", inversion);
+	dbg_info("(%d)\n", inversion);
 #if 0
 /* FGR - spectral_inversion defaults already set for VSB and QAM; can enable later if desired */
 
@@ -705,7 +711,7 @@ static int lgdt3306a_set_if(struct lgdt3306a_state *state,
 
 	switch (if_freq_khz) {
 	default:
-	    lg_warn("IF=%d KHz is not supportted, 3250 assumed\n", if_freq_khz);
+	    pr_warn("IF=%d KHz is not supportted, 3250 assumed\n", if_freq_khz);
 		/* fallthrough */
 	case 3250: /* 3.25Mhz */
 		nco1 = 0x34;
@@ -735,7 +741,7 @@ static int lgdt3306a_set_if(struct lgdt3306a_state *state,
 	if (ret)
 		return ret;
 
-	lg_dbg("if_freq=%d KHz->[%04x]\n", if_freq_khz, nco1<<8 | nco2);
+	dbg_info("if_freq=%d KHz->[%04x]\n", if_freq_khz, nco1<<8 | nco2);
 
 	return 0;
 }
@@ -747,10 +753,10 @@ static int lgdt3306a_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	struct lgdt3306a_state *state = fe->demodulator_priv;
 
 	if (state->cfg->deny_i2c_rptr) {
-		lg_dbg("deny_i2c_rptr=%d\n", state->cfg->deny_i2c_rptr);
+		dbg_info("deny_i2c_rptr=%d\n", state->cfg->deny_i2c_rptr);
 		return 0;
 	}
-	lg_dbg("(%d)\n", enable);
+	dbg_info("(%d)\n", enable);
 
 	return lgdt3306a_set_reg_bit(state, 0x0002, 7, enable ? 0 : 1); /* NI2CRPTEN=0x80 */
 }
@@ -759,7 +765,7 @@ static int lgdt3306a_sleep(struct lgdt3306a_state *state)
 {
 	int ret;
 
-	lg_dbg("\n");
+	dbg_info("\n");
 	state->current_frequency = -1; /* force re-tune, when we wake */
 
 	ret = lgdt3306a_mpeg_tristate(state, 1); /* disable data bus */
@@ -786,7 +792,7 @@ static int lgdt3306a_init(struct dvb_frontend *fe)
 	u8 val;
 	int ret;
 
-	lg_dbg("\n");
+	dbg_info("\n");
 
 	/* 1. Normal operation mode */
 	ret = lgdt3306a_set_reg_bit(state, 0x0001, 0, 1); /* SIMFASTENB=0x01 */
@@ -871,7 +877,7 @@ static int lgdt3306a_init(struct dvb_frontend *fe)
 		if (lg_chkerr(ret))
 			goto fail;
 	} else {
-		lg_err("Bad xtalMHz=%d\n", state->cfg->xtalMHz);
+		pr_err("Bad xtalMHz=%d\n", state->cfg->xtalMHz);
 	}
 #if 0
 	ret = lgdt3306a_write_reg(state, 0x000e, 0x00);
@@ -936,11 +942,11 @@ static int lgdt3306a_set_parameters(struct dvb_frontend *fe)
 	struct lgdt3306a_state *state = fe->demodulator_priv;
 	int ret;
 
-	lg_dbg("(%d, %d)\n", p->frequency, p->modulation);
+	dbg_info("(%d, %d)\n", p->frequency, p->modulation);
 
 	if (state->current_frequency  == p->frequency &&
 	   state->current_modulation == p->modulation) {
-		lg_dbg(" (already set, skipping ...)\n");
+		dbg_info(" (already set, skipping ...)\n");
 		return 0;
 	}
 	state->current_frequency = -1;
@@ -1009,7 +1015,7 @@ static int lgdt3306a_get_frontend(struct dvb_frontend *fe)
 	struct lgdt3306a_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
-	lg_dbg("(%u, %d)\n", state->current_frequency, state->current_modulation);
+	dbg_info("(%u, %d)\n", state->current_frequency, state->current_modulation);
 
 	p->modulation = state->current_modulation;
 	p->frequency = state->current_frequency;
@@ -1057,7 +1063,7 @@ static int lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
 		return ret;
 	fbDlyCir |= val;
 
-	lg_dbg("snrRef=%d maxPowerMan=0x%x nCombDet=%d fbDlyCir=0x%x\n",
+	dbg_info("snrRef=%d maxPowerMan=0x%x nCombDet=%d fbDlyCir=0x%x\n",
 		snrRef, maxPowerMan, nCombDet, fbDlyCir);
 
 	/* Carrier offset sub loop bandwidth */
@@ -1108,7 +1114,7 @@ static enum lgdt3306a_modulation lgdt3306a_check_oper_mode(struct lgdt3306a_stat
 		goto err;
 
 	if (val & 0x80)	{
-		lg_dbg("VSB\n");
+		dbg_info("VSB\n");
 		return LG3306_VSB;
 	}
 	if (val & 0x08) {
@@ -1117,15 +1123,15 @@ static enum lgdt3306a_modulation lgdt3306a_check_oper_mode(struct lgdt3306a_stat
 			goto err;
 		val = val >> 2;
 		if (val & 0x01) {
-			lg_dbg("QAM256\n");
+			dbg_info("QAM256\n");
 			return LG3306_QAM256;
 		} else {
-			lg_dbg("QAM64\n");
+			dbg_info("QAM64\n");
 			return LG3306_QAM64;
 		}
 	}
 err:
-	lg_warn("UNKNOWN\n");
+	pr_warn("UNKNOWN\n");
 	return LG3306_UNKNOWN_MODE;
 }
 
@@ -1151,7 +1157,7 @@ static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_s
 		else
 			lockStatus = LG3306_UNLOCK;
 
-		lg_dbg("SYNC_LOCK=%x\n", lockStatus);
+		dbg_info("SYNC_LOCK=%x\n", lockStatus);
 		break;
 	}
 	case LG3306_AGC_LOCK:
@@ -1165,7 +1171,7 @@ static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_s
 		else
 			lockStatus = LG3306_UNLOCK;
 
-		lg_dbg("AGC_LOCK=%x\n", lockStatus);
+		dbg_info("AGC_LOCK=%x\n", lockStatus);
 		break;
 	}
 	case LG3306_TR_LOCK:
@@ -1183,7 +1189,7 @@ static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_s
 		} else
 			lockStatus = LG3306_UNKNOWN_LOCK;
 
-		lg_dbg("TR_LOCK=%x\n", lockStatus);
+		dbg_info("TR_LOCK=%x\n", lockStatus);
 		break;
 	}
 	case LG3306_FEC_LOCK:
@@ -1201,13 +1207,13 @@ static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_s
 		} else
 			lockStatus = LG3306_UNKNOWN_LOCK;
 
-		lg_dbg("FEC_LOCK=%x\n", lockStatus);
+		dbg_info("FEC_LOCK=%x\n", lockStatus);
 		break;
 	}
 
 	default:
 		lockStatus = LG3306_UNKNOWN_LOCK;
-		lg_warn("UNKNOWN whatLock=%d\n", whatLock);
+		pr_warn("UNKNOWN whatLock=%d\n", whatLock);
 		break;
 	}
 
@@ -1225,7 +1231,7 @@ static enum lgdt3306a_neverlock_status lgdt3306a_check_neverlock_status(struct l
 		return ret;
 	lockStatus = (enum lgdt3306a_neverlock_status)(val & 0x03);
 
-	lg_dbg("NeverLock=%d", lockStatus);
+	dbg_info("NeverLock=%d", lockStatus);
 
 	return lockStatus;
 }
@@ -1258,7 +1264,7 @@ static int lgdt3306a_pre_monitoring(struct lgdt3306a_state *state)
 		return ret;
 	aiccrejStatus = (val & 0xf0) >> 4;
 
-	lg_dbg("snrRef=%d mainStrong=%d aiccrejStatus=%d currChDiffACQ=0x%x\n",
+	dbg_info("snrRef=%d mainStrong=%d aiccrejStatus=%d currChDiffACQ=0x%x\n",
 		snrRef, mainStrong, aiccrejStatus, currChDiffACQ);
 
 #if 0
@@ -1323,11 +1329,11 @@ static enum lgdt3306a_lock_status lgdt3306a_sync_lock_poll(struct lgdt3306a_stat
 		syncLockStatus = lgdt3306a_check_lock_status(state, LG3306_SYNC_LOCK);
 
 		if (syncLockStatus == LG3306_LOCK) {
-			lg_dbg("locked(%d)\n", i);
+			dbg_info("locked(%d)\n", i);
 			return LG3306_LOCK;
 		}
 	}
-	lg_dbg("not locked\n");
+	dbg_info("not locked\n");
 	return LG3306_UNLOCK;
 }
 
@@ -1342,11 +1348,11 @@ static enum lgdt3306a_lock_status lgdt3306a_fec_lock_poll(struct lgdt3306a_state
 		FECLockStatus = lgdt3306a_check_lock_status(state, LG3306_FEC_LOCK);
 
 		if (FECLockStatus == LG3306_LOCK) {
-			lg_dbg("locked(%d)\n", i);
+			dbg_info("locked(%d)\n", i);
 			return FECLockStatus;
 		}
 	}
-	lg_dbg("not locked\n");
+	dbg_info("not locked\n");
 	return FECLockStatus;
 }
 
@@ -1361,11 +1367,11 @@ static enum lgdt3306a_neverlock_status lgdt3306a_neverlock_poll(struct lgdt3306a
 		NLLockStatus = lgdt3306a_check_neverlock_status(state);
 
 		if (NLLockStatus == LG3306_NL_LOCK) {
-			lg_dbg("NL_LOCK(%d)\n", i);
+			dbg_info("NL_LOCK(%d)\n", i);
 			return NLLockStatus;
 		}
 	}
-	lg_dbg("NLLockStatus=%d\n", NLLockStatus);
+	dbg_info("NLLockStatus=%d\n", NLLockStatus);
 	return NLLockStatus;
 }
 
@@ -1443,7 +1449,7 @@ static u32 lgdt3306a_calculate_snr_x100(struct lgdt3306a_state *state)
 		return 0;
 
 	snr_x100 = log10_x1000((pwr * 10000) / mse) - 3000;
-	lg_dbg("mse=%u, pwr=%u, snr_x100=%d\n", mse, pwr, snr_x100);
+	dbg_info("mse=%u, pwr=%u, snr_x100=%d\n", mse, pwr, snr_x100);
 
 	return snr_x100;
 }
@@ -1457,7 +1463,7 @@ static enum lgdt3306a_lock_status lgdt3306a_vsb_lock_poll(struct lgdt3306a_state
 
 	while (1) {
 		if (lgdt3306a_sync_lock_poll(state) == LG3306_UNLOCK) {
-			lg_dbg("no sync lock!\n");
+			dbg_info("no sync lock!\n");
 			return LG3306_UNLOCK;
 		} else {
 			msleep(20);
@@ -1467,7 +1473,7 @@ static enum lgdt3306a_lock_status lgdt3306a_vsb_lock_poll(struct lgdt3306a_state
 
 			packet_error = lgdt3306a_get_packet_error(state);
 			snr = lgdt3306a_calculate_snr_x100(state);
-			lg_dbg("cnt=%d errors=%d snr=%d\n",
+			dbg_info("cnt=%d errors=%d snr=%d\n",
 			       cnt, packet_error, snr);
 
 			if ((snr < 1500) || (packet_error >= 0xff))
@@ -1476,7 +1482,7 @@ static enum lgdt3306a_lock_status lgdt3306a_vsb_lock_poll(struct lgdt3306a_state
 				return LG3306_LOCK;
 
 			if (cnt >= 10) {
-				lg_dbg("not locked!\n");
+				dbg_info("not locked!\n");
 				return LG3306_UNLOCK;
 			}
 		}
@@ -1492,14 +1498,14 @@ static enum lgdt3306a_lock_status lgdt3306a_qam_lock_poll(struct lgdt3306a_state
 
 	while (1) {
 		if (lgdt3306a_fec_lock_poll(state) == LG3306_UNLOCK) {
-			lg_dbg("no fec lock!\n");
+			dbg_info("no fec lock!\n");
 			return LG3306_UNLOCK;
 		} else {
 			msleep(20);
 
 			packet_error = lgdt3306a_get_packet_error(state);
 			snr = lgdt3306a_calculate_snr_x100(state);
-			lg_dbg("cnt=%d errors=%d snr=%d\n",
+			dbg_info("cnt=%d errors=%d snr=%d\n",
 			       cnt, packet_error, snr);
 
 			if ((snr < 1500) || (packet_error >= 0xff))
@@ -1508,7 +1514,7 @@ static enum lgdt3306a_lock_status lgdt3306a_qam_lock_poll(struct lgdt3306a_state
 				return LG3306_LOCK;
 
 			if (cnt >= 10) {
-				lg_dbg("not locked!\n");
+				dbg_info("not locked!\n");
 				return LG3306_UNLOCK;
 			}
 		}
@@ -1525,9 +1531,9 @@ static int lgdt3306a_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	if (fe->ops.tuner_ops.get_rf_strength) {
 		ret = fe->ops.tuner_ops.get_rf_strength(fe, &strength);
 		if (ret == 0) {
-			lg_dbg("strength=%d\n", strength);
+			dbg_info("strength=%d\n", strength);
 		} else {
-			lg_dbg("fe->ops.tuner_ops.get_rf_strength() failed\n");
+			dbg_info("fe->ops.tuner_ops.get_rf_strength() failed\n");
 		}
 	}
 
@@ -1620,7 +1626,7 @@ static int lgdt3306a_read_signal_strength(struct dvb_frontend *fe,
 		str = (0xffff * str) / 100;
 	}
 	*strength = (u16)str;
-	lg_dbg("strength=%u\n", *strength);
+	dbg_info("strength=%u\n", *strength);
 
 fail:
 	return ret;
@@ -1642,7 +1648,7 @@ static int lgdt3306a_read_ber(struct dvb_frontend *fe, u32 *ber)
 	tmp = (tmp << 8) | read_reg(state, 0x00fe); /* NBERVALUE[8-15] */
 	tmp = (tmp << 8) | read_reg(state, 0x00ff); /* NBERVALUE[0-7] */
 	*ber = tmp;
-	lg_dbg("ber=%u\n", tmp);
+	dbg_info("ber=%u\n", tmp);
 #endif
 	return 0;
 }
@@ -1656,7 +1662,7 @@ static int lgdt3306a_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	/* FGR - BUGBUG - I don't know what value is expected by dvb_core
 	 * what happens when value wraps? */
 	*ucblocks = read_reg(state, 0x00f4); /* TPIFTPERRCNT[0-7] */
-	lg_dbg("ucblocks=%u\n", *ucblocks);
+	dbg_info("ucblocks=%u\n", *ucblocks);
 #endif
 
 	return 0;
@@ -1667,7 +1673,7 @@ static int lgdt3306a_tune(struct dvb_frontend *fe, bool re_tune, unsigned int mo
 	int ret = 0;
 	struct lgdt3306a_state *state = fe->demodulator_priv;
 
-	lg_dbg("re_tune=%u\n", re_tune);
+	dbg_info("re_tune=%u\n", re_tune);
 
 	if (re_tune) {
 		state->current_frequency = -1; /* force re-tune */
@@ -1686,7 +1692,7 @@ static int lgdt3306a_get_tune_settings(struct dvb_frontend *fe,
 				       *fe_tune_settings)
 {
 	fe_tune_settings->min_delay_ms = 100;
-	lg_dbg("\n");
+	dbg_info("\n");
 	return 0;
 }
 
@@ -1702,7 +1708,7 @@ static int lgdt3306a_search(struct dvb_frontend *fe)
 
 	/* wait frontend lock */
 	for (i = 20; i > 0; i--) {
-		lg_dbg(": loop=%d\n", i);
+		dbg_info(": loop=%d\n", i);
 		msleep(50);
 		ret = lgdt3306a_read_status(fe, &status);
 		if (ret)
@@ -1719,7 +1725,7 @@ static int lgdt3306a_search(struct dvb_frontend *fe)
 		return DVBFE_ALGO_SEARCH_AGAIN;
 
 error:
-	lg_dbg("failed (%d)\n", ret);
+	dbg_info("failed (%d)\n", ret);
 	return DVBFE_ALGO_SEARCH_ERROR;
 }
 
@@ -1727,7 +1733,7 @@ static void lgdt3306a_release(struct dvb_frontend *fe)
 {
 	struct lgdt3306a_state *state = fe->demodulator_priv;
 
-	lg_dbg("\n");
+	dbg_info("\n");
 	kfree(state);
 }
 
@@ -1740,7 +1746,7 @@ struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 	int ret;
 	u8 val;
 
-	lg_dbg("(%d-%04x)\n",
+	dbg_info("(%d-%04x)\n",
 	       i2c_adap ? i2c_adapter_id(i2c_adap) : 0,
 	       config ? config->i2c_addr : 0);
 
@@ -1762,7 +1768,7 @@ struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 	if (lg_chkerr(ret))
 		goto fail;
 	if ((val & 0x74) != 0x74) {
-		lg_warn("expected 0x74, got 0x%x\n", (val & 0x74));
+		pr_warn("expected 0x74, got 0x%x\n", (val & 0x74));
 #if 0
 		goto fail;	/* BUGBUG - re-enable when we know this is right */
 #endif
@@ -1771,7 +1777,7 @@ struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 	if (lg_chkerr(ret))
 		goto fail;
 	if ((val & 0xf6) != 0xc6) {
-		lg_warn("expected 0xc6, got 0x%x\n", (val & 0xf6));
+		pr_warn("expected 0xc6, got 0x%x\n", (val & 0xf6));
 #if 0
 		goto fail;	/* BUGBUG - re-enable when we know this is right */
 #endif
@@ -1780,7 +1786,7 @@ struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 	if (lg_chkerr(ret))
 		goto fail;
 	if ((val & 0x73) != 0x03) {
-		lg_warn("expected 0x03, got 0x%x\n", (val & 0x73));
+		pr_warn("expected 0x03, got 0x%x\n", (val & 0x73));
 #if 0
 		goto fail;	/* BUGBUG - re-enable when we know this is right */
 #endif
@@ -1794,7 +1800,7 @@ struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 	return &state->frontend;
 
 fail:
-	lg_warn("unable to detect LGDT3306A hardware\n");
+	pr_warn("unable to detect LGDT3306A hardware\n");
 	kfree(state);
 	return NULL;
 }
@@ -2049,13 +2055,13 @@ static void lgdt3306a_DumpRegs(struct lgdt3306a_state *state)
 		return;
 	debug &= ~DBG_REG; /* suppress DBG_REG during reg dump */
 
-	lg_info("\n");
+	lg_debug("\n");
 
 	for (i = 0; i < numDumpRegs; i++) {
 		lgdt3306a_read_reg(state, regtab[i], &regval1[i]);
 		if (regval1[i] != regval2[i]) {
-			lg_info(" %04X = %02X\n", regtab[i], regval1[i]);
-				regval2[i] = regval1[i];
+			lg_debug(" %04X = %02X\n", regtab[i], regval1[i]);
+				 regval2[i] = regval1[i];
 		}
 	}
 	debug = sav_debug;
-- 
1.9.3


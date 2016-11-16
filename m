Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49696 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753797AbcKPQnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 18/35] [media] dib3000mb: use pr_foo() instead of printk()
Date: Wed, 16 Nov 2016 14:42:50 -0200
Message-Id: <5cd34c6c343794a178f1f14dbb885114159fe2c0.1479314177.git.mchehab@s-opensource.com>
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

The frontend settings also rely on continuation lines. Change
it to avoid the need of adding pr_cont() calls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/dib3000mb.c      | 137 +++++++++++++--------------
 drivers/media/dvb-frontends/dib3000mb_priv.h |  16 ++--
 2 files changed, 71 insertions(+), 82 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib3000mb.c b/drivers/media/dvb-frontends/dib3000mb.c
index 6821ecb53d63..447a709c2002 100644
--- a/drivers/media/dvb-frontends/dib3000mb.c
+++ b/drivers/media/dvb-frontends/dib3000mb.c
@@ -21,6 +21,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -42,13 +44,13 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,2=xfer,4=setfe,8=getfe (|-able)).");
 
-#define deb_info(args...) dprintk(0x01,args)
-#define deb_i2c(args...)  dprintk(0x02,args)
-#define deb_srch(args...) dprintk(0x04,args)
-#define deb_info(args...) dprintk(0x01,args)
-#define deb_xfer(args...) dprintk(0x02,args)
-#define deb_setf(args...) dprintk(0x04,args)
-#define deb_getf(args...) dprintk(0x08,args)
+#define deb_info(args...) dprintk(0x01, args)
+#define deb_i2c(args...)  dprintk(0x02, args)
+#define deb_srch(args...) dprintk(0x04, args)
+#define deb_info(args...) dprintk(0x01, args)
+#define deb_xfer(args...) dprintk(0x02, args)
+#define deb_setf(args...) dprintk(0x04, args)
+#define deb_getf(args...) dprintk(0x08, args)
 
 static int dib3000_read_reg(struct dib3000_state *state, u16 reg)
 {
@@ -126,103 +128,96 @@ static int dib3000mb_set_frontend(struct dvb_frontend *fe, int tuner)
 		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 
-		deb_setf("bandwidth: ");
 		switch (c->bandwidth_hz) {
 			case 8000000:
-				deb_setf("8 MHz\n");
 				wr_foreach(dib3000mb_reg_timing_freq, dib3000mb_timing_freq[2]);
 				wr_foreach(dib3000mb_reg_bandwidth, dib3000mb_bandwidth_8mhz);
 				break;
 			case 7000000:
-				deb_setf("7 MHz\n");
 				wr_foreach(dib3000mb_reg_timing_freq, dib3000mb_timing_freq[1]);
 				wr_foreach(dib3000mb_reg_bandwidth, dib3000mb_bandwidth_7mhz);
 				break;
 			case 6000000:
-				deb_setf("6 MHz\n");
 				wr_foreach(dib3000mb_reg_timing_freq, dib3000mb_timing_freq[0]);
 				wr_foreach(dib3000mb_reg_bandwidth, dib3000mb_bandwidth_6mhz);
 				break;
 			case 0:
 				return -EOPNOTSUPP;
 			default:
-				err("unknown bandwidth value.");
+				pr_err("unknown bandwidth value.\n");
 				return -EINVAL;
 		}
+		deb_setf("bandwidth: %d MHZ\n", c->bandwidth_hz / 1000000);
 	}
 	wr(DIB3000MB_REG_LOCK1_MASK, DIB3000MB_LOCK1_SEARCH_4);
 
-	deb_setf("transmission mode: ");
 	switch (c->transmission_mode) {
 		case TRANSMISSION_MODE_2K:
-			deb_setf("2k\n");
+			deb_setf("transmission mode: 2k\n");
 			wr(DIB3000MB_REG_FFT, DIB3000_TRANSMISSION_MODE_2K);
 			break;
 		case TRANSMISSION_MODE_8K:
-			deb_setf("8k\n");
+			deb_setf("transmission mode: 8k\n");
 			wr(DIB3000MB_REG_FFT, DIB3000_TRANSMISSION_MODE_8K);
 			break;
 		case TRANSMISSION_MODE_AUTO:
-			deb_setf("auto\n");
+			deb_setf("transmission mode: auto\n");
 			break;
 		default:
 			return -EINVAL;
 	}
 
-	deb_setf("guard: ");
 	switch (c->guard_interval) {
 		case GUARD_INTERVAL_1_32:
-			deb_setf("1_32\n");
+			deb_setf("guard 1_32\n");
 			wr(DIB3000MB_REG_GUARD_TIME, DIB3000_GUARD_TIME_1_32);
 			break;
 		case GUARD_INTERVAL_1_16:
-			deb_setf("1_16\n");
+			deb_setf("guard 1_16\n");
 			wr(DIB3000MB_REG_GUARD_TIME, DIB3000_GUARD_TIME_1_16);
 			break;
 		case GUARD_INTERVAL_1_8:
-			deb_setf("1_8\n");
+			deb_setf("guard 1_8\n");
 			wr(DIB3000MB_REG_GUARD_TIME, DIB3000_GUARD_TIME_1_8);
 			break;
 		case GUARD_INTERVAL_1_4:
-			deb_setf("1_4\n");
+			deb_setf("guard 1_4\n");
 			wr(DIB3000MB_REG_GUARD_TIME, DIB3000_GUARD_TIME_1_4);
 			break;
 		case GUARD_INTERVAL_AUTO:
-			deb_setf("auto\n");
+			deb_setf("guard auto\n");
 			break;
 		default:
 			return -EINVAL;
 	}
 
-	deb_setf("inversion: ");
 	switch (c->inversion) {
 		case INVERSION_OFF:
-			deb_setf("off\n");
+			deb_setf("inversion off\n");
 			wr(DIB3000MB_REG_DDS_INV, DIB3000_DDS_INVERSION_OFF);
 			break;
 		case INVERSION_AUTO:
-			deb_setf("auto ");
+			deb_setf("inversion auto\n");
 			break;
 		case INVERSION_ON:
-			deb_setf("on\n");
+			deb_setf("inversion on\n");
 			wr(DIB3000MB_REG_DDS_INV, DIB3000_DDS_INVERSION_ON);
 			break;
 		default:
 			return -EINVAL;
 	}
 
-	deb_setf("modulation: ");
 	switch (c->modulation) {
 		case QPSK:
-			deb_setf("qpsk\n");
+			deb_setf("modulation: qpsk\n");
 			wr(DIB3000MB_REG_QAM, DIB3000_CONSTELLATION_QPSK);
 			break;
 		case QAM_16:
-			deb_setf("qam16\n");
+			deb_setf("modulation: qam16\n");
 			wr(DIB3000MB_REG_QAM, DIB3000_CONSTELLATION_16QAM);
 			break;
 		case QAM_64:
-			deb_setf("qam64\n");
+			deb_setf("modulation: qam64\n");
 			wr(DIB3000MB_REG_QAM, DIB3000_CONSTELLATION_64QAM);
 			break;
 		case QAM_AUTO:
@@ -230,69 +225,64 @@ static int dib3000mb_set_frontend(struct dvb_frontend *fe, int tuner)
 		default:
 			return -EINVAL;
 	}
-	deb_setf("hierarchy: ");
 	switch (c->hierarchy) {
 		case HIERARCHY_NONE:
-			deb_setf("none ");
+			deb_setf("hierarchy: none\n");
 			/* fall through */
 		case HIERARCHY_1:
-			deb_setf("alpha=1\n");
+			deb_setf("hierarchy: alpha=1\n");
 			wr(DIB3000MB_REG_VIT_ALPHA, DIB3000_ALPHA_1);
 			break;
 		case HIERARCHY_2:
-			deb_setf("alpha=2\n");
+			deb_setf("hierarchy: alpha=2\n");
 			wr(DIB3000MB_REG_VIT_ALPHA, DIB3000_ALPHA_2);
 			break;
 		case HIERARCHY_4:
-			deb_setf("alpha=4\n");
+			deb_setf("hierarchy: alpha=4\n");
 			wr(DIB3000MB_REG_VIT_ALPHA, DIB3000_ALPHA_4);
 			break;
 		case HIERARCHY_AUTO:
-			deb_setf("alpha=auto\n");
+			deb_setf("hierarchy: alpha=auto\n");
 			break;
 		default:
 			return -EINVAL;
 	}
 
-	deb_setf("hierarchy: ");
 	if (c->hierarchy == HIERARCHY_NONE) {
-		deb_setf("none\n");
 		wr(DIB3000MB_REG_VIT_HRCH, DIB3000_HRCH_OFF);
 		wr(DIB3000MB_REG_VIT_HP, DIB3000_SELECT_HP);
 		fe_cr = c->code_rate_HP;
 	} else if (c->hierarchy != HIERARCHY_AUTO) {
-		deb_setf("on\n");
 		wr(DIB3000MB_REG_VIT_HRCH, DIB3000_HRCH_ON);
 		wr(DIB3000MB_REG_VIT_HP, DIB3000_SELECT_LP);
 		fe_cr = c->code_rate_LP;
 	}
-	deb_setf("fec: ");
 	switch (fe_cr) {
 		case FEC_1_2:
-			deb_setf("1_2\n");
+			deb_setf("fec: 1_2\n");
 			wr(DIB3000MB_REG_VIT_CODE_RATE, DIB3000_FEC_1_2);
 			break;
 		case FEC_2_3:
-			deb_setf("2_3\n");
+			deb_setf("fec: 2_3\n");
 			wr(DIB3000MB_REG_VIT_CODE_RATE, DIB3000_FEC_2_3);
 			break;
 		case FEC_3_4:
-			deb_setf("3_4\n");
+			deb_setf("fec: 3_4\n");
 			wr(DIB3000MB_REG_VIT_CODE_RATE, DIB3000_FEC_3_4);
 			break;
 		case FEC_5_6:
-			deb_setf("5_6\n");
+			deb_setf("fec: 5_6\n");
 			wr(DIB3000MB_REG_VIT_CODE_RATE, DIB3000_FEC_5_6);
 			break;
 		case FEC_7_8:
-			deb_setf("7_8\n");
+			deb_setf("fec: 7_8\n");
 			wr(DIB3000MB_REG_VIT_CODE_RATE, DIB3000_FEC_7_8);
 			break;
 		case FEC_NONE:
-			deb_setf("none ");
+			deb_setf("fec: none\n");
 			break;
 		case FEC_AUTO:
-			deb_setf("auto\n");
+			deb_setf("fec: auto\n");
 			break;
 		default:
 			return -EINVAL;
@@ -357,7 +347,8 @@ static int dib3000mb_set_frontend(struct dvb_frontend *fe, int tuner)
 					rd(DIB3000MB_REG_LOCK2_VALUE))) < 0 && as_count++ < 100)
 			msleep(1);
 
-		deb_setf("search_state after autosearch %d after %d checks\n",search_state,as_count);
+		deb_setf("search_state after autosearch %d after %d checks\n",
+			 search_state, as_count);
 
 		if (search_state == 1) {
 			if (dib3000mb_get_frontend(fe, c) == 0) {
@@ -464,7 +455,7 @@ static int dib3000mb_get_frontend(struct dvb_frontend* fe,
 		return 0;
 
 	dds_val = ((rd(DIB3000MB_REG_DDS_VALUE_MSB) & 0xff) << 16) + rd(DIB3000MB_REG_DDS_VALUE_LSB);
-	deb_getf("DDS_VAL: %x %x %x",dds_val, rd(DIB3000MB_REG_DDS_VALUE_MSB), rd(DIB3000MB_REG_DDS_VALUE_LSB));
+	deb_getf("DDS_VAL: %x %x %x\n",dds_val, rd(DIB3000MB_REG_DDS_VALUE_MSB), rd(DIB3000MB_REG_DDS_VALUE_LSB));
 	if (dds_val < threshold)
 		inv_test1 = 0;
 	else if (dds_val == threshold)
@@ -473,7 +464,7 @@ static int dib3000mb_get_frontend(struct dvb_frontend* fe,
 		inv_test1 = 2;
 
 	dds_val = ((rd(DIB3000MB_REG_DDS_FREQ_MSB) & 0xff) << 16) + rd(DIB3000MB_REG_DDS_FREQ_LSB);
-	deb_getf("DDS_FREQ: %x %x %x",dds_val, rd(DIB3000MB_REG_DDS_FREQ_MSB), rd(DIB3000MB_REG_DDS_FREQ_LSB));
+	deb_getf("DDS_FREQ: %x %x %x\n",dds_val, rd(DIB3000MB_REG_DDS_FREQ_MSB), rd(DIB3000MB_REG_DDS_FREQ_LSB));
 	if (dds_val < threshold)
 		inv_test2 = 0;
 	else if (dds_val == threshold)
@@ -490,19 +481,19 @@ static int dib3000mb_get_frontend(struct dvb_frontend* fe,
 
 	switch ((tps_val = rd(DIB3000MB_REG_TPS_QAM))) {
 		case DIB3000_CONSTELLATION_QPSK:
-			deb_getf("QPSK ");
+			deb_getf("QPSK\n");
 			c->modulation = QPSK;
 			break;
 		case DIB3000_CONSTELLATION_16QAM:
-			deb_getf("QAM16 ");
+			deb_getf("QAM16\n");
 			c->modulation = QAM_16;
 			break;
 		case DIB3000_CONSTELLATION_64QAM:
-			deb_getf("QAM64 ");
+			deb_getf("QAM64\n");
 			c->modulation = QAM_64;
 			break;
 		default:
-			err("Unexpected constellation returned by TPS (%d)", tps_val);
+			pr_err("Unexpected constellation returned by TPS (%d)\n", tps_val);
 			break;
 	}
 	deb_getf("TPS: %d\n", tps_val);
@@ -513,23 +504,23 @@ static int dib3000mb_get_frontend(struct dvb_frontend* fe,
 		c->code_rate_HP = FEC_NONE;
 		switch ((tps_val = rd(DIB3000MB_REG_TPS_VIT_ALPHA))) {
 			case DIB3000_ALPHA_0:
-				deb_getf("HIERARCHY_NONE ");
+				deb_getf("HIERARCHY_NONE\n");
 				c->hierarchy = HIERARCHY_NONE;
 				break;
 			case DIB3000_ALPHA_1:
-				deb_getf("HIERARCHY_1 ");
+				deb_getf("HIERARCHY_1\n");
 				c->hierarchy = HIERARCHY_1;
 				break;
 			case DIB3000_ALPHA_2:
-				deb_getf("HIERARCHY_2 ");
+				deb_getf("HIERARCHY_2\n");
 				c->hierarchy = HIERARCHY_2;
 				break;
 			case DIB3000_ALPHA_4:
-				deb_getf("HIERARCHY_4 ");
+				deb_getf("HIERARCHY_4\n");
 				c->hierarchy = HIERARCHY_4;
 				break;
 			default:
-				err("Unexpected ALPHA value returned by TPS (%d)", tps_val);
+				pr_err("Unexpected ALPHA value returned by TPS (%d)\n", tps_val);
 				break;
 		}
 		deb_getf("TPS: %d\n", tps_val);
@@ -546,65 +537,65 @@ static int dib3000mb_get_frontend(struct dvb_frontend* fe,
 
 	switch (tps_val) {
 		case DIB3000_FEC_1_2:
-			deb_getf("FEC_1_2 ");
+			deb_getf("FEC_1_2\n");
 			*cr = FEC_1_2;
 			break;
 		case DIB3000_FEC_2_3:
-			deb_getf("FEC_2_3 ");
+			deb_getf("FEC_2_3\n");
 			*cr = FEC_2_3;
 			break;
 		case DIB3000_FEC_3_4:
-			deb_getf("FEC_3_4 ");
+			deb_getf("FEC_3_4\n");
 			*cr = FEC_3_4;
 			break;
 		case DIB3000_FEC_5_6:
-			deb_getf("FEC_5_6 ");
+			deb_getf("FEC_5_6\n");
 			*cr = FEC_4_5;
 			break;
 		case DIB3000_FEC_7_8:
-			deb_getf("FEC_7_8 ");
+			deb_getf("FEC_7_8\n");
 			*cr = FEC_7_8;
 			break;
 		default:
-			err("Unexpected FEC returned by TPS (%d)", tps_val);
+			pr_err("Unexpected FEC returned by TPS (%d)\n", tps_val);
 			break;
 	}
 	deb_getf("TPS: %d\n",tps_val);
 
 	switch ((tps_val = rd(DIB3000MB_REG_TPS_GUARD_TIME))) {
 		case DIB3000_GUARD_TIME_1_32:
-			deb_getf("GUARD_INTERVAL_1_32 ");
+			deb_getf("GUARD_INTERVAL_1_32\n");
 			c->guard_interval = GUARD_INTERVAL_1_32;
 			break;
 		case DIB3000_GUARD_TIME_1_16:
-			deb_getf("GUARD_INTERVAL_1_16 ");
+			deb_getf("GUARD_INTERVAL_1_16\n");
 			c->guard_interval = GUARD_INTERVAL_1_16;
 			break;
 		case DIB3000_GUARD_TIME_1_8:
-			deb_getf("GUARD_INTERVAL_1_8 ");
+			deb_getf("GUARD_INTERVAL_1_8\n");
 			c->guard_interval = GUARD_INTERVAL_1_8;
 			break;
 		case DIB3000_GUARD_TIME_1_4:
-			deb_getf("GUARD_INTERVAL_1_4 ");
+			deb_getf("GUARD_INTERVAL_1_4\n");
 			c->guard_interval = GUARD_INTERVAL_1_4;
 			break;
 		default:
-			err("Unexpected Guard Time returned by TPS (%d)", tps_val);
+			pr_err("Unexpected Guard Time returned by TPS (%d)\n", tps_val);
 			break;
 	}
 	deb_getf("TPS: %d\n", tps_val);
 
 	switch ((tps_val = rd(DIB3000MB_REG_TPS_FFT))) {
 		case DIB3000_TRANSMISSION_MODE_2K:
-			deb_getf("TRANSMISSION_MODE_2K ");
+			deb_getf("TRANSMISSION_MODE_2K\n");
 			c->transmission_mode = TRANSMISSION_MODE_2K;
 			break;
 		case DIB3000_TRANSMISSION_MODE_8K:
-			deb_getf("TRANSMISSION_MODE_8K ");
+			deb_getf("TRANSMISSION_MODE_8K\n");
 			c->transmission_mode = TRANSMISSION_MODE_8K;
 			break;
 		default:
-			err("unexpected transmission mode return by TPS (%d)", tps_val);
+			pr_err("unexpected transmission mode return by TPS (%d)\n", tps_val);
 			break;
 	}
 	deb_getf("TPS: %d\n", tps_val);
diff --git a/drivers/media/dvb-frontends/dib3000mb_priv.h b/drivers/media/dvb-frontends/dib3000mb_priv.h
index 0459d5c84314..b22378cd33d1 100644
--- a/drivers/media/dvb-frontends/dib3000mb_priv.h
+++ b/drivers/media/dvb-frontends/dib3000mb_priv.h
@@ -13,20 +13,15 @@
 #ifndef __DIB3000MB_PRIV_H_INCLUDED__
 #define __DIB3000MB_PRIV_H_INCLUDED__
 
-/* info and err, taken from usb.h, if there is anything available like by default. */
-#define err(format, arg...)  printk(KERN_ERR     "dib3000: " format "\n" , ## arg)
-#define info(format, arg...) printk(KERN_INFO    "dib3000: " format "\n" , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "dib3000: " format "\n" , ## arg)
-
 /* handy shortcuts */
 #define rd(reg) dib3000_read_reg(state,reg)
 
 #define wr(reg,val) if (dib3000_write_reg(state,reg,val)) \
-	{ err("while sending 0x%04x to 0x%04x.",val,reg); return -EREMOTEIO; }
+	{ pr_err("while sending 0x%04x to 0x%04x.",val,reg); return -EREMOTEIO; }
 
 #define wr_foreach(a,v) { int i; \
 	if (sizeof(a) != sizeof(v)) \
-		err("sizeof: %zu %zu is different",sizeof(a),sizeof(v));\
+		pr_err("sizeof: %zu %zu is different",sizeof(a),sizeof(v));\
 	for (i=0; i < sizeof(a)/sizeof(u16); i++) \
 		wr(a[i],v[i]); \
 	}
@@ -37,8 +32,11 @@
 
 /* debug */
 
-#define dprintk(level,args...) \
-    do { if ((debug & level)) { printk(args); } } while (0)
+#define dprintk(level, fmt, arg...) do {				\
+	if (debug & level)						\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__ , ##arg);				\
+} while(0)
 
 /* mask for enabling a specific pid for the pid_filter */
 #define DIB3000_ACTIVATE_PID_FILTERING	(0x2000)
-- 
2.7.4



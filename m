Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JpEV9-0004p5-F6
	for linux-dvb@linuxtv.org; Fri, 25 Apr 2008 05:21:34 +0200
From: Andy Walls <awalls@radix.net>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="=-ObdbzQuxwaR+kuM7Ldb5"
Date: Thu, 24 Apr 2008 23:16:18 -0400
Message-Id: <1209093378.6367.22.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: ivtv-devel@ivtvdriver.org
Subject: [linux-dvb] [PATCH] mxl500x: Add module parameter to enable/disable
	debug	messages
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-ObdbzQuxwaR+kuM7Ldb5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

All,

The attached patch replaces the unconditional printk() messages with
printk() messages that are enabled by a "debug" module parameter.

When using the beta cx18 driver with the HVR-1600, the debug messages
produced by the mxl500x module are excessive, especially when MythTV
goes to fetch EPG data from the ATSC broadcasts. 

I didn't particularly like having to "#ifdef DEBUG" the debug macros,
but that's what Documentation/CodingStyle recommended.

Could you please review and comment?

Thanks,
Andy Walls




--=-ObdbzQuxwaR+kuM7Ldb5
Content-Disposition: attachment; filename=mxl500x-module-debug-param.patch
Content-Type: text/x-patch; name=mxl500x-module-debug-param.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Andy Walls <awalls@radix.net>
# Date 1209092528 14400
# Node ID 979f9052fc7e4df5841244aad0bc0868bfe6c155
# Parent  e6eb3d828145a6df892bf2bc567167f1ee7df528
[PATCH] mxl500x: Add module parameter to enable/disable debug messages

From: Andy Walls <awalls@radix.net>

Replace the unconditional printk() messages with printk() messages that are
enabled/disabled by a "debug" module parameter.

When using the beta cx18 driver with the HVR-1600, the debug messages
produced by the mxl500x module are excessive, especially when an application
like MythTV goes to fetch EPG data from the over the air broadcasts.

The debug macros in the patch were derived from:

linux/drivers/i2c/algos/i2c-algo-bit.c      (C) 1995-2000 Simon G. Vogl
linux/drivers/media/dvb/frontends/bcm3510.c (C) 2001-2005 B2C2 inc.
linux/drivers/media/dvb/frontends/xc5000.c  (C) 2007 Xceive Corp & Steve Toth

Signed-off-by: Andy Walls <awalls@radix.net>

diff -r e6eb3d828145 -r 979f9052fc7e linux/drivers/media/dvb/frontends/mxl500x.c
--- a/linux/drivers/media/dvb/frontends/mxl500x.c	Thu Apr 17 12:19:34 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/mxl500x.c	Thu Apr 24 23:02:08 2008 -0400
@@ -29,6 +29,32 @@
 
 #include "mxl500x.h"
 #include "mxl500x_reg.h"
+
+#ifdef DEBUG
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Set debug level [0-2] (default: 0/off");
+
+#define dprintk(level, fmt, arg...)                                       \
+	do {                                                              \
+		if (debug >= level)                                       \
+			printk(KERN_DEBUG "%s: " fmt, "mxl500x", ## arg); \
+	} while (0)
+
+#define dbufout(level, buf, n)                           \
+	do {                                             \
+		if (debug >= level) {                    \
+			int i;                           \
+			printk(" [");                    \
+			for (i = 0; i < n; i++)          \
+				printk(" %02x", buf[i]); \
+			printk(" ]\n");                  \
+		}                                        \
+	} while (0)
+#else
+#define dprintk(level, fmt, arg...)   do {} while (0)
+#define dbufout(level, buf, n)        do {} while (0)
+#endif
 
 struct mxl500x_reg {
 	u8 reg;
@@ -184,31 +210,27 @@ static int mxl500x_write(struct mxl500x_
 		.buf	= buf,
 		.len	= 2,
 	};
-	int j;
 
 	if (MXL_LATCH == latch)
 		msg.len = 3;
 
 	if (fe->ops.i2c_gate_ctrl) {
-		printk("%s: Enable gate\n", __func__);
+		dprintk(1, "%s: Enable gate\n", __func__);
 		if (fe->ops.i2c_gate_ctrl(fe, 1))
 			goto exit;
 	}
-	printk("tuner access: >> [");
-	for (j = 0; j < msg.len; j++)
-		printk(" %02x", buf[j]);
-
-	printk(" ]\n");
+	dprintk(2, "tuner access: >>");
+	dbufout(2, buf, msg.len);
 	i2c_transfer(state->i2c, &msg, 1);
 	if (fe->ops.i2c_gate_ctrl) {
-		printk("%s: disable gate\n", __func__);
+		dprintk(1, "%s: disable gate\n", __func__);
 		if (fe->ops.i2c_gate_ctrl(fe, 0))
 			goto exit;
 	}
 
 	return 0;
 exit:
-	printk("%s: I/O Error\n", __func__);
+	dprintk(1, "%s: I/O Error\n", __func__);
 	return -EREMOTEIO;
 }
 
@@ -220,7 +242,6 @@ static int mxl500x_write_regs(struct mxl
 	u8 buf[max_regs*2+1];
 	int i;
 	int reg_nr;
-	int j;
 
 	struct dvb_frontend *fe = state->frontend;
 	const struct mxl500x_config *config = state->config;
@@ -233,11 +254,11 @@ static int mxl500x_write_regs(struct mxl
 	};
 
 	if (fe->ops.i2c_gate_ctrl) {
-		printk("%s: Enable gate\n", __func__);
+		dprintk(1, "%s: Enable gate\n", __func__);
 		if (fe->ops.i2c_gate_ctrl(fe, 1))
 			goto exit;
 	}
-	printk("%s: Registers to Write=%d\n", __func__, count);
+	dprintk(1, "%s: Registers to Write=%d\n", __func__, count);
 	/* Look at the regs, copy those regs from the field map to the xfer buffer */
 	reg_nr = 0;
 	for (i = 0; i < count; i++) {
@@ -253,11 +274,8 @@ static int mxl500x_write_regs(struct mxl
 				msg.len++;
 			}
 
-			printk("tuner access: >> [");
-			for (j = 0; j < msg.len; j++)
-				printk(" %02x", buf[j]);
-
-			printk(" ]\n");
+			dprintk(2, "tuner access: >>");
+			dbufout(2, buf, msg.len);
 
 			i2c_transfer(state->i2c, &msg, 1);
 			msleep(1);
@@ -265,14 +283,14 @@ static int mxl500x_write_regs(struct mxl
 		}
 	}
 	if (fe->ops.i2c_gate_ctrl) {
-		printk("%s: Disable gate\n", __func__);
+		dprintk(1, "%s: Disable gate\n", __func__);
 		if (fe->ops.i2c_gate_ctrl(fe, 0))
 			goto exit;
 	}
 
 	return 0;
 exit:
-	printk("%s: I/O Error\n", __func__);
+	dprintk(1, "%s: I/O Error\n", __func__);
 	return -EREMOTEIO;
 }
 
@@ -688,7 +706,7 @@ static int mxl500x_set_params(struct dvb
 	memcpy(state->reg_field, reg_init, sizeof (reg_init));
 
 	/* Step 1: Synthesizer RESET (Single AGC Mode) */
-	printk("%s: Synthesizer RESET and latch\n", __func__);
+	dprintk(1, "%s: Synthesizer RESET and latch\n", __func__);
 	if (mxl500x_write(state, 0x09, 0xb1, MXL_LATCH))  /* master reg, synth reset */
 		goto exit;
 
@@ -719,7 +737,8 @@ static int mxl500x_set_params(struct dvb
 			MXL500x_SET_MAP(MXL500x_LPF1, LPF1_BB_DLPF_BANDSEL, 3);
 			break;
 		default:
-			printk("%s: Invalid Bandwidth mode specified %d\n", __func__, p->u.ofdm.bandwidth);
+			dprintk(1, "%s: Invalid Bandwidth mode specified %d\n",
+				__func__, p->u.ofdm.bandwidth);
 			return -EINVAL;
 		}
 	} else {
@@ -839,13 +858,13 @@ static int mxl500x_set_params(struct dvb
 
 	//11, 12, 13, 22, 43, 44, 53, 56, 59, 73, 76, 77, 91, 134, 135, 137, 147, 156, 166, 167, 168
 	// TODO! write registers (Init regs)
-	printk("%s: Writing Init Regs\n", __func__);
+	dprintk(1, "%s: Writing Init Regs\n", __func__);
 	if (mxl500x_write_regs(state, mxl500x_init_regs, sizeof(mxl500x_init_regs)))
 		goto exit;
 
 	/* Step 3: ZIF Mode */
 	// Synthesizer reset
-	printk("%s: Synthesizer RESET and latch\n", __func__);
+	dprintk(1, "%s: Synthesizer RESET and latch\n", __func__);
 	if (mxl500x_write(state, 0x09, 0xb1, MXL_LATCH))  /* master reg, synth reset, latch */
 		goto exit;
 
@@ -1157,13 +1176,13 @@ static int mxl500x_set_params(struct dvb
 	MXL500x_SET_MAP(MXL500x_MISC_TUNE2, MISC_TUNE2_SEQ_EXTPOWERUP, 1);
 	MXL500x_SET_MAP(MXL500x_IFSYN4, IFSYN4_IF_DIVVAL, 8);
 	// Synthesizer LOAD Start
-//	printk("%s: Synthesizer Load START\n", __func__);
+//	dprintk(1, "%s: Synthesizer Load START\n", __func__);
 //	if (mxl500x_write(state, 0x09, 0xf2, MXL_NO_LATCH)) /* master reg, load start, don't latch */
 //		goto exit;
 	// write all changed regs (change regs)
 	// 14, 15, 16, 17, 22, 43, 68, 69, 70, 73, 92, 93, 106, 107, 108, 109, 110, 111, 112, 136, 138, 149
 	mxl500x_set_reg(state, 0x09, 0xf3);
-	printk("%s: Setup changed registers\n", __func__);
+	dprintk(1, "%s: Setup changed registers\n", __func__);
 	if (mxl500x_write_regs(state, mxl500x_zif_regs, sizeof(mxl500x_zif_regs)))
 		goto exit;
 
@@ -1171,21 +1190,21 @@ static int mxl500x_set_params(struct dvb
 	MXL500x_SET_MAP(MXL500x_MISC_TUNE1, MISC_TUNE1_SEQ_FSM_PULSE, 1);
 	MXL500x_SET_MAP(MXL500x_IFSYN4, IFSYN4_IF_DIVVAL, if_div);
 	// Synthesizer LOAD Start
-//	printk("%s: Synthesizer Load START\n", __func__);
+//	dprintk(1, "%s: Synthesizer Load START\n", __func__);
 //	if (mxl500x_write(state, 0x09, 0xf2, MXL_NO_LATCH)) /* master reg, load start, don't latch */
 //		goto exit;
 	// write regs
 	// 43, 136
-	printk("%s: Tuner go\n", __func__);
+	dprintk(1, "%s: Tuner go\n", __func__);
 	if (mxl500x_write_regs(state, mxl500x_go_regs, sizeof(mxl500x_go_regs)))
 		goto exit;
 
-	printk("%s: Done\n", __func__);
+	dprintk(1, "%s: Done\n", __func__);
 
 	return 0;
 
 exit:
-	printk("%s: I/O error\n", __func__);
+	dprintk(1, "%s: I/O error\n", __func__);
 	return -EIO;
 }
 
@@ -1208,7 +1227,7 @@ struct dvb_frontend *mxl500x_attach(stru
 {
 	struct mxl500x_state *state;
 
-	printk("%s: Attaching ...\n", __func__);
+	dprintk(1, "%s: Attaching ...\n", __func__);
 	if ((state = kzalloc(sizeof (struct mxl500x_state), GFP_KERNEL)) == NULL) {
 		fe = NULL;
 		goto exit;
@@ -1220,11 +1239,11 @@ struct dvb_frontend *mxl500x_attach(stru
 	memcpy(&fe->ops.tuner_ops, &mxl500x_ops, sizeof (struct dvb_tuner_ops));
 	fe->tuner_priv	= state;
 
-	printk("%s: MXL500x tuner succesfully attached\n", __func__);
+	dprintk(1, "%s: MXL500x tuner succesfully attached\n", __func__);
 	return fe;
 
 exit:
-	printk("%s: Error attaching tuner\n", __func__);
+	dprintk(1, "%s: Error attaching tuner\n", __func__);
 	return NULL;
 }
 EXPORT_SYMBOL(mxl500x_attach);

--=-ObdbzQuxwaR+kuM7Ldb5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-ObdbzQuxwaR+kuM7Ldb5--

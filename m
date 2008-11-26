Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQ7kjWQ029729
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 02:46:45 -0500
Received: from smtps.ntu.edu.tw (smtps.ntu.edu.tw [140.112.2.142])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQ7kUc8004721
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 02:46:30 -0500
Date: Wed, 26 Nov 2008 15:46:33 +0800
From: Chia-I Wu <olvaffe@gmail.com>
To: Erik =?iso-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
Message-ID: <20081126074633.GA11305@m500.domain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: [PATCH] gspca-stv06xx: Overhaul the HDCS driver.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Erik,

This patch (against r9689) overhauls HDCS driver and make 046d:0840
work.  Please help review and apply, if it is ok.  Thanks.

-- 
Regards,
olv

--n8g4imXOkfNTN/H1
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: inline; filename="overhaul-the-hdcs-driver.patch"
Content-Transfer-Encoding: 8bit

Overhaul the HDCS driver.

From: Chia-I Wu <olvaffe@gmail.com>

This patch makes the HDCS driver really work, at least with 046d:0840.  For
now, there could only be one such device exist.  The driver reports EBUSY when
a second supported device is inserted.  The restriction could be lifted once
the driver data (struct hcds) could be associated with struct sd.

Priority: normal

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>

diff -r 8b1b8968a794 -r 8ea65863e5b9 linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
--- a/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c	Tue Nov 25 22:19:48 2008 +0100
+++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c	Wed Nov 26 15:36:38 2008 +0800
@@ -3,6 +3,7 @@
  *		      Mark Cave-Ayland, Carlo E Prelz, Dick Streefland
  * Copyright (c) 2002, 2003 Tuukka Toivonen
  * Copyright (c) 2008 Erik Andrén
+ * Copyright (c) 2008 Chia-I Wu
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -29,171 +30,513 @@
 
 #include "stv06xx_hdcs.h"
 
-int hdcs_probe(struct sd *sd)
+#define HDCS_REG_CONFIG(d)	((d)->is_1020 ? HDCS20_CONFIG : HDCS00_CONFIG)
+#define HDCS_REG_CONTROL(d)	((d)->is_1020 ? HDCS20_CONTROL : HDCS00_CONTROL)
+#define to_hdcs(sd) (&_global_hdcs)
+
+enum {
+	HDCS_STATE_SLEEP,
+	HDCS_STATE_IDLE,
+	HDCS_STATE_RUN,
+};
+
+/* no lock? */
+struct hdcs {
+	atomic_t initialized;
+
+	struct sd *sd;
+	char is_1020:1;
+	char is_870:1;
+	int state;
+	int w, h;
+
+	/* visible area of the sensor array */
+	struct {
+		int left, top;
+		int width, height;
+		int border;
+	} array;
+
+	/* non-zero imples the border area is invalid */
+	int y_skip_bottom;
+
+	int hz;
+	int psmp;
+	int astrt;
+};
+
+/* XXX make this per-sensor data */
+static struct hdcs _global_hdcs;
+
+static int hdcs_bridge_write(struct hdcs *hdcs, u16 reg, u16 val)
 {
+	PDEBUG(D_USBO, "set bridget 0x%02x to 0x%02x", reg, val);
+
+	return stv06xx_write_bridge(hdcs->sd, reg, val);
+}
+
+static int hdcs_reg_write_seq(struct hdcs *hdcs, u8 reg, u8 *vals, int len)
+{
+	u8 regs[I2C_MAX_COMMANDS];
+	int ret, i;
+
+	if (unlikely(len < 0 || len >= I2C_MAX_COMMANDS ||
+				reg + len * 2 > 0xff))
+		return -EINVAL;
+
+	if (!len)
+		return 0;
+
+	for (i = 0; i < len; i++) {
+		PDEBUG(D_USBO, "seq-set reg 0x%02x to 0x%02x",
+				reg, vals[i]);
+
+		regs[i] = reg;
+		reg += 2;
+	}
+
+	ret = stv06xx_write_sensor(hdcs->sd, regs, vals, len);
+	if (ret)
+		err("seq-set reg 0x%02x of length %d failed: %d",
+				regs[0], len, ret);
+
+	return ret;
+}
+
+static int hdcs_reg_write(struct hdcs *hdcs, u8 reg, u8 val)
+{
+	PDEBUG(D_USBO, "set reg 0x%02x to 0x%02x", reg, val);
+
+	return stv06xx_write_sensor(hdcs->sd, &reg, &val, 1);
+}
+
+static int hdcs_reg_read(struct hdcs *hdcs, u8 reg)
+{
+	u8 val;
+	int ret;
+
+	ret = stv06xx_read_sensor(hdcs->sd, &reg, &val, 1);
+	if (ret > 0)
+		ret = -EINVAL;
+
+	return (ret) ? ret : val;
+}
+
+static int hdcs_set_state(struct hdcs *hdcs, int state)
+{
+	u8 val;
+	int ret;
+
+	if (hdcs->state == state)
+		return 0;
+
+	/* we need to go idle before running or sleeping */
+	if (hdcs->state != HDCS_STATE_IDLE) {
+		ret = hdcs_reg_write(hdcs, HDCS_REG_CONTROL(hdcs), 0);
+		if (ret)
+			return ret;
+	}
+
+	hdcs->state = HDCS_STATE_IDLE;
+
+	if (state == HDCS_STATE_IDLE)
+		return 0;
+
+	switch (state) {
+	case HDCS_STATE_SLEEP:
+		val = HDCS_SLEEP_MODE;
+		break;
+	case HDCS_STATE_RUN:
+		val = HDCS_RUN_ENABLE;
+		break;
+	default:
+		return -EINVAL;
+		break;
+	}
+
+	ret = hdcs_reg_write(hdcs, HDCS_REG_CONTROL(hdcs), val);
+	if (!ret)
+		hdcs->state = state;
+
+	return ret;
+}
+
+static int hdcs_reset(struct hdcs *hdcs)
+{
+	int ret;
+
+	ret = hdcs_reg_write(hdcs, HDCS_REG_CONTROL(hdcs), 1);
+	if (ret)
+		return ret;
+
+	ret = hdcs_reg_write(hdcs, HDCS_REG_CONTROL(hdcs), 0);
+	if (!ret)
+		hdcs->state = HDCS_STATE_IDLE;
+
+	return ret;
+}
+
+static int hdcs_set_exposure(struct hdcs *hdcs, unsigned int us)
+{
+	int rowexp, srowexp;
+	int max_srowexp;
+	int ct, cp, rp, mnct;
+	int cto, cpo, rs, er;
+	int cycles;
+	int ret;
+	u8 exp[4];
+
+	cycles = us * (hdcs->hz / 1000 / 1000);
+
+	if (hdcs->is_1020) {
+		cto = 3;
+		cpo = 3;
+		rs = 155;
+		er = 96;
+	} else {
+		cto = 4;
+		cpo = 2;
+		rs = 186;
+		er = 100;
+	}
+
+	ct = cto + hdcs->psmp + (hdcs->astrt + 2);
+	cp = cpo + (hdcs->w * ct / 2);
+
+	/* the cycles one row takes */
+	rp = rs + cp;
+
+	rowexp = cycles / rp;
+
+	/* the remaining cycles */
+	cycles -= rowexp * rp;
+
+	/* calculate sub-row exposure */
+	if (hdcs->is_1020) {
+		/* see 3.5.6.4, p. 63 */
+		srowexp = hdcs->w - (cycles + er + 13) / ct;
+
+		mnct = (er + 12 + ct - 1) / ct;
+		max_srowexp = hdcs->w - mnct;
+	} else {
+		/* see 3.4.5.5, p. 61 */
+		srowexp = cp - er - 6 - cycles;
+
+		mnct = (er + 5 + ct - 1) / ct;
+		max_srowexp = cp - mnct * ct - 1;
+	}
+
+	if (srowexp < 0)
+		srowexp = 0;
+	else if (srowexp > max_srowexp)
+		srowexp = max_srowexp;
+
+	if (hdcs->is_1020) {
+		exp[0] = rowexp & 0xff;
+		exp[1] = rowexp >> 8;
+		exp[2] = (srowexp >> 2) & 0xff;
+
+		/* this clears exposure error flag */
+		exp[3] = 0x1;
+
+		ret = hdcs_reg_write_seq(hdcs, HDCS_ROWEXPL, exp, 4);
+	} else {
+		exp[0] = rowexp & 0xff;
+		exp[1] = rowexp >> 8;
+		exp[2] = srowexp & 0xff;
+		exp[3] = srowexp >> 8;
+
+		ret = hdcs_reg_write_seq(hdcs, HDCS_ROWEXPL, exp, 4);
+
+		/* clear exposure error flag */
+		if (!ret)
+			ret = hdcs_reg_write(hdcs, HDCS_STATUS, BIT(4));
+	}
+
+	return ret;
+}
+
+static int hdcs_set_gains(struct hdcs *hdcs, u8 r, u8 g, u8 b)
+{
+	u8 gains[4];
+
+	/* the voltage gain Av = (1 + 19 * val / 127) * (1 + bit7) */
+
+	if (r > 127)
+		r = 0x80 | (r / 2);
+	if (g > 127)
+		g = 0x80 | (g / 2);
+	if (b > 127)
+		b = 0x80 | (b / 2);
+
+	gains[0] = g;
+	gains[1] = r;
+	gains[2] = b;
+	gains[3] = g;
+
+	return hdcs_reg_write_seq(hdcs, HDCS_ERECPGA, gains, 4);
+}
+
+static int hdcs_set_size(struct hdcs *hdcs,
+		unsigned int width, unsigned int height)
+{
+	u8 win[4];
+	unsigned int x, y;
+	int ret;
+
+	/* must be multiple of 4 */
+	width = (width + 3) & ~0x3;
+	height = (height + 3) & ~0x3;
+
+	if (width > hdcs->array.width)
+		width = hdcs->array.width;
+
+	if (hdcs->y_skip_bottom) {
+		/* the borders are also invalid */
+		if (height + 2 * hdcs->array.border +
+				hdcs->y_skip_bottom > hdcs->array.height)
+			height = hdcs->array.height - 2 * hdcs->array.border -
+				hdcs->y_skip_bottom;
+	} else if (height > hdcs->array.height) {
+		height = hdcs->array.height;
+	}
+
+	x = hdcs->array.left + (hdcs->array.width - width) / 2;
+	y = hdcs->array.top +
+		(hdcs->array.height - hdcs->y_skip_bottom - height) / 2;
+
+	win[0] = y / 4;
+	win[1] = x / 4;
+	win[2] = (y + height) / 4 - 1;
+	win[3] = (x + width) / 4 - 1;
+
+	ret = hdcs_reg_write_seq(hdcs, HDCS_FWROW, win, 4);
+	if (ret == 0) {
+		hdcs->w = width;
+		hdcs->h = height;
+	}
+
+	return ret;
+}
+
+int hdcs_probe_1x00(struct sd *sd)
+{
+	struct hdcs *hdcs;
 	u8 sensor;
-	int err;
+	int ret;
 
-	err = stv06xx_read_sensor_b(sd, HDCS_IDENT, &sensor);
-
-	if (err < 0)
+	ret = stv06xx_read_sensor_b(sd, HDCS_IDENT, &sensor);
+	if (ret < 0 || sensor != 0x08)
 		return -ENODEV;
 
-	if ((sensor == 0x08) && (sd->sensor == &stv06xx_sensor_hdcs1x00)) {
-		info("HDCS-1000/1100 sensor detected");
+	if (atomic_read(&_global_hdcs.initialized))
+		return -EBUSY;
+	atomic_inc(&_global_hdcs.initialized);
 
-		sd->gspca_dev.cam.cam_mode = stv06xx_sensor_hdcs1x00.modes;
-		sd->gspca_dev.cam.nmodes = stv06xx_sensor_hdcs1x00.nmodes;
-		sd->desc->ctrls = stv06xx_sensor_hdcs1x00.ctrls;
-		sd->desc->nctrls = stv06xx_sensor_hdcs1x00.nctrls;
-		return 0;
-	}
+	hdcs = &_global_hdcs;
 
-	if ((sensor == 0x10) && (sd->sensor == &stv06xx_sensor_hdcs1020)) {
-		info("HDCS-1020 sensor detected");
+	info("HDCS-1000/1100 sensor detected");
 
-		sd->gspca_dev.cam.cam_mode = stv06xx_sensor_hdcs1020.modes;
-		sd->gspca_dev.cam.nmodes = stv06xx_sensor_hdcs1020.nmodes;
-		sd->desc->ctrls = stv06xx_sensor_hdcs1020.ctrls;
-		sd->desc->nctrls = stv06xx_sensor_hdcs1020.nctrls;
-		return 0;
-	}
+	sd->gspca_dev.cam.cam_mode = stv06xx_sensor_hdcs1x00.modes;
+	sd->gspca_dev.cam.nmodes = stv06xx_sensor_hdcs1x00.nmodes;
+	sd->desc->ctrls = stv06xx_sensor_hdcs1x00.ctrls;
+	sd->desc->nctrls = stv06xx_sensor_hdcs1x00.nctrls;
 
-	return -ENODEV;
+	hdcs->sd = sd;
+
+	hdcs->is_1020 = 0;
+	hdcs->is_870 = (sd->gspca_dev.dev->descriptor.idProduct == 0x870);
+
+	hdcs->array.left = 8;
+	hdcs->array.top  = 8;
+	hdcs->array.width = 360;
+	hdcs->array.height = 296;
+	hdcs->array.border = 4;
+
+	hdcs->y_skip_bottom = 0;
+
+	hdcs->hz = 25 * 1000 * 1000;
+
+	/* 0..3, doesn't seem to have any effect */
+	/* Smaller is slower with subsampling */
+	hdcs->astrt = 3;
+
+	/*
+	 * Frame rate on HDCS-1000 0x46D:0x840 depending on PSMP:
+	 *  4 = doesn't work at all
+	 *  5 = 7.8 fps,
+	 *  6 = 6.9 fps,
+	 *  8 = 6.3 fps,
+	 * 10 = 5.5 fps,
+	 * 15 = 4.4 fps,
+	 * 31 = 2.8 fps
+	 *
+	 * Frame rate on HDCS-1000 0x46D:0x870 depending on PSMP:
+	 * 15 = doesn't work at all
+	 * 18 = doesn't work at all
+	 * 19 = 7.3 fps
+	 * 20 = 7.4 fps
+	 * 21 = 7.4 fps
+	 * 22 = 7.4 fps
+	 * 24 = 6.3 fps
+	 * 30 = 5.4 fps
+	 */
+	hdcs->psmp = hdcs->is_870 ? 20 : 5;
+
+	return 0;
+}
+
+int hdcs_probe_1020(struct sd *sd)
+{
+	struct hdcs *hdcs;
+	u8 sensor;
+	int ret;
+
+	ret = stv06xx_read_sensor_b(sd, HDCS_IDENT, &sensor);
+	if (ret < 0 || sensor != 0x10)
+		return -ENODEV;
+
+	if (atomic_read(&_global_hdcs.initialized))
+		return -EBUSY;
+	atomic_inc(&_global_hdcs.initialized);
+
+	hdcs = &_global_hdcs;
+
+	info("HDCS-1020 sensor detected");
+	warn("This driver is untested");
+
+	sd->gspca_dev.cam.cam_mode = stv06xx_sensor_hdcs1020.modes;
+	sd->gspca_dev.cam.nmodes = stv06xx_sensor_hdcs1020.nmodes;
+	sd->desc->ctrls = stv06xx_sensor_hdcs1020.ctrls;
+	sd->desc->nctrls = stv06xx_sensor_hdcs1020.nctrls;
+
+	hdcs->sd = sd;
+
+	hdcs->is_1020 = 1;
+	hdcs->is_870 = (sd->gspca_dev.dev->descriptor.idProduct == 0x870);
+
+	/*
+	 * From Andrey's test image: looks like HDCS-1020 upper-left
+	 * visible pixel is at 24,8 (y maybe even smaller?) and lower-right
+	 * visible pixel at 375,299 (x maybe even larger?)
+	 */
+	hdcs->array.left = 24;
+	hdcs->array.top  = 4;
+	hdcs->array.width = 352;
+	hdcs->array.height = 304;
+	hdcs->array.border = 4;
+
+	hdcs->y_skip_bottom = 4;
+
+	hdcs->hz = 25 * 1000 * 1000;
+
+	hdcs->astrt = 3;
+	hdcs->psmp = 6;
+
+	return 0;
 }
 
 int hdcs_start(struct sd *sd)
 {
-	int err = stv06xx_write_sensor_b(sd, GET_CONTROL, HDCS_RUN_ENABLE);
+	struct hdcs *hdcs = to_hdcs(sd);
+
 	PDEBUG(D_STREAM, "Starting stream");
-	return (err < 0) ? err : 0;
+
+	return hdcs_set_state(hdcs, HDCS_STATE_RUN);
 }
 
 int hdcs_stop(struct sd *sd)
 {
-	int err = stv06xx_write_sensor_b(sd, GET_CONTROL, HDCS_SLEEP_MODE);
+	struct hdcs *hdcs = to_hdcs(sd);
+
 	PDEBUG(D_STREAM, "Halting stream");
-	return (err < 0) ? err : 0;
+
+	return hdcs_set_state(hdcs, HDCS_STATE_SLEEP);
 }
 
-/* FIXME: This function is quite dirty at the moment,
-	  the first stage is to verify that it works on a sensor.
-	  Cleanup will come later */
 /* FIXME: No errors are caught, add this later as we roll up the
 	  initialization using a command buffer */
 int hdcs_init(struct sd *sd)
 {
-	int tctrl, astrt, psmp;
+	struct hdcs *hdcs = to_hdcs(sd);
+	int tctrl;
 
-	stv06xx_write_bridge(sd, STV_REG23, 0);
+	hdcs_bridge_write(hdcs, STV_ISO_ENABLE, 0);
+	hdcs_bridge_write(hdcs, STV_REG23, 0);
 
 	/* Set the STV0602AA in STV0600 emulation mode */
-	if (IS_870(sd))
-		stv06xx_write_bridge(sd, STV_STV0600_EMULATION, 1);
+	if (hdcs->is_870)
+		hdcs_bridge_write(hdcs, STV_STV0600_EMULATION, 1);
 
-	/* Reset the image sensor (keeping it to 1 is a problem) */
-	stv06xx_write_sensor_b(sd, GET_CONTROL, 1);
-	stv06xx_write_sensor_b(sd, GET_CONTROL, 0);
+	/* soft reset */
+	hdcs_reset(hdcs);
 
 	/* Clear status (writing 1 will clear the corresponding status bit) */
-	stv06xx_write_sensor_b(sd, HDCS_STATUS, BIT(6)|BIT(5)|BIT(4)|
+	hdcs_reg_write(hdcs, HDCS_STATUS, BIT(6)|BIT(5)|BIT(4)|
 						BIT(3)|BIT(2)|BIT(1));
 	/* Disable all interrupts */
-	stv06xx_write_sensor_b(sd, HDCS_IMASK, 0x00);
+	hdcs_reg_write(hdcs, HDCS_IMASK, 0x00);
 
-	stv06xx_write_bridge(sd, STV_REG00, 0x1d);
-	stv06xx_write_bridge(sd, STV_REG04, 0x07);
-	stv06xx_write_bridge(sd, STV_REG03, 0x95);
+	hdcs_bridge_write(hdcs, STV_REG00, 0x1d);
+	hdcs_bridge_write(hdcs, STV_REG04, 0x07);
+	hdcs_bridge_write(hdcs, STV_REG03, 0x95);
 
-	stv06xx_write_bridge(sd, STV_REG23, 0);
+	hdcs_bridge_write(hdcs, STV_REG23, 0);
 
 	/* Larger -> slower */
-	stv06xx_write_bridge(sd, STV_SCAN_RATE, 0x20);
+	hdcs_bridge_write(hdcs, STV_SCAN_RATE, 0x20);
 
 	/* ISO-Size, 0x34F = 847 .. 0x284 = 644 */
-	stv06xx_write_bridge(sd, STV_ISO_SIZE_L, 847);
+	hdcs_bridge_write(hdcs, STV_ISO_SIZE_L, 847);
 
 	/* Set mode */
 	/* 0x02: half, 0x01: full */
-	stv06xx_write_bridge(sd, STV_Y_CTRL, 0x01);
+	hdcs_bridge_write(hdcs, STV_Y_CTRL, 0x01);
 	/* 0x06: half, 0x0A: full */
-	stv06xx_write_bridge(sd, STV_X_CTRL, 0x0a);
+	hdcs_bridge_write(hdcs, STV_X_CTRL, 0x0a);
 
-	/* These are not good final values, which will be set in set_size */
-	stv06xx_write_sensor_b(sd, HDCS_FWROW, 0);	/* Start at row 0 */
-	stv06xx_write_sensor_b(sd, HDCS_FWCOL, 0);	/* Start at column 0 */
-	stv06xx_write_sensor_b(sd, HDCS_LWROW, 0x47);	/* End at row 288 */
-	stv06xx_write_sensor_b(sd, HDCS_LWCOL, 0x57);	/* End at column 352 */
+	hdcs_set_size(hdcs, hdcs->array.width, hdcs->array.height);
 
-	/* 0x07 - 0x50 */
-	/* 0..3, doesn't seem to have any effect */
-	/* Smaller is slower with subsampling */
-	astrt = 3;
-	if (!IS_1020(sd)) {
-		/* HDCS-1000 (tctrl was 0x09,
-		   but caused some HDCS-1000 not to work) */
-		/* Frame rate on HDCS-1000 0x46D:0x840 depending on PSMP:
-		*  4 = doesn't work at all
-		*  5 = 7.8 fps,
-		*  6 = 6.9 fps,
-		*  8 = 6.3 fps,
-		* 10 = 5.5 fps,
-		* 15 = 4.4 fps,
-		* 31 = 2.8 fps */
-		/* Frame rate on HDCS-1000 0x46D:0x870 depending on PSMP:
-		* 15 = doesn't work at all
-		* 18 = doesn't work at all
-		* 19 = 7.3 fps
-		* 20 = 7.4 fps
-		* 21 = 7.4 fps
-		* 22 = 7.4 fps
-		* 24 = 6.3 fps
-		* 30 = 5.4 fps */
-		/* 4..31 (was 30, changed to 20) */
-		psmp = IS_870(sd) ? 20 : 5;
-		tctrl = (astrt << 5) | psmp;
-	} else {
-		/* HDCS-1020 (tctrl was 0x7E,
-		   but causes slow frame rate on HDCS-1020) */
-		/* Changed to 6 which should give 8.1 fps */
-		psmp = 6;	/* 4..31 (was 9, changed to 6 to improve fps */
-		tctrl = (astrt << 6) | psmp;
-	}
 	/* Set PGA sample duration
 	   (was 0x7E for IS_870, but caused slow framerate with HDCS-1020) */
-	stv06xx_write_sensor_b(sd, HDCS_TCTRL, tctrl);
+	if (hdcs->is_1020)
+		tctrl = (hdcs->astrt << 6) | hdcs->psmp;
+	else
+		tctrl = (hdcs->astrt << 5) | hdcs->psmp;
+	hdcs_reg_write(hdcs, HDCS_TCTRL, tctrl);
 
-	/* FIXME:should not be anymore necessary (already done) */
-	stv06xx_write_sensor_b(sd, GET_CONTROL, 0);
+	hdcs_set_gains(hdcs, 128, 128, 128);
+	hdcs_set_exposure(hdcs, 5000);
 
-	stv06xx_write_sensor_b(sd, HDCS_ROWEXPL, 0);
-	stv06xx_write_sensor_b(sd, HDCS_ROWEXPH, 0);
-	if (IS_1020(sd)) {
-		stv06xx_write_sensor_b(sd, HDCS20_SROWEXP, 0);
-		/* Clear error conditions by writing 1 */
-		stv06xx_write_sensor_b(sd, HDCS20_ERROR, BIT(0)|BIT(2));
-	} else {
-		stv06xx_write_sensor_b(sd, HDCS00_SROWEXPL, 0);
-		stv06xx_write_sensor_b(sd, HDCS00_SROWEXPH, 0);
-	}
+	hdcs_bridge_write(hdcs, STV_REG01, 0xb5);
+	hdcs_bridge_write(hdcs, STV_REG02, 0xa8);
 
-	stv06xx_write_bridge(sd, STV_REG01, 0xb5);
-	stv06xx_write_bridge(sd, STV_REG02, 0xa8);
-
-	stv06xx_write_sensor_b(sd, HDCS_PCTRL, BIT(6)|BIT(5)|BIT(1)|BIT(0));
-	stv06xx_write_sensor_b(sd, HDCS_PDRV,  0x00);
-	stv06xx_write_sensor_b(sd, HDCS_ICTRL, BIT(5));
-	stv06xx_write_sensor_b(sd, HDCS_ITMG,  BIT(4)|BIT(1));
+	hdcs_reg_write(hdcs, HDCS_PCTRL, BIT(6)|BIT(5)|BIT(1)|BIT(0));
+	hdcs_reg_write(hdcs, HDCS_PDRV,  0x00);
+	hdcs_reg_write(hdcs, HDCS_ICTRL, BIT(5));
+	hdcs_reg_write(hdcs, HDCS_ITMG,  BIT(4)|BIT(1));
 
 	/* CONFIG: Bit 3: continous frame capture,
 	   bit 2: stop when frame complete */
-	stv06xx_write_sensor_b(sd, GET_CONFIG, BIT(3));
+	hdcs_reg_write(hdcs, HDCS_REG_CONFIG(hdcs), BIT(3));
 	/* ADC output resolution to 10 bits */
-	stv06xx_write_sensor_b(sd, HDCS_ADCCTRL, 10);
+	hdcs_reg_write(hdcs, HDCS_ADCCTRL, 10);
+
 	return 0;
 }
 
 int hdcs_dump(struct sd *sd)
 {
+	struct hdcs *hdcs = to_hdcs(sd);
+	int reg, val;
+
+	info("Dumping sensor registers:");
+
+	for (reg = HDCS_IDENT; reg <= HDCS_ROWEXPH; reg += 2) {
+		val = hdcs_reg_read(hdcs, reg);
+
+		info("reg 0x%02x = 0x%02x", reg, val);
+	}
+
 	return 0;
 }
diff -r 8b1b8968a794 -r 8ea65863e5b9 linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
--- a/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h	Tue Nov 25 22:19:48 2008 +0100
+++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h	Wed Nov 26 15:36:38 2008 +0800
@@ -3,6 +3,7 @@
  *		      Mark Cave-Ayland, Carlo E Prelz, Dick Streefland
  * Copyright (c) 2002, 2003 Tuukka Toivonen
  * Copyright (c) 2008 Erik Andrén
+ * Copyright (c) 2008 Chia-I Wu
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -117,10 +118,8 @@
 #define HDCS_RUN_ENABLE		(1 << 2)
 #define HDCS_SLEEP_MODE		(1 << 1)
 
-#define GET_CONTROL	(IS_1020(sd) ? HDCS20_CONTROL : HDCS00_CONTROL)
-#define GET_CONFIG	(IS_1020(sd) ? HDCS20_CONFIG : HDCS00_CONFIG)
-
-int hdcs_probe(struct sd *sd);
+int hdcs_probe_1x00(struct sd *sd);
+int hdcs_probe_1020(struct sd *sd);
 int hdcs_start(struct sd *sd);
 int hdcs_init(struct sd *sd);
 int hdcs_stop(struct sd *sd);
@@ -133,7 +132,7 @@
 	.i2c_len = 1,
 
 	.init = hdcs_init,
-	.probe = hdcs_probe,
+	.probe = hdcs_probe_1x00,
 	.start = hdcs_start,
 	.stop = hdcs_stop,
 	.dump = hdcs_dump,
@@ -167,7 +166,7 @@
 	.ctrls = {},
 
 	.init = hdcs_init,
-	.probe = hdcs_probe,
+	.probe = hdcs_probe_1020,
 	.start = hdcs_start,
 	.stop = hdcs_stop,
 	.dump = hdcs_dump,

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--n8g4imXOkfNTN/H1--

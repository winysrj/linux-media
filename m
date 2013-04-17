Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab3DQAnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:43:03 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0h2SF024317
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:43:03 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 21/31] [media] r820t: add IMR calibrate code
Date: Tue, 16 Apr 2013 21:42:32 -0300
Message-Id: <1366159362-3773-22-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code seems to calibrate I/Q phase and gain during the
device initialization.
This is done only once, and it doesn't seem to be needed to
happen after resuming.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 702 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 681 insertions(+), 21 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 07d0323..fa2e9ae 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -47,6 +47,8 @@
  */
 #define REG_SHADOW_START	5
 #define NUM_REGS		27
+#define NUM_IMR			5
+#define IMR_TRIAL		9
 
 #define VER_NUM  49
 
@@ -66,6 +68,12 @@ enum xtal_cap_value {
 	XTAL_HIGH_CAP_0P
 };
 
+struct r820t_sect_type {
+	u8	phase_y;
+	u8	gain_x;
+	u16	value;
+};
+
 struct r820t_priv {
 	struct list_head		hybrid_tuner_instance_list;
 	const struct r820t_config	*cfg;
@@ -80,6 +88,8 @@ struct r820t_priv {
 	u8				fil_cal_code;
 	bool				imr_done;
 
+	struct r820t_sect_type		imr_data[NUM_IMR];
+
 	/* Store current mode */
 	u32				delsys;
 	enum v4l2_tuner_type		type;
@@ -459,7 +469,7 @@ static int r820t_set_mux(struct r820t_priv *priv, u32 freq)
 {
 	const struct r820t_freq_range *range;
 	int i, rc;
-	u8 val;
+	u8 val, reg08, reg09;
 
 	/* Get the proper frequency range */
 	freq = freq / 1000000;
@@ -507,17 +517,18 @@ static int r820t_set_mux(struct r820t_priv *priv, u32 freq)
 	if (rc < 0)
 		return rc;
 
-	/*
-	 * FIXME: the original driver has a logic there with preserves
-	 * gain/phase from registers 8 and 9 reading the data from the
-	 * registers before writing, if "IMF done". That code was sort of
-	 * commented there, as the flag is always false.
-	 */
-	rc = r820t_write_reg_mask(priv, 0x08, 0, 0x3f);
+	if (priv->imr_done) {
+		reg08 = priv->imr_data[range->imr_mem].gain_x;
+		reg09 = priv->imr_data[range->imr_mem].phase_y;
+	} else {
+		reg08 = 0;
+		reg09 = 0;
+	}
+	rc = r820t_write_reg_mask(priv, 0x08, reg08, 0x3f);
 	if (rc < 0)
 		return rc;
 
-	rc = r820t_write_reg_mask(priv, 0x09, 0, 0x3f);
+	rc = r820t_write_reg_mask(priv, 0x09, reg09, 0x3f);
 
 	return rc;
 }
@@ -1383,24 +1394,621 @@ static int r820t_xtal_check(struct r820t_priv *priv)
 	return r820t_xtal_capacitor[i][1];
 }
 
-/*
- *  r820t frontend operations and tuner attach code
- *
- * All driver locks and i2c control are only in this part of the code
- */
+static int r820t_imr_prepare(struct r820t_priv *priv)
+{
+	int rc;
 
-static int r820t_init(struct dvb_frontend *fe)
+	/* Initialize the shadow registers */
+	memcpy(priv->regs, r820t_init_array, sizeof(r820t_init_array));
+
+	/* lna off (air-in off) */
+	rc = r820t_write_reg_mask(priv, 0x05, 0x20, 0x20);
+	if (rc < 0)
+		return rc;
+
+	/* mixer gain mode = manual */
+	rc = r820t_write_reg_mask(priv, 0x07, 0, 0x10);
+	if (rc < 0)
+		return rc;
+
+	/* filter corner = lowest */
+	rc = r820t_write_reg_mask(priv, 0x0a, 0x0f, 0x0f);
+	if (rc < 0)
+		return rc;
+
+	/* filter bw=+2cap, hp=5M */
+	rc = r820t_write_reg_mask(priv, 0x0b, 0x60, 0x6f);
+	if (rc < 0)
+		return rc;
+
+	/* adc=on, vga code mode, gain = 26.5dB   */
+	rc = r820t_write_reg_mask(priv, 0x0c, 0x0b, 0x9f);
+	if (rc < 0)
+		return rc;
+
+	/* ring clk = on */
+	rc = r820t_write_reg_mask(priv, 0x0f, 0, 0x08);
+	if (rc < 0)
+		return rc;
+
+	/* ring power = on */
+	rc = r820t_write_reg_mask(priv, 0x18, 0x10, 0x10);
+	if (rc < 0)
+		return rc;
+
+	/* from ring = ring pll in */
+	rc = r820t_write_reg_mask(priv, 0x1c, 0x02, 0x02);
+	if (rc < 0)
+		return rc;
+
+	/* sw_pdect = det3 */
+	rc = r820t_write_reg_mask(priv, 0x1e, 0x80, 0x80);
+	if (rc < 0)
+		return rc;
+
+	/* Set filt_3dB */
+	rc = r820t_write_reg_mask(priv, 0x06, 0x20, 0x20);
+
+	return rc;
+}
+
+static int r820t_multi_read(struct r820t_priv *priv)
+{
+	int rc, i;
+	u8 data[2], min = 0, max = 255, sum = 0;
+
+	usleep_range(5000, 6000);
+
+	for (i = 0; i < 6; i++) {
+		rc = r820t_read(priv, 0x00, data, sizeof(data));
+		if (rc < 0)
+			return rc;
+
+		sum += data[1];
+
+		if (data[1] < min)
+			min = data[1];
+
+		if (data[1] > max)
+			max = data[1];
+	}
+	rc = sum - max - min;
+
+	return rc;
+}
+
+static int r820t_imr_cross(struct r820t_priv *priv,
+			   struct r820t_sect_type iq_point[3],
+			   u8 *x_direct)
+{
+	struct r820t_sect_type cross[5]; /* (0,0)(0,Q-1)(0,I-1)(Q-1,0)(I-1,0) */
+	struct r820t_sect_type tmp;
+	int i, rc;
+	u8 reg08, reg09;
+
+	reg08 = r820t_read_cache_reg(priv, 8) & 0xc0;
+	reg09 = r820t_read_cache_reg(priv, 9) & 0xc0;
+
+	tmp.gain_x = 0;
+	tmp.phase_y = 0;
+	tmp.value = 255;
+
+	for (i = 0; i < 5; i++) {
+		switch (i) {
+		case 0:
+			cross[i].gain_x  = reg08;
+			cross[i].phase_y = reg09;
+			break;
+		case 1:
+			cross[i].gain_x  = reg08;		/* 0 */
+			cross[i].phase_y = reg09 + 1;		/* Q-1 */
+			break;
+		case 2:
+			cross[i].gain_x  = reg08;		/* 0 */
+			cross[i].phase_y = (reg09 | 0x20) + 1;	/* I-1 */
+			break;
+		case 3:
+			cross[i].gain_x  = reg08 + 1;		/* Q-1 */
+			cross[i].phase_y = reg09;
+			break;
+		default:
+			cross[i].gain_x  = (reg08 | 0x20) + 1;	/* I-1 */
+			cross[i].phase_y = reg09;
+		}
+
+		rc = r820t_write_reg(priv, 0x08, cross[i].gain_x);
+		if (rc < 0)
+			return rc;
+
+		rc = r820t_write_reg(priv, 0x09, cross[i].phase_y);
+		if (rc < 0)
+			return rc;
+
+		rc = r820t_multi_read(priv);
+		if (rc < 0)
+			return rc;
+
+		cross[i].value = rc;
+
+		if (cross[i].value < tmp.value)
+			memcpy(&tmp, &cross[i], sizeof(tmp));
+	}
+
+	if ((tmp.phase_y & 0x1f) == 1) {	/* y-direction */
+		*x_direct = 0;
+
+		iq_point[0] = cross[0];
+		iq_point[1] = cross[1];
+		iq_point[2] = cross[2];
+	} else {				/* (0,0) or x-direction */
+		*x_direct = 1;
+
+		iq_point[0] = cross[0];
+		iq_point[1] = cross[3];
+		iq_point[2] = cross[4];
+	}
+	return 0;
+}
+
+static void r820t_compre_cor(struct r820t_sect_type iq[3])
+{
+	int i;
+
+	for (i = 3; i > 0; i--) {
+		if (iq[0].value > iq[i - 1].value)
+			swap(iq[0], iq[i - 1]);
+	}
+}
+
+static int r820t_compre_step(struct r820t_priv *priv,
+			     struct r820t_sect_type iq[3], u8 reg)
+{
+	int rc;
+	struct r820t_sect_type tmp;
+
+	/*
+	 * Purpose: if (Gain<9 or Phase<9), Gain+1 or Phase+1 and compare
+	 * with min value:
+	 *  new < min => update to min and continue
+	 *  new > min => Exit
+	 */
+
+	/* min value already saved in iq[0] */
+	tmp.phase_y = iq[0].phase_y;
+	tmp.gain_x  = iq[0].gain_x;
+
+	while (((tmp.gain_x & 0x1f) < IMR_TRIAL) &&
+	      ((tmp.phase_y & 0x1f) < IMR_TRIAL)) {
+		if (reg == 0x08)
+			tmp.gain_x++;
+		else
+			tmp.phase_y++;
+
+		rc = r820t_write_reg(priv, 0x08, tmp.gain_x);
+		if (rc < 0)
+			return rc;
+
+		rc = r820t_write_reg(priv, 0x09, tmp.phase_y);
+		if (rc < 0)
+			return rc;
+
+		rc = r820t_multi_read(priv);
+		if (rc < 0)
+			return rc;
+		tmp.value = rc;
+
+		if (tmp.value <= iq[0].value) {
+			iq[0].gain_x  = tmp.gain_x;
+			iq[0].phase_y = tmp.phase_y;
+			iq[0].value   = tmp.value;
+		} else {
+			return 0;
+		}
+
+	}
+
+	return 0;
+}
+
+static int r820t_iq_tree(struct r820t_priv *priv,
+			 struct r820t_sect_type iq[3],
+			 u8 fix_val, u8 var_val, u8 fix_reg)
+{
+	int rc, i;
+	u8 tmp, var_reg;
+
+	/*
+	 * record IMC results by input gain/phase location then adjust
+	 * gain or phase positive 1 step and negtive 1 step,
+	 * both record results
+	 */
+
+	if (fix_reg == 0x08)
+		var_reg = 0x09;
+	else
+		var_reg = 0x08;
+
+	for (i = 0; i < 3; i++) {
+		rc = r820t_write_reg(priv, fix_reg, fix_val);
+		if (rc < 0)
+			return rc;
+
+		rc = r820t_write_reg(priv, var_reg, var_val);
+		if (rc < 0)
+			return rc;
+
+		rc = r820t_multi_read(priv);
+		if (rc < 0)
+			return rc;
+		iq[i].value = rc;
+
+		if (fix_reg == 0x08) {
+			iq[i].gain_x  = fix_val;
+			iq[i].phase_y = var_val;
+		} else {
+			iq[i].phase_y = fix_val;
+			iq[i].gain_x  = var_val;
+		}
+
+		if (i == 0) {  /* try right-side point */
+			var_val++;
+		} else if (i == 1) { /* try left-side point */
+			 /* if absolute location is 1, change I/Q direction */
+			if ((var_val & 0x1f) < 0x02) {
+				tmp = 2 - (var_val & 0x1f);
+
+				/* b[5]:I/Q selection. 0:Q-path, 1:I-path */
+				if (var_val & 0x20) {
+					var_val &= 0xc0;
+					var_val |= tmp;
+				} else {
+					var_val |= 0x20 | tmp;
+				}
+			} else {
+				var_val -= 2;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int r820t_section(struct r820t_priv *priv,
+			 struct r820t_sect_type *iq_point)
+{
+	int rc;
+	struct r820t_sect_type compare_iq[3], compare_bet[3];
+
+	/* Try X-1 column and save min result to compare_bet[0] */
+	if (!(iq_point->gain_x & 0x1f))
+		compare_iq[0].gain_x = ((iq_point->gain_x) & 0xdf) + 1;  /* Q-path, Gain=1 */
+	else
+		compare_iq[0].gain_x  = iq_point->gain_x - 1;  /* left point */
+	compare_iq[0].phase_y = iq_point->phase_y;
+
+	/* y-direction */
+	rc = r820t_iq_tree(priv, compare_iq,  compare_iq[0].gain_x,
+			compare_iq[0].phase_y, 0x08);
+	if (rc < 0)
+		return rc;
+
+	r820t_compre_cor(compare_iq);
+
+	compare_bet[0] = compare_iq[0];
+
+	/* Try X column and save min result to compare_bet[1] */
+	compare_iq[0].gain_x  = iq_point->gain_x;
+	compare_iq[0].phase_y = iq_point->phase_y;
+
+	rc = r820t_iq_tree(priv, compare_iq,  compare_iq[0].gain_x,
+			   compare_iq[0].phase_y, 0x08);
+	if (rc < 0)
+		return rc;
+
+	r820t_compre_cor(compare_iq);
+
+	compare_bet[1] = compare_iq[0];
+
+	/* Try X+1 column and save min result to compare_bet[2] */
+	if ((iq_point->gain_x & 0x1f) == 0x00)
+		compare_iq[0].gain_x = ((iq_point->gain_x) | 0x20) + 1;  /* I-path, Gain=1 */
+	else
+		compare_iq[0].gain_x = iq_point->gain_x + 1;
+	compare_iq[0].phase_y = iq_point->phase_y;
+
+	rc = r820t_iq_tree(priv, compare_iq,  compare_iq[0].gain_x,
+			   compare_iq[0].phase_y, 0x08);
+	if (rc < 0)
+		return rc;
+
+	r820t_compre_cor(compare_iq);
+
+	compare_bet[2] = compare_iq[0];
+
+	r820t_compre_cor(compare_bet);
+
+	*iq_point = compare_bet[0];
+
+	return 0;
+}
+
+static int r820t_vga_adjust(struct r820t_priv *priv)
+{
+	int rc;
+	u8 vga_count;
+
+	/* increase vga power to let image significant */
+	for (vga_count = 12; vga_count < 16; vga_count++) {
+		rc = r820t_write_reg_mask(priv, 0x0c, vga_count, 0x0f);
+		if (rc < 0)
+			return rc;
+
+		usleep_range(10000, 11000);
+
+		rc = r820t_multi_read(priv);
+		if (rc < 0)
+			return rc;
+
+		if (rc > 40 * 4)
+			break;
+	}
+
+	return 0;
+}
+
+static int r820t_iq(struct r820t_priv *priv, struct r820t_sect_type *iq_pont)
+{
+	struct r820t_sect_type compare_iq[3];
+	int rc;
+	u8 x_direction = 0;  /* 1:x, 0:y */
+	u8 dir_reg, other_reg;
+
+	r820t_vga_adjust(priv);
+
+	rc = r820t_imr_cross(priv, compare_iq, &x_direction);
+	if (rc < 0)
+		return rc;
+
+	if (x_direction == 1) {
+		dir_reg   = 0x08;
+		other_reg = 0x09;
+	} else {
+		dir_reg   = 0x09;
+		other_reg = 0x08;
+	}
+
+	/* compare and find min of 3 points. determine i/q direction */
+	r820t_compre_cor(compare_iq);
+
+	/* increase step to find min value of this direction */
+	rc = r820t_compre_step(priv, compare_iq, dir_reg);
+	if (rc < 0)
+		return rc;
+
+	/* the other direction */
+	rc = r820t_iq_tree(priv, compare_iq,  compare_iq[0].gain_x,
+				compare_iq[0].phase_y, dir_reg);
+	if (rc < 0)
+		return rc;
+
+	/* compare and find min of 3 points. determine i/q direction */
+	r820t_compre_cor(compare_iq);
+
+	/* increase step to find min value on this direction */
+	rc = r820t_compre_step(priv, compare_iq, other_reg);
+	if (rc < 0)
+		return rc;
+
+	/* check 3 points again */
+	rc = r820t_iq_tree(priv, compare_iq,  compare_iq[0].gain_x,
+				compare_iq[0].phase_y, other_reg);
+	if (rc < 0)
+		return rc;
+
+	r820t_compre_cor(compare_iq);
+
+	/* section-9 check */
+	rc = r820t_section(priv, compare_iq);
+
+	*iq_pont = compare_iq[0];
+
+	/* reset gain/phase control setting */
+	rc = r820t_write_reg_mask(priv, 0x08, 0, 0x3f);
+	if (rc < 0)
+		return rc;
+
+	rc = r820t_write_reg_mask(priv, 0x09, 0, 0x3f);
+
+	return rc;
+}
+
+static int r820t_f_imr(struct r820t_priv *priv, struct r820t_sect_type *iq_pont)
+{
+	int rc;
+
+	r820t_vga_adjust(priv);
+
+	/*
+	 * search surrounding points from previous point
+	 * try (x-1), (x), (x+1) columns, and find min IMR result point
+	 */
+	rc = r820t_section(priv, iq_pont);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+static int r820t_imr(struct r820t_priv *priv, unsigned imr_mem, bool im_flag)
+{
+	struct r820t_sect_type imr_point;
+	int rc;
+	u32 ring_vco, ring_freq, ring_ref;
+	u8 n_ring, n;
+	int reg18, reg19, reg1f;
+
+	if (priv->cfg->xtal > 24000000)
+		ring_ref = priv->cfg->xtal / 2;
+	else
+		ring_ref = priv->cfg->xtal;
+
+	for (n = 0; n < 16; n++) {
+		if ((16 + n) * 8 * ring_ref >= 3100000) {
+			n_ring = n;
+			break;
+		}
+
+		/* n_ring not found */
+		if (n == 15)
+			n_ring = n;
+	}
+
+	reg18 = r820t_read_cache_reg(priv, 0x18);
+	reg19 = r820t_read_cache_reg(priv, 0x19);
+	reg1f = r820t_read_cache_reg(priv, 0x1f);
+
+	reg18 &= 0xf0;      /* set ring[3:0] */
+	reg18 |= n_ring;
+
+	ring_vco = (16 + n_ring) * 8 * ring_ref;
+
+	reg18 &= 0xdf;   /* clear ring_se23 */
+	reg19 &= 0xfc;   /* clear ring_seldiv */
+	reg1f &= 0xfc;   /* clear ring_att */
+
+	switch (imr_mem) {
+	case 0:
+		ring_freq = ring_vco / 48;
+		reg18 |= 0x20;  /* ring_se23 = 1 */
+		reg19 |= 0x03;  /* ring_seldiv = 3 */
+		reg1f |= 0x02;  /* ring_att 10 */
+		break;
+	case 1:
+		ring_freq = ring_vco / 16;
+		reg18 |= 0x00;  /* ring_se23 = 0 */
+		reg19 |= 0x02;  /* ring_seldiv = 2 */
+		reg1f |= 0x00;  /* pw_ring 00 */
+		break;
+	case 2:
+		ring_freq = ring_vco / 8;
+		reg18 |= 0x00;  /* ring_se23 = 0 */
+		reg19 |= 0x01;  /* ring_seldiv = 1 */
+		reg1f |= 0x03;  /* pw_ring 11 */
+		break;
+	case 3:
+		ring_freq = ring_vco / 6;
+		reg18 |= 0x20;  /* ring_se23 = 1 */
+		reg19 |= 0x00;  /* ring_seldiv = 0 */
+		reg1f |= 0x03;  /* pw_ring 11 */
+		break;
+	case 4:
+		ring_freq = ring_vco / 4;
+		reg18 |= 0x00;  /* ring_se23 = 0 */
+		reg19 |= 0x00;  /* ring_seldiv = 0 */
+		reg1f |= 0x01;  /* pw_ring 01 */
+		break;
+	default:
+		ring_freq = ring_vco / 4;
+		reg18 |= 0x00;  /* ring_se23 = 0 */
+		reg19 |= 0x00;  /* ring_seldiv = 0 */
+		reg1f |= 0x01;  /* pw_ring 01 */
+		break;
+	}
+
+
+	/* write pw_ring, n_ring, ringdiv2 registers */
+
+	/* n_ring, ring_se23 */
+	rc = r820t_write_reg(priv, 0x18, reg18);
+	if (rc < 0)
+		return rc;
+
+	/* ring_sediv */
+	rc = r820t_write_reg(priv, 0x19, reg19);
+	if (rc < 0)
+		return rc;
+
+	/* pw_ring */
+	rc = r820t_write_reg(priv, 0x1f, reg1f);
+	if (rc < 0)
+		return rc;
+
+	/* mux input freq ~ rf_in freq */
+	rc = r820t_set_mux(priv, (ring_freq - 5300) * 1000);
+	if (rc < 0)
+		return rc;
+
+	rc = r820t_set_pll(priv, V4L2_TUNER_DIGITAL_TV,
+			   (ring_freq - 5300) * 1000);
+	if (!priv->has_lock)
+		rc = -EINVAL;
+	if (rc < 0)
+		return rc;
+
+	if (im_flag) {
+		rc = r820t_iq(priv, &imr_point);
+	} else {
+		imr_point.gain_x  = priv->imr_data[3].gain_x;
+		imr_point.phase_y = priv->imr_data[3].phase_y;
+		imr_point.value   = priv->imr_data[3].value;
+
+		rc = r820t_f_imr(priv, &imr_point);
+	}
+	if (rc < 0)
+		return rc;
+
+	/* save IMR value */
+	switch (imr_mem) {
+	case 0:
+		priv->imr_data[0].gain_x  = imr_point.gain_x;
+		priv->imr_data[0].phase_y = imr_point.phase_y;
+		priv->imr_data[0].value   = imr_point.value;
+		break;
+	case 1:
+		priv->imr_data[1].gain_x  = imr_point.gain_x;
+		priv->imr_data[1].phase_y = imr_point.phase_y;
+		priv->imr_data[1].value   = imr_point.value;
+		break;
+	case 2:
+		priv->imr_data[2].gain_x  = imr_point.gain_x;
+		priv->imr_data[2].phase_y = imr_point.phase_y;
+		priv->imr_data[2].value   = imr_point.value;
+		break;
+	case 3:
+		priv->imr_data[3].gain_x  = imr_point.gain_x;
+		priv->imr_data[3].phase_y = imr_point.phase_y;
+		priv->imr_data[3].value   = imr_point.value;
+		break;
+	case 4:
+		priv->imr_data[4].gain_x  = imr_point.gain_x;
+		priv->imr_data[4].phase_y = imr_point.phase_y;
+		priv->imr_data[4].value   = imr_point.value;
+		break;
+	default:
+		priv->imr_data[4].gain_x  = imr_point.gain_x;
+		priv->imr_data[4].phase_y = imr_point.phase_y;
+		priv->imr_data[4].value   = imr_point.value;
+		break;
+	}
+
+	return 0;
+}
+
+static int r820t_imr_callibrate(struct r820t_priv *priv)
 {
-	struct r820t_priv *priv = fe->tuner_priv;
 	int rc, i;
 	int xtal_cap = 0;
 
-	tuner_dbg("%s:\n", __func__);
+	if (priv->imr_done)
+		return 0;
 
-	mutex_lock(&priv->lock);
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
+	/* Initialize registers */
+	rc = r820t_write(priv, 0x05,
+			 r820t_init_array, sizeof(r820t_init_array));
+	if (rc < 0)
+		return rc;
 
+	/* Detect Xtal capacitance */
 	if ((priv->cfg->rafael_chip == CHIP_R820T) ||
 	    (priv->cfg->rafael_chip == CHIP_R828S) ||
 	    (priv->cfg->rafael_chip == CHIP_R820C)) {
@@ -1409,7 +2017,7 @@ static int r820t_init(struct dvb_frontend *fe)
 		for (i = 0; i < 3; i++) {
 			rc = r820t_xtal_check(priv);
 			if (rc < 0)
-				goto err;
+				return rc;
 			if (!i || rc > xtal_cap)
 				xtal_cap = rc;
 		}
@@ -1419,6 +2027,58 @@ static int r820t_init(struct dvb_frontend *fe)
 	/* Initialize registers */
 	rc = r820t_write(priv, 0x05,
 			 r820t_init_array, sizeof(r820t_init_array));
+	if (rc < 0)
+		return rc;
+
+	rc = r820t_imr_prepare(priv);
+	if (rc < 0)
+		return rc;
+
+	rc = r820t_imr(priv, 3, true);
+	if (rc < 0)
+		return rc;
+	rc = r820t_imr(priv, 1, false);
+	if (rc < 0)
+		return rc;
+	rc = r820t_imr(priv, 0, false);
+	if (rc < 0)
+		return rc;
+	rc = r820t_imr(priv, 2, false);
+	if (rc < 0)
+		return rc;
+	rc = r820t_imr(priv, 4, false);
+	if (rc < 0)
+		return rc;
+
+	priv->imr_done = true;
+
+	return 0;
+}
+
+/*
+ *  r820t frontend operations and tuner attach code
+ *
+ * All driver locks and i2c control are only in this part of the code
+ */
+
+static int r820t_init(struct dvb_frontend *fe)
+{
+	struct r820t_priv *priv = fe->tuner_priv;
+	int rc;
+
+	tuner_dbg("%s:\n", __func__);
+
+	mutex_lock(&priv->lock);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	rc = r820t_imr_callibrate(priv);
+	if (rc < 0)
+		goto err;
+
+	/* Initialize registers */
+	rc = r820t_write(priv, 0x05,
+			 r820t_init_array, sizeof(r820t_init_array));
 
 err:
 	if (fe->ops.i2c_gate_ctrl)
-- 
1.8.1.4


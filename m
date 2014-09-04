Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38354 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059AbaIDChB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/37] it913x: change reg read/write routines more common
Date: Thu,  4 Sep 2014 05:36:22 +0300
Message-Id: <1409798205-25645-14-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change register write and read routines to similar which are
typically used. We have to add processor core as a part of register
address in order to simplify register access. Chip has two cores,
called link and ofdm. As for now, use address bit 24 to address used
core. Bits 15:0 are register address in given core.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c      | 58 +++++++++++++++-----------------
 drivers/media/tuners/it913x_priv.h | 69 ++++++++++++++++++--------------------
 2 files changed, 60 insertions(+), 67 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 72fefb7..7664878 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -49,7 +49,6 @@ static int it913x_rd_regs(struct it913x_state *state,
 	b[0] = (u8)(reg >> 16) & 0xff;
 	b[1] = (u8)(reg >> 8) & 0xff;
 	b[2] = (u8) reg & 0xff;
-	b[0] |= 0x80; /* All reads from demodulator */
 
 	ret = i2c_transfer(state->client->adapter, msg, 2);
 
@@ -57,18 +56,21 @@ static int it913x_rd_regs(struct it913x_state *state,
 }
 
 /* read single register */
-static int it913x_rd_reg(struct it913x_state *state, u32 reg)
+static int it913x_rd_reg(struct it913x_state *state, u32 reg, u8 *val)
 {
 	int ret;
 	u8 b[1];
 
 	ret = it913x_rd_regs(state, reg, &b[0], sizeof(b));
-	return (ret < 0) ? -ENODEV : b[0];
+	if (ret < 0)
+		return -ENODEV;
+	*val = b[0];
+	return 0;
 }
 
 /* write multiple registers */
 static int it913x_wr_regs(struct it913x_state *state,
-		u8 pro, u32 reg, u8 buf[], u8 count)
+		u32 reg, u8 buf[], u8 count)
 {
 	u8 b[256];
 	struct i2c_msg msg[1] = {
@@ -82,9 +84,6 @@ static int it913x_wr_regs(struct it913x_state *state,
 	b[2] = (u8) reg & 0xff;
 	memcpy(&b[3], buf, count);
 
-	if (pro == PRO_DMOD)
-		b[0] |= 0x80;
-
 	ret = i2c_transfer(state->client->adapter, msg, 1);
 
 	if (ret < 0)
@@ -95,7 +94,7 @@ static int it913x_wr_regs(struct it913x_state *state,
 
 /* write single register */
 static int it913x_wr_reg(struct it913x_state *state,
-		u8 pro, u32 reg, u32 data)
+		u32 reg, u32 data)
 {
 	int ret;
 	u8 b[4];
@@ -115,7 +114,7 @@ static int it913x_wr_reg(struct it913x_state *state,
 	else
 		s = 0;
 
-	ret = it913x_wr_regs(state, pro, reg, &b[s], sizeof(b) - s);
+	ret = it913x_wr_regs(state, reg, &b[s], sizeof(b) - s);
 
 	return ret;
 }
@@ -129,9 +128,9 @@ static int it913x_script_loader(struct it913x_state *state,
 		return -EINVAL;
 
 	for (i = 0; i < 1000; ++i) {
-		if (loadscript[i].pro == 0xff)
+		if (loadscript[i].address == 0x000000)
 			break;
-		ret = it913x_wr_regs(state, loadscript[i].pro,
+		ret = it913x_wr_regs(state,
 			loadscript[i].address,
 			loadscript[i].reg, loadscript[i].count);
 		if (ret < 0)
@@ -143,12 +142,13 @@ static int it913x_script_loader(struct it913x_state *state,
 static int it913x_init(struct dvb_frontend *fe)
 {
 	struct it913x_state *state = fe->tuner_priv;
-	int ret, i, reg;
+	int ret, i;
+	u8 reg = 0;
 	u8 val, nv_val;
 	u8 nv[] = {48, 32, 24, 16, 12, 8, 6, 4, 2};
 	u8 b[2];
 
-	reg = it913x_rd_reg(state, 0xec86);
+	ret = it913x_rd_reg(state, 0x80ec86, &reg);
 	switch (reg) {
 	case 0:
 		state->tun_clk_mode = reg;
@@ -156,13 +156,8 @@ static int it913x_init(struct dvb_frontend *fe)
 		state->tun_fdiv = 3;
 		val = 16;
 		break;
-	case -ENODEV:
-		/* FIXME: these are just avoid divide by 0 */
-		state->tun_xtal = 2000;
-		state->tun_fdiv = 3;
-		return -ENODEV;
 	case 1:
-	default:
+	default: /* I/O error too */
 		state->tun_clk_mode = reg;
 		state->tun_xtal = 640;
 		state->tun_fdiv = 1;
@@ -170,7 +165,7 @@ static int it913x_init(struct dvb_frontend *fe)
 		break;
 	}
 
-	reg = it913x_rd_reg(state, 0xed03);
+	ret = it913x_rd_reg(state, 0x80ed03,  &reg);
 
 	if (reg < 0)
 		return -ENODEV;
@@ -180,7 +175,7 @@ static int it913x_init(struct dvb_frontend *fe)
 		nv_val = 2;
 
 	for (i = 0; i < 50; i++) {
-		ret = it913x_rd_regs(state, 0xed23, &b[0], sizeof(b));
+		ret = it913x_rd_regs(state, 0x80ed23, &b[0], sizeof(b));
 		reg = (b[1] << 8) + b[0];
 		if (reg > 0)
 			break;
@@ -196,21 +191,21 @@ static int it913x_init(struct dvb_frontend *fe)
 		msleep(50);
 	else {
 		for (i = 0; i < 50; i++) {
-			reg = it913x_rd_reg(state, 0xec82);
+			ret = it913x_rd_reg(state, 0x80ec82, &reg);
+			if (ret < 0)
+				return -ENODEV;
 			if (reg > 0)
 				break;
-			if (reg < 0)
-				return -ENODEV;
 			udelay(2000);
 		}
 	}
 
 	/* Power Up Tuner - common all versions */
-	ret = it913x_wr_reg(state, PRO_DMOD, 0xec40, 0x1);
-	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec57, 0x0);
-	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec58, 0x0);
+	ret = it913x_wr_reg(state, 0x80ec40, 0x1);
+	ret |= it913x_wr_reg(state, 0x80ec57, 0x0);
+	ret |= it913x_wr_reg(state, 0x80ec58, 0x0);
 
-	return it913x_wr_reg(state, PRO_DMOD, 0xed81, val);
+	return it913x_wr_reg(state, 0x80ed81, val);
 }
 
 static int it9137_set_params(struct dvb_frontend *fe)
@@ -220,7 +215,8 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u32 bandwidth = p->bandwidth_hz;
 	u32 frequency_m = p->frequency;
-	int ret, reg;
+	int ret;
+	u8 reg = 0;
 	u32 frequency = frequency_m / 1000;
 	u32 freq, temp_f, tmp;
 	u16 iqik_m_cal;
@@ -321,7 +317,7 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	} else
 		return -EINVAL;
 
-	reg = it913x_rd_reg(state, 0xed81);
+	ret = it913x_rd_reg(state, 0x80ed81, &reg);
 	iqik_m_cal = (u16)reg * n_div;
 
 	if (reg < 0x20) {
@@ -412,7 +408,7 @@ static int it913x_probe(struct i2c_client *client,
 	state->firmware_ver = 1;
 
 	/* tuner RF initial */
-	ret = it913x_wr_reg(state, PRO_DMOD, 0xec4c, 0x68);
+	ret = it913x_wr_reg(state, 0x80ec4c, 0x68);
 	if (ret < 0)
 		goto err;
 
diff --git a/drivers/media/tuners/it913x_priv.h b/drivers/media/tuners/it913x_priv.h
index d624efd..32af24c 100644
--- a/drivers/media/tuners/it913x_priv.h
+++ b/drivers/media/tuners/it913x_priv.h
@@ -25,63 +25,60 @@
 
 #include "it913x.h"
 
-#define PRO_LINK		0x0
-#define PRO_DMOD		0x1
 #define TRIGGER_OFSM		0x0000
 
-struct it913xset {	u32 pro;
-			u32 address;
+struct it913xset {	u32 address;
 			u8 reg[15];
 			u8 count;
 };
 
 /* Tuner setting scripts for IT9135 AX */
 static struct it913xset it9135ax_tuner_off[] = {
-	{PRO_DMOD, 0xec40, {0x00}, 0x01}, /* Power Down Tuner */
-	{PRO_DMOD, 0xec02, {0x3f}, 0x01},
-	{PRO_DMOD, 0xec03, {0x1f}, 0x01},
-	{PRO_DMOD, 0xec04, {0x3f}, 0x01},
-	{PRO_DMOD, 0xec05, {0x3f}, 0x01},
-	{PRO_DMOD, 0xec3f, {0x01}, 0x01},
-	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+	{0x80ec40, {0x00}, 0x01}, /* Power Down Tuner */
+	{0x80ec02, {0x3f}, 0x01},
+	{0x80ec03, {0x1f}, 0x01},
+	{0x80ec04, {0x3f}, 0x01},
+	{0x80ec05, {0x3f}, 0x01},
+	{0x80ec3f, {0x01}, 0x01},
+	{0x000000, {0x00}, 0x00}, /* Terminating Entry */
 };
 
 /* Tuner setting scripts (still keeping it9137) */
 static struct it913xset it9137_tuner_off[] = {
-	{PRO_DMOD, 0xec40, {0x00}, 0x01}, /* Power Down Tuner */
-	{PRO_DMOD, 0xec02, {0x3f, 0x1f, 0x3f, 0x3f}, 0x04},
-	{PRO_DMOD, 0xec06, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	{0x80ec40, {0x00}, 0x01}, /* Power Down Tuner */
+	{0x80ec02, {0x3f, 0x1f, 0x3f, 0x3f}, 0x04},
+	{0x80ec06, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 				0x00, 0x00, 0x00, 0x00}, 0x0c},
-	{PRO_DMOD, 0xec12, {0x00, 0x00, 0x00, 0x00}, 0x04},
-	{PRO_DMOD, 0xec17, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	{0x80ec12, {0x00, 0x00, 0x00, 0x00}, 0x04},
+	{0x80ec17, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 				0x00}, 0x09},
-	{PRO_DMOD, 0xec22, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	{0x80ec22, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 				0x00, 0x00}, 0x0a},
-	{PRO_DMOD, 0xec20, {0x00}, 0x01},
-	{PRO_DMOD, 0xec3f, {0x01}, 0x01},
-	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+	{0x80ec20, {0x00}, 0x01},
+	{0x80ec3f, {0x01}, 0x01},
+	{0x000000, {0x00}, 0x00}, /* Terminating Entry */
 };
 
 static struct it913xset set_it9135_template[] = {
-	{PRO_DMOD, 0xee06, {0x00}, 0x01},
-	{PRO_DMOD, 0xec56, {0x00}, 0x01},
-	{PRO_DMOD, 0xec4c, {0x00}, 0x01},
-	{PRO_DMOD, 0xec4d, {0x00}, 0x01},
-	{PRO_DMOD, 0xec4e, {0x00}, 0x01},
-	{PRO_DMOD, 0x011e, {0x00}, 0x01}, /* Older Devices */
-	{PRO_DMOD, 0x011f, {0x00}, 0x01},
-	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+	{0x80ee06, {0x00}, 0x01},
+	{0x80ec56, {0x00}, 0x01},
+	{0x80ec4c, {0x00}, 0x01},
+	{0x80ec4d, {0x00}, 0x01},
+	{0x80ec4e, {0x00}, 0x01},
+	{0x80011e, {0x00}, 0x01}, /* Older Devices */
+	{0x80011f, {0x00}, 0x01},
+	{0x000000, {0x00}, 0x00}, /* Terminating Entry */
 };
 
 static struct it913xset set_it9137_template[] = {
-	{PRO_DMOD, 0xee06, {0x00}, 0x01},
-	{PRO_DMOD, 0xec56, {0x00}, 0x01},
-	{PRO_DMOD, 0xec4c, {0x00}, 0x01},
-	{PRO_DMOD, 0xec4d, {0x00}, 0x01},
-	{PRO_DMOD, 0xec4e, {0x00}, 0x01},
-	{PRO_DMOD, 0xec4f, {0x00}, 0x01},
-	{PRO_DMOD, 0xec50, {0x00}, 0x01},
-	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+	{0x80ee06, {0x00}, 0x01},
+	{0x80ec56, {0x00}, 0x01},
+	{0x80ec4c, {0x00}, 0x01},
+	{0x80ec4d, {0x00}, 0x01},
+	{0x80ec4e, {0x00}, 0x01},
+	{0x80ec4f, {0x00}, 0x01},
+	{0x80ec50, {0x00}, 0x01},
+	{0x000000, {0x00}, 0x00}, /* Terminating Entry */
 };
 
 #endif
-- 
http://palosaari.fi/


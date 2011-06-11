Return-path: <mchehab@pedra>
Received: from blu0-omc2-s4.blu0.hotmail.com ([65.55.111.79]:19949 "EHLO
	blu0-omc2-s4.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab1FKI4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 04:56:17 -0400
Message-ID: <BLU0-SMTP6489F0DFD8FDFA50474384D8670@phx.gbl>
From: Manoel Pinheiro <pinusdtv@hotmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] [media] mb86a20s: Add support for TBS-Tech ISDB-T Full Seg DTB08
Date: Sat, 11 Jun 2011 05:56:01 -0300
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This code allows free programming of some registers of the mb86a20s
demodulator. All registers that need changes received an identification
(REGXXXX_IDCFG).


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
---
 drivers/media/dvb/frontends/mb86a20s.c |  203 ++++++++++++++++++++++++++++++++
 drivers/media/dvb/frontends/mb86a20s.h |  100 ++++++++++++++++
 2 files changed, 303 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index f3c4013..bc7e868 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -1,6 +1,7 @@
 /*
  *   Fujitu mb86a20s ISDB-T/ISDB-Tsb Module driver
  *
+ *   Copyright (C) 2011 Manoel Pinheiro <pinusdtv@pdtv.cjb.net>
  *   Copyright (C) 2010 Mauro Carvalho Chehab <mchehab@redhat.com>
  *   Copyright (C) 2009-2010 Douglas Landgraf <dougsland@redhat.com>
  *
@@ -45,8 +46,19 @@ struct mb86a20s_state {
 	struct dvb_frontend frontend;
 
 	bool need_init;
+	int config_regs_size;
+	const struct mb86a20s_config_regs_val *config_regs;
 };
 
+struct mb86a20s_config_regs {
+	u8 id_cfg;
+	u8 type;	/* 0=8 bits wo/sub, 1=8 bits w/sub
+			 * 2=16 bits wo/sub, 3=16 bits w/sub, 4=24 bits */
+	u8 reg;
+	u8 subreg;
+	u32 init_val;
+};
+ 
 struct regdata {
 	u8 reg;
 	u8 data;
@@ -309,6 +321,104 @@ static struct regdata mb86a20s_reset_reception[] = {
 	{ 0x08, 0x00 },
 };
 
+/*
+ * Initial registers for Pixelview USB hybrid PV-B308U
+ */
+static struct mb86a20s_config_regs mb86a20s_init_regs[] = {
+	{ REGNONE_IDCFG, 0x00, 0x70, 0x00, 0x0f },
+	{ REGNONE_IDCFG, 0x00, 0x70, 0x00, 0xff },
+	{ REGNONE_IDCFG, 0x00, 0x08, 0x00, 0x01 },
+	{ REG09_IDCFG, 0x00, 0x09, 0x00, 0x3e },
+	{ REG50D1_IDCFG, 0x01, 0x50, 0xd1, 0x22 },
+	{ REG39_IDCFG, 0x00, 0x39, 0x00, 0x01 },
+	{ REG71_IDCFG, 0x00, 0x71, 0x00, 0x00 },
+	{ REG282A_IDCFG, 0x04, 0x28, 0x2a, 0xff80 },
+	{ REG2820_IDCFG, 0x04, 0x28, 0x20, 0x33dfa9 },
+	{ REG2822_IDCFG, 0x04, 0x28, 0x22, 0x1ff0 },
+	{ REGNONE_IDCFG, 0x00, 0x3b, 0x00, 0x21 },
+	{ REG3C_IDCFG, 0x00, 0x3c, 0x00, 0x3a },
+	{ REG01_IDCFG, 0x00, 0x01, 0x00, 0x0d },
+	{ REG0408_IDCFG, 0x01, 0x04, 0x08, 0x05 },
+	{ REG040E_IDCFG, 0x03, 0x04, 0x0e, 0x0014 },
+	{ REG040B_IDCFG, 0x01, 0x04, 0x0b, 0x8c },
+	{ REG0400_IDCFG, 0x03, 0x04, 0x00, 0x0007 },
+	{ REG0402_IDCFG, 0x03, 0x04, 0x02, 0x0fa0 },
+	{ REG0409_IDCFG, 0x01, 0x04, 0x09, 0x00 },
+	{ REG040A_IDCFG, 0x01, 0x04, 0x0a, 0xff },
+	{ REG0427_IDCFG, 0x01, 0x04, 0x27, 0x64 },
+	{ REG0428_IDCFG, 0x01, 0x04, 0x28, 0x00 },
+	{ REG041E_IDCFG, 0x01, 0x04, 0x1e, 0xff },
+	{ REG0429_IDCFG, 0x01, 0x04, 0x29, 0x0a },
+	{ REG0432_IDCFG, 0x01, 0x04, 0x32, 0x0a },
+	{ REG0414_IDCFG, 0x01, 0x04, 0x14, 0x02 },
+	{ REG0404_IDCFG, 0x03, 0x04, 0x04, 0x0022 },
+	{ REG0406_IDCFG, 0x03, 0x04, 0x06, 0x0ed8 },
+	{ REG0412_IDCFG, 0x01, 0x04, 0x12, 0x00 },
+	{ REG0413_IDCFG, 0x01, 0x04, 0x13, 0xff },
+	{ REG0415_IDCFG, 0x01, 0x04, 0x15, 0x4e },
+	{ REG0416_IDCFG, 0x01, 0x04, 0x16, 0x20 },
+	{ REGNONE_IDCFG, 0x00, 0x52, 0x00, 0x01 },
+	{ REG50A7_IDCFG, 0x04, 0x50, 0xa7, 0xffff },
+	{ REG50AA_IDCFG, 0x04, 0x50, 0xaa,0xffff },
+	{ REG50AD_IDCFG, 0x04, 0x50, 0xad, 0xffff },
+	{ REGNONE_IDCFG, 0x00, 0x5e, 0x00, 0x07 },
+	{ REG50DC_IDCFG, 0x03, 0x50, 0xdc, 0x01f4 },
+	{ REG50DE_IDCFG, 0x03, 0x50, 0xde, 0x01f4 },
+	{ REG50E0_IDCFG, 0x03, 0x50, 0xe0, 0x01f4 },
+	{ REG50B0_IDCFG, 0x01, 0x50, 0xb0, 0x07 },
+	{ REG50B2_IDCFG, 0x03, 0x50, 0xb2, 0xffff },
+	{ REG50B4_IDCFG, 0x03, 0x50, 0xb4, 0xffff },
+	{ REG50B6_IDCFG, 0x03, 0x50, 0xb6, 0xffff },
+	{ REG5050_IDCFG, 0x01, 0x50, 0x50, 0x02 },
+	{ REG5051_IDCFG, 0x01, 0x50, 0x51, 0x04 },
+	{ REG45_IDCFG, 0x00, 0x45, 0x00, 0x04 },
+	{ REGNONE_IDCFG, 0x00, 0x48, 0x00, 0x04 },
+	{ REG50D5_IDCFG, 0x01, 0x50, 0xd5, 0x01 },
+	{ REG50D6_IDCFG, 0x01, 0x50, 0xd6, 0x1f },
+	{ REG50D2_IDCFG, 0x01, 0x50, 0xd2, 0x03 },
+	{ REG50D7_IDCFG, 0x01, 0x50, 0xd7, 0x3f },
+	{ REG2874_IDCFG, 0x04, 0x28, 0x74, 0x0040 },
+	{ REG2846_IDCFG, 0x04, 0x28, 0x46, 0x2c0c },
+	{ REG0440_IDCFG, 0x01, 0x04, 0x40, 0x01 },
+	{ REG2800_IDCFG, 0x01, 0x28, 0x00, 0x10 },
+	{ REG2805_IDCFG, 0x01, 0x28, 0x05, 0x02 },
+	{ REGNONE_IDCFG, 0x00, 0x1c, 0x00, 0x01 },
+	{ REG2806_IDCFG, 0x04, 0x28, 0x06, 0x0003 },
+	{ REG2807_IDCFG, 0x04, 0x28, 0x07, 0x000d },
+	{ REG2808_IDCFG, 0x04, 0x28, 0x08, 0x0002 },
+	{ REG2809_IDCFG, 0x04, 0x28, 0x09, 0x0001 },
+	{ REG280A_IDCFG, 0x04, 0x28, 0x0a, 0x0021 },
+	{ REG280B_IDCFG, 0x04, 0x28, 0x0b, 0x0029 },
+	{ REG280C_IDCFG, 0x04, 0x28, 0x0c, 0x0016 },
+	{ REG280D_IDCFG, 0x04, 0x28, 0x0d, 0x0031 },
+	{ REG280E_IDCFG, 0x04, 0x28, 0x0e, 0x000e },
+	{ REG280F_IDCFG, 0x04, 0x28, 0x0f, 0x004e },
+	{ REG2810_IDCFG, 0x04, 0x28, 0x10, 0x0046 },
+	{ REG2811_IDCFG, 0x04, 0x28, 0x11, 0x000f },
+	{ REG2812_IDCFG, 0x04, 0x28, 0x12, 0x0056 },
+	{ REG2813_IDCFG, 0x04, 0x28, 0x13, 0x0035 },
+	{ REG2814_IDCFG, 0x04, 0x28, 0x14, 0x01be },
+	{ REG2815_IDCFG, 0x04, 0x28, 0x15, 0x0184 },
+	{ REG2816_IDCFG, 0x04, 0x28, 0x16, 0x03ee },
+	{ REG2817_IDCFG, 0x04, 0x28, 0x17, 0x0098 },
+	{ REG2818_IDCFG, 0x04, 0x28, 0x18, 0x009f },
+	{ REG2819_IDCFG, 0x04, 0x28, 0x19, 0x07b2 },
+	{ REG281A_IDCFG, 0x04, 0x28, 0x1a, 0x06c2 },
+	{ REG281B_IDCFG, 0x04, 0x28, 0x1b, 0x074a },
+	{ REG281C_IDCFG, 0x04, 0x28, 0x1c, 0x01bc },
+	{ REG281D_IDCFG, 0x04, 0x28, 0x1d, 0x04ba },
+	{ REG281E_IDCFG, 0x04, 0x28, 0x1e, 0x0614 },
+	{ REG501E_IDCFG, 0x01, 0x50, 0x1e, 0x5d },
+	{ REG5022_IDCFG, 0x01, 0x50, 0x22, 0x00 },
+	{ REG5023_IDCFG, 0x01, 0x50, 0x23, 0xc8 },
+	{ REG5024_IDCFG, 0x01, 0x50, 0x24, 0x00 },
+	{ REG5025_IDCFG, 0x01, 0x50, 0x25, 0xf0 },
+	{ REG5026_IDCFG, 0x01, 0x50, 0x26, 0x00 },
+	{ REG5027_IDCFG, 0x01, 0x50, 0x27, 0xc3 },
+	{ REG5039_IDCFG, 0x01, 0x50, 0x39, 0x02 },
+	{ REG286A_IDCFG, 0x04, 0x28, 0x6a, 0x0000 }
+};
+
 static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
 			     u8 i2c_addr, int reg, int data)
 {
@@ -381,12 +491,103 @@ static int mb86a20s_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 		return mb86a20s_writereg(state, 0xfe, 1);
 }
 
+static u32 get_config_reg_val(struct mb86a20s_state *state, u8 id_cfg, u32 default_val)
+{
+	int i;
+
+	if (state->config_regs != NULL) {
+		for (i = 0; i < state->config_regs_size; i++) {
+			if (state->config_regs[i].id_cfg == id_cfg)
+				return state->config_regs[i].init_val;
+		}
+	}
+        return default_val;
+}
+
+static int mb86a20s_regs_init(struct mb86a20s_state *state)
+{
+	int i, i2, rc, count;
+	char buf[12];
+
+	state->need_init = 1;
+
+	for (i = 0; i < ARRAY_SIZE(mb86a20s_init_regs); i++) {
+		struct mb86a20s_config_regs *reg_val = &mb86a20s_init_regs[i];
+		u32 val = reg_val->init_val;
+		if (reg_val->id_cfg != REGNONE_IDCFG && state->config_regs)
+			val = get_config_reg_val(state, reg_val->id_cfg, val);
+
+		buf[0] = reg_val->reg;
+		count = 1;
+		switch (reg_val->type) {
+		case 1:
+			buf[count++] = reg_val->subreg;
+			if (buf[0] == 0x28)
+				buf[count++] = 0x2b;
+			else
+				buf[count++] = buf[0] + 1;
+			break;
+		case 2:
+			buf[count++] = (u8)(val >> 0x08);
+			buf[count++] = buf[0] + 1;
+			buf[count++] = (u8)val;
+			break;
+		case 3:
+			buf[count++] = reg_val->subreg;
+			buf[count++] = buf[0] + 1;
+			buf[count++] = (u8)(val >> 0x08);
+			buf[count++] = buf[0];
+			buf[count++] = reg_val->subreg + 1;
+			buf[count++] = buf[0] + 1;
+			break;
+		case 4:
+			if (buf[0] == 0x28) {
+				buf[count++] = reg_val->subreg;
+				buf[count++] = 0x29;
+				buf[count++] = (u8)(val >> 0x10);
+				buf[count++] = 0x2a;
+				buf[count++] = (u8)(val >> 0x08);
+				buf[count++] = 0x2b;
+			}
+			else if (buf[0] == 0x50) {
+				buf[count++] = reg_val->subreg;
+				buf[count++] = buf[0] + 1;
+				buf[count++] = (u8)(val >> 0x10);
+				buf[count++] = buf[0];
+				buf[count++] = reg_val->subreg + 1;
+				buf[count++] = buf[0] + 1;
+				buf[count++] = (u8)(val >> 0x08);
+				buf[count++] = buf[0];
+				buf[count++] = reg_val->subreg + 2;
+				buf[count++] = buf[0] + 1;
+			}
+			else
+				return -1;
+			break;
+		}
+		buf[count++] = (u8)val;
+		i2 = 0;
+		while (i2 < count)
+		{
+			rc = mb86a20s_writereg(state, buf[i2], buf[i2 + 1]);
+			if (rc < 0)
+				return rc;
+			i2 += 2;
+		}
+	}
+	state->need_init = 0;
+	return 0;
+}
+
 static int mb86a20s_initfe(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	int rc;
 	u8  regD5 = 1;
 
+	if (state->config_regs)
+		return mb86a20s_regs_init(state);
+
 	dprintk("\n");
 
 	if (fe->ops.i2c_gate_ctrl)
@@ -593,6 +794,8 @@ struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 	/* setup the state */
 	state->config = config;
 	state->i2c = i2c;
+	state->config_regs_size = config->config_regs_size;
+	state->config_regs = config->config_regs;
 
 	/* create dvb_frontend */
 	memcpy(&state->frontend.ops, &mb86a20s_ops,
diff --git a/drivers/media/dvb/frontends/mb86a20s.h b/drivers/media/dvb/frontends/mb86a20s.h
index bf22e77..385d886 100644
--- a/drivers/media/dvb/frontends/mb86a20s.h
+++ b/drivers/media/dvb/frontends/mb86a20s.h
@@ -18,6 +18,104 @@
 
 #include <linux/dvb/frontend.h>
 
+/*
+ * These IDCFG are unique identifiers for registers that can be assigned new values.
+ * New identifiers may be added to this list in ascending order.
+ * The unique identifier that cannot have its value changed is REGNONE_IDCFG
+ * which must be equal to zero.
+ * The values for IDCFG must be between 0x01 and 0xff (8 bits), for while.
+ */
+#define REGNONE_IDCFG	0x00	/* do not change this ID */
+#define REG01_IDCFG	0x01
+#define REG0400_IDCFG	0x02
+#define REG0402_IDCFG	0x03
+#define REG0404_IDCFG	0x04
+#define REG0406_IDCFG	0x05
+#define REG0408_IDCFG	0x06
+#define REG0409_IDCFG	0x07
+#define REG040A_IDCFG	0x08
+#define REG040B_IDCFG	0x09
+#define REG040E_IDCFG	0x0a
+#define REG0412_IDCFG	0x0b
+#define REG0413_IDCFG	0x0c
+#define REG0414_IDCFG	0x0d
+#define REG0415_IDCFG	0x0e
+#define REG0416_IDCFG	0x0f
+#define REG041E_IDCFG	0x10
+#define REG0427_IDCFG	0x11
+#define REG0428_IDCFG	0x12
+#define REG0429_IDCFG	0x13
+#define REG0432_IDCFG	0x14
+#define REG0440_IDCFG	0x15
+#define REG09_IDCFG	0x16
+#define REG2800_IDCFG	0x17
+#define REG2805_IDCFG	0x18
+#define REG2806_IDCFG	0x19
+#define REG2807_IDCFG	0x1a
+#define REG2808_IDCFG	0x1b
+#define REG2809_IDCFG	0x1c
+#define REG280A_IDCFG	0x1d
+#define REG280B_IDCFG	0x1e
+#define REG280C_IDCFG	0x1f
+#define REG280D_IDCFG	0x20
+#define REG280E_IDCFG	0x21
+#define REG280F_IDCFG	0x22
+#define REG2810_IDCFG	0x23
+#define REG2811_IDCFG	0x24
+#define REG2812_IDCFG	0x25
+#define REG2813_IDCFG	0x26
+#define REG2814_IDCFG	0x27
+#define REG2815_IDCFG	0x28
+#define REG2816_IDCFG	0x29
+#define REG2817_IDCFG	0x2a
+#define REG2818_IDCFG	0x2b
+#define REG2819_IDCFG	0x2c
+#define REG281A_IDCFG	0x2d
+#define REG281B_IDCFG	0x2e
+#define REG281C_IDCFG	0x2f
+#define REG281D_IDCFG	0x30
+#define REG281E_IDCFG	0x31
+#define REG2820_IDCFG	0x32
+#define REG2822_IDCFG	0x33
+#define REG282A_IDCFG	0x34
+#define REG2846_IDCFG	0x35
+#define REG286A_IDCFG	0x36
+#define REG2874_IDCFG	0x37
+#define REG39_IDCFG	0x38
+#define REG3C_IDCFG	0x39
+#define REG45_IDCFG	0x3a
+#define REG501E_IDCFG	0x3b
+#define REG5022_IDCFG	0x3c
+#define REG5023_IDCFG	0x3d
+#define REG5024_IDCFG	0x3e
+#define REG5025_IDCFG	0x3f
+#define REG5026_IDCFG	0x40
+#define REG5027_IDCFG	0x41
+#define REG5039_IDCFG	0x42
+#define REG5050_IDCFG	0x43
+#define REG5051_IDCFG	0x44
+#define REG50A7_IDCFG	0x45
+#define REG50AA_IDCFG	0x46
+#define REG50AD_IDCFG	0x47
+#define REG50B0_IDCFG	0x48
+#define REG50B2_IDCFG	0x49
+#define REG50B4_IDCFG	0x4a
+#define REG50B6_IDCFG	0x4b
+#define REG50D1_IDCFG	0x4c
+#define REG50D2_IDCFG	0x4d
+#define REG50D5_IDCFG	0x4e
+#define REG50D6_IDCFG	0x4f
+#define REG50D7_IDCFG	0x50
+#define REG50DC_IDCFG	0x51
+#define REG50DE_IDCFG	0x52
+#define REG50E0_IDCFG	0x53
+#define REG71_IDCFG	0x54
+
+struct mb86a20s_config_regs_val {
+	u8 id_cfg;
+	u32 init_val;
+};
+
 /**
  * struct mb86a20s_config - Define the per-device attributes of the frontend
  *
@@ -27,6 +125,8 @@
 struct mb86a20s_config {
 	u8 demod_address;
 	bool is_serial;
+	int config_regs_size;
+	const struct mb86a20s_config_regs_val *config_regs;
 };
 
 #if defined(CONFIG_DVB_MB86A20S) || (defined(CONFIG_DVB_MB86A20S_MODULE) \
-- 
1.7.3.4


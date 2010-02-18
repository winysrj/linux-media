Return-path: <linux-media-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:40588 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab0BRMXZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 07:23:25 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.1/8.13.1) with ESMTP id o1ICNOXd030810
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2010 12:23:24 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o1ICNOXr1437800
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2010 13:23:24 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o1ICNNgp005110
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2010 13:23:24 +0100
Received: from dyn-9-152-222-36.boeblingen.de.ibm.com (dyn-9-152-222-36.boeblingen.de.ibm.com [9.152.222.36])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id o1ICNNS8005104
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2010 13:23:23 +0100
Message-Id: <1FD22C9F-BFD7-4267-B0FA-819AE36DF0D1@herrendoerfer.name>
From: "D. Herrendoerfer" <d.herrendoerfer@herrendoerfer.name>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: [PATCH] Add support for Samsung SMT7020S to cx88 driver
Date: Thu, 18 Feb 2010 13:23:23 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the built-in dvb device
of a Samsung SMT7020s (x86 based STB) to the cx88 family.
(see http://www.linuxtv.org/pipermail/linux-dvb/2007-January/015208.html)

Signed-off-by: Dirk Herrendoerfer <d.herrendoerfer@herrendoerfer.name>

diff -r 095b1aec2354 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Thu Feb 11 15:43:41  
2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Thu Feb 11 22:01:13  
2010 +0100
@@ -1499,6 +1499,18 @@
  			.audioroute = 8,
  		},
  	},
+	[CX88_BOARD_SAMSUNG_SMT_7020] = {
+		.name		= "Samsung SMT 7020 DVB-S",
+		.tuner_type	= TUNER_ABSENT,
+		.radio_type	= UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.input		= { {
+			.type	= CX88_VMUX_DVB,
+			.vmux	= 0,
+		} },
+		.mpeg           = CX88_MPEG_DVB,
+	},
  	[CX88_BOARD_ADSTECH_PTV_390] = {
  		.name           = "ADS Tech Instant Video PCI",
  		.tuner_type     = TUNER_ABSENT,
@@ -2388,6 +2400,14 @@
  		.subvendor = 0x0070,
  		.subdevice = 0x1404,
  		.card      = CX88_BOARD_HAUPPAUGE_HVR3000,
+	}, {
+		.subvendor = 0x18ac,
+		.subdevice = 0xdc00,
+		.card      = CX88_BOARD_SAMSUNG_SMT_7020,
+	}, {
+		.subvendor = 0x18ac,
+		.subdevice = 0xdccd,
+		.card      = CX88_BOARD_SAMSUNG_SMT_7020,
  	},{
  		.subvendor = 0x1461,
  		.subdevice = 0xc111, /* AverMedia M150-D */
@@ -2666,6 +2686,9 @@
  	case 98559: /* WinTV-HVR1100LP (Video no IR, Retail - Low Profile) */
  		/* known */
  		break;
+	case CX88_BOARD_SAMSUNG_SMT_7020:
+		cx_set(MO_GP0_IO, 0x008989FF);
+		break;
  	default:
  		warn_printk(core, "warning: unknown hauppauge model #%d\n",
  			    tv.model);
diff -r 095b1aec2354 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Thu Feb 11 15:43:41  
2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Thu Feb 11 22:01:13  
2010 +0100
@@ -681,6 +681,194 @@
  	return 0;
  }

+
+
+static u8 samsung_smt_7020_inittab[] = {
+	     0x01, 0x15,
+	     0x02, 0x00,
+	     0x03, 0x00,
+	     0x04, 0x7D,
+	     0x05, 0x0F,
+	     0x06, 0x02,
+	     0x07, 0x00,
+	     0x08, 0x60,
+
+	     0x0A, 0xC2,
+	     0x0B, 0x00,
+	     0x0C, 0x01,
+	     0x0D, 0x81,
+	     0x0E, 0x44,
+	     0x0F, 0x09,
+	     0x10, 0x3C,
+	     0x11, 0x84,
+	     0x12, 0xDA,
+	     0x13, 0x99,
+	     0x14, 0x8D,
+	     0x15, 0xCE,
+	     0x16, 0xE8,
+	     0x17, 0x43,
+	     0x18, 0x1C,
+	     0x19, 0x1B,
+	     0x1A, 0x1D,
+
+	     0x1C, 0x12,
+	     0x1D, 0x00,
+	     0x1E, 0x00,
+	     0x1F, 0x00,
+	     0x20, 0x00,
+	     0x21, 0x00,
+	     0x22, 0x00,
+	     0x23, 0x00,
+
+	     0x28, 0x02,
+	     0x29, 0x28,
+	     0x2A, 0x14,
+	     0x2B, 0x0F,
+	     0x2C, 0x09,
+	     0x2D, 0x05,
+
+	     0x31, 0x1F,
+	     0x32, 0x19,
+	     0x33, 0xFC,
+	     0x34, 0x13,
+	     0xff, 0xff,
+};
+
+
+static int samsung_smt_7020_tuner_set_params(struct dvb_frontend *fe,
+	struct dvb_frontend_parameters *params)
+{
+	struct cx8802_dev *dev = fe->dvb->priv;
+	u8 buf[4];
+	u32 div;
+	struct i2c_msg msg = {
+		.addr = 0x61,
+		.flags = 0,
+		.buf = buf,
+		.len = sizeof(buf) };
+
+	div = params->frequency / 125;
+
+	buf[0] = (div >> 8) & 0x7f;
+	buf[1] = div & 0xff;
+	buf[2] = 0x84;  /* 0xC4 */
+	buf[3] = 0x00;
+
+	if (params->frequency < 1500000)
+		buf[3] |= 0x10;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if (i2c_transfer(&dev->core->i2c_adap, &msg, 1) != 1)
+		return -EIO;
+
+	return 0;
+}
+
+static int samsung_smt_7020_set_tone(struct dvb_frontend *fe,
+	fe_sec_tone_mode_t tone)
+{
+	struct cx8802_dev *dev = fe->dvb->priv;
+	struct cx88_core *core = dev->core;
+
+	cx_set(MO_GP0_IO, 0x0800);
+
+	switch (tone) {
+	case SEC_TONE_ON:
+		cx_set(MO_GP0_IO, 0x08);
+		break;
+	case SEC_TONE_OFF:
+		cx_clear(MO_GP0_IO, 0x08);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int samsung_smt_7020_set_voltage(struct dvb_frontend *fe,
+	fe_sec_voltage_t voltage)
+{
+	struct cx8802_dev *dev = fe->dvb->priv;
+	struct cx88_core *core = dev->core;
+
+	u8 data;
+	struct i2c_msg msg = {
+		.addr = 8,
+		.flags = 0,
+		.buf = &data,
+		.len = sizeof(data) };
+
+	cx_set(MO_GP0_IO, 0x8000);
+
+	switch (voltage) {
+	case SEC_VOLTAGE_OFF:
+		break;
+	case SEC_VOLTAGE_13:
+		data = ISL6421_EN1 | ISL6421_LLC1;
+		cx_clear(MO_GP0_IO, 0x80);
+		break;
+	case SEC_VOLTAGE_18:
+		data = ISL6421_EN1 | ISL6421_LLC1 | ISL6421_VSEL1;
+		cx_clear(MO_GP0_IO, 0x80);
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	return (i2c_transfer(&dev->core->i2c_adap, &msg, 1) == 1) ? 0 : -EIO;
+}
+
+static int samsung_smt_7020_stv0299_set_symbol_rate(struct  
dvb_frontend *fe,
+	u32 srate, u32 ratio)
+{
+	u8 aclk = 0;
+	u8 bclk = 0;
+
+	if (srate < 1500000) {
+		aclk = 0xb7;
+		bclk = 0x47;
+	} else if (srate < 3000000) {
+		aclk = 0xb7;
+		bclk = 0x4b;
+	} else if (srate < 7000000) {
+		aclk = 0xb7;
+		bclk = 0x4f;
+	} else if (srate < 14000000) {
+		aclk = 0xb7;
+		bclk = 0x53;
+	} else if (srate < 30000000) {
+		aclk = 0xb6;
+		bclk = 0x53;
+	} else if (srate < 45000000) {
+		aclk = 0xb4;
+		bclk = 0x51;
+	}
+
+	stv0299_writereg(fe, 0x13, aclk);
+	stv0299_writereg(fe, 0x14, bclk);
+	stv0299_writereg(fe, 0x1f, (ratio >> 16) & 0xff);
+	stv0299_writereg(fe, 0x20, (ratio >>  8) & 0xff);
+	stv0299_writereg(fe, 0x21, ratio & 0xf0);
+
+	return 0;
+}
+
+
+static struct stv0299_config samsung_stv0299_config = {
+	.demod_address = 0x68,
+	.inittab = samsung_smt_7020_inittab,
+	.mclk = 88000000UL,
+	.invert = 0,
+	.skip_reinit = 0,
+	.lock_output = STV0299_LOCKOUTPUT_LK,
+	.volt13_op0_op1 = STV0299_VOLT13_OP1,
+	.min_delay_ms = 100,
+	.set_symbol_rate = samsung_smt_7020_stv0299_set_symbol_rate,
+};
+
  static int dvb_register(struct cx8802_dev *dev)
  {
  	struct cx88_core *core = dev->core;
@@ -1210,6 +1398,34 @@
  		}
  		break;
  		}
+	case CX88_BOARD_SAMSUNG_SMT_7020:
+		dev->ts_gen_cntrl = 0x08;
+
+		struct cx88_core *core = dev->core;
+
+		cx_set(MO_GP0_IO, 0x0101);
+
+		cx_clear(MO_GP0_IO, 0x01);
+		mdelay(100);
+		cx_set(MO_GP0_IO, 0x01);
+		mdelay(200);
+
+		fe0->dvb.frontend = dvb_attach(stv0299_attach,
+					&samsung_stv0299_config,
+					&dev->core->i2c_adap);
+		if (fe0->dvb.frontend) {
+			fe0->dvb.frontend->ops.tuner_ops.set_params =
+				samsung_smt_7020_tuner_set_params;
+			fe0->dvb.frontend->tuner_priv =
+				&dev->core->i2c_adap;
+			fe0->dvb.frontend->ops.set_voltage =
+				samsung_smt_7020_set_voltage;
+			fe0->dvb.frontend->ops.set_tone =
+				samsung_smt_7020_set_tone;
+		}
+
+		break;
+
  	default:
  		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card isn't  
supported yet\n",
  		       core->name);
diff -r 095b1aec2354 linux/drivers/media/video/cx88/cx88-mpeg.c
--- a/linux/drivers/media/video/cx88/cx88-mpeg.c	Thu Feb 11 15:43:41  
2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88-mpeg.c	Thu Feb 11 22:01:13  
2010 +0100
@@ -123,6 +123,9 @@
  		case CX88_BOARD_PCHDTV_HD5500:
  			cx_write(TS_SOP_STAT, 1<<13);
  			break;
+		case CX88_BOARD_SAMSUNG_SMT_7020:
+			cx_write(TS_SOP_STAT, 0x00);
+			break;
  		case CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1:
  		case CX88_BOARD_HAUPPAUGE_NOVASE2_S1:
  			cx_write(MO_PINMUX_IO, 0x88); /* Enable MPEG parallel IO and  
video signal pins */
diff -r 095b1aec2354 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Thu Feb 11 15:43:41 2010  
-0200
+++ b/linux/drivers/media/video/cx88/cx88.h	Thu Feb 11 22:01:13 2010  
+0100
@@ -240,6 +240,7 @@
  #define CX88_BOARD_WINFAST_DTV1800H        81
  #define CX88_BOARD_WINFAST_DTV2000H_J      82
  #define CX88_BOARD_PROF_7301               83
+#define CX88_BOARD_SAMSUNG_SMT_7020        84

  enum cx88_itype {
  	CX88_VMUX_COMPOSITE1 = 1,



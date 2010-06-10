Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnxtsmtp2.conexant.com ([198.62.9.253]:42231 "EHLO
	cnxtsmtp2.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab0FJEnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 00:43:35 -0400
Received: from cps (nbwsmx2.bbnet.ad [157.152.183.212]) (using TLSv1 with cipher RC4-MD5 (128/128
 bits)) (No client certificate requested) by cnxtsmtp2.conexant.com (Tumbleweed MailGate 3.7.1) with
 ESMTP id 2890D255820 for <linux-media@vger.kernel.org>; Wed, 9 Jun 2010 21:25:44 -0700 (PDT)
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>,
	"Jay Guillory" <Jay.Guillory@conexant.com>
Date: Wed, 9 Jun 2010 21:25:37 -0700
Subject: [cx231xx 1/2] Added support for s5h1432 demod
Message-ID: <34B38BE41EDBA046A4AFBB591FA31132F4B402@NBMBX01.bbnet.ad>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 53df9742b92902b5fa9d28b2dcc949cb495725a5 Mon Sep 17 00:00:00 2001
Message-Id: <53df9742b92902b5fa9d28b2dcc949cb495725a5.1276143429.git.palash.bandyopadhyay@conexant.com>
From: palash <palash.bandyopadhyay@conexant.com>
Date: Wed, 9 Jun 2010 21:13:17 -0700
Subject: [cx231xx 1/2] Added support for s5h1432 demod
To: linux-media@vger.kernel.org

Signed-off-by: palash <palash.bandyopadhyay@conexant.com>

 create mode 100644 drivers/media/dvb/frontends/s5h1432.c
 create mode 100644 drivers/media/dvb/frontends/s5h1432.h

diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index cd7f9b7..257c2fa 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -257,6 +257,13 @@ config DVB_CX22702
        help
          A DVB-T tuner module. Say Y when you want to support this frontend.

+config DVB_S5H1432
+       tristate "Samsung s5h1432 demodulator (OFDM)"
+       depends on DVB_CORE && I2C
+       default m if DVB_FE_CUSTOMISE
+       help
+         A DVB-T tuner module. Say Y when you want to support this frontend.
+
 config DVB_DRX397XD
        tristate "Micronas DRX3975D/DRX3977D based"
        depends on DVB_CORE && I2C
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index 874e8ad..faaa9aa 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_DVB_STB0899) += stb0899.o
 obj-$(CONFIG_DVB_STB6100) += stb6100.o
 obj-$(CONFIG_DVB_SP8870) += sp8870.o
 obj-$(CONFIG_DVB_CX22700) += cx22700.o
+obj-$(CONFIG_DVB_S5H1432) += s5h1432.o
 obj-$(CONFIG_DVB_CX24110) += cx24110.o
 obj-$(CONFIG_DVB_TDA8083) += tda8083.o
 obj-$(CONFIG_DVB_L64781) += l64781.o
diff --git a/drivers/media/dvb/frontends/s5h1432.c b/drivers/media/dvb/frontends/s5h1432.c
new file mode 100644
index 0000000..92d134e
--- /dev/null
+++ b/drivers/media/dvb/frontends/s5h1432.c
@@ -0,0 +1,446 @@
+/*
+    Samsung s5h1432 DVB-T demodulator driver
+
+    Copyright (C) 2009 Bill Liu <Bill.Liu@Conexant.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+*/
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include "dvb_frontend.h"
+#include "s5h1432.h"
+
+struct s5h1432_state {
+
+       struct i2c_adapter *i2c;
+
+       /* configuration settings */
+       const struct s5h1432_config *config;
+
+       struct dvb_frontend frontend;
+
+       fe_modulation_t current_modulation;
+       unsigned int first_tune:1;
+
+       u32 current_frequency;
+       int if_freq;
+
+       u8 inversion;
+};
+
+static int debug;
+
+#define dprintk(arg...) do {   \
+       if (debug)              \
+               printk(arg);    \
+       } while (0)
+
+
+static int s5h1432_writereg(struct s5h1432_state *state,
+       u8 addr, u8 reg, u8 data)
+{
+       int ret;
+       u8 buf[] = { reg, data };
+
+       struct i2c_msg msg = { .addr = addr, .flags = 0, .buf = buf, .len = 2 };
+
+       ret = i2c_transfer(state->i2c, &msg, 1);
+
+       if (ret != 1)
+               printk(KERN_ERR "%s: writereg error 0x%02x 0x%02x 0x%04x, "
+                      "ret == %i)\n", __func__, addr, reg, data, ret);
+
+       return (ret != 1) ? -1 : 0;
+}
+
+static u8 s5h1432_readreg(struct s5h1432_state *state, u8 addr, u8 reg)
+{
+       int ret;
+       u8 b0[] = { reg };
+       u8 b1[] = { 0 };
+
+       struct i2c_msg msg[] = {
+               { .addr = addr, .flags = 0, .buf = b0, .len = 1 },
+               { .addr = addr, .flags = I2C_M_RD, .buf = b1, .len = 1 } };
+
+       ret = i2c_transfer(state->i2c, msg, 2);
+
+       if (ret != 2)
+               printk(KERN_ERR "%s: readreg error (ret == %i)\n",
+                       __func__, ret);
+       return b1[0];
+}
+
+static int s5h1432_sleep(struct dvb_frontend *fe)
+{
+       return 0;
+}
+
+static int s5h1432_set_channel_bandwidth(struct dvb_frontend *fe, u32 bandwidth)
+{
+
+       struct s5h1432_state *state = fe->demodulator_priv;
+
+       u8 reg = 0;
+
+
+    /* Register        [0x2E] bit 3:2 : 8MHz = 0; 7MHz = 1; 6MHz = 2*/
+       reg = s5h1432_readreg(state, S5H1432_I2C_TOP_ADDR, 0x2E);
+       reg &= ~(0x0C);
+       switch (bandwidth) {
+       case 6:
+               reg |= 0x08;
+               break;
+       case 7:
+               reg |= 0x04;
+               break;
+       case 8:
+               reg |= 0x00;
+               break;
+       default:
+       return 0;
+       }
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x2E, reg);
+    return 1;
+}
+
+static int s5h1432_set_IF(struct dvb_frontend *fe, u32 ifFreqHz)
+{
+
+       struct s5h1432_state *state = fe->demodulator_priv;
+
+       switch (ifFreqHz) {
+       case TAIWAN_HI_IF_FREQ_44_MHZ:
+               {
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe4 , 0x55);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe5 , 0x55);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe7 , 0x15);
+                   break;
+               }
+       case EUROPE_HI_IF_FREQ_36_MHZ:
+               {
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe4 , 0x00);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe5 , 0x00);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe7 , 0x40);
+                   break;
+               }
+       case IF_FREQ_6_MHZ:
+               {
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe4 , 0x00);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe5 , 0x00);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe7 , 0xe0);
+                   break;
+               }
+       case IF_FREQ_3point3_MHZ:
+               {
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe4 , 0x66);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe5 , 0x66);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe7 , 0xEE);
+                   break;
+               }
+       case IF_FREQ_3point5_MHZ:
+               {
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe4 , 0x55);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe5 , 0x55);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe7 , 0xED);
+                   break;
+               }
+       case IF_FREQ_4_MHZ:
+               {
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe4 , 0xAA);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe5 , 0xAA);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe7 , 0xEA);
+                   break;
+               }
+       default:
+               {
+               u32 value = 0;
+               value = (u32) (((48000 - (ifFreqHz / 1000)) * 512 *
+                                (u32) 32768) / (48 * 1000));
+               printk(KERN_INFO "Default IFFreq %d :reg value = 0x%x \n",
+                                ifFreqHz, value);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe4 ,
+                                (u8) value & 0xFF);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe5 ,
+                                (u8)(value>>8) & 0xFF);
+                   s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe7 ,
+                                (u8)(value>>16) & 0xFF);
+                   break;
+       }
+
+       }
+
+    return 1;
+}
+
+/* Talk to the demod, set the FEC, GUARD, QAM settings etc */
+static int s5h1432_set_frontend(struct dvb_frontend *fe,
+       struct dvb_frontend_parameters *p)
+{
+       u32 dvb_bandwidth = 8;
+       struct s5h1432_state *state = fe->demodulator_priv;
+
+       if (p->frequency == state->current_frequency) {
+               /*current_frequency = p->frequency;*/
+               /*state->current_frequency = p->frequency;*/
+       } else {
+               fe->ops.tuner_ops.set_params(fe, p); msleep(300);
+               s5h1432_set_channel_bandwidth(fe, dvb_bandwidth);
+               switch (p->u.ofdm.bandwidth) {
+               case BANDWIDTH_6_MHZ:
+                               dvb_bandwidth = 6;
+                               s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
+                               break;
+               case BANDWIDTH_7_MHZ:
+                               dvb_bandwidth = 7;
+                               s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
+                               break;
+               case BANDWIDTH_8_MHZ:
+                               dvb_bandwidth = 8;
+                               s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
+                               break;
+               default:
+                               return 0;
+                       }
+               /*fe->ops.tuner_ops.set_params(fe, p);*/
+/*Soft Reset chip*/
+       msleep(30);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x09,     0x1a);
+       msleep(30);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x09,     0x1b);
+
+
+               s5h1432_set_channel_bandwidth(fe, dvb_bandwidth);
+               switch (p->u.ofdm.bandwidth) {
+               case BANDWIDTH_6_MHZ:
+                               dvb_bandwidth = 6;
+                               s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
+                               break;
+               case BANDWIDTH_7_MHZ:
+                               dvb_bandwidth = 7;
+                               s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
+                               break;
+               case BANDWIDTH_8_MHZ:
+                               dvb_bandwidth = 8;
+                               s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
+                               break;
+               default:
+                               return 0;
+                       }
+               /*fe->ops.tuner_ops.set_params(fe,p);*/
+/*Soft Reset chip*/
+       msleep(30);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x09,     0x1a);
+       msleep(30);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x09,     0x1b);
+
+       }
+
+       state->current_frequency = p->frequency;
+
+       return 0;
+}
+
+
+static int s5h1432_init(struct dvb_frontend *fe)
+{
+       struct s5h1432_state *state = fe->demodulator_priv;
+
+       u8 reg = 0;
+       state->current_frequency = 0;
+       printk(KERN_INFO " s5h1432_init().\n");
+
+
+    /*Set VSB mode as default, this also does a soft reset*/
+    /*Initialize registers*/
+
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x04,     0xa8);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x05,     0x01);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x07,     0x70);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x19,     0x80);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x1b,     0x9D);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x1c,     0x30);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x1d,     0x20);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x1e,     0x1B);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x2e,     0x40);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x42,     0x84);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x50,     0x5a);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x5a,     0xd3);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x68,     0x50);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xb8,     0x3c);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xc4,     0x10);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xcc,     0x9c);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xDA,     0x00);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe1,     0x94);
+/*     s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xf4,     0xa1);*/
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xf9,     0x00);
+
+/*For NXP tuner*/
+
+    /*Set 3.3MHz as default IF frequency*/
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe4 , 0x66);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe5 , 0x66);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0xe7 , 0xEE);
+    /* Set reg 0x1E to get the full dynamic range */
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x1e,     0x31);
+
+/*Mode setting in demod*/
+       reg = s5h1432_readreg(state, S5H1432_I2C_TOP_ADDR, 0x42);
+       reg |= 0x80;
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x42, reg);
+       /*Serial mode*/
+
+/*Soft Reset chip*/
+
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x09,     0x1a);
+       msleep(30);
+       s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x09,     0x1b);
+
+#if 0
+       for (i = 0; i < 0xFF; i++) {
+               reg = s5h1432_readreg(state, S5H1432_I2C_TOP_ADDR, i);
+               printk(KERN_INFO " @@@@@ reg 0x%x=0x%x\n", i, reg);
+       }
+#endif
+
+       return 0;
+}
+
+
+static int s5h1432_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+       return 0;
+}
+
+
+
+static int s5h1432_read_signal_strength(struct dvb_frontend *fe,
+       u16 *signal_strength)
+{
+       return 0;
+}
+
+static int s5h1432_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+       return 0;
+}
+
+static int s5h1432_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+
+       return 0;
+}
+
+static int s5h1432_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+       return 0;
+}
+
+static int s5h1432_get_frontend(struct dvb_frontend *fe,
+                               struct dvb_frontend_parameters *p)
+{
+       return 0;
+}
+
+static int s5h1432_get_tune_settings(struct dvb_frontend *fe,
+                                    struct dvb_frontend_tune_settings *tune)
+{
+       return 0;
+}
+
+static void s5h1432_release(struct dvb_frontend *fe)
+{
+       struct s5h1432_state *state = fe->demodulator_priv;
+       kfree(state);
+}
+
+static struct dvb_frontend_ops s5h1432_ops;
+
+struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
+                                   struct i2c_adapter *i2c)
+{
+       struct s5h1432_state *state = NULL;
+
+       printk(KERN_INFO " Enter s5h1432_attach(). attach success!\n");
+       /* allocate memory for the internal state */
+       state = kmalloc(sizeof(struct s5h1432_state), GFP_KERNEL);
+       if (state == NULL)
+               goto error;
+
+       /* setup the state */
+       state->config = config;
+       state->i2c = i2c;
+       state->current_modulation = QAM_16;
+       state->inversion = state->config->inversion;
+
+       /* create dvb_frontend */
+       memcpy(&state->frontend.ops, &s5h1432_ops,
+              sizeof(struct dvb_frontend_ops));
+
+       state->frontend.demodulator_priv = state;
+
+       return &state->frontend;
+
+error:
+       kfree(state);
+       return NULL;
+}
+EXPORT_SYMBOL(s5h1432_attach);
+
+static struct dvb_frontend_ops s5h1432_ops = {
+
+       .info = {
+               .name                   = "Samsung s5h1432 DVB-T Frontend",
+               .type                   = FE_OFDM,
+               .frequency_min          = 177000000,
+               .frequency_max          = 858000000,
+               .frequency_stepsize     = 166666,
+               .caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+               FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
+               FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
+               FE_CAN_HIERARCHY_AUTO | FE_CAN_GUARD_INTERVAL_AUTO |
+               FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_RECOVER
+       },
+
+       .init                 = s5h1432_init,
+       .sleep                = s5h1432_sleep,
+       .set_frontend         = s5h1432_set_frontend,
+       .get_frontend         = s5h1432_get_frontend,
+       .get_tune_settings    = s5h1432_get_tune_settings,
+       .read_status          = s5h1432_read_status,
+       .read_ber             = s5h1432_read_ber,
+       .read_signal_strength = s5h1432_read_signal_strength,
+       .read_snr             = s5h1432_read_snr,
+       .read_ucblocks        = s5h1432_read_ucblocks,
+       .release              = s5h1432_release,
+};
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Enable verbose debug messages");
+
+MODULE_DESCRIPTION("Samsung s5h1432 DVB-T Demodulator driver");
+MODULE_AUTHOR("Bill Liu");
+MODULE_LICENSE("GPL");
+
+/*
+ * Local variables:
+ * c-basic-offset: 8
+ */
diff --git a/drivers/media/dvb/frontends/s5h1432.h b/drivers/media/dvb/frontends/s5h1432.h
new file mode 100644
index 0000000..241a904
--- /dev/null
+++ b/drivers/media/dvb/frontends/s5h1432.h
@@ -0,0 +1,96 @@
+/*
+    Samsung s5h1432 VSB/QAM demodulator driver
+
+    Copyright (C) 2009 Bill Liu <Bill.Liu@Conexant.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+*/
+
+#ifndef __S5H1432_H__
+#define __S5H1432_H__
+
+#include <linux/dvb/frontend.h>
+
+#define S5H1432_I2C_TOP_ADDR (0x02 >> 1)
+
+#define TAIWAN_HI_IF_FREQ_44_MHZ 44000000
+#define EUROPE_HI_IF_FREQ_36_MHZ 36000000
+#define IF_FREQ_6_MHZ             6000000
+#define IF_FREQ_3point3_MHZ       3300000
+#define IF_FREQ_3point5_MHZ       3500000
+#define IF_FREQ_4_MHZ             4000000
+
+struct s5h1432_config {
+
+       /* serial/parallel output */
+#define S5H1432_PARALLEL_OUTPUT 0
+#define S5H1432_SERIAL_OUTPUT   1
+       u8 output_mode;
+
+       /* GPIO Setting */
+#define S5H1432_GPIO_OFF 0
+#define S5H1432_GPIO_ON  1
+       u8 gpio;
+
+       /* MPEG signal timing */
+#define S5H1432_MPEGTIMING_CONTINOUS_INVERTING_CLOCK       0
+#define S5H1432_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK    1
+#define S5H1432_MPEGTIMING_NONCONTINOUS_INVERTING_CLOCK    2
+#define S5H1432_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK 3
+       u16 mpeg_timing;
+
+       /* IF Freq for QAM and VSB in KHz */
+#define S5H1432_IF_3250  3250
+#define S5H1432_IF_3500  3500
+#define S5H1432_IF_4000  4000
+#define S5H1432_IF_5380  5380
+#define S5H1432_IF_44000 44000
+#define S5H1432_VSB_IF_DEFAULT s5h1432_IF_44000
+#define S5H1432_QAM_IF_DEFAULT s5h1432_IF_44000
+       u16 qam_if;
+       u16 vsb_if;
+
+       /* Spectral Inversion */
+#define S5H1432_INVERSION_OFF 0
+#define S5H1432_INVERSION_ON  1
+       u8 inversion;
+
+       /* Return lock status based on tuner lock, or demod lock */
+#define S5H1432_TUNERLOCKING 0
+#define S5H1432_DEMODLOCKING 1
+       u8 status_mode;
+};
+
+#if defined(CONFIG_DVB_S5H1432) || \
+       (defined(CONFIG_DVB_S5H1432_MODULE) && defined(MODULE))
+extern struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
+                                          struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *s5h1432_attach(
+       const struct s5h1432_config *config,
+       struct i2c_adapter *i2c)
+{
+       printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+       return NULL;
+}
+#endif /* CONFIG_DVB_s5h1432 */
+
+#endif /* __s5h1432_H__ */
+
+/*
+ * Local variables:
+ * c-basic-offset: 8
+ */
--
1.7.0.4


Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------


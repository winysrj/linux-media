Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbbLURDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 12:03:32 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Jiri Kosina <jkosina@suse.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH v2] [media] au8522: Avoid memory leak for device config data
Date: Mon, 21 Dec 2015 15:02:51 -0200
Message-Id: <177d26a15571eba1a797ec1e2f2392acd2fadd0d.1450717344.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by kmemleak:

	unreferenced object 0xffff880321e1da40 (size 32):
	  comm "modprobe", pid 3309, jiffies 4295019569 (age 2359.636s)
	  hex dump (first 32 bytes):
	    47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  G...............
	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	  backtrace:
	    [<ffffffff82278c8e>] kmemleak_alloc+0x4e/0xb0
	    [<ffffffff8153c08c>] kmem_cache_alloc_trace+0x1ec/0x280
	    [<ffffffffa13a896a>] au8522_probe+0x19a/0xa30 [au8522_decoder]
	    [<ffffffff81de0032>] i2c_device_probe+0x2b2/0x490
	    [<ffffffff81ca7004>] driver_probe_device+0x454/0xd90
	    [<ffffffff81ca7c1b>] __device_attach_driver+0x17b/0x230
	    [<ffffffff81ca15da>] bus_for_each_drv+0x11a/0x1b0
	    [<ffffffff81ca6a4d>] __device_attach+0x1cd/0x2c0
	    [<ffffffff81ca7d43>] device_initial_probe+0x13/0x20
	    [<ffffffff81ca451f>] bus_probe_device+0x1af/0x250
	    [<ffffffff81c9e0f3>] device_add+0x943/0x13b0
	    [<ffffffff81c9eb7a>] device_register+0x1a/0x20
	    [<ffffffff81de8626>] i2c_new_device+0x5d6/0x8f0
	    [<ffffffffa0d88ea4>] v4l2_i2c_new_subdev_board+0x1e4/0x250 [v4l2_common]
	    [<ffffffffa0d88fe7>] v4l2_i2c_new_subdev+0xd7/0x110 [v4l2_common]
	    [<ffffffffa13b2f76>] au0828_card_analog_fe_setup+0x2e6/0x3f0 [au0828]

Checking where the error happens:
	(gdb) list *au8522_probe+0x19a
	0x99a is in au8522_probe (drivers/media/dvb-frontends/au8522_decoder.c:761).
	756			printk(KERN_INFO "au8522_decoder attach existing instance.\n");
	757			break;
	758		}
	759
	760		demod_config = kzalloc(sizeof(struct au8522_config), GFP_KERNEL);
	761		if (demod_config == NULL) {
	762			if (instance == 1)
	763				kfree(state);
	764			return -ENOMEM;
	765		}

Shows that the error path is not being handled properly.

The are actually several issues here:

1) config free should have been calling hybrid_tuner_release_state()
function, by calling au8522_release_state();

2) config is only allocated at the digital part. On the analog one,
it is received from the caller.

A complex logic could be added to address it, however, it is simpler
to just embeed config inside the state.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/au8522_common.c  | 10 +++++-----
 drivers/media/dvb-frontends/au8522_decoder.c | 10 +---------
 drivers/media/dvb-frontends/au8522_dig.c     | 16 ++++++++--------
 drivers/media/dvb-frontends/au8522_priv.h    |  2 +-
 4 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_common.c b/drivers/media/dvb-frontends/au8522_common.c
index 3559ff230045..f135126bc373 100644
--- a/drivers/media/dvb-frontends/au8522_common.c
+++ b/drivers/media/dvb-frontends/au8522_common.c
@@ -44,7 +44,7 @@ int au8522_writereg(struct au8522_state *state, u16 reg, u8 data)
 	int ret;
 	u8 buf[] = { (reg >> 8) | 0x80, reg & 0xff, data };
 
-	struct i2c_msg msg = { .addr = state->config->demod_address,
+	struct i2c_msg msg = { .addr = state->config.demod_address,
 			       .flags = 0, .buf = buf, .len = 3 };
 
 	ret = i2c_transfer(state->i2c, &msg, 1);
@@ -64,9 +64,9 @@ u8 au8522_readreg(struct au8522_state *state, u16 reg)
 	u8 b1[] = { 0 };
 
 	struct i2c_msg msg[] = {
-		{ .addr = state->config->demod_address, .flags = 0,
+		{ .addr = state->config.demod_address, .flags = 0,
 		  .buf = b0, .len = 2 },
-		{ .addr = state->config->demod_address, .flags = I2C_M_RD,
+		{ .addr = state->config.demod_address, .flags = I2C_M_RD,
 		  .buf = b1, .len = 1 } };
 
 	ret = i2c_transfer(state->i2c, msg, 2);
@@ -140,7 +140,7 @@ EXPORT_SYMBOL(au8522_release_state);
 
 static int au8522_led_gpio_enable(struct au8522_state *state, int onoff)
 {
-	struct au8522_led_config *led_config = state->config->led_cfg;
+	struct au8522_led_config *led_config = state->config.led_cfg;
 	u8 val;
 
 	/* bail out if we can't control an LED */
@@ -170,7 +170,7 @@ static int au8522_led_gpio_enable(struct au8522_state *state, int onoff)
  */
 int au8522_led_ctrl(struct au8522_state *state, int led)
 {
-	struct au8522_led_config *led_config = state->config->led_cfg;
+	struct au8522_led_config *led_config = state->config.led_cfg;
 	int i, ret = 0;
 
 	/* bail out if we can't control an LED */
diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 28d7dc2fee34..b3502a6191ba 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -754,15 +754,7 @@ static int au8522_probe(struct i2c_client *client,
 		break;
 	}
 
-	demod_config = kzalloc(sizeof(struct au8522_config), GFP_KERNEL);
-	if (demod_config == NULL) {
-		if (instance == 1)
-			kfree(state);
-		return -ENOMEM;
-	}
-	demod_config->demod_address = 0x8e >> 1;
-
-	state->config = demod_config;
+	state->config.demod_address = 0x8e >> 1;
 	state->i2c = client->adapter;
 
 	sd = &state->sd;
diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index f956f13fb3dc..6c1e97640f3f 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -566,7 +566,7 @@ static int au8522_enable_modulation(struct dvb_frontend *fe,
 			au8522_writereg(state,
 				VSB_mod_tab[i].reg,
 				VSB_mod_tab[i].data);
-		au8522_set_if(fe, state->config->vsb_if);
+		au8522_set_if(fe, state->config.vsb_if);
 		break;
 	case QAM_64:
 		dprintk("%s() QAM 64\n", __func__);
@@ -574,7 +574,7 @@ static int au8522_enable_modulation(struct dvb_frontend *fe,
 			au8522_writereg(state,
 				QAM64_mod_tab[i].reg,
 				QAM64_mod_tab[i].data);
-		au8522_set_if(fe, state->config->qam_if);
+		au8522_set_if(fe, state->config.qam_if);
 		break;
 	case QAM_256:
 		if (zv_mode) {
@@ -583,7 +583,7 @@ static int au8522_enable_modulation(struct dvb_frontend *fe,
 				au8522_writereg(state,
 					QAM256_mod_tab_zv_mode[i].reg,
 					QAM256_mod_tab_zv_mode[i].data);
-			au8522_set_if(fe, state->config->qam_if);
+			au8522_set_if(fe, state->config.qam_if);
 			msleep(100);
 			au8522_writereg(state, 0x821a, 0x00);
 		} else {
@@ -592,7 +592,7 @@ static int au8522_enable_modulation(struct dvb_frontend *fe,
 				au8522_writereg(state,
 					QAM256_mod_tab[i].reg,
 					QAM256_mod_tab[i].data);
-			au8522_set_if(fe, state->config->qam_if);
+			au8522_set_if(fe, state->config.qam_if);
 		}
 		break;
 	default:
@@ -666,7 +666,7 @@ static int au8522_read_status(struct dvb_frontend *fe, enum fe_status *status)
 			*status |= FE_HAS_LOCK | FE_HAS_SYNC;
 	}
 
-	switch (state->config->status_mode) {
+	switch (state->config.status_mode) {
 	case AU8522_DEMODLOCKING:
 		dprintk("%s() DEMODLOCKING\n", __func__);
 		if (*status & FE_HAS_VITERBI)
@@ -704,7 +704,7 @@ static int au8522_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 static int au8522_led_status(struct au8522_state *state, const u16 *snr)
 {
-	struct au8522_led_config *led_config = state->config->led_cfg;
+	struct au8522_led_config *led_config = state->config.led_cfg;
 	int led;
 	u16 strong;
 
@@ -758,7 +758,7 @@ static int au8522_read_snr(struct dvb_frontend *fe, u16 *snr)
 					    au8522_readreg(state, 0x4311),
 					    snr);
 
-	if (state->config->led_cfg)
+	if (state->config.led_cfg)
 		au8522_led_status(state, snr);
 
 	return ret;
@@ -866,7 +866,7 @@ struct dvb_frontend *au8522_attach(const struct au8522_config *config,
 	}
 
 	/* setup the state */
-	state->config = config;
+	state->config = *config;
 	state->i2c = i2c;
 	state->operational_mode = AU8522_DIGITAL_MODE;
 
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index 951b3847e6f6..ee330c61aa61 100644
--- a/drivers/media/dvb-frontends/au8522_priv.h
+++ b/drivers/media/dvb-frontends/au8522_priv.h
@@ -50,7 +50,7 @@ struct au8522_state {
 	struct list_head hybrid_tuner_instance_list;
 
 	/* configuration settings */
-	const struct au8522_config *config;
+	struct au8522_config config;
 
 	struct dvb_frontend frontend;
 
-- 
2.5.0



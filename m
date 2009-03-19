Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2717 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZCSUYz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 16:24:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEWv2] bttv v4l2_subdev conversion
Date: Thu, 19 Mar 2009 21:24:52 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903192124.52524.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here is the revised bttv v4l2_subdev conversion, taking into account all
the input I received.

The tree is here: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-bttv

Short changelog:

- tvaudio: fix mute and s/g_tuner handling
- tvaudio: add tda9875 support.
- tvaudio: always call init_timer to prevent rmmod crash.
- bttv: convert to v4l2_subdev since i2c autoprobing will disappear.

The tvaudio patches are the same as before, except split into two and a
third bug fix (init_timer) was added that I found while testing.

I've included the bttv patch below for easier reviewing.

Please note that the somewhat awkward i2c address lists are temporary.
When all drivers that need it are converted to v4l2_subdev I'll do a
sweep over all of them and clean this up. I want to wait with this until
I have a good overview of how it is used and who needs it.

In addition there are a few conversions in progress as well, so changing
APIs while that's still ongoing is something I want to avoid.

Regards,

	Hans



# HG changeset patch
# User Hans Verkuil <hverkuil@xs4all.nl>
# Date 1237493753 -3600
# Node ID 68050e782acbe6c47e3e3c0530ed1d96f0ec651f
# Parent  7191463177cdbf2ab1f2ade8eb3aa7dcad8cc80e
bttv: convert to v4l2_subdev since i2c autoprobing will disappear.

From: Hans Verkuil <hverkuil@xs4all.nl>

Since i2c autoprobing will disappear bttv needs to be converted to use
v4l2_subdev instead.

Without autoprobing the autoload module option has become obsolete. A warning
is generated if it is set, but it is otherwise ignored.

Since the bttv card definitions are of questionable value three new options
were added to allow the user to control which audio module is selected:
msp3400, tda7432 or tvaudio.

By default bttv will use the card definitions and fallback on tvaudio as the
last resort.

If no audio device was found a warning is printed.

The saa6588 RDS device is now also explicitly probed since it is no longer
possible to autoprobe it. A new saa6588 module option was added to override
the card definition since I suspect more cards have this device than one
would guess from the card definitions.

Priority: normal

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

diff -r 7191463177cd -r 68050e782acb linux/drivers/media/video/bt8xx/bttv-cards.c
--- a/linux/drivers/media/video/bt8xx/bttv-cards.c	Thu Mar 19 20:53:32 2009 +0100
+++ b/linux/drivers/media/video/bt8xx/bttv-cards.c	Thu Mar 19 21:15:53 2009 +0100
@@ -97,12 +97,12 @@
 static unsigned int tuner[BTTV_MAX]  = { [ 0 ... (BTTV_MAX-1) ] = UNSET };
 static unsigned int svhs[BTTV_MAX]   = { [ 0 ... (BTTV_MAX-1) ] = UNSET };
 static unsigned int remote[BTTV_MAX] = { [ 0 ... (BTTV_MAX-1) ] = UNSET };
+static unsigned int msp3400[BTTV_MAX];
+static unsigned int tda7432[BTTV_MAX];
+static unsigned int tvaudio[BTTV_MAX];
+static unsigned int saa6588[BTTV_MAX];
 static struct bttv  *master[BTTV_MAX] = { [ 0 ... (BTTV_MAX-1) ] = NULL };
-#ifdef MODULE
-static unsigned int autoload = 1;
-#else
-static unsigned int autoload;
-#endif
+static unsigned int autoload = UNSET;
 static unsigned int gpiomask = UNSET;
 static unsigned int audioall = UNSET;
 static unsigned int audiomux[5] = { [ 0 ... 4 ] = UNSET };
@@ -121,6 +121,9 @@
 module_param_array(tuner,    int, NULL, 0444);
 module_param_array(svhs,     int, NULL, 0444);
 module_param_array(remote,   int, NULL, 0444);
+module_param_array(msp3400,  int, NULL, 0444);
+module_param_array(tda7432,  int, NULL, 0444);
+module_param_array(tvaudio,  int, NULL, 0444);
 module_param_array(audiomux, int, NULL, 0444);
 
 MODULE_PARM_DESC(triton1,"set ETBF pci config bit "
@@ -131,7 +134,11 @@
 MODULE_PARM_DESC(card,"specify TV/grabber card model, see CARDLIST file for a list");
 MODULE_PARM_DESC(pll,"specify installed crystal (0=none, 28=28 MHz, 35=35 MHz)");
 MODULE_PARM_DESC(tuner,"specify installed tuner type");
-MODULE_PARM_DESC(autoload,"automatically load i2c modules like tuner.o, default is 1 (yes)");
+MODULE_PARM_DESC(autoload,"obsolete option, please do not use anymore");
+MODULE_PARM_DESC(msp3400, "if 1, then load msp3400 only, default (0) is to use the card definition.");
+MODULE_PARM_DESC(tda7432, "if 1, then load tda7432 only, default (0) is to use the card definition.");
+MODULE_PARM_DESC(tvaudio, "if 1, then load tvaudio only, default (0) is to use the card definition.");
+MODULE_PARM_DESC(saa6588, "if 1, then load the saa6588 RDS module, default (0) is to use the card definition.");
 MODULE_PARM_DESC(no_overlay,"allow override overlay default (0 disables, 1 enables)"
 		" [some VIA/SIS chipsets are known to have problem with overlay]");
 
@@ -3332,9 +3339,21 @@
 /* initialization part two -- after registering i2c bus */
 void __devinit bttv_init_card2(struct bttv *btv)
 {
+	static const unsigned short tvaudio_addrs[] = {
+		I2C_ADDR_TDA8425   >> 1,
+		I2C_ADDR_TEA6300   >> 1,
+		I2C_ADDR_TEA6420   >> 1,
+		I2C_ADDR_TDA9840   >> 1,
+		I2C_ADDR_TDA985x_L >> 1,
+		I2C_ADDR_TDA985x_H >> 1,
+		I2C_ADDR_TDA9874   >> 1,
+		I2C_ADDR_PIC16C54  >> 1,
+		I2C_CLIENT_END
+	};
 	int addr=ADDR_UNSET;
 
 	btv->tuner_type = UNSET;
+	btv->has_saa6588 = bttv_tvcards[btv->c.type].has_saa6588;
 
 	if (BTTV_BOARD_UNKNOWN == btv->c.type) {
 		bttv_readee(btv,eeprom_data,0xa0);
@@ -3495,6 +3514,12 @@
 		printk(KERN_INFO "bttv%d: tuner type=%d\n", btv->c.nr,
 		       btv->tuner_type);
 
+	if (autoload != UNSET) {
+		printk(KERN_WARNING "bttv%d: the autoload option is obsolete.\n", btv->c.nr);
+		printk(KERN_WARNING "bttv%d: use option msp3400, tda7432 or tvaudio to\n", btv->c.nr);
+		printk(KERN_WARNING "bttv%d: override which audio module should be used.\n", btv->c.nr);
+	}
+
 	if (UNSET == btv->tuner_type)
 		btv->tuner_type = TUNER_ABSENT;
 
@@ -3502,8 +3527,13 @@
 		struct tuner_setup tun_setup;
 
 		/* Load tuner module before issuing tuner config call! */
-		if (autoload)
-			request_module("tuner");
+		if (bttv_tvcards[btv->c.type].has_radio)
+			v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
+				"tuner", "tuner", v4l2_i2c_tuner_addrs(ADDRS_RADIO));
+		v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap, "tuner",
+				"tuner", v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
+		v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap, "tuner",
+				"tuner", v4l2_i2c_tuner_addrs(ADDRS_TV_WITH_DEMOD));
 
 		tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
 		tun_setup.type = btv->tuner_type;
@@ -3512,7 +3542,7 @@
 		if (bttv_tvcards[btv->c.type].has_radio)
 			tun_setup.mode_mask |= T_RADIO;
 
-		bttv_call_i2c_clients(btv, TUNER_SET_TYPE_ADDR, &tun_setup);
+		bttv_call_all(btv, tuner, s_type_addr, &tun_setup);
 	}
 
 	if (btv->tda9887_conf) {
@@ -3521,7 +3551,7 @@
 		tda9887_cfg.tuner = TUNER_TDA9887;
 		tda9887_cfg.priv = &btv->tda9887_conf;
 
-		bttv_call_i2c_clients(btv, TUNER_SET_CONFIG, &tda9887_cfg);
+		bttv_call_all(btv, tuner, s_config, &tda9887_cfg);
 	}
 
 	btv->dig = bttv_tvcards[btv->c.type].has_dig_in ?
@@ -3544,31 +3574,110 @@
 	if (bttv_tvcards[btv->c.type].audio_mode_gpio)
 		btv->audio_mode_gpio=bttv_tvcards[btv->c.type].audio_mode_gpio;
 
-	if (!autoload)
-		return;
-
 	if (btv->tuner_type == TUNER_ABSENT)
 		return;  /* no tuner or related drivers to load */
 
+	if (btv->has_saa6588 || saa6588[btv->c.nr]) {
+		/* Probe for RDS receiver chip */
+		static const unsigned short addrs[] = {
+			0x20 >> 1,
+			0x22 >> 1,
+			I2C_CLIENT_END
+		};
+
+		btv->sd_saa6588 = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
+				"saa6588", "saa6588", addrs);
+	}
+
 	/* try to detect audio/fader chips */
-	if (!bttv_tvcards[btv->c.type].no_msp34xx &&
-	    bttv_I2CRead(btv, I2C_ADDR_MSP3400, "MSP34xx") >=0)
-		request_module("msp3400");
-
-	if (bttv_tvcards[btv->c.type].msp34xx_alt &&
-	    bttv_I2CRead(btv, I2C_ADDR_MSP3400_ALT, "MSP34xx (alternate address)") >=0)
-		request_module("msp3400");
-
-	if (!bttv_tvcards[btv->c.type].no_tda9875 &&
-	    bttv_I2CRead(btv, I2C_ADDR_TDA9875, "TDA9875") >=0)
-		request_module("tda9875");
-
-	if (!bttv_tvcards[btv->c.type].no_tda7432 &&
-	    bttv_I2CRead(btv, I2C_ADDR_TDA7432, "TDA7432") >=0)
-		request_module("tda7432");
-
-	if (bttv_tvcards[btv->c.type].needs_tvaudio)
-		request_module("tvaudio");
+
+	/* First check if the user specified the audio chip via a module
+	   option. */
+
+	if (msp3400[btv->c.nr]) {
+		/* The user specified that we should probe for msp3400 */
+		static const unsigned short addrs[] = {
+			I2C_ADDR_MSP3400 >> 1,
+			I2C_ADDR_MSP3400_ALT >> 1,
+			I2C_CLIENT_END
+		};
+
+		btv->sd_msp34xx = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
+				"msp3400", "msp3400", addrs);
+		if (btv->sd_msp34xx)
+			return;
+		goto no_audio;
+	}
+	if (tda7432[btv->c.nr]) {
+		/* The user specified that we should probe for tda7432 */
+		static const unsigned short addrs[] = {
+			I2C_ADDR_TDA7432 >> 1,
+			I2C_CLIENT_END
+		};
+
+		if (v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
+				"tda7432", "tda7432", addrs))
+			return;
+		goto no_audio;
+	}
+	if (tvaudio[btv->c.nr]) {
+		/* The user specified that we should probe for tvaudio */
+		btv->sd_tvaudio = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
+				"tvaudio", "tvaudio", tvaudio_addrs);
+		if (btv->sd_tvaudio)
+			return;
+		goto no_audio;
+	}
+
+	/* There were no overrides, sp now we try to discover this through the
+	   card definition */
+
+	/* probe for msp3400 first: this driver can detect whether or not
+	   it really is a msp3400, so it will return NULL when the device
+	   found is really something else (e.g. a tea6300). */
+	if (!bttv_tvcards[btv->c.type].no_msp34xx) {
+		static const unsigned short addrs[] = {
+			I2C_ADDR_MSP3400 >> 1,
+			I2C_CLIENT_END
+		};
+
+		btv->sd_msp34xx = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
+				"msp3400", "msp3400", addrs);
+	} else if (bttv_tvcards[btv->c.type].msp34xx_alt) {
+		static const unsigned short addrs[] = {
+			I2C_ADDR_MSP3400_ALT >> 1,
+			I2C_CLIENT_END
+		};
+
+		btv->sd_msp34xx = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
+				"msp3400", "msp3400", addrs);
+	}
+
+	/* If we found a msp34xx, then we're done. */
+	if (btv->sd_msp34xx)
+		return;
+
+	/* it might also be a tda7432. */
+	if (!bttv_tvcards[btv->c.type].no_tda7432) {
+		static const unsigned short addrs[] = {
+			I2C_ADDR_TDA7432 >> 1,
+			I2C_CLIENT_END
+		};
+
+		if (v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
+				"tda7432", "tda7432", addrs))
+			return;
+	}
+
+	/* Now see if we can find one of the tvaudio devices. */
+	btv->sd_tvaudio = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
+			"tvaudio", "tvaudio", tvaudio_addrs);
+	if (btv->sd_tvaudio)
+		return;
+
+no_audio:
+	printk(KERN_WARNING "bttv%d: audio absent, no audio device found!\n",
+			btv->c.nr);
 }
 
 
@@ -3640,6 +3749,7 @@
 		printk("bttv%d: Terratec Active Radio Upgrade found.\n",
 		       btv->c.nr);
 		btv->has_radio    = 1;
+		btv->has_saa6588  = 1;
 		btv->has_matchbox = 1;
 	} else {
 		btv->has_radio    = 0;
diff -r 7191463177cd -r 68050e782acb linux/drivers/media/video/bt8xx/bttv-driver.c
--- a/linux/drivers/media/video/bt8xx/bttv-driver.c	Thu Mar 19 20:53:32 2009 +0100
+++ b/linux/drivers/media/video/bt8xx/bttv-driver.c	Thu Mar 19 21:15:53 2009 +0100
@@ -1181,7 +1181,6 @@
 {
 	int gpio_val, signal;
 	struct v4l2_control ctrl;
-	struct i2c_client *c;
 
 	gpio_inout(bttv_tvcards[btv->c.type].gpiomask,
 		   bttv_tvcards[btv->c.type].gpiomask);
@@ -1220,9 +1219,8 @@
 
 	ctrl.id = V4L2_CID_AUDIO_MUTE;
 	ctrl.value = btv->mute;
-	bttv_call_i2c_clients(btv, VIDIOC_S_CTRL, &ctrl);
-	c = btv->i2c_msp34xx_client;
-	if (c) {
+	bttv_call_all(btv, core, s_ctrl, &ctrl);
+	if (btv->sd_msp34xx) {
 		struct v4l2_routing route;
 
 		/* Note: the inputs tuner/radio/extern/intern are translated
@@ -1261,15 +1259,14 @@
 			break;
 		}
 		route.output = MSP_OUTPUT_DEFAULT;
-		c->driver->command(c, VIDIOC_INT_S_AUDIO_ROUTING, &route);
-	}
-	c = btv->i2c_tvaudio_client;
-	if (c) {
+		v4l2_subdev_call(btv->sd_msp34xx, audio, s_routing, &route);
+	}
+	if (btv->sd_tvaudio) {
 		struct v4l2_routing route;
 
 		route.input = input;
 		route.output = 0;
-		c->driver->command(c, VIDIOC_INT_S_AUDIO_ROUTING, &route);
+		v4l2_subdev_call(btv->sd_tvaudio, audio, s_routing, &route);
 	}
 	return 0;
 }
@@ -1360,7 +1357,7 @@
 #endif
 	}
 	id = tvnorm->v4l2_id;
-	bttv_call_i2c_clients(btv, VIDIOC_S_STD, &id);
+	bttv_call_all(btv, tuner, s_std, id);
 
 	return 0;
 }
@@ -1504,7 +1501,7 @@
 	case V4L2_CID_AUDIO_BALANCE:
 	case V4L2_CID_AUDIO_BASS:
 	case V4L2_CID_AUDIO_TREBLE:
-		bttv_call_i2c_clients(btv, VIDIOC_G_CTRL, c);
+		bttv_call_all(btv, core, g_ctrl, c);
 		break;
 
 	case V4L2_CID_PRIVATE_CHROMA_AGC:
@@ -1578,12 +1575,12 @@
 		if (btv->volume_gpio)
 			btv->volume_gpio(btv, c->value);
 
-		bttv_call_i2c_clients(btv, VIDIOC_S_CTRL, c);
+		bttv_call_all(btv, core, s_ctrl, c);
 		break;
 	case V4L2_CID_AUDIO_BALANCE:
 	case V4L2_CID_AUDIO_BASS:
 	case V4L2_CID_AUDIO_TREBLE:
-		bttv_call_i2c_clients(btv, VIDIOC_S_CTRL, c);
+		bttv_call_all(btv, core, s_ctrl, c);
 		break;
 
 	case V4L2_CID_PRIVATE_CHROMA_AGC:
@@ -2001,7 +1998,7 @@
 		return -EINVAL;
 
 	mutex_lock(&btv->lock);
-	bttv_call_i2c_clients(btv, VIDIOC_S_TUNER, t);
+	bttv_call_all(btv, tuner, s_tuner, t);
 
 	if (btv->audio_mode_gpio)
 		btv->audio_mode_gpio(btv, t, 1);
@@ -2046,7 +2043,7 @@
 		return -EINVAL;
 	mutex_lock(&btv->lock);
 	btv->freq = f->frequency;
-	bttv_call_i2c_clients(btv, VIDIOC_S_FREQUENCY, f);
+	bttv_call_all(btv, tuner, s_frequency, f);
 	if (btv->has_matchbox && btv->radio_user)
 		tea5757_set_freq(btv, btv->freq);
 	mutex_unlock(&btv->lock);
@@ -2060,7 +2057,7 @@
 
 	printk(KERN_INFO "bttv%d: ========  START STATUS CARD #%d  ========\n",
 			btv->c.nr, btv->c.nr);
-	bttv_call_i2c_clients(btv, VIDIOC_LOG_STATUS, NULL);
+	bttv_call_all(btv, core, log_status);
 	printk(KERN_INFO "bttv%d: ========  END STATUS CARD   #%d  ========\n",
 			btv->c.nr, btv->c.nr);
 	return 0;
@@ -2976,7 +2973,7 @@
 
 	mutex_lock(&btv->lock);
 	t->rxsubchans = V4L2_TUNER_SUB_MONO;
-	bttv_call_i2c_clients(btv, VIDIOC_G_TUNER, t);
+	bttv_call_all(btv, tuner, g_tuner, t);
 	strcpy(t->name, "Television");
 	t->capability = V4L2_TUNER_CAP_NORM;
 	t->type       = V4L2_TUNER_ANALOG_TV;
@@ -3467,7 +3464,7 @@
 
 	btv->radio_user++;
 
-	bttv_call_i2c_clients(btv,AUDC_SET_RADIO,NULL);
+	bttv_call_all(btv, tuner, s_radio);
 	audio_input(btv,TVAUDIO_INPUT_RADIO);
 
 	mutex_unlock(&btv->lock);
@@ -3487,7 +3484,7 @@
 
 	btv->radio_user--;
 
-	bttv_call_i2c_clients(btv, RDS_CMD_CLOSE, &cmd);
+	bttv_call_all(btv, core, ioctl, RDS_CMD_CLOSE, &cmd);
 
 	return 0;
 }
@@ -3520,7 +3517,7 @@
 	strcpy(t->name, "Radio");
 	t->type = V4L2_TUNER_RADIO;
 
-	bttv_call_i2c_clients(btv, VIDIOC_G_TUNER, t);
+	bttv_call_all(btv, tuner, g_tuner, t);
 
 	if (btv->audio_mode_gpio)
 		btv->audio_mode_gpio(btv, t, 0);
@@ -3562,7 +3559,7 @@
 	if (0 != t->index)
 		return -EINVAL;
 
-	bttv_call_i2c_clients(btv, VIDIOC_G_TUNER, t);
+	bttv_call_all(btv, tuner, g_tuner, t);
 	return 0;
 }
 
@@ -3623,7 +3620,7 @@
 	cmd.instance = file;
 	cmd.result = -ENODEV;
 
-	bttv_call_i2c_clients(btv, RDS_CMD_READ, &cmd);
+	bttv_call_all(btv, core, ioctl, RDS_CMD_READ, &cmd);
 
 	return cmd.result;
 }
@@ -3636,7 +3633,7 @@
 	cmd.instance = file;
 	cmd.event_list = wait;
 	cmd.result = -ENODEV;
-	bttv_call_i2c_clients(btv, RDS_CMD_POLL, &cmd);
+	bttv_call_all(btv, core, ioctl, RDS_CMD_POLL, &cmd);
 
 	return cmd.result;
 }
diff -r 7191463177cd -r 68050e782acb linux/drivers/media/video/bt8xx/bttv-i2c.c
--- a/linux/drivers/media/video/bt8xx/bttv-i2c.c	Thu Mar 19 20:53:32 2009 +0100
+++ b/linux/drivers/media/video/bt8xx/bttv-i2c.c	Thu Mar 19 21:15:53 2009 +0100
@@ -35,8 +35,6 @@
 #include <media/v4l2-common.h>
 #include <linux/jiffies.h>
 #include <asm/io.h>
-
-static int attach_inform(struct i2c_client *client);
 
 static int i2c_debug;
 static int i2c_hw;
@@ -269,51 +267,6 @@
 /* ----------------------------------------------------------------------- */
 /* I2C functions - common stuff                                            */
 
-static int attach_inform(struct i2c_client *client)
-{
-	struct v4l2_device *v4l2_dev = i2c_get_adapdata(client->adapter);
-	struct bttv *btv = to_bttv(v4l2_dev);
-	int addr=ADDR_UNSET;
-
-
-	if (ADDR_UNSET != bttv_tvcards[btv->c.type].tuner_addr)
-		addr = bttv_tvcards[btv->c.type].tuner_addr;
-
-
-	if (bttv_debug)
-		printk(KERN_DEBUG "bttv%d: %s i2c attach [addr=0x%x,client=%s]\n",
-			btv->c.nr, client->driver->driver.name, client->addr,
-			client->name);
-	if (!client->driver->command)
-		return 0;
-
-	if (client->driver->id == I2C_DRIVERID_MSP3400)
-		btv->i2c_msp34xx_client = client;
-	if (client->driver->id == I2C_DRIVERID_TVAUDIO)
-		btv->i2c_tvaudio_client = client;
-	if (btv->tuner_type != TUNER_ABSENT) {
-		struct tuner_setup tun_setup;
-
-		if (addr == ADDR_UNSET || addr == client->addr) {
-			tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV | T_RADIO;
-			tun_setup.type = btv->tuner_type;
-			tun_setup.addr = addr;
-			bttv_call_i2c_clients(btv, TUNER_SET_TYPE_ADDR, &tun_setup);
-		}
-
-	}
-
-	return 0;
-}
-
-void bttv_call_i2c_clients(struct bttv *btv, unsigned int cmd, void *arg)
-{
-	if (0 != btv->i2c_rc)
-		return;
-	i2c_clients_command(&btv->c.i2c_adap, cmd, arg);
-}
-
-
 /* read I2C */
 int bttv_I2CRead(struct bttv *btv, unsigned char addr, char *probe_for)
 {
@@ -424,8 +377,9 @@
 		btv->c.i2c_adap.algo_data = &btv->i2c_algo;
 	}
 	btv->c.i2c_adap.owner = THIS_MODULE;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 22)
 	btv->c.i2c_adap.class = I2C_CLASS_TV_ANALOG;
-	btv->c.i2c_adap.client_register = attach_inform;
+#endif
 
 	btv->c.i2c_adap.dev.parent = &btv->c.pci->dev;
 	snprintf(btv->c.i2c_adap.name, sizeof(btv->c.i2c_adap.name),
@@ -435,10 +389,12 @@
 	i2c_set_adapdata(&btv->c.i2c_adap, &btv->c.v4l2_dev);
 	btv->i2c_client.adapter = &btv->c.i2c_adap;
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 22)
 	if (bttv_tvcards[btv->c.type].no_video)
 		btv->c.i2c_adap.class &= ~I2C_CLASS_TV_ANALOG;
 	if (bttv_tvcards[btv->c.type].has_dvb)
 		btv->c.i2c_adap.class |= I2C_CLASS_TV_DIGITAL;
+#endif
 
 	if (btv->use_i2c_hw) {
 		btv->i2c_rc = i2c_add_adapter(&btv->c.i2c_adap);
diff -r 7191463177cd -r 68050e782acb linux/drivers/media/video/bt8xx/bttv.h
--- a/linux/drivers/media/video/bt8xx/bttv.h	Thu Mar 19 20:53:32 2009 +0100
+++ b/linux/drivers/media/video/bt8xx/bttv.h	Thu Mar 19 21:15:53 2009 +0100
@@ -242,6 +242,7 @@
 	unsigned int msp34xx_alt:1;
 
 	unsigned int no_video:1; /* video pci function is unused */
+	unsigned int has_saa6588:1;
 	unsigned int has_dvb:1;
 	unsigned int has_remote:1;
 	unsigned int has_radio:1;
@@ -357,7 +358,9 @@
 /* ---------------------------------------------------------- */
 /* i2c                                                        */
 
-extern void bttv_call_i2c_clients(struct bttv *btv, unsigned int cmd, void *arg);
+#define bttv_call_all(btv, o, f, args...) \
+	v4l2_device_call_all(&btv->c.v4l2_dev, 0, o, f, ##args)
+
 extern int bttv_I2CRead(struct bttv *btv, unsigned char addr, char *probe_for);
 extern int bttv_I2CWrite(struct bttv *btv, unsigned char addr, unsigned char b1,
 			 unsigned char b2, int both);
diff -r 7191463177cd -r 68050e782acb linux/drivers/media/video/bt8xx/bttvp.h
--- a/linux/drivers/media/video/bt8xx/bttvp.h	Thu Mar 19 20:53:32 2009 +0100
+++ b/linux/drivers/media/video/bt8xx/bttvp.h	Thu Mar 19 21:15:53 2009 +0100
@@ -331,6 +331,7 @@
 	unsigned int tuner_type;  /* tuner chip type */
 	unsigned int tda9887_conf;
 	unsigned int svhs, dig;
+	unsigned int has_saa6588:1;
 	struct bttv_pll_info pll;
 	int triton1;
 	int gpioirq;
@@ -354,8 +355,9 @@
 	int                        i2c_state, i2c_rc;
 	int                        i2c_done;
 	wait_queue_head_t          i2c_queue;
-	struct i2c_client 	  *i2c_msp34xx_client;
-	struct i2c_client 	  *i2c_tvaudio_client;
+	struct v4l2_subdev 	  *sd_msp34xx;
+	struct v4l2_subdev 	  *sd_tvaudio;
+	struct v4l2_subdev 	  *sd_saa6588;
 
 	/* video4linux (1) */
 	struct video_device *video_dev;


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

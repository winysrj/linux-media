Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4502 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZCPMQT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 08:16:19 -0400
Message-ID: <24193.62.70.2.252.1237205766.squirrel@webmail.xs4all.nl>
Date: Mon, 16 Mar 2009 13:16:06 +0100 (CET)
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Trent Piepho" <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Mon, 16 Mar 2009 08:09:44 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>
>> > >> > > > > Can you review my ~hverkuil/v4l-dvb-bttv2 tree?
>
> Ok, it was not that hard. It follows my comments.
>
>> --- a/linux/drivers/media/video/bt8xx/bttv-cards.c	Sun Mar 15 10:53:32
>> 2009 +0100
>> +++ b/linux/drivers/media/video/bt8xx/bttv-cards.c	Sun Mar 15 13:07:15
>> 2009 +0100
>> @@ -97,12 +97,8 @@ static unsigned int tuner[BTTV_MAX]  = {
>>  static unsigned int tuner[BTTV_MAX]  = { [ 0 ... (BTTV_MAX-1) ] = UNSET
>> };
>>  static unsigned int svhs[BTTV_MAX]   = { [ 0 ... (BTTV_MAX-1) ] = UNSET
>> };
>>  static unsigned int remote[BTTV_MAX] = { [ 0 ... (BTTV_MAX-1) ] = UNSET
>> };
>> +static unsigned int tvaudio[BTTV_MAX] = { [0 ... (BTTV_MAX - 1)] =
>> UNSET };
>>  static struct bttv  *master[BTTV_MAX] = { [ 0 ... (BTTV_MAX-1) ] = NULL
>> };
>> -#ifdef MODULE
>> -static unsigned int autoload = 1;
>> -#else
>> -static unsigned int autoload;
>> -#endif
>>  static unsigned int gpiomask = UNSET;
>>  static unsigned int audioall = UNSET;
>>  static unsigned int audiomux[5] = { [ 0 ... 4 ] = UNSET };
>> @@ -114,13 +110,13 @@ module_param(latency,    int, 0444);
>>  module_param(latency,    int, 0444);
>>  module_param(gpiomask,   int, 0444);
>>  module_param(audioall,   int, 0444);
>> -module_param(autoload,   int, 0444);
>
> As already discussed, instead of removing, just print some warning if
> people
> use this parameter. The printed message should ideally direct to some wiki
> page
> commenting about the changes, and explaining how to emulate the previous
> behaviour where such parameter were needed.

Acked.

>
>>
>>  module_param_array(card,     int, NULL, 0444);
>>  module_param_array(pll,      int, NULL, 0444);
>>  module_param_array(tuner,    int, NULL, 0444);
>>  module_param_array(svhs,     int, NULL, 0444);
>>  module_param_array(remote,   int, NULL, 0444);
>> +module_param_array(tvaudio,  int, NULL, 0444);
>>  module_param_array(audiomux, int, NULL, 0444);
>>
>>  MODULE_PARM_DESC(triton1,"set ETBF pci config bit "
>> @@ -131,7 +127,8 @@ MODULE_PARM_DESC(card,"specify TV/grabbe
>>  MODULE_PARM_DESC(card,"specify TV/grabber card model, see CARDLIST file
>> for a list");
>>  MODULE_PARM_DESC(pll,"specify installed crystal (0=none, 28=28 MHz,
>> 35=35 MHz)");
>>  MODULE_PARM_DESC(tuner,"specify installed tuner type");
>> -MODULE_PARM_DESC(autoload,"automatically load i2c modules like tuner.o,
>> default is 1 (yes)");
>> +MODULE_PARM_DESC(tvaudio, "specify whether tvaudio should be loaded (1)
>> or not (0),"
>> +		 " default is autodetect");
>>  MODULE_PARM_DESC(no_overlay,"allow override overlay default (0
>> disables, 1 enables)"
>>  		" [some VIA/SIS chipsets are known to have problem with overlay]");
>>
>> @@ -3333,8 +3330,10 @@ void __devinit bttv_init_card2(struct bt
>>  void __devinit bttv_init_card2(struct bttv *btv)
>>  {
>>  	int addr=ADDR_UNSET;
>> +	int load_tvaudio = tvaudio[btv->c.nr];
>>
>>  	btv->tuner_type = UNSET;
>> +	btv->has_saa6588 = bttv_tvcards[btv->c.type].has_saa6588;
>>
>>  	if (BTTV_BOARD_UNKNOWN == btv->c.type) {
>>  		bttv_readee(btv,eeprom_data,0xa0);
>> @@ -3502,8 +3501,13 @@ void __devinit bttv_init_card2(struct bt
>>  		struct tuner_setup tun_setup;
>>
>>  		/* Load tuner module before issuing tuner config call! */
>> -		if (autoload)
>> -			request_module("tuner");
>> +		if (bttv_tvcards[btv->c.type].has_radio)
>> +			v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
>> +				"tuner", "tuner", v4l2_i2c_tuner_addrs(ADDRS_RADIO));
>> +		v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap, "tuner",
>> +				"tuner", v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
>> +		v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap, "tuner",
>> +				"tuner", v4l2_i2c_tuner_addrs(ADDRS_TV_WITH_DEMOD));
>
> There are several bttv boards without tuner. In fact, those are becoming
> a more common setup with bttv, since there are still several surveillance
> boards with bttv being selled in the market. We should test if
> !TUNER_ABSENT
> before doing the probe for a tuner.

Hmm? This code is already inside an 'if (btv->tuner_type != TUNER_ABSENT)'.

>>  		tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
>>  		tun_setup.type = btv->tuner_type;
>> @@ -3512,7 +3516,7 @@ void __devinit bttv_init_card2(struct bt
>>  		if (bttv_tvcards[btv->c.type].has_radio)
>>  			tun_setup.mode_mask |= T_RADIO;
>>
>> -		bttv_call_i2c_clients(btv, TUNER_SET_TYPE_ADDR, &tun_setup);
>> +		bttv_call_all(btv, tuner, s_type_addr, &tun_setup);
>>  	}
>>
>>  	if (btv->tda9887_conf) {
>> @@ -3521,7 +3525,7 @@ void __devinit bttv_init_card2(struct bt
>>  		tda9887_cfg.tuner = TUNER_TDA9887;
>>  		tda9887_cfg.priv = &btv->tda9887_conf;
>>
>> -		bttv_call_i2c_clients(btv, TUNER_SET_CONFIG, &tda9887_cfg);
>> +		bttv_call_all(btv, tuner, s_config, &tda9887_cfg);
>>  	}
>>
>>  	btv->dig = bttv_tvcards[btv->c.type].has_dig_in ?
>> @@ -3544,31 +3548,94 @@ void __devinit bttv_init_card2(struct bt
>>  	if (bttv_tvcards[btv->c.type].audio_mode_gpio)
>>  		btv->audio_mode_gpio=bttv_tvcards[btv->c.type].audio_mode_gpio;
>>
>> -	if (!autoload)
>> -		return;
>> -
>>  	if (btv->tuner_type == TUNER_ABSENT)
>>  		return;  /* no tuner or related drivers to load */
>>
>> +	if (btv->has_saa6588) {
>> +		/* Probe for RDS receiver chip */
>> +		static const unsigned short addrs[] = {
>> +			0x20 >> 1,
>> +			0x22 >> 1,
>> +			I2C_CLIENT_END
>> +		};
>> +
>> +		btv->sd_rds = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
>> +				"saa6588", "saa6588", addrs);
>> +	}
>> +
>>  	/* try to detect audio/fader chips */
>> -	if (!bttv_tvcards[btv->c.type].no_msp34xx &&
>> -	    bttv_I2CRead(btv, I2C_ADDR_MSP3400, "MSP34xx") >=0)
>> -		request_module("msp3400");
>> -
>> -	if (bttv_tvcards[btv->c.type].msp34xx_alt &&
>> -	    bttv_I2CRead(btv, I2C_ADDR_MSP3400_ALT, "MSP34xx (alternate
>> address)") >=0)
>> -		request_module("msp3400");
>> -
>> -	if (!bttv_tvcards[btv->c.type].no_tda9875 &&
>> -	    bttv_I2CRead(btv, I2C_ADDR_TDA9875, "TDA9875") >=0)
>> -		request_module("tda9875");
>> -
>> -	if (!bttv_tvcards[btv->c.type].no_tda7432 &&
>> -	    bttv_I2CRead(btv, I2C_ADDR_TDA7432, "TDA7432") >=0)
>> -		request_module("tda7432");
>> -
>> -	if (bttv_tvcards[btv->c.type].needs_tvaudio)
>> -		request_module("tvaudio");
>> +
>> +	/* probe for msp3400 first: this driver can detect whether or not
>> +	   it really is a msp3400, so it will return NULL when the device
>> +	   found is really something else (e.g. a tea6300). */
>> +	if (bttv_tvcards[btv->c.type].msp34xx_alt) {
>> +		static const unsigned short addrs[] = {
>> +			I2C_ADDR_MSP3400_ALT >> 1,
>> +			I2C_CLIENT_END
>> +		};
>
> Why aren't you probing first at I2C_ADDR_MSP3400? You're changing the
> behaviour
> here. It is better to probe at the same order as the previous version.

OK.

>> +
>> +		btv->sd_msp34xx = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
>> +				"msp3400", "msp3400", addrs);
>> +	} else if (!bttv_tvcards[btv->c.type].no_msp34xx) {
>> +		static const unsigned short addrs[] = {
>> +			I2C_ADDR_MSP3400 >> 1,
>> +			I2C_CLIENT_END
>> +		};
>> +
>> +		btv->sd_msp34xx = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
>> +				"msp3400", "msp3400", addrs);
>> +	}
>
> Why do you need to probe it twice? Shouldn't it be just one probing for
> both addresses?

The original code is actually doing its own probing for just one address.
So this replicates the original behavior.

>
>> +
>> +	/* If we found a msp34xx, then we're done. */
>> +	if (btv->sd_msp34xx)
>> +		return;
>> +
>> +	if (load_tvaudio != UNSET) {
>> +		printk(KERN_INFO "bttv%d: if you need to set the tvaudio module
>> option to %d, then the\n",
>> +				btv->c.nr, load_tvaudio);
>> +		printk(KERN_INFO "bttv%d: definition for card type %d needs to be
>> updated.\n",
>> +				btv->c.nr, btv->c.type);
>> +		printk(KERN_INFO "bttv%d: please report this to the bttv
>> maintainer.\n", btv->c.nr);
>
> This is not what I call "tvaudio autodectect" (that should be the default
> way,
> as the comments for tvaudio option states).
>
> A bttv board should have some audio chip otherwise audio won't work.
>
> I dunno if is there any supported card without audio at all, but probably,
> if
> we have, this is by far much less than boards with an audio chip.
>
> Based on this principle, IMO, the probing function should, by default,
> probe
> for tvaudio, if it doesn't find another audio device. You may eventually
> ask
> for people to report, to warn us that the board entry is broken, but we
> shouln't intentionally break a device that we're almost sure that requires
> tvaudio or tda7432.

OK. In other words it would be better to probe for:

1) msp3400
2) msp3400_alt
3) tda7432
4) tvaudio

and return as soon as we find a chip. So tvaudio is probed
unconditionally, effectively ignoring the needs_tvaudio flag and only
honoring the tvaudio module option (although I'm not sure whether that is
still needed in that case).

>> +	} else {
>> +		/* tda9875 is now also handled by tvaudio. It used to be
>> +		   handled by the tda9875 module, but that causes problems
>> +		   in detecting whether you have a tda9874 or tda9875. It is
>> +		   better to use tvaudio for both. */
>> +		load_tvaudio = bttv_tvcards[btv->c.type].needs_tvaudio ||
>> +			!bttv_tvcards[btv->c.type].no_tda9875;
>> +	}
>> +
>> +	/* Now see if we can find one of the tvaudio devices. */
>> +	if (load_tvaudio) {
>> +		static const unsigned short addrs[] = {
>> +			I2C_ADDR_TDA8425   >> 1,
>> +			I2C_ADDR_TEA6300   >> 1,
>> +			I2C_ADDR_TEA6420   >> 1,
>> +			I2C_ADDR_TDA9840   >> 1,
>> +			I2C_ADDR_TDA985x_L >> 1,
>> +			I2C_ADDR_TDA985x_H >> 1,
>> +			I2C_ADDR_TDA9874   >> 1,
>> +			I2C_ADDR_PIC16C54  >> 1,
>> +			I2C_CLIENT_END
>> +		};
>
> We should preserve the same probing order as before, in order to reduce
> breakage risks.

It is the same order.

>> +
>> +		btv->sd_tvaudio = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
>> +				"tvaudio", "tvaudio", addrs);
>> +		/* If we found a device supported by tvaudio, then we're done
>> +		   as well. */
>> +		if (btv->sd_tvaudio)
>> +			return;
>> +	}
>> +	/* Last possibility: it might be a tda7432. */
>> +	if (!bttv_tvcards[btv->c.type].no_tda7432) {
>> +		static const unsigned short addrs[] = {
>> +			I2C_ADDR_TDA7432 >> 1,
>> +			I2C_CLIENT_END
>> +		};
>> +
>> +		v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap, "tda7432",
>> +				"tda7432", addrs);
>> +	}
>
> No audio module found. This requires printing a warning, since the board
> won't have audio working.

OK.

>>  }
>>
>>
>> @@ -3640,6 +3707,7 @@ static int terratec_active_radio_upgrade
>>  		printk("bttv%d: Terratec Active Radio Upgrade found.\n",
>>  		       btv->c.nr);
>>  		btv->has_radio    = 1;
>> +		btv->has_saa6588  = 1;
>>  		btv->has_matchbox = 1;
>>  	} else {
>>  		btv->has_radio    = 0;
>> --- a/linux/drivers/media/video/bt8xx/bttv-driver.c	Sun Mar 15 10:53:32
>> 2009 +0100
>> +++ b/linux/drivers/media/video/bt8xx/bttv-driver.c	Sun Mar 15 13:07:15
>> 2009 +0100
>> @@ -1181,7 +1181,6 @@ audio_mux(struct bttv *btv, int input, i
>>  {
>>  	int gpio_val, signal;
>>  	struct v4l2_control ctrl;
>> -	struct i2c_client *c;
>>
>>  	gpio_inout(bttv_tvcards[btv->c.type].gpiomask,
>>  		   bttv_tvcards[btv->c.type].gpiomask);
>> @@ -1220,9 +1219,8 @@ audio_mux(struct bttv *btv, int input, i
>>
>>  	ctrl.id = V4L2_CID_AUDIO_MUTE;
>>  	ctrl.value = btv->mute;
>> -	bttv_call_i2c_clients(btv, VIDIOC_S_CTRL, &ctrl);
>> -	c = btv->i2c_msp34xx_client;
>> -	if (c) {
>> +	bttv_call_all(btv, core, s_ctrl, &ctrl);
>> +	if (btv->sd_msp34xx) {
>>  		struct v4l2_routing route;
>>
>>  		/* Note: the inputs tuner/radio/extern/intern are translated
>> @@ -1261,15 +1259,14 @@ audio_mux(struct bttv *btv, int input, i
>>  			break;
>>  		}
>>  		route.output = MSP_OUTPUT_DEFAULT;
>> -		c->driver->command(c, VIDIOC_INT_S_AUDIO_ROUTING, &route);
>> -	}
>> -	c = btv->i2c_tvaudio_client;
>> -	if (c) {
>> +		v4l2_subdev_call(btv->sd_msp34xx, audio, s_routing, &route);
>> +	}
>> +	if (btv->sd_tvaudio) {
>>  		struct v4l2_routing route;
>>
>>  		route.input = input;
>>  		route.output = 0;
>> -		c->driver->command(c, VIDIOC_INT_S_AUDIO_ROUTING, &route);
>> +		v4l2_subdev_call(btv->sd_tvaudio, audio, s_routing, &route);
>>  	}
>>  	return 0;
>>  }
>> @@ -1360,7 +1357,7 @@ set_tvnorm(struct bttv *btv, unsigned in
>>  #endif
>>  	}
>>  	id = tvnorm->v4l2_id;
>> -	bttv_call_i2c_clients(btv, VIDIOC_S_STD, &id);
>> +	bttv_call_all(btv, tuner, s_std, id);
>>
>>  	return 0;
>>  }
>> @@ -1504,7 +1501,7 @@ static int bttv_g_ctrl(struct file *file
>>  	case V4L2_CID_AUDIO_BALANCE:
>>  	case V4L2_CID_AUDIO_BASS:
>>  	case V4L2_CID_AUDIO_TREBLE:
>> -		bttv_call_i2c_clients(btv, VIDIOC_G_CTRL, c);
>> +		bttv_call_all(btv, core, g_ctrl, c);
>>  		break;
>>
>>  	case V4L2_CID_PRIVATE_CHROMA_AGC:
>> @@ -1578,12 +1575,12 @@ static int bttv_s_ctrl(struct file *file
>>  		if (btv->volume_gpio)
>>  			btv->volume_gpio(btv, c->value);
>>
>> -		bttv_call_i2c_clients(btv, VIDIOC_S_CTRL, c);
>> +		bttv_call_all(btv, core, s_ctrl, c);
>>  		break;
>>  	case V4L2_CID_AUDIO_BALANCE:
>>  	case V4L2_CID_AUDIO_BASS:
>>  	case V4L2_CID_AUDIO_TREBLE:
>> -		bttv_call_i2c_clients(btv, VIDIOC_S_CTRL, c);
>> +		bttv_call_all(btv, core, s_ctrl, c);
>>  		break;
>>
>>  	case V4L2_CID_PRIVATE_CHROMA_AGC:
>> @@ -2001,7 +1998,7 @@ static int bttv_s_tuner(struct file *fil
>>  		return -EINVAL;
>>
>>  	mutex_lock(&btv->lock);
>> -	bttv_call_i2c_clients(btv, VIDIOC_S_TUNER, t);
>> +	bttv_call_all(btv, tuner, s_tuner, t);
>>
>>  	if (btv->audio_mode_gpio)
>>  		btv->audio_mode_gpio(btv, t, 1);
>> @@ -2046,7 +2043,7 @@ static int bttv_s_frequency(struct file
>>  		return -EINVAL;
>>  	mutex_lock(&btv->lock);
>>  	btv->freq = f->frequency;
>> -	bttv_call_i2c_clients(btv, VIDIOC_S_FREQUENCY, f);
>> +	bttv_call_all(btv, tuner, s_frequency, f);
>>  	if (btv->has_matchbox && btv->radio_user)
>>  		tea5757_set_freq(btv, btv->freq);
>>  	mutex_unlock(&btv->lock);
>> @@ -2060,7 +2057,7 @@ static int bttv_log_status(struct file *
>>
>>  	printk(KERN_INFO "bttv%d: ========  START STATUS CARD #%d
>> ========\n",
>>  			btv->c.nr, btv->c.nr);
>> -	bttv_call_i2c_clients(btv, VIDIOC_LOG_STATUS, NULL);
>> +	bttv_call_all(btv, core, log_status);
>>  	printk(KERN_INFO "bttv%d: ========  END STATUS CARD   #%d
>> ========\n",
>>  			btv->c.nr, btv->c.nr);
>>  	return 0;
>> @@ -2976,7 +2973,7 @@ static int bttv_g_tuner(struct file *fil
>>
>>  	mutex_lock(&btv->lock);
>>  	t->rxsubchans = V4L2_TUNER_SUB_MONO;
>> -	bttv_call_i2c_clients(btv, VIDIOC_G_TUNER, t);
>> +	bttv_call_all(btv, tuner, g_tuner, t);
>>  	strcpy(t->name, "Television");
>>  	t->capability = V4L2_TUNER_CAP_NORM;
>>  	t->type       = V4L2_TUNER_ANALOG_TV;
>> @@ -3467,7 +3464,7 @@ static int radio_open(struct file *file)
>>
>>  	btv->radio_user++;
>>
>> -	bttv_call_i2c_clients(btv,AUDC_SET_RADIO,NULL);
>> +	bttv_call_all(btv, tuner, s_radio);
>>  	audio_input(btv,TVAUDIO_INPUT_RADIO);
>>
>>  	mutex_unlock(&btv->lock);
>> @@ -3487,7 +3484,7 @@ static int radio_release(struct file *fi
>>
>>  	btv->radio_user--;
>>
>> -	bttv_call_i2c_clients(btv, RDS_CMD_CLOSE, &cmd);
>> +	bttv_call_all(btv, core, ioctl, RDS_CMD_CLOSE, &cmd);
>>
>>  	return 0;
>>  }
>> @@ -3520,7 +3517,7 @@ static int radio_g_tuner(struct file *fi
>>  	strcpy(t->name, "Radio");
>>  	t->type = V4L2_TUNER_RADIO;
>>
>> -	bttv_call_i2c_clients(btv, VIDIOC_G_TUNER, t);
>> +	bttv_call_all(btv, tuner, g_tuner, t);
>>
>>  	if (btv->audio_mode_gpio)
>>  		btv->audio_mode_gpio(btv, t, 0);
>> @@ -3562,7 +3559,7 @@ static int radio_s_tuner(struct file *fi
>>  	if (0 != t->index)
>>  		return -EINVAL;
>>
>> -	bttv_call_i2c_clients(btv, VIDIOC_G_TUNER, t);
>> +	bttv_call_all(btv, tuner, g_tuner, t);
>>  	return 0;
>>  }
>>
>> @@ -3623,7 +3620,7 @@ static ssize_t radio_read(struct file *f
>>  	cmd.instance = file;
>>  	cmd.result = -ENODEV;
>>
>> -	bttv_call_i2c_clients(btv, RDS_CMD_READ, &cmd);
>> +	bttv_call_all(btv, core, ioctl, RDS_CMD_READ, &cmd);
>>
>>  	return cmd.result;
>>  }
>> @@ -3636,7 +3633,7 @@ static unsigned int radio_poll(struct fi
>>  	cmd.instance = file;
>>  	cmd.event_list = wait;
>>  	cmd.result = -ENODEV;
>> -	bttv_call_i2c_clients(btv, RDS_CMD_POLL, &cmd);
>> +	bttv_call_all(btv, core, ioctl, RDS_CMD_POLL, &cmd);
>>
>>  	return cmd.result;
>>  }
>> --- a/linux/drivers/media/video/bt8xx/bttv-i2c.c	Sun Mar 15 10:53:32
>> 2009 +0100
>> +++ b/linux/drivers/media/video/bt8xx/bttv-i2c.c	Sun Mar 15 13:07:15
>> 2009 +0100
>> @@ -35,8 +35,6 @@
>>  #include <media/v4l2-common.h>
>>  #include <linux/jiffies.h>
>>  #include <asm/io.h>
>> -
>> -static int attach_inform(struct i2c_client *client);
>>
>>  static int i2c_debug;
>>  static int i2c_hw;
>> @@ -269,51 +267,6 @@ static const struct i2c_algorithm bttv_a
>>  /*
>> -----------------------------------------------------------------------
>> */
>>  /* I2C functions - common stuff
>>    */
>>
>> -static int attach_inform(struct i2c_client *client)
>> -{
>> -	struct v4l2_device *v4l2_dev = i2c_get_adapdata(client->adapter);
>> -	struct bttv *btv = to_bttv(v4l2_dev);
>> -	int addr=ADDR_UNSET;
>> -
>> -
>> -	if (ADDR_UNSET != bttv_tvcards[btv->c.type].tuner_addr)
>> -		addr = bttv_tvcards[btv->c.type].tuner_addr;
>> -
>> -
>> -	if (bttv_debug)
>> -		printk(KERN_DEBUG "bttv%d: %s i2c attach [addr=0x%x,client=%s]\n",
>> -			btv->c.nr, client->driver->driver.name, client->addr,
>> -			client->name);
>
> It is still valid to print a message when a device is attached at i2c bus,
> for debugging purposes.

Each i2c driver already prints a message when it is found, so this is just
duplicating that. It adds nothing new. The only reason for this callback
was to support autoprobing.

>> -	if (!client->driver->command)
>> -		return 0;
>> -
>> -	if (client->driver->id == I2C_DRIVERID_MSP3400)
>> -		btv->i2c_msp34xx_client = client;
>> -	if (client->driver->id == I2C_DRIVERID_TVAUDIO)
>> -		btv->i2c_tvaudio_client = client;
>> -	if (btv->tuner_type != TUNER_ABSENT) {
>> -		struct tuner_setup tun_setup;
>> -
>> -		if (addr == ADDR_UNSET || addr == client->addr) {
>> -			tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV | T_RADIO;
>> -			tun_setup.type = btv->tuner_type;
>> -			tun_setup.addr = addr;
>> -			bttv_call_i2c_clients(btv, TUNER_SET_TYPE_ADDR, &tun_setup);
>> -		}
>> -
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>> -void bttv_call_i2c_clients(struct bttv *btv, unsigned int cmd, void
>> *arg)
>> -{
>> -	if (0 != btv->i2c_rc)
>> -		return;
>> -	i2c_clients_command(&btv->c.i2c_adap, cmd, arg);
>> -}
>> -
>> -
>>  /* read I2C */
>>  int bttv_I2CRead(struct bttv *btv, unsigned char addr, char *probe_for)
>>  {
>> @@ -424,8 +377,9 @@ int __devinit init_bttv_i2c(struct bttv
>>  		btv->c.i2c_adap.algo_data = &btv->i2c_algo;
>>  	}
>>  	btv->c.i2c_adap.owner = THIS_MODULE;
>> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 22)
>>  	btv->c.i2c_adap.class = I2C_CLASS_TV_ANALOG;
>> -	btv->c.i2c_adap.client_register = attach_inform;
>> +#endif
>>
>>  	btv->c.i2c_adap.dev.parent = &btv->c.pci->dev;
>>  	snprintf(btv->c.i2c_adap.name, sizeof(btv->c.i2c_adap.name),
>> @@ -435,10 +389,12 @@ int __devinit init_bttv_i2c(struct bttv
>>  	i2c_set_adapdata(&btv->c.i2c_adap, &btv->c.v4l2_dev);
>>  	btv->i2c_client.adapter = &btv->c.i2c_adap;
>>
>> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 22)
>>  	if (bttv_tvcards[btv->c.type].no_video)
>>  		btv->c.i2c_adap.class &= ~I2C_CLASS_TV_ANALOG;
>>  	if (bttv_tvcards[btv->c.type].has_dvb)
>>  		btv->c.i2c_adap.class |= I2C_CLASS_TV_DIGITAL;
>> +#endif
>>
>>  	if (btv->use_i2c_hw) {
>>  		btv->i2c_rc = i2c_add_adapter(&btv->c.i2c_adap);
>> --- a/linux/drivers/media/video/bt8xx/bttv.h	Sun Mar 15 10:53:32 2009
>> +0100
>> +++ b/linux/drivers/media/video/bt8xx/bttv.h	Sun Mar 15 13:07:15 2009
>> +0100
>> @@ -242,6 +242,7 @@ struct tvcard {
>>  	unsigned int msp34xx_alt:1;
>>
>>  	unsigned int no_video:1; /* video pci function is unused */
>> +	unsigned int has_saa6588:1;
>>  	unsigned int has_dvb:1;
>>  	unsigned int has_remote:1;
>>  	unsigned int has_radio:1;
>> @@ -357,7 +358,9 @@ void bttv_gpio_bits(struct bttv_core *co
>>  /* ---------------------------------------------------------- */
>>  /* i2c                                                        */
>>
>> -extern void bttv_call_i2c_clients(struct bttv *btv, unsigned int cmd,
>> void *arg);
>> +#define bttv_call_all(btv, o, f, args...) \
>> +	v4l2_device_call_all(&btv->c.v4l2_dev, 0, o, f, ##args)
>> +
>>  extern int bttv_I2CRead(struct bttv *btv, unsigned char addr, char
>> *probe_for);
>>  extern int bttv_I2CWrite(struct bttv *btv, unsigned char addr, unsigned
>> char b1,
>>  			 unsigned char b2, int both);
>> --- a/linux/drivers/media/video/bt8xx/bttvp.h	Sun Mar 15 10:53:32 2009
>> +0100
>> +++ b/linux/drivers/media/video/bt8xx/bttvp.h	Sun Mar 15 13:07:15 2009
>> +0100
>> @@ -331,6 +331,7 @@ struct bttv {
>>  	unsigned int tuner_type;  /* tuner chip type */
>>  	unsigned int tda9887_conf;
>>  	unsigned int svhs, dig;
>> +	int has_saa6588;
>
> Does it need to be a 32 or 64 bit integer?

I'll replace it with a u8.

>
>>  	struct bttv_pll_info pll;
>>  	int triton1;
>>  	int gpioirq;
>> @@ -354,8 +355,9 @@ struct bttv {
>>  	int                        i2c_state, i2c_rc;
>>  	int                        i2c_done;
>>  	wait_queue_head_t          i2c_queue;
>> -	struct i2c_client 	  *i2c_msp34xx_client;
>> -	struct i2c_client 	  *i2c_tvaudio_client;
>> +	struct v4l2_subdev 	  *sd_msp34xx;
>> +	struct v4l2_subdev 	  *sd_tvaudio;
>> +	struct v4l2_subdev 	  *sd_rds;
>>
>>  	/* video4linux (1) */
>>  	struct video_device *video_dev;

Thanks for the review! Much appreciated.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG


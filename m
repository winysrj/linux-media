Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab3ADVNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:13:22 -0500
Date: Fri, 4 Jan 2013 19:12:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] em28xx: make remote controls of devices with
 external IR IC working again
Message-ID: <20130104191252.4aec9646@redhat.com>
In-Reply-To: <1356649368-5426-4-git-send-email-fschaefer.oss@googlemail.com>
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
	<1356649368-5426-4-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Dec 2012 00:02:45 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Tested with device "Terratec Cinergy 200 USB".

Sorry, but this patch is completely wrong ;)

The fix here is simple: just move the initialization to happen
earlier.

I'm posting it right now, together with a bunch of other fixes for
I2C-based IR devices.

Regards,
Mauro
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c |    9 +-
>  drivers/media/usb/em28xx/em28xx-i2c.c   |    1 +
>  drivers/media/usb/em28xx/em28xx-input.c |  142 +++++++++++++++++--------------
>  3 Dateien geändert, 83 Zeilen hinzugefügt(+), 69 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 40c3e45..3b226b1 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -488,6 +488,7 @@ struct em28xx_board em28xx_boards[] = {
>  		.name         = "Terratec Cinergy 250 USB",
>  		.tuner_type   = TUNER_LG_PAL_NEW_TAPC,
>  		.has_ir_i2c   = 1,
> +		.ir_codes     = RC_MAP_EM_TERRATEC,
>  		.tda9887_conf = TDA9887_PRESENT,
>  		.decoder      = EM28XX_SAA711X,
>  		.input        = { {
> @@ -508,6 +509,7 @@ struct em28xx_board em28xx_boards[] = {
>  		.name         = "Pinnacle PCTV USB 2",
>  		.tuner_type   = TUNER_LG_PAL_NEW_TAPC,
>  		.has_ir_i2c   = 1,
> +		.ir_codes     = RC_MAP_PINNACLE_GREY,
>  		.tda9887_conf = TDA9887_PRESENT,
>  		.decoder      = EM28XX_SAA711X,
>  		.input        = { {
> @@ -533,6 +535,7 @@ struct em28xx_board em28xx_boards[] = {
>  		.decoder      = EM28XX_TVP5150,
>  		.has_msp34xx  = 1,
>  		.has_ir_i2c   = 1,
> +		.ir_codes     = RC_MAP_HAUPPAUGE,
>  		.input        = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
>  			.vmux     = TVP5150_COMPOSITE0,
> @@ -629,6 +632,7 @@ struct em28xx_board em28xx_boards[] = {
>  		.valid        = EM28XX_BOARD_NOT_VALIDATED,
>  		.tuner_type   = TUNER_PHILIPS_FM1216ME_MK3,
>  		.has_ir_i2c   = 1,
> +		.ir_codes     = RC_MAP_WINFAST_USBII_DELUXE,
>  		.tvaudio_addr = 0x58,
>  		.tda9887_conf = TDA9887_PRESENT |
>  				TDA9887_PORT2_ACTIVE |
> @@ -1222,6 +1226,7 @@ struct em28xx_board em28xx_boards[] = {
>  		.name         = "Terratec Cinergy 200 USB",
>  		.is_em2800    = 1,
>  		.has_ir_i2c   = 1,
> +		.ir_codes     = RC_MAP_EM_TERRATEC,
>  		.tuner_type   = TUNER_LG_TALN,
>  		.tda9887_conf = TDA9887_PRESENT,
>  		.decoder      = EM28XX_SAA711X,
> @@ -2912,7 +2917,7 @@ static void request_module_async(struct work_struct *work)
>  
>  	if (dev->board.has_dvb)
>  		request_module("em28xx-dvb");
> -	if (dev->board.ir_codes && !disable_ir)
> +	if ((dev->board.ir_codes || dev->board.has_ir_i2c) && !disable_ir)
>  		request_module("em28xx-rc");
>  #endif /* CONFIG_MODULES */
>  }
> @@ -2935,8 +2940,6 @@ static void flush_request_modules(struct em28xx *dev)
>  */
>  void em28xx_release_resources(struct em28xx *dev)
>  {
> -	/*FIXME: I2C IR should be disconnected */
> -
>  	em28xx_release_analog_resources(dev);
>  
>  	em28xx_i2c_unregister(dev);
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 44533e4..39c5a3e 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -470,6 +470,7 @@ static struct i2c_client em28xx_client_template = {
>  static char *i2c_devs[128] = {
>  	[0x4a >> 1] = "saa7113h",
>  	[0x52 >> 1] = "drxk",
> +	[0x3e >> 1] = "remote IR sensor",
>  	[0x60 >> 1] = "remote IR sensor",
>  	[0x8e >> 1] = "remote IR sensor",
>  	[0x86 >> 1] = "tda9887",
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 3598221..631e252 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -5,6 +5,7 @@
>  		      Markus Rechberger <mrechberger@gmail.com>
>  		      Mauro Carvalho Chehab <mchehab@infradead.org>
>  		      Sascha Sommer <saschasommer@freenet.de>
> +   Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
>  
>    This program is free software; you can redistribute it and/or modify
>    it under the terms of the GNU General Public License as published by
> @@ -34,6 +35,8 @@
>  #define EM28XX_SBUTTON_QUERY_INTERVAL 500
>  #define EM28XX_R0C_USBSUSP_SNAPSHOT 0x20
>  
> +#define EM28XX_RC_QUERY_INTERVAL 100
> +
>  static unsigned int ir_debug;
>  module_param(ir_debug, int, 0644);
>  MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
> @@ -67,13 +70,14 @@ struct em28xx_IR {
>  	char name[32];
>  	char phys[32];
>  
> -	/* poll external decoder */
>  	int polling;
>  	struct delayed_work work;
>  	unsigned int full_code:1;
>  	unsigned int last_readcount;
>  	u64 rc_type;
>  
> +	struct i2c_client *i2c_dev; /* external i2c IR receiver/decoder */
> +
>  	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
>  };
>  
> @@ -452,7 +456,7 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
>  	}
>  }
>  
> -static void em28xx_register_i2c_ir(struct em28xx *dev)
> +static int em28xx_register_i2c_ir(struct em28xx *dev, struct rc_dev *rc_dev)
>  {
>  	/* Leadtek winfast tv USBII deluxe can find a non working IR-device */
>  	/* at address 0x18, so if that address is needed for another board in */
> @@ -470,30 +474,46 @@ static void em28xx_register_i2c_ir(struct em28xx *dev)
>  	switch (dev->model) {
>  	case EM2800_BOARD_TERRATEC_CINERGY_200:
>  	case EM2820_BOARD_TERRATEC_CINERGY_250:
> -		dev->init_data.ir_codes = RC_MAP_EM_TERRATEC;
> -		dev->init_data.get_key = em28xx_get_key_terratec;
>  		dev->init_data.name = "i2c IR (EM28XX Terratec)";
> +		dev->init_data.type = RC_BIT_OTHER;
> +		dev->init_data.get_key = em28xx_get_key_terratec;
>  		break;
>  	case EM2820_BOARD_PINNACLE_USB_2:
> -		dev->init_data.ir_codes = RC_MAP_PINNACLE_GREY;
> -		dev->init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
>  		dev->init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
> +		dev->init_data.type = RC_BIT_OTHER;
> +		dev->init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
>  		break;
>  	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
> -		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE;
> -		dev->init_data.get_key = em28xx_get_key_em_haup;
>  		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
> +		dev->init_data.type = RC_BIT_RC5;
> +		dev->init_data.get_key = em28xx_get_key_em_haup;
>  		break;
>  	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
> -		dev->init_data.ir_codes = RC_MAP_WINFAST_USBII_DELUXE;
> -		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;
>  		dev->init_data.name = "i2c IR (EM2820 Winfast TV USBII Deluxe)";
> +		dev->init_data.type = RC_BIT_OTHER;
> +		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;
>  		break;
>  	}
>  
> -	if (dev->init_data.name)
> +	if (dev->init_data.name && dev->board.ir_codes) {
> +		dev->init_data.ir_codes = dev->board.ir_codes;
> +		dev->init_data.polling_interval = EM28XX_RC_QUERY_INTERVAL;
> +		dev->init_data.rc_dev = rc_dev;
>  		info.platform_data = &dev->init_data;
> -	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list, NULL);
> +	} else {
> +		em28xx_warn("Unknown i2c remote control device.\n");
> +		em28xx_warn("If the remote control doesn't work properly, please contact <linux-media@vger.kernel.org>\n");
> +	}
> +
> +	dev->ir->i2c_dev = i2c_new_probed_device(&dev->i2c_adap, &info, addr_list, NULL);
> +	if (NULL == dev->ir->i2c_dev)
> +		return -ENODEV;
> +
> +#if defined(CONFIG_MODULES) && defined(MODULE)
> +	request_module("ir-kbd-i2c");
> +#endif
> +
> +	return 0;
>  }
>  
>  /**********************************************************
> @@ -590,7 +610,7 @@ static int em28xx_ir_init(struct em28xx *dev)
>  	int err = -ENOMEM;
>  	u64 rc_type;
>  
> -	if (dev->board.ir_codes == NULL) {
> +	if (dev->board.ir_codes == NULL && !dev->board.has_ir_i2c) {
>  		/* No remote control support */
>  		em28xx_warn("Remote control support is not available for "
>  				"this card.\n");
> @@ -607,68 +627,56 @@ static int em28xx_ir_init(struct em28xx *dev)
>  	dev->ir = ir;
>  	ir->rc = rc;
>  
> -	/*
> -	 * em2874 supports more protocols. For now, let's just announce
> -	 * the two protocols that were already tested
> -	 */
> -	rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
> -	rc->priv = ir;
> -	rc->change_protocol = em28xx_ir_change_protocol;
> -	rc->open = em28xx_ir_start;
> -	rc->close = em28xx_ir_stop;
> -
> -	switch (dev->chip_id) {
> -	case CHIP_ID_EM2860:
> -	case CHIP_ID_EM2883:
> -		rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
> -		break;
> -	case CHIP_ID_EM2884:
> -	case CHIP_ID_EM2874:
> -	case CHIP_ID_EM28174:
> -		rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC | RC_BIT_RC6_0;
> -		break;
> -	default:
> -		err = -ENODEV;
> -		goto error;
> -	}
> -
> -	/* By default, keep protocol field untouched */
> -	rc_type = RC_BIT_UNKNOWN;
> -	err = em28xx_ir_change_protocol(rc, &rc_type);
> -	if (err)
> -		goto error;
> -
> -	/* This is how often we ask the chip for IR information */
> -	ir->polling = 100; /* ms */
> -
> -	/* init input device */
> -	snprintf(ir->name, sizeof(ir->name), "em28xx IR (%s)",
> -						dev->name);
> -
> +	snprintf(ir->name, sizeof(ir->name), "em28xx IR (%s)", dev->name);
>  	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
>  	strlcat(ir->phys, "/input0", sizeof(ir->phys));
> +	ir->polling = EM28XX_RC_QUERY_INTERVAL;
>  
> -	rc->input_name = ir->name;
> -	rc->input_phys = ir->phys;
> -	rc->input_id.bustype = BUS_USB;
>  	rc->input_id.version = 1;
>  	rc->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
>  	rc->input_id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
>  	rc->dev.parent = &dev->udev->dev;
> -	rc->map_name = dev->board.ir_codes;
>  	rc->driver_name = MODULE_NAME;
>  
> -	/* all done */
> -	err = rc_register_device(rc);
> -	if (err)
> -		goto error;
> -
> -	em28xx_register_i2c_ir(dev);
> +	if (dev->board.has_ir_i2c) {
> +		err = em28xx_register_i2c_ir(dev, rc);
> +		if (err < 0)
> +			goto error;
> +	} else {
> +		switch (dev->chip_id) {
> +		case CHIP_ID_EM2860:
> +		case CHIP_ID_EM2883:
> +			rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
> +			break;
> +		case CHIP_ID_EM2884:
> +		case CHIP_ID_EM2874:
> +		case CHIP_ID_EM28174:
> +			rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC | RC_BIT_RC6_0;
> +			break;
> +		default:
> +			err = -ENODEV;
> +			goto error;
> +		}
> +		rc->priv = ir;
> +		rc->change_protocol = em28xx_ir_change_protocol;
> +		rc->open = em28xx_ir_start;
> +		rc->close = em28xx_ir_stop;
> +		rc->input_name = ir->name;
> +		rc->input_phys = ir->phys;
> +		rc->input_id.bustype = BUS_USB;
> +		rc->map_name = dev->board.ir_codes;
> +
> +		/* By default, keep protocol field untouched */
> +		rc_type = RC_BIT_UNKNOWN;
> +		err = em28xx_ir_change_protocol(rc, &rc_type);
> +		if (err)
> +			goto error;
> +
> +		err = rc_register_device(rc);
> +		if (err < 0)
> +			goto error;
> +	}
>  
> -#if defined(CONFIG_MODULES) && defined(MODULE)
> -	if (dev->board.has_ir_i2c)
> -		request_module("ir-kbd-i2c");
> -#endif
>  	if (dev->board.has_snapshot_button)
>  		em28xx_register_snapshot_button(dev);
>  
> @@ -691,7 +699,9 @@ static int em28xx_ir_fini(struct em28xx *dev)
>  	if (!ir)
>  		return 0;
>  
> -	if (ir->rc)
> +	if (ir->i2c_dev)
> +		i2c_unregister_device(ir->i2c_dev);
> +	else if (ir->rc)
>  		rc_unregister_device(ir->rc);
>  
>  	/* done */


-- 

Cheers,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:51573 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaGYW6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 18:58:24 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9A00HRCIHAOO00@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jul 2014 18:58:22 -0400 (EDT)
Date: Fri, 25 Jul 2014 19:58:18 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 37/49] rc-core: allow empty keymaps
Message-id: <20140725195818.4fff7c26.m.chehab@samsung.com>
In-reply-to: <20140403233423.27099.4554.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
 <20140403233423.27099.4554.stgit@zeus.muc.hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Apr 2014 01:34:23 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Remove the RC_MAP_EMPTY hack and instead allow for empty keymaps.

Doesn't apply anymore, but makes sense.

There's just one thing that we need to double check: if a given
device is with an empty keytable, it doesn't make sense to start
IR polling, as IR polling costs power.

So, we need to be sure that we'll only call the IR start method
if the table is filled.

I think the current behavior already takes this into account, but
we need to test it.

Regards,
Mauro

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/i2c/ir-kbd-i2c.c             |    4 +--
>  drivers/media/pci/cx88/cx88-input.c        |    6 -----
>  drivers/media/pci/ivtv/ivtv-i2c.c          |    2 +-
>  drivers/media/rc/gpio-ir-recv.c            |    2 +-
>  drivers/media/rc/img-ir/img-ir-hw.c        |    1 -
>  drivers/media/rc/img-ir/img-ir-raw.c       |    1 -
>  drivers/media/rc/rc-keytable.c             |    3 +++
>  drivers/media/rc/rc-loopback.c             |    1 -
>  drivers/media/rc/rc-main.c                 |   33 ++--------------------------
>  drivers/media/usb/dvb-usb-v2/af9015.c      |    4 ---
>  drivers/media/usb/dvb-usb-v2/af9035.c      |    4 ---
>  drivers/media/usb/dvb-usb-v2/az6007.c      |    4 ++-
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |    4 ---
>  drivers/media/usb/dvb-usb/dvb-usb-remote.c |    4 +--
>  drivers/media/usb/em28xx/em28xx-cards.c    |    1 -
>  include/media/rc-map.h                     |    1 -
>  16 files changed, 11 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
> index 8311f1a..5393558 100644
> --- a/drivers/media/i2c/ir-kbd-i2c.c
> +++ b/drivers/media/i2c/ir-kbd-i2c.c
> @@ -309,7 +309,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		name        = "Pixelview";
>  		ir->get_key = get_key_pixelview;
>  		rc_type     = RC_BIT_OTHER;
> -		ir_codes    = RC_MAP_EMPTY;
>  		break;
>  	case 0x18:
>  	case 0x1f:
> @@ -323,7 +322,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		name        = "KNC One";
>  		ir->get_key = get_key_knc1;
>  		rc_type     = RC_BIT_OTHER;
> -		ir_codes    = RC_MAP_EMPTY;
>  		break;
>  	case 0x6b:
>  		name        = "FusionHDTV";
> @@ -405,7 +403,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	ir->rc = rc;
>  
>  	/* Make sure we are all setup before going on */
> -	if (!name || !ir->get_key || !rc_type || !ir_codes) {
> +	if (!name || !ir->get_key || !rc_type) {
>  		dprintk(1, ": Unsupported device at address 0x%02x\n",
>  			addr);
>  		err = -ENODEV;
> diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
> index 3f1342c..cb587ce 100644
> --- a/drivers/media/pci/cx88/cx88-input.c
> +++ b/drivers/media/pci/cx88/cx88-input.c
> @@ -437,11 +437,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
>  		break;
>  	}
>  
> -	if (!ir_codes) {
> -		err = -ENODEV;
> -		goto err_out_free;
> -	}
> -
>  	/*
>  	 * The usage of mask_keycode were very convenient, due to several
>  	 * reasons. Among others, the scancode tables were using the scancode
> @@ -612,7 +607,6 @@ void cx88_i2c_init_ir(struct cx88_core *core)
>  		core->init_data.name = "cx88 Leadtek PVR 2000 remote";
>  		core->init_data.type = RC_BIT_UNKNOWN;
>  		core->init_data.get_key = get_key_pvr2000;
> -		core->init_data.ir_codes = RC_MAP_EMPTY;
>  		break;
>  	}
>  
> diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
> index 1a41ba5..846bb51 100644
> --- a/drivers/media/pci/ivtv/ivtv-i2c.c
> +++ b/drivers/media/pci/ivtv/ivtv-i2c.c
> @@ -222,7 +222,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
>  		init_data->get_key = get_key_adaptec;
>  		init_data->name = itv->card_name;
>  		/* FIXME: The protocol and RC_MAP needs to be corrected */
> -		init_data->ir_codes = RC_MAP_EMPTY;
> +		/* init_data->ir_codes = RC_MAP_? */
>  		init_data->type = RC_BIT_UNKNOWN;
>  		break;
>  	}
> diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
> index 5985308..7d01560 100644
> --- a/drivers/media/rc/gpio-ir-recv.c
> +++ b/drivers/media/rc/gpio-ir-recv.c
> @@ -148,7 +148,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
>  		rcdev->allowed_protocols = pdata->allowed_protos;
>  	else
>  		rcdev->allowed_protocols = RC_BIT_ALL;
> -	rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
> +	rcdev->map_name = pdata->map_name;
>  
>  	gpio_dev->rcdev = rcdev;
>  	gpio_dev->gpio_nr = pdata->gpio_nr;
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
> index 3bb6a32..5bc7903 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -993,7 +993,6 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
>  		goto err_alloc_rc;
>  	}
>  	rdev->priv = priv;
> -	rdev->map_name = RC_MAP_EMPTY;
>  	rdev->allowed_protocols = img_ir_allowed_protos(priv);
>  	rdev->input_name = "IMG Infrared Decoder";
>  	rdev->s_filter = img_ir_set_normal_filter;
> diff --git a/drivers/media/rc/img-ir/img-ir-raw.c b/drivers/media/rc/img-ir/img-ir-raw.c
> index cfb01d9..5b6d8e9 100644
> --- a/drivers/media/rc/img-ir/img-ir-raw.c
> +++ b/drivers/media/rc/img-ir/img-ir-raw.c
> @@ -111,7 +111,6 @@ int img_ir_probe_raw(struct img_ir_priv *priv)
>  		return -ENOMEM;
>  	}
>  	rdev->priv = priv;
> -	rdev->map_name = RC_MAP_EMPTY;
>  	rdev->input_name = "IMG Infrared Decoder Raw";
>  	rdev->driver_type = RC_DRIVER_IR_RAW;
>  
> diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
> index 89295f3..5709ae6 100644
> --- a/drivers/media/rc/rc-keytable.c
> +++ b/drivers/media/rc/rc-keytable.c
> @@ -55,6 +55,9 @@ struct rc_map *rc_map_get(const char *name)
>  
>  	struct rc_map_list *map;
>  
> +	if (!name)
> +		return NULL;
> +
>  	map = seek_rc_map(name);
>  #ifdef MODULE
>  	if (!map) {
> diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
> index 628e834..f201395 100644
> --- a/drivers/media/rc/rc-loopback.c
> +++ b/drivers/media/rc/rc-loopback.c
> @@ -226,7 +226,6 @@ static int __init loop_init(void)
>  	rc->input_id.bustype	= BUS_VIRTUAL;
>  	rc->input_id.version	= 1;
>  	rc->driver_name		= DRIVER_NAME;
> -	rc->map_name		= RC_MAP_EMPTY;
>  	rc->priv		= &loopdev;
>  	rc->driver_type		= RC_DRIVER_IR_RAW;
>  	rc->allowed_protocols	= RC_BIT_ALL;
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index ad784c8..8729d0a 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -207,12 +207,6 @@ static int rc_add_keytable(struct rc_dev *dev, const char *name,
>  	struct rc_keytable *kt;
>  	unsigned i;
>  
> -	if (!rc_map)
> -		rc_map = rc_map_get(RC_MAP_EMPTY);
> -
> -	if (!rc_map)
> -		return -EFAULT;
> -
>  	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
>  		if (!dev->keytables[i])
>  			break;
> @@ -1321,22 +1315,14 @@ int rc_register_device(struct rc_dev *dev)
>  	if (dev->map_name)
>  		rc_map = rc_map_get(dev->map_name);
>  
> -	if (!rc_map)
> -		rc_map = rc_map_get(RC_MAP_EMPTY);
> -
> -	if (!rc_map || !rc_map->scan || rc_map->size == 0) {
> -		rc = -EFAULT;
> -		goto out_raw;
> -	}
> -
> -	if (dev->change_protocol && rc_map->len > 0) {
> +	if (dev->change_protocol && rc_map && rc_map->len > 0) {
>  		u64 rc_type = (1 << rc_map->scan[0].protocol);
>  		rc = dev->change_protocol(dev, &rc_type);
>  		if (rc < 0)
>  			goto out_raw;
>  		dev->enabled_protocols = rc_type;
>  	}
> -	
> +
>  	rc = cdev_add(&dev->cdev, dev->dev.devt, 1);
>  	if (rc)
>  		goto out_raw;
> @@ -1407,19 +1393,6 @@ void rc_unregister_device(struct rc_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(rc_unregister_device);
>  
> -static struct rc_map_table empty[] = {
> -	{ RC_TYPE_OTHER, 0x2a, KEY_COFFEE },
> -};
> -
> -static struct rc_map_list empty_map = {
> -	.map = {
> -		.scan    = empty,
> -		.size    = ARRAY_SIZE(empty),
> -		.rc_type = RC_TYPE_UNKNOWN,     /* Legacy IR type */
> -		.name    = RC_MAP_EMPTY,
> -	}
> -};
> -
>  static int __init rc_core_init(void)
>  {
>  	int err;
> @@ -1439,14 +1412,12 @@ static int __init rc_core_init(void)
>  
>  	IR_dprintk(1, "Allocated char dev: %u\n", MAJOR(rc_devt));
>  	led_trigger_register_simple("rc-feedback", &led_feedback);
> -	rc_map_register(&empty_map);
>  
>  	return 0;
>  }
>  
>  static void __exit rc_core_exit(void)
>  {
> -	rc_map_unregister(&empty_map);
>  	led_trigger_unregister_simple(led_feedback);
>  	unregister_chrdev_region(rc_devt, RC_DEV_MAX);
>  	class_unregister(&rc_class);
> diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
> index 8776eaf..31066e8 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9015.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9015.c
> @@ -1297,10 +1297,6 @@ static int af9015_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
>  		}
>  	}
>  
> -	/* load empty to enable rc */
> -	if (!rc->map_name)
> -		rc->map_name = RC_MAP_EMPTY;
> -
>  	rc->allowed_protos = RC_BIT_NEC;
>  	rc->query = af9015_rc_query;
>  	rc->interval = 500;
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 6bc9693..cfe0be7 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -1332,10 +1332,6 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
>  
>  		rc->query = af9035_rc_query;
>  		rc->interval = 500;
> -
> -		/* load empty to enable rc */
> -		if (!rc->map_name)
> -			rc->map_name = RC_MAP_EMPTY;
>  	}
>  
>  	return 0;
> diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
> index 7e38278..9c2a07e 100644
> --- a/drivers/media/usb/dvb-usb-v2/az6007.c
> +++ b/drivers/media/usb/dvb-usb-v2/az6007.c
> @@ -922,13 +922,13 @@ static struct dvb_usb_device_properties az6007_cablestar_hdci_props = {
>  
>  static struct usb_device_id az6007_usb_table[] = {
>  	{DVB_USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_6007,
> -		&az6007_props, "Azurewave 6007", RC_MAP_EMPTY)},
> +		&az6007_props, "Azurewave 6007", NULL)},
>  	{DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7,
>  		&az6007_props, "Terratec H7", RC_MAP_NEC_TERRATEC_CINERGY_XS)},
>  	{DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7_2,
>  		&az6007_props, "Terratec H7", RC_MAP_NEC_TERRATEC_CINERGY_XS)},
>  	{DVB_USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_CABLESTAR_HDCI,
> -		&az6007_cablestar_hdci_props, "Technisat CableStar Combo HD CI", RC_MAP_EMPTY)},
> +		&az6007_cablestar_hdci_props, "Technisat CableStar Combo HD CI", NULL)},
>  	{0},
>  };
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 45c77b1..15f1e70 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1270,7 +1270,6 @@ err:
>  static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
>  		struct dvb_usb_rc *rc)
>  {
> -	rc->map_name = RC_MAP_EMPTY;
>  	rc->allowed_protos = RC_BIT_NEC;
>  	rc->query = rtl2831u_rc_query;
>  	rc->interval = 400;
> @@ -1373,9 +1372,6 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
>  	if (rtl28xxu_disable_rc)
>  		return rtl28xx_wr_reg(d, IR_RX_IE, 0x00);
>  
> -	/* load empty to enable rc */
> -	if (!rc->map_name)
> -		rc->map_name = RC_MAP_EMPTY;
>  	rc->allowed_protos = RC_BIT_ALL;
>  	rc->driver_type = RC_DRIVER_IR_RAW;
>  	rc->query = rtl2832u_rc_query;
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
> index 7b5dae3..5986626 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-remote.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
> @@ -313,10 +313,8 @@ int dvb_usb_remote_init(struct dvb_usb_device *d)
>  
>  	if (d->props.rc.legacy.rc_map_table && d->props.rc.legacy.rc_query)
>  		d->props.rc.mode = DVB_RC_LEGACY;
> -	else if (d->props.rc.core.rc_codes)
> -		d->props.rc.mode = DVB_RC_CORE;
>  	else
> -		return 0;
> +		d->props.rc.mode = DVB_RC_CORE;
>  
>  	usb_make_path(d->udev, d->rc_phys, sizeof(d->rc_phys));
>  	strlcat(d->rc_phys, "/ir0", sizeof(d->rc_phys));
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 50aa5a5..cf803f2 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -1120,7 +1120,6 @@ struct em28xx_board em28xx_boards[] = {
>  		.has_dvb      = 1,
>  		/* FIXME: Add analog support - need a saa7136 driver */
>  		.tuner_type = TUNER_ABSENT,	/* Digital-only TDA18271HD */
> -		.ir_codes     = RC_MAP_EMPTY,
>  		.def_i2c_bus  = 1,
>  		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE,
>  		.dvb_gpio     = c3tech_digital_duo_digital,
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index 34c192f..417cce3 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -140,7 +140,6 @@ void rc_map_init(void);
>  #define RC_MAP_DM1105_NEC                "rc-dm1105-nec"
>  #define RC_MAP_DNTV_LIVE_DVBT_PRO        "rc-dntv-live-dvbt-pro"
>  #define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
> -#define RC_MAP_EMPTY                     "rc-empty"
>  #define RC_MAP_EM_TERRATEC               "rc-em-terratec"
>  #define RC_MAP_ENCORE_ENLTV2             "rc-encore-enltv2"
>  #define RC_MAP_ENCORE_ENLTV_FM53         "rc-encore-enltv-fm53"
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab1D2Mv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 08:51:59 -0400
Message-ID: <4DBAB466.4040404@redhat.com>
Date: Fri, 29 Apr 2011 09:51:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB USB should not depend on RC
References: <20110221214906.GA27284@mess.org>
In-Reply-To: <20110221214906.GA27284@mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sean,

Em 21-02-2011 18:49, Sean Young escreveu:
> I have a SheevaPlug which has no (human) input or output devices, with a
> DVB USB device connected with a mythtv backend running. The DVB USB drivers
> pull in the remote control tree, which is unneeded in this case; the
> mythtv client runs elsewhere (where RC is used). However the RC tree depends
> on input which also has dependants. 
> 
> This can save a reasonable amount of memory:
> 
>  $ ./scripts/bloat-o-meter vmlinux vmlinux-no-rc add/remove: 0/909 grow/shrink: 1/20 up/down: 4/-159171 (-159167)

Sorry for a late review. The problem with this patch is that it is too much intrusive.
It is a bad practice to fill the code with lots of #ifdef's, because it makes harder
to analyse the source code and find bugs there. 

Also, while it saves some memory, this strategy forces that all DVB drivers to have a
check for RC_CORE, being very easy that someone would forget about that, causing compilation
breakages if this option is disabled.

The proper way is to have a separate module for RC and just making such module as dependent
of RC_CORE.

Mauro.


> 
> Diff against current mainline.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
> index 3d48ba0..a03bcf5 100644
> --- a/drivers/media/dvb/dvb-usb/Kconfig
> +++ b/drivers/media/dvb/dvb-usb/Kconfig
> @@ -1,6 +1,6 @@
>  config DVB_USB
>  	tristate "Support for various USB DVB devices"
> -	depends on DVB_CORE && USB && I2C && RC_CORE
> +	depends on DVB_CORE && USB && I2C
>  	help
>  	  By enabling this you will be able to choose the various supported
>  	  USB1.1 and USB2.0 DVB devices.
> diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/dvb/dvb-usb/a800.c
> index 53b93a4..b4b6387 100644
> --- a/drivers/media/dvb/dvb-usb/a800.c
> +++ b/drivers/media/dvb/dvb-usb/a800.c
> @@ -37,6 +37,7 @@ static int a800_identify_state(struct usb_device *udev, struct dvb_usb_device_pr
>  	return 0;
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  static struct rc_map_table rc_map_a800_table[] = {
>  	{ 0x0201, KEY_PROG1 },       /* SOURCE */
>  	{ 0x0200, KEY_POWER },       /* POWER */
> @@ -90,6 +91,7 @@ static int a800_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  		deb_rc("key: %x %x %x %x %x\n",key[0],key[1],key[2],key[3],key[4]);
>  	return 0;
>  }
> +#endif
>  
>  /* USB Driver stuff */
>  static struct dvb_usb_device_properties a800_properties;
> @@ -146,12 +148,14 @@ static struct dvb_usb_device_properties a800_properties = {
>  	.power_ctrl       = a800_power_ctrl,
>  	.identify_state   = a800_identify_state,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = DEFAULT_RC_INTERVAL,
>  		.rc_map_table     = rc_map_a800_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_a800_table),
>  		.rc_query         = a800_rc_query,
>  	},
> +#endif
>  
>  	.i2c_algo         = &dibusb_i2c_algo,
>  
> diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb/af9005.c
> index 51f6439..0f1503e 100644
> --- a/drivers/media/dvb/dvb-usb/af9005.c
> +++ b/drivers/media/dvb/dvb-usb/af9005.c
> @@ -42,10 +42,12 @@ MODULE_PARM_DESC(dump_eeprom, "dump contents of the eeprom.");
>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  
>  /* remote control decoder */
> +#ifdef CONFIG_RC_CORE
>  static int (*rc_decode) (struct dvb_usb_device *d, u8 *data, int len,
>  		u32 *event, int *state);
>  static void *rc_keys;
>  static int *rc_keys_size;
> +#endif
>  
>  u8 regmask[8] = { 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff };
>  
> @@ -819,6 +821,7 @@ static int af9005_frontend_attach(struct dvb_usb_adapter *adap)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  static int af9005_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
>  {
>  	struct af9005_device_state *st = d->priv;
> @@ -871,6 +874,7 @@ static int af9005_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
>  	}
>  	return 0;
>  }
> +#endif
>  
>  static int af9005_power_ctrl(struct dvb_usb_device *d, int onoff)
>  {
> @@ -1025,12 +1029,14 @@ static struct dvb_usb_device_properties af9005_properties = {
>  
>  	.i2c_algo = &af9005_i2c_algo,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval = 200,
>  		.rc_map_table = NULL,
>  		.rc_map_size = 0,
>  		.rc_query = af9005_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint          = 2,
>  	.generic_bulk_ctrl_endpoint_response = 1,
> @@ -1069,6 +1075,7 @@ static int __init af9005_usb_module_init(void)
>  		err("usb_register failed. (%d)", result);
>  		return result;
>  	}
> +#ifdef CONFIG_RC_CORE
>  	rc_decode = symbol_request(af9005_rc_decode);
>  	rc_keys = symbol_request(rc_map_af9005_table);
>  	rc_keys_size = symbol_request(rc_map_af9005_table_size);
> @@ -1079,12 +1086,14 @@ static int __init af9005_usb_module_init(void)
>  		af9005_properties.rc.legacy.rc_map_table = rc_keys;
>  		af9005_properties.rc.legacy.rc_map_size = *rc_keys_size;
>  	}
> +#endif
>  
>  	return 0;
>  }
>  
>  static void __exit af9005_usb_module_exit(void)
>  {
> +#ifdef CONFIG_RC_CORE
>  	/* release rc decode symbols */
>  	if (rc_decode != NULL)
>  		symbol_put(af9005_rc_decode);
> @@ -1092,6 +1101,7 @@ static void __exit af9005_usb_module_exit(void)
>  		symbol_put(rc_map_af9005_table);
>  	if (rc_keys_size != NULL)
>  		symbol_put(rc_map_af9005_table_size);
> +#endif
>  	/* deregister this driver from the USB subsystem */
>  	usb_deregister(&af9005_usb_driver);
>  }
> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> index 8671ca3..fe01d13 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -37,9 +37,11 @@
>  static int dvb_usb_af9015_debug;
>  module_param_named(debug, dvb_usb_af9015_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "set debugging level" DVB_USB_DEBUG_STATUS);
> +#ifdef CONFIG_IR_CORE
>  static int dvb_usb_af9015_remote;
>  module_param_named(remote, dvb_usb_af9015_remote, int, 0644);
>  MODULE_PARM_DESC(remote, "select remote");
> +#endif
>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  
>  static DEFINE_MUTEX(af9015_usb_mutex);
> @@ -707,6 +709,7 @@ error:
>  	return ret;
>  }
>  
> +#ifdef CONFIG_IR_CORE
>  struct af9015_rc_setup {
>  	unsigned int id;
>  	char *rc_codes;
> @@ -804,6 +807,7 @@ static void af9015_set_remote_config(struct usb_device *udev,
>  
>  	return;
>  }
> +#endif
>  
>  static int af9015_read_config(struct usb_device *udev)
>  {
> @@ -826,6 +830,7 @@ static int af9015_read_config(struct usb_device *udev)
>  	if (ret)
>  		goto error;
>  
> +#ifdef CONFIG_IR_CORE
>  	deb_info("%s: IR mode:%d\n", __func__, val);
>  	for (i = 0; i < af9015_properties_count; i++) {
>  		if (val == AF9015_IR_MODE_DISABLED)
> @@ -833,6 +838,7 @@ static int af9015_read_config(struct usb_device *udev)
>  		else
>  			af9015_set_remote_config(udev, &af9015_properties[i]);
>  	}
> +#endif
>  
>  	/* TS mode - one or two receivers */
>  	req.addr = AF9015_EEPROM_TS_MODE;
> @@ -1012,6 +1018,7 @@ static int af9015_identify_state(struct usb_device *udev,
>  	return ret;
>  }
>  
> +#ifdef CONFIG_IR_CORE
>  static int af9015_rc_query(struct dvb_usb_device *d)
>  {
>  	struct af9015_state *priv = d->priv;
> @@ -1060,6 +1067,7 @@ error:
>  
>  	return ret;
>  }
> +#endif
>  
>  /* init 2nd I2C adapter */
>  static int af9015_i2c_init(struct dvb_usb_device *d)
> @@ -1343,6 +1351,7 @@ static struct dvb_usb_device_properties af9015_properties[] = {
>  
>  		.identify_state = af9015_identify_state,
>  
> +#ifdef CONFIG_IR_CORE
>  		.rc.core = {
>  			.protocol         = RC_TYPE_NEC,
>  			.module_name      = "af9015",
> @@ -1350,6 +1359,7 @@ static struct dvb_usb_device_properties af9015_properties[] = {
>  			.rc_interval      = AF9015_RC_INTERVAL,
>  			.allowed_protos   = RC_TYPE_NEC,
>  		},
> +#endif
>  
>  		.i2c_algo = &af9015_i2c_algo,
>  
> @@ -1471,6 +1481,7 @@ static struct dvb_usb_device_properties af9015_properties[] = {
>  
>  		.identify_state = af9015_identify_state,
>  
> +#ifdef CONFIG_IR_CORE
>  		.rc.core = {
>  			.protocol         = RC_TYPE_NEC,
>  			.module_name      = "af9015",
> @@ -1478,6 +1489,7 @@ static struct dvb_usb_device_properties af9015_properties[] = {
>  			.rc_interval      = AF9015_RC_INTERVAL,
>  			.allowed_protos   = RC_TYPE_NEC,
>  		},
> +#endif
>  
>  		.i2c_algo = &af9015_i2c_algo,
>  
> @@ -1583,6 +1595,7 @@ static struct dvb_usb_device_properties af9015_properties[] = {
>  
>  		.identify_state = af9015_identify_state,
>  
> +#ifdef CONFIG_IR_CORE
>  		.rc.core = {
>  			.protocol         = RC_TYPE_NEC,
>  			.module_name      = "af9015",
> @@ -1590,6 +1603,7 @@ static struct dvb_usb_device_properties af9015_properties[] = {
>  			.rc_interval      = AF9015_RC_INTERVAL,
>  			.allowed_protos   = RC_TYPE_NEC,
>  		},
> +#endif
>  
>  		.i2c_algo = &af9015_i2c_algo,
>  
> diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
> index 6b402e9..972a208 100644
> --- a/drivers/media/dvb/dvb-usb/anysee.c
> +++ b/drivers/media/dvb/dvb-usb/anysee.c
> @@ -374,6 +374,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  static int anysee_rc_query(struct dvb_usb_device *d)
>  {
>  	u8 buf[] = {CMD_GET_IR_CODE};
> @@ -399,6 +400,7 @@ static int anysee_rc_query(struct dvb_usb_device *d)
>  
>  	return 0;
>  }
> +#endif
>  
>  /* DVB USB Driver stuff */
>  static struct dvb_usb_device_properties anysee_properties;
> @@ -474,6 +476,7 @@ static struct dvb_usb_device_properties anysee_properties = {
>  		}
>  	},
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.core = {
>  		.rc_codes         = RC_MAP_ANYSEE,
>  		.protocol         = RC_TYPE_OTHER,
> @@ -481,6 +484,7 @@ static struct dvb_usb_device_properties anysee_properties = {
>  		.rc_query         = anysee_rc_query,
>  		.rc_interval      = 250,  /* windows driver uses 500ms */
>  	},
> +#endif
>  
>  	.i2c_algo         = &anysee_i2c_algo,
>  
> diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
> index 57e2444..8a478ef 100644
> --- a/drivers/media/dvb/dvb-usb/az6027.c
> +++ b/drivers/media/dvb/dvb-usb/az6027.c
> @@ -385,6 +385,7 @@ static int az6027_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  /* keys for the enclosed remote control */
>  static struct rc_map_table rc_map_az6027_table[] = {
>  	{ 0x01, KEY_1 },
> @@ -396,6 +397,7 @@ static int az6027_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  {
>  	return 0;
>  }
> +#endif
>  
>  /*
>  int az6027_power_ctrl(struct dvb_usb_device *d, int onoff)
> @@ -1126,12 +1128,14 @@ static struct dvb_usb_device_properties az6027_properties = {
>  	.power_ctrl       = az6027_power_ctrl,
>  	.read_mac_address = az6027_read_mac_addr,
>   */
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_map_table     = rc_map_az6027_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_az6027_table),
>  		.rc_interval      = 400,
>  		.rc_query         = az6027_rc_query,
>  	},
> +#endif
>  
>  	.i2c_algo         = &az6027_i2c_algo,
>  
> diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-core.c b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
> index 16f2ce2..82e106f 100644
> --- a/drivers/media/dvb/dvb-usb/cinergyT2-core.c
> +++ b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
> @@ -84,6 +84,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  static struct rc_map_table rc_map_cinergyt2_table[] = {
>  	{ 0x0401, KEY_POWER },
>  	{ 0x0402, KEY_1 },
> @@ -177,6 +178,7 @@ static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  	}
>  	return 0;
>  }
> +#endif
>  
>  static int cinergyt2_usb_probe(struct usb_interface *intf,
>  				const struct usb_device_id *id)
> @@ -217,12 +219,14 @@ static struct dvb_usb_device_properties cinergyt2_properties = {
>  
>  	.power_ctrl       = cinergyt2_power_ctrl,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 50,
>  		.rc_map_table     = rc_map_cinergyt2_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_cinergyt2_table),
>  		.rc_query         = cinergyt2_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 1,
>  
> diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
> index acb5fb2..fe926c6 100644
> --- a/drivers/media/dvb/dvb-usb/cxusb.c
> +++ b/drivers/media/dvb/dvb-usb/cxusb.c
> @@ -383,6 +383,7 @@ static int cxusb_d680_dmb_streaming_ctrl(
>  	}
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  static int cxusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  {
>  	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
> @@ -585,6 +586,7 @@ static struct rc_map_table rc_map_d680_dmb_table[] = {
>  	{ 0x0814, KEY_UNKNOWN },    /* Shuffle */
>  	{ 0x0025, KEY_POWER },
>  };
> +#endif
>  
>  static int cxusb_dee1601_demod_init(struct dvb_frontend* fe)
>  {
> @@ -902,11 +904,6 @@ static int cxusb_dee1601_frontend_attach(struct dvb_usb_adapter *adap)
>  
>  static int cxusb_dualdig4_frontend_attach(struct dvb_usb_adapter *adap)
>  {
> -	u8 ircode[4];
> -	int i;
> -	struct i2c_msg msg = { .addr = 0x6b, .flags = I2C_M_RD,
> -			       .buf = ircode, .len = 4 };
> -
>  	if (usb_set_interface(adap->dev->udev, 0, 1) < 0)
>  		err("set interface failed");
>  
> @@ -922,6 +919,12 @@ static int cxusb_dualdig4_frontend_attach(struct dvb_usb_adapter *adap)
>  				   &adap->dev->i2c_adap)) == NULL)
>  		return -EIO;
>  
> +#ifdef CONFIG_RC_CORE
> +	int i;
> +	u8 ircode[4];
> +	struct i2c_msg msg = { .addr = 0x6b, .flags = I2C_M_RD,
> +			       .buf = ircode, .len = 4 };
> +
>  	/* try to determine if there is no IR decoder on the I2C bus */
>  	for (i = 0; adap->dev->props.rc.legacy.rc_map_table != NULL && i < 5; i++) {
>  		msleep(20);
> @@ -936,6 +939,7 @@ no_IR:
>  			break;
>  		}
>  	}
> +#endif
>  
>  	return 0;
>  }
> @@ -1451,12 +1455,14 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties = {
>  
>  	.i2c_algo         = &cxusb_i2c_algo,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_dvico_portable_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_portable_table),
>  		.rc_query         = cxusb_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> @@ -1504,12 +1510,14 @@ static struct dvb_usb_device_properties cxusb_bluebird_dee1601_properties = {
>  
>  	.i2c_algo         = &cxusb_i2c_algo,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 150,
>  		.rc_map_table     = rc_map_dvico_mce_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_mce_table),
>  		.rc_query         = cxusb_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> @@ -1565,12 +1573,14 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
>  
>  	.i2c_algo         = &cxusb_i2c_algo,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_dvico_portable_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_portable_table),
>  		.rc_query         = cxusb_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  	.num_device_descs = 1,
> @@ -1617,12 +1627,14 @@ static struct dvb_usb_device_properties cxusb_bluebird_dtt7579_properties = {
>  
>  	.i2c_algo         = &cxusb_i2c_algo,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_dvico_portable_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_portable_table),
>  		.rc_query         = cxusb_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> @@ -1668,12 +1680,14 @@ static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_properties = {
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_dvico_mce_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_mce_table),
>  		.rc_query         = cxusb_bluebird2_rc_query,
>  	},
> +#endif
>  
>  	.num_device_descs = 1,
>  	.devices = {
> @@ -1718,12 +1732,14 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties = {
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_dvico_portable_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_portable_table),
>  		.rc_query         = cxusb_bluebird2_rc_query,
>  	},
> +#endif
>  
>  	.num_device_descs = 1,
>  	.devices = {
> @@ -1770,12 +1786,14 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_prope
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_dvico_portable_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_portable_table),
>  		.rc_query         = cxusb_rc_query,
>  	},
> +#endif
>  
>  	.num_device_descs = 1,
>  	.devices = {
> @@ -1863,12 +1881,14 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_dvico_mce_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_dvico_mce_table),
>  		.rc_query         = cxusb_rc_query,
>  	},
> +#endif
>  
>  	.num_device_descs = 1,
>  	.devices = {
> @@ -1913,12 +1933,14 @@ static struct dvb_usb_device_properties cxusb_d680_dmb_properties = {
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_d680_dmb_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_d680_dmb_table),
>  		.rc_query         = cxusb_d680_dmb_rc_query,
>  	},
> +#endif
>  
>  	.num_device_descs = 1,
>  	.devices = {
> @@ -1964,12 +1986,14 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_d680_dmb_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_d680_dmb_table),
>  		.rc_query         = cxusb_d680_dmb_rc_query,
>  	},
> +#endif
>  
>  	.num_device_descs = 1,
>  	.devices = {
> diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
> index 98ffb40..b53c8f0 100644
> --- a/drivers/media/dvb/dvb-usb/dib0700_core.c
> +++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
> @@ -471,6 +471,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>  	return dib0700_ctrl_wr(adap->dev, b, 4);
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
>  {
>  	struct dvb_usb_device *d = rc->priv;
> @@ -645,6 +646,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
>  
>  	return ret;
>  }
> +#endif
>  
>  static int dib0700_probe(struct usb_interface *intf,
>  		const struct usb_device_id *id)
> @@ -667,6 +669,7 @@ static int dib0700_probe(struct usb_interface *intf,
>  			st->fw_version = fw_version;
>  			st->nb_packet_buffer_size = (u32)nb_packet_buffer_size;
>  
> +#ifdef CONFIG_RC_CORE
>  			/* Disable polling mode on newer firmwares */
>  			if (st->fw_version >= 0x10200)
>  				dev->props.rc.core.bulk_mode = true;
> @@ -674,6 +677,7 @@ static int dib0700_probe(struct usb_interface *intf,
>  				dev->props.rc.core.bulk_mode = false;
>  
>  			dib0700_rc_setup(dev);
> +#endif
>  
>  			return 0;
>  		}
> diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
> index defd839..fc7dc6e 100644
> --- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
> @@ -466,6 +466,8 @@ static int stk7700ph_tuner_attach(struct dvb_usb_adapter *adap)
>  		== NULL ? -ENODEV : 0;
>  }
>  
> +#ifdef CONFIG_RC_CORE
> +
>  #define DEFAULT_RC_INTERVAL 50
>  
>  static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
> @@ -532,6 +534,7 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
>  	}
>  	return 0;
>  }
> +#endif
>  
>  /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */
>  static struct dibx000_agc_config stk7700p_7000m_mt2060_agc_config = {
> @@ -1920,6 +1923,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			}
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -1929,6 +1933,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  
>  		.num_adapters = 2,
> @@ -1954,6 +1959,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -1963,6 +1969,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  
>  		.num_adapters = 2,
> @@ -2013,6 +2020,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -2022,6 +2030,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  
>  		.num_adapters = 1,
> @@ -2054,6 +2063,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			}
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -2064,6 +2074,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  
>  		.num_adapters = 1,
> @@ -2130,6 +2141,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -2140,6 +2152,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  
>  		.num_adapters = 1,
> @@ -2174,6 +2187,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -2184,6 +2198,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  
>  		.num_adapters = 2,
> @@ -2242,6 +2257,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -2252,6 +2268,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  
>  		.num_adapters = 2,
> @@ -2289,6 +2306,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
> @@ -2299,6 +2317,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  
>  		.num_adapters = 1,
> @@ -2358,6 +2377,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -2368,6 +2388,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  		.num_adapters = 1,
>  		.adapter = {
> @@ -2394,6 +2415,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -2404,6 +2426,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  		.num_adapters = 1,
>  		.adapter = {
> @@ -2462,6 +2485,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -2472,6 +2496,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  		.num_adapters = 1,
>  		.adapter = {
> @@ -2506,6 +2531,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
> @@ -2516,6 +2542,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  		.num_adapters = 2,
>  		.adapter = {
> @@ -2555,6 +2582,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -2565,6 +2593,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
> +#endif
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
>  		.num_adapters = 1,
>  		.adapter = {
> @@ -2592,6 +2621,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			},
>  		},
>  
> +#ifdef CONFIG_RC_CORE
>  		.rc.core = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
> @@ -2602,6 +2632,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  					    RC_TYPE_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
> +#endif
>  	},
>  };
>  
> diff --git a/drivers/media/dvb/dvb-usb/dibusb-common.c b/drivers/media/dvb/dvb-usb/dibusb-common.c
> index 956f7ae..7bd029f 100644
> --- a/drivers/media/dvb/dvb-usb/dibusb-common.c
> +++ b/drivers/media/dvb/dvb-usb/dibusb-common.c
> @@ -324,6 +324,7 @@ int dibusb_dib3000mc_tuner_attach(struct dvb_usb_adapter *adap)
>  EXPORT_SYMBOL(dibusb_dib3000mc_tuner_attach);
>  #endif
>  
> +#ifdef CONFIG_RC_CORE
>  /*
>   * common remote control stuff
>   */
> @@ -468,3 +469,4 @@ int dibusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  	return 0;
>  }
>  EXPORT_SYMBOL(dibusb_rc_query);
> +#endif
> diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c b/drivers/media/dvb/dvb-usb/dibusb-mb.c
> index 04d91bd..08b6267 100644
> --- a/drivers/media/dvb/dvb-usb/dibusb-mb.c
> +++ b/drivers/media/dvb/dvb-usb/dibusb-mb.c
> @@ -211,12 +211,14 @@ static struct dvb_usb_device_properties dibusb1_1_properties = {
>  
>  	.power_ctrl       = dibusb_power_ctrl,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = DEFAULT_RC_INTERVAL,
>  		.rc_map_table     = rc_map_dibusb_table,
>  		.rc_map_size      = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
>  		.rc_query         = dibusb_rc_query,
>  	},
> +#endif
>  
>  	.i2c_algo         = &dibusb_i2c_algo,
>  
> @@ -297,12 +299,14 @@ static struct dvb_usb_device_properties dibusb1_1_an2235_properties = {
>  	},
>  	.power_ctrl       = dibusb_power_ctrl,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = DEFAULT_RC_INTERVAL,
>  		.rc_map_table     = rc_map_dibusb_table,
>  		.rc_map_size      = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
>  		.rc_query         = dibusb_rc_query,
>  	},
> +#endif
>  
>  	.i2c_algo         = &dibusb_i2c_algo,
>  
> @@ -363,12 +367,14 @@ static struct dvb_usb_device_properties dibusb2_0b_properties = {
>  	},
>  	.power_ctrl       = dibusb2_0_power_ctrl,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = DEFAULT_RC_INTERVAL,
>  		.rc_map_table     = rc_map_dibusb_table,
>  		.rc_map_size      = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
>  		.rc_query         = dibusb_rc_query,
>  	},
> +#endif
>  
>  	.i2c_algo         = &dibusb_i2c_algo,
>  
> @@ -422,12 +428,14 @@ static struct dvb_usb_device_properties artec_t1_usb2_properties = {
>  	},
>  	.power_ctrl       = dibusb2_0_power_ctrl,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = DEFAULT_RC_INTERVAL,
>  		.rc_map_table     = rc_map_dibusb_table,
>  		.rc_map_size      = 111, /* wow, that is ugly ... I want to load it to the driver dynamically */
>  		.rc_query         = dibusb_rc_query,
>  	},
> +#endif
>  
>  	.i2c_algo         = &dibusb_i2c_algo,
>  
> diff --git a/drivers/media/dvb/dvb-usb/dibusb-mc.c b/drivers/media/dvb/dvb-usb/dibusb-mc.c
> index c1d9094..6ad1c23 100644
> --- a/drivers/media/dvb/dvb-usb/dibusb-mc.c
> +++ b/drivers/media/dvb/dvb-usb/dibusb-mc.c
> @@ -81,12 +81,14 @@ static struct dvb_usb_device_properties dibusb_mc_properties = {
>  	},
>  	.power_ctrl       = dibusb2_0_power_ctrl,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = DEFAULT_RC_INTERVAL,
>  		.rc_map_table     = rc_map_dibusb_table,
>  		.rc_map_size      = 111, /* FIXME */
>  		.rc_query         = dibusb_rc_query,
>  	},
> +#endif
>  
>  	.i2c_algo         = &dibusb_i2c_algo,
>  
> diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
> index f2dbce7..dc81cc2 100644
> --- a/drivers/media/dvb/dvb-usb/digitv.c
> +++ b/drivers/media/dvb/dvb-usb/digitv.c
> @@ -161,6 +161,7 @@ static int digitv_tuner_attach(struct dvb_usb_adapter *adap)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  static struct rc_map_table rc_map_digitv_table[] = {
>  	{ 0x5f55, KEY_0 },
>  	{ 0x6f55, KEY_1 },
> @@ -251,6 +252,7 @@ static int digitv_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  		deb_rc("key: %x %x %x %x %x\n",key[0],key[1],key[2],key[3],key[4]);
>  	return 0;
>  }
> +#endif
>  
>  /* DVB USB Driver stuff */
>  static struct dvb_usb_device_properties digitv_properties;
> @@ -310,12 +312,14 @@ static struct dvb_usb_device_properties digitv_properties = {
>  	},
>  	.identify_state   = digitv_identify_state,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 1000,
>  		.rc_map_table     = rc_map_digitv_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_digitv_table),
>  		.rc_query         = digitv_rc_query,
>  	},
> +#endif
>  
>  	.i2c_algo         = &digitv_i2c_algo,
>  
> diff --git a/drivers/media/dvb/dvb-usb/dtt200u.c b/drivers/media/dvb/dvb-usb/dtt200u.c
> index ecd86ec..4082fb2 100644
> --- a/drivers/media/dvb/dvb-usb/dtt200u.c
> +++ b/drivers/media/dvb/dvb-usb/dtt200u.c
> @@ -55,6 +55,7 @@ static int dtt200u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
>  	return dvb_usb_generic_write(adap->dev, b_pid, 4);
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  /* remote control */
>  /* key list for the tiny remote control (Yakumo, don't know about the others) */
>  static struct rc_map_table rc_map_dtt200u_table[] = {
> @@ -87,6 +88,7 @@ static int dtt200u_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  		deb_info("key: %x %x %x %x %x\n",key[0],key[1],key[2],key[3],key[4]);
>  	return 0;
>  }
> +#endif
>  
>  static int dtt200u_frontend_attach(struct dvb_usb_adapter *adap)
>  {
> @@ -161,12 +163,14 @@ static struct dvb_usb_device_properties dtt200u_properties = {
>  	},
>  	.power_ctrl      = dtt200u_power_ctrl,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval     = 300,
>  		.rc_map_table    = rc_map_dtt200u_table,
>  		.rc_map_size     = ARRAY_SIZE(rc_map_dtt200u_table),
>  		.rc_query        = dtt200u_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> @@ -208,12 +212,14 @@ static struct dvb_usb_device_properties wt220u_properties = {
>  	},
>  	.power_ctrl      = dtt200u_power_ctrl,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval     = 300,
>  		.rc_map_table      = rc_map_dtt200u_table,
>  		.rc_map_size = ARRAY_SIZE(rc_map_dtt200u_table),
>  		.rc_query        = dtt200u_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> @@ -255,12 +261,14 @@ static struct dvb_usb_device_properties wt220u_fc_properties = {
>  	},
>  	.power_ctrl      = dtt200u_power_ctrl,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval     = 300,
>  		.rc_map_table    = rc_map_dtt200u_table,
>  		.rc_map_size     = ARRAY_SIZE(rc_map_dtt200u_table),
>  		.rc_query        = dtt200u_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> @@ -302,12 +310,14 @@ static struct dvb_usb_device_properties wt220u_zl0353_properties = {
>  	},
>  	.power_ctrl      = dtt200u_power_ctrl,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval     = 300,
>  		.rc_map_table    = rc_map_dtt200u_table,
>  		.rc_map_size     = ARRAY_SIZE(rc_map_dtt200u_table),
>  		.rc_query        = dtt200u_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
> index 23005b3..4a5de7a 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
> @@ -8,6 +8,7 @@
>  #include "dvb-usb-common.h"
>  #include <linux/usb/input.h>
>  
> +#ifdef CONFIG_RC_CORE
>  static int legacy_dvb_usb_getkeycode(struct input_dev *dev,
>  				unsigned int scancode, unsigned int *keycode)
>  {
> @@ -362,3 +363,7 @@ int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *d,
>  	return 0;
>  }
>  EXPORT_SYMBOL(dvb_usb_nec_rc_key_to_event);
> +#else
> +int dvb_usb_remote_init(struct dvb_usb_device *d) { return 0; }
> +int dvb_usb_remote_exit(struct dvb_usb_device *d) { return 0; }
> +#endif
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
> index 65fa926..0920ba1 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
> @@ -270,11 +270,13 @@ struct dvb_usb_device_properties {
>  	int (*identify_state)   (struct usb_device *, struct dvb_usb_device_properties *,
>  			struct dvb_usb_device_description **, int *);
>  
> +#ifdef CONFIG_RC_CORE
>  	struct {
>  		enum dvb_usb_mode mode;	/* Drivers shouldn't touch on it */
>  		struct dvb_rc_legacy legacy;
>  		struct dvb_rc core;
>  	} rc;
> +#endif
>  
>  	struct i2c_algorithm *i2c_algo;
>  
> diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
> index 2c307ba..9a61a3f 100644
> --- a/drivers/media/dvb/dvb-usb/dw2102.c
> +++ b/drivers/media/dvb/dvb-usb/dw2102.c
> @@ -83,11 +83,12 @@ static int dvb_usb_dw2102_debug;
>  module_param_named(debug, dvb_usb_dw2102_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "set debugging level (1=info 2=xfer 4=rc(or-able))."
>  						DVB_USB_DEBUG_STATUS);
> -
> +#ifdef CONFIG_RC_CORE
>  /* keymaps */
>  static int ir_keymap;
>  module_param_named(keymap, ir_keymap, int, 0644);
>  MODULE_PARM_DESC(keymap, "set keymap 0=default 1=dvbworld 2=tevii 3=tbs  ...");
> +#endif
>  
>  /* demod probe */
>  static int demod_probe = 1;
> @@ -948,6 +949,7 @@ static int dw3101_tuner_attach(struct dvb_usb_adapter *adap)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  static struct rc_map_table rc_map_dw210x_table[] = {
>  	{ 0xf80a, KEY_Q },		/*power*/
>  	{ 0xf80c, KEY_M },		/*mute*/
> @@ -1113,6 +1115,7 @@ static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  
>  	return 0;
>  }
> +#endif
>  
>  static struct usb_device_id dw2102_table[] = {
>  	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2102)},
> @@ -1185,14 +1188,18 @@ static int dw2102_load_firmware(struct usb_device *dev,
>  		/* init registers */
>  		switch (dev->descriptor.idProduct) {
>  		case USB_PID_PROF_1100:
> +#ifdef CONFIG_RC_CORE
>  			s6x0_properties.rc.legacy.rc_map_table = rc_map_tbs_table;
>  			s6x0_properties.rc.legacy.rc_map_size =
>  					ARRAY_SIZE(rc_map_tbs_table);
> +#endif
>  			break;
>  		case USB_PID_TEVII_S650:
> +#ifdef CONFIG_RC_CORE
>  			dw2104_properties.rc.legacy.rc_map_table = rc_map_tevii_table;
>  			dw2104_properties.rc.legacy.rc_map_size =
>  					ARRAY_SIZE(rc_map_tevii_table);
> +#endif
>  		case USB_PID_DW2104:
>  			reset = 1;
>  			dw210x_op_rw(dev, 0xc4, 0x0000, 0, &reset, 1,
> @@ -1256,12 +1263,14 @@ static struct dvb_usb_device_properties dw2102_properties = {
>  
>  	.i2c_algo = &dw2102_serit_i2c_algo,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_map_table = rc_map_dw210x_table,
>  		.rc_map_size = ARRAY_SIZE(rc_map_dw210x_table),
>  		.rc_interval = 150,
>  		.rc_query = dw2102_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x81,
>  	/* parameter for the MPEG2-data transfer */
> @@ -1309,12 +1318,14 @@ static struct dvb_usb_device_properties dw2104_properties = {
>  	.no_reconnect = 1,
>  
>  	.i2c_algo = &dw2104_i2c_algo,
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_map_table = rc_map_dw210x_table,
>  		.rc_map_size = ARRAY_SIZE(rc_map_dw210x_table),
>  		.rc_interval = 150,
>  		.rc_query = dw2102_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x81,
>  	/* parameter for the MPEG2-data transfer */
> @@ -1358,12 +1369,14 @@ static struct dvb_usb_device_properties dw3101_properties = {
>  	.no_reconnect = 1,
>  
>  	.i2c_algo = &dw3101_i2c_algo,
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_map_table = rc_map_dw210x_table,
>  		.rc_map_size = ARRAY_SIZE(rc_map_dw210x_table),
>  		.rc_interval = 150,
>  		.rc_query = dw2102_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x81,
>  	/* parameter for the MPEG2-data transfer */
> @@ -1403,12 +1416,14 @@ static struct dvb_usb_device_properties s6x0_properties = {
>  	.no_reconnect = 1,
>  
>  	.i2c_algo = &s6x0_i2c_algo,
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_map_table = rc_map_tevii_table,
>  		.rc_map_size = ARRAY_SIZE(rc_map_tevii_table),
>  		.rc_interval = 150,
>  		.rc_query = dw2102_rc_query,
>  	},
> +#endif
>  
>  	.generic_bulk_ctrl_endpoint = 0x81,
>  	.num_adapters = 1,
> @@ -1468,8 +1483,10 @@ static int dw2102_probe(struct usb_interface *intf,
>  	/* fill only different fields */
>  	p7500->firmware = "dvb-usb-p7500.fw";
>  	p7500->devices[0] = d7500;
> +#ifdef CONFIG_RC_CORE
>  	p7500->rc.legacy.rc_map_table = rc_map_tbs_table;
>  	p7500->rc.legacy.rc_map_size = ARRAY_SIZE(rc_map_tbs_table);
> +#endif
>  	p7500->adapter->frontend_attach = prof_7500_frontend_attach;
>  
>  	if (0 == dvb_usb_device_init(intf, &dw2102_properties,
> diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> index 9eea418..caceda5 100644
> --- a/drivers/media/dvb/dvb-usb/lmedm04.c
> +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> @@ -193,12 +193,14 @@ static int lme2510_stream_restart(struct dvb_usb_device *d)
>  }
>  static int lme2510_remote_keypress(struct dvb_usb_adapter *adap, u16 keypress)
>  {
> +#ifdef CONFIG_RC_CORE
>  	struct dvb_usb_device *d = adap->dev;
>  
>  	deb_info(1, "INT Key Keypress =%04x", keypress);
>  
>  	if (keypress > 0)
>  		rc_keydown(d->rc_dev, keypress, 0);
> +#endif
>  
>  	return 0;
>  }
> @@ -554,6 +556,8 @@ static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>  
>  static int lme2510_int_service(struct dvb_usb_adapter *adap)
>  {
> +	int ret;
> +#ifdef CONFIG_RC_CORE
>  	struct dvb_usb_device *d = adap->dev;
>  	struct rc_dev *rc;
>  	int ret;
> @@ -579,14 +583,17 @@ static int lme2510_int_service(struct dvb_usb_adapter *adap)
>  		return ret;
>  	}
>  	d->rc_dev = rc;
> +#endif
>  
>  	/* Start the Interupt */
>  	ret = lme2510_int_read(adap);
> +#ifdef CONFIG_RC_CORE
>  	if (ret < 0) {
>  		rc_unregister_device(rc);
>  		info("INT Unable to start Interupt Service");
>  		return -ENODEV;
>  	}
> +#endif
>  
>  	return 0;
>  }
> @@ -1061,7 +1068,9 @@ void *lme2510_exit_int(struct dvb_usb_device *d)
>  		usb_free_coherent(d->udev, 5000, st->buffer,
>  				  st->lme_urb->transfer_dma);
>  		info("Interupt Service Stopped");
> +#ifdef CONFIG_RC_CORE
>  		rc_unregister_device(d->rc_dev);
> +#endif
>  		info("Remote Stopped");
>  	}
>  	return buffer;
> diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
> index da9dc91..63c873a 100644
> --- a/drivers/media/dvb/dvb-usb/m920x.c
> +++ b/drivers/media/dvb/dvb-usb/m920x.c
> @@ -68,6 +68,7 @@ static int m920x_init(struct dvb_usb_device *d, struct m920x_inits *rc_seq)
>  	int ret = 0, i, epi, flags = 0;
>  	int adap_enabled[M9206_MAX_ADAPTERS] = { 0 };
>  
> +#ifdef CONFIG_RC_CORE
>  	/* Remote controller init. */
>  	if (d->props.rc.legacy.rc_query) {
>  		deb("Initialising remote control\n");
> @@ -84,6 +85,7 @@ static int m920x_init(struct dvb_usb_device *d, struct m920x_inits *rc_seq)
>  
>  		deb("Initialising remote control success\n");
>  	}
> +#endif
>  
>  	for (i = 0; i < d->props.num_adapters; i++)
>  		flags |= d->adapter[i].props.caps;
> @@ -130,6 +132,7 @@ static int m920x_init_ep(struct usb_interface *intf)
>  				 alt->desc.bAlternateSetting);
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  {
>  	struct m920x_state *m = d->priv;
> @@ -192,6 +195,7 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  
>  	return ret;
>  }
> +#endif
>  
>  /* I2C */
>  static int m920x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
> @@ -588,6 +592,7 @@ static struct m920x_inits pinnacle310e_init[] = {
>  	{ } /* terminating entry */
>  };
>  
> +#ifdef CONFIG_RC_CORE
>  /* ir keymaps */
>  static struct rc_map_table rc_map_megasky_table[] = {
>  	{ 0x0012, KEY_POWER },
> @@ -683,6 +688,7 @@ static struct rc_map_table rc_map_pinnacle310e_table[] = {
>  	{ 0x5e, KEY_SAT },			/* Yellow */
>  	{ 0x5f, KEY_PLAYER },		/* Blue */
>  };
> +#endif
>  
>  /* DVB USB Driver stuff */
>  static struct dvb_usb_device_properties megasky_properties;
> @@ -784,12 +790,14 @@ static struct dvb_usb_device_properties megasky_properties = {
>  	.firmware = "dvb-usb-megasky-02.fw",
>  	.download_firmware = m920x_firmware_download,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_megasky_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_megasky_table),
>  		.rc_query         = m920x_rc_query,
>  	},
> +#endif
>  
>  	.size_of_priv     = sizeof(struct m920x_state),
>  
> @@ -887,12 +895,14 @@ static struct dvb_usb_device_properties tvwalkertwin_properties = {
>  	.firmware = "dvb-usb-tvwalkert.fw",
>  	.download_firmware = m920x_firmware_download,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_tvwalkertwin_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_tvwalkertwin_table),
>  		.rc_query         = m920x_rc_query,
>  	},
> +#endif
>  
>  	.size_of_priv     = sizeof(struct m920x_state),
>  
> @@ -996,12 +1006,14 @@ static struct dvb_usb_device_properties pinnacle_pctv310e_properties = {
>  	.usb_ctrl = DEVICE_SPECIFIC,
>  	.download_firmware = NULL,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_pinnacle310e_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_pinnacle310e_table),
>  		.rc_query         = m920x_rc_query,
>  	},
> +#endif
>  
>  	.size_of_priv     = sizeof(struct m920x_state),
>  
> diff --git a/drivers/media/dvb/dvb-usb/nova-t-usb2.c b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
> index 9d3cd2d..267e259 100644
> --- a/drivers/media/dvb/dvb-usb/nova-t-usb2.c
> +++ b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
> @@ -20,6 +20,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  #define deb_rc(args...) dprintk(debug,0x01,args)
>  #define deb_ee(args...) dprintk(debug,0x02,args)
>  
> +#ifdef CONFIG_RC_CORE
>  /* Hauppauge NOVA-T USB2 keys */
>  static struct rc_map_table rc_map_haupp_table[] = {
>  	{ 0x1e00, KEY_0 },
> @@ -119,6 +120,7 @@ static int nova_t_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  
>  	return 0;
>  }
> +#endif
>  
>  static int nova_t_read_mac_address (struct dvb_usb_device *d, u8 mac[6])
>  {
> @@ -195,12 +197,14 @@ static struct dvb_usb_device_properties nova_t_properties = {
>  	.power_ctrl       = dibusb2_0_power_ctrl,
>  	.read_mac_address = nova_t_read_mac_address,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 100,
>  		.rc_map_table     = rc_map_haupp_table,
>  		.rc_map_size      = ARRAY_SIZE(rc_map_haupp_table),
>  		.rc_query         = nova_t_rc_query,
>  	},
> +#endif
>  
>  	.i2c_algo         = &dibusb_i2c_algo,
>  
> diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
> index 1f1b7d6..1a66bcf 100644
> --- a/drivers/media/dvb/dvb-usb/opera1.c
> +++ b/drivers/media/dvb/dvb-usb/opera1.c
> @@ -331,6 +331,7 @@ static int opera1_pid_filter_control(struct dvb_usb_adapter *adap, int onoff)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  static struct rc_map_table rc_map_opera1_table[] = {
>  	{0x5fa0, KEY_1},
>  	{0x51af, KEY_2},
> @@ -418,6 +419,7 @@ static int opera1_rc_query(struct dvb_usb_device *dev, u32 * event, int *state)
>  		*state = REMOTE_NO_KEY_PRESSED;
>  	return 0;
>  }
> +#endif
>  
>  static struct usb_device_id opera1_table[] = {
>  	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_OPERA1_COLD)},
> @@ -496,12 +498,14 @@ static struct dvb_usb_device_properties opera1_properties = {
>  	.power_ctrl = opera1_power_ctrl,
>  	.i2c_algo = &opera1_i2c_algo,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_map_table = rc_map_opera1_table,
>  		.rc_map_size = ARRAY_SIZE(rc_map_opera1_table),
>  		.rc_interval = 200,
>  		.rc_query = opera1_rc_query,
>  	},
> +#endif
>  	.read_mac_address = opera1_read_mac_address,
>  	.generic_bulk_ctrl_endpoint = 0x00,
>  	/* parameter for the MPEG2-data transfer */
> diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
> index 0d4709f..88e435f 100644
> --- a/drivers/media/dvb/dvb-usb/ttusb2.c
> +++ b/drivers/media/dvb/dvb-usb/ttusb2.c
> @@ -129,6 +129,8 @@ static struct i2c_algorithm ttusb2_i2c_algo = {
>  	.functionality = ttusb2_i2c_func,
>  };
>  
> +#ifdef CONFIG_RC_CORE
> +
>  /* command to poll IR receiver (copied from pctv452e.c) */
>  #define CMD_GET_IR_CODE     0x1b
>  
> @@ -154,7 +156,7 @@ static int tt3650_rc_query(struct dvb_usb_device *d)
>  
>  	return 0;
>  }
> -
> +#endif
>  
>  /* Callbacks for DVB USB */
>  static int ttusb2_identify_state (struct usb_device *udev, struct
> @@ -373,12 +375,14 @@ static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
>  
>  	.size_of_priv = sizeof(struct ttusb2_state),
>  
> +#ifdef CONFIG_RC_OCRE
>  	.rc.core = {
>  		.rc_interval      = 150, /* Less than IR_KEYPRESS_TIMEOUT */
>  		.rc_codes         = RC_MAP_TT_1500,
>  		.rc_query         = tt3650_rc_query,
>  		.allowed_protos   = RC_TYPE_UNKNOWN,
>  	},
> +#endif
>  
>  	.num_adapters = 1,
>  	.adapter = {
> diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
> index 7890e75..6de2397 100644
> --- a/drivers/media/dvb/dvb-usb/vp702x.c
> +++ b/drivers/media/dvb/dvb-usb/vp702x.c
> @@ -173,6 +173,7 @@ static int vp702x_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  /* keys for the enclosed remote control */
>  static struct rc_map_table rc_map_vp702x_table[] = {
>  	{ 0x0001, KEY_1 },
> @@ -205,7 +206,7 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  		}
>  	return 0;
>  }
> -
> +#endif
>  
>  static int vp702x_read_mac_addr(struct dvb_usb_device *d,u8 mac[6])
>  {
> @@ -283,12 +284,14 @@ static struct dvb_usb_device_properties vp702x_properties = {
>  	},
>  	.read_mac_address = vp702x_read_mac_addr,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_map_table       = rc_map_vp702x_table,
>  		.rc_map_size  = ARRAY_SIZE(rc_map_vp702x_table),
>  		.rc_interval      = 400,
>  		.rc_query         = vp702x_rc_query,
>  	},
> +#endif
>  
>  	.num_device_descs = 1,
>  	.devices = {
> diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
> index ab0ab3c..a7c1fac 100644
> --- a/drivers/media/dvb/dvb-usb/vp7045.c
> +++ b/drivers/media/dvb/dvb-usb/vp7045.c
> @@ -95,6 +95,7 @@ static int vp7045_power_ctrl(struct dvb_usb_device *d, int onoff)
>  	return vp7045_usb_op(d,SET_TUNER_POWER,&v,1,NULL,0,150);
>  }
>  
> +#ifdef CONFIG_RC_CORE
>  /* remote control stuff */
>  
>  /* The keymapping struct. Somehow this should be loaded to the driver, but
> @@ -173,6 +174,7 @@ static int vp7045_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  		}
>  	return 0;
>  }
> +#endif
>  
>  static int vp7045_read_eeprom(struct dvb_usb_device *d,u8 *buf, int len, int offset)
>  {
> @@ -259,12 +261,14 @@ static struct dvb_usb_device_properties vp7045_properties = {
>  	.power_ctrl       = vp7045_power_ctrl,
>  	.read_mac_address = vp7045_read_mac_addr,
>  
> +#ifdef CONFIG_RC_CORE
>  	.rc.legacy = {
>  		.rc_interval      = 400,
>  		.rc_map_table       = rc_map_vp7045_table,
>  		.rc_map_size  = ARRAY_SIZE(rc_map_vp7045_table),
>  		.rc_query         = vp7045_rc_query,
>  	},
> +#endif
>  
>  	.num_device_descs = 2,
>  	.devices = {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:57055 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab2JQQS6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 12:18:58 -0400
Date: Wed, 17 Oct 2012 17:18:56 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH] rc-core: add separate defines for protocol bitmaps and
 numbers
Message-ID: <20121017161856.GA10964@pequod.mess.org>
References: <20121011231154.22683.2502.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121011231154.22683.2502.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 12, 2012 at 01:11:54AM +0200, David Härdeman wrote:
> The RC_TYPE_* defines are currently used both where a single protocol is
> expected and where a bitmap of protocols is expected. This patch tries
> to separate the two in preparation for the following patches.

I'm not sure why this is needed.

> The intended use is also clearer to anyone reading the code. Where a
> single protocol is expected, enum rc_type is used, where one or more
> protocol(s) are expected, something like u64 is used.

Having two sets of #define and enums for the same information is not
necessarily clearer. I don't like the name RC_BIT_* either; how about
RC_PROTO_*?

Sean

> The patch has been rewritten so that the format of the sysfs "protocols"
> file is no longer altered (at the loss of some detail). The file itself
> should probably be deprecated in the future though.
> 
> I missed some drivers when creating the last version of the patch because
> some weren't enabled in my .config. This patch passes an allmodyes build.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/common/siano/smsir.c           |    2 
>  drivers/media/i2c/ir-kbd-i2c.c               |   14 +-
>  drivers/media/pci/cx18/cx18-i2c.c            |    2 
>  drivers/media/pci/cx23885/cx23885-input.c    |    6 +
>  drivers/media/pci/cx88/cx88-input.c          |    8 +
>  drivers/media/pci/ivtv/ivtv-i2c.c            |    8 +
>  drivers/media/pci/saa7134/saa7134-input.c    |    2 
>  drivers/media/rc/ati_remote.c                |    2 
>  drivers/media/rc/ene_ir.c                    |    2 
>  drivers/media/rc/fintek-cir.c                |    2 
>  drivers/media/rc/gpio-ir-recv.c              |    2 
>  drivers/media/rc/iguanair.c                  |    2 
>  drivers/media/rc/imon.c                      |   40 +++----
>  drivers/media/rc/ir-jvc-decoder.c            |    4 -
>  drivers/media/rc/ir-lirc-codec.c             |    4 -
>  drivers/media/rc/ir-mce_kbd-decoder.c        |    4 -
>  drivers/media/rc/ir-nec-decoder.c            |    4 -
>  drivers/media/rc/ir-rc5-decoder.c            |   14 ++
>  drivers/media/rc/ir-rc5-sz-decoder.c         |    6 +
>  drivers/media/rc/ir-rc6-decoder.c            |    8 +
>  drivers/media/rc/ir-sanyo-decoder.c          |    4 -
>  drivers/media/rc/ir-sony-decoder.c           |   17 +++
>  drivers/media/rc/ite-cir.c                   |    2 
>  drivers/media/rc/keymaps/rc-imon-mce.c       |    2 
>  drivers/media/rc/keymaps/rc-rc6-mce.c        |    2 
>  drivers/media/rc/mceusb.c                    |    2 
>  drivers/media/rc/nuvoton-cir.c               |    2 
>  drivers/media/rc/rc-loopback.c               |    2 
>  drivers/media/rc/rc-main.c                   |   73 +++++++------
>  drivers/media/rc/redrat3.c                   |    2 
>  drivers/media/rc/streamzap.c                 |    2 
>  drivers/media/rc/ttusbir.c                   |    2 
>  drivers/media/rc/winbond-cir.c               |    2 
>  drivers/media/usb/cx231xx/cx231xx-input.c    |    2 
>  drivers/media/usb/dvb-usb-v2/af9015.c        |    2 
>  drivers/media/usb/dvb-usb-v2/af9035.c        |    4 -
>  drivers/media/usb/dvb-usb-v2/anysee.c        |    2 
>  drivers/media/usb/dvb-usb-v2/az6007.c        |    2 
>  drivers/media/usb/dvb-usb-v2/dvb_usb.h       |    2 
>  drivers/media/usb/dvb-usb-v2/it913x.c        |    2 
>  drivers/media/usb/dvb-usb-v2/lmedm04.c       |    2 
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c      |    4 -
>  drivers/media/usb/dvb-usb/dib0700.h          |    2 
>  drivers/media/usb/dvb-usb/dib0700_core.c     |   16 ++-
>  drivers/media/usb/dvb-usb/dib0700_devices.c  |  146 +++++++++++++-------------
>  drivers/media/usb/dvb-usb/dvb-usb.h          |    2 
>  drivers/media/usb/dvb-usb/pctv452e.c         |    4 -
>  drivers/media/usb/dvb-usb/technisat-usb2.c   |    2 
>  drivers/media/usb/dvb-usb/ttusb2.c           |    2 
>  drivers/media/usb/em28xx/em28xx-input.c      |   16 ++-
>  drivers/media/usb/hdpvr/hdpvr-i2c.c          |    2 
>  drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |    4 -
>  drivers/media/usb/tm6000/tm6000-input.c      |   20 ++--
>  include/media/ir-kbd-i2c.h                   |    2 
>  include/media/rc-core.h                      |    4 -
>  include/media/rc-map.h                       |   64 +++++++++--
>  56 files changed, 314 insertions(+), 244 deletions(-)
> 
> diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
> index 37bc5c4..b8c5cad 100644
> --- a/drivers/media/common/siano/smsir.c
> +++ b/drivers/media/common/siano/smsir.c
> @@ -88,7 +88,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
>  
>  	dev->priv = coredev;
>  	dev->driver_type = RC_DRIVER_IR_RAW;
> -	dev->allowed_protos = RC_TYPE_ALL;
> +	dev->allowed_protos = RC_BIT_ALL;
>  	dev->map_name = sms_get_board(board_id)->rc_codes;
>  	dev->driver_name = MODULE_NAME;
>  
> diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
> index 04f192a..08ae067 100644
> --- a/drivers/media/i2c/ir-kbd-i2c.c
> +++ b/drivers/media/i2c/ir-kbd-i2c.c
> @@ -284,7 +284,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  {
>  	char *ir_codes = NULL;
>  	const char *name = NULL;
> -	u64 rc_type = RC_TYPE_UNKNOWN;
> +	u64 rc_type = RC_BIT_UNKNOWN;
>  	struct IR_i2c *ir;
>  	struct rc_dev *rc = NULL;
>  	struct i2c_adapter *adap = client->adapter;
> @@ -303,7 +303,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	case 0x64:
>  		name        = "Pixelview";
>  		ir->get_key = get_key_pixelview;
> -		rc_type     = RC_TYPE_OTHER;
> +		rc_type     = RC_BIT_OTHER;
>  		ir_codes    = RC_MAP_EMPTY;
>  		break;
>  	case 0x18:
> @@ -311,31 +311,31 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	case 0x1a:
>  		name        = "Hauppauge";
>  		ir->get_key = get_key_haup;
> -		rc_type     = RC_TYPE_RC5;
> +		rc_type     = RC_BIT_RC5;
>  		ir_codes    = RC_MAP_HAUPPAUGE;
>  		break;
>  	case 0x30:
>  		name        = "KNC One";
>  		ir->get_key = get_key_knc1;
> -		rc_type     = RC_TYPE_OTHER;
> +		rc_type     = RC_BIT_OTHER;
>  		ir_codes    = RC_MAP_EMPTY;
>  		break;
>  	case 0x6b:
>  		name        = "FusionHDTV";
>  		ir->get_key = get_key_fusionhdtv;
> -		rc_type     = RC_TYPE_RC5;
> +		rc_type     = RC_BIT_RC5;
>  		ir_codes    = RC_MAP_FUSIONHDTV_MCE;
>  		break;
>  	case 0x40:
>  		name        = "AVerMedia Cardbus remote";
>  		ir->get_key = get_key_avermedia_cardbus;
> -		rc_type     = RC_TYPE_OTHER;
> +		rc_type     = RC_BIT_OTHER;
>  		ir_codes    = RC_MAP_AVERMEDIA_CARDBUS;
>  		break;
>  	case 0x71:
>  		name        = "Hauppauge/Zilog Z8";
>  		ir->get_key = get_key_haup_xvr;
> -		rc_type     = RC_TYPE_RC5;
> +		rc_type     = RC_BIT_RC5;
>  		ir_codes    = RC_MAP_HAUPPAUGE;
>  		break;
>  	}
> diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
> index 51609d5..4908eb7 100644
> --- a/drivers/media/pci/cx18/cx18-i2c.c
> +++ b/drivers/media/pci/cx18/cx18-i2c.c
> @@ -98,7 +98,7 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
>  	case CX18_HW_Z8F0811_IR_RX_HAUP:
>  		init_data->ir_codes = RC_MAP_HAUPPAUGE;
>  		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
> -		init_data->type = RC_TYPE_RC5;
> +		init_data->type = RC_BIT_RC5;
>  		init_data->name = cx->card_name;
>  		info.platform_data = init_data;
>  		break;
> diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
> index 5606672..11a636b 100644
> --- a/drivers/media/pci/cx23885/cx23885-input.c
> +++ b/drivers/media/pci/cx23885/cx23885-input.c
> @@ -270,21 +270,21 @@ int cx23885_input_init(struct cx23885_dev *dev)
>  	case CX23885_BOARD_HAUPPAUGE_HVR1250:
>  		/* Integrated CX2388[58] IR controller */
>  		driver_type = RC_DRIVER_IR_RAW;
> -		allowed_protos = RC_TYPE_ALL;
> +		allowed_protos = RC_BIT_ALL;
>  		/* The grey Hauppauge RC-5 remote */
>  		rc_map = RC_MAP_HAUPPAUGE;
>  		break;
>  	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
>  		/* Integrated CX23885 IR controller */
>  		driver_type = RC_DRIVER_IR_RAW;
> -		allowed_protos = RC_TYPE_NEC;
> +		allowed_protos = RC_BIT_NEC;
>  		/* The grey Terratec remote with orange buttons */
>  		rc_map = RC_MAP_NEC_TERRATEC_CINERGY_XS;
>  		break;
>  	case CX23885_BOARD_TEVII_S470:
>  		/* Integrated CX23885 IR controller */
>  		driver_type = RC_DRIVER_IR_RAW;
> -		allowed_protos = RC_TYPE_ALL;
> +		allowed_protos = RC_BIT_ALL;
>  		/* A guess at the remote */
>  		rc_map = RC_MAP_TEVII_NEC;
>  		break;
> diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
> index ebf448c..f29e18c 100644
> --- a/drivers/media/pci/cx88/cx88-input.c
> +++ b/drivers/media/pci/cx88/cx88-input.c
> @@ -248,7 +248,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
>  	struct cx88_IR *ir;
>  	struct rc_dev *dev;
>  	char *ir_codes = NULL;
> -	u64 rc_type = RC_TYPE_OTHER;
> +	u64 rc_type = RC_BIT_OTHER;
>  	int err = -ENOMEM;
>  	u32 hardware_mask = 0;	/* For devices with a hardware mask, when
>  				 * used with a full-code IR table
> @@ -416,7 +416,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
>  		break;
>  	case CX88_BOARD_TWINHAN_VP1027_DVBS:
>  		ir_codes         = RC_MAP_TWINHAN_VP1027_DVBS;
> -		rc_type          = RC_TYPE_NEC;
> +		rc_type          = RC_BIT_NEC;
>  		ir->sampling     = 0xff00; /* address */
>  		break;
>  	}
> @@ -592,7 +592,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
>  	case CX88_BOARD_LEADTEK_PVR2000:
>  		addr_list = pvr2000_addr_list;
>  		core->init_data.name = "cx88 Leadtek PVR 2000 remote";
> -		core->init_data.type = RC_TYPE_UNKNOWN;
> +		core->init_data.type = RC_BIT_UNKNOWN;
>  		core->init_data.get_key = get_key_pvr2000;
>  		core->init_data.ir_codes = RC_MAP_EMPTY;
>  		break;
> @@ -613,7 +613,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
>  			/* Hauppauge XVR */
>  			core->init_data.name = "cx88 Hauppauge XVR remote";
>  			core->init_data.ir_codes = RC_MAP_HAUPPAUGE;
> -			core->init_data.type = RC_TYPE_RC5;
> +			core->init_data.type = RC_BIT_RC5;
>  			core->init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
>  
>  			info.platform_data = &core->init_data;
> diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
> index d47f41a..46e262b 100644
> --- a/drivers/media/pci/ivtv/ivtv-i2c.c
> +++ b/drivers/media/pci/ivtv/ivtv-i2c.c
> @@ -200,21 +200,21 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
>  		init_data->ir_codes = RC_MAP_AVERMEDIA_CARDBUS;
>  		init_data->internal_get_key_func =
>  					IR_KBD_GET_KEY_AVERMEDIA_CARDBUS;
> -		init_data->type = RC_TYPE_OTHER;
> +		init_data->type = RC_BIT_OTHER;
>  		init_data->name = "AVerMedia AVerTV card";
>  		break;
>  	case IVTV_HW_I2C_IR_RX_HAUP_EXT:
>  	case IVTV_HW_I2C_IR_RX_HAUP_INT:
>  		init_data->ir_codes = RC_MAP_HAUPPAUGE;
>  		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
> -		init_data->type = RC_TYPE_RC5;
> +		init_data->type = RC_BIT_RC5;
>  		init_data->name = itv->card_name;
>  		break;
>  	case IVTV_HW_Z8F0811_IR_RX_HAUP:
>  		/* Default to grey remote */
>  		init_data->ir_codes = RC_MAP_HAUPPAUGE;
>  		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
> -		init_data->type = RC_TYPE_RC5;
> +		init_data->type = RC_BIT_RC5;
>  		init_data->name = itv->card_name;
>  		break;
>  	case IVTV_HW_I2C_IR_RX_ADAPTEC:
> @@ -222,7 +222,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
>  		init_data->name = itv->card_name;
>  		/* FIXME: The protocol and RC_MAP needs to be corrected */
>  		init_data->ir_codes = RC_MAP_EMPTY;
> -		init_data->type = RC_TYPE_UNKNOWN;
> +		init_data->type = RC_BIT_UNKNOWN;
>  		break;
>  	}
>  
> diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
> index 0f78f5e..e761262 100644
> --- a/drivers/media/pci/saa7134/saa7134-input.c
> +++ b/drivers/media/pci/saa7134/saa7134-input.c
> @@ -990,7 +990,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
>  		dev->init_data.name = "BeholdTV";
>  		dev->init_data.get_key = get_key_beholdm6xx;
>  		dev->init_data.ir_codes = RC_MAP_BEHOLD;
> -		dev->init_data.type = RC_TYPE_NEC;
> +		dev->init_data.type = RC_BIT_NEC;
>  		info.addr = 0x2d;
>  		break;
>  	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
> diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
> index 49bb356..2d6fb26 100644
> --- a/drivers/media/rc/ati_remote.c
> +++ b/drivers/media/rc/ati_remote.c
> @@ -784,7 +784,7 @@ static void ati_remote_rc_init(struct ati_remote *ati_remote)
>  
>  	rdev->priv = ati_remote;
>  	rdev->driver_type = RC_DRIVER_SCANCODE;
> -	rdev->allowed_protos = RC_TYPE_OTHER;
> +	rdev->allowed_protos = RC_BIT_OTHER;
>  	rdev->driver_name = "ati_remote";
>  
>  	rdev->open = ati_remote_rc_open;
> diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
> index 647dd95..07f7c38 100644
> --- a/drivers/media/rc/ene_ir.c
> +++ b/drivers/media/rc/ene_ir.c
> @@ -1043,7 +1043,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
>  		learning_mode_force = false;
>  
>  	rdev->driver_type = RC_DRIVER_IR_RAW;
> -	rdev->allowed_protos = RC_TYPE_ALL;
> +	rdev->allowed_protos = RC_BIT_ALL;
>  	rdev->priv = dev;
>  	rdev->open = ene_open;
>  	rdev->close = ene_close;
> diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
> index 52fd769..d2d93cb 100644
> --- a/drivers/media/rc/fintek-cir.c
> +++ b/drivers/media/rc/fintek-cir.c
> @@ -541,7 +541,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
>  	/* Set up the rc device */
>  	rdev->priv = fintek;
>  	rdev->driver_type = RC_DRIVER_IR_RAW;
> -	rdev->allowed_protos = RC_TYPE_ALL;
> +	rdev->allowed_protos = RC_BIT_ALL;
>  	rdev->open = fintek_open;
>  	rdev->close = fintek_close;
>  	rdev->input_name = FINTEK_DESCRIPTION;
> diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
> index 04cb272..ba1a1eb 100644
> --- a/drivers/media/rc/gpio-ir-recv.c
> +++ b/drivers/media/rc/gpio-ir-recv.c
> @@ -95,7 +95,7 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
>  	if (pdata->allowed_protos)
>  		rcdev->allowed_protos = pdata->allowed_protos;
>  	else
> -		rcdev->allowed_protos = RC_TYPE_ALL;
> +		rcdev->allowed_protos = RC_BIT_ALL;
>  	rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
>  
>  	gpio_dev->rcdev = rcdev;
> diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
> index 1e4c68a..aca2242 100644
> --- a/drivers/media/rc/iguanair.c
> +++ b/drivers/media/rc/iguanair.c
> @@ -503,7 +503,7 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
>  	usb_to_input_id(ir->udev, &rc->input_id);
>  	rc->dev.parent = &intf->dev;
>  	rc->driver_type = RC_DRIVER_IR_RAW;
> -	rc->allowed_protos = RC_TYPE_ALL;
> +	rc->allowed_protos = RC_BIT_ALL;
>  	rc->priv = ir;
>  	rc->open = iguanair_open;
>  	rc->close = iguanair_close;
> diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
> index 5dd0386..8f6a289 100644
> --- a/drivers/media/rc/imon.c
> +++ b/drivers/media/rc/imon.c
> @@ -1001,7 +1001,7 @@ static void imon_touch_display_timeout(unsigned long data)
>   * it is not, so we must acquire it prior to calling send_packet, which
>   * requires that the lock is held.
>   */
> -static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
> +static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
>  {
>  	int retval;
>  	struct imon_context *ictx = rc->priv;
> @@ -1010,31 +1010,27 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
>  	unsigned char ir_proto_packet[] = {
>  		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
>  
> -	if (rc_type && !(rc_type & rc->allowed_protos))
> +	if (*rc_type && !(*rc_type & rc->allowed_protos))
>  		dev_warn(dev, "Looks like you're trying to use an IR protocol "
>  			 "this device does not support\n");
>  
> -	switch (rc_type) {
> -	case RC_TYPE_RC6:
> +	if (*rc_type & RC_BIT_RC6_MCE) {
>  		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
>  		ir_proto_packet[0] = 0x01;
> -		break;
> -	case RC_TYPE_UNKNOWN:
> -	case RC_TYPE_OTHER:
> +		*rc_type = RC_BIT_RC6_MCE;
> +	} else if (*rc_type & RC_BIT_OTHER) {
>  		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
>  		if (!pad_stabilize)
>  			dev_dbg(dev, "PAD stabilize functionality disabled\n");
>  		/* ir_proto_packet[0] = 0x00; // already the default */
> -		rc_type = RC_TYPE_OTHER;
> -		break;
> -	default:
> +		*rc_type = RC_BIT_OTHER;
> +	} else {
>  		dev_warn(dev, "Unsupported IR protocol specified, overriding "
>  			 "to iMON IR protocol\n");
>  		if (!pad_stabilize)
>  			dev_dbg(dev, "PAD stabilize functionality disabled\n");
>  		/* ir_proto_packet[0] = 0x00; // already the default */
> -		rc_type = RC_TYPE_OTHER;
> -		break;
> +		*rc_type = RC_BIT_OTHER;
>  	}
>  
>  	memcpy(ictx->usb_tx_buf, &ir_proto_packet, sizeof(ir_proto_packet));
> @@ -1048,7 +1044,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
>  	if (retval)
>  		goto out;
>  
> -	ictx->rc_type = rc_type;
> +	ictx->rc_type = *rc_type;
>  	ictx->pad_mouse = false;
>  
>  out:
> @@ -1323,7 +1319,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
>  		rel_x = buf[2];
>  		rel_y = buf[3];
>  
> -		if (ictx->rc_type == RC_TYPE_OTHER && pad_stabilize) {
> +		if (ictx->rc_type == RC_BIT_OTHER && pad_stabilize) {
>  			if ((buf[1] == 0) && ((rel_x != 0) || (rel_y != 0))) {
>  				dir = stabilize((int)rel_x, (int)rel_y,
>  						timeout, threshold);
> @@ -1390,7 +1386,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
>  		buf[0] = 0x01;
>  		buf[1] = buf[4] = buf[5] = buf[6] = buf[7] = 0;
>  
> -		if (ictx->rc_type == RC_TYPE_OTHER && pad_stabilize) {
> +		if (ictx->rc_type == RC_BIT_OTHER && pad_stabilize) {
>  			dir = stabilize((int)rel_x, (int)rel_y,
>  					timeout, threshold);
>  			if (!dir) {
> @@ -1511,7 +1507,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
>  		kc = imon_panel_key_lookup(scancode);
>  	} else {
>  		scancode = be32_to_cpu(*((u32 *)buf));
> -		if (ictx->rc_type == RC_TYPE_RC6) {
> +		if (ictx->rc_type == RC_BIT_RC6_MCE) {
>  			ktype = IMON_KEY_IMON;
>  			if (buf[0] == 0x80)
>  				ktype = IMON_KEY_MCE;
> @@ -1744,7 +1740,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
>  {
>  	u8 ffdc_cfg_byte = ictx->usb_rx_buf[6];
>  	u8 detected_display_type = IMON_DISPLAY_TYPE_NONE;
> -	u64 allowed_protos = RC_TYPE_OTHER;
> +	u64 allowed_protos = RC_BIT_OTHER;
>  
>  	switch (ffdc_cfg_byte) {
>  	/* iMON Knob, no display, iMON IR + vol knob */
> @@ -1775,13 +1771,13 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
>  	case 0x9e:
>  		dev_info(ictx->dev, "0xffdc iMON VFD, MCE IR");
>  		detected_display_type = IMON_DISPLAY_TYPE_VFD;
> -		allowed_protos = RC_TYPE_RC6;
> +		allowed_protos = RC_BIT_RC6_MCE;
>  		break;
>  	/* iMON LCD, MCE IR */
>  	case 0x9f:
>  		dev_info(ictx->dev, "0xffdc iMON LCD, MCE IR");
>  		detected_display_type = IMON_DISPLAY_TYPE_LCD;
> -		allowed_protos = RC_TYPE_RC6;
> +		allowed_protos = RC_BIT_RC6_MCE;
>  		break;
>  	default:
>  		dev_info(ictx->dev, "Unknown 0xffdc device, "
> @@ -1789,7 +1785,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
>  		detected_display_type = IMON_DISPLAY_TYPE_VFD;
>  		/* We don't know which one it is, allow user to set the
>  		 * RC6 one from userspace if OTHER wasn't correct. */
> -		allowed_protos |= RC_TYPE_RC6;
> +		allowed_protos |= RC_BIT_RC6_MCE;
>  		break;
>  	}
>  
> @@ -1875,7 +1871,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
>  
>  	rdev->priv = ictx;
>  	rdev->driver_type = RC_DRIVER_SCANCODE;
> -	rdev->allowed_protos = RC_TYPE_OTHER | RC_TYPE_RC6; /* iMON PAD or MCE */
> +	rdev->allowed_protos = RC_BIT_OTHER | RC_BIT_RC6_MCE; /* iMON PAD or MCE */
>  	rdev->change_protocol = imon_ir_change_protocol;
>  	rdev->driver_name = MOD_NAME;
>  
> @@ -1893,7 +1889,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
>  
>  	imon_set_display_type(ictx);
>  
> -	if (ictx->rc_type == RC_TYPE_RC6)
> +	if (ictx->rc_type == RC_BIT_RC6_MCE)
>  		rdev->map_name = RC_MAP_IMON_MCE;
>  	else
>  		rdev->map_name = RC_MAP_IMON_PAD;
> diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
> index 035668e..69edffb 100644
> --- a/drivers/media/rc/ir-jvc-decoder.c
> +++ b/drivers/media/rc/ir-jvc-decoder.c
> @@ -47,7 +47,7 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  {
>  	struct jvc_dec *data = &dev->raw->jvc;
>  
> -	if (!(dev->raw->enabled_protocols & RC_TYPE_JVC))
> +	if (!(dev->raw->enabled_protocols & RC_BIT_JVC))
>  		return 0;
>  
>  	if (!is_timing_event(ev)) {
> @@ -174,7 +174,7 @@ out:
>  }
>  
>  static struct ir_raw_handler jvc_handler = {
> -	.protocols	= RC_TYPE_JVC,
> +	.protocols	= RC_BIT_JVC,
>  	.decode		= ir_jvc_decode,
>  };
>  
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index 569124b..498ecea 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -35,7 +35,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	struct lirc_codec *lirc = &dev->raw->lirc;
>  	int sample;
>  
> -	if (!(dev->raw->enabled_protocols & RC_TYPE_LIRC))
> +	if (!(dev->raw->enabled_protocols & RC_BIT_LIRC))
>  		return 0;
>  
>  	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
> @@ -408,7 +408,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
>  }
>  
>  static struct ir_raw_handler lirc_handler = {
> -	.protocols	= RC_TYPE_LIRC,
> +	.protocols	= RC_BIT_LIRC,
>  	.decode		= ir_lirc_decode,
>  	.raw_register	= ir_lirc_register,
>  	.raw_unregister	= ir_lirc_unregister,
> diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
> index 3784ebf..33fafa4 100644
> --- a/drivers/media/rc/ir-mce_kbd-decoder.c
> +++ b/drivers/media/rc/ir-mce_kbd-decoder.c
> @@ -216,7 +216,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	u32 scancode;
>  	unsigned long delay;
>  
> -	if (!(dev->raw->enabled_protocols & RC_TYPE_MCE_KBD))
> +	if (!(dev->raw->enabled_protocols & RC_BIT_MCE_KBD))
>  		return 0;
>  
>  	if (!is_timing_event(ev)) {
> @@ -422,7 +422,7 @@ static int ir_mce_kbd_unregister(struct rc_dev *dev)
>  }
>  
>  static struct ir_raw_handler mce_kbd_handler = {
> -	.protocols	= RC_TYPE_MCE_KBD,
> +	.protocols	= RC_BIT_MCE_KBD,
>  	.decode		= ir_mce_kbd_decode,
>  	.raw_register	= ir_mce_kbd_register,
>  	.raw_unregister	= ir_mce_kbd_unregister,
> diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
> index 2ca509e..a47ee36 100644
> --- a/drivers/media/rc/ir-nec-decoder.c
> +++ b/drivers/media/rc/ir-nec-decoder.c
> @@ -52,7 +52,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	u8 address, not_address, command, not_command;
>  	bool send_32bits = false;
>  
> -	if (!(dev->raw->enabled_protocols & RC_TYPE_NEC))
> +	if (!(dev->raw->enabled_protocols & RC_BIT_NEC))
>  		return 0;
>  
>  	if (!is_timing_event(ev)) {
> @@ -201,7 +201,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  }
>  
>  static struct ir_raw_handler nec_handler = {
> -	.protocols	= RC_TYPE_NEC,
> +	.protocols	= RC_BIT_NEC,
>  	.decode		= ir_nec_decode,
>  };
>  
> diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
> index 9ab663a..5b4d1dd 100644
> --- a/drivers/media/rc/ir-rc5-decoder.c
> +++ b/drivers/media/rc/ir-rc5-decoder.c
> @@ -52,8 +52,8 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	u8 toggle;
>  	u32 scancode;
>  
> -        if (!(dev->raw->enabled_protocols & RC_TYPE_RC5))
> -                return 0;
> +	if (!(dev->raw->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
> +		return 0;
>  
>  	if (!is_timing_event(ev)) {
>  		if (ev.reset)
> @@ -128,6 +128,10 @@ again:
>  		if (data->wanted_bits == RC5X_NBITS) {
>  			/* RC5X */
>  			u8 xdata, command, system;
> +			if (!(dev->raw->enabled_protocols & RC_BIT_RC5X)) {
> +				data->state = STATE_INACTIVE;
> +				return 0;
> +			}
>  			xdata    = (data->bits & 0x0003F) >> 0;
>  			command  = (data->bits & 0x00FC0) >> 6;
>  			system   = (data->bits & 0x1F000) >> 12;
> @@ -141,6 +145,10 @@ again:
>  		} else {
>  			/* RC5 */
>  			u8 command, system;
> +			if (!(dev->raw->enabled_protocols & RC_BIT_RC5)) {
> +				data->state = STATE_INACTIVE;
> +				return 0;
> +			}
>  			command  = (data->bits & 0x0003F) >> 0;
>  			system   = (data->bits & 0x007C0) >> 6;
>  			toggle   = (data->bits & 0x00800) ? 1 : 0;
> @@ -164,7 +172,7 @@ out:
>  }
>  
>  static struct ir_raw_handler rc5_handler = {
> -	.protocols	= RC_TYPE_RC5,
> +	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X,
>  	.decode		= ir_rc5_decode,
>  };
>  
> diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
> index ec8d4a2..fd807a8 100644
> --- a/drivers/media/rc/ir-rc5-sz-decoder.c
> +++ b/drivers/media/rc/ir-rc5-sz-decoder.c
> @@ -48,8 +48,8 @@ static int ir_rc5_sz_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	u8 toggle, command, system;
>  	u32 scancode;
>  
> -        if (!(dev->raw->enabled_protocols & RC_TYPE_RC5_SZ))
> -                return 0;
> +	if (!(dev->raw->enabled_protocols & RC_BIT_RC5_SZ))
> +		return 0;
>  
>  	if (!is_timing_event(ev)) {
>  		if (ev.reset)
> @@ -128,7 +128,7 @@ out:
>  }
>  
>  static struct ir_raw_handler rc5_sz_handler = {
> -	.protocols	= RC_TYPE_RC5_SZ,
> +	.protocols	= RC_BIT_RC5_SZ,
>  	.decode		= ir_rc5_sz_decode,
>  };
>  
> diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
> index 4cfdd7f..e19072f 100644
> --- a/drivers/media/rc/ir-rc6-decoder.c
> +++ b/drivers/media/rc/ir-rc6-decoder.c
> @@ -89,7 +89,9 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	u32 scancode;
>  	u8 toggle;
>  
> -	if (!(dev->raw->enabled_protocols & RC_TYPE_RC6))
> +	if (!(dev->raw->enabled_protocols &
> +	      (RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
> +	       RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)))
>  		return 0;
>  
>  	if (!is_timing_event(ev)) {
> @@ -271,7 +273,9 @@ out:
>  }
>  
>  static struct ir_raw_handler rc6_handler = {
> -	.protocols	= RC_TYPE_RC6,
> +	.protocols	= RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 |
> +			  RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 |
> +			  RC_BIT_RC6_MCE,
>  	.decode		= ir_rc6_decode,
>  };
>  
> diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
> index 7e54ec5..7e69a3b 100644
> --- a/drivers/media/rc/ir-sanyo-decoder.c
> +++ b/drivers/media/rc/ir-sanyo-decoder.c
> @@ -58,7 +58,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	u32 scancode;
>  	u8 address, command, not_command;
>  
> -	if (!(dev->raw->enabled_protocols & RC_TYPE_SANYO))
> +	if (!(dev->raw->enabled_protocols & RC_BIT_SANYO))
>  		return 0;
>  
>  	if (!is_timing_event(ev)) {
> @@ -179,7 +179,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  }
>  
>  static struct ir_raw_handler sanyo_handler = {
> -	.protocols	= RC_TYPE_SANYO,
> +	.protocols	= RC_BIT_SANYO,
>  	.decode		= ir_sanyo_decode,
>  };
>  
> diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
> index dab98b3..fb91434 100644
> --- a/drivers/media/rc/ir-sony-decoder.c
> +++ b/drivers/media/rc/ir-sony-decoder.c
> @@ -45,7 +45,8 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	u32 scancode;
>  	u8 device, subdevice, function;
>  
> -	if (!(dev->raw->enabled_protocols & RC_TYPE_SONY))
> +	if (!(dev->raw->enabled_protocols &
> +	      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
>  		return 0;
>  
>  	if (!is_timing_event(ev)) {
> @@ -123,16 +124,28 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  
>  		switch (data->count) {
>  		case 12:
> +			if (!(dev->raw->enabled_protocols & RC_BIT_SONY12)) {
> +				data->state = STATE_INACTIVE;
> +				return 0;
> +			}
>  			device    = bitrev8((data->bits <<  3) & 0xF8);
>  			subdevice = 0;
>  			function  = bitrev8((data->bits >>  4) & 0xFE);
>  			break;
>  		case 15:
> +			if (!(dev->raw->enabled_protocols & RC_BIT_SONY15)) {
> +				data->state = STATE_INACTIVE;
> +				return 0;
> +			}
>  			device    = bitrev8((data->bits >>  0) & 0xFF);
>  			subdevice = 0;
>  			function  = bitrev8((data->bits >>  7) & 0xFE);
>  			break;
>  		case 20:
> +			if (!(dev->raw->enabled_protocols & RC_BIT_SONY20)) {
> +				data->state = STATE_INACTIVE;
> +				return 0;
> +			}
>  			device    = bitrev8((data->bits >>  5) & 0xF8);
>  			subdevice = bitrev8((data->bits >>  0) & 0xFF);
>  			function  = bitrev8((data->bits >> 12) & 0xFE);
> @@ -157,7 +170,7 @@ out:
>  }
>  
>  static struct ir_raw_handler sony_handler = {
> -	.protocols	= RC_TYPE_SONY,
> +	.protocols	= RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20,
>  	.decode		= ir_sony_decode,
>  };
>  
> diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
> index 24c77a4..d635115 100644
> --- a/drivers/media/rc/ite-cir.c
> +++ b/drivers/media/rc/ite-cir.c
> @@ -1563,7 +1563,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
>  	/* set up ir-core props */
>  	rdev->priv = itdev;
>  	rdev->driver_type = RC_DRIVER_IR_RAW;
> -	rdev->allowed_protos = RC_TYPE_ALL;
> +	rdev->allowed_protos = RC_BIT_ALL;
>  	rdev->open = ite_open;
>  	rdev->close = ite_close;
>  	rdev->s_idle = ite_s_idle;
> diff --git a/drivers/media/rc/keymaps/rc-imon-mce.c b/drivers/media/rc/keymaps/rc-imon-mce.c
> index 124c722..f0da960 100644
> --- a/drivers/media/rc/keymaps/rc-imon-mce.c
> +++ b/drivers/media/rc/keymaps/rc-imon-mce.c
> @@ -121,7 +121,7 @@ static struct rc_map_list imon_mce_map = {
>  		.scan    = imon_mce,
>  		.size    = ARRAY_SIZE(imon_mce),
>  		/* its RC6, but w/a hardware decoder */
> -		.rc_type = RC_TYPE_RC6,
> +		.rc_type = RC_TYPE_RC6_MCE,
>  		.name    = RC_MAP_IMON_MCE,
>  	}
>  };
> diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
> index 753e43e..ef4006f 100644
> --- a/drivers/media/rc/keymaps/rc-rc6-mce.c
> +++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
> @@ -97,7 +97,7 @@ static struct rc_map_list rc6_mce_map = {
>  	.map = {
>  		.scan    = rc6_mce,
>  		.size    = ARRAY_SIZE(rc6_mce),
> -		.rc_type = RC_TYPE_RC6,
> +		.rc_type = RC_TYPE_RC6_MCE,
>  		.name    = RC_MAP_RC6_MCE,
>  	}
>  };
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 850547f..b2146cd 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -1205,7 +1205,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
>  	rc->dev.parent = dev;
>  	rc->priv = ir;
>  	rc->driver_type = RC_DRIVER_IR_RAW;
> -	rc->allowed_protos = RC_TYPE_ALL;
> +	rc->allowed_protos = RC_BIT_ALL;
>  	rc->timeout = MS_TO_NS(100);
>  	if (!ir->flags.no_tx) {
>  		rc->s_tx_mask = mceusb_set_tx_mask;
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index 699eef3..8e8a19c 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -1042,7 +1042,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
>  	/* Set up the rc device */
>  	rdev->priv = nvt;
>  	rdev->driver_type = RC_DRIVER_IR_RAW;
> -	rdev->allowed_protos = RC_TYPE_ALL;
> +	rdev->allowed_protos = RC_BIT_ALL;
>  	rdev->open = nvt_open;
>  	rdev->close = nvt_close;
>  	rdev->tx_ir = nvt_tx_ir;
> diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
> index f9be681..53d0282 100644
> --- a/drivers/media/rc/rc-loopback.c
> +++ b/drivers/media/rc/rc-loopback.c
> @@ -195,7 +195,7 @@ static int __init loop_init(void)
>  	rc->map_name		= RC_MAP_EMPTY;
>  	rc->priv		= &loopdev;
>  	rc->driver_type		= RC_DRIVER_IR_RAW;
> -	rc->allowed_protos	= RC_TYPE_ALL;
> +	rc->allowed_protos	= RC_BIT_ALL;
>  	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
>  	rc->min_timeout		= 1;
>  	rc->max_timeout		= UINT_MAX;
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index cabc19c..601d1ac1 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -725,25 +725,36 @@ static struct class ir_input_class = {
>  	.devnode	= ir_devnode,
>  };
>  
> +/*
> + * These are the protocol textual descriptions that are
> + * used by the sysfs protocols file. Note that the order
> + * of the entries is relevant.
> + */
>  static struct {
>  	u64	type;
>  	char	*name;
>  } proto_names[] = {
> -	{ RC_TYPE_UNKNOWN,	"unknown"	},
> -	{ RC_TYPE_RC5,		"rc-5"		},
> -	{ RC_TYPE_NEC,		"nec"		},
> -	{ RC_TYPE_RC6,		"rc-6"		},
> -	{ RC_TYPE_JVC,		"jvc"		},
> -	{ RC_TYPE_SONY,		"sony"		},
> -	{ RC_TYPE_RC5_SZ,	"rc-5-sz"	},
> -	{ RC_TYPE_SANYO,	"sanyo"		},
> -	{ RC_TYPE_MCE_KBD,	"mce_kbd"	},
> -	{ RC_TYPE_LIRC,		"lirc"		},
> -	{ RC_TYPE_OTHER,	"other"		},
> +	{ RC_BIT_NONE,		"none"		},
> +	{ RC_BIT_OTHER,		"other"		},
> +	{ RC_BIT_UNKNOWN,	"unknown"	},
> +	{ RC_BIT_RC5 |
> +	  RC_BIT_RC5X,		"rc-5"		},
> +	{ RC_BIT_NEC,		"nec"		},
> +	{ RC_BIT_RC6_0 |
> +	  RC_BIT_RC6_6A_20 |
> +	  RC_BIT_RC6_6A_24 |
> +	  RC_BIT_RC6_6A_32 |
> +	  RC_BIT_RC6_MCE,	"rc-6"		},
> +	{ RC_BIT_JVC,		"jvc"		},
> +	{ RC_BIT_SONY12 |
> +	  RC_BIT_SONY15 |
> +	  RC_BIT_SONY20,	"sony"		},
> +	{ RC_BIT_RC5_SZ,	"rc-5-sz"	},
> +	{ RC_BIT_SANYO,		"sanyo"		},
> +	{ RC_BIT_MCE_KBD,	"mce_kbd"	},
> +	{ RC_BIT_LIRC,		"lirc"		},
>  };
>  
> -#define PROTO_NONE	"none"
> -
>  /**
>   * show_protocols() - shows the current IR protocol(s)
>   * @device:	the device descriptor
> @@ -790,6 +801,9 @@ static ssize_t show_protocols(struct device *device,
>  			tmp += sprintf(tmp, "[%s] ", proto_names[i].name);
>  		else if (allowed & proto_names[i].type)
>  			tmp += sprintf(tmp, "%s ", proto_names[i].name);
> +
> +		if (allowed & proto_names[i].type)
> +			allowed &= ~proto_names[i].type;
>  	}
>  
>  	if (tmp != buf)
> @@ -867,26 +881,20 @@ static ssize_t store_protocols(struct device *device,
>  			disable = false;
>  		}
>  
> -		if (!enable && !disable && !strncasecmp(tmp, PROTO_NONE, sizeof(PROTO_NONE))) {
> -			tmp += sizeof(PROTO_NONE);
> -			mask = 0;
> -			count++;
> -		} else {
> -			for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
> -				if (!strcasecmp(tmp, proto_names[i].name)) {
> -					tmp += strlen(proto_names[i].name);
> -					mask = proto_names[i].type;
> -					break;
> -				}
> -			}
> -			if (i == ARRAY_SIZE(proto_names)) {
> -				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
> -				ret = -EINVAL;
> -				goto out;
> +		for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
> +			if (!strcasecmp(tmp, proto_names[i].name)) {
> +				mask = proto_names[i].type;
> +				break;
>  			}
> -			count++;
>  		}
>  
> +		if (i == ARRAY_SIZE(proto_names)) {
> +			IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
> +			return -EINVAL;
> +		}
> +
> +		count++;
> +
>  		if (enable)
>  			type |= mask;
>  		else if (disable)
> @@ -902,7 +910,7 @@ static ssize_t store_protocols(struct device *device,
>  	}
>  
>  	if (dev->change_protocol) {
> -		rc = dev->change_protocol(dev, type);
> +		rc = dev->change_protocol(dev, &type);
>  		if (rc < 0) {
>  			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
>  				   (long long)type);
> @@ -1117,7 +1125,8 @@ int rc_register_device(struct rc_dev *dev)
>  	}
>  
>  	if (dev->change_protocol) {
> -		rc = dev->change_protocol(dev, rc_map->rc_type);
> +		u64 rc_type = (1 << rc_map->rc_type);
> +		rc = dev->change_protocol(dev, &rc_type);
>  		if (rc < 0)
>  			goto out_raw;
>  	}
> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
> index 49731b1..97dc0f7 100644
> --- a/drivers/media/rc/redrat3.c
> +++ b/drivers/media/rc/redrat3.c
> @@ -1079,7 +1079,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
>  	rc->dev.parent = dev;
>  	rc->priv = rr3;
>  	rc->driver_type = RC_DRIVER_IR_RAW;
> -	rc->allowed_protos = RC_TYPE_ALL;
> +	rc->allowed_protos = RC_BIT_ALL;
>  	rc->timeout = US_TO_NS(2750);
>  	rc->tx_ir = redrat3_transmit_ir;
>  	rc->s_tx_carrier = redrat3_set_tx_carrier;
> diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
> index d6f4bfe..c720f12 100644
> --- a/drivers/media/rc/streamzap.c
> +++ b/drivers/media/rc/streamzap.c
> @@ -322,7 +322,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
>  	rdev->dev.parent = dev;
>  	rdev->priv = sz;
>  	rdev->driver_type = RC_DRIVER_IR_RAW;
> -	rdev->allowed_protos = RC_TYPE_ALL;
> +	rdev->allowed_protos = RC_BIT_ALL;
>  	rdev->driver_name = DRIVER_NAME;
>  	rdev->map_name = RC_MAP_STREAMZAP;
>  
> diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
> index fef0523..f0921b5 100644
> --- a/drivers/media/rc/ttusbir.c
> +++ b/drivers/media/rc/ttusbir.c
> @@ -316,7 +316,7 @@ static int __devinit ttusbir_probe(struct usb_interface *intf,
>  	usb_to_input_id(tt->udev, &rc->input_id);
>  	rc->dev.parent = &intf->dev;
>  	rc->driver_type = RC_DRIVER_IR_RAW;
> -	rc->allowed_protos = RC_TYPE_ALL;
> +	rc->allowed_protos = RC_BIT_ALL;
>  	rc->priv = tt;
>  	rc->driver_name = DRIVER_NAME;
>  	rc->map_name = RC_MAP_TT_1500;
> diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
> index 30ae1f2..b1cb3a9 100644
> --- a/drivers/media/rc/winbond-cir.c
> +++ b/drivers/media/rc/winbond-cir.c
> @@ -1022,7 +1022,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
>  	data->dev->priv = data;
>  	data->dev->dev.parent = &device->dev;
>  	data->dev->timeout = MS_TO_NS(100);
> -	data->dev->allowed_protos = RC_TYPE_ALL;
> +	data->dev->allowed_protos = RC_BIT_ALL;
>  
>  	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
>  		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
> diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
> index 96176e9..0f7b424 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-input.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-input.c
> @@ -99,7 +99,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
>  	/* The i2c micro-controller only outputs the cmd part of NEC protocol */
>  	dev->init_data.rc_dev->scanmask = 0xff;
>  	dev->init_data.rc_dev->driver_name = "cx231xx";
> -	dev->init_data.type = RC_TYPE_NEC;
> +	dev->init_data.type = RC_BIT_NEC;
>  	info.addr = 0x30;
>  
>  	/* Load and bind ir-kbd-i2c */
> diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
> index 824f191..b646106 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9015.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9015.c
> @@ -1306,7 +1306,7 @@ static int af9015_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
>  	if (!rc->map_name)
>  		rc->map_name = RC_MAP_EMPTY;
>  
> -	rc->allowed_protos = RC_TYPE_NEC;
> +	rc->allowed_protos = RC_BIT_NEC;
>  	rc->query = af9015_rc_query;
>  	rc->interval = 500;
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index aabd3fc..b43c1cd 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -1023,10 +1023,10 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
>  		switch (tmp) {
>  		case 0: /* NEC */
>  		default:
> -			rc->allowed_protos = RC_TYPE_NEC;
> +			rc->allowed_protos = RC_BIT_NEC;
>  			break;
>  		case 1: /* RC6 */
> -			rc->allowed_protos = RC_TYPE_RC6;
> +			rc->allowed_protos = RC_BIT_RC6_MCE;
>  			break;
>  		}
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
> index ec540140..e78ca8f 100644
> --- a/drivers/media/usb/dvb-usb-v2/anysee.c
> +++ b/drivers/media/usb/dvb-usb-v2/anysee.c
> @@ -1048,7 +1048,7 @@ static int anysee_rc_query(struct dvb_usb_device *d)
>  
>  static int anysee_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
>  {
> -	rc->allowed_protos = RC_TYPE_NEC;
> +	rc->allowed_protos = RC_BIT_NEC;
>  	rc->query          = anysee_rc_query;
>  	rc->interval       = 250;  /* windows driver uses 500ms */
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
> index 54f1221..d75dbf2 100644
> --- a/drivers/media/usb/dvb-usb-v2/az6007.c
> +++ b/drivers/media/usb/dvb-usb-v2/az6007.c
> @@ -826,7 +826,7 @@ static int az6007_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
>  {
>  	pr_debug("Getting az6007 Remote Control properties\n");
>  
> -	rc->allowed_protos = RC_TYPE_NEC;
> +	rc->allowed_protos = RC_BIT_NEC;
>  	rc->query          = az6007_rc_query;
>  	rc->interval       = 400;
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> index bae16a1..059291b 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> @@ -137,7 +137,7 @@ struct dvb_usb_driver_info {
>  struct dvb_usb_rc {
>  	const char *map_name;
>  	u64 allowed_protos;
> -	int (*change_protocol)(struct rc_dev *dev, u64 rc_type);
> +	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int (*query) (struct dvb_usb_device *d);
>  	unsigned int interval;
>  	const enum rc_driver_type driver_type;
> diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
> index 695f910..0b1ddc2 100644
> --- a/drivers/media/usb/dvb-usb-v2/it913x.c
> +++ b/drivers/media/usb/dvb-usb-v2/it913x.c
> @@ -698,7 +698,7 @@ static int it913x_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
>  		return 0;
>  	}
>  
> -	rc->allowed_protos = RC_TYPE_NEC;
> +	rc->allowed_protos = RC_BIT_NEC;
>  	rc->query = it913x_rc_query;
>  	rc->interval = 250;
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> index c41d9d9..6a2445b 100644
> --- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
> +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> @@ -1253,7 +1253,7 @@ static int lme2510_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
>  static int lme2510_get_rc_config(struct dvb_usb_device *d,
>  	struct dvb_usb_rc *rc)
>  {
> -	rc->allowed_protos = RC_TYPE_NEC;
> +	rc->allowed_protos = RC_BIT_NEC;
>  	return 0;
>  }
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index f62cfba..2aea2d3 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1197,7 +1197,7 @@ static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
>  		struct dvb_usb_rc *rc)
>  {
>  	rc->map_name = RC_MAP_EMPTY;
> -	rc->allowed_protos = RC_TYPE_NEC;
> +	rc->allowed_protos = RC_BIT_NEC;
>  	rc->query = rtl2831u_rc_query;
>  	rc->interval = 400;
>  
> @@ -1269,7 +1269,7 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
>  		struct dvb_usb_rc *rc)
>  {
>  	rc->map_name = RC_MAP_EMPTY;
> -	rc->allowed_protos = RC_TYPE_NEC;
> +	rc->allowed_protos = RC_BIT_NEC;
>  	rc->query = rtl2832u_rc_query;
>  	rc->interval = 400;
>  
> diff --git a/drivers/media/usb/dvb-usb/dib0700.h b/drivers/media/usb/dvb-usb/dib0700.h
> index 7de125c..637b612 100644
> --- a/drivers/media/usb/dvb-usb/dib0700.h
> +++ b/drivers/media/usb/dvb-usb/dib0700.h
> @@ -64,7 +64,7 @@ extern int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff);
>  extern struct i2c_algorithm dib0700_i2c_algo;
>  extern int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
>  			struct dvb_usb_device_description **desc, int *cold);
> -extern int dib0700_change_protocol(struct rc_dev *dev, u64 rc_type);
> +extern int dib0700_change_protocol(struct rc_dev *dev, u64 *rc_type);
>  extern int dib0700_set_i2c_speed(struct dvb_usb_device *d, u16 scl_kHz);
>  
>  extern int dib0700_device_count;
> diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
> index ef87229..19b5ed2 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_core.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_core.c
> @@ -605,7 +605,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>  	return ret;
>  }
>  
> -int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
> +int dib0700_change_protocol(struct rc_dev *rc, u64 *rc_type)
>  {
>  	struct dvb_usb_device *d = rc->priv;
>  	struct dib0700_state *st = d->priv;
> @@ -621,17 +621,19 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
>  	st->buf[2] = 0;
>  
>  	/* Set the IR mode */
> -	if (rc_type == RC_TYPE_RC5)
> +	if (*rc_type & RC_BIT_RC5) {
>  		new_proto = 1;
> -	else if (rc_type == RC_TYPE_NEC)
> +		*rc_type = RC_BIT_RC5;
> +	} else if (*rc_type & RC_BIT_NEC) {
>  		new_proto = 0;
> -	else if (rc_type == RC_TYPE_RC6) {
> +		*rc_type = RC_BIT_NEC;
> +	} else if (*rc_type & RC_BIT_RC6_MCE) {
>  		if (st->fw_version < 0x10200) {
>  			ret = -EINVAL;
>  			goto out;
>  		}
> -
>  		new_proto = 2;
> +		*rc_type = RC_BIT_RC6_MCE;
>  	} else {
>  		ret = -EINVAL;
>  		goto out;
> @@ -645,7 +647,7 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
>  		goto out;
>  	}
>  
> -	d->props.rc.core.protocol = rc_type;
> +	d->props.rc.core.protocol = *rc_type;
>  
>  out:
>  	mutex_unlock(&d->usb_mutex);
> @@ -707,7 +709,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
>  		 purb->actual_length);
>  
>  	switch (d->props.rc.core.protocol) {
> -	case RC_TYPE_NEC:
> +	case RC_BIT_NEC:
>  		toggle = 0;
>  
>  		/* NEC protocol sends repeat code as 0 0 0 FF */
> diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
> index 510001d..1179842 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
> @@ -518,7 +518,7 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
>  
>  	d->last_event = 0;
>  	switch (d->props.rc.core.protocol) {
> -	case RC_TYPE_NEC:
> +	case RC_BIT_NEC:
>  		/* NEC protocol sends repeat code as 0 0 0 FF */
>  		if ((key[3-2] == 0x00) && (key[3-3] == 0x00) &&
>  		    (key[3] == 0xff))
> @@ -3658,9 +3658,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -3698,9 +3698,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -3763,9 +3763,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_interval      = DEFAULT_RC_INTERVAL,
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -3808,9 +3808,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -3890,9 +3890,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -3936,9 +3936,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -3987,9 +3987,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4055,9 +4055,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4106,9 +4106,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4177,9 +4177,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4215,9 +4215,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4295,9 +4295,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4341,9 +4341,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4394,9 +4394,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4433,9 +4433,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4472,9 +4472,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4511,9 +4511,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4550,9 +4550,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4589,9 +4589,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4644,9 +4644,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4681,9 +4681,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4721,9 +4721,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4761,9 +4761,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> @@ -4802,9 +4802,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
>  			.module_name	  = "dib0700",
>  			.rc_query         = dib0700_rc_query_old_firmware,
> -			.allowed_protos   = RC_TYPE_RC5 |
> -					    RC_TYPE_RC6 |
> -					    RC_TYPE_NEC,
> +			.allowed_protos   = RC_BIT_RC5 |
> +					    RC_BIT_RC6_MCE |
> +					    RC_BIT_NEC,
>  			.change_protocol  = dib0700_change_protocol,
>  		},
>  	},
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
> index aab0f99..ce4c4e3 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/usb/dvb-usb/dvb-usb.h
> @@ -202,7 +202,7 @@ struct dvb_rc {
>  	u64 protocol;
>  	u64 allowed_protos;
>  	enum rc_driver_type driver_type;
> -	int (*change_protocol)(struct rc_dev *dev, u64 rc_type);
> +	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	char *module_name;
>  	int (*rc_query) (struct dvb_usb_device *d);
>  	int rc_interval;
> diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
> index 02e8785..d1ddfa1 100644
> --- a/drivers/media/usb/dvb-usb/pctv452e.c
> +++ b/drivers/media/usb/dvb-usb/pctv452e.c
> @@ -927,7 +927,7 @@ static struct dvb_usb_device_properties pctv452e_properties = {
>  
>  	.rc.core = {
>  		.rc_codes	= RC_MAP_DIB0700_RC5_TABLE,
> -		.allowed_protos	= RC_TYPE_UNKNOWN,
> +		.allowed_protos	= RC_BIT_UNKNOWN,
>  		.rc_query	= pctv452e_rc_query,
>  		.rc_interval	= 100,
>  	},
> @@ -980,7 +980,7 @@ static struct dvb_usb_device_properties tt_connect_s2_3600_properties = {
>  
>  	.rc.core = {
>  		.rc_codes	= RC_MAP_TT_1500,
> -		.allowed_protos	= RC_TYPE_UNKNOWN,
> +		.allowed_protos	= RC_BIT_UNKNOWN,
>  		.rc_query	= pctv452e_rc_query,
>  		.rc_interval	= 100,
>  	},
> diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
> index acefaa8..3b8752a 100644
> --- a/drivers/media/usb/dvb-usb/technisat-usb2.c
> +++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
> @@ -731,7 +731,7 @@ static struct dvb_usb_device_properties technisat_usb2_devices = {
>  		.rc_codes    = RC_MAP_TECHNISAT_USB2,
>  		.module_name = "technisat-usb2",
>  		.rc_query    = technisat_usb2_rc_query,
> -		.allowed_protos = RC_TYPE_ALL,
> +		.allowed_protos = RC_BIT_ALL,
>  		.driver_type    = RC_DRIVER_IR_RAW,
>  	}
>  };
> diff --git a/drivers/media/usb/dvb-usb/ttusb2.c b/drivers/media/usb/dvb-usb/ttusb2.c
> index 6a50cde..bcdac22 100644
> --- a/drivers/media/usb/dvb-usb/ttusb2.c
> +++ b/drivers/media/usb/dvb-usb/ttusb2.c
> @@ -741,7 +741,7 @@ static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
>  		.rc_interval      = 150, /* Less than IR_KEYPRESS_TIMEOUT */
>  		.rc_codes         = RC_MAP_TT_1500,
>  		.rc_query         = tt3650_rc_query,
> -		.allowed_protos   = RC_TYPE_UNKNOWN,
> +		.allowed_protos   = RC_BIT_UNKNOWN,
>  	},
>  
>  	.num_adapters = 1,
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 97d36b4..660bf80 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -345,7 +345,7 @@ static void em28xx_ir_stop(struct rc_dev *rc)
>  	cancel_delayed_work_sync(&ir->work);
>  }
>  
> -static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
> +static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
>  {
>  	int rc = 0;
>  	struct em28xx_IR *ir = rc_dev->priv;
> @@ -354,14 +354,16 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
>  
>  	/* Adjust xclk based o IR table for RC5/NEC tables */
>  
> -	if (rc_type == RC_TYPE_RC5) {
> +	if (*rc_type & RC_BIT_RC5) {
>  		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
>  		ir->full_code = 1;
> -	} else if (rc_type == RC_TYPE_NEC) {
> +		*rc_type = RC_BIT_RC5;
> +	} else if (*rc_type & RC_BIT_NEC) {
>  		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
>  		ir_config = EM2874_IR_NEC;
>  		ir->full_code = 1;
> -	} else if (rc_type != RC_TYPE_UNKNOWN)
> +		*rc_type = RC_BIT_NEC;
> +	} else if (*rc_type != RC_BIT_UNKNOWN)
>  		rc = -EINVAL;
>  
>  	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
> @@ -524,6 +526,7 @@ static int em28xx_ir_init(struct em28xx *dev)
>  	struct em28xx_IR *ir;
>  	struct rc_dev *rc;
>  	int err = -ENOMEM;
> +	u64 rc_type;
>  
>  	if (dev->board.ir_codes == NULL) {
>  		/* No remote control support */
> @@ -546,14 +549,15 @@ static int em28xx_ir_init(struct em28xx *dev)
>  	 * em2874 supports more protocols. For now, let's just announce
>  	 * the two protocols that were already tested
>  	 */
> -	rc->allowed_protos = RC_TYPE_RC5 | RC_TYPE_NEC;
> +	rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
>  	rc->priv = ir;
>  	rc->change_protocol = em28xx_ir_change_protocol;
>  	rc->open = em28xx_ir_start;
>  	rc->close = em28xx_ir_stop;
>  
>  	/* By default, keep protocol field untouched */
> -	err = em28xx_ir_change_protocol(rc, RC_TYPE_UNKNOWN);
> +	rc_type = RC_BIT_UNKNOWN;
> +	err = em28xx_ir_change_protocol(rc, &rc_type);
>  	if (err)
>  		goto err_out_free;
>  
> diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
> index 82e819f..031cf02 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
> @@ -55,7 +55,7 @@ struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
>  	/* Our default information for ir-kbd-i2c.c to use */
>  	init_data->ir_codes = RC_MAP_HAUPPAUGE;
>  	init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
> -	init_data->type = RC_TYPE_RC5;
> +	init_data->type = RC_BIT_RC5;
>  	init_data->name = "HD-PVR";
>  	init_data->polling_interval = 405; /* ms, duplicated from Windows */
>  	hdpvr_ir_rx_i2c_board_info.platform_data = init_data;
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
> index 885ce11..9ab596c 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
> @@ -581,7 +581,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
>  	case PVR2_IR_SCHEME_29XXX: /* Original 29xxx device */
>  		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
>  		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
> -		init_data->type                  = RC_TYPE_RC5;
> +		init_data->type                  = RC_BIT_RC5;
>  		init_data->name                  = hdw->hdw_desc->description;
>  		init_data->polling_interval      = 100; /* ms From ir-kbd-i2c */
>  		/* IR Receiver */
> @@ -596,7 +596,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
>  	case PVR2_IR_SCHEME_24XXX_MCE: /* 24xxx MCE device */
>  		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
>  		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
> -		init_data->type                  = RC_TYPE_RC5;
> +		init_data->type                  = RC_BIT_RC5;
>  		init_data->name                  = hdw->hdw_desc->description;
>  		/* IR Receiver */
>  		info.addr          = 0x71;
> diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
> index dffbd4b..8a6bbf1 100644
> --- a/drivers/media/usb/tm6000/tm6000-input.c
> +++ b/drivers/media/usb/tm6000/tm6000-input.c
> @@ -109,12 +109,12 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
>  	 */
>  
>  	switch (ir->rc_type) {
> -	case RC_TYPE_NEC:
> +	case RC_BIT_NEC:
>  		leader = 900;	/* ms */
>  		pulse  = 700;	/* ms - the actual value would be 562 */
>  		break;
>  	default:
> -	case RC_TYPE_RC5:
> +	case RC_BIT_RC5:
>  		leader = 900;	/* ms - from the NEC decoding */
>  		pulse  = 1780;	/* ms - The actual value would be 1776 */
>  		break;
> @@ -122,12 +122,12 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
>  
>  	pulse = ir_clock_mhz * pulse;
>  	leader = ir_clock_mhz * leader;
> -	if (ir->rc_type == RC_TYPE_NEC)
> +	if (ir->rc_type == RC_BIT_NEC)
>  		leader = leader | 0x8000;
>  
>  	dprintk(2, "%s: %s, %d MHz, leader = 0x%04x, pulse = 0x%06x \n",
>  		__func__,
> -		(ir->rc_type == RC_TYPE_NEC) ? "NEC" : "RC-5",
> +		(ir->rc_type == RC_BIT_NEC) ? "NEC" : "RC-5",
>  		ir_clock_mhz, leader, pulse);
>  
>  	/* Remote WAKEUP = enable, normal mode, from IR decoder output */
> @@ -297,7 +297,7 @@ static void tm6000_ir_stop(struct rc_dev *rc)
>  	cancel_delayed_work_sync(&ir->work);
>  }
>  
> -static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
> +static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
>  {
>  	struct tm6000_IR *ir = rc->priv;
>  
> @@ -306,10 +306,10 @@ static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
>  
>  	dprintk(2, "%s\n",__func__);
>  
> -	if ((rc->rc_map.scan) && (rc_type == RC_TYPE_NEC))
> +	if ((rc->rc_map.scan) && (*rc_type == RC_BIT_NEC))
>  		ir->key_addr = ((rc->rc_map.scan[0].scancode >> 8) & 0xffff);
>  
> -	ir->rc_type = rc_type;
> +	ir->rc_type = *rc_type;
>  
>  	tm6000_ir_config(ir);
>  	/* TODO */
> @@ -398,6 +398,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
>  	struct tm6000_IR *ir;
>  	struct rc_dev *rc;
>  	int err = -ENOMEM;
> +	u64 rc_type;
>  
>  	if (!enable_ir)
>  		return -ENODEV;
> @@ -421,7 +422,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
>  	ir->rc = rc;
>  
>  	/* input setup */
> -	rc->allowed_protos = RC_TYPE_RC5 | RC_TYPE_NEC;
> +	rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
>  	/* Neded, in order to support NEC remotes with 24 or 32 bits */
>  	rc->scanmask = 0xffff;
>  	rc->priv = ir;
> @@ -444,7 +445,8 @@ int tm6000_ir_init(struct tm6000_core *dev)
>  	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
>  	strlcat(ir->phys, "/input0", sizeof(ir->phys));
>  
> -	tm6000_ir_change_protocol(rc, RC_TYPE_UNKNOWN);
> +	rc_type = RC_BIT_UNKNOWN;
> +	tm6000_ir_change_protocol(rc, &rc_type);
>  
>  	rc->input_name = ir->name;
>  	rc->input_phys = ir->phys;
> diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
> index 768aa77..e221bc7 100644
> --- a/include/media/ir-kbd-i2c.h
> +++ b/include/media/ir-kbd-i2c.h
> @@ -37,7 +37,7 @@ enum ir_kbd_get_key_fn {
>  struct IR_i2c_init_data {
>  	char			*ir_codes;
>  	const char		*name;
> -	u64			type; /* RC_TYPE_RC5, etc */
> +	u64			type; /* RC_BIT_RC5, etc */
>  	u32			polling_interval; /* 0 means DEFAULT_POLLING_INTERVAL */
>  
>  	/*
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index b0c494a..f03445f 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -50,7 +50,7 @@ enum rc_driver_type {
>   * @input_dev: the input child device used to communicate events to userspace
>   * @driver_type: specifies if protocol decoding is done in hardware or software
>   * @idle: used to keep track of RX state
> - * @allowed_protos: bitmask with the supported RC_TYPE_* protocols
> + * @allowed_protos: bitmask with the supported RC_BIT_* protocols
>   * @scanmask: some hardware decoders are not capable of providing the full
>   *	scancode to the application. As this is a hardware limit, we can't do
>   *	anything with it. Yet, as the same keycode table can be used with other
> @@ -113,7 +113,7 @@ struct rc_dev {
>  	u32				max_timeout;
>  	u32				rx_resolution;
>  	u32				tx_resolution;
> -	int				(*change_protocol)(struct rc_dev *dev, u64 rc_type);
> +	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int				(*open)(struct rc_dev *dev);
>  	void				(*close)(struct rc_dev *dev);
>  	int				(*s_tx_mask)(struct rc_dev *dev, u32 mask);
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index cfd5163..74f55a3 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -11,22 +11,54 @@
>  
>  #include <linux/input.h>
>  
> -#define RC_TYPE_UNKNOWN	0
> -#define RC_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
> -#define RC_TYPE_NEC	(1  << 1)
> -#define RC_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
> -#define RC_TYPE_JVC	(1  << 3)	/* JVC protocol */
> -#define RC_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
> -#define RC_TYPE_RC5_SZ	(1  << 5)	/* RC5 variant used by Streamzap */
> -#define RC_TYPE_SANYO   (1  << 6)	/* Sanyo protocol */
> -#define RC_TYPE_MCE_KBD	(1  << 29)	/* RC6-ish MCE keyboard/mouse */
> -#define RC_TYPE_LIRC	(1  << 30)	/* Pass raw IR to lirc userspace */
> -#define RC_TYPE_OTHER	(1u << 31)
> +enum rc_type {
> +	RC_TYPE_UNKNOWN		= 0,	/* Protocol not known */
> +	RC_TYPE_OTHER		= 1,	/* Protocol known but proprietary */
> +	RC_TYPE_LIRC		= 2,	/* Pass raw IR to lirc userspace */
> +	RC_TYPE_RC5		= 3,	/* Philips RC5 protocol */
> +	RC_TYPE_RC5X		= 4,	/* Philips RC5x protocol */
> +	RC_TYPE_RC5_SZ		= 5,	/* StreamZap variant of RC5 */
> +	RC_TYPE_JVC		= 6,	/* JVC protocol */
> +	RC_TYPE_SONY12		= 7,	/* Sony 12 bit protocol */
> +	RC_TYPE_SONY15		= 8,	/* Sony 15 bit protocol */
> +	RC_TYPE_SONY20		= 9,	/* Sony 20 bit protocol */
> +	RC_TYPE_NEC		= 10,	/* NEC protocol */
> +	RC_TYPE_SANYO		= 11,	/* Sanyo protocol */
> +	RC_TYPE_MCE_KBD		= 12,	/* RC6-ish MCE keyboard/mouse */
> +	RC_TYPE_RC6_0		= 13,	/* Philips RC6-0-16 protocol */
> +	RC_TYPE_RC6_6A_20	= 14,	/* Philips RC6-6A-20 protocol */
> +	RC_TYPE_RC6_6A_24	= 15,	/* Philips RC6-6A-24 protocol */
> +	RC_TYPE_RC6_6A_32	= 16,	/* Philips RC6-6A-32 protocol */
> +	RC_TYPE_RC6_MCE		= 17,	/* MCE (Philips RC6-6A-32 subtype) protocol */
> +};
> +
> +#define RC_BIT_NONE		0
> +#define RC_BIT_UNKNOWN		(1 << RC_TYPE_UNKNOWN)
> +#define RC_BIT_OTHER		(1 << RC_TYPE_OTHER)
> +#define RC_BIT_LIRC		(1 << RC_TYPE_LIRC)
> +#define RC_BIT_RC5		(1 << RC_TYPE_RC5)
> +#define RC_BIT_RC5X		(1 << RC_TYPE_RC5X)
> +#define RC_BIT_RC5_SZ		(1 << RC_TYPE_RC5_SZ)
> +#define RC_BIT_JVC		(1 << RC_TYPE_JVC)
> +#define RC_BIT_SONY12		(1 << RC_TYPE_SONY12)
> +#define RC_BIT_SONY15		(1 << RC_TYPE_SONY15)
> +#define RC_BIT_SONY20		(1 << RC_TYPE_SONY20)
> +#define RC_BIT_NEC		(1 << RC_TYPE_NEC)
> +#define RC_BIT_SANYO		(1 << RC_TYPE_SANYO)
> +#define RC_BIT_MCE_KBD		(1 << RC_TYPE_MCE_KBD)
> +#define RC_BIT_RC6_0		(1 << RC_TYPE_RC6_0)
> +#define RC_BIT_RC6_6A_20	(1 << RC_TYPE_RC6_6A_20)
> +#define RC_BIT_RC6_6A_24	(1 << RC_TYPE_RC6_6A_24)
> +#define RC_BIT_RC6_6A_32	(1 << RC_TYPE_RC6_6A_32)
> +#define RC_BIT_RC6_MCE		(1 << RC_TYPE_RC6_MCE)
>  
> -#define RC_TYPE_ALL (RC_TYPE_RC5    | RC_TYPE_NEC   | RC_TYPE_RC6     | \
> -		     RC_TYPE_JVC    | RC_TYPE_SONY  | RC_TYPE_LIRC    | \
> -		     RC_TYPE_RC5_SZ | RC_TYPE_SANYO | RC_TYPE_MCE_KBD | \
> -		     RC_TYPE_OTHER)
> +#define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | RC_BIT_LIRC | \
> +			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
> +			 RC_BIT_JVC | \
> +			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
> +			 RC_BIT_NEC | RC_BIT_SANYO | RC_BIT_MCE_KBD | \
> +			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
> +			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)
>  
>  struct rc_map_table {
>  	u32	scancode;
> @@ -38,7 +70,7 @@ struct rc_map {
>  	unsigned int		size;	/* Max number of entries */
>  	unsigned int		len;	/* Used number of entries */
>  	unsigned int		alloc;	/* Size of *scan in bytes */
> -	u64			rc_type;
> +	enum rc_type		rc_type;
>  	const char		*name;
>  	spinlock_t		lock;
>  };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

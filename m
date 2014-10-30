Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:64766 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760795AbaJ3Tag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 15:30:36 -0400
Received: by mail-lb0-f169.google.com with SMTP id l4so4883177lbv.14
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 12:30:34 -0700 (PDT)
Date: Thu, 30 Oct 2014 21:30:24 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: Nibble Max <nibble.max@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] cx23885: add DVBSky S950C dvb-s/s2 ci PCIe card
 support(no RC)
In-Reply-To: <201410231801394213817@gmail.com>
Message-ID: <alpine.DEB.2.10.1410302129460.1436@dl160.lan>
References: <201410231801394213817@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>

On Thu, 23 Oct 2014, Nibble Max wrote:

> DVBSky s950ci dvb-s/s2 ci PCIe card:
> 1>dvb frontend: M88TS2022(tuner),M88DS3103(demod)
> 2>ci controller: CIMAX SP2 or its clone.
> 3>PCIe bridge: CX23885
>
> The patchs are based on the following patchs.
> Olli Salonen submit:
> https://patchwork.linuxtv.org/patch/26180/
> https://patchwork.linuxtv.org/patch/26183/
> https://patchwork.linuxtv.org/patch/26324/
> Nibble Max submit:
> https://patchwork.linuxtv.org/patch/26207/
>
> Signed-off-by: Nibble Max <nibble.max@gmail.com>
> ---
> drivers/media/pci/cx23885/cx23885-cards.c | 11 +++++
> drivers/media/pci/cx23885/cx23885-dvb.c   | 79 ++++++++++++++++++++++++++-----
> drivers/media/pci/cx23885/cx23885.h       |  1 +
> 3 files changed, 80 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> index c4a69e4..ac34c27 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -684,6 +684,10 @@ struct cx23885_board cx23885_boards[] = {
> 		.name		= "DVBSky T980C",
> 		.portb		= CX23885_MPEG_DVB,
> 	},
> +	[CX23885_BOARD_DVBSKY_S950C] = {
> +		.name		= "DVBSky S950C",
> +		.portb		= CX23885_MPEG_DVB,
> +	},
> };
> const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
>
> @@ -947,6 +951,10 @@ struct cx23885_subid cx23885_subids[] = {
> 		.subvendor = 0x4254,
> 		.subdevice = 0x980c,
> 		.card      = CX23885_BOARD_DVBSKY_T980C,
> +	}, {
> +		.subvendor = 0x4254,
> +		.subdevice = 0x950c,
> +		.card      = CX23885_BOARD_DVBSKY_S950C,
> 	},
> };
> const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
> @@ -1550,6 +1558,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
> 		cx23885_gpio_set(dev, GPIO_2 | GPIO_11);
> 		break;
> 	case CX23885_BOARD_DVBSKY_T980C:
> +	case CX23885_BOARD_DVBSKY_S950C:
> 		/*
> 		 * GPIO-0 INTA from CiMax, input
> 		 * GPIO-1 reset CiMax, output, high active
> @@ -1859,6 +1868,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBWORLD_2005:
> 	case CX23885_BOARD_PROF_8000:
> 	case CX23885_BOARD_DVBSKY_T980C:
> +	case CX23885_BOARD_DVBSKY_S950C:
> 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
> 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> @@ -1978,6 +1988,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
> 	case CX23885_BOARD_TBS_6981:
> 	case CX23885_BOARD_DVBSKY_T9580:
> 	case CX23885_BOARD_DVBSKY_T980C:
> +	case CX23885_BOARD_DVBSKY_S950C:
> 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
> 				&dev->i2c_bus[2].i2c_adap,
> 				"cx25840", 0x88 >> 1, NULL);
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index efa05ee..f86b7c79 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -635,7 +635,7 @@ static int cx23885_sp2_ci_ctrl(void *priv, u8 read, int addr,
> 	struct cx23885_tsport *port = priv;
> 	struct cx23885_dev *dev = port->dev;
> 	int ret;
> -	int tmp;
> +	int tmp = 0;
> 	unsigned long timeout;
>
> 	mutex_lock(&dev->gpio_lock);
> @@ -865,6 +865,19 @@ static const struct m88ds3103_config dvbsky_t9580_m88ds3103_config = {
> 	.agc = 0x99,
> };
>
> +static const struct m88ds3103_config dvbsky_s950c_m88ds3103_config = {
> +	.i2c_addr = 0x68,
> +	.clock = 27000000,
> +	.i2c_wr_max = 33,
> +	.clock_out = 0,
> +	.ts_mode = M88DS3103_TS_CI,
> +	.ts_clk = 10000,
> +	.ts_clk_pol = 1,
> +	.lnb_en_pol = 1,
> +	.lnb_hv_pol = 0,
> +	.agc = 0x99,
> +};
> +
> static int netup_altera_fpga_rw(void *device, int flag, int data, int read)
> {
> 	struct cx23885_dev *dev = (struct cx23885_dev *)device;
> @@ -1020,7 +1033,7 @@ static int dvb_register(struct cx23885_tsport *port)
> 	struct m88ts2022_config m88ts2022_config;
> 	struct i2c_board_info info;
> 	struct i2c_adapter *adapter;
> -	struct i2c_client *client_demod, *client_tuner, *client_ci;
> +	struct i2c_client *client_demod = NULL, *client_tuner = NULL, *client_ci = NULL;
> 	int mfe_shared = 0; /* bus not shared by default */
> 	int ret;
>
> @@ -1796,6 +1809,41 @@ static int dvb_register(struct cx23885_tsport *port)
> 		}
> 		port->i2c_client_tuner = client_tuner;
> 		break;
> +	case CX23885_BOARD_DVBSKY_S950C:
> +		i2c_bus = &dev->i2c_bus[1];
> +		i2c_bus2 = &dev->i2c_bus[0];
> +
> +		/* attach frontend */
> +		fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
> +				&dvbsky_s950c_m88ds3103_config,
> +				&i2c_bus->i2c_adap, &adapter);
> +		if (fe0->dvb.frontend == NULL)
> +			break;
> +
> +		/* attach tuner */
> +		memset(&m88ts2022_config, 0, sizeof(m88ts2022_config));
> +		m88ts2022_config.fe = fe0->dvb.frontend;
> +		m88ts2022_config.clock = 27000000;
> +		memset(&info, 0, sizeof(struct i2c_board_info));
> +		strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
> +		info.addr = 0x60;
> +		info.platform_data = &m88ts2022_config;
> +		request_module(info.type);
> +		client_tuner = i2c_new_device(adapter, &info);
> +		if (client_tuner == NULL ||
> +				client_tuner->dev.driver == NULL)
> +			goto frontend_detach;
> +		if (!try_module_get(client_tuner->dev.driver->owner)) {
> +			i2c_unregister_device(client_tuner);
> +			goto frontend_detach;
> +		}
> +
> +		/* delegate signal strength measurement to tuner */
> +		fe0->dvb.frontend->ops.read_signal_strength =
> +			fe0->dvb.frontend->ops.tuner_ops.get_rf_strength;
> +
> +		port->i2c_client_tuner = client_tuner;
> +		break;
> 	default:
> 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
> 			" isn't supported yet\n",
> @@ -1886,6 +1934,7 @@ static int dvb_register(struct cx23885_tsport *port)
> 			(port->nr-1) * 8, 6);
> 		break;
> 		}
> +	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_DVBSKY_T980C: {
> 		u8 eeprom[256]; /* 24C02 i2c eeprom */
>
> @@ -1902,18 +1951,26 @@ static int dvb_register(struct cx23885_tsport *port)
> 		client_ci = i2c_new_device(&i2c_bus2->i2c_adap, &info);
> 		if (client_ci == NULL ||
> 				client_ci->dev.driver == NULL) {
> -			module_put(client_tuner->dev.driver->owner);
> -			i2c_unregister_device(client_tuner);
> -			module_put(client_demod->dev.driver->owner);
> -			i2c_unregister_device(client_demod);
> +			if (client_tuner) {
> +				module_put(client_tuner->dev.driver->owner);
> +				i2c_unregister_device(client_tuner);
> +			}
> +			if (client_demod) {
> +				module_put(client_demod->dev.driver->owner);
> +				i2c_unregister_device(client_demod);
> +			}
> 			goto frontend_detach;
> 		}
> 		if (!try_module_get(client_ci->dev.driver->owner)) {
> 			i2c_unregister_device(client_ci);
> -			module_put(client_tuner->dev.driver->owner);
> -			i2c_unregister_device(client_tuner);
> -			module_put(client_demod->dev.driver->owner);
> -			i2c_unregister_device(client_demod);
> +			if (client_tuner) {
> +				module_put(client_tuner->dev.driver->owner);
> +				i2c_unregister_device(client_tuner);
> +			}
> +			if (client_demod) {
> +				module_put(client_demod->dev.driver->owner);
> +				i2c_unregister_device(client_demod);
> +			}
> 			goto frontend_detach;
> 		}
> 		port->i2c_client_ci = client_ci;
> @@ -1925,7 +1982,7 @@ static int dvb_register(struct cx23885_tsport *port)
> 		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
> 		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
> 				sizeof(eeprom));
> -		printk(KERN_INFO "DVBSky T980C MAC address: %pM\n",
> +		printk(KERN_INFO "DVBSky T980C/S950C MAC address: %pM\n",
> 			eeprom + 0xc0);
> 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0, 6);
> 		break;
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index 27ea249..f6f6974 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -94,6 +94,7 @@
> #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2 44
> #define CX23885_BOARD_DVBSKY_T9580             45
> #define CX23885_BOARD_DVBSKY_T980C             46
> +#define CX23885_BOARD_DVBSKY_S950C             47
>
> #define GPIO_0 0x00000001
> #define GPIO_1 0x00000002
>
> -- 
> 1.9.1
>
>

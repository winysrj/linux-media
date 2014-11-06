Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:51274 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaKFUbC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 15:31:02 -0500
Received: by mail-la0-f52.google.com with SMTP id pv20so3238531lab.25
        for <linux-media@vger.kernel.org>; Thu, 06 Nov 2014 12:31:00 -0800 (PST)
Date: Thu, 6 Nov 2014 22:30:57 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: Nibble Max <nibble.max@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] cx23885: add DVBSky S952 support
In-Reply-To: <201411052258322502227@gmail.com>
Message-ID: <alpine.DEB.2.10.1411062228200.1386@dl160.lan>
References: <201411052258322502227@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good to me. Only missing T982 support now?

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>

-olli

On Wed, 5 Nov 2014, Nibble Max wrote:

> DVBSky S952 dvb-s/s2 dual PCIe card:
> 1>dvb frontend: M88TS2022(tuner),M88DS3103(demod)
> 2>PCIe bridge: CX23885(port b: parallel mode, port c: serial mode)
> 3>rc: cx23885 integrated.
>
> Signed-off-by: Nibble Max <nibble.max@gmail.com>
> ---
> drivers/media/pci/cx23885/cx23885-cards.c | 22 +++++++
> drivers/media/pci/cx23885/cx23885-dvb.c   | 99 ++++++++++++++++++++++++++++++-
> drivers/media/pci/cx23885/cx23885-input.c |  3 +
> drivers/media/pci/cx23885/cx23885.h       |  1 +
> 4 files changed, 124 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> index 4b9cb07..4bad27d 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -696,6 +696,11 @@ struct cx23885_board cx23885_boards[] = {
> 		.name		= "DVBSky S950",
> 		.portb		= CX23885_MPEG_DVB,
> 	},
> +	[CX23885_BOARD_DVBSKY_S952] = {
> +		.name		= "DVBSky S952",
> +		.portb		= CX23885_MPEG_DVB,
> +		.portc		= CX23885_MPEG_DVB,
> +	},
> };
> const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
>
> @@ -971,6 +976,10 @@ struct cx23885_subid cx23885_subids[] = {
> 		.subvendor = 0x4254,
> 		.subdevice = 0x0950,
> 		.card      = CX23885_BOARD_DVBSKY_S950,
> +	}, {
> +		.subvendor = 0x4254,
> +		.subdevice = 0x0952,
> +		.card      = CX23885_BOARD_DVBSKY_S952,
> 	},
> };
> const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
> @@ -1566,6 +1575,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
> 		mdelay(60);
> 		break;
> 	case CX23885_BOARD_DVBSKY_T9580:
> +	case CX23885_BOARD_DVBSKY_S952:
> 		/* enable GPIO3-18 pins */
> 		cx_write(MC417_CTL, 0x00000037);
> 		cx23885_gpio_enable(dev, GPIO_2 | GPIO_11, 1);
> @@ -1697,6 +1707,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> 	case CX23885_BOARD_DVBSKY_S950:
> +	case CX23885_BOARD_DVBSKY_S952:
> 		if (!enable_885_ir)
> 			break;
> 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
> @@ -1748,6 +1759,7 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> 	case CX23885_BOARD_DVBSKY_S950:
> +	case CX23885_BOARD_DVBSKY_S952:
> 		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
> 		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
> 		dev->sd_ir = NULL;
> @@ -1800,6 +1812,7 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> 	case CX23885_BOARD_DVBSKY_S950:
> +	case CX23885_BOARD_DVBSKY_S952:
> 		if (dev->sd_ir)
> 			cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
> 		break;
> @@ -1962,6 +1975,14 @@ void cx23885_card_setup(struct cx23885_dev *dev)
> 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> 		break;
> +	case CX23885_BOARD_DVBSKY_S952:
> +		ts1->gen_ctrl_val  = 0x5; /* Parallel */
> +		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> +		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> +		ts2->gen_ctrl_val  = 0xe; /* Serial bus */
> +		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> +		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> +		break;
> 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
> 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
> 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
> @@ -2029,6 +2050,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> 	case CX23885_BOARD_DVBSKY_S950:
> +	case CX23885_BOARD_DVBSKY_S952:
> 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
> 				&dev->i2c_bus[2].i2c_adap,
> 				"cx25840", 0x88 >> 1, NULL);
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index 3410ab8..2457b64 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -617,6 +617,32 @@ static int dvbsky_t9580_set_voltage(struct dvb_frontend *fe,
> 	return 0;
> }
>
> +static int dvbsky_s952_portc_set_voltage(struct dvb_frontend *fe,
> +					fe_sec_voltage_t voltage)
> +{
> +	struct cx23885_tsport *port = fe->dvb->priv;
> +	struct cx23885_dev *dev = port->dev;
> +
> +	cx23885_gpio_enable(dev, GPIO_12 | GPIO_13, 1);
> +
> +	switch (voltage) {
> +	case SEC_VOLTAGE_13:
> +		cx23885_gpio_set(dev, GPIO_13);
> +		cx23885_gpio_clear(dev, GPIO_12);
> +		break;
> +	case SEC_VOLTAGE_18:
> +		cx23885_gpio_set(dev, GPIO_13);
> +		cx23885_gpio_set(dev, GPIO_12);
> +		break;
> +	case SEC_VOLTAGE_OFF:
> +		cx23885_gpio_clear(dev, GPIO_13);
> +		cx23885_gpio_clear(dev, GPIO_12);
> +		break;
> +	}
> +	/* call the frontend set_voltage function */
> +	return port->fe_set_voltage(fe, voltage);
> +}
> +
> static int cx23885_sp2_ci_ctrl(void *priv, u8 read, int addr,
> 				u8 data, int *mem)
> {
> @@ -878,6 +904,19 @@ static const struct m88ds3103_config dvbsky_s950c_m88ds3103_config = {
> 	.agc = 0x99,
> };
>
> +static const struct m88ds3103_config dvbsky_s952_portc_m88ds3103_config = {
> +	.i2c_addr = 0x68,
> +	.clock = 27000000,
> +	.i2c_wr_max = 33,
> +	.clock_out = 0,
> +	.ts_mode = M88DS3103_TS_SERIAL,
> +	.ts_clk = 96000,
> +	.ts_clk_pol = 0,
> +	.lnb_en_pol = 1,
> +	.lnb_hv_pol = 0,
> +	.agc = 0x99,
> +};
> +
> static int netup_altera_fpga_rw(void *device, int flag, int data, int read)
> {
> 	struct cx23885_dev *dev = (struct cx23885_dev *)device;
> @@ -1034,6 +1073,8 @@ static int dvb_register(struct cx23885_tsport *port)
> 	struct i2c_board_info info;
> 	struct i2c_adapter *adapter;
> 	struct i2c_client *client_demod = NULL, *client_tuner = NULL, *client_ci = NULL;
> +	const struct m88ds3103_config *p_m88ds3103_config = NULL;
> +	int (*p_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage) = NULL;
> 	int mfe_shared = 0; /* bus not shared by default */
> 	int ret;
>
> @@ -1849,6 +1890,61 @@ static int dvb_register(struct cx23885_tsport *port)
>
> 		port->i2c_client_tuner = client_tuner;
> 		break;
> +	case CX23885_BOARD_DVBSKY_S952:
> +		switch (port->nr) {
> +		/* port b */
> +		case 1:
> +			i2c_bus = &dev->i2c_bus[1];
> +			p_m88ds3103_config = &dvbsky_t9580_m88ds3103_config;
> +			p_set_voltage = dvbsky_t9580_set_voltage;
> +			break;
> +		/* port c */
> +		case 2:
> +			i2c_bus = &dev->i2c_bus[0];
> +			p_m88ds3103_config = &dvbsky_s952_portc_m88ds3103_config;
> +			p_set_voltage = dvbsky_s952_portc_set_voltage;
> +			break;
> +		}
> +
> +		/* attach frontend */
> +		fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
> +				p_m88ds3103_config,
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
> +		/*
> +		 * for setting the voltage we need to set GPIOs on
> +		 * the card.
> +		 */
> +		port->fe_set_voltage =
> +			fe0->dvb.frontend->ops.set_voltage;
> +		fe0->dvb.frontend->ops.set_voltage = p_set_voltage;
> +
> +		port->i2c_client_tuner = client_tuner;
> +		break;
> 	default:
> 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
> 			" isn't supported yet\n",
> @@ -1924,7 +2020,8 @@ static int dvb_register(struct cx23885_tsport *port)
> 		break;
> 		}
> 	case CX23885_BOARD_DVBSKY_T9580:
> -	case CX23885_BOARD_DVBSKY_S950: {
> +	case CX23885_BOARD_DVBSKY_S950:
> +	case CX23885_BOARD_DVBSKY_S952: {
> 		u8 eeprom[256]; /* 24C02 i2c eeprom */
>
> 		if (port->nr > 2)
> diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
> index 7523d0a..a1f4894 100644
> --- a/drivers/media/pci/cx23885/cx23885-input.c
> +++ b/drivers/media/pci/cx23885/cx23885-input.c
> @@ -92,6 +92,7 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> 	case CX23885_BOARD_DVBSKY_S950:
> +	case CX23885_BOARD_DVBSKY_S952:
> 		/*
> 		 * The only boards we handle right now.  However other boards
> 		 * using the CX2388x integrated IR controller should be similar
> @@ -149,6 +150,7 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> 	case CX23885_BOARD_DVBSKY_S950:
> +	case CX23885_BOARD_DVBSKY_S952:
> 		/*
> 		 * The IR controller on this board only returns pulse widths.
> 		 * Any other mode setting will fail to set up the device.
> @@ -319,6 +321,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_T980C:
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_DVBSKY_S950:
> +	case CX23885_BOARD_DVBSKY_S952:
> 		/* Integrated CX23885 IR controller */
> 		driver_type = RC_DRIVER_IR_RAW;
> 		allowed_protos = RC_BIT_ALL;
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index f9cd0da..58c5038 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -97,6 +97,7 @@
> #define CX23885_BOARD_DVBSKY_S950C             47
> #define CX23885_BOARD_TT_CT2_4500_CI           48
> #define CX23885_BOARD_DVBSKY_S950              49
> +#define CX23885_BOARD_DVBSKY_S952              50
>
> #define GPIO_0 0x00000001
> #define GPIO_1 0x00000002
>
> -- 
> 1.9.1
>
>

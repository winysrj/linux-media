Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:50048 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaKFUPR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 15:15:17 -0500
Received: by mail-lb0-f173.google.com with SMTP id n15so1584690lbi.18
        for <linux-media@vger.kernel.org>; Thu, 06 Nov 2014 12:15:15 -0800 (PST)
Date: Thu, 6 Nov 2014 22:15:05 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: Nibble Max <nibble.max@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] cx23885: add DVBSky S950 support
In-Reply-To: <201411052258037656794@gmail.com>
Message-ID: <alpine.DEB.2.10.1411062212120.1386@dl160.lan>
References: <201411052258037656794@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>

On Wed, 5 Nov 2014, Nibble Max wrote:

> DVBSky S950 dvb-s/s2 PCIe card:
> 1>dvb frontend: M88TS2022(tuner),M88DS3103(demod)
> 2>PCIe bridge: cx23885
> 3>rc: cx23885 integrated.
>
> Signed-off-by: Nibble Max <nibble.max@gmail.com>
> ---
> drivers/media/pci/cx23885/cx23885-cards.c | 20 ++++++++++++++++++++
> drivers/media/pci/cx23885/cx23885-dvb.c   |  9 ++++++---
> drivers/media/pci/cx23885/cx23885-input.c |  3 +++
> drivers/media/pci/cx23885/cx23885.h       |  1 +
> 4 files changed, 30 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> index 9c7e8ac..4b9cb07 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -692,6 +692,10 @@ struct cx23885_board cx23885_boards[] = {
> 		.name		= "Technotrend TT-budget CT2-4500 CI",
> 		.portb		= CX23885_MPEG_DVB,
> 	},
> +	[CX23885_BOARD_DVBSKY_S950] = {
> +		.name		= "DVBSky S950",
> +		.portb		= CX23885_MPEG_DVB,
> +	},
> };
> const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
>
> @@ -963,6 +967,10 @@ struct cx23885_subid cx23885_subids[] = {
> 		.subvendor = 0x13c2,
> 		.subdevice = 0x3013,
> 		.card      = CX23885_BOARD_TT_CT2_4500_CI,
> +	}, {
> +		.subvendor = 0x4254,
> +		.subdevice = 0x0950,
> +		.card      = CX23885_BOARD_DVBSKY_S950,
> 	},
> };
> const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
> @@ -1597,6 +1605,13 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
>
> 		/* enable irq */
> 		cx_write(GPIO_ISM, 0x00000000); /* INTERRUPTS active low */
> +		break;
> +	case CX23885_BOARD_DVBSKY_S950:
> +		cx23885_gpio_enable(dev, GPIO_2, 1);
> +		cx23885_gpio_clear(dev, GPIO_2);
> +		msleep(100);
> +		cx23885_gpio_set(dev, GPIO_2);
> +		break;
> 	}
> }
>
> @@ -1681,6 +1696,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_T980C:
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> +	case CX23885_BOARD_DVBSKY_S950:
> 		if (!enable_885_ir)
> 			break;
> 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
> @@ -1731,6 +1747,7 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_T980C:
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> +	case CX23885_BOARD_DVBSKY_S950:
> 		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
> 		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
> 		dev->sd_ir = NULL;
> @@ -1782,6 +1799,7 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_T980C:
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> +	case CX23885_BOARD_DVBSKY_S950:
> 		if (dev->sd_ir)
> 			cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
> 		break;
> @@ -1888,6 +1906,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_T980C:
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> +	case CX23885_BOARD_DVBSKY_S950:
> 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
> 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> @@ -2009,6 +2028,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_T980C:
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> +	case CX23885_BOARD_DVBSKY_S950:
> 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
> 				&dev->i2c_bus[2].i2c_adap,
> 				"cx25840", 0x88 >> 1, NULL);
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index 9da5cf3..3410ab8 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -1672,6 +1672,7 @@ static int dvb_register(struct cx23885_tsport *port)
> 		}
> 		break;
> 	case CX23885_BOARD_DVBSKY_T9580:
> +	case CX23885_BOARD_DVBSKY_S950:
> 		i2c_bus = &dev->i2c_bus[0];
> 		i2c_bus2 = &dev->i2c_bus[1];
> 		switch (port->nr) {
> @@ -1922,7 +1923,8 @@ static int dvb_register(struct cx23885_tsport *port)
> 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xa0, 6);
> 		break;
> 		}
> -	case CX23885_BOARD_DVBSKY_T9580: {
> +	case CX23885_BOARD_DVBSKY_T9580:
> +	case CX23885_BOARD_DVBSKY_S950: {
> 		u8 eeprom[256]; /* 24C02 i2c eeprom */
>
> 		if (port->nr > 2)
> @@ -1932,8 +1934,9 @@ static int dvb_register(struct cx23885_tsport *port)
> 		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
> 		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
> 				sizeof(eeprom));
> -		printk(KERN_INFO "DVBSky T9580 port %d MAC address: %pM\n",
> -			port->nr, eeprom + 0xc0 + (port->nr-1) * 8);
> +		printk(KERN_INFO "%s port %d MAC address: %pM\n",
> +			cx23885_boards[dev->board].name, port->nr,
> +			eeprom + 0xc0 + (port->nr-1) * 8);
> 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0 +
> 			(port->nr-1) * 8, 6);
> 		break;
> diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
> index 12d8a3d..7523d0a 100644
> --- a/drivers/media/pci/cx23885/cx23885-input.c
> +++ b/drivers/media/pci/cx23885/cx23885-input.c
> @@ -91,6 +91,7 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
> 	case CX23885_BOARD_DVBSKY_T980C:
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> +	case CX23885_BOARD_DVBSKY_S950:
> 		/*
> 		 * The only boards we handle right now.  However other boards
> 		 * using the CX2388x integrated IR controller should be similar
> @@ -147,6 +148,7 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_T980C:
> 	case CX23885_BOARD_DVBSKY_S950C:
> 	case CX23885_BOARD_TT_CT2_4500_CI:
> +	case CX23885_BOARD_DVBSKY_S950:
> 		/*
> 		 * The IR controller on this board only returns pulse widths.
> 		 * Any other mode setting will fail to set up the device.
> @@ -316,6 +318,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
> 	case CX23885_BOARD_DVBSKY_T9580:
> 	case CX23885_BOARD_DVBSKY_T980C:
> 	case CX23885_BOARD_DVBSKY_S950C:
> +	case CX23885_BOARD_DVBSKY_S950:
> 		/* Integrated CX23885 IR controller */
> 		driver_type = RC_DRIVER_IR_RAW;
> 		allowed_protos = RC_BIT_ALL;
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index 7eee2ea..f9cd0da 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -96,6 +96,7 @@
> #define CX23885_BOARD_DVBSKY_T980C             46
> #define CX23885_BOARD_DVBSKY_S950C             47
> #define CX23885_BOARD_TT_CT2_4500_CI           48
> +#define CX23885_BOARD_DVBSKY_S950              49
>
> #define GPIO_0 0x00000001
> #define GPIO_1 0x00000002
>
> -- 
> 1.9.1
>
>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50102 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbaLUU10 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Dec 2014 15:27:26 -0500
Message-ID: <54972D2B.9040802@iki.fi>
Date: Sun, 21 Dec 2014 22:27:23 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH] cx23885: Split Hauppauge WinTV Starburst from HVR4400
 card entry
References: <1419191964-29833-1-git-send-email-zzam@gentoo.org>
In-Reply-To: <1419191964-29833-1-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Works now

media: Linux media interface: v0.10
Linux video capture interface: v2.00
cx23885 driver version 0.0.4 loaded
CORE cx23885[0]: subsystem: 0070:c12a, board: Hauppauge WinTV Starburst 
[card=52,autodetected]
tveeprom 5-0050: Hauppauge model 121200, rev B2C3, serial# 4034388477
tveeprom 5-0050: MAC address is 00:0d:fe:77:e1:fd
tveeprom 5-0050: tuner model is Conexant CX24118A (idx 123, type 4)
tveeprom 5-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
tveeprom 5-0050: audio processor is CX23888 (idx 40)
tveeprom 5-0050: decoder processor is CX23888 (idx 34)
tveeprom 5-0050: has no radio, has IR receiver, has no IR transmitter
cx23885[0]: warning: unknown hauppauge model #121200
cx23885[0]: hauppauge eeprom: model=121200
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
i2c i2c-5: a8293: Allegro A8293 SEC attached
DVB: registering new adapter (cx23885[0])
cx23885 0000:02:00.0: DVB: registering adapter 0 frontend 0 (NXP 
TDA10071)...
cx23885_dev_checkrevision() Hardware revision = 0xd0
cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 18, latency: 0, mmio: 
0xfe800000


Tested-by: Antti Palosaari <crope@iki.fi>

Antti

On 12/21/2014 09:59 PM, Matthias Schwarzott wrote:
> Unconditionally attaching Si2161/Si2165 demod driver
> breaks Hauppauge WinTV Starburst.
> So create own card entry for this.
>
> Add card name comments to the subsystem ids.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/pci/cx23885/cx23885-cards.c | 23 +++++++++++++++++------
>   drivers/media/pci/cx23885/cx23885-dvb.c   | 11 +++++++++++
>   drivers/media/pci/cx23885/cx23885.h       |  1 +
>   3 files changed, 29 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> index db99ca2..06931f6 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -614,7 +614,7 @@ struct cx23885_board cx23885_boards[] = {
>   		.portb		= CX23885_MPEG_DVB,
>   	},
>   	[CX23885_BOARD_HAUPPAUGE_HVR4400] = {
> -		.name		= "Hauppauge WinTV-HVR4400",
> +		.name		= "Hauppauge WinTV-HVR4400/HVR5500",
>   		.porta		= CX23885_ANALOG_VIDEO,
>   		.portb		= CX23885_MPEG_DVB,
>   		.portc		= CX23885_MPEG_DVB,
> @@ -622,6 +622,10 @@ struct cx23885_board cx23885_boards[] = {
>   		.tuner_addr	= 0x60, /* 0xc0 >> 1 */
>   		.tuner_bus	= 1,
>   	},
> +	[CX23885_BOARD_HAUPPAUGE_STARBURST] = {
> +		.name		= "Hauppauge WinTV Starburst",
> +		.portb		= CX23885_MPEG_DVB,
> +	},
>   	[CX23885_BOARD_AVERMEDIA_HC81R] = {
>   		.name		= "AVerTV Hybrid Express Slim HC81R",
>   		.tuner_type	= TUNER_XC2028,
> @@ -936,19 +940,19 @@ struct cx23885_subid cx23885_subids[] = {
>   	}, {
>   		.subvendor = 0x0070,
>   		.subdevice = 0xc108,
> -		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400,
> +		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400, /* Hauppauge WinTV HVR-4400 (Model 121xxx, Hybrid DVB-T/S2, IR) */
>   	}, {
>   		.subvendor = 0x0070,
>   		.subdevice = 0xc138,
> -		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400,
> +		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400, /* Hauppauge WinTV HVR-5500 (Model 121xxx, Hybrid DVB-T/C/S2, IR) */
>   	}, {
>   		.subvendor = 0x0070,
>   		.subdevice = 0xc12a,
> -		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400,
> +		.card      = CX23885_BOARD_HAUPPAUGE_STARBURST, /* Hauppauge WinTV Starburst (Model 121x00, DVB-S2, IR) */
>   	}, {
>   		.subvendor = 0x0070,
>   		.subdevice = 0xc1f8,
> -		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400,
> +		.card      = CX23885_BOARD_HAUPPAUGE_HVR4400, /* Hauppauge WinTV HVR-5500 (Model 121xxx, Hybrid DVB-T/C/S2, IR) */
>   	}, {
>   		.subvendor = 0x1461,
>   		.subdevice = 0xd939,
> @@ -1545,8 +1549,9 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
>   		cx_write(GPIO_ISM, 0x00000000);/* INTERRUPTS active low*/
>   		break;
>   	case CX23885_BOARD_HAUPPAUGE_HVR4400:
> +	case CX23885_BOARD_HAUPPAUGE_STARBURST:
>   		/* GPIO-8 tda10071 demod reset */
> -		/* GPIO-9 si2165 demod reset */
> +		/* GPIO-9 si2165 demod reset (only HVR4400/HVR5500)*/
>
>   		/* Put the parts into reset and back */
>   		cx23885_gpio_enable(dev, GPIO_8 | GPIO_9, 1);
> @@ -1872,6 +1877,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>   	case CX23885_BOARD_HAUPPAUGE_HVR1850:
>   	case CX23885_BOARD_HAUPPAUGE_HVR1290:
>   	case CX23885_BOARD_HAUPPAUGE_HVR4400:
> +	case CX23885_BOARD_HAUPPAUGE_STARBURST:
>   	case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
>   		if (dev->i2c_bus[0].i2c_rc == 0)
>   			hauppauge_eeprom(dev, eeprom+0xc0);
> @@ -1980,6 +1986,11 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>   		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
>   		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
>   		break;
> +	case CX23885_BOARD_HAUPPAUGE_STARBURST:
> +		ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
> +		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> +		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> +		break;
>   	case CX23885_BOARD_DVBSKY_T9580:
>   	case CX23885_BOARD_DVBSKY_T982:
>   		ts1->gen_ctrl_val  = 0x5; /* Parallel */
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index c47d182..a9c450d 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -1710,6 +1710,17 @@ static int dvb_register(struct cx23885_tsport *port)
>   			break;
>   		}
>   		break;
> +	case CX23885_BOARD_HAUPPAUGE_STARBURST:
> +		i2c_bus = &dev->i2c_bus[0];
> +		fe0->dvb.frontend = dvb_attach(tda10071_attach,
> +						&hauppauge_tda10071_config,
> +						&i2c_bus->i2c_adap);
> +		if (fe0->dvb.frontend != NULL) {
> +			dvb_attach(a8293_attach, fe0->dvb.frontend,
> +				   &i2c_bus->i2c_adap,
> +				   &hauppauge_a8293_config);
> +		}
> +		break;
>   	case CX23885_BOARD_DVBSKY_T9580:
>   	case CX23885_BOARD_DVBSKY_S950:
>   		i2c_bus = &dev->i2c_bus[0];
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index f55cd12..36f2f96 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -99,6 +99,7 @@
>   #define CX23885_BOARD_DVBSKY_S950              49
>   #define CX23885_BOARD_DVBSKY_S952              50
>   #define CX23885_BOARD_DVBSKY_T982              51
> +#define CX23885_BOARD_HAUPPAUGE_STARBURST      52
>
>   #define GPIO_0 0x00000001
>   #define GPIO_1 0x00000002
>

-- 
http://palosaari.fi/

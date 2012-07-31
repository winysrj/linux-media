Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab2GaDJS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 23:09:18 -0400
Message-ID: <50174C3A.1070407@redhat.com>
Date: Tue, 31 Jul 2012 00:08:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mariusz Bialonczyk <manio@skyboo.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Wojciech Myrda <vojcek@tlen.pl>
Subject: Re: [PATCH] Add support for Prof Revolution DVB-S2 8000 PCI-E card
References: <1343326123-11882-1-git-send-email-manio@skyboo.net>
In-Reply-To: <1343326123-11882-1-git-send-email-manio@skyboo.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-07-2012 15:08, Mariusz Bialonczyk escreveu:
> The device is based on STV0903 demodulator, STB6100 tuner
> and CX23885 chipset; subsystem id: 8000:3034
> 
> Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>

This is the second time I see this patch. It seems very similar to the
one sent by Wojciech. So, who is the author of this patch?


> ---
>   drivers/media/video/cx23885/Kconfig         |    1 +
>   drivers/media/video/cx23885/cx23885-cards.c |   10 +++++
>   drivers/media/video/cx23885/cx23885-dvb.c   |   56 +++++++++++++++++++++++++++
>   drivers/media/video/cx23885/cx23885.h       |    1 +
>   4 files changed, 68 insertions(+)
> 
> diff --git a/drivers/media/video/cx23885/Kconfig b/drivers/media/video/cx23885/Kconfig
> index b391e9b..510adfe 100644
> --- a/drivers/media/video/cx23885/Kconfig
> +++ b/drivers/media/video/cx23885/Kconfig
> @@ -21,6 +21,7 @@ config VIDEO_CX23885
>   	select DVB_STV6110 if !DVB_FE_CUSTOMISE
>   	select DVB_CX24116 if !DVB_FE_CUSTOMISE
>   	select DVB_STV0900 if !DVB_FE_CUSTOMISE
> +	select DVB_STV090x if !DVB_FE_CUSTOMISE
>   	select DVB_DS3000 if !DVB_FE_CUSTOMISE
>   	select DVB_STV0367 if !DVB_FE_CUSTOMISE
>   	select MEDIA_TUNER_MT2131 if !MEDIA_TUNER_CUSTOMISE

You've included 3 files at -dvb:

	+#include "stv090x.h"
	+#include "stb6100.h"
	+#include "stb6100_cfg.h"

but you're selecting only STV090x. It seems you missed stb6100 here.


> diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
> index 080e111..50fedff 100644
> --- a/drivers/media/video/cx23885/cx23885-cards.c
> +++ b/drivers/media/video/cx23885/cx23885-cards.c
> @@ -564,6 +564,10 @@ struct cx23885_board cx23885_boards[] = {
>   	[CX23885_BOARD_TEVII_S471] = {
>   		.name		= "TeVii S471",
>   		.portb		= CX23885_MPEG_DVB,
> +	},
> +	[CX23885_BOARD_PROF_8000] = {
> +		.name		= "Prof Revolution DVB-S2 8000",
> +		.portb		= CX23885_MPEG_DVB,
>   	}
>   };
>   const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
> @@ -776,6 +780,10 @@ struct cx23885_subid cx23885_subids[] = {
>   		.subvendor = 0xd471,
>   		.subdevice = 0x9022,
>   		.card      = CX23885_BOARD_TEVII_S471,
> +	}, {
> +		.subvendor = 0x8000,
> +		.subdevice = 0x3034,
> +		.card      = CX23885_BOARD_PROF_8000,
>   	},
>   };
>   const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
> @@ -1155,6 +1163,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
>   		cx_set(GP0_IO, 0x00040004);
>   		break;
>   	case CX23885_BOARD_TBS_6920:
> +	case CX23885_BOARD_PROF_8000:
>   		cx_write(MC417_CTL, 0x00000036);
>   		cx_write(MC417_OEN, 0x00001000);
>   		cx_set(MC417_RWD, 0x00000002);
> @@ -1536,6 +1545,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>   	case CX23885_BOARD_TEVII_S470:
>   	case CX23885_BOARD_TEVII_S471:
>   	case CX23885_BOARD_DVBWORLD_2005:
> +	case CX23885_BOARD_PROF_8000:
>   		ts1->gen_ctrl_val  = 0x5; /* Parallel */
>   		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
>   		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
> index cd54268..ba046ea 100644
> --- a/drivers/media/video/cx23885/cx23885-dvb.c
> +++ b/drivers/media/video/cx23885/cx23885-dvb.c
> @@ -63,6 +63,9 @@
>   #include "stv0367.h"
>   #include "drxk.h"
>   #include "mt2063.h"
> +#include "stv090x.h"
> +#include "stb6100.h"
> +#include "stb6100_cfg.h"
>   
>   static unsigned int debug;
>   
> @@ -489,6 +492,42 @@ static struct xc5000_config mygica_x8506_xc5000_config = {
>   	.if_khz = 5380,
>   };
>   
> +static struct stv090x_config prof_8000_stv090x_config = {
> +        .device                 = STV0903,
> +        .demod_mode             = STV090x_SINGLE,
> +        .clk_mode               = STV090x_CLK_EXT,
> +        .xtal                   = 27000000,
> +        .address                = 0x6A,
> +        .ts1_mode               = STV090x_TSMODE_PARALLEL_PUNCTURED,
> +        .repeater_level         = STV090x_RPTLEVEL_64,
> +        .adc1_range             = STV090x_ADC_2Vpp,
> +        .diseqc_envelope_mode   = false,
> +
> +        .tuner_get_frequency    = stb6100_get_frequency,
> +        .tuner_set_frequency    = stb6100_set_frequency,
> +        .tuner_set_bandwidth    = stb6100_set_bandwidth,
> +        .tuner_get_bandwidth    = stb6100_get_bandwidth,
> +};
> +
> +static struct stb6100_config prof_8000_stb6100_config = {
> +	.tuner_address = 0x60,
> +	.refclock = 27000000,
> +};
> +
> +static int p8000_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
> +{
> +	struct cx23885_tsport *port = fe->dvb->priv;
> +	struct cx23885_dev *dev = port->dev;
> +
> +	if (voltage == SEC_VOLTAGE_18)
> +		cx_write(MC417_RWD, 0x00001e00);
> +	else if (voltage == SEC_VOLTAGE_13)
> +		cx_write(MC417_RWD, 0x00001a00);
> +	else
> +		cx_write(MC417_RWD, 0x00001800);
> +	return 0;
> +}
> +
>   static int cx23885_dvb_set_frontend(struct dvb_frontend *fe)
>   {
>   	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> @@ -1186,6 +1225,23 @@ static int dvb_register(struct cx23885_tsport *port)
>   					&tevii_ds3000_config,
>   					&i2c_bus->i2c_adap);
>   		break;
> +	case CX23885_BOARD_PROF_8000:
> +		i2c_bus = &dev->i2c_bus[0];
> +
> +		fe0->dvb.frontend = dvb_attach(stv090x_attach,
> +						&prof_8000_stv090x_config,
> +						&i2c_bus->i2c_adap,
> +						STV090x_DEMODULATOR_0);
> +		if (fe0->dvb.frontend != NULL) {
> +			if (!dvb_attach(stb6100_attach,
> +					fe0->dvb.frontend,
> +					&prof_8000_stb6100_config,
> +					&i2c_bus->i2c_adap))
> +				goto frontend_detach;
> +
> +			fe0->dvb.frontend->ops.set_voltage = p8000_set_voltage;
> +		}
> +		break;
>   	default:
>   		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
>   			" isn't supported yet\n",
> diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
> index 13c37ec..452ccec 100644
> --- a/drivers/media/video/cx23885/cx23885.h
> +++ b/drivers/media/video/cx23885/cx23885.h
> @@ -91,6 +91,7 @@
>   #define CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL 34
>   #define CX23885_BOARD_TEVII_S471               35
>   #define CX23885_BOARD_HAUPPAUGE_HVR1255_22111  36
> +#define CX23885_BOARD_PROF_8000                37
>   
>   #define GPIO_0 0x00000001
>   #define GPIO_1 0x00000002
> 


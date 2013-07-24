Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33311 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab3GXRkk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 13:40:40 -0400
Message-ID: <51F0116D.9060807@iki.fi>
Date: Wed, 24 Jul 2013 20:39:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis Alves <ljalvs@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH 2/2] cx24117[v4]: Add new dvb-frontend: add supported
 cards to cx23885. Currently tested with TBS6980 and TBS6981.
References: <1374679132-30672-1-git-send-email-ljalvs@gmail.com> <1374679132-30672-2-git-send-email-ljalvs@gmail.com>
In-Reply-To: <1374679132-30672-2-git-send-email-ljalvs@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/24/2013 06:18 PM, Luis Alves wrote:
> v4:
> Patch order fixed.
> Changed some msleep's to clear checkpatch warnings.
>
>
> Signed-off-by: Luis Alves <ljalvs@gmail.com>

Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/pci/cx23885/Kconfig         |    1 +
>   drivers/media/pci/cx23885/cx23885-cards.c |   67 +++++++++++++++++++++++++++++
>   drivers/media/pci/cx23885/cx23885-dvb.c   |   31 +++++++++++++
>   drivers/media/pci/cx23885/cx23885-input.c |   12 ++++++
>   drivers/media/pci/cx23885/cx23885.h       |    2 +
>   5 files changed, 113 insertions(+)
>
> diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
> index b3688aa..91b2ed7 100644
> --- a/drivers/media/pci/cx23885/Kconfig
> +++ b/drivers/media/pci/cx23885/Kconfig
> @@ -23,6 +23,7 @@ config VIDEO_CX23885
>   	select DVB_STB6100 if MEDIA_SUBDRV_AUTOSELECT
>   	select DVB_STV6110 if MEDIA_SUBDRV_AUTOSELECT
>   	select DVB_CX24116 if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_CX24117 if MEDIA_SUBDRV_AUTOSELECT
>   	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
>   	select DVB_DS3000 if MEDIA_SUBDRV_AUTOSELECT
>   	select DVB_TS2020 if MEDIA_SUBDRV_AUTOSELECT
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> index 7e923f8..7ecd3fb 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -259,6 +259,16 @@ struct cx23885_board cx23885_boards[] = {
>   		.name		= "TurboSight TBS 6920",
>   		.portb		= CX23885_MPEG_DVB,
>   	},
> +	[CX23885_BOARD_TBS_6980] = {
> +		.name		= "TurboSight TBS 6980",
> +		.portb		= CX23885_MPEG_DVB,
> +		.portc		= CX23885_MPEG_DVB,
> +	},
> +	[CX23885_BOARD_TBS_6981] = {
> +		.name		= "TurboSight TBS 6981",
> +		.portb		= CX23885_MPEG_DVB,
> +		.portc		= CX23885_MPEG_DVB,
> +	},
>   	[CX23885_BOARD_TEVII_S470] = {
>   		.name		= "TeVii S470",
>   		.portb		= CX23885_MPEG_DVB,
> @@ -698,6 +708,14 @@ struct cx23885_subid cx23885_subids[] = {
>   		.subdevice = 0x8888,
>   		.card      = CX23885_BOARD_TBS_6920,
>   	}, {
> +		.subvendor = 0x6980,
> +		.subdevice = 0x8888,
> +		.card      = CX23885_BOARD_TBS_6980,
> +	}, {
> +		.subvendor = 0x6981,
> +		.subdevice = 0x8888,
> +		.card      = CX23885_BOARD_TBS_6981,
> +	}, {
>   		.subvendor = 0xd470,
>   		.subdevice = 0x9022,
>   		.card      = CX23885_BOARD_TEVII_S470,
> @@ -1022,6 +1040,35 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
>   			dev->name, tv.model);
>   }
>
> +/* Some TBS cards require initing a chip using a bitbanged SPI attached
> +   to the cx23885 gpio's. If this chip doesn't get init'ed the demod
> +   doesn't respond to any command. */
> +static void tbs_card_init(struct cx23885_dev *dev)
> +{
> +	int i;
> +	const u8 buf[] = {
> +		0xe0, 0x06, 0x66, 0x33, 0x65,
> +		0x01, 0x17, 0x06, 0xde};
> +
> +	switch (dev->board) {
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
> +		cx_set(GP0_IO, 0x00070007);
> +		usleep_range(1000, 10000);
> +		cx_clear(GP0_IO, 2);
> +		usleep_range(1000, 10000);
> +		for (i = 0; i < 9 * 8; i++) {
> +			cx_clear(GP0_IO, 7);
> +			usleep_range(1000, 10000);
> +			cx_set(GP0_IO,
> +				((buf[i >> 3] >> (7 - (i & 7))) & 1) | 4);
> +			usleep_range(1000, 10000);
> +		}
> +		cx_set(GP0_IO, 7);
> +		break;
> +	}
> +}
> +
>   int cx23885_tuner_callback(void *priv, int component, int command, int arg)
>   {
>   	struct cx23885_tsport *port = priv;
> @@ -1224,6 +1271,8 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
>   		cx_set(GP0_IO, 0x00040004);
>   		break;
>   	case CX23885_BOARD_TBS_6920:
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
>   	case CX23885_BOARD_PROF_8000:
>   		cx_write(MC417_CTL, 0x00000036);
>   		cx_write(MC417_OEN, 0x00001000);
> @@ -1472,6 +1521,8 @@ int cx23885_ir_init(struct cx23885_dev *dev)
>   	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
>   	case CX23885_BOARD_TEVII_S470:
>   	case CX23885_BOARD_MYGICA_X8507:
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
>   		if (!enable_885_ir)
>   			break;
>   		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
> @@ -1515,6 +1566,8 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
>   	case CX23885_BOARD_TEVII_S470:
>   	case CX23885_BOARD_HAUPPAUGE_HVR1250:
>   	case CX23885_BOARD_MYGICA_X8507:
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
>   		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
>   		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
>   		dev->sd_ir = NULL;
> @@ -1560,6 +1613,8 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
>   	case CX23885_BOARD_TEVII_S470:
>   	case CX23885_BOARD_HAUPPAUGE_HVR1250:
>   	case CX23885_BOARD_MYGICA_X8507:
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
>   		if (dev->sd_ir)
>   			cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
>   		break;
> @@ -1675,6 +1730,16 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>   		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
>   		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
>   		break;
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
> +		ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
> +		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> +		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> +		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
> +		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> +		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> +		tbs_card_init(dev);
> +		break;
>   	case CX23885_BOARD_MYGICA_X8506:
>   	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
>   		ts1->gen_ctrl_val  = 0x5; /* Parallel */
> @@ -1750,6 +1815,8 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>   	case CX23885_BOARD_MYGICA_X8507:
>   	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
>   	case CX23885_BOARD_AVERMEDIA_HC81R:
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
>   		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
>   				&dev->i2c_bus[2].i2c_adap,
>   				"cx25840", 0x88 >> 1, NULL);
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index 9c5ed10..bfb7e33 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -51,6 +51,7 @@
>   #include "stv6110.h"
>   #include "lnbh24.h"
>   #include "cx24116.h"
> +#include "cx24117.h"
>   #include "cimax2.h"
>   #include "lgs8gxx.h"
>   #include "netup-eeprom.h"
> @@ -468,6 +469,10 @@ static struct cx24116_config tbs_cx24116_config = {
>   	.demod_address = 0x55,
>   };
>
> +static struct cx24117_config tbs_cx24117_config = {
> +	.demod_address = 0x55,
> +};
> +
>   static struct ds3000_config tevii_ds3000_config = {
>   	.demod_address = 0x68,
>   };
> @@ -1027,6 +1032,32 @@ static int dvb_register(struct cx23885_tsport *port)
>   			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
>
>   		break;
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
> +		i2c_bus = &dev->i2c_bus[1];
> +
> +		switch (port->nr) {
> +		/* PORT B */
> +		case 1:
> +			fe0->dvb.frontend = dvb_attach(cx24117_attach,
> +					&tbs_cx24117_config,
> +					&i2c_bus->i2c_adap, NULL);
> +			break;
> +		/* PORT C */
> +		case 2:
> +			/* use fe1 pointer as temporary holder */
> +			/* for the first frontend */
> +			fe1 = videobuf_dvb_get_frontend(
> +				&port->dev->ts1.frontends, 1);
> +
> +			fe0->dvb.frontend = dvb_attach(cx24117_attach,
> +					&tbs_cx24117_config,
> +					&i2c_bus->i2c_adap, fe1->dvb.frontend);
> +			/* we're done, so clear fe1 pointer */
> +			fe1 = NULL;
> +			break;
> +		}
> +		break;
>   	case CX23885_BOARD_TEVII_S470:
>   		i2c_bus = &dev->i2c_bus[1];
>
> diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
> index 7875dfb..8a49e7c 100644
> --- a/drivers/media/pci/cx23885/cx23885-input.c
> +++ b/drivers/media/pci/cx23885/cx23885-input.c
> @@ -90,6 +90,8 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
>   	case CX23885_BOARD_TEVII_S470:
>   	case CX23885_BOARD_HAUPPAUGE_HVR1250:
>   	case CX23885_BOARD_MYGICA_X8507:
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
>   		/*
>   		 * The only boards we handle right now.  However other boards
>   		 * using the CX2388x integrated IR controller should be similar
> @@ -168,6 +170,8 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
>   		break;
>   	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
>   	case CX23885_BOARD_TEVII_S470:
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
>   		/*
>   		 * The IR controller on this board only returns pulse widths.
>   		 * Any other mode setting will fail to set up the device.
> @@ -298,6 +302,14 @@ int cx23885_input_init(struct cx23885_dev *dev)
>   		/* A guess at the remote */
>   		rc_map = RC_MAP_TOTAL_MEDIA_IN_HAND_02;
>   		break;
> +	case CX23885_BOARD_TBS_6980:
> +	case CX23885_BOARD_TBS_6981:
> +		/* Integrated CX23885 IR controller */
> +		driver_type = RC_DRIVER_IR_RAW;
> +		allowed_protos = RC_BIT_ALL;
> +		/* A guess at the remote */
> +		rc_map = RC_MAP_TBS_NEC;
> +		break;
>   	default:
>   		return -ENODEV;
>   	}
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index 5687d3f..ebcc63e 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -93,6 +93,8 @@
>   #define CX23885_BOARD_PROF_8000                37
>   #define CX23885_BOARD_HAUPPAUGE_HVR4400        38
>   #define CX23885_BOARD_AVERMEDIA_HC81R          39
> +#define CX23885_BOARD_TBS_6981                 40
> +#define CX23885_BOARD_TBS_6980                 41
>
>   #define GPIO_0 0x00000001
>   #define GPIO_1 0x00000002
>


-- 
http://palosaari.fi/

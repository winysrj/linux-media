Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53123 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751054AbdAIQ7G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 11:59:06 -0500
Subject: Re: [PATCH] [media] cx231xx: Initial support Evromedia USB Full
 Hybrid Full HD
To: Oleh Kravchenko <oleg@kaa.org.ua>, linux-media@vger.kernel.org,
        hverkuil@xs4all.nl
References: <20170109152310.22161-1-oleg@kaa.org.ua>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <135491db-a8e8-802d-d533-57b18d7725d4@iki.fi>
Date: Mon, 9 Jan 2017 18:59:03 +0200
MIME-Version: 1.0
In-Reply-To: <20170109152310.22161-1-oleg@kaa.org.ua>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/09/2017 05:23 PM, Oleh Kravchenko wrote:
> This patch provide only digital support.
>
> The device is based on Si2168 30-demodulator,
> Si2158-20 tuner and CX23102-11Z chipset;
> USB id: 1b80:d3b2.
>
> Status:
> - DVB-T2 works fine;
> - Composite and SVideo works fine;
> - Analog not implemented.
>
> Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
> Tested-by: Oleh Kravchenko <oleg@kaa.org.ua>
> ---
>  drivers/media/usb/cx231xx/Kconfig         |  1 +
>  drivers/media/usb/cx231xx/cx231xx-cards.c | 29 +++++++++++++
>  drivers/media/usb/cx231xx/cx231xx-dvb.c   | 71 +++++++++++++++++++++++++++++++
>  drivers/media/usb/cx231xx/cx231xx-i2c.c   | 37 ++++++++++++++++
>  drivers/media/usb/cx231xx/cx231xx.h       |  1 +
>  5 files changed, 139 insertions(+)
>
> diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
> index 0cced3e..58de80b 100644
> --- a/drivers/media/usb/cx231xx/Kconfig
> +++ b/drivers/media/usb/cx231xx/Kconfig
> @@ -50,6 +50,7 @@ config VIDEO_CX231XX_DVB
>  	select DVB_LGDT3306A if MEDIA_SUBDRV_AUTOSELECT
>  	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
>  	select DVB_SI2165 if MEDIA_SUBDRV_AUTOSELECT
> +	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
>  	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
>
>  	---help---
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index 36bc254..9b1df5a 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -841,6 +841,33 @@ struct cx231xx_board cx231xx_boards[] = {
>  			.gpio = NULL,
>  		} },
>  	},
> +	[CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD] = {
> +		.name = "Evromedia USB Full Hybrid Full HD",
> +		.tuner_type = TUNER_ABSENT,
> +		.demod_addr = 0xc8 >> 1,
> +		.demod_i2c_master = I2C_1_MUX_3,
> +		.has_dvb = 1,
> +		.ir_i2c_master = I2C_0,
> +		.norm = V4L2_STD_PAL,
> +		.output_mode = OUT_MODE_VIP11,
> +		.tuner_addr = 0xc0 >> 1,

These "8-bit" I2C addresses looks funny, but if that's used by cx231xx 
driver then leave...


> +		.tuner_i2c_master = I2C_2,
> +		.input = {{
> +			.type = CX231XX_VMUX_TELEVISION,
> +			.vmux = 0,
> +			.amux = CX231XX_AMUX_VIDEO,
> +		}, {
> +			.type = CX231XX_VMUX_COMPOSITE1,
> +			.vmux = CX231XX_VIN_2_1,
> +			.amux = CX231XX_AMUX_LINE_IN,
> +		}, {
> +			.type = CX231XX_VMUX_SVIDEO,
> +			.vmux = CX231XX_VIN_1_1 |
> +				(CX231XX_VIN_1_2 << 8) |
> +				CX25840_SVIDEO_ON,
> +			.amux = CX231XX_AMUX_LINE_IN,
> +		} },
> +	},
>  };
>  const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
>
> @@ -908,6 +935,8 @@ struct usb_device_id cx231xx_id_table[] = {
>  	 .driver_info = CX231XX_BOARD_OTG102},
>  	{USB_DEVICE(USB_VID_TERRATEC, 0x00a6),
>  	 .driver_info = CX231XX_BOARD_TERRATEC_GRABBY},
> +	{USB_DEVICE(0x1b80, 0xd3b2),
> +	.driver_info = CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD},
>  	{},
>  };
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
> index 1417515..08472a3 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
> @@ -33,6 +33,7 @@
>  #include "s5h1411.h"
>  #include "lgdt3305.h"
>  #include "si2165.h"
> +#include "si2168.h"
>  #include "mb86a20s.h"
>  #include "si2157.h"
>  #include "lgdt3306a.h"
> @@ -949,6 +950,76 @@ static int dvb_init(struct cx231xx *dev)
>  			   &pv_tda18271_config);
>  		break;
>
> +	case CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD:
> +	{
> +		struct si2157_config si2157_config = {};
> +		struct si2168_config si2168_config = {};
> +		struct i2c_board_info info = {};
> +		struct i2c_client *client;
> +		struct i2c_adapter *adapter;
> +
> +		/* attach demodulator chip */
> +		si2168_config.ts_mode = SI2168_TS_SERIAL; /* from *.inf file */
> +		si2168_config.fe = &dev->dvb->frontend;
> +		si2168_config.i2c_adapter = &adapter;
> +		si2168_config.ts_clock_inv = true;
> +
> +		strlcpy(info.type, "si2168", info.type);
> +		info.addr = dev->board.demod_addr;
> +		info.platform_data = &si2168_config;
> +
> +		request_module(info.type);
> +		client = i2c_new_device(demod_i2c, &info);
> +
> +		if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend == NULL) {

No need to check frontend here, or at least I cannot see why it should? 
Does the cx231xx initialize with some special value before calling 
si2168 probe - which will set it? client and driver will be null in case 
si2168 probe fails. Also, frontend pointer is not set if si2168 probe fails.

> +			dev_err(dev->dev, "Failed to attach Si2168 front end\n");
> +			result = -EINVAL;
> +			goto out_free;
> +		}
> +
> +		if (!try_module_get(client->dev.driver->owner)) {
> +			i2c_unregister_device(client);
> +			result = -ENODEV;
> +			goto out_free;
> +		}
> +
> +		dvb->i2c_client_demod = client;
> +		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;

si2168 does not use nor set i2c_gate_ctrl callback. No need to nullify 
it in any case.

> +		dvb->frontend->callback = cx231xx_tuner_callback;
> +
> +		/* attach tuner chip */
> +		si2157_config.fe = dev->dvb->frontend;
> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
> +		si2157_config.mdev = dev->media_dev;
> +#endif
> +		si2157_config.if_port = 1;
> +		si2157_config.inversion = false;
> +
> +		memset(&info, 0, sizeof(info));
> +		strlcpy(info.type, "si2157", info.type);
> +		info.addr = dev->board.tuner_addr;
> +		info.platform_data = &si2157_config;
> +
> +		request_module("si2157");
> +		client = i2c_new_device(tuner_i2c, &info);
> +
> +		if (client == NULL || client->dev.driver == NULL) {
> +			dvb_frontend_detach(dev->dvb->frontend);
> +			result = -ENODEV;
> +			goto out_free;
> +		}

Does this error handling work? Have you tested it? I suspect it will 
not. You should likely decrease si2168 module reference counter and then 
unregister si2168 driver.

> +
> +		if (!try_module_get(client->dev.driver->owner)) {
> +			i2c_unregister_device(client);
> +			dvb_frontend_detach(dev->dvb->frontend);
> +			result = -ENODEV;
> +			goto out_free;
> +		}
> +
> +		dev->cx231xx_reset_analog_tuner = NULL;
> +		dev->dvb->i2c_client_tuner = client;
> +		break;
> +	}
>  	default:
>  		dev_err(dev->dev,
>  			"%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> index 35e9acf..60412ec 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> @@ -171,6 +171,43 @@ static int cx231xx_i2c_send_bytes(struct i2c_adapter *i2c_adap,
>  		bus->i2c_nostop = 0;
>  		bus->i2c_reserve = 0;
>
> +	} else if (dev->model == CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD
> +		&& msg->addr == dev->tuner_addr
> +		&& msg->len > 4) {
> +		/* special case for Evromedia USB Full Hybrid Full HD tuner chip */
> +		size = msg->len;
> +		saddr_len = 1;
> +
> +		/* adjust the length to correct length */
> +		size -= saddr_len;
> +
> +		buf_ptr = (u8*)(msg->buf + 1);
> +
> +		do {
> +			/* prepare xfer_data struct */
> +			req_data.dev_addr = msg->addr;
> +			req_data.direction = msg->flags;
> +			req_data.saddr_len = saddr_len;
> +			req_data.saddr_dat = msg->buf[0];
> +			req_data.buf_size = size > 4 ? 4 : size;
> +			req_data.p_buffer = (u8*)(buf_ptr + loop * 4);
> +
> +			bus->i2c_nostop = (size > 4) ? 1 : 0;
> +			bus->i2c_reserve = (loop == 0) ? 0 : 1;
> +
> +			/* usb send command */
> +			status = dev->cx231xx_send_usb_command(bus, &req_data);
> +			loop++;
> +
> +			if (size >= 4) {
> +				size -= 4;
> +			} else {
> +				size = 0;
> +			}
> +		} while (size > 0);
> +
> +		bus->i2c_nostop = 0;
> +		bus->i2c_reserve = 0;

I don't follow (and I looked only that patch, not whole cx231xx driver) 
why this I2C adapter logic is limited to that device only. si2168 and 
si2157 drivers applies just standard multibyte I2C read and write 
operations - no write+read op used at all.

These I2C adapter routines should be same for every device. Maybe 
original logic is somehow wrong and it should be fixed instead of adding 
new device specific logic.


>  	} else {		/* regular case */
>
>  		/* prepare xfer_data struct */
> diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
> index 90c8676..d9792ea 100644
> --- a/drivers/media/usb/cx231xx/cx231xx.h
> +++ b/drivers/media/usb/cx231xx/cx231xx.h
> @@ -78,6 +78,7 @@
>  #define CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx 20
>  #define CX231XX_BOARD_HAUPPAUGE_955Q 21
>  #define CX231XX_BOARD_TERRATEC_GRABBY 22
> +#define CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD 23
>
>  /* Limits minimum and default number of buffers */
>  #define CX231XX_MIN_BUF                 4
>

regards
Antti

-- 
http://palosaari.fi/

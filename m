Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46512 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762001Ab2EQOuH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 10:50:07 -0400
Message-ID: <4FB5101D.8040909@iki.fi>
Date: Thu, 17 May 2012 17:50:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: pomidorabelisima@gmail.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: Re: [PATCH v4 5/5] rtl28xxu: support Terratec Noxon DAB/DAB+ stick
References: <1> <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com> <1337206420-23810-6-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1337206420-23810-6-git-send-email-thomas.mair86@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.05.2012 01:13, Thomas Mair wrote:
> Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>
> Signed-off-by: Thomas Mair<thomas.mair86@googlemail.com>

Acked-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
>   drivers/media/dvb/dvb-usb/rtl28xxu.c    |   27 ++++++++++++++++++++++++++-
>   2 files changed, 27 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> index b0a86e9..95c9c14 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> @@ -244,6 +244,7 @@
>   #define USB_PID_TERRATEC_H7_2				0x10a3
>   #define USB_PID_TERRATEC_T3				0x10a0
>   #define USB_PID_TERRATEC_T5				0x10a1
> +#define USB_PID_NOXON_DAB_STICK				0x00b3
>   #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
>   #define USB_PID_PINNACLE_PCTV2000E			0x022c
>   #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
> diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
> index 9056d28..f10cac2 100644
> --- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
> +++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
> @@ -29,6 +29,7 @@
>   #include "mt2060.h"
>   #include "mxl5005s.h"
>   #include "fc0012.h"
> +#include "fc0013.h"

Aaah, it is coming here. You were introducing some FC0013 earlier which 
I mentioned (that Kconfig dependency). Correct place for FC0013 stuff is 
that patch.

>
>   /* debug */
>   static int dvb_usb_rtl28xxu_debug;
> @@ -388,6 +389,12 @@ static struct rtl2832_config rtl28xxu_rtl2832_fc0012_config = {
>   	.tuner = TUNER_RTL2832_FC0012
>   };
>
> +static struct rtl2832_config rtl28xxu_rtl2832_fc0013_config = {
> +	.i2c_addr = 0x10, /* 0x20 */
> +	.xtal = 28800000,
> +	.if_dvbt = 0,
> +	.tuner = TUNER_RTL2832_FC0013
> +};
>
>   static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
>   		int cmd, int arg)
> @@ -553,6 +560,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
>   	ret = rtl28xxu_ctrl_msg(adap->dev,&req_fc0013);
>   	if (ret == 0&&  buf[0] == 0xa3) {
>   		priv->tuner = TUNER_RTL2832_FC0013;
> +		rtl2832_config =&rtl28xxu_rtl2832_fc0013_config;
>   		info("%s: FC0013 tuner found", __func__);
>   		goto found;
>   	}
> @@ -750,6 +758,14 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>   				fe->ops.tuner_ops.get_rf_strength;
>   		return 0;
>   		break;
> +	case TUNER_RTL2832_FC0013:
> +		fe = dvb_attach(fc0013_attach, adap->fe_adap[0].fe,
> +			&adap->dev->i2c_adap, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
> +
> +		/* fc0013 also supports signal strength reading */
> +		adap->fe_adap[0].fe->ops.read_signal_strength = adap->fe_adap[0]
> +			.fe->ops.tuner_ops.get_rf_strength;
> +		return 0;
>   	default:
>   		fe = NULL;
>   		err("unknown tuner=%d", priv->tuner);
> @@ -1136,6 +1152,7 @@ enum rtl28xxu_usb_table_entry {
>   	RTL2831U_14AA_0161,
>   	RTL2832U_0CCD_00A9,
>   	RTL2832U_1F4D_B803,
> +	RTL2832U_0CCD_00B3,
>   };
>
>   static struct usb_device_id rtl28xxu_table[] = {
> @@ -1152,6 +1169,8 @@ static struct usb_device_id rtl28xxu_table[] = {
>   		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1)},
>   	[RTL2832U_1F4D_B803] = {
>   		USB_DEVICE(USB_VID_GTEK, USB_PID_GTEK)},
> +	[RTL2832U_0CCD_00B3] = {
> +		USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK)},
>   	{} /* terminating entry */
>   };
>
> @@ -1265,7 +1284,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
>
>   		.i2c_algo =&rtl28xxu_i2c_algo,
>
> -		.num_device_descs = 2,
> +		.num_device_descs = 3,
>   		.devices = {
>   			{
>   				.name = "Terratec Cinergy T Stick Black",
> @@ -1279,6 +1298,12 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
>   					&rtl28xxu_table[RTL2832U_1F4D_B803],
>   				},
>   			},
> +			{
> +				.name = "NOXON DAB/DAB+ USB dongle",
> +				.warm_ids = {
> +					&rtl28xxu_table[RTL2832U_0CCD_00B3],
> +				},
> +			},
>   		}
>   	},
>


-- 
http://palosaari.fi/

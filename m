Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50027 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbbLTDgt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2015 22:36:49 -0500
Subject: Re: [PATCH 3/3] rtl28xxu: change Astrometa DVB-T2 to always use
 hardware pid filters
To: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org
References: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
 <1448763016-10527-3-git-send-email-benjamin@southpole.se>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <5676224F.3030803@iki.fi>
Date: Sun, 20 Dec 2015 05:36:47 +0200
MIME-Version: 1.0
In-Reply-To: <1448763016-10527-3-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
I did some testing and I cannot see reason to force hw pid filter for 
that device. I assume you somehow think it does not work without 
filtering, but I think it does.

I tested streaming with mn88472 demod DVB-C and DVB-T2 modes without 
stream errors. DVB-T2 (live) datarate 45Mbps and DVB-C (modulator) 
datarate 50Mbps. Maximum DVB-T2 (8MHz) datarate is 50Mbps - in a real 
life it is bit less.

DVB-C
1fff 19870.47 p/s 29184.8 Kbps 207966 KB
TOT 34313.26 p/s 50397.6 Kbps 359127 KB

DVB-T2
1fff 2589.99 p/s 3804.0 Kbps 21400 KB
TOT 30346.18 p/s 44570.9 Kbps 250745 KB

So point me the reason hw PID filters need to be forced.

regards
Antti


On 11/29/2015 04:10 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 35 ++++++++++++++++++++++++++++++++-
>   1 file changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 5a503a6..74201ec 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1848,6 +1848,39 @@ static const struct dvb_usb_device_properties rtl28xxu_props = {
>   	},
>   };
>
> +static const struct dvb_usb_device_properties rtl28xxp_props = {
> +	.driver_name = KBUILD_MODNAME,
> +	.owner = THIS_MODULE,
> +	.adapter_nr = adapter_nr,
> +	.size_of_priv = sizeof(struct rtl28xxu_dev),
> +
> +	.identify_state = rtl28xxu_identify_state,
> +	.power_ctrl = rtl28xxu_power_ctrl,
> +	.frontend_ctrl = rtl28xxu_frontend_ctrl,
> +	.i2c_algo = &rtl28xxu_i2c_algo,
> +	.read_config = rtl28xxu_read_config,
> +	.frontend_attach = rtl28xxu_frontend_attach,
> +	.frontend_detach = rtl28xxu_frontend_detach,
> +	.tuner_attach = rtl28xxu_tuner_attach,
> +	.tuner_detach = rtl28xxu_tuner_detach,
> +	.init = rtl28xxu_init,
> +
> +	.get_rc_config = rtl28xxu_get_rc_config,
> +	.num_adapters = 1,
> +	.adapter = {
> +		{
> +			.caps = DVB_USB_ADAP_NEED_PID_FILTERING |
> +				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
> +
> +			.pid_filter_count = 32,
> +			.pid_filter_ctrl = rtl28xxu_pid_filter_ctrl,
> +			.pid_filter = rtl28xxu_pid_filter,
> +
> +			.stream = DVB_USB_STREAM_BULK(0x81, 6, 8 * 512),
> +		},
> +	},
> +};
> +
>   static const struct usb_device_id rtl28xxu_id_table[] = {
>   	/* RTL2831U devices: */
>   	{ DVB_USB_DEVICE(USB_VID_REALTEK, USB_PID_REALTEK_RTL2831U,
> @@ -1919,7 +1952,7 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>
>   	/* RTL2832P devices: */
>   	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
> -		&rtl28xxu_props, "Astrometa DVB-T2", NULL) },
> +		&rtl28xxp_props, "Astrometa DVB-T2", NULL) },
>   	{ DVB_USB_DEVICE(0x5654, 0xca42,
>   		&rtl28xxu_props, "GoTView MasterHD 3", NULL) },
>   	{ }
>

-- 
http://palosaari.fi/

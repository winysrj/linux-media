Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-d03.mx.aol.com ([205.188.109.200]:60044 "EHLO
	omr-d03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaCJILd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 04:11:33 -0400
Received: from mtaout-mac01.mx.aol.com (mtaout-mac01.mx.aol.com [172.26.222.205])
	by omr-d03.mx.aol.com (Outbound Mail Relay) with ESMTP id D4914701FA4C2
	for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 04:11:32 -0400 (EDT)
Received: from [192.168.10.62] (p17087-ipngn5502marunouchi.tokyo.ocn.ne.jp [153.160.16.87])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mtaout-mac01.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 2C7783800009C
	for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 04:11:31 -0400 (EDT)
Message-ID: <531D73BD.6030602@aim.com>
Date: Mon, 10 Mar 2014 17:11:41 +0900
From: Sat <sattnag@aim.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Siano: smsusb - Add a device id for PX-S1UD
References: <52F89FB9.7080004@aim.com>
In-Reply-To: <52F89FB9.7080004@aim.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Could anyone move forward with this patch?
Or is there anything I should do more?
Please advise.

Thanks,
Satoshi

(2014/02/10 18:45), Satoshi Nagahama wrote:
> Add a device id to support for PX-S1UD (PLEX ISDB-T usb dongle) which
> has sms2270.
>
> Signed-off-by: Satoshi Nagahama <sattnag@aim.com>
> ---
>   drivers/media/usb/siano/smsusb.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/siano/smsusb.c
> b/drivers/media/usb/siano/smsusb.c
> index 05bd91a..1836a41 100644
> --- a/drivers/media/usb/siano/smsusb.c
> +++ b/drivers/media/usb/siano/smsusb.c
> @@ -653,6 +653,8 @@ static const struct usb_device_id smsusb_id_table[] = {
>   		.driver_info = SMS1XXX_BOARD_ZTE_DVB_DATA_CARD },
>   	{ USB_DEVICE(0x19D2, 0x0078),
>   		.driver_info = SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD },
> +	{ USB_DEVICE(0x3275, 0x0080),
> +		.driver_info = SMS1XXX_BOARD_SIANO_RIO },
>   	{ } /* Terminating entry */
>   	};
>


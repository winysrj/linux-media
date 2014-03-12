Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m02.mx.aol.com ([64.12.143.76]:50144 "EHLO
	omr-m02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbaCLGiU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 02:38:20 -0400
Received: from mtaout-mba01.mx.aol.com (mtaout-mba01.mx.aol.com [172.26.133.109])
	by omr-m02.mx.aol.com (Outbound Mail Relay) with ESMTP id 8805F7020B3CD
	for <linux-media@vger.kernel.org>; Wed, 12 Mar 2014 02:38:19 -0400 (EDT)
Received: from [192.168.10.62] (p17087-ipngn5502marunouchi.tokyo.ocn.ne.jp [153.160.16.87])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mtaout-mba01.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id E1DF43800008C
	for <linux-media@vger.kernel.org>; Wed, 12 Mar 2014 02:38:18 -0400 (EDT)
Message-ID: <532000D7.7020209@aim.com>
Date: Wed, 12 Mar 2014 15:38:15 +0900
From: Sat <sattnag@aim.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] Siano: smsusb - Add a device
 id for PX-S1UD
References: <E1WNONv-0000Nm-Ua@www.linuxtv.org>
In-Reply-To: <E1WNONv-0000Nm-Ua@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for the update, Mauro.
I didn't know how to check the status, now I get it :-)

Thanks,
Satoshi

(2014/03/12 0:12), Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] Siano: smsusb - Add a device id for PX-S1UD
> Author:  Satoshi Nagahama <sattnag@aim.com>
> Date:    Mon Feb 10 06:45:29 2014 -0300
> 
> Add a device id to support for PX-S1UD (PLEX ISDB-T usb dongle) which
> has sms2270.
> 
> Signed-off-by: Satoshi Nagahama <sattnag@aim.com>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
>   drivers/media/usb/siano/smsusb.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=f61e2268a06c3ea7354a1f4b3d878bedb8b776b1
> 
> diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
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
> 


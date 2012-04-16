Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54415 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2DPEvG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 00:51:06 -0400
Message-ID: <4F8BC15A.3010104@Berthereau.net>
Date: Mon, 16 Apr 2012 08:51:06 +0200
From: Daniel <daniel.videodvb@berthereau.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Gianluca Gennari <gennarone@gmail.com>
Subject: Re: [PATCH] dib0700: add new USB PID for the Elgato EyeTV DTT stick
References: <4F891F54.6030802@Berthereau.net> <1334409247-32467-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1334409247-32467-1-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patch works fine, but the IR sensor doesn't seem to be enabled. 
It's not a problem, because the stick isn't sold with a remote control.

Sincerely,

Daniel


On 14/04/2012 15:14, Gianluca Gennari wrote:
> Reported working here:
> http://ubuntuforums.org/archive/index.php/t-1510188.html
> http://ubuntuforums.org/archive/index.php/t-1756828.html
> https://sites.google.com/site/slackwarestuff/home/elgato-eyetv
>
> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>
> ---
>   drivers/media/dvb/dvb-usb/dib0700_devices.c |    7 ++++++-
>   drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 +
>   2 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
> index f9e966a..510001d 100644
> --- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
> @@ -3569,6 +3569,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
>   	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE7090E) },
>   	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE7790E) },
>   /* 80 */{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE8096P) },
> +	{ USB_DEVICE(USB_VID_ELGATO,	USB_PID_ELGATO_EYETV_DTT_2) },
>   	{ 0 }		/* Terminating entry */
>   };
>   MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
> @@ -3832,7 +3833,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>   			},
>   		},
>
> -		.num_device_descs = 11,
> +		.num_device_descs = 12,
>   		.devices = {
>   			{   "DiBcom STK7070P reference design",
>   				{&dib0700_usb_id_table[15], NULL },
> @@ -3878,6 +3879,10 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>   				{&dib0700_usb_id_table[50], NULL },
>   				{ NULL },
>   			},
> +			{   "Elgato EyeTV DTT rev. 2",
> +				{&dib0700_usb_id_table[81], NULL },
> +				{ NULL },
> +			},
>   		},
>
>   		.rc.core = {
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> index 94d3f8a..2418e41 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> @@ -335,6 +335,7 @@
>   #define USB_PID_MYGICA_D689				0xd811
>   #define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
>   #define USB_PID_ELGATO_EYETV_DTT			0x0021
> +#define USB_PID_ELGATO_EYETV_DTT_2			0x003f
>   #define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020
>   #define USB_PID_ELGATO_EYETV_SAT			0x002a
>   #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000

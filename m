Return-path: <linux-media-owner@vger.kernel.org>
Received: from bonnie-vm4.ifh.de ([141.34.50.21]:40125 "EHLO smtp.ifh.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751259Ab0FAKZD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 06:25:03 -0400
Date: Tue, 1 Jun 2010 11:53:17 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: =?ISO-8859-15?Q?St=E9phane_Elmaleh?= <s_elmaleh@hotmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] support for medion dvb stick 1660:1921
In-Reply-To: <loom.20100531T003945-828@post.gmane.org>
Message-ID: <alpine.LRH.2.00.1006011150030.28355@pub2.ifh.de>
References: <loom.20100531T003945-828@post.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stephane,

On Sun, 30 May 2010, St?phane Elmaleh wrote:
> Hello,
> I'm not sure of doing this the right way since I'm not a programmer.

Thanks for submitting the patch.

> diff -r b576509ea6d2 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
> --- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Wed May 19 19:34:33
> 2010 -0300
> +++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Mon May 31 00:34:44
> 2010 +0200
> @@ -2083,6 +2083,7 @@
> 	{ USB_DEVICE(USB_VID_PCTV,	USB_PID_PINNACLE_PCTV282E) },
> 	{ USB_DEVICE(USB_VID_DIBCOM,	USB_PID_DIBCOM_STK7770P) },
> /* 60 */{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_XXS_2) },
> +	{ USB_DEVICE(USB_VID_MEDION,	USB_PID_MEDION_STICK_CTX_1921) },
> 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XPVR) },
> 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XP) },
> 	{ USB_DEVICE(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD) }

Could you please move your inserted line to the end of this PID/VID-table? 
How it is done now will change the indices used for all other 
PID/VID-entries which will break all the references to it.


> @@ -2606,10 +2607,14 @@
> 			},
> 		},
>
> -		.num_device_descs = 2,
> +		.num_device_descs = 3,
> 		.devices = {
> 			{   "DiBcom STK7770P reference design",
> 				{ &dib0700_usb_id_table[59], NULL },
> +				{ NULL },
> +			},
> +			{   "Medion Stick ctx 1921",
> +				{ &dib0700_usb_id_table[61], NULL },

If moved to the end of the table you have to adapt the 61 here to the 
real value.

Please resent the patch afterwards.

thanks,
Patrick.

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/

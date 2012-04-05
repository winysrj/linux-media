Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47155 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab2DEQUv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 12:20:51 -0400
Received: by eaaq12 with SMTP id q12so487538eaa.19
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2012 09:20:50 -0700 (PDT)
Message-ID: <4F7DC65F.7030007@gmail.com>
Date: Thu, 05 Apr 2012 18:20:47 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: pierigno <pierigno@gmail.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	m@bues.ch, hfvogt@gmx.net, mchehab@redhat.com
Subject: Re: [PATCH] af9035: add several new USB IDs
References: <1333540034-14002-1-git-send-email-gennarone@gmail.com> <4F7C3787.5020602@iki.fi> <4F7C4141.40004@gmail.com> <4F7C481A.2020203@iki.fi> <4F7C4C58.5050703@gmail.com> <CAN7fRVvX2gEWHAEAqqZ1Jbgx+atU8S_dXVc9Q83_o+-L69nq7g@mail.gmail.com> <CAN7fRVsGqUvmNkYbzmf5dKYjc_+n9T_3TTBp7Bawon3-awjfPQ@mail.gmail.com>
In-Reply-To: <CAN7fRVsGqUvmNkYbzmf5dKYjc_+n9T_3TTBp7Bawon3-awjfPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Pierangelo,
but there are still issues with your patch.
See in-line comments.

Il 05/04/2012 16:34, pierigno ha scritto:
> gosh!! I pasted the wrong patch, sorry for the noise, here it is (it
> should be applied against
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental):
> 
> 
> --- drivers/media/dvb/dvb-usb/af9035.c.origin	2012-04-05
> 15:31:55.431075058 +0200
> +++ drivers/media/dvb/dvb-usb/af9035.c	2012-04-05 15:26:44.483073976 +0200
> @@ -827,6 +827,7 @@ enum af9035_id_entry {
>  	AF9035_07CA_B835,
>  	AF9035_07CA_1867,
>  	AF9035_07CA_A867,
> +	AF9035_07CA_0825,

here you define AF9035_07CA_0825....

>  };
> 
>  static struct usb_device_id af9035_id[] = {
> @@ -844,6 +845,8 @@ static struct usb_device_id af9035_id[]
>  		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_1867)},
>  	[AF9035_07CA_A867] = {
>  		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A867)},
> +	[AF9035_07CA_0825] = {
> +		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_TWINSTAR)},
>  	{},
>  };
> 
> @@ -886,7 +889,7 @@ static struct dvb_usb_device_properties
> 
>  		.i2c_algo = &af9035_i2c_algo,
> 
> -		.num_device_descs = 4,
> +		.num_device_descs = 5,
>  		.devices = {
>  			{
>  				.name = "TerraTec Cinergy T Stick",
> @@ -911,6 +914,10 @@ static struct dvb_usb_device_properties
>  					&af9035_id[AF9035_07CA_1867],
>  					&af9035_id[AF9035_07CA_A867],
>  				},
> +			}, {
> +				.name = "AVerMedia Twinstar (0825)",
> +				.cold_ids = {
> +					&af9035_id[AF9035_07CA_0235],

... and here you use AF9035_07CA_0235!
Also, I think the name should be something like "AVerMedia Twinstar
(A825)" since Avermedia code names usually are "Axxx".


>  			},
>  		}
>  	},
> 
> --- drivers/media/dvb/dvb-usb/dvb-usb-ids.h.origin	2012-04-05
> 15:32:15.229075128 +0200
> +++ drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2012-04-05 15:27:22.775074099 +0200
> @@ -228,6 +228,7 @@
>  #define USB_PID_AVERMEDIA_B835				0xb835
>  #define USB_PID_AVERMEDIA_1867				0x1867
>  #define USB_PID_AVERMEDIA_A867				0xa867
> +#define USB_PID_AVERMEDIA_TWINSTAR			0x0825
>  #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
>  #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
> 
> 

Also, remember to put your "Signed-off-by" line on the patch.

Regards,
Gianluca

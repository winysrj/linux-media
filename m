Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48BBFFA9.8030602@linuxtv.org>
Date: Mon, 01 Sep 2008 10:43:53 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Finn Thain <fthain@telegraphics.com.au>
References: <Pine.LNX.4.64.0808291627340.21301@loopy.telegraphics.com.au>	<alpine.LRH.1.10.0808291157060.17297@pub3.ifh.de>	<Pine.LNX.4.64.0808292129330.21301@loopy.telegraphics.com.au>	<alpine.LRH.1.10.0808291356540.17297@pub3.ifh.de>
	<Pine.LNX.4.64.0809020025050.2229@loopy.telegraphics.com.au>
In-Reply-To: <Pine.LNX.4.64.0809020025050.2229@loopy.telegraphics.com.au>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [v4l-dvb-maintainer] [PATCH] Add support for the
 Gigabyte R8000-HT USB DVB-T adapter, take 2
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Finn Thain wrote:
> Add support for the Gigabyte R8000-HT USB DVB-T adapter.
>
> Thanks to Ilia Penev for the tip-off that this device is much the same as 
> (identical to?) a Terratec Cinergy HT USB XE, and for the firmware hints: 
> http://linuxtv.org/pipermail/linux-dvb/2008-August/028108.html
>
> DVB functionality tested OK with xine using the usual dib0700 firmware.
>
> This diff is based on the latest latest linuxtv.org v4l-dvb mercurial 
> repo.
>
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>   

Your patch looks fine, but I have one comment, please see below:


> --- linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-09-01 22:33:12.000000000 +1000
> +++ linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-09-01 22:37:32.000000000 +1000
> @@ -1119,6 +1119,7 @@
>  	{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
>  /* 35 */{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009) },
>  	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500_3) },
> +	{ USB_DEVICE(USB_VID_GIGABYTE,  USB_PID_GIGABYTE_U8000) },
>  	{ 0 }		/* Terminating entry */
>  };
>  MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
> @@ -1408,8 +1409,12 @@
>  			},
>  		},
>  
> -		.num_device_descs = 3,
> +		.num_device_descs = 4,
>  		.devices = {
> +			{   "Gigabyte U8000-RH",
> +				{ &dib0700_usb_id_table[37], NULL },
> +				{ NULL },
> +			},
>  			{   "Terratec Cinergy HT USB XE",
>  				{ &dib0700_usb_id_table[27], NULL },
>  				{ NULL },
>   

You've added your new entry to be the first listed in the .devices section.

We usually prefer to add new entries below those already existing.

Would you regenerate this again with the new device listed after the
other three preexisting ones?


> --- linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-09-01 22:33:12.000000000 +1000
> +++ linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-09-01 22:37:32.000000000 +1000
> @@ -205,6 +205,7 @@
>  #define USB_PID_LIFEVIEW_TV_WALKER_TWIN_COLD		0x0514
>  #define USB_PID_LIFEVIEW_TV_WALKER_TWIN_WARM		0x0513
>  #define USB_PID_GIGABYTE_U7000				0x7001
> +#define USB_PID_GIGABYTE_U8000				0x7002
>  #define USB_PID_ASUS_U3000				0x171f
>  #define USB_PID_ASUS_U3100				0x173f
>  #define USB_PID_YUAN_EC372S				0x1edc
>
>   
Cheers,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

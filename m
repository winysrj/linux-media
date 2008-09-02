Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Tue, 2 Sep 2008 09:58:42 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Finn Thain <fthain@telegraphics.com.au>
In-Reply-To: <Pine.LNX.4.64.0809021442280.22720@loopy.telegraphics.com.au>
Message-ID: <alpine.LRH.1.10.0809020958110.3828@pub6.ifh.de>
References: <Pine.LNX.4.64.0808291627340.21301@loopy.telegraphics.com.au>
	<alpine.LRH.1.10.0808291157060.17297@pub3.ifh.de>
	<Pine.LNX.4.64.0808292129330.21301@loopy.telegraphics.com.au>
	<alpine.LRH.1.10.0808291356540.17297@pub3.ifh.de>
	<Pine.LNX.4.64.0809020025050.2229@loopy.telegraphics.com.au>
	<48BBFFA9.8030602@linuxtv.org>
	<Pine.LNX.4.64.0809021442280.22720@loopy.telegraphics.com.au>
MIME-Version: 1.0
Cc: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add support for the Gigabyte R8000-HT USB
 DVB-T adapter, take 3
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

Hi Finn,

thanks for your patch - I will merge it later that day.

Patrick.

On Tue, 2 Sep 2008, Finn Thain wrote:

>
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
> diff -r 6032ecd6ad7e linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
> --- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Sat Aug 30 11:07:04 2008 -0300
> +++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Tue Sep 02 14:40:12 2008 +1000
> @@ -1119,6 +1119,7 @@ struct usb_device_id dib0700_usb_id_tabl
> 	{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
> /* 35 */{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009) },
> 	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500_3) },
> +	{ USB_DEVICE(USB_VID_GIGABYTE,  USB_PID_GIGABYTE_U8000) },
> 	{ 0 }		/* Terminating entry */
> };
> MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
> @@ -1408,7 +1409,7 @@ struct dvb_usb_device_properties dib0700
> 			},
> 		},
>
> -		.num_device_descs = 3,
> +		.num_device_descs = 4,
> 		.devices = {
> 			{   "Terratec Cinergy HT USB XE",
> 				{ &dib0700_usb_id_table[27], NULL },
> @@ -1422,6 +1423,10 @@ struct dvb_usb_device_properties dib0700
> 				{ &dib0700_usb_id_table[32], NULL },
> 				{ NULL },
> 			},
> +			{   "Gigabyte U8000-RH",
> +				{ &dib0700_usb_id_table[37], NULL },
> +				{ NULL },
> +			},
> 		},
> 		.rc_interval      = DEFAULT_RC_INTERVAL,
> 		.rc_key_map       = dib0700_rc_keys,
> diff -r 6032ecd6ad7e linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> --- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sat Aug 30 11:07:04 2008 -0300
> +++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Tue Sep 02 14:40:12 2008 +1000
> @@ -205,6 +205,7 @@
> #define USB_PID_LIFEVIEW_TV_WALKER_TWIN_COLD		0x0514
> #define USB_PID_LIFEVIEW_TV_WALKER_TWIN_WARM		0x0513
> #define USB_PID_GIGABYTE_U7000				0x7001
> +#define USB_PID_GIGABYTE_U8000				0x7002
> #define USB_PID_ASUS_U3000				0x171f
> #define USB_PID_ASUS_U3100				0x173f
> #define USB_PID_YUAN_EC372S				0x1edc
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

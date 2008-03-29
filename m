Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from omta03ps.mx.bigpond.com ([144.140.82.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ptay1685@Bigpond.net.au>) id 1JfP1a-0001kZ-5p
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 01:34:29 +0100
Received: from oaamta03ps.mx.bigpond.com ([58.172.153.185])
	by omta03ps.mx.bigpond.com with ESMTP id
	<20080329003335.NZIG27747.omta03ps.mx.bigpond.com@oaamta03ps.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Sat, 29 Mar 2008 00:33:35 +0000
Message-ID: <012f01c89134$85561fc0$6e00a8c0@barny1e59e583e>
From: "ptay1685" <ptay1685@Bigpond.net.au>
To: "Antti Palosaari" <crope@iki.fi>,
	"Patrick Boettcher" <patrick.boettcher@desy.de>,
	"John" <bitumen.surfer@gmail.com>
References: <e44ae5e0712172128p4e1428aao493d0a1725b6fcd3@mail.gmail.com>
	<47EC3BD4.3070307@iki.fi>
Date: Sat, 29 Mar 2008 11:31:22 +1100
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org, k.bannister@ieee.org
Subject: Re: [linux-dvb] [PATCH] new USB-ID for Leadtek Winfast DTV was: Re:
	New Leadtek Winfast DTV Dongle working - with mods but	no RC
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

Didnt work for me, sorry. Device still not detected.

Probably me not getting the sources correctly or something - i followed the 
directions on linuxtv.org website.

Regards,

Phil T.

----- Original Message ----- 
From: "Antti Palosaari" <crope@iki.fi>
To: "Patrick Boettcher" <patrick.boettcher@desy.de>; "ptay1685" 
<ptay1685@Bigpond.net.au>; "John" <bitumen.surfer@gmail.com>
Cc: <linux-dvb@linuxtv.org>; <k.bannister@ieee.org>
Sent: Friday, March 28, 2008 11:29 AM
Subject: [linux-dvb] [PATCH] new USB-ID for Leadtek Winfast DTV was: Re: New 
Leadtek Winfast DTV Dongle working - with mods but no RC


> hello
> USB-ID for Leadtek Winfast DTV
>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
>
> Patch done against current development-tree at
> http://linuxtv.org/hg/~pb/v4l-dvb/
> Patrick, could you check and add it?
>
> Could ptay1685 or John or some other test this?
>
> Keith Bannister wrote:
>> I hopped onto the IRC channel and crope` (thanks mate) advised me to
>> change dvb-usb-ids.h to
>>
>> #define USB_PID_WINFAST_DTV_DONGLE_STK7700P        0x6f01
>
> Sorry, I forgot make patch earlier...
>
> regards
> Antti
> -- 
> http://palosaari.fi/
>


--------------------------------------------------------------------------------


> diff -r 3d252c252869 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
> --- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Sat Mar 22 
> 23:19:38 2008 +0100
> +++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c Fri Mar 28 
> 02:15:01 2008 +0200
> @@ -1115,6 +1115,8 @@ struct usb_device_id dib0700_usb_id_tabl
>  { USB_DEVICE(USB_VID_YUAN, USB_PID_YUAN_EC372S) },
>  { USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_HT_EXPRESS) },
>  { USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_XXS) },
> + { USB_DEVICE(USB_VID_LEADTEK,
> + USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
>  { 0 } /* Terminating entry */
> };
> MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
> @@ -1179,7 +1181,8 @@ struct dvb_usb_device_properties dib0700
>  { NULL },
>  },
>  {   "Leadtek Winfast DTV Dongle (STK7700P based)",
> - { &dib0700_usb_id_table[8], NULL },
> + { &dib0700_usb_id_table[8],
> +   &dib0700_usb_id_table[34], NULL },
>  { NULL },
>  },
>  {   "AVerMedia AVerTV DVB-T Express",
> diff -r 3d252c252869 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> --- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h Sat Mar 22 23:19:38 
> 2008 +0100
> +++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h Fri Mar 28 02:15:01 
> 2008 +0200
> @@ -180,6 +180,7 @@
> #define USB_PID_WINFAST_DTV_DONGLE_COLD 0x6025
> #define USB_PID_WINFAST_DTV_DONGLE_WARM 0x6026
> #define USB_PID_WINFAST_DTV_DONGLE_STK7700P 0x6f00
> +#define USB_PID_WINFAST_DTV_DONGLE_STK7700P_2 0x6f01
> #define USB_PID_GENPIX_8PSK_REV_1_COLD 0x0200
> #define USB_PID_GENPIX_8PSK_REV_1_WARM 0x0201
> #define USB_PID_GENPIX_8PSK_REV_2 0x0202
>


--------------------------------------------------------------------------------


> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab2AFNMb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 08:12:31 -0500
Message-ID: <4F06F32D.2010002@redhat.com>
Date: Fri, 06 Jan 2012 11:12:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: linux-media@vger.kernel.org, Eduard Bloch <blade@debian.org>,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: Re: Add support for new Terratec DVB USB IDs
References: <20111222215356.GA4499@rotes76.wohnheim.uni-kl.de> <20111222234446.GB10497@elie.Belkin>
In-Reply-To: <20111222234446.GB10497@elie.Belkin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22-12-2011 21:44, Jonathan Nieder wrote:
> Hi,
> 
> Eduard Bloch wrote[1]:
> 
>> current revision of the Cinergy S2 USB box from Terratec seems to use
>> another USB-IDs. The manufacturer provides patches at
>> http://linux.terratec.de/tv_en.html and it seems like the only
>> difference is really just the new ID and a couple of init flag changes.
>>
>> Their patch is not exactly for the linux-3.x tree but for the current
>> s2-liplianin drivers, OTOH they still look similar enough and porting
>> the patch was straight-forward. I also added the patch for Terratec S7
>> which is not tested yet but shouldn't do any harm.
> [...]
> 
> Eduard, meet the LinuxTV project.  linux-media folks, meet Eduard.
> Patch follows.
> 
> Eduard: may we have your sign-off?  Please see
> Documentation/SubmittingPatches, section 12 "Sign your work" for what
> this means.

Eduard/Jonathan,

Please provide your Signed-off-by: your name <your@email>

thanks!
Mauro

> 
> My only other hint is that it would be better to add the new device
> IDs in some logical place in the list near the older ones, instead of
> at the end where it is more likely to collide with other patches in
> flight.  So if rerolling the patches, it might be useful to do that.
> 
> -- >8 --
> From: Eduard Bloch <blade@debian.org>
> Date: Thu, 22 Dec 2011 19:46:54 +0100
> Subject: new device IDs used by some Terratec USB devices
> 
> The changes are extracted from ID patches in tarballs at
> http://linux.terratec.de/tv_en.html (for S7 and Cinergy S2 USB HD), and
> slightly modified to match the state of s2-liplianin tree used in linux-3.x so
> far.
> ---
> Thanks for your work,
> Jonathan
> 
> [1] http://bugs.debian.org/653026
> 
> diff -urd linux-2.6-3.1.5.debian/drivers/media/dvb/dvb-usb/az6027.c linux-2.6-3.1.5/drivers/media/dvb/dvb-usb/az6027.c
> --- linux-2.6-3.1.5.debian/drivers/media/dvb/dvb-usb/az6027.c	2011-12-09 17:57:05.000000000 +0100
> +++ linux-2.6-3.1.5/drivers/media/dvb/dvb-usb/az6027.c	2011-12-22 19:42:25.655675023 +0100
> @@ -1090,6 +1090,7 @@
>  	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V1) },
>  	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V2) },
>  	{ USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT) },
> +	{ USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V3) },
>  	{ },
>  };
>  
> @@ -1135,7 +1136,7 @@
>  
>  	.i2c_algo         = &az6027_i2c_algo,
>  
> -	.num_device_descs = 6,
> +	.num_device_descs = 7,
>  	.devices = {
>  		{
>  			.name = "AZUREWAVE DVB-S/S2 USB2.0 (AZ6027)",
> @@ -1161,6 +1162,10 @@
>  			.name = "Elgato EyeTV Sat",
>  			.cold_ids = { &az6027_usb_table[5], NULL },
>  			.warm_ids = { NULL },
> +		}, {
> +			.name = "TERRATEC S7 Rev.3",
> +			.cold_ids = { &az6027_usb_table[6], NULL },
> +			.warm_ids = { NULL },
>  		},
>  		{ NULL },
>  	}
> diff -urd linux-2.6-3.1.5.debian/drivers/media/dvb/dvb-usb/dvb-usb-ids.h linux-2.6-3.1.5/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> --- linux-2.6-3.1.5.debian/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2011-12-09 17:57:05.000000000 +0100
> +++ linux-2.6-3.1.5/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2011-12-22 19:40:02.208934727 +0100
> @@ -319,6 +319,7 @@
>  #define USB_PID_AZUREWAVE_AZ6027			0x3275
>  #define USB_PID_TERRATEC_DVBS2CI_V1			0x10a4
>  #define USB_PID_TERRATEC_DVBS2CI_V2			0x10ac
> +#define USB_PID_TERRATEC_DVBS2CI_V3			0x10b0
>  #define USB_PID_TECHNISAT_USB2_HDCI_V1			0x0001
>  #define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002
>  #define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2		0x0004
> diff -urd linux-2.6-3.1.5.debian/drivers/media/dvb/dvb-usb/dw2102.c linux-2.6-3.1.5/drivers/media/dvb/dvb-usb/dw2102.c
> --- linux-2.6-3.1.5.debian/drivers/media/dvb/dvb-usb/dw2102.c	2011-12-09 17:57:05.000000000 +0100
> +++ linux-2.6-3.1.5/drivers/media/dvb/dvb-usb/dw2102.c	2011-12-22 19:43:16.588387654 +0100
> @@ -1181,6 +1181,14 @@
>  {
>  	u8 obuf[3] = { 0xe, 0x80, 0 };
>  	u8 ibuf[] = { 0 };
> +	
> +	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +
> +	//power on su3000
> +	obuf[0] = 0xe;
> +	obuf[1] = 0x02;
> +	obuf[2] = 1;
>  
>  	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
>  		err("command 0x0e transfer failed.");
> @@ -1451,6 +1459,7 @@
>  	{USB_DEVICE(0x9022, USB_PID_TEVII_S480_1)},
>  	{USB_DEVICE(0x9022, USB_PID_TEVII_S480_2)},
>  	{USB_DEVICE(0x1f4d, 0x3100)},
> +	{USB_DEVICE(USB_VID_TERRATEC, 0x00b0)},
>  	{ }
>  };
>  
> @@ -1824,7 +1833,7 @@
>  			}
>  		}
>  	},
> -	.num_device_descs = 3,
> +	.num_device_descs = 4,
>  	.devices = {
>  		{ "SU3000HD DVB-S USB2.0",
>  			{ &dw2102_table[10], NULL },
> @@ -1838,6 +1847,10 @@
>  			{ &dw2102_table[14], NULL },
>  			{ NULL },
>  		},
> +		{ "Terratec Cinergy S2 USB HD Rev.2",
> +			{ &dw2102_table[15], NULL },
> +			{ NULL },
> +		},
>  	}
>  };
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


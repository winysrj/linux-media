Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51491 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZA2Jsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 04:48:30 -0500
Date: Thu, 29 Jan 2009 07:47:35 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Boettcher <patrick.boettcher@desy.de>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Support faulty USB IDs on DIBUSB_MC
Message-ID: <20090129074735.76e07d47@caramujo.chehab.org>
In-Reply-To: <4974E4BE.2060107@free.fr>
References: <484A72D3.7070500@free.fr>
	<4974E4BE.2060107@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Jan 2009 21:38:22 +0100
matthieu castet <castet.matthieu@free.fr> wrote:

> matthieu castet wrote:
> > Hi,
> > 
> > I got a LITE-ON USB2.0 DVB-T Tuner that loose it's cold state vid/pid 
> > and got  FX2 dev kit one (0x04b4, 0x8613).
> > 
> > This patch introduce an option similar to the DVB_USB_DIBUSB_MB_FAULTY :
> > it add the FX2 dev kit ids to the DIBUSB_MC driver if 
> > DVB_USB_DIBUSB_MC_FAULTY is selected.
> > 
> > Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> > 
> 
> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
> index f00a0eb..a656b9b 100644
> --- a/drivers/media/dvb/dvb-usb/Kconfig
> +++ b/drivers/media/dvb/dvb-usb/Kconfig
> @@ -68,6 +68,12 @@ config DVB_USB_DIBUSB_MC
>  	  Say Y if you own such a device and want to use it. You should build it as
>  	  a module.
>  
> +config DVB_USB_DIBUSB_MC_FAULTY
> +	bool "Support faulty USB IDs"
> +	depends on DVB_USB_DIBUSB_MC
> +	help
> +	  Support for faulty USB IDs due to an invalid EEPROM on some LITE-ON devices.
> +
>  config DVB_USB_DIB0700
>  	tristate "DiBcom DiB0700 USB DVB devices (see help for supported devices)"
>  	depends on DVB_USB
> diff --git a/drivers/media/dvb/dvb-usb/dibusb-mc.c b/drivers/media/dvb/dvb-usb/dibusb-mc.c
> index 059cec9..ab5766a 100644
> --- a/drivers/media/dvb/dvb-usb/dibusb-mc.c
> +++ b/drivers/media/dvb/dvb-usb/dibusb-mc.c
> @@ -42,6 +42,17 @@ static struct usb_device_id dibusb_dib3000mc_table [] = {
>  /* 11 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ARTEC_T14_WARM) },
>  /* 12 */	{ USB_DEVICE(USB_VID_LEADTEK,		USB_PID_WINFAST_DTV_DONGLE_COLD) },
>  /* 13 */	{ USB_DEVICE(USB_VID_LEADTEK,		USB_PID_WINFAST_DTV_DONGLE_WARM) },
> +/*
> + * XXX: Some LITE-ON devices seem to loose their id after some time. Bad EEPROM ???.
> + *      We don't catch these faulty IDs (namely 'Cypress FX2 USB controller') that
> + *      have been left on the device. If you don't have such a device but an LITE-ON
> + *      device that's supposed to work with this driver but is not detected by it,
> + *      free to enable CONFIG_DVB_USB_DIBUSB_MC_FAULTY via your kernel config.
> + */
> +
> +#ifdef CONFIG_DVB_USB_DIBUSB_MC_FAULTY
> +/* 14 */	{ USB_DEVICE(USB_VID_CYPRESS,		USB_PID_ULTIMA_TVBOX_USB2_FX_COLD) },
> +#endif

It doesn't sound a very good approach the need of recompiling the driver to
allow it to work with a broken card. The better would be to have some modprobe
option to force it to accept a certain USB ID as a valid ID for the card.

>  			{ }		/* Terminating entry */
>  };
>  MODULE_DEVICE_TABLE (usb, dibusb_dib3000mc_table);
> @@ -88,7 +99,11 @@ static struct dvb_usb_device_properties dibusb_mc_properties = {
>  
>  	.generic_bulk_ctrl_endpoint = 0x01,
>  
> +#ifdef CONFIG_DVB_USB_DIBUSB_MC_FAULTY
> +	.num_device_descs = 8,
> +#else
>  	.num_device_descs = 7,
> +#endif

The above is really ugly. IMO, we should replace this by
ARRAY_SIZE(dibusb_mc_properties.devices). Of course, for this to work,
num_device_descs should be bellow devices.

>  	.devices = {
>  		{   "DiBcom USB2.0 DVB-T reference design (MOD3000P)",
>  			{ &dibusb_dib3000mc_table[0], NULL },
> @@ -119,6 +134,13 @@ static struct dvb_usb_device_properties dibusb_mc_properties = {
>  			{ &dibusb_dib3000mc_table[12], NULL },
>  			{ &dibusb_dib3000mc_table[13], NULL },
>  		},
> +#ifdef CONFIG_DVB_USB_DIBUSB_MC_FAULTY
> +		{   "LITE-ON USB2.0 DVB-T Tuner (faulty USB IDs)",
> +		    /* Also rebranded as Intuix S800, Toshiba */
> +			{ &dibusb_dib3000mc_table[14], NULL },
> +			{ NULL },
> +		},
> +#endif
>  		{ NULL },
>  	}
>  };


Patrick,
Comments?


Cheers,
Mauro

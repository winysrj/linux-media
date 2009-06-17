Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbZFQRkq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 13:40:46 -0400
Date: Wed, 17 Jun 2009 14:40:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Udi Atar <udi.linuxtv@gmail.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [09061_01] Siano: Update KConfig and Makefile
Message-ID: <20090617144043.519b413c@pedra.chehab.org>
In-Reply-To: <f1e62fb30906170736j69c9ff90pccef1be313d0dfe4@mail.gmail.com>
References: <f1e62fb30906170736j69c9ff90pccef1be313d0dfe4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Jun 2009 17:36:21 +0300
Udi Atar <udi.linuxtv@gmail.com> escreveu:

> # HG changeset patch
> # User Udi Atar <udia@siano-ms.com>
> # Date 1245248482 -10800
> # Node ID 46081b3e60046b900c9c8110513224911df8e106
> # Parent  b385a43af222b6c8d2d93937644eb936f63d81e3
> Update Siano KConfig file
> 
> From: Udi Atar <udia@siano-ms.com>
> 
> Priority: normal
> 
> Signed-off-by: Udi Atar <udia@siano-ms.com>
> 
> diff -r b385a43af222 -r 46081b3e6004 linux/drivers/media/dvb/siano/Kconfig
> --- a/linux/drivers/media/dvb/siano/Kconfig	Tue Jun 16 23:55:44 2009 -0300
> +++ b/linux/drivers/media/dvb/siano/Kconfig	Wed Jun 17 17:21:22 2009 +0300
> @@ -2,25 +2,32 @@
>  # Siano Mobile Silicon Digital TV device configuration
>  #
> 
> -config DVB_SIANO_SMS1XXX
> -	tristate "Siano SMS1XXX USB dongle support"
> -	depends on DVB_CORE && USB
> +config SMS_SIANO_MDTV

All DVB devices should start with DVB_.

> +	tristate "Siano SMS1xxx based MDTV receiver"
> +	default m

Don't use "default". You shouldn't assume that most of the kernel users are interested
on this module.

>  	---help---
> -	  Choose Y here if you have a USB dongle with a SMS1XXX chipset.
> +	Choose Y or M here if you have MDTV receiver with a Siano chipset.
> 
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called sms1xxx.
> +	To compile this driver as a module, choose M here
> +	(The modules will be called smsmdtv).
> 
> -config DVB_SIANO_SMS1XXX_SMS_IDS
> -	bool "Enable support for Siano Mobile Silicon default USB IDs"
> -	depends on DVB_SIANO_SMS1XXX
> -	default y
> +	Note: All dependents, if selected, will be part of this module.

As already discussed, the driver should be kept modular. So, the note above
doesn't apply.

> +
> +	Further documentation on this driver can be found on the WWW
> +	at http://www.siano-ms.com/
> +
> +if SMS_SIANO_MDTV
> +menu "Siano module components"
> +
> +# Hardware interfaces support
> +
> +config SMS_USB_DRV
> +	tristate "USB interface support"
> +	depends on USB
> +	default m if USB
>  	---help---
> -	  Choose Y here if you have a USB dongle with a SMS1XXX chipset
> -	  that uses Siano Mobile Silicon's default usb vid:pid.
> +	Choose if you would like to have Siano's support for USB interface
> 
> -	  Choose N here if you would prefer to use Siano's external driver.
> 
> -	  Further documentation on this driver can be found on the WWW at
> -	  <http://www.siano-ms.com/>.
> -
> +endmenu
> +endif # SMS_SIANO_MDTV

What kind of support the driver will provide without USB ?

I suspect that you are wanting to have several bus options like for example USB
and MMC. Since, without a bus, the core module makes no sense to be compiled,
you should, instead, use a different Kbuild struct. Something something like:


comment "Siano devices"

config DVB_SIANO_MDTV
	tristate
	default n

config DVB_SIANO_USB
	tristate "USB bus support for Siano devices"
	depends on DVB_CORE && USB
	select DVB_SIANO_MDTV
 	---help---
	  Choose if you would like to have Siano's support for USB interface

config DVB_SIANO_MMC
	tristate "MMC bus support for Siano devices"
	depends on DVB_CORE && USB
	select DVB_SIANO_MDTV
 	---help---
	  Choose if you would like to have Siano's support for MMC interface

<other bus options here>

With the above syntax, the core module will be built only if at least one of the
supported bus is selected.



Cheers,
Mauro

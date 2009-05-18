Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbZERGOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 02:14:52 -0400
Date: Mon, 18 May 2009 03:14:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0905_10] Siano - perform clean multi-modules build
Message-ID: <20090518031448.79b1d1fd@pedra.chehab.org>
In-Reply-To: <7362.40279.qm@web110812.mail.gq1.yahoo.com>
References: <7362.40279.qm@web110812.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 May 2009 12:26:18 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> escreveu:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1242323350 -10800
> # Node ID f93a86c6f9785cb60e015e811ddfca6850135887
> # Parent  0018ed9bbca31e76a17ead56e2e953c325c7cf3f
> [0905_10] Siano - perform clean multi-modules build
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> Clean up the multi dynamic module build, so no warning/errors
> will occur either with clean kernel git or Siano's repository.
> 
> Priority: normal
> 
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> 
> diff -r 0018ed9bbca3 -r f93a86c6f978 linux/drivers/media/dvb/siano/Kconfig
> --- a/linux/drivers/media/dvb/siano/Kconfig	Tue May 12 16:13:13 2009 +0000
> +++ b/linux/drivers/media/dvb/siano/Kconfig	Thu May 14 20:49:10 2009 +0300
> @@ -2,25 +2,74 @@
>  # Siano Mobile Silicon Digital TV device configuration
>  #
>  
> -config DVB_SIANO_SMS1XXX
> -	tristate "Siano SMS1XXX USB dongle support"
> -	depends on DVB_CORE && USB
> +config SMS_SIANO_MDTV

Please start with DVB for all DVB config options. The same comment is valid
also to the SMS suboptions bellow.

> +	tristate "Siano SMS1xxx based MDTV receiver"
> +	default m
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
> +
> +	Further documentation on this driver can be found on the WWW at http://www.siano-ms.com/

Please don't use more than 80 characters per line.

> +
> +if SMS_SIANO_MDTV
> +menu "Siano module components"
> +
> +# Kernel sub systems support
> +config SMS_DVB3_SUBSYS
> +	tristate "DVB v.3 Subsystem support"
> +	depends on DVB_CORE
> +	default m if DVB_CORE
>  	---help---
> -	  Choose Y here if you have a USB dongle with a SMS1XXX chipset
> -	  that uses Siano Mobile Silicon's default usb vid:pid.
> +	Choose if you would like to have DVB v.3 kernel sub-system support.
>  
> -	  Choose N here if you would prefer to use Siano's external driver.
> +#config SMS_DVB5_S2API_SUBSYS
> +#	tristate "DVB v.5 (S2 API) Subsystem support"
> +#	default n
> +#	---help---
> +#	Choose if you would like to have DVB v.5 (S2 API) kernel sub-system support.
> +#
> +#config SMS_HOSTLIB_SUBSYS
> +#	tristate "Host Library Subsystem support"
> +#	default n
> +#	---help---
> +#	Choose if you would like to have Siano's host library kernel sub-system support.
> +#
> +#if SMS_HOSTLIB_SUBSYS
> +#
> +#config SMS_NET_SUBSYS
> +#	tristate "Siano Network Adapter"
> +#	depends on SMS_HOSTLIB_SUBSYS
> +#	default n
> +#	---help---
> +#	Choose if you would like to have Siano's network adapter support.
> +#endif # SMS_HOSTLIB_SUBSYS

Don't add something commented above. Also, please be sure that, before adding
those Kconfig items, that the driver will support compilation with all
alternatives.
>  
> -	  Further documentation on this driver can be found on the WWW at
> -	  <http://www.siano-ms.com/>.
> +# Hardware interfaces support
>  
> +config SMS_USB_DRV
> +	tristate "USB interface support"
> +	depends on USB
> +	default m if USB
> +	---help---
> +	Choose if you would like to have Siano's support for USB interface
> +
> +config SMS_SDIO_DRV
> +	tristate "SDIO interface support"
> +	depends on MMC
> +	default m if MMC
> +	---help---
> +	Choose if you would like to have Siano's support for SDIO interface
> +
> +#config SMS_SPI_PXA310_DRV
> +#	tristate "PXA 310 SPI interface support"
> +#	depends on ARM && ARCH_PXA && MACH_ZYLONITE && PXA_SSP && SPI
> +#	default m if ARM && ARCH_PXA && MACH_ZYLONITE && PXA_SSP && SPI
> +#	---help---
> +#	Choose if you would like to have Siano's support for PXA 310 SPI interface

Idem.

> +
> +endmenu
> +endif # SMS_SIANO_MDTV
> diff -r 0018ed9bbca3 -r f93a86c6f978 linux/drivers/media/dvb/siano/Makefile
> --- a/linux/drivers/media/dvb/siano/Makefile	Tue May 12 16:13:13 2009 +0000
> +++ b/linux/drivers/media/dvb/siano/Makefile	Thu May 14 20:49:10 2009 +0300
> @@ -1,8 +1,9 @@ sms1xxx-objs := smscoreapi.o sms-cards.o
> -sms1xxx-objs := smscoreapi.o sms-cards.o smsendian.o
> +smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o
>  
> -obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o
> -obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsusb.o
> -obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsdvb.o
> +obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o
> +obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
> +obj-$(CONFIG_SMS_DVB3_SUBSYS) += smsdvb.o
> +#obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o

Please, don't add a commented line here. Just submit a Kconfig addition for
smssdio after the patch that adds this new module, as a separate file. I
sometimes rearrange the Kconfig patches, if later I discover some git bisection
breakage. So, the better is that Kconfig/Makefile patches to be separated than
the patches that touches the code.

>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
>  
> diff -r 0018ed9bbca3 -r f93a86c6f978 linux/drivers/media/dvb/siano/smsendian.h
> --- a/linux/drivers/media/dvb/siano/smsendian.h	Tue May 12 16:13:13 2009 +0000
> +++ b/linux/drivers/media/dvb/siano/smsendian.h	Thu May 14 20:49:10 2009 +0300
> @@ -24,9 +24,9 @@ along with this program.  If not, see <h
>  
>  #include <asm/byteorder.h>
>  
> -void smsendian_handle_tx_message(void *buffer);
> -void smsendian_handle_rx_message(void *buffer);
> -void smsendian_handle_message_header(void *msg);
> +extern void smsendian_handle_tx_message(void *buffer);
> +extern void smsendian_handle_rx_message(void *buffer);
> +extern void smsendian_handle_message_header(void *msg);
>  
>  #endif /* __SMS_ENDIAN_H__ */

It is better to provide the above as a separate patch. I'll probably rearrange
it at my -git to apply it before the patch that started using smdendian



Cheers,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1IWUW0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 16:22:26 -0400
Message-ID: <4E7CEA7C.1080701@redhat.com>
Date: Fri, 23 Sep 2011 17:22:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH  2/17]DVB:Siano drivers - Update module name string to
 contain module version
References: <1316514655.5199.80.camel@Doron-Ubuntu>
In-Reply-To: <1316514655.5199.80.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-09-2011 07:30, Doron Cohen escreveu:
> Hi,
> This patch step adds version to module name string for all modules.
> 
> Thanks,
> Doron Cohen
> 
> -----------------------
>>From 81a55103537fb6df2b487819aa9a5af28a5c4bd2 Mon Sep 17 00:00:00 2001
> From: Doron Cohen <doronc@siano-ms.com>
> Date: Wed, 14 Sep 2011 13:33:20 +0300
> Subject: [PATCH 03/21] Add smsspi driver to support Siano SPI connected
> device using SPI generic driver
> 
> 	modified:   drivers/media/dvb/siano/Makefile
> 	modified:   drivers/media/dvb/siano/smscoreapi.c
> 	new file:   drivers/media/dvb/siano/smsdbg_prn.h
> 	modified:   drivers/media/dvb/siano/smsspidrv.c
> 	modified:   drivers/media/dvb/siano/smsspiphy.c
> ---
>  drivers/media/dvb/siano/Makefile     |    2 +
>  drivers/media/dvb/siano/smscoreapi.c |    2 +-
>  drivers/media/dvb/siano/smsdbg_prn.h |   56
> ++++++++++++++++++++++++++++++++++

Patch is also mangled by your emailer.

>  drivers/media/dvb/siano/smsspidrv.c  |   33 +++++++++++++++-----
>  drivers/media/dvb/siano/smsspiphy.c  |   40 ++++++++----------------
>  5 files changed, 97 insertions(+), 36 deletions(-)
>  create mode 100644 drivers/media/dvb/siano/smsdbg_prn.h
> 
> diff --git a/drivers/media/dvb/siano/Makefile
> b/drivers/media/dvb/siano/Makefile
> index c54140b..affaf01 100644
> --- a/drivers/media/dvb/siano/Makefile
> +++ b/drivers/media/dvb/siano/Makefile
> @@ -1,9 +1,11 @@
>  
>  smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o smsir.o
> +smsspi-objs := smsspicommon.o smsspidrv.o smsspiphy.o
>  
>  obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
>  obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
>  obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o
> +obj-$(CONFIG_SMS_SPI_DRV) += smsspi.o
>  
>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
>  
> diff --git a/drivers/media/dvb/siano/smscoreapi.c
> b/drivers/media/dvb/siano/smscoreapi.c
> index 78765ed..239f453 100644
> --- a/drivers/media/dvb/siano/smscoreapi.c
> +++ b/drivers/media/dvb/siano/smscoreapi.c
> @@ -39,7 +39,7 @@
>  #include "smsir.h"
>  #include "smsendian.h"
>  
> -static int sms_dbg;
> +int sms_dbg;
>  module_param_named(debug, sms_dbg, int, 0644);
>  MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
>  
> diff --git a/drivers/media/dvb/siano/smsdbg_prn.h
> b/drivers/media/dvb/siano/smsdbg_prn.h
> new file mode 100644
> index 0000000..ea157da
> --- /dev/null
> +++ b/drivers/media/dvb/siano/smsdbg_prn.h
> @@ -0,0 +1,56 @@
> +/****************************************************************
> +
> +Siano Mobile Silicon, Inc.
> +MDTV receiver kernel modules.
> +Copyright (C) 2006-2008, Uri Shkolnik
> +
> +This program is free software: you can redistribute it and/or modify
> +it under the terms of the GNU General Public License as published by
> +the Free Software Foundation, either version 2 of the License, or
> +(at your option) any later version.
> +
> + This program is distributed in the hope that it will be useful,
> +but WITHOUT ANY WARRANTY; without even the implied warranty of
> +MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +GNU General Public License for more details.
> +
> +You should have received a copy of the GNU General Public License
> +along with this program.  If not, see <http://www.gnu.org/licenses/>.
> +
> +****************************************************************/
> +
> +#ifndef _SMS_DBG_H_
> +#define _SMS_DBG_H_
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +/************************************************************************/
> +/* Debug Zones definitions.
> */
> +/************************************************************************/
> +#undef PERROR
> +#  define PERROR(fmt, args...) \
> +	printk(KERN_ERR "spibus error: line %d- %s(): " fmt, __LINE__,\
> +	  __func__, ## args)
> +#undef PWARNING
> +#  define PWARNING(fmt, args...) \
> +	printk(KERN_WARNING "spibus warning: line %d- %s(): " fmt, __LINE__,
> \
> +	__func__, ## args)
> +
> +/* the debug macro - conditional compilation from the makefile */
> +#undef PDEBUG			/* undef it, just in case */
> +#ifdef SPIBUS_DEBUG
> +#  define PDEBUG(fmt, args...) \
> +	printk(KERN_DEBUG "spibus: line %d- %s(): " fmt, __LINE__, \
> +	 __func__, ## args)
> +#else
> +#  define PDEBUG(fmt, args...)	/* not debugging: nothing */
> +#endif
> +
> +/* The following defines are used for printing and
> +are mandatory for compilation. */
> +#define TXT(str) str
> +#define PRN_DBG(str) PDEBUG str
> +#define PRN_ERR(str) PERROR str
> +
> +#endif /*_SMS_DBG_H_*/
> diff --git a/drivers/media/dvb/siano/smsspidrv.c
> b/drivers/media/dvb/siano/smsspidrv.c
> index 35cce42..fa80c1a 100644
> --- a/drivers/media/dvb/siano/smsspidrv.c
> +++ b/drivers/media/dvb/siano/smsspidrv.c
> @@ -79,18 +79,27 @@ struct _Msg {
>  
>  struct _spi_device_st *spi_dev;
>  
> +int sms_dbg;
>  static void spi_worker_thread(void *arg);
>  static DECLARE_WORK(spi_work_queue, (void *)spi_worker_thread);
>  static u8 smsspi_preamble[] = { 0xa5, 0x5a, 0xe7, 0x7e };
>  static u8 smsspi_startup[] = { 0, 0, 0xde, 0xc1, 0xa5, 0x51, 0xf1,
> 0xed };
> +static u32 sms_intr_pin = SMS_INTR_PIN;
> +extern u32 host_intr_pin;
> +
>  static u32 default_type = SMS_NOVA_B0;
> -static u32 intr_pin = SMS_INTR_PIN;
>  
> -module_param(default_type, int, 0644);
> -MODULE_PARM_DESC(default_type, "default board type.");
> +module_param_named(debug, sms_dbg, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
> +
> +module_param(default_type, int, S_IRUGO);
> +MODULE_PARM_DESC(default_type, "default SMS device type.");
> +
> +module_param(sms_intr_pin, int, S_IRUGO);
> +MODULE_PARM_DESC(sms_intr_pin, "interrupt pin number used by SMS chip
> for interrupting host.");
>  
> -module_param(intr_pin, int, 0644);
> -MODULE_PARM_DESC(intr_pin, "interrupt pin number.");
> +module_param(host_intr_pin, int, S_IRUGO);
> +MODULE_PARM_DESC(host_intr_pin, "interrupt pin number used by Host to
> be interrupted by SMS.");
>  
>  /******************************************/
>  static void spi_worker_thread(void *arg)
> @@ -212,7 +221,7 @@ static int smsspi_preload(void *context)
>  		{
>  		MSG_SMS_SPI_INT_LINE_SET_REQ, 0, HIF_TASK,
>  			sizeof(struct _Msg), 0}, {
> -		0, intr_pin, 0}
> +		0, sms_intr_pin, 0}
>  	};
>  	int rc;
>  
> @@ -333,7 +342,7 @@ static struct platform_device smsspi_device = {
>  		},
>  };
>  
> -int smsspi_register(void)
> +static int __init smsspi_module_init(void)
>  {
>  	struct smsdevice_params_t params;
>  	int ret;
> @@ -438,7 +447,7 @@ txbuf_error:
>  	return ret;
>  }
>  
> -void smsspi_unregister(void)
> +static void __exit smsspi_module_exit(void)
>  {
>  	struct _spi_device_st *spi_device = spi_dev;
>  	sms_info("entering\n");
> @@ -453,3 +462,11 @@ void smsspi_unregister(void)
>  	platform_device_unregister(&smsspi_device);
>  	sms_info("exiting\n");
>  }
> +
> +
> +module_init(smsspi_module_init);
> +module_exit(smsspi_module_exit);
> +
> +MODULE_DESCRIPTION("Siano MDTV SPI device driver");
> +MODULE_AUTHOR("Siano Mobile Silicon, Inc. (doronc@siano-ms.com)");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb/siano/smsspiphy.c
> b/drivers/media/dvb/siano/smsspiphy.c
> index 9b8cb14..708ee06 100644
> --- a/drivers/media/dvb/siano/smsspiphy.c
> +++ b/drivers/media/dvb/siano/smsspiphy.c
> @@ -4,6 +4,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/irq.h>
>  #include <linux/interrupt.h>
> +
>  //#include <linux/timer.h>
>  #include "smscoreapi.h"
>  
> @@ -13,6 +14,12 @@
>  #define MAX_SPEED_DURING_DOWNLOAD	6000000
>  #define MAX_SPEED_DURING_WORK		6000000	
>  #define SPI_PACKET_SIZE 		256	
> +extern int sms_dbg;
> +
> +int sms_spi_interrupt = 135;
> +module_param_named(debug, sms_spi_interrupt, int, 0644);
> +MODULE_PARM_DESC(debug, "set interrupt gpio pin for spi device.");
> +
>  
>  int spi_max_speed = MAX_SPEED_DURING_WORK;
>  
> @@ -23,8 +30,6 @@ struct sms_spi {
>  	int 			bus_speed;
>  	void (*interruptHandler) (void *);
>  	void			*intr_context;
> -//	struct timer_list 	timer;
> -//	int			timer_interval;
>  };
>  
>  /*!
> @@ -141,9 +146,6 @@ void smsspibus_xfer(void *context, unsigned char
> *txbuf,
>  
>  
>  
> -
> -
> -
>  void *smsspiphy_init(void *context, void (*smsspi_interruptHandler)
> (void *),
>  		     void *intr_context)
>  {
> @@ -163,9 +165,7 @@ void *smsspiphy_init(void *context, void
> (*smsspi_interruptHandler) (void *),
>  		.mode		= SPI_MODE_0,
>  	};
>  
> -
> -	printk(KERN_INFO "sms_debug = %d\n", sms_debug);
> -
> +	sms_err("sms_debug = %d\n", sms_dbg);
>  
>  	sms_device = spi_new_device(master, &sms_chip);	
>  	if (!sms_device)
> @@ -191,36 +191,22 @@ void *smsspiphy_init(void *context, void
> (*smsspi_interruptHandler) (void *),
>  		return NULL;
>  	}
>  	memset (sms_spi->zero_txbuf, 0, SPI_PACKET_SIZE);
> -//	setup_timer(&sms_spi->timer, timer_function, (unsigned
> long)sms_spi);
>  	sms_spi->interruptHandler = smsspi_interruptHandler;
>  	sms_spi->intr_context = intr_context;
>  
>  
> -
> -
> -
> -
> -
> -	if ((gpio_request(135, "SMSSPI") == 0) &&
> -	    (gpio_direction_input(135) == 0)) {
> -		gpio_export(135, 0);
> +	if ((gpio_request(sms_spi_interrupt, "SMSSPI") == 0) &&
> +	    (gpio_direction_input(sms_spi_interrupt) == 0)) {
> +		gpio_export(sms_spi_interrupt, 0);
>  	}
>  
> -
> -	set_irq_type(gpio_to_irq(135), IRQ_TYPE_EDGE_FALLING);
> -	ret = request_irq(gpio_to_irq(135), spibus_interrupt,
> IRQF_TRIGGER_FALLING, "SMSSPI", sms_spi);
> +	irq_set_irq_type(gpio_to_irq(sms_spi_interrupt),
> IRQ_TYPE_EDGE_FALLING);
> +	ret = request_irq(gpio_to_irq(sms_spi_interrupt), spibus_interrupt,
> IRQF_TRIGGER_FALLING, "SMSSPI", sms_spi);
>  	if (ret) {
>  		sms_err("Could not get interrupt for SMS device. status =%d\n", ret);
>  		return NULL;
>  	}
>  
> -
> -
> -
> -
> -
> -
> -//	sms_spi->timer_interval = 1000;
>  	sms_spi->spi_dev = sms_device;
>  	sms_spi->bus_speed = spi_max_speed;
>  	sms_err ("after init sms_spi=0x%x, spi_dev = 0x%x", (int)sms_spi,
> (int)sms_spi->spi_dev);


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49493 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab2KSQP0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 11:15:26 -0500
Message-ID: <50AA5AFE.90601@iki.fi>
Date: Mon, 19 Nov 2012 18:14:54 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/for_v3.8] [media] siano: fix RC compilation
References: <E1TXsLC-0002s4-OG@www.linuxtv.org>
In-Reply-To: <E1TXsLC-0002s4-OG@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, it is still broken (for_v3.8)

   TEST    posttest
   Building modules, stage 2.
   MODPOST 2358 modules
ERROR: "sms_ir_exit" [drivers/media/common/siano/smsmdtv.ko] undefined!
ERROR: "sms_ir_event" [drivers/media/common/siano/smsmdtv.ko] undefined!
ERROR: "sms_ir_init" [drivers/media/common/siano/smsmdtv.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....
Succeed: decoded and checked 1628212 instructions
   TEST    posttest

regards
Antti


On 11/07/2012 12:09 PM, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] siano: fix RC compilation
> Author:  Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:    Wed Nov 7 11:09:08 2012 +0100
>
> As reported by Antti and by Stephen:
> drivers/built-in.o: In function `sms_ir_event':
> /home/david/checkouts/linux/drivers/media/common/siano/smsir.c:48: undefined reference to `ir_raw_event_store'
> /home/david/checkouts/linux/drivers/media/common/siano/smsir.c:50: undefined reference to `ir_raw_event_handle'
> drivers/built-in.o: In function `sms_ir_init':
> /home/david/checkouts/linux/drivers/media/common/siano/smsir.c:56: undefined reference to `smscore_get_board_id'
> /home/david/checkouts/linux/drivers/media/common/siano/smsir.c:60: undefined reference to `rc_allocate_device'
> /home/david/checkouts/linux/drivers/media/common/siano/smsir.c:72: undefined reference to `sms_get_board'
> /home/david/checkouts/linux/drivers/media/common/siano/smsir.c:92: undefined reference to `sms_get_board'
> /home/david/checkouts/linux/drivers/media/common/siano/smsir.c:97: undefined reference to `rc_register_device'
> /home/david/checkouts/linux/drivers/media/common/siano/smsir.c:100: undefined reference to `rc_free_device'
> drivers/built-in.o: In function `sms_ir_exit':
> /home/david/checkouts/linux/drivers/media/common/siano/smsir.c:111: undefined reference to `rc_unregister_device'
> make: *** [vmlinux] Error 1
>
> Caused by commit fdd1eeb49d36 "[media] siano: allow compiling it without RC support"
> And it happens when CONFIG_SMS_SIANO_RC=y and CONFIG_RC_CORE=m .
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>   drivers/media/common/siano/Kconfig  |    1 +
>   drivers/media/common/siano/Makefile |    5 ++++-
>   drivers/media/mmc/siano/Kconfig     |    2 +-
>   drivers/media/usb/siano/Kconfig     |    2 +-
>   4 files changed, 7 insertions(+), 3 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=2c4e11b7c15af70580625657a154ea7ea70b8c76
>
> diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
> index 3cb7823..68f0f60 100644
> --- a/drivers/media/common/siano/Kconfig
> +++ b/drivers/media/common/siano/Kconfig
> @@ -5,6 +5,7 @@
>   config SMS_SIANO_MDTV
>   	tristate
>   	depends on DVB_CORE && HAS_DMA
> +	depends on !RC_CORE || RC_CORE
>   	depends on SMS_USB_DRV || SMS_SDIO_DRV
>   	default y
>
> diff --git a/drivers/media/common/siano/Makefile b/drivers/media/common/siano/Makefile
> index 0e6f5e9..9e7fdf2 100644
> --- a/drivers/media/common/siano/Makefile
> +++ b/drivers/media/common/siano/Makefile
> @@ -1,7 +1,10 @@
>   smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o
>
>   obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
> -obj-$(CONFIG_SMS_SIANO_RC) += smsir.o
> +
> +ifeq ($(CONFIG_SMS_SIANO_RC),y)
> +  obj-$(CONFIG_SMS_SIANO_MDTV) += smsir.o
> +endif
>
>   ccflags-y += -Idrivers/media/dvb-core
>   ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
> diff --git a/drivers/media/mmc/siano/Kconfig b/drivers/media/mmc/siano/Kconfig
> index 69f8061..aa05ad3 100644
> --- a/drivers/media/mmc/siano/Kconfig
> +++ b/drivers/media/mmc/siano/Kconfig
> @@ -4,7 +4,7 @@
>
>   config SMS_SDIO_DRV
>   	tristate "Siano SMS1xxx based MDTV via SDIO interface"
> -	depends on DVB_CORE && RC_CORE && HAS_DMA
> +	depends on DVB_CORE && HAS_DMA
>   	depends on MMC
>   	select MEDIA_COMMON_OPTIONS
>   	---help---
> diff --git a/drivers/media/usb/siano/Kconfig b/drivers/media/usb/siano/Kconfig
> index b2c229e..5afbd9a 100644
> --- a/drivers/media/usb/siano/Kconfig
> +++ b/drivers/media/usb/siano/Kconfig
> @@ -4,7 +4,7 @@
>
>   config SMS_USB_DRV
>   	tristate "Siano SMS1xxx based MDTV receiver"
> -	depends on DVB_CORE && RC_CORE && HAS_DMA
> +	depends on DVB_CORE && HAS_DMA
>   	select MEDIA_COMMON_OPTIONS
>   	---help---
>   	  Choose if you would like to have Siano's support for USB interface
>
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
>


-- 
http://palosaari.fi/

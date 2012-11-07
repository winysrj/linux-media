Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab2KGBP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2012 20:15:56 -0500
Date: Wed, 7 Nov 2012 02:15:48 +0100
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: David =?ISO-8859-1?B?SORyZGVtYW4=?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] siano: fix Kconfig
Message-ID: <20121107021548.6e94618e@gaivota.chehab>
In-Reply-To: <20121107001018.31147.34490.stgit@zeus.hardeman.nu>
References: <20121107001018.31147.34490.stgit@zeus.hardeman.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 07 Nov 2012 01:10:18 +0100
David Härdeman <david@hardeman.nu> escreveu:

> make allmodconfig fails on the staging/for_v3.8 branch:
> 
>   LD      init/built-in.o
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
> from drivers/media/common/siano/Kconfig:
> config SMS_SIANO_RC
>         bool "Enable Remote Controller support for Siano devices"
> 
> from drivers/media/common/siano/Makefile:
>         obj-$(CONFIG_SMS_SIANO_RC) += smsir.o
> 
> Note the "bool" option in the Kconfig which results in these .config options:
>         CONFIG_SMS_SIANO_MDTV=m
>         CONFIG_SMS_SIANO_RC=y
>         CONFIG_RC_CORE=m
> 
> So the smsir.ko module gets built in while rc-core is a standalone
> module. Fix by making smsir a tristate as well. (I hope that's the
> correct fix, I'm no Kconfig expert).

I suspect that this won't cover all possibilities. It seems that this would
still be a valid option:

         CONFIG_SMS_SIANO_MDTV=y
         CONFIG_SMS_SIANO_RC=m
         CONFIG_RC_CORE=m

But I don't think it would work.

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/common/siano/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
> index 3cb7823..239b7ba 100644
> --- a/drivers/media/common/siano/Kconfig
> +++ b/drivers/media/common/siano/Kconfig
> @@ -9,7 +9,7 @@ config SMS_SIANO_MDTV
>  	default y
>  
>  config SMS_SIANO_RC
> -	bool "Enable Remote Controller support for Siano devices"
> +	tristate "Enable Remote Controller support for Siano devices"
>  	depends on SMS_SIANO_MDTV && RC_CORE
>  	depends on SMS_USB_DRV || SMS_SDIO_DRV
>  	depends on MEDIA_COMMON_OPTIONS
> 




Cheers,
Mauro

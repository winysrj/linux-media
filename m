Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36198 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751903AbdJJG37 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 02:29:59 -0400
Date: Tue, 10 Oct 2017 15:30:09 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: ir-spi needs OF
Message-id: <20171010063009.GE487@gangnam>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <20171009084650.31129-1-sean@mess.org>
References: <CGME20171009084659epcas1p42793d0df42faccd091109ae388a267f8@epcas1p4.samsung.com>
        <20171009084650.31129-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 09, 2017 at 09:46:50AM +0100, Sean Young wrote:
> Without device tree, there is no way to use this driver.
> 
> Signed-off-by: Sean Young <sean@mess.org>

Thanks, Sean!

Acked-by: Andi Shyti <andi.shyti@samsung.com>

Andi

> ---
>  drivers/media/rc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index bde3c271fb88..afb3456d4e20 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -286,6 +286,7 @@ config IR_REDRAT3
>  config IR_SPI
>  	tristate "SPI connected IR LED"
>  	depends on SPI && LIRC
> +	depends on OF || COMPILE_TEST
>  	---help---
>  	  Say Y if you want to use an IR LED connected through SPI bus.
>  
> -- 
> 2.13.6
> 
> 

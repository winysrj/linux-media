Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44215 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754253AbeDWI4L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 04:56:11 -0400
Date: Mon, 23 Apr 2018 09:56:08 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Ladislav Michl <ladis@linux-mips.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andi Kleen <ak@linux.intel.com>, Mans Rullgard <mans@mansr.com>
Subject: Re: [PATCH 3/7] media: rc: allow build pnp-dependent drivers with
 COMPILE_TEST
Message-ID: <20180423085607.r6sz2dzxdwwa6sdj@gofer.mess.org>
References: <cover.1524245455.git.mchehab@s-opensource.com>
 <48bdabe5761d9b86b79b715be81686cee47d25dd.1524245455.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48bdabe5761d9b86b79b715be81686cee47d25dd.1524245455.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 01:42:49PM -0400, Mauro Carvalho Chehab wrote:
> The pnp header already provide enough stub to build those
> drivers with COMPILE_TEST on non-x86 archs.

That's great, thanks.

Acked-by: Sean Young <sean@mess.org>

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/rc/Kconfig | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index eb2c3b6eca7f..9a3b66c6700c 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -149,7 +149,7 @@ config RC_ATI_REMOTE
>  
>  config IR_ENE
>  	tristate "ENE eHome Receiver/Transceiver (pnp id: ENE0100/ENE02xxx)"
> -	depends on PNP
> +	depends on PNP || COMPILE_TEST
>  	depends on RC_CORE
>  	---help---
>  	   Say Y here to enable support for integrated infrared receiver
> @@ -210,7 +210,7 @@ config IR_MCEUSB
>  
>  config IR_ITE_CIR
>  	tristate "ITE Tech Inc. IT8712/IT8512 Consumer Infrared Transceiver"
> -	depends on PNP
> +	depends on PNP || COMPILE_TEST
>  	depends on RC_CORE
>  	---help---
>  	   Say Y here to enable support for integrated infrared receivers
> @@ -223,7 +223,7 @@ config IR_ITE_CIR
>  
>  config IR_FINTEK
>  	tristate "Fintek Consumer Infrared Transceiver"
> -	depends on PNP
> +	depends on PNP || COMPILE_TEST
>  	depends on RC_CORE
>  	---help---
>  	   Say Y here to enable support for integrated infrared receiver
> @@ -257,7 +257,7 @@ config IR_MTK
>  
>  config IR_NUVOTON
>  	tristate "Nuvoton w836x7hg Consumer Infrared Transceiver"
> -	depends on PNP
> +	depends on PNP || COMPILE_TEST
>  	depends on RC_CORE
>  	---help---
>  	   Say Y here to enable support for integrated infrared receiver
> @@ -305,7 +305,7 @@ config IR_STREAMZAP
>  
>  config IR_WINBOND_CIR
>  	tristate "Winbond IR remote control"
> -	depends on X86 && PNP
> +	depends on (X86 && PNP) || COMPILE_TEST
>  	depends on RC_CORE
>  	select NEW_LEDS
>  	select LEDS_CLASS
> -- 
> 2.14.3

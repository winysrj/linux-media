Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54757 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdJEMk1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 08:40:27 -0400
Date: Thu, 5 Oct 2017 13:40:25 +0100
From: Sean Young <sean@mess.org>
To: Ladislav Michl <ladis@linux-mips.org>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] media: rc: fix gpio-ir-receiver build failure
Message-ID: <20171005124025.l63iejkrbrm2pdkn@gofer.mess.org>
References: <201710051617.Heo0ts1p%fengguang.wu@intel.com>
 <20171005121105.zdldrc323lpp2upn@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171005121105.zdldrc323lpp2upn@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 05, 2017 at 02:11:06PM +0200, Ladislav Michl wrote:
> The 0-day robot reports:
> 
>    drivers/media/rc/gpio-ir-recv.c: In function 'gpio_ir_recv_irq':
> >> drivers/media/rc/gpio-ir-recv.c:38:8: error: implicit declaration of function 'gpiod_get_value' [-Werror=implicit-function-declaration]
> 
> Fixes: eed008e605d1 ("[media] media: rc: gpio-ir-recv: use gpiolib API")
> 
> For some reason only partial patch was applied. Also include
> gpio/consumer.h otherwise compile test fails.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
> ---
>  Changes:
>  -v2: replace Sean's patch with something I believe is more accurate

Yes, your change is right. Thanks for pointing that out. Actually there
are more device tree rc drivers that need a "depends on OF || TEST_COMPILE".

Acked-by: Sean Young <sean@mess.org>

> 
>  drivers/media/rc/Kconfig        |    1 +
>  drivers/media/rc/gpio-ir-recv.c |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index d9ce8ff55d0c..6bfe983ff295 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -393,6 +393,7 @@ config RC_LOOPBACK
>  config IR_GPIO_CIR
>  	tristate "GPIO IR remote control"
>  	depends on RC_CORE
> +	depends on (OF && GPIOLIB) || COMPILE_TEST
>  	---help---
>  	   Say Y if you want to use GPIO based IR Receiver.
> 
> diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
> index 5bb0851eacce..b6c4a2d2b696 100644
> --- a/drivers/media/rc/gpio-ir-recv.c
> +++ b/drivers/media/rc/gpio-ir-recv.c
> @@ -14,7 +14,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/slab.h>
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>

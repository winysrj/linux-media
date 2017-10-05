Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:37332 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdJELgM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Oct 2017 07:36:12 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990523AbdJELgKMCK48 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Oct 2017 13:36:10 +0200
Date: Thu, 5 Oct 2017 13:36:07 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: Sean Young <sean@mess.org>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: fix gpio-ir-receiver build failure
Message-ID: <20171005113607.pr4b635ybpqkum5f@lenoch>
References: <201710051617.Heo0ts1p%fengguang.wu@intel.com>
 <20171005110327.z4oqlna7jdjk7gh5@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171005110327.z4oqlna7jdjk7gh5@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 05, 2017 at 12:03:28PM +0100, Sean Young wrote:
> The 0-day robot reports:
> 
>    drivers/media/rc/gpio-ir-recv.c: In function 'gpio_ir_recv_irq':
> >> drivers/media/rc/gpio-ir-recv.c:38:8: error: implicit declaration of function 'gpiod_get_value' [-Werror=implicit-function-declaration]
> 
> Fixes: eed008e605d1 ("[media] media: rc: gpio-ir-recv: use gpiolib API")
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 467cf2bdbd42..b9ae0cb01a53 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -392,6 +392,7 @@ config RC_LOOPBACK
>  config IR_GPIO_CIR
>  	tristate "GPIO IR remote control"
>  	depends on RC_CORE
> +	depends on GPIOLIB
>  	---help---
>  	   Say Y if you want to use GPIO based IR Receiver.

Hmm, following was part of patch I sent. What happened to it?

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index d9ce8ff55d0c..6bfe983ff295 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -393,6 +393,7 @@ config RC_LOOPBACK
 config IR_GPIO_CIR
        tristate "GPIO IR remote control"
        depends on RC_CORE
+       depends on (OF && GPIOLIB) || COMPILE_TEST
        ---help---
           Say Y if you want to use GPIO based IR Receiver.

Just compare:
https://patchwork.linuxtv.org/patch/43918/
and
https://git.linuxtv.org/media_tree.git/commit/?id=eed008e605d13ee4fb64668350be58999e85aac7

Also, fix appears to be:

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 5bb0851eacce..b6c4a2d2b696 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -14,7 +14,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>

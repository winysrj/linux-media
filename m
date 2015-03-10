Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:42106 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbbCJS3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 14:29:54 -0400
Received: by lams18 with SMTP id s18so3687801lam.9
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2015 11:29:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425822043-18733-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1425822043-18733-1-git-send-email-laurent.pinchart@ideasonboard.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 10 Mar 2015 18:29:22 +0000
Message-ID: <CA+V-a8uvEfiTAsL826udM8r0aFT3ZYXkMoT1UXgCOeq=pTbw0Q@mail.gmail.com>
Subject: Re: [PATCH] v4l: mt9p031: Convert to the gpiod API
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Sun, Mar 8, 2015 at 1:40 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> This simplifies platform data and DT integration.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/mt9p031.c | 31 +++++++++++--------------------
>  include/media/mt9p031.h     |  2 --
>  2 files changed, 11 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 89ae2b4..1757ef6 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -15,12 +15,11 @@
>  #include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/device.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/i2c.h>
>  #include <linux/log2.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> -#include <linux/of_gpio.h>
>  #include <linux/of_graph.h>
>  #include <linux/pm.h>
>  #include <linux/regulator/consumer.h>
> @@ -136,7 +135,7 @@ struct mt9p031 {
>         struct aptina_pll pll;
>         unsigned int clk_div;
>         bool use_pll;
> -       int reset;
> +       struct gpio_desc *reset;
>
>         struct v4l2_ctrl_handler ctrls;
>         struct v4l2_ctrl *blc_auto;
> @@ -309,9 +308,9 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
>  {
>         int ret;
>
> -       /* Ensure RESET_BAR is low */
> -       if (gpio_is_valid(mt9p031->reset)) {
> -               gpio_set_value(mt9p031->reset, 0);
> +       /* Ensure RESET_BAR is active */
> +       if (mt9p031->reset) {
> +               gpiod_set_value(mt9p031->reset, 1);
>                 usleep_range(1000, 2000);
>         }
>
> @@ -332,8 +331,8 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
>         }
>
>         /* Now RESET_BAR must be high */
> -       if (gpio_is_valid(mt9p031->reset)) {
> -               gpio_set_value(mt9p031->reset, 1);
> +       if (mt9p031->reset) {
> +               gpiod_set_value(mt9p031->reset, 0);
>                 usleep_range(1000, 2000);
>         }
>
As per the data sheet reset needs to be low initially and then high,
you just reversed it.

Thanks,
--Prabhakar Lad

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:50404 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751331AbdIPKxq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 06:53:46 -0400
Received: by mail-wm0-f46.google.com with SMTP id v142so13110703wmv.5
        for <linux-media@vger.kernel.org>; Sat, 16 Sep 2017 03:53:46 -0700 (PDT)
Date: Sat, 16 Sep 2017 14:53:39 +0400
From: Anton Sviridenko <anton@corp.bluecherry.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] solo6x10: hide unused variable
Message-ID: <20170916105337.GA8054@magpie-gentoo>
References: <20170915195225.1394284-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170915195225.1394284-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Fri, Sep 15, 2017 at 09:52:04PM +0200, Arnd Bergmann wrote:
> When building without CONFIG_GPIOLIB, we get a harmless
> warning about an unused variable:
> 
> drivers/media/pci/solo6x10/solo6x10-gpio.c: In function 'solo_gpio_init':
> drivers/media/pci/solo6x10/solo6x10-gpio.c:165:6: error: unused variable 'ret' [-Werror=unused-variable]
> 
> This adds another #ifdef around the declaration.
> 
> Fixes: d3202d1981dc ("media: solo6x10: export hardware GPIO pins 8:31 to gpiolib interface")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/pci/solo6x10/solo6x10-gpio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-gpio.c b/drivers/media/pci/solo6x10/solo6x10-gpio.c
> index 3d0d1aa2f6a8..7b4641a2cb84 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-gpio.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-gpio.c
> @@ -162,7 +162,9 @@ static void solo_gpiochip_set(struct gpio_chip *chip,
>  
>  int solo_gpio_init(struct solo_dev *solo_dev)
>  {
> +#ifdef CONFIG_GPIOLIB
>  	int ret;
> +#endif
>  
>  	solo_gpio_config(solo_dev);
>  #ifdef CONFIG_GPIOLIB
> -- 
> 2.9.0
> 

Acked-by: Anton Sviridenko <anton@corp.bluecherry.net>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46436 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbbCIJgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 05:36:38 -0400
Received: by wiwh11 with SMTP id h11so8175848wiw.5
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2015 02:36:37 -0700 (PDT)
Date: Mon, 9 Mar 2015 09:36:33 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v12 05/19] mfd: max77693: Modify flash cell name
 identifiers
Message-ID: <20150309093633.GI3427@x1>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
 <1425485680-8417-6-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1425485680-8417-6-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 Mar 2015, Jacek Anaszewski wrote:

> Change flash cell identifiers from max77693-flash to max77693-led
> to avoid confusion with NOR/NAND Flash.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/max77693.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index a159593..cb14afa 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -53,8 +53,8 @@ static const struct mfd_cell max77693_devs[] = {
>  		.of_compatible = "maxim,max77693-haptic",
>  	},
>  	{
> -		.name = "max77693-flash",
> -		.of_compatible = "maxim,max77693-flash",
> +		.name = "max77693-led",
> +		.of_compatible = "maxim,max77693-led",
>  	},
>  };
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40803 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaLIIwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Dec 2014 03:52:25 -0500
Received: by mail-ie0-f179.google.com with SMTP id rp18so102791iec.10
        for <linux-media@vger.kernel.org>; Tue, 09 Dec 2014 00:52:24 -0800 (PST)
Date: Tue, 9 Dec 2014 08:52:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v9 03/19] mfd: max77693: Modify flash cell name
 identifiers
Message-ID: <20141209085216.GS3951@x1>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-4-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417622814-10845-4-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 03 Dec 2014, Jacek Anaszewski wrote:

> Change flash cell identifiers from max77693-flash to max77693-led
> to avoid confusion with NOR/NAND Flash.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/max77693.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
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

This is fine by me, so long as you've been through the usual
deprecation procedures or this platform is still WiP.

>  	},
>  };
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

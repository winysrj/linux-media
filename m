Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37383 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbbCIJfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 05:35:23 -0400
Received: by widem10 with SMTP id em10so3732238wid.2
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2015 02:35:20 -0700 (PDT)
Date: Mon, 9 Mar 2015 09:35:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v12 08/19] mfd: max77693: Adjust FLASH_EN_SHIFT and
 TORCH_EN_SHIFT macros
Message-ID: <20150309093516.GF3427@x1>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
 <1425485680-8417-9-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1425485680-8417-9-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 Mar 2015, Jacek Anaszewski wrote:

> Modify FLASH_EN_SHIFT and TORCH_EN_SHIFT macros to work properly
> when passed enum max77693_fled values (0 for FLED1 and 1 for FLED2)
> from leds-max77693 driver. Previous definitions were compatible with
> one of the previous RFC versions of leds-max77693.c driver, which was
> not merged.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mfd/max77693-private.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> index 8770ce1..51633ea 100644
> --- a/include/linux/mfd/max77693-private.h
> +++ b/include/linux/mfd/max77693-private.h
> @@ -114,8 +114,8 @@ enum max77693_pmic_reg {
>  #define FLASH_EN_FLASH		0x1
>  #define FLASH_EN_TORCH		0x2
>  #define FLASH_EN_ON		0x3
> -#define FLASH_EN_SHIFT(x)	(6 - ((x) - 1) * 2)
> -#define TORCH_EN_SHIFT(x)	(2 - ((x) - 1) * 2)
> +#define FLASH_EN_SHIFT(x)	(6 - (x) * 2)
> +#define TORCH_EN_SHIFT(x)	(2 - (x) * 2)
>  
>  /* MAX77693 MAX_FLASH1 register */
>  #define MAX_FLASH1_MAX_FL_EN	0x80

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

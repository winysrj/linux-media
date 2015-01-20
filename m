Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:62479 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbbATLR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 06:17:26 -0500
Received: by mail-ig0-f181.google.com with SMTP id hn18so2855081igb.2
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2015 03:17:26 -0800 (PST)
Date: Tue, 20 Jan 2015 11:17:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 07/19] mfd: max77693: Adjust FLASH_EN_SHIFT and
 TORCH_EN_SHIFT macros
Message-ID: <20150120111719.GF13701@x1>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-8-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420816989-1808-8-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 09 Jan 2015, Jacek Anaszewski wrote:

> Modify FLASH_EN_SHIFT and TORCH_EN_SHIFT macros to work properly
> when passed enum max77693_fled values (0 for FLED1 and 1 for FLED2)
> from leds-max77693 driver.

Off-by-one ay?  Wasn't the original code tested?

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mfd/max77693-private.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> index 08dae01..01799a9 100644
> --- a/include/linux/mfd/max77693-private.h
> +++ b/include/linux/mfd/max77693-private.h
> @@ -113,8 +113,8 @@ enum max77693_pmic_reg {
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

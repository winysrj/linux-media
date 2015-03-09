Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:44002 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbbCIJgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 05:36:16 -0400
Received: by wggx12 with SMTP id x12so15919558wgg.10
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2015 02:36:15 -0700 (PDT)
Date: Mon, 9 Mar 2015 09:36:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v12 07/19] mfd: max77693: add TORCH_IOUT_MASK macro
Message-ID: <20150309093611.GH3427@x1>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
 <1425485680-8417-8-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1425485680-8417-8-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 Mar 2015, Jacek Anaszewski wrote:

> Add a macro for obtaining the mask of ITORCH register bit fields
> related either to FLED1 or FLED2 current output. The expected
> arguments are TORCH_IOUT1_SHIFT or TORCH_IOUT2_SHIFT.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mfd/max77693-private.h |    1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> index 955dd99..8770ce1 100644
> --- a/include/linux/mfd/max77693-private.h
> +++ b/include/linux/mfd/max77693-private.h
> @@ -87,6 +87,7 @@ enum max77693_pmic_reg {
>  /* MAX77693 ITORCH register */
>  #define TORCH_IOUT1_SHIFT	0
>  #define TORCH_IOUT2_SHIFT	4
> +#define TORCH_IOUT_MASK(x)	(0xf << (x))
>  #define TORCH_IOUT_MIN		15625
>  #define TORCH_IOUT_MAX		250000
>  #define TORCH_IOUT_STEP		15625

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

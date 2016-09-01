Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:58125 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755262AbcIALyz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 07:54:55 -0400
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        wsa@the-dreams.de, linux-samsung-soc@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] exynos4-is: Clear isp-i2c adapter
 power.ignore_children flag
Date: Thu, 01 Sep 2016 13:54:49 +0200
Message-id: <4547892.mzTdl6x2IH@amdc1976>
In-reply-to: <1472729956-17475-1-git-send-email-s.nawrocki@samsung.com>
References: <1472729956-17475-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

On Thursday, September 01, 2016 01:39:16 PM Sylwester Nawrocki wrote:
> Since commit 04f59143b571161d25315dd52d7a2ecc022cb71a
> ("i2c: let I2C masters ignore their children for PM")
> the power.ignore_children flag is set when registering an I2C
> adapter. Since I2C transfers are not managed by the fimc-isp-i2c
> driver its clients use pm_runtime_* calls directly to communicate
> required power state of the bus controller.
> However when the power.ignore_children flag is set that doesn't
> work, so clear that flag back after registering the adapter.
> While at it drop pm_runtime_enable() call on the i2c_adapter
> as it is already done by the I2C subsystem when registering
> I2C adapter.
> 
> Cc: <stable@vger.kernel.org> # 4.7+

You may also use "Fixes:" tag to mark the original commit that
this one corrects.

> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/media/platform/exynos4-is/fimc-is-i2c.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
> index 7521aa5..03b4246 100644
> --- a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
> +++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
> @@ -55,26 +55,37 @@ static int fimc_is_i2c_probe(struct platform_device *pdev)
>  	i2c_adap->algo = &fimc_is_i2c_algorithm;
>  	i2c_adap->class = I2C_CLASS_SPD;
>  
> +	platform_set_drvdata(pdev, isp_i2c);
> +	pm_runtime_enable(&pdev->dev);
> +
>  	ret = i2c_add_adapter(i2c_adap);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to add I2C bus %s\n",
>  						node->full_name);
> -		return ret;
> +		goto err_pm_dis;
>  	}
>  
> -	platform_set_drvdata(pdev, isp_i2c);
> -
> -	pm_runtime_enable(&pdev->dev);
> -	pm_runtime_enable(&i2c_adap->dev);
> -
> +	/*
> +	 * Client drivers of this adapter don't do any I2C transfers as that
> +	 * is handled by the ISP firmware.  But we rely on the runtime PM
> +	 * state propagation from the clients up to the adapter driver so
> +	 * clear the ignore_children flags here.  PM rutnime calls are not

Minor nit:

"rutnime" typo

Otherwise it looks all fine to me.

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


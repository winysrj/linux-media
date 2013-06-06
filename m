Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:52348 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3FFFUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jun 2013 01:20:38 -0400
Received: by mail-oa0-f54.google.com with SMTP id o17so1857767oag.13
        for <linux-media@vger.kernel.org>; Wed, 05 Jun 2013 22:20:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370005408-10853-3-git-send-email-arun.kk@samsung.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-3-git-send-email-arun.kk@samsung.com>
Date: Thu, 6 Jun 2013 10:50:38 +0530
Message-ID: <CAK9yfHzwtkrpVVK6DZPN1xjanc+bNeHb5yX+Dy9rfHh50nACxg@mail.gmail.com>
Subject: Re: [RFC v2 02/10] exynos5-fimc-is: Adds fimc-is driver core files
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	arunkk.samsung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 31 May 2013 18:33, Arun Kumar K <arun.kk@samsung.com> wrote:
> This driver is for the FIMC-IS IP available in Samsung Exynos5
> SoC onwards. This patch adds the core files for the new driver.
>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
> ---
[snip]

> +
> +static void fimc_is_clk_put(struct fimc_is *is)
> +{
> +       int i;
> +
> +       for (i = 0; i < IS_CLK_MAX_NUM; i++) {
> +               if (IS_ERR_OR_NULL(is->clock[i]))

You should not check for NULL here. Instead initialize the clocks to
some error value (like  "is->clock[i] =  ERR_PTR(-EINVAL);" )
and use IS_ERR only.

> +                       continue;
> +               clk_unprepare(is->clock[i]);
> +               clk_put(is->clock[i]);
> +               is->clock[i] = NULL;
> +       }
> +}
> +
> +static int fimc_is_clk_get(struct fimc_is *is)
> +{
> +       struct device *dev = &is->pdev->dev;
> +       int i, ret;
> +
> +       for (i = 0; i < IS_CLK_MAX_NUM; i++) {
> +               is->clock[i] = clk_get(dev, fimc_is_clock_name[i]);
> +               if (IS_ERR(is->clock[i]))
> +                       goto err;
> +               ret = clk_prepare(is->clock[i]);
> +               if (ret < 0) {
> +                       clk_put(is->clock[i]);
> +                       is->clock[i] = NULL;

is->clock[i] =  ERR_PTR(-EINVAL);

> +                       goto err;
> +               }
> +       }
> +       return 0;
> +err:
> +       fimc_is_clk_put(is);
> +       pr_err("Failed to get clock: %s\n", fimc_is_clock_name[i]);
> +       return -ENXIO;
> +}
> +
> +static int fimc_is_clk_cfg(struct fimc_is *is)
> +{
> +       int ret;
> +
> +       ret = fimc_is_clk_get(is);
> +       if (ret)
> +               return ret;
> +
> +       /* Set rates */
> +       ret = clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV0], 200 * 1000000);
> +       ret |= clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV1], 100 * 1000000);
> +       ret |= clk_set_rate(is->clock[IS_CLK_ISP_DIV0], 134 * 1000000);
> +       ret |= clk_set_rate(is->clock[IS_CLK_ISP_DIV1], 68 * 1000000);
> +       ret |= clk_set_rate(is->clock[IS_CLK_ISP_DIVMPWM], 34 * 1000000);
> +
> +       if (ret)
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
> +static int fimc_is_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct resource res;
> +       struct fimc_is *is;
> +       struct pinctrl *pctrl;
> +       void __iomem *regs;
> +       struct device_node *node;
> +       int irq, ret;
> +
> +       pr_debug("FIMC-IS Probe Enter\n");
> +
> +       if (!pdev->dev.of_node)
> +               return -ENODEV;
> +
> +       is = devm_kzalloc(&pdev->dev, sizeof(*is), GFP_KERNEL);
> +       if (!is)
> +               return -ENOMEM;
> +
> +       is->pdev = pdev;
> +
> +       ret = of_address_to_resource(dev->of_node, 0, &res);
> +       if (ret < 0)
> +               return ret;
> +
> +       regs = devm_ioremap_resource(dev, &res);
> +       if (regs == NULL) {

Please use if(IS_ERR(regs))

> +               dev_err(dev, "Failed to obtain io memory\n");

This is not needed as devm_ioremap_resource prints the appropriate
error messages.

> +               return -ENOENT;

return PTR_ERR(regs);

Don't forget to include <linux/err.h> for using PTR_ERR() .

-- 
With warm regards,
Sachin

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:34927 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3FGK0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 06:26:35 -0400
Received: by mail-ve0-f169.google.com with SMTP id m1so2890242ves.14
        for <linux-media@vger.kernel.org>; Fri, 07 Jun 2013 03:26:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK9yfHzwtkrpVVK6DZPN1xjanc+bNeHb5yX+Dy9rfHh50nACxg@mail.gmail.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-3-git-send-email-arun.kk@samsung.com>
	<CAK9yfHzwtkrpVVK6DZPN1xjanc+bNeHb5yX+Dy9rfHh50nACxg@mail.gmail.com>
Date: Fri, 7 Jun 2013 15:56:34 +0530
Message-ID: <CALt3h7_ky1xkpt9nMpJDNK9uakfXwf3etnKrtaYHSAi12D1Ejg@mail.gmail.com>
Subject: Re: [RFC v2 02/10] exynos5-fimc-is: Adds fimc-is driver core files
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thank you for the review.
Will address your comments in next iteration.

Regards
Arun

On Thu, Jun 6, 2013 at 10:50 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Arun,
>
> On 31 May 2013 18:33, Arun Kumar K <arun.kk@samsung.com> wrote:
>> This driver is for the FIMC-IS IP available in Samsung Exynos5
>> SoC onwards. This patch adds the core files for the new driver.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
>> ---
> [snip]
>
>> +
>> +static void fimc_is_clk_put(struct fimc_is *is)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < IS_CLK_MAX_NUM; i++) {
>> +               if (IS_ERR_OR_NULL(is->clock[i]))
>
> You should not check for NULL here. Instead initialize the clocks to
> some error value (like  "is->clock[i] =  ERR_PTR(-EINVAL);" )
> and use IS_ERR only.
>
>> +                       continue;
>> +               clk_unprepare(is->clock[i]);
>> +               clk_put(is->clock[i]);
>> +               is->clock[i] = NULL;
>> +       }
>> +}
>> +
>> +static int fimc_is_clk_get(struct fimc_is *is)
>> +{
>> +       struct device *dev = &is->pdev->dev;
>> +       int i, ret;
>> +
>> +       for (i = 0; i < IS_CLK_MAX_NUM; i++) {
>> +               is->clock[i] = clk_get(dev, fimc_is_clock_name[i]);
>> +               if (IS_ERR(is->clock[i]))
>> +                       goto err;
>> +               ret = clk_prepare(is->clock[i]);
>> +               if (ret < 0) {
>> +                       clk_put(is->clock[i]);
>> +                       is->clock[i] = NULL;
>
> is->clock[i] =  ERR_PTR(-EINVAL);
>
>> +                       goto err;
>> +               }
>> +       }
>> +       return 0;
>> +err:
>> +       fimc_is_clk_put(is);
>> +       pr_err("Failed to get clock: %s\n", fimc_is_clock_name[i]);
>> +       return -ENXIO;
>> +}
>> +
>> +static int fimc_is_clk_cfg(struct fimc_is *is)
>> +{
>> +       int ret;
>> +
>> +       ret = fimc_is_clk_get(is);
>> +       if (ret)
>> +               return ret;
>> +
>> +       /* Set rates */
>> +       ret = clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV0], 200 * 1000000);
>> +       ret |= clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV1], 100 * 1000000);
>> +       ret |= clk_set_rate(is->clock[IS_CLK_ISP_DIV0], 134 * 1000000);
>> +       ret |= clk_set_rate(is->clock[IS_CLK_ISP_DIV1], 68 * 1000000);
>> +       ret |= clk_set_rate(is->clock[IS_CLK_ISP_DIVMPWM], 34 * 1000000);
>> +
>> +       if (ret)
>> +               return -EINVAL;
>> +
>> +       return 0;
>> +}
>> +
>> +static int fimc_is_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev = &pdev->dev;
>> +       struct resource res;
>> +       struct fimc_is *is;
>> +       struct pinctrl *pctrl;
>> +       void __iomem *regs;
>> +       struct device_node *node;
>> +       int irq, ret;
>> +
>> +       pr_debug("FIMC-IS Probe Enter\n");
>> +
>> +       if (!pdev->dev.of_node)
>> +               return -ENODEV;
>> +
>> +       is = devm_kzalloc(&pdev->dev, sizeof(*is), GFP_KERNEL);
>> +       if (!is)
>> +               return -ENOMEM;
>> +
>> +       is->pdev = pdev;
>> +
>> +       ret = of_address_to_resource(dev->of_node, 0, &res);
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       regs = devm_ioremap_resource(dev, &res);
>> +       if (regs == NULL) {
>
> Please use if(IS_ERR(regs))
>
>> +               dev_err(dev, "Failed to obtain io memory\n");
>
> This is not needed as devm_ioremap_resource prints the appropriate
> error messages.
>
>> +               return -ENOENT;
>
> return PTR_ERR(regs);
>
> Don't forget to include <linux/err.h> for using PTR_ERR() .
>
> --
> With warm regards,
> Sachin

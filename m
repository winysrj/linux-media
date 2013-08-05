Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:48121 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3HEKHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 06:07:00 -0400
MIME-Version: 1.0
In-Reply-To: <51FD78F8.4080304@gmail.com>
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
	<1375455762-22071-2-git-send-email-arun.kk@samsung.com>
	<51FD78F8.4080304@gmail.com>
Date: Mon, 5 Aug 2013 15:36:59 +0530
Message-ID: <CALt3h7_qHb4UqsnVo+KPtHFdL42AShkKo5-V3qPaPrMUOANpGg@mail.gmail.com>
Subject: Re: [RFC v3 01/13] [media] exynos5-is: Adding media device driver for exynos5
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the review.
Will address all your review comments.
Some responses below:

[snip]
>> +
>> +static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
>> +{
>> +       struct device_node *of_node = fmd->pdev->dev.of_node;
>> +       int ret;
>> +
>> +       /*
>> +        * Runtime resume one of the FIMC entities to make sure
>> +        * the sclk_cam clocks are not globally disabled.
>
>
> It's a bit mysterious to me, is this requirement still valid on Exynos5 ?
> I glanced over the Exynos5250 datasheet and there seem to be no sclk_cam?
> clocks dependency on any of GScaler clocks. Maybe you don't need a clock
> provider in this driver, perhaps sensor drivers could use sclk_cam clocks
> directly, assigned through dts ?
>

Yes these clocks can be directly exposed via dt.
I will drop clock provider from this driver.

[snip]

>> +/*
>> + * The peripheral sensor clock management.
>> + */
>> +static void fimc_md_put_clocks(struct fimc_md *fmd)
>> +{
>> +       int i = FIMC_MAX_CAMCLKS;
>> +
>> +       while (--i>= 0) {
>> +               if (IS_ERR(fmd->camclk[i].clock))
>> +                       continue;
>> +               clk_put(fmd->camclk[i].clock);
>> +               fmd->camclk[i].clock = ERR_PTR(-EINVAL);
>> +       }
>
>
> Please double check if you need this sclk_cam clocks handling. We could
> simply add a requirement that this driver supports only sensor subdevs
> through the v4l2-async API and which controls their clock themselves.
>

sclk_cam* handling can be removed and be done from respective
sensors. But I think the sclk_bayer handling needs to be retained in the
media driver.

>> +}
>> +
>> +static int fimc_md_get_clocks(struct fimc_md *fmd)
>> +{
>> +       struct device *dev = NULL;
>> +       char clk_name[32];
>> +       struct clk *clock;
>> +       int i, ret = 0;
>> +
>> +       for (i = 0; i<  FIMC_MAX_CAMCLKS; i++)
>> +               fmd->camclk[i].clock = ERR_PTR(-EINVAL);
>> +
>> +       if (fmd->pdev->dev.of_node)
>> +               dev =&fmd->pdev->dev;
>> +
>> +       for (i = 0; i<  SCLK_BAYER; i++) {
>> +               snprintf(clk_name, sizeof(clk_name), "sclk_cam%u", i);
>> +               clock = clk_get(dev, clk_name);
>> +
>> +               if (IS_ERR(clock)) {
>> +                       dev_err(&fmd->pdev->dev, "Failed to get clock:
>> %s\n",
>> +                                                               clk_name);
>> +                       ret = PTR_ERR(clock);
>> +                       break;
>> +               }
>> +               fmd->camclk[i].clock = clock;
>> +       }
>> +       if (ret)
>> +               fimc_md_put_clocks(fmd);
>> +
>> +       /* Prepare bayer clk */
>> +       clock = clk_get(dev, "sclk_bayer");
>> +
>> +       if (IS_ERR(clock)) {
>> +               dev_err(&fmd->pdev->dev, "Failed to get clock: %s\n",
>> +                                                       clk_name);
>
>
> Wrong error message.
>
>> +               ret = PTR_ERR(clock);
>> +               goto err_exit;
>> +       }
>> +       ret = clk_prepare(clock);
>> +       if (ret<  0) {
>> +               clk_put(clock);
>> +               fmd->camclk[SCLK_BAYER].clock = ERR_PTR(-EINVAL);
>> +               goto err_exit;
>> +       }
>> +       fmd->camclk[SCLK_BAYER].clock = clock;
>
>
> Could you explain a bit how is this SCLK_BAYER clock used ? Is it routed
> to external image sensor, or is it used only inside an SoC ?
>

It is not defined properly in the manual, but I suppose its the bus clock
for the bayer rgb data bus. So for proper sensor functionality, we need this
sclk_bayer in addition to the external sensor clks (sclk_cam*). Isn't
exynos5 media driver is the best place to handle such clocks?

>> +       return 0;
>> +err_exit:
>> +       fimc_md_put_clocks(fmd);
>> +       return ret;
>> +}
>> +

Regards
Arun

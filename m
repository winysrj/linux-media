Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47884 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab3B0PcT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 10:32:19 -0500
Received: by mail-wi0-f181.google.com with SMTP id hm6so831554wib.8
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 07:32:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512DEC6C.60607@samsung.com>
References: <51275DF7.4010600@gmail.com>
	<512D2780.3020103@gmail.com>
	<CAG17yqQ3d+3Uwpfo+_r0Jwm4TQXcSY-bcW4qRcygzjq=9qXvvA@mail.gmail.com>
	<512DEC6C.60607@samsung.com>
Date: Wed, 27 Feb 2013 21:02:18 +0530
Message-ID: <CAG17yqRYF-DRDigQVfJ1nvt0x2evnX=dnNfL6FFxPWno+NGqMg@mail.gmail.com>
Subject: Re: SMDKV210 support issue in kernel 3.8 (dma-pl330 and HDMI failed)
From: Inderpal Singh <inderpal.singh@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Lonsn <lonsn2005@gmail.com>, linux-samsung-soc@vger.kernel.org,
	linux-media@vger.kernel.org, Boojin Kim <boojin.kim@samsung.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27 February 2013 16:52, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> On 02/27/2013 11:51 AM, Inderpal Singh wrote:
>> On 27 February 2013 02:52, Sylwester Nawrocki
>> <sylvester.nawrocki@gmail.com> wrote:
>>> On 02/22/2013 01:00 PM, Lonsn wrote:
>>>>
>>>> Hi,
>>>> I have tested the kernel 3.8 with a SMDKV210 like board. But I failed
>>>> with dma-pl330 and HDMI driver.
>>>> For dma-pl330, kernel print:
>>>> dma-pl330 dma-pl330.0: PERIPH_ID 0x0, PCELL_ID 0x0 !
>>>> dma-pl330: probe of dma-pl330.0 failed with error -22
>>>> dma-pl330 dma-pl330.1: PERIPH_ID 0x0, PCELL_ID 0x0 !
>>>> dma-pl330: probe of dma-pl330.1 failed with error -22
>>>
>>>
>>> Maybe there is some issue with the PL330 DMA controller clocks and the
>>> read values are all 0 because the clocks are disabled ?
>>>
>>> It seems arch/arm/mach-s5pv210/clock.c might be missing "apb_pclk" clock
>>> supply names, which I suspect may be required after commits:
>>>
>>> commit 7c71b8eb268ee38235f7e924d943ea9d90e59469
>>> Author: Inderpal Singh <inderpal.singh@linaro.org>
>>> Date:   Fri Sep 7 12:14:48 2012 +0530
>>>
>>>     DMA: PL330: Remove redundant runtime_suspend/resume functions
>>>
>>>     The driver's  runtime_suspend/resume functions just disable/enable
>>>     the clock which is already being managed at AMBA bus level
>>>     runtime_suspend/resume functions.
>>>
>>>     Hence, remove the driver's runtime_suspend/resume functions.
>>>
>>>     Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
>>>     Tested-by: Chander Kashyap <chander.kashyap@linaro.org>
>>>     Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
>>>
>>> commit faf6fbc6f2ca3b34bf464a8bb079a998e571957c
>>> Author: Inderpal Singh <inderpal.singh@linaro.org>
>>> Date:   Fri Sep 7 12:14:47 2012 +0530
>>>
>>>     DMA: PL330: Remove controller clock enable/disable
>>>
>>>     The controller clock is being enabled/disabled in AMBA bus
>>>     infrastructre in probe/remove functions. Hence, its not required
>>>     at driver level probe/remove.
>>>
>>>     Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
>>>     Tested-by: Chander Kashyap <chander.kashyap@linaro.org>
>>>     Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
>>>
>>> I have added people who made related changes at Cc, hopefully they
>>> can provide some help in debugging this.
>>>
>>
>> The mentioned patches just removed the redundant clock enable/disable
>> from the driver as clock is already being managed at amba bus level in
>> the same code path. As per my understanding the issue should come even
>> without these patches.
>
> But were the clocks managed directly by the pl330 driver same as those
> managed at amba bus level ? The first patch as above removed chunk
>
> @@ -2887,24 +2884,17 @@ pl330_probe(struct amba_device *adev, const struct
> amba_id *id)
>                 goto probe_err1;
>         }
>
> -       pdmac->clk = clk_get(&adev->dev, "dma");
> -       if (IS_ERR(pdmac->clk)) {
> -               dev_err(&adev->dev, "Cannot get operation clock.\n");
> -               ret = -EINVAL;
> -               goto probe_err2;
> -       }
> -
>
> which suggest the driver was enabling directly "dma" clocks, defined at
> S5PV210 platform level as:
>
>         {
>                 .name           = "dma",
>                 .devname        = "dma-pl330.0",
>                 .parent         = &clk_hclk_psys.clk,
>                 .enable         = s5pv210_clk_ip0_ctrl,
>                 .ctrlbit        = (1 << 3),
>         }, {
>                 .name           = "dma",
>                 .devname        = "dma-pl330.1",
>                 .parent         = &clk_hclk_psys.clk,
>                 .enable         = s5pv210_clk_ip0_ctrl,
>                 .ctrlbit        = (1 << 4),
>         }, {
>
> And amba bus was getting only dummy clocks behind "apb_pclk" clock
> conn_id.
>

Ahh Yes, I had missed this point. So the changes you suggested needs
to be done as confirmed by Lonsn.

Thanks Lonsn for bringing this up :-)

Regards,
Inder

>> @Lonsn: Can you please test without these patches?
>
> I suspect reverting only patch
> DMA: PL330: Remove redundant runtime_suspend/resume functions
> with PM_RUNTIME enabled might fix the issue.
>
> --
>
> Regards,
> Sylwester

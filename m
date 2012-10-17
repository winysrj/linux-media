Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34246 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2JQP5h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 11:57:37 -0400
Message-id: <507ED56E.1000406@samsung.com>
Date: Wed, 17 Oct 2012 17:57:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	"Turquette, Mike" <mturquette@ti.com>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 1/8] [media] s5p-fimc: Use clk_prepare_enable and
 clk_disable_unprepare
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
 <507EC1BF.6040107@samsung.com>
 <CAK9yfHymckQLOp=xavQ1sj5uJKRg7tFMXgvo68Dp8GL6N9g0JQ@mail.gmail.com>
In-reply-to: <CAK9yfHymckQLOp=xavQ1sj5uJKRg7tFMXgvo68Dp8GL6N9g0JQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2012 05:35 PM, Sachin Kamat wrote:
>> Most of the s5p-* drivers have already added support for clk_(un)prepare.
>> Thus most of your changes in this patch are not needed. I seem to have only
>> missed fimc-mdevice.c, other modules are already reworked
> 
> I did not find these changes in your tree. Please let me know the
> branch where these changes are available.

Are in Linus' tree, for quite long already, commits:

11a37c709797cc56f48905e68a3099b79cf08850
[media] s5p-g2d: Added support for clk_prepare

bd7d8888e99d67f778f4ee272346322c0b9cb378
[media] s5p-fimc: convert to clk_prepare()/clk_unprepare()

eb732518e0db585376f95256b18b2149240e3ad3
[media] s5p-mfc: Added support for clk_prepare

Please note there was the media drivers reorganization recently, e.g.
drivers/media/video/s5p-* changed to drivers/media/platform/s5p-*.

>> $ git grep -5  clk_prepare  -- drivers/media/platform/s5p-fimc
>> drivers/media/platform/s5p-fimc/fimc-core.c-
>> drivers/media/platform/s5p-fimc/fimc-core.c-    for (i = 0; i < MAX_FIMC_CLOCKS; i++) {
>> drivers/media/platform/s5p-fimc/fimc-core.c-            fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clocks[i]);
>> drivers/media/platform/s5p-fimc/fimc-core.c-            if (IS_ERR(fimc->clock[i]))
> 
>>> I would prefer you have added the required changes at fimc_md_get_clocks()
>> and fimc_md_put_clocks() functions.
> 
> Ok. I will check this.

Thanks.

--
Regards,
Sylwester

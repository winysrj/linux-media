Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50876
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752308AbdATNhD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 08:37:03 -0500
Subject: Re: [PATCH 2/2] [media] exynos-gsc: Fix imprecise external abort due
 disabled power domain
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
References: <1484699402-28738-1-git-send-email-javier@osg.samsung.com>
 <CGME20170118003022epcas3p34cf03bb6feb830c4fa231497f2536d0e@epcas3p3.samsung.com>
 <1484699402-28738-2-git-send-email-javier@osg.samsung.com>
 <cc9c6837-7141-b63c-ddf6-68252493df11@samsung.com>
 <842737f2-3faf-7b22-c480-93e183bbb670@osg.samsung.com>
 <20ecbcee-0dfd-04f6-a855-e117ba05732f@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5d223b5f-585d-c6a0-0773-d9e42ec3f3a9@osg.samsung.com>
Date: Fri, 20 Jan 2017 10:36:46 -0300
MIME-Version: 1.0
In-Reply-To: <20ecbcee-0dfd-04f6-a855-e117ba05732f@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 01/20/2017 05:08 AM, Marek Szyprowski wrote:

[snip]

>>
>> This seems to be caused by some needed clocks to access the power domains
>> to be gated, since I don't get these erros when passing clk_ignore_unused
>> as parameter in the kernel command line.
> 
> I think that those issues were fixes by the following patch:
> https://patchwork.kernel.org/patch/9484607/
> It still didn't reach mainline, but I hope it will go as a fix to v4.10.
> 

Argh, I missed on a first read that the patch you mentioned already marks
CLK_ACLK432_SCALER as CLK_IS_CRITICAL. So please also ignore my clk patch.

Sorry for the noise and the mess with these patches. Thought I also tested
on linux-next to see if the issue was solved there, but it seems I didn't.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America

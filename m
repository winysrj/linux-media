Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50480
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751712AbdATKqi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 05:46:38 -0500
Subject: Re: [PATCH 2/2] [media] exynos-gsc: Fix imprecise external abort due
 disabled power domain
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
References: <1484699402-28738-1-git-send-email-javier@osg.samsung.com>
 <CGME20170118003022epcas3p34cf03bb6feb830c4fa231497f2536d0e@epcas3p3.samsung.com>
 <1484699402-28738-2-git-send-email-javier@osg.samsung.com>
 <cc9c6837-7141-b63c-ddf6-68252493df11@samsung.com>
 <842737f2-3faf-7b22-c480-93e183bbb670@osg.samsung.com>
 <d727576a-fbce-eb54-3b74-270c689b7fa3@osg.samsung.com>
 <c1d00b28-0252-0fb1-eb7c-5fc69035f12f@samsung.com>
 <c72965a4-d6e0-f3e7-1140-039274f7e60b@osg.samsung.com>
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
Message-ID: <042e9067-7ef1-c942-0341-634963ff3fb0@osg.samsung.com>
Date: Fri, 20 Jan 2017 07:46:29 -0300
MIME-Version: 1.0
In-Reply-To: <c72965a4-d6e0-f3e7-1140-039274f7e60b@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 01/20/2017 07:06 AM, Javier Martinez Canillas wrote:
> Hello Marek,
> 
> On 01/20/2017 05:37 AM, Marek Szyprowski wrote:
> 
> [snip]
>>
>> Please send this patch instead of adding more clocks to the power domains.
>> This way we will avoid adding more dependencies to userspace (DT ABI).
>> Likely those clocks are also needed to access any device in that power
>> domains.
>>
>> Later, once the runtime PM for clocks get merged, a patch for exynos542x
>> clocks driver can be made to replace IS_CRITICAL with proper runtime
>> handling.
>>
> 
> Ok, I thought that we didn't want to mark more clocks as CLK_IGNORE_UNUSED
> or CLK_IS_CRITICAL but I agree this can be done as a temporary workaround
> until a proper runtime PM based solution gets merged.
> 

I posted following patch [0] for clk-exynos5420, so $SUBJECT can be dropped.

[0]: https://patchwork.kernel.org/patch/9527957/

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America

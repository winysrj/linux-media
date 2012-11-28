Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53586 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2K1DeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 22:34:15 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so9737573vcm.19
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2012 19:34:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B54C70.8030607@gmail.com>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
	<50B54C70.8030607@gmail.com>
Date: Wed, 28 Nov 2012 09:04:14 +0530
Message-ID: <CAK9yfHzwcS97KVsFUKOUC-U33U_JOyTQ0FA2JmNAsXyTwk-oeg@mail.gmail.com>
Subject: Re: [PATCH 0/9] [media] s5p-tv: Checkpatch Fixes and cleanup
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: t.stanislaws@samsung.com, linux-media@vger.kernel.org,
	s.nawrocki@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28 November 2012 04:57, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 11/26/2012 05:48 AM, Sachin Kamat wrote:
>>
>> Build tested based on samsung/for_v3.8 branch of
>> git://linuxtv.org/snawrocki/media.git tree.
>
>
> How about testing it on Origen board ?

I wanted to but could not due to hardware setup problem.
I will see if I can get it up today (I am off for the rest of the week).

>
> Tomasz, are you OK with this patch series ?
>
> As a side note, for v3.9, when common clock framework support for the Exynos
> platforms is merged this driver will need to have clk_(un)prepare added.
> It will fail to initialize otherwise.
>
>
>> Sachin Kamat (9):
>>    [media] s5p-tv: Add missing braces around sizeof in sdo_drv.c
>>    [media] s5p-tv: Add missing braces around sizeof in mixer_video.c
>>    [media] s5p-tv: Add missing braces around sizeof in mixer_reg.c
>>    [media] s5p-tv: Add missing braces around sizeof in mixer_drv.c
>>    [media] s5p-tv: Add missing braces around sizeof in hdmiphy_drv.c
>>    [media] s5p-tv: Add missing braces around sizeof in hdmi_drv.c
>>    [media] s5p-tv: Use devm_clk_get APIs in sdo_drv.c
>>    [media] s5p-tv: Use devm_* APIs in mixer_drv.c
>>    [media] s5p-tv: Use devm_clk_get APIs in hdmi_drv
>>
>>   drivers/media/platform/s5p-tv/hdmi_drv.c    |   28 +++------
>>   drivers/media/platform/s5p-tv/hdmiphy_drv.c |    2 +-
>>   drivers/media/platform/s5p-tv/mixer_drv.c   |   87
>> +++++++--------------------
>>   drivers/media/platform/s5p-tv/mixer_reg.c   |    6 +-
>>   drivers/media/platform/s5p-tv/mixer_video.c |   18 +++---
>>   drivers/media/platform/s5p-tv/sdo_drv.c     |   43 ++++---------
>>   6 files changed, 57 insertions(+), 127 deletions(-)
>
>
> --
>
> Thanks,
> Sylwester



-- 
With warm regards,
Sachin

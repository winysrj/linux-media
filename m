Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54007 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2LCKSN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 05:18:13 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MEG009OM9YLGE40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Dec 2012 10:20:58 +0000 (GMT)
Received: from [106.116.147.108] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MEG00LAJ9YBPC60@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Dec 2012 10:18:11 +0000 (GMT)
Message-id: <50BC7C61.60207@samsung.com>
Date: Mon, 03 Dec 2012 11:18:09 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH 0/9] [media] s5p-tv: Checkpatch Fixes and cleanup
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
 <50B54C70.8030607@gmail.com>
 <CAK9yfHzwcS97KVsFUKOUC-U33U_JOyTQ0FA2JmNAsXyTwk-oeg@mail.gmail.com>
 <CAK9yfHwue=Gb8O=mUpOVMR0PO6Ve+e=j_JNCRHP3ORh=mebh3w@mail.gmail.com>
 <CAK9yfHxEiz_W+QnhsdkyAxazCK4-0fkgOywPN=kiVX7-aTV5zg@mail.gmail.com>
In-reply-to: <CAK9yfHxEiz_W+QnhsdkyAxazCK4-0fkgOywPN=kiVX7-aTV5zg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2012 05:28 AM, Sachin Kamat wrote:
> On 28 November 2012 11:33, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> 
>>>> How about testing it on Origen board ?
>>>
>>> I wanted to but could not due to hardware setup problem.
>>> I will see if I can get it up today (I am off for the rest of the week).
>>
>> Tested this series with test application on Origen. Works fine.
>>
>>>
>>>>
>>>> Tomasz, are you OK with this patch series ?

Hi Sachin Kamat,
I am OK with patches from "s5p-tv: Add missing braces around sizeof in ..." family.
You can add my Acked-by to them.

The devm_clk patches should be postponed until s5p-tv gets integrated with
clk_prepare/unprepare stuff.

Regards,
Tomasz Stanislawski


> 
> Hi Tomasz,
> 
> Any comments on this series?
> 
> Regards,
> Sachin
> 
> 
>>>>
>>>>
>>>>> Sachin Kamat (9):
>>>>>    [media] s5p-tv: Add missing braces around sizeof in sdo_drv.c
>>>>>    [media] s5p-tv: Add missing braces around sizeof in mixer_video.c
>>>>>    [media] s5p-tv: Add missing braces around sizeof in mixer_reg.c
>>>>>    [media] s5p-tv: Add missing braces around sizeof in mixer_drv.c
>>>>>    [media] s5p-tv: Add missing braces around sizeof in hdmiphy_drv.c
>>>>>    [media] s5p-tv: Add missing braces around sizeof in hdmi_drv.c
>>>>>    [media] s5p-tv: Use devm_clk_get APIs in sdo_drv.c
>>>>>    [media] s5p-tv: Use devm_* APIs in mixer_drv.c
>>>>>    [media] s5p-tv: Use devm_clk_get APIs in hdmi_drv
>>>>>
> 
> 
> 


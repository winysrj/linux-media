Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41223 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab2LCE26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2012 23:28:58 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so1408474vcd.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 20:28:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK9yfHwue=Gb8O=mUpOVMR0PO6Ve+e=j_JNCRHP3ORh=mebh3w@mail.gmail.com>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
	<50B54C70.8030607@gmail.com>
	<CAK9yfHzwcS97KVsFUKOUC-U33U_JOyTQ0FA2JmNAsXyTwk-oeg@mail.gmail.com>
	<CAK9yfHwue=Gb8O=mUpOVMR0PO6Ve+e=j_JNCRHP3ORh=mebh3w@mail.gmail.com>
Date: Mon, 3 Dec 2012 09:58:57 +0530
Message-ID: <CAK9yfHxEiz_W+QnhsdkyAxazCK4-0fkgOywPN=kiVX7-aTV5zg@mail.gmail.com>
Subject: Re: [PATCH 0/9] [media] s5p-tv: Checkpatch Fixes and cleanup
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28 November 2012 11:33, Sachin Kamat <sachin.kamat@linaro.org> wrote:

>>> How about testing it on Origen board ?
>>
>> I wanted to but could not due to hardware setup problem.
>> I will see if I can get it up today (I am off for the rest of the week).
>
> Tested this series with test application on Origen. Works fine.
>
>>
>>>
>>> Tomasz, are you OK with this patch series ?

Hi Tomasz,

Any comments on this series?

Regards,
Sachin


>>>
>>>
>>>> Sachin Kamat (9):
>>>>    [media] s5p-tv: Add missing braces around sizeof in sdo_drv.c
>>>>    [media] s5p-tv: Add missing braces around sizeof in mixer_video.c
>>>>    [media] s5p-tv: Add missing braces around sizeof in mixer_reg.c
>>>>    [media] s5p-tv: Add missing braces around sizeof in mixer_drv.c
>>>>    [media] s5p-tv: Add missing braces around sizeof in hdmiphy_drv.c
>>>>    [media] s5p-tv: Add missing braces around sizeof in hdmi_drv.c
>>>>    [media] s5p-tv: Use devm_clk_get APIs in sdo_drv.c
>>>>    [media] s5p-tv: Use devm_* APIs in mixer_drv.c
>>>>    [media] s5p-tv: Use devm_clk_get APIs in hdmi_drv
>>>>



-- 
With warm regards,
Sachin

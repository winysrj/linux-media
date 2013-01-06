Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:61553 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab3AFNPs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2013 08:15:48 -0500
Received: by mail-ee0-f44.google.com with SMTP id b47so9082029eek.3
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 05:15:47 -0800 (PST)
Message-ID: <50E97900.4060100@gmail.com>
Date: Sun, 06 Jan 2013 14:15:44 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Tushar Behera <tushar.behera@linaro.org>
Subject: Re: [GIT PULL FOR 3.9] Exynos SoC media drivers updates
References: <50E726F4.7060704@samsung.com> <50E96F6D.9080206@gmail.com> <20130106104157.5ffb5f6c@redhat.com> <201301061353.52306.hverkuil@xs4all.nl>
In-Reply-To: <201301061353.52306.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/2013 01:53 PM, Hans Verkuil wrote:
>>>>>> Tomasz Stanislawski (1):
>>>>>>          s5p-tv: mixer: fix handling of VIDIOC_S_FMT
>>>>
>>>> I'll drop this one for now. Devin raised a point: such changes would break
>>>> existing applications.
>>>>
>>>> So, we'll need to revisit this topic before changing the drivers.
>>>>
>>>> Btw, I failed to find the corresponding patch at patchwork:
>>>> 	http://patchwork.linuxtv.org/project/linux-media/list/?state=*&q=VIDIOC_S_FMT
>>>>
>>>> So, its status update may be wrong after flushing your pwclient commands.
>>>
>>> Hmm, I got this patch from Tomasz by e-mail and added it to the pull
>>> request.
>>> I think it wasn't sent to the mailing list, but I noticed it only after
>>> sending you the pull requests, when was preparing the pwclient commands.
>>> I've just posted it now, sorry. The link is here:
>>> http://patchwork.linuxtv.org/patch/16143
>>>
>>> Tomasz created this patch specifically for the purpose of format negotiation
>>> in video pipeline in the application we used to test various scenarios with
>>> DMABUF. I agree this patch has a potential of breaking buggy user space
>>> applications. I can't see other solution for it right now, there seems even
>>> to be no possibility to return some flag in VIDIOC_S_FMT indicating that
>>> format has been modified and is valid, when -EINVAL was returned. This
>>> sounds
>>> ugly anyway, but could ensure backward compatibility for applications that
>>> exppect EINVAL when format has been changed. BTW, I wonder if it is only
>>> fourcc,
>>> or other format parameters as well - like width, height, some applications
>>> expect to get EINVAL when those have changed.
>>
>> The patch makes the driver compliant to v4l-compilance, as its behavior asks
>> for such change, after some discussions we had this year in San Diego. At that
>> time, we all believed that such change were safe.
>>
>> However, we can't do it like proposed there (and on other patches from Hans).
>>
>> The fact is that tvtime and mythtv applications (maybe more) will fail
>> if the returned format is different than the requested ones, as they
>> don't check for the returned value.
>>
>> As no regressions on userspace are allowed, we need to re-discuss this issue.
>>
>> While this doesn't happen, I'll postpone such patches.
>
> This is a video output device. So this patch will never affect tvtime/mythtv/etc.
> I have no problem with this change being merged.

TBH, I very much doubt anyone would complain in case of this driver. I'm not
certain if there is complete support for even one board in the mainline 
kernel,
likely only Origen A. AFAIK most applications use either Exynos DRM driver,
that has support for all features available in s5p-tv driver, or 
framebuffer
emulation on top of v4l2 output interface (there were in the past RFC 
patches
posted for vb2 adding FB emulation) is used. Although I agree with Mauro in
principle, I think chances of above patch causing any trouble to anyone are
close to zero.

--

Regards,
Sylwester

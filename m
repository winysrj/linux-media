Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:48316 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab3AFMe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2013 07:34:58 -0500
Received: by mail-ea0-f170.google.com with SMTP id d11so7281063eaa.1
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 04:34:56 -0800 (PST)
Message-ID: <50E96F6D.9080206@gmail.com>
Date: Sun, 06 Jan 2013 13:34:53 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [GIT PULL FOR 3.9] Exynos SoC media drivers updates
References: <50E726F4.7060704@samsung.com> <50E75A10.8090906@gmail.com> <20130106093246.36f959da@redhat.com>
In-Reply-To: <20130106093246.36f959da@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/2013 12:32 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 04 Jan 2013 23:39:12 +0100
> Sylwester Nawrocki<sylvester.nawrocki@gmail.com>  escreveu:
>
>
>>> Tomasz Stanislawski (1):
>>>         s5p-tv: mixer: fix handling of VIDIOC_S_FMT
>
> I'll drop this one for now. Devin raised a point: such changes would break
> existing applications.
>
> So, we'll need to revisit this topic before changing the drivers.
>
> Btw, I failed to find the corresponding patch at patchwork:
> 	http://patchwork.linuxtv.org/project/linux-media/list/?state=*&q=VIDIOC_S_FMT
>
> So, its status update may be wrong after flushing your pwclient commands.

Hmm, I got this patch from Tomasz by e-mail and added it to the pull 
request.
I think it wasn't sent to the mailing list, but I noticed it only after
sending you the pull requests, when was preparing the pwclient commands.
I've just posted it now, sorry. The link is here:
http://patchwork.linuxtv.org/patch/16143

Tomasz created this patch specifically for the purpose of format negotiation
in video pipeline in the application we used to test various scenarios with
DMABUF. I agree this patch has a potential of breaking buggy user space
applications. I can't see other solution for it right now, there seems even
to be no possibility to return some flag in VIDIOC_S_FMT indicating that
format has been modified and is valid, when -EINVAL was returned. This 
sounds
ugly anyway, but could ensure backward compatibility for applications that
exppect EINVAL when format has been changed. BTW, I wonder if it is only 
fourcc,
or other format parameters as well - like width, height, some applications
expect to get EINVAL when those have changed.


Regards,
Sylwester

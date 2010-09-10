Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab0IJMPA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 08:15:00 -0400
Message-ID: <4C8A2154.8090401@redhat.com>
Date: Fri, 10 Sep 2010 09:15:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <p.osciak@samsung.com>, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, t.fujak@samsung.com
Subject: Re: [PATCH/RFC v1 0/7] Videobuf2 framework
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com> <4C891F0D.2060103@redhat.com> <4C89A3EE.8040503@samsung.com> <4C89B3AD.1010404@redhat.com> <4C89E084.6090203@samsung.com>
In-Reply-To: <4C89E084.6090203@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 10-09-2010 04:38, Marek Szyprowski escreveu:
> Hello,
> 
> On 2010-09-10 13:27, Mauro Carvalho Chehab wrote:
> 
>>>> 1) it lacks implementation of read() method. This means that vivi driver
>>>> has a regression, as it currently supports it.
>>>
>>> Yes, read() is not yet implemented. I guess it is not a feature that would
>>> be deprecated, right?
>>
>> Yes, there are no plans to deprecate it. Also, some devices like cx88 and bttv
>> allows receiving simultaneous streams, one via mmap, and another via read().
>> This is used by some applications to allow recording video via ffmpeg/mencoder
>> using read(), while the main application is displaying video using mmap.
> 
> Well, in my opinion such devices should provide two separate /dev/videoX nodes rather than hacking with mmap and read access types.

Why? V4L2 API allows to have multiple applications opening and streaming. There's nothing
wrong with that, since it is a common practice in Unix to allow multiple opens for the same
device.

Cheers,
Mauro

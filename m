Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab2ETPaQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 11:30:16 -0400
Message-ID: <4FB90DF9.7030404@redhat.com>
Date: Sun, 20 May 2012 12:30:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [GIT PULL FOR 3.5] s5p-fimc driver updates
References: <4FA3F635.60409@samsung.com> <4FAB80D5.50500@samsung.com> <4FB17B79.2000207@gmail.com> <4FB8E608.108@redhat.com> <4FB8FA24.3050008@gmail.com>
In-Reply-To: <4FB8FA24.3050008@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-05-2012 11:05, Sylwester Nawrocki escreveu:
> On 05/20/2012 02:39 PM, Mauro Carvalho Chehab wrote:
>> Em 14-05-2012 18:39, Sylwester Nawrocki escreveu:
>>> On 05/10/2012 10:48 AM, Sylwester Nawrocki wrote:
>>>> On 05/04/2012 05:31 PM, Sylwester Nawrocki wrote:
> ...
>>>> The following changes since commit ae45d3e9aea0ab951dbbca2238fbfbf3993f1e7f:
>>>>
>>>>     s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS (2012-05-09 16:07:49 +0200)
>>>>
>>>> are available in the git repository at:
>>>>
>>>>     git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-exynos4x12
>>>>
>>>> for you to fetch changes up to 5feefe6656583de6fd4ef1d53b19031dd5efeec1:
>>>>
>>>>     s5p-fimc: Use selection API in place of crop operations (2012-05-09 16:11:29 +0200)
>>>>
>>>> ----------------------------------------------------------------
>>>> Sylwester Nawrocki (14):
>>>>         V4L: Extend V4L2_CID_COLORFX with more image effects
>>>>         s5p-fimc: Avoid crash with null platform_data
>>>>         s5p-fimc: Move m2m node driver into separate file
>>>
>>> It seems there is a conflict now with this patch:
>>> http://git.linuxtv.org/media_tree.git/commit/5126f2590bee412e3053de851cb07f531e4be36a
>>>
>>> Attached are updated versions of the two conflicting patches, the others
>>> don't need touching.
>>>
>>> I could provide rebased version of the whole change set tomorrow - if needed.
>>
>> Please do that, as this patch doesn't apply as-is.
> 
> I guess there is no intervention from my side needed, since you already applied
> those updated patches to the media tree (since I pushed the rebased patch to
> git.infradead.org a few days ago already) ?
> 
> However, there is going to be conflicts now with my patch from Sakari's pull
> request: http://patchwork.linuxtv.org/patch/11336.

Yes. I didn't apply that patch. It needs rework.

> 
> As we talked in #v4l IRC, even if the API is experimental, any changes to it
> must not cause build breaks. I didn't discuss that yet with Sakari.  I have 
> now reworked the renaming patch, so it now includes backward compatibility 
> definitions like this:
> 
> #define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
> #define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE 
> 
> I would then make a patch for Documentation/feature-removal-schedule.txt
> to indicate those aliases will be removed after two kernel releases.
> 
> Does it sound like a right thing to do ?

_If_ 3.5 is the first kernel with the selection API, we can fix it without 
a backward compat, but I think that the selection API went into 3.4 kernel
series.

Regards,
Mauro

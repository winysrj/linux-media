Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55641 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab2ETOF1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 10:05:27 -0400
Received: by bkcji2 with SMTP id ji2so3306301bkc.19
        for <linux-media@vger.kernel.org>; Sun, 20 May 2012 07:05:26 -0700 (PDT)
Message-ID: <4FB8FA24.3050008@gmail.com>
Date: Sun, 20 May 2012 16:05:24 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [GIT PULL FOR 3.5] s5p-fimc driver updates
References: <4FA3F635.60409@samsung.com> <4FAB80D5.50500@samsung.com> <4FB17B79.2000207@gmail.com> <4FB8E608.108@redhat.com>
In-Reply-To: <4FB8E608.108@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2012 02:39 PM, Mauro Carvalho Chehab wrote:
> Em 14-05-2012 18:39, Sylwester Nawrocki escreveu:
>> On 05/10/2012 10:48 AM, Sylwester Nawrocki wrote:
>>> On 05/04/2012 05:31 PM, Sylwester Nawrocki wrote:
...
>>> The following changes since commit ae45d3e9aea0ab951dbbca2238fbfbf3993f1e7f:
>>>
>>>     s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS (2012-05-09 16:07:49 +0200)
>>>
>>> are available in the git repository at:
>>>
>>>     git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-exynos4x12
>>>
>>> for you to fetch changes up to 5feefe6656583de6fd4ef1d53b19031dd5efeec1:
>>>
>>>     s5p-fimc: Use selection API in place of crop operations (2012-05-09 16:11:29 +0200)
>>>
>>> ----------------------------------------------------------------
>>> Sylwester Nawrocki (14):
>>>         V4L: Extend V4L2_CID_COLORFX with more image effects
>>>         s5p-fimc: Avoid crash with null platform_data
>>>         s5p-fimc: Move m2m node driver into separate file
>>
>> It seems there is a conflict now with this patch:
>> http://git.linuxtv.org/media_tree.git/commit/5126f2590bee412e3053de851cb07f531e4be36a
>>
>> Attached are updated versions of the two conflicting patches, the others
>> don't need touching.
>>
>> I could provide rebased version of the whole change set tomorrow - if needed.
> 
> Please do that, as this patch doesn't apply as-is.

I guess there is no intervention from my side needed, since you already applied
those updated patches to the media tree (since I pushed the rebased patch to
git.infradead.org a few days ago already) ?

However, there is going to be conflicts now with my patch from Sakari's pull
request: http://patchwork.linuxtv.org/patch/11336.

As we talked in #v4l IRC, even if the API is experimental, any changes to it
must not cause build breaks. I didn't discuss that yet with Sakari.  I have 
now reworked the renaming patch, so it now includes backward compatibility 
definitions like this:

#define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
#define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE 

I would then make a patch for Documentation/feature-removal-schedule.txt
to indicate those aliases will be removed after two kernel releases.

Does it sound like a right thing to do ?


Regards,
Sylwester

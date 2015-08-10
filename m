Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51773 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932201AbbHJKMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 06:12:07 -0400
Message-ID: <55C878DB.5080404@xs4all.nl>
Date: Mon, 10 Aug 2015 12:11:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com, inki.dae@samsung.com,
	sw0312.kim@samsung.com, nenggun.kim@samsung.com,
	sangbae90.lee@samsung.com, rany.kwon@samsung.com
Subject: Re: [RFC PATCH v2 0/5] Refactoring Videobuf2 for common use
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>	<55C86147.4090307@xs4all.nl> <20150810063255.2f087b24@recife.lan>
In-Reply-To: <20150810063255.2f087b24@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/10/2015 11:32 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 10 Aug 2015 10:31:03 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Jungsak,
>>
>> On 07/31/2015 10:44 AM, Junghak Sung wrote:
>>> Hello everybody,
>>>
>>> This is the 2nd round for refactoring Videobuf2(a.k.a VB2).
>>> The purpose of this patch series is to separate existing VB2 framework
>>> into core part and V4L2 specific part. So that not only V4L2 but also other
>>> frameworks can use them to manage buffer and utilize queue.
>>>
>>> Why do we try to make the VB2 framework to be common?
>>>
>>> As you may know, current DVB framework uses ringbuffer mechanism to demux
>>> MPEG-2 TS data and pass it to userspace. However, this mechanism requires
>>> extra memory copy because DVB framework provides only read() system call for
>>> application - read() system call copies the kernel data to user-space buffer.
>>> So if we can use VB2 framework which supports streaming I/O and buffer
>>> sharing mechanism, then we could enhance existing DVB framework by removing
>>> the extra memory copy - with VB2 framework, application can access the kernel
>>> data directly through mmap system call.
>>>
>>> We have a plan for this work as follows:
>>> 1. Separate existing VB2 framework into three parts - VB2 common, VB2-v4l2.
>>>    Of course, this change will not affect other v4l2-based
>>>    device drivers. This patch series corresponds to this step.
>>>
>>> 2. Add and implement new APIs for DVB streaming I/O.
>>>    We can remove unnecessary memory copy between kernel-space and user-space
>>>    by using these new APIs. However, we leaves legacy interfaces as-is
>>>    for backward compatibility.
>>>
>>> This patch series is the first step for it.
>>> The previous version of this patch series can be found at [1].
>>>
>>> [1] RFC PATCH v1 - http://www.spinics.net/lists/linux-media/msg90688.html
>>
>> This v2 looks much better, but, as per my comment to patch 1/5, it needs a bit
>> more work before I can do a really good review. I think things will be much
>> clearer once patch 3 shows the code moving from core.c/h to v4l2.c/h instead
>> of the other way around. That shouldn't be too difficult.
> 
> Hans,
> 
> I suggested Junkhak to do that. On his previous patchset, he did what
> you're suggestiong, e. g moving things from vb2-core into vb2-v4l2, and
> that resulted on patches big enough to not be catched by vger.

Actually, that wasn't the reason why the patches became so big. I just
reorganized the patch series as I suggested above (pretty easy to do) and
the size of patch 3 went down.

> Also, IMHO, it is cleared this way, as we can see what parts of VB2 will
> actually be shared, as there are lots of things that won't be shared:
> overlay, userptr, multiplanar.

That's why I prefer to see what moves *out* from the core.

To be honest, it depends on what your preference is.

Junghak, just leave the patch as-is. However, for v3 you should run
checkpatch.pl over the diff since it complained about various things.

Regards,

	Hans

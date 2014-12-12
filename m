Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39998 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934906AbaLLPar (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 10:30:47 -0500
Message-ID: <548B0A25.3060608@osg.samsung.com>
Date: Fri, 12 Dec 2014 08:30:45 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [REVIEW] au0828-video.c
References: <548AC061.3050700@xs4all.nl> <20141212104942.0ea3c1d7@recife.lan> <548AE5B2.1070306@xs4all.nl> <20141212111424.0595125b@recife.lan> <548B092F.2090803@osg.samsung.com> <548B09A5.80506@xs4all.nl>
In-Reply-To: <548B09A5.80506@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2014 08:28 AM, Hans Verkuil wrote:
> On 12/12/2014 04:26 PM, Shuah Khan wrote:
>> On 12/12/2014 06:14 AM, Mauro Carvalho Chehab wrote:
>>> Em Fri, 12 Dec 2014 13:55:14 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> On 12/12/2014 01:49 PM, Mauro Carvalho Chehab wrote:
>>>>> Em Fri, 12 Dec 2014 11:16:01 +0100
>>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>>>
>>>>>> Hi Shuah,
>>>>>>
>>>>>> This is the video.c review with your patch applied.
>>>>>>
>>>>>>> /*
>>>>>>>  * Auvitek AU0828 USB Bridge (Analog video support)
>>>>>>>  *
>>>>>>>  * Copyright (C) 2009 Devin Heitmueller <dheitmueller@linuxtv.org>
>>>>>>>  * Copyright (C) 2005-2008 Auvitek International, Ltd.
>>>>>>>  *
>>>>>>>  * This program is free software; you can redistribute it and/or
>>>>>>>  * modify it under the terms of the GNU General Public License
>>>>>>>  * As published by the Free Software Foundation; either version 2
>>>>>>>  * of the License, or (at your option) any later version.
>>>>>>>  *
>>>>>>>  * This program is distributed in the hope that it will be useful,
>>>>>>>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>>>>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>>>>  * GNU General Public License for more details.
>>>>>>>  *
>>>>>>>  * You should have received a copy of the GNU General Public License
>>>>>>>  * along with this program; if not, write to the Free Software
>>>>>>>  * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
>>>>>>>  * 02110-1301, USA.
>>>>>>>  */
>>>>>>>
>>>>>>> /* Developer Notes:
>>>>>>>  *
>>>>>>>  * VBI support is not yet working
>>>>>>
>>>>>> I'll see if I can get this to work quickly. If not, then we should
>>>>>> probably just strip the VBI support from this driver. It's pointless to
>>>>>> have non-functioning VBI support.
>>>>>
>>>>> This is a left-over. VBI support works on this driver. I tested.
>>>>
>>>> Oh wait, now I get it. You are only capturing line 21, not the whole vbi area.
>>>> That's why vbi_height = 1. Never mind then. Although that comment should indeed
>>>> be removed.
>>
>> Want me to remove the comment with this work or as a separate patch??
> 
> Separate, I think.
> 
>>
>>>>
>>>>>
>>>>> Probably, the patches that added VBI support forgot to remove the
>>>>> above notice.
>>>>>
>>>>>>> /* This function ensures that video frames continue to be delivered even if
>>>>>>>    the ITU-656 input isn't receiving any data (thereby preventing applications
>>>>>>>    such as tvtime from hanging) */
>>>>>>
>>>>>> Why would tvtime be hanging? Make a separate patch that just removes all this
>>>>>> timeout nonsense. If there are no frames, then tvtime (and any other app) should
>>>>>> just wait for frames to arrive. And ctrl-C should always be able to break the app
>>>>>> (or they can timeout themselves).
>>>>>>
>>>>>> It's not the driver's responsibility to do this and it only makes the code overly
>>>>>> complex.
>>>>>
>>>>> Well, we should not cause regressions on userspace. If removing this
>>>>> check will cause tvtime to hang, we should keep it.
>>>>
>>>> Obviously if it hangs (i.e. tvtime can't be killed anymore) it is a bug in the driver.
>>>> But the driver shouldn't start generating bogus frames just because no new frames are
>>>> arriving, that's just nuts.
>>>
>>> If I remember the bug well, what used to happen is that tvtime would wait
>>> for a certain amount of time for a frame. If nothing arrives, it stops
>>> capturing.
>>>
>>> The net effect is that tvtime shows no picture. This used to be so bad
>>> that tvtime didn't work with vivi at all.
>>>
>>> The bug used also to manifest there if lots of frames got dropped
>>> when, for example, changing from one channel to another.
>>>
>>> Btw, on a quick look, I'm not seeing any patch at tvtime since we took
>>> it over that would be fixing it. So, it was either a VB bug or the
>>> bug is still there.
>>>
>>>>
>>>>> Btw, the same kind of test used to be at vivi and other drivers.
>>>>> I think we removed it there some time ago, so maybe either it was a
>>>>> VB1 bug or this got fixed at tvtime.
>>>>
>>
>> I take it that we decided to keep the timeout handling for now.
> 
> No, tvtime no longer hangs if no frames arrive, so there is no need for
> this timeout handling. I'd strip it out, which can be done in a separate
> patch.
> 

Will do. This will reduce the complexity other drives don't have.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Open Source Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

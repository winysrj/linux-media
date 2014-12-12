Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:54312 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967608AbaLLMzY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 07:55:24 -0500
Message-ID: <548AE5B2.1070306@xs4all.nl>
Date: Fri, 12 Dec 2014 13:55:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [REVIEW] au0828-video.c
References: <548AC061.3050700@xs4all.nl> <20141212104942.0ea3c1d7@recife.lan>
In-Reply-To: <20141212104942.0ea3c1d7@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2014 01:49 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 12 Dec 2014 11:16:01 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Shuah,
>>
>> This is the video.c review with your patch applied.
>>
>>> /*
>>>  * Auvitek AU0828 USB Bridge (Analog video support)
>>>  *
>>>  * Copyright (C) 2009 Devin Heitmueller <dheitmueller@linuxtv.org>
>>>  * Copyright (C) 2005-2008 Auvitek International, Ltd.
>>>  *
>>>  * This program is free software; you can redistribute it and/or
>>>  * modify it under the terms of the GNU General Public License
>>>  * As published by the Free Software Foundation; either version 2
>>>  * of the License, or (at your option) any later version.
>>>  *
>>>  * This program is distributed in the hope that it will be useful,
>>>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>  * GNU General Public License for more details.
>>>  *
>>>  * You should have received a copy of the GNU General Public License
>>>  * along with this program; if not, write to the Free Software
>>>  * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
>>>  * 02110-1301, USA.
>>>  */
>>>
>>> /* Developer Notes:
>>>  *
>>>  * VBI support is not yet working
>>
>> I'll see if I can get this to work quickly. If not, then we should
>> probably just strip the VBI support from this driver. It's pointless to
>> have non-functioning VBI support.
> 
> This is a left-over. VBI support works on this driver. I tested.

Oh wait, now I get it. You are only capturing line 21, not the whole vbi area.
That's why vbi_height = 1. Never mind then. Although that comment should indeed
be removed.

> 
> Probably, the patches that added VBI support forgot to remove the
> above notice.
> 
>>> /* This function ensures that video frames continue to be delivered even if
>>>    the ITU-656 input isn't receiving any data (thereby preventing applications
>>>    such as tvtime from hanging) */
>>
>> Why would tvtime be hanging? Make a separate patch that just removes all this
>> timeout nonsense. If there are no frames, then tvtime (and any other app) should
>> just wait for frames to arrive. And ctrl-C should always be able to break the app
>> (or they can timeout themselves).
>>
>> It's not the driver's responsibility to do this and it only makes the code overly
>> complex.
> 
> Well, we should not cause regressions on userspace. If removing this
> check will cause tvtime to hang, we should keep it.

Obviously if it hangs (i.e. tvtime can't be killed anymore) it is a bug in the driver.
But the driver shouldn't start generating bogus frames just because no new frames are
arriving, that's just nuts.

> Btw, the same kind of test used to be at vivi and other drivers.
> I think we removed it there some time ago, so maybe either it was a
> VB1 bug or this got fixed at tvtime.

Most likely.

Regards,

	Hans


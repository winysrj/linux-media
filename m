Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264Ab0KPNGy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 08:06:54 -0500
Message-ID: <4CE281E8.3040705@redhat.com>
Date: Tue, 16 Nov 2010 11:06:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
References: <cover.1289740431.git.hverkuil@xs4all.nl>    <201011142253.29768.arnd@arndb.de>    <201011142348.51859.hverkuil@xs4all.nl>    <201011151017.41453.arnd@arndb.de>    <342eb735192f26a4a84488cad7f01068.squirrel@webmail.xs4all.nl>    <4CE276C9.3000802@redhat.com> <9bb4a78df49dbe30ca6382b6b5408129.squirrel@webmail.xs4all.nl>
In-Reply-To: <9bb4a78df49dbe30ca6382b6b5408129.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-11-2010 10:35, Hans Verkuil escreveu:
> 
>> Em 15-11-2010 07:49, Hans Verkuil escreveu:
>>>
>>>> On Sunday 14 November 2010 23:48:51 Hans Verkuil wrote:
>>>>> On Sunday, November 14, 2010 22:53:29 Arnd Bergmann wrote:
>>>>>> On Sunday 14 November 2010, Hans Verkuil wrote:
>>>>>>> This patch series converts 24 v4l drivers to unlocked_ioctl. These
>>>>> are low
>>>>>>> hanging fruit but you have to start somewhere :-)
>>>>>>>
>>>>>>> The first patch replaces mutex_lock in the V4L2 core by
>>>>> mutex_lock_interruptible
>>>>>>> for most fops.
>>>>>>
>>>>>> The patches all look good as far as I can tell, but I suppose the
>>>>> title is
>>>>>> obsolete now that the BKL has been replaced with a v4l-wide mutex,
>>>>> which
>>>>>> is what you are removing in the series.
>>>>>
>>>>> I guess I have to rename it, even though strictly speaking the branch
>>>>> I'm
>>>>> working in doesn't have your patch merged yet.
>>>>>
>>>>> BTW, replacing the BKL with a static mutex is rather scary: the BKL
>>>>> gives up
>>>>> the lock whenever you sleep, the mutex doesn't. Since sleeping is very
>>>>> common
>>>>> in V4L (calling VIDIOC_DQBUF will typically sleep while waiting for a
>>>>> new frame
>>>>> to arrive), this will make it impossible for another process to access
>>>>> any
>>>>> v4l2 device node while the ioctl is sleeping.
>>>>>
>>>>> I am not sure whether that is what you intended. Or am I missing
>>>>> something?
>>>>
>>>> I was aware that something like this could happen, but I apparently
>>>> misjudged how big the impact is. The general pattern for ioctls is that
>>>> those that get called frequently do not sleep, so it can almost always
>>>> be
>>>> called with a mutex held.
>>>
>>> True in general, but most definitely not true for V4L. The all important
>>> VIDIOC_DQBUF ioctl will almost always sleep.
>>>
>>> Mauro, I think this patch will have to be reverted and we just have to
>>> do
>>> the hard work ourselves.
>>
>> The VIDIOC_QBUF/VIDIOC_DQBUF ioctls are called after having the V4L device
>> ready
>> for stream. During the qbuf/dqbuf loop, the only other ioctls that may
>> appear are
>> the control change ioctl's, to adjust things like bright. I doubt that his
>> will
>> cause a really serious trouble.
> 
> Yes, it does. Anyone who is using multiple capture/output devices at the
> same time will be affected.

One correction to your comment:
	"Anyone that uses multiple capture/output devices that were not converted to unlocked ioctl will be affected."
This means that devices with multiple entries need to be fixed first.

> For example, anyone who uses the davinci
> dm6467 driver for both input and output. And yes, that's what we use at
> work. And ship to thousands of customers. Or think about surveillance
> applications where you are capturing from many streams simultaneously.

Cheers,
Mauro

Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab0ISSIu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 14:08:50 -0400
Message-ID: <4C9651A7.4010707@redhat.com>
Date: Sun, 19 Sep 2010 15:08:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC: BKL, locking and ioctls
References: <fm127xqs7xbmiabppyr1ifai.1284910330767@email.android.com> <201009191810.34189.hverkuil@xs4all.nl>
In-Reply-To: <201009191810.34189.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-09-2010 13:10, Hans Verkuil escreveu:
> On Sunday, September 19, 2010 17:38:18 Andy Walls wrote:
>> The device node isn't even the right place for drivers that provide multiple device nodes that can possibly access the same underlying data or register sets.
>>
>> Any core/infrastructure approach is likely doomed in the general case.  It's trying to protect data and registers in a driver it knows nothing about, by protecting the *code paths* that take essentially unknown actions on that data and registers. :{
> 
> Just to clarify: struct video_device gets a *pointer* to a mutex. The mutex
> itself can be either at the top-level device or associated with the actual
> video device, depending on the requirements of the driver.
> 
>> Videobuf is the right place to protect videobuf data.
> 
> vb_lock is AFAIK there to protect the streaming of data.

True, but part of this data is outside videobuf struct. So, a mutex inside videobuf is not enough.
See for example the tricks that bttv-driver need to do in order to protect data. I suspect that
there are even some race issues there, since it needs to unlock struct bttv in order to get videobuf
lock on some places.

> And that's definitely
> per device node since only one filehandle per device node can do streaming.

That's a wrong assumption. There are some drivers, like bttv, cx88 and saa7134 that allows streaming
on two separate file handlers, using the same device. This is valid according with V4L2 spec, and
some applications, like xawtv and xdtv assumes this behavior, when you try to record a video.

Cheers,
Mauro

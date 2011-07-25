Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48757 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1GYByU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 21:54:20 -0400
Received: by qwk3 with SMTP id 3so1844300qwk.19
        for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 18:54:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110630161803.04e1db20@bike.lwn.net>
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
 <20110629072627.10081454@bike.lwn.net> <003501cc3666$5725a230$0570e690$%szyprowski@samsung.com>
 <20110630161803.04e1db20@bike.lwn.net>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 24 Jul 2011 18:53:59 -0700
Message-ID: <CAMm-=zCaV8fG5tvUOdOe3pCZ8Tm4dmkNEivhUHhJwmL4SwCA9w@mail.gmail.com>
Subject: Re: [PATCH/RFC] media: vb2: change queue initialization order
To: Jonathan Corbet <corbet@lwn.net>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	=?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?=
	<u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marin Mitov <mitov@issp.bas.bg>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon and Marek,

On Thu, Jun 30, 2011 at 15:18, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed, 29 Jun 2011 16:10:45 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>
>> > I do still wonder why this is an issue - why not pass the buffers through
>> > to the driver at VIDIOC_QBUF time?  I assume there must be a reason for
>> > doing things this way, I'd like to understand what it is.
>>
>> I want to delay giving the ownership of the buffers to the driver until it
>> is certain that start_streaming method will be called. This way I achieve
>> a well defined states of the queued buffers:
>>
>> 1. successful start_streaming() -> the driver is processing the queue buffers
>> 2. unsuccessful start_streaming() -> the driver is responsible to discard all
>>    queued buffers
>> 3. stop_streaming() called -> the driver has finished or discarded all queued
>>    buffers
>
> So it's a buffer ownership thing.  I wonder if there would be value in
> adding a buf_give_them_all_back_now() callback?  You have an implicit
> change of buffer ownership now that seems easy for drivers to mess up.  It
> might be better to send an explicit signal at such times and, perhaps,
> even require the driver to explicitly hand each buffer back to vb2?  That
> would make the rules clear and give some flexibility - stopping and
> starting streaming without needing to start over with buffers, for example.
>
> Dunno, I'm just sort of babbling as I think; what's there now clearly
> works.
>

The original reason behind not passing buffers to the driver at QBUF
time was very simple: a driver, when given a buffer by videobuf, was
supposed to start using it right away. The drivers did not have to
have a notion of streaming state, which was to be managed entirely in
videobuf. This greatly simplified drivers, as their logic needed only
to be: "on buf_queue() start processing immediately and give back the
buffer as soon as finished". This approach was assuming that
enabling/disabling a device (e.g. making it start or stop capturing)
was fast and simple though. And it simplified cancelling/destroying
the queue. So yes, it was an ownership thing (and still is).

The reality seems to be proving different, the drivers want to know
about streaming, as enabling and disabling their devices can be
complicated and/or may be taking a significant amount of time (too
long to be done on QBUF without slowing down things). On the other
hand, V4L2 allows starting streaming without queuing any buffers (not
for OUTPUT devices though, for obvious reasons). At first, videobuf
would not allow STREAMON only for OUTPUT devices if no buffers were
queued. Now it looks like most would prefer, by default, disallowing
STREAMON with no buffers queued even for CAPTURE devices, unless a
driver requests otherwise (the new flag in the above patch).

The "buf_give_them_all_back_now()" callback is already there actually.
It's stop_streaming(). That's why stop_streaming is required, while
start_streaming is not. I'll try to clarify that in my incoming
documentation patches.

I like the general idea of this patch, making the behavior
configurable by a driver. We can still have simple drivers that don't
care about streaming state this way. Although I'm not sure which
variant should be the default. I agree that a better idea would be to
make driver check for it itself in start_streaming. Makes it simpler,
and there would be no default either.
But there is one catch: if we allow buf_queue() to be called without
streaming on, all drivers will have to implement start_streaming, so
it will have to become mandatory. Am I right Marek?

-- 
Best regards,
Pawel Osciak

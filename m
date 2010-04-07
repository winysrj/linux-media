Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:39630 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab0DGPDQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 11:03:16 -0400
MIME-Version: 1.0
In-Reply-To: <4BBC88AA.4030808@infradead.org>
References: <20100406104410.710253548@hardeman.nu>
	 <20100406104811.GA6414@hardeman.nu> <4BBB449B.3000207@infradead.org>
	 <1270635607.3021.222.camel@palomino.walls.org>
	 <20100407114234.GA3476@hardeman.nu>
	 <j2g9e4733911004070611je836445apb6527b4e2d8137fb@mail.gmail.com>
	 <4BBC88AA.4030808@infradead.org>
Date: Wed, 7 Apr 2010 11:03:14 -0400
Message-ID: <k2i9e4733911004070803ib02cf971k810c0b02971a2e67@mail.gmail.com>
Subject: Re: [RFC] Teach drivers/media/IR/ir-raw-event.c to use durations
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 7, 2010 at 9:29 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On the implementation I did, each event is passed to each decoder serialized (yet, as one keystroke
> is a series of events, it behaves as if they are processed in parallel). We might create separate
> kthreads for each decoder, and use a spinlock at kfifo, but I suspect that the end result will be
> very close and we'll have more threads interfering at the samples collect, especially on those
> (broken) hardware that don't have IRQ's to indicate a state transition, so the driver needs
> to poll the samples.

Polling should be the driver's problem. They can set up a timer
interrupt and do it that way. Do all of the protocols have a long
enough lead one for a timer tick to catch them? If so, look for it in
the timer event, then go into a polling loop. You'd be way better off
buying new hardware since your video is going to stop while this
pooling loop runs. Do modern serial ports interrupt on DTR or whatever
those Iguana devices use? What is an example of a polled input device?
I can't think of one, even IR diode on mic input is interrupt driven
(that require a special ALSA driver to pass the data into RC core).

No need to use different kthreads for each protocol decoder, but don't
lock up the default kernel thread waiting for a user space response.
What I meant by parallel was that pulses are fed one at a time into
each of the decoders, don't wait for a long space and then feed the
entire message into the decoders.

>
> --
>
> Cheers,
> Mauro
>



-- 
Jon Smirl
jonsmirl@gmail.com

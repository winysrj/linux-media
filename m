Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43368 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533Ab1LCRlI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Dec 2011 12:41:08 -0500
Date: Sat, 3 Dec 2011 17:42:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: VDR User <user.vdr@gmail.com>
Cc: Andreas Oberritter <obi@linuxtv.org>, HoP <jpetrous@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111203174247.0bbab100@lxorguk.ukuu.org.uk>
In-Reply-To: <CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<4EDA4AB4.90303@linuxtv.org>
	<CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 3 Dec 2011 09:21:23 -0800
VDR User <user.vdr@gmail.com> wrote:

> On Sat, Dec 3, 2011 at 8:13 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
> > You could certainly build a library to reach a different goal. The goal
> > of vtuner is to access remote tuners with any existing program
> > implementing the DVB API.
> 
> So you could finally use VDR as a server/client setup using vtuner,
> right? With full OSD, timer, etc? Yes, I'm aware that streamdev
> exists. It was horrible when I tried it last (a long time ago) and I
> understand it's gotten better. But it's not a suitable replacement for
> a real server/client setup. It sounds like using vtuner, this would
> finally be possible and since Klaus has no intention of ever
> modernizing VDR into server/client (that I'm aware of), it's also the
> only suitable option as well.

I would expect it to still suck. One of the problems you have with trying
to pretend things are not networked is that you fake asynchronous events
synchronously, you can't properly cover error cases and as a result you
get things like ioctls that hang for two minutes or fail in bogus and
bizarre ways. If you loop via userspace you've also got to deal with
deadlocks and all sorts of horrible cornercases like the user space
daemon dying.

There is a reason properly working client/server code looks different -
it's not a trivial transformation and faking it kernel side won't be any
better than faking it in user space - it may well even be a worse fake.

Alan

Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZALFUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 00:20:21 -0500
Date: Mon, 12 Jan 2009 03:19:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: CityK <cityk@rogers.com>
Cc: Josh Borke <joshborke@gmail.com>, linux-media@vger.kernel.org,
	David Lonie <loniedavid@gmail.com>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090112031947.134c29c9@pedra.chehab.org>
In-Reply-To: <496AB41E.8020507@rogers.com>
References: <496A9485.7060808@gmail.com>
	<496AB41E.8020507@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 11 Jan 2009 22:08:14 -0500
CityK <cityk@rogers.com> wrote:

> Josh Borke wrote:
> > After upgrading to Fedora 10 I am no longer able to tune analog or dvb
> > channels using my KWorld ATSC 115. When I try to view a channel with
> > tvtime all I can see is static and when I try to scandvb I keep
> > getting tuning failed even though I know that there are channels being
> > broadcast on the channels scanned. I have tried to find tips on the
> > wiki of how to resolve my static problem but I could not find any. I'm
> > not sure where to look for clues as to why it isn't working.
> >
> > I have a 1-to-4 splitter with 2 outputs going to the inputs of the
> > KWorld ATSC and another going to a TV so I know there is signal on the
> > cable.
> >
> > Any help would be really appreciated.
> 
> Hello everyone,
> 
> In addition to being a general broadcast message, I have cc'ed  in a
> number of folks.
> 
> This (broken analog TV on, at the very minimum, the KWorld 110 and 115
> cards) is a known problem that has persisted for a long time.  Far too
> long now.   I last wrote about it here: 
> http://marc.info/?l=linux-video&m=122809741331944&w=2.  No response was
> generated from that.  So I will try again and outline what I believe is
> the relevant history:
> 
> - Mauro, you introduced a regression for these boards in changeset: 
> 7753:67faa17a5bcb  (http://linuxtv.org/hg/v4l-dvb/rev/67faa17a5bcb). 
> Since that commit, analog TV has been broken for these cards.
> 
> - Michael commented about this here:
> http://marc.info/?l=linux-video&m=121243712021921&w=2
> 
> - Mauro responded here: 
> http://marc.info/?l=linux-video&m=121243995927725&w=2
> 
> - Several users have brought this up since then (both here on the m/l's
> and on internet forums) .
> 
> - Michael spun a stopgap solution for this (found here
> :http://linuxtv.org/~mkrufky/fix-broken-atsc110-analog.patch
> <http://linuxtv.org/%7Emkrufky/fix-broken-atsc110-analog.patch> ).  It
> still applies cleanly.  Unfortunately, it is not a bonafide solution
> because: (a) upon each reboot of the system, the user is required to
> first "modprobe tuner -r" and then "modprobe tuner" before the analog
> tuning will initialize and function properly.  (b) In addition,
> Michael's patch may affect/break other devices, so it can not be
> committed to the master repo.
> 
> - Hans, I know you have done a lot of clean ups in regards to i2c, but
> do not know whether any of your work would have touched upon or have had
> any impact here.  Nonetheless, I'd appreciate your input on the matter
> too if you are able to comment.
> 
> I am hoping that this can be resolved to everyone's satisfaction.  In my
> opinion, this should become a priority item, as this regression's life
> has spanned over 4 kernels.
> 
> [For the sake of full disclosure, I am personally affected by the issue,
> but I note that I use Mike's patch each and everyday (thank you Mike!),
> and so, other then the minor inconvenience of having to do a modprobe
> dance with the tuner module, I am not impacted too much.  Other users,
> however, are left in the dark.  And, as I explained in my last message,
> those AVS users that I addressed this issue with seemed entirely
> hesitant about using the patch (maybe I scared them with a greivious
> warning ??).  Anyway, as evidenced by Josh  (OP for this message) and
> David (see his recent messages; e.g.
> http://marc.info/?l=linux-video&m=123066362106086&w=2), end users
> continue to encounter  this problem.  I am only surprised that we
> haven't heard more about this issue.  As I noted earlier on, I believe
> that its impact is greater then just upon the KWorld 11x cards.]

This issue doesn't have an easy fix. The big problem is that some devices like
Kworld ATSC 115 needs to send some i2c commands before accessing the tuner.
However, depending on the load order, the tuner command can happen before the
right time. This trouble is not exclusive with saa7134. We have similar issues
with cx88 (for example, Kworld ATSC 120 suffers similar troubles).

As you noticed, applying Michael patch will likely break other drivers.

The proper fix is a major saa7134 redesign, by using the newer i2c methods.

The new i2c interfaces allow you to register the i2c bus first, then register
each driver when you want to, and not relying on a code that automatically
registers all i2c video drivers found at a random order.

So, with the new i2c approach, we can warrant that we'll first open the i2c
gate before binding the tuner and/or the demodulator.

Any other approach with the current way will break some other cards or cause
troubles on some situations, like having the driver compiled monolithically
with the kernel or if you have two boards on the machine.

The redesign of saa7134 requires lots of work. It requires to a full
understanding of Hans Verkuil approach used on ivtv. The ivtv driver is
different enough from the other drivers to allow an easy conversion. Also, his
approach changed recently with the introduction of the v4l2 subdevices. Even the
conversion of the cx18 driver (very close to ivtv) to the newer approach
doesn't seem to be that easy, as noticed recently by Andy.

IMO, the better would be if Hans could dedicate some time to convert one
of the drivers that have the more usual approach (saa7134, em28xx, cx88,
bttv) to the new approach. Then the same patch could be easily converted to the
other drivers.

Hans,

Could you help us with this?

Cheers,
Mauro

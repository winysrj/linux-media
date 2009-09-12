Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55582 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZILPzM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 11:55:12 -0400
Date: Sat, 12 Sep 2009 12:54:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Media controller: sysfs vs ioctl
Message-ID: <20090912125445.14610988@caramujo.chehab.org>
In-Reply-To: <200909121712.35718.hverkuil@xs4all.nl>
References: <200909120021.48353.hverkuil@xs4all.nl>
	<829197380909120641w66f8d092yfd307186da20edc2@mail.gmail.com>
	<20090912114535.19f9716f@caramujo.chehab.org>
	<200909121712.35718.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 12 Sep 2009 17:12:35 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > Why? Nothing stops discussing it there and better prepare a proposal, but,
> > considering all the noise we had after the DVB S2API last year, I don't think
> > we should ever repeat using a conference, where only some of us will be there
> > to approve a proposal. It is the right forum for discussing and better formulate
> > the issues, in order to prepare a proposal, but the decisions should happen at
> > the ML.
> 
> In that particular case you would have had a lot of noise no matter what you
> did :-)

True.

> The final decisions will indeed be taken here, but the conference is an
> excellent place to talk face-to-face and to see how well the current proposal
> will fit actual media hardware.
> 
> I don't have complete access or knowledge of all the current and upcoming
> media boards, but there are several TI and Nokia engineers present who can
> help with that. Also interesting is to see how and if the framework can be
> extended to dvb.

As I've said at #irc, it would be really great if you could find some ways for
remote people to participate, maybe setting an audio conference channel. I
think we should try to discuss with LPC runners if we can find some ways for it.

I would love to discuss this there with you, but this year's budget and
logistics didn't allow. For those that will also be in Japan for JLC, we can
compliment there with some useful face-to-face discussions.
> 
> > Hans took a year to prepare RFCv2, and we all know that he was hardly
> > working on implementing what was discussed during the first RFC proposal during
> > all those timeframe. This shows that this is a complex matter.
> 
> Not entirely true, I worked on the necessary building blocks for such a media
> controller in the past year. There is a reason why it only took me 400-odd
> lines to get the basic mc support in...

Yes, I know. having the drivers using the framework is for sure the first step.
Yet, unfortunately, this means that we'll still need to do lots of work with
the webcam and dvb drivers for them to use the i2c kernel support and the
proper media core. As some webcams has audio input streaming over USB, it is
important to extend media controller features also to them.

> > Yes, let's do it for 2.6.33, but it this discussion started too late for 2.6.32.
> 
> I don't think anyone advocated getting anything merged for 2.6.32. Certainly
> not me. I'm not even sure whether 2.6.33 is feasible: before we merge anything
> I'd really like to see it implemented in e.g. omap3, uvcvideo and ivtv at the
> least. The proof of the pudding is in the eating, and since this is meant to
> cover a wide range of media boards we should have some idea if theory and
> practice actually match.
> 
> Personally I think that the fact that I got an initial version implemented so
> quickly is very promising.
> 
> I'm currently trying to get ivtv media-controller-aware. It's probably the
> most complex driver when it comes to topology that I have access to, so that
> would be a good test case.

The most complex hardware for PC I'm aware is the cx25821. Unfortunately, the
driver is currently in bad shape, in terms of CodingStyle (including the
removal of large blocks of code that are repeated several times along the
driver), needing lots of changes in order to get merged.

For those interested, the code is at:
	http://linuxtv.org/hg/~mchehab/cx25821/

I'll likely do some work on it during this merge window for its inclusion
upstream (probably at drivers/staging - since I doubt we'll have enough time to
clean it up right now).

It has several blocks that can be used for video in and video out. The current
driver has support for 8 simultaneous video inputs and 4 simultaneous video
output. I'm not sure, but I won't doubt that you can exchange inputs and
outputs or even group them. So, this is a good candidate for some media
controller tests. I'll try to do it via sysfs, running some tests and post the
results.

Cheers,
Mauro

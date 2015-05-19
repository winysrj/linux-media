Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:53244 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbbESMJ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 08:09:56 -0400
Date: Tue, 19 May 2015 14:09:53 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Jemma Denson <jdenson@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] For 4.2 (or even 4.1?) add support for cx24120/Technisat
 SkyStar S2
Message-ID: <20150519140953.0c34185d@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <555B1D9F.5060206@gmail.com>
References: <20150420092720.3cb092ba@dibcom294.coe.adi.dibcom.com>
	<20150427171628.5ba22752@recife.lan>
	<20150427232523.08c1c8f1@lappi3.parrot.biz>
	<20150427214022.1ff9f61f@recife.lan>
	<20150429133501.38eacfa0@dibcom294.coe.adi.dibcom.com>
	<20150429085526.655677d8@recife.lan>
	<20150514184040.094c8a95@recife.lan>
	<20150515102433.15ec0b3d@dibcom294.coe.adi.dibcom.com>
	<20150515112449.4f460aab@recife.lan>
	<55560E2F.40502@gmail.com>
	<20150519075728.1424abf1@recife.lan>
	<555B1D9F.5060206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19 May 2015 12:25:19 +0100 Jemma Denson <jdenson@gmail.com>
wrote:

> On 19/05/15 11:57, Mauro Carvalho Chehab wrote:
> >
> >> The only thing left now is moving UCB & BER over to DVBv5 stats - we
> >> haven't got anything close to any specs for this demod so I'm struggling
> >> to work out how to handle the counter increment.
> >> It's not helped by my signal not being marginal enough to see any errors
> >> anyway!
> >>
> >> What's the best course of action here - either leave those two out
> >> entirely or fudge something to get the numbers to about the right
> >> magnitude and worry about making it more accurate at a later date?
> > I prefer to have something, even not 100% acurate, reported via DVBv5.
> >
> > Regards,
> > Mauro
> 
> I think I've managed to work it out now :) It's set to use a 16 bit BER 
> window and what I did manage to see suggests that the window is based on 
> packets. So it's just a case of calculating things from there.
> 
> I implemented something for BER lastnight but it does need a little 
> tidying. UCB should be much more straightforward. I should be able to 
> find time during the week, or if not this weekend. I'll send the patches 
> through to Patrick to add to his tree and then we can have a v3 pull 
> request.

Great job. Let's do it so. I will check with Mauro about his patches.

--
Patrick.

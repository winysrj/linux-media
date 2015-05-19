Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56819 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbbESK5d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 06:57:33 -0400
Date: Tue, 19 May 2015 07:57:28 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jemma Denson <jdenson@gmail.com>
Cc: Patrick Boettcher <patrick.boettcher@posteo.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] For 4.2 (or even 4.1?) add support for cx24120/Technisat
 SkyStar S2
Message-ID: <20150519075728.1424abf1@recife.lan>
In-Reply-To: <55560E2F.40502@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 15 May 2015 16:18:07 +0100
Jemma Denson <jdenson@gmail.com> escreveu:

> Hi Mauro,
> 
> On 15/05/15 15:24, Mauro Carvalho Chehab wrote:
> >> Of course. Jemma and me (mainly Jemma) are progressing and might be
> >> able to resubmit everything this weekend.
> > Good! Thanks for the good work!
> >
> > Mauro
> 
> 
> The only thing left now is moving UCB & BER over to DVBv5 stats - we 
> haven't got anything close to any specs for this demod so I'm struggling 
> to work out how to handle the counter increment.
> It's not helped by my signal not being marginal enough to see any errors 
> anyway!
> 
> What's the best course of action here - either leave those two out 
> entirely or fudge something to get the numbers to about the right 
> magnitude and worry about making it more accurate at a later date?

I prefer to have something, even not 100% acurate, reported via DVBv5.

Regards,
Mauro

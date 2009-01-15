Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:42442 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545AbZAODOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 22:14:43 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: CityK <cityk@rogers.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <20090115005446.379aae99@pedra.chehab.org>
References: <496A9485.7060808@gmail.com> <496AB41E.8020507@rogers.com>
	 <20090112031947.134c29c9@pedra.chehab.org>
	 <200901120840.20194.hverkuil@xs4all.nl> <496BF812.40102@rogers.com>
	 <1231816664.2680.21.camel@pc10.localdom.local>
	 <496D6CF6.6030005@rogers.com>
	 <1231986761.2896.21.camel@pc10.localdom.local>
	 <20090115005446.379aae99@pedra.chehab.org>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 04:15:04 +0100
Message-Id: <1231989304.2896.24.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Donnerstag, den 15.01.2009, 00:54 -0200 schrieb Mauro Carvalho
Chehab:
> On Thu, 15 Jan 2009 03:32:41 +0100
> hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> > > Consulting on irc, both Eric and myself can confirm that DVB is working
> > > fine for the device (I can only test cable currently, but Eric
> > > successfully checked both QAM and 8-VSB).  I'm using recent Hg and Eric
> > > is using stock FC10 supplied drivers.  So, I'm not sure why Josh was
> > > having problems.  
> > 
> > for me the same and I can't test on these.
> > The Pinnacle 310i seems to have the LNA support broken, can't test.
> 
> Hermann,
> 
> The DVB part shouldn't be affected by the patch. It changes the way that tuners
> are attached at the analog part. So, the tests should be on tea5767 radio and
> on analog tuner reception.
> 
> Also, his patch just changes the way tuner is binding. Manual adjustments on
> saa7134 cards structs (like adding TDA9887_PRESENT flag) will be needed to fix some
> issues like what you've reported (driver not loading automatically tda9887
> driver).

It won't fix the antenna input selection controlled from the digital
demod, as told before.

Cheers,
Hermann



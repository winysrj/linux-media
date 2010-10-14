Return-path: <mchehab@pedra>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:41580 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528Ab0JNT1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 15:27:42 -0400
Subject: Re: [PATCH] xc5000 and switch RF input
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>
In-Reply-To: <20101014121244.17795e5f@glory.local>
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>
	 <AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>
	 <20100525114939.067404eb@glory.loctelecom.ru> <4C32044C.3060007@redhat.com>
	 <AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>
	 <20101013173010.74ee2827@glory.local>
	 <AANLkTimuunSAwewBRaq0hg-c11utF=Lj0v3b=1+3k4Ag@mail.gmail.com>
	 <20101014121244.17795e5f@glory.local>
Content-Type: text/plain
Date: Thu, 14 Oct 2010 21:27:22 +0200
Message-Id: <1287084442.3296.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Am Donnerstag, den 14.10.2010, 12:12 -0400 schrieb Dmitri Belimov:
> Hi
> 
> > On Wed, Oct 13, 2010 at 5:30 PM, Dmitri Belimov <d.belimov@gmail.com>
> > wrote:
> > > Hi
> > >
> > > Our TV card Behold X7 has two different RF input. This RF inputs
> > > can switch between different RF sources.
> > >
> > > ANT 1 for analog and digital TV
> > > ANT 2 for FM radio
> > >
> > > The switch controlled by zl10353.
> > >
> > > I add some defines for the tuner xc5000 and use tuner callback to
> > > saa7134 part. All works well. But my patch can touch other TV cards
> > > with xc5000.
> > >
> > > Devin can you check my changes on the other TV cards.
> > >
> > > With my best regards, Dmitry.
> > 
> > Hello Dmitri,
> > 
> > I've looked at the patch.  I really don't think this is the right
> > approach.  The tuner driver should not have any of this logic - it
> > should be in the bridge driver.  You can also look at Michael Krufky's
> > frontend override patches, which allow the bridge to intervene when
> > DVB frontend commands are made (for example, to toggle the antenna
> > before the tune is performed).
> 
> Ok.
> 
> > I understand the problem you are trying to solve, but jamming the
> > logic into the tuner driver really is a bad idea.
> > 
> > NACK.
> > 
> > Devin
> > 
> > -- 
> > Devin J. Heitmueller - Kernel Labs
> > http://www.kernellabs.com
> 
> Ok.
> 
> With my best regards, Dmitry.
> 
> --

Dmitry,

please adjust your timezone somehow better.

I do read the stuff only in backlash mode currently,

but it is annoying to have you always in the future and real time
relations are broken within all the other stuff coming in.

Cheers,
Hermann





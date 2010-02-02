Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:58757 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792Ab0BBXeo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 18:34:44 -0500
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135   
	variants
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
In-Reply-To: <20100202085415.38a1e362@hyperion.delvare>
References: <20100127120211.2d022375@hyperion.delvare>
	 <4B630179.3080006@redhat.com> <1264812461.16350.90.camel@localhost>
	 <20100130115632.03da7e1b@hyperion.delvare>
	 <1264986995.21486.20.camel@pc07.localdom.local>
	 <20100201105628.77057856@hyperion.delvare>
	 <1265075273.2588.51.camel@localhost>
	 <20100202085415.38a1e362@hyperion.delvare>
Content-Type: text/plain
Date: Wed, 03 Feb 2010 00:32:51 +0100
Message-Id: <1265153571.3194.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Jean, Mauro and all,

Am Dienstag, den 02.02.2010, 08:54 +0100 schrieb Jean Delvare:
> Hi Hermann,
> 
> On Tue, 02 Feb 2010 02:47:53 +0100, hermann pitton wrote:
> > Hi Jean,
> > 
> > Am Montag, den 01.02.2010, 10:56 +0100 schrieb Jean Delvare:
> > > Hi Hermann,
> > > 
> > > On Mon, 01 Feb 2010 02:16:35 +0100, hermann pitton wrote:
> > > > For now, I only faked a P7131 Dual with a broken IR receiver on a 2.6.29
> > > > with recent, you can see that gpio 0x40000 doesn't go high, but your
> > > > patch should enable the remote on that P7131 analog only.
> > > 
> > > I'm not sure why you had to fake anything? What I'd like to know is
> > > simply if my first patch had any negative effect on other cards.
> > 
> > because I simply don't have that Asus My Cinema analog only in question.
> > 
> > To recap, you previously announced a patch, tested by Daro, claiming to
> > get the remote up under auto detection for that device and I told you
> > having some doubts on it.
> 
> My first patch was not actually tested by Daro. What he tested was
> loading the driver with card=146. At first I thought it was equivalent,
> but since then I have realized it wasn't. That's the reason why the
> "Tested-by:" was turned into a mere "Cc:" on my second and third
> patches.
> 
> > Mauro prefers to have a fix for that single card in need for now.
> > 
> > Since nobody else cares, "For now", see above, I can confirm that your
> > last patch for that single device should work to get IR up with auto
> > detection in delay after we change the card such late with eeprom
> > detection.
> > 
> > The meaning of that byte in use here is unknown to me, we should avoid
> > such as much we can! It can turn out to be only some pseudo service.
> > 
> > If your call for testers on your previous attempt, really reaches some
> > for some reason, I'm with you, but for now I have to keep the car
> > operable within all such snow.
> 
> That I understand. What I don't understand is: if you have a
> SAA7134-based card, why don't you test my second patch (the one moving
> the call to saa7134_input_init1 to saa7134_hwinit2) on it, without
> faking anything? This would be a first, useful data point.
> 

sorry, the snow fall did not stop and we will need trucks next day to
get it out of town. No place left.

I did not reread any single line of code until now, but told you that
Roman has tested a equivalent patch on his P7131_ANALOG already and I
can confirm that it also had no side effects on a FlyVideo3000 card=2.

For now, I would at least need some time to see, if input_init can be
decoupled from all other hardware init, what you seem to suggest, and
looking closer to Mauro's concerns.

Thought you are asking for some test with a i2c remote next to confirm
your analysis there. No such card in any machine currently, but can be
done.

Cheers,
Hermann





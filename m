Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:51749 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616Ab0BOFcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 00:32:09 -0500
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135
	variants
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
In-Reply-To: <1265849882.4422.17.camel@localhost>
References: <20100127120211.2d022375@hyperion.delvare>
	 <4B630179.3080006@redhat.com> <1264812461.16350.90.camel@localhost>
	 <20100130115632.03da7e1b@hyperion.delvare>
	 <1264986995.21486.20.camel@pc07.localdom.local>
	 <20100201105628.77057856@hyperion.delvare>
	 <1265075273.2588.51.camel@localhost>
	 <20100202085415.38a1e362@hyperion.delvare> <4B681173.1030404@redhat.com>
	 <20100210190907.5c695e4e@hyperion.delvare> <4B72FD83.1050500@redhat.com>
	 <20100210203601.31ef3220@hyperion.delvare>
	 <1265849882.4422.17.camel@localhost>
Content-Type: text/plain
Date: Mon, 15 Feb 2010 06:31:46 +0100
Message-Id: <1266211906.3177.16.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Donnerstag, den 11.02.2010, 01:58 +0100 schrieb hermann pitton:
> Hi,
> 
> Am Mittwoch, den 10.02.2010, 20:36 +0100 schrieb Jean Delvare:
> > On Wed, 10 Feb 2010 16:40:03 -0200, Mauro Carvalho Chehab wrote:
> > > Jean Delvare wrote:
> > > > Under the assumption that saa7134_hwinit1() only touches GPIOs
> > > > connected to IR receivers (and it certainly looks like this to me) I
> > > > fail to see how these pins not being initialized could have any effect
> > > > on non-IR code.
> > > 
> > > Now, i suspect that you're messing things again: are you referring to saa7134_hwinit1() or
> > > to saa7134_input_init1()?
> > > 
> > > I suspect that you're talking about moving saa7134_input_init1(), since saa7134_hwinit1()
> > > has the muted and spinlock inits. It also has the setups for video, vbi and mpeg. 
> > > So, moving it require more care.
> > 
> > Err, you're right, I meant saa7134_input_init1() and not
> > saa7134_hwinit1(), copy-and-paste error. Sorry for adding more
> > confusion where it really wasn't needed...
> > 
> 
> both attempts of Jean will work.
> 
> If we are only talking about moving input_init, only that Jean did
> suggest initially, it should work, since only some GPIOs for enabling
> remote chips are affected.
> 
> I can give the crappy tester, but don't have such a remote, but should
> not be a problem to trigger the GPIOs later.
> 
> Cheers,
> Hermann
> 

Hi Jean,

I did test your patch, only following Roman's initial patch already
known, on eight different cards for now, also with three slightly
different remotes and it does not have any negative impact.

Please consider, that it is only about that single card for now and a
per card solution is enough.

I strongly remind, that we should not rely on unknown eeprom bytes, as
told previously and should not expand such into any direction.

If we make progress there, we should change it for all cards, but again,
what had happened on the m$ drivers previously is not encouraging to do
it without any need.

To do it per card in need for now seems enough "service" to me.

If more such should come, unlikely on that driver, I would at first deny
auto detection support, since they are breaking rules.

The problem likely will time out very soon.

Cheers,
Hermann




 






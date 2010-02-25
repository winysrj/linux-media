Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:39805 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933895Ab0BYVvG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 16:51:06 -0500
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135
	variants
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
In-Reply-To: <20100225141254.3e43f2c6@hyperion.delvare>
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
	 <1266211906.3177.16.camel@pc07.localdom.local>
	 <1266635225.3407.33.camel@pc07.localdom.local>
	 <20100225141254.3e43f2c6@hyperion.delvare>
Content-Type: text/plain
Date: Thu, 25 Feb 2010 22:50:31 +0100
Message-Id: <1267134631.3186.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Am Donnerstag, den 25.02.2010, 14:12 +0100 schrieb Jean Delvare:
> On Sat, 20 Feb 2010 04:07:05 +0100, hermann pitton wrote:
> > Are you still waiting for Daro's report?
> 
> Yes, I am still waiting. Unfortunately neither Daro nor Roman reported
> any test result so far. Now, if we go for my second patch, I guess we
> might as well apply it right now. It only affects this one card (Asus
> P7131 analog), and it was broken so far, so I don't think my patch can
> do any bad.

yes, we can go for your second patch without any risk.

It even will work, but I'm wondering if I would have to buy such card,
to get it through. Thanks for your time to review that.

> > As said, I would prefer to see all OEMs _not_ following Philips/NXP
> > eeprom rules running into their own trash on GNU/Linux too.
> > 
> > Then we have facts.
> > 
> > That is much better than to provide a golden cloud for them. At least I
> > won't help to debug such later ...
> > 
> > If you did not manage to decipher all OEM eeprom content already,
> > just let's go with the per card solution for now.
> > 
> > Are you aware, that my intention is _not_ to spread the use of random
> > and potentially invalid eeprom content for some sort of such auto
> > detection?
> > 
> > The other solution is not lost and in mind, if we should need to come
> > back to it and are in details. Preferably the OEMs should take the
> > responsibility for such.
> > 
> > We can see, that even those always doing best on it, can't provide the
> > missing informations for different LNA stuff after the
> > Hauppauge/Pinnacle merge until now.
> > 
> > If you claim to know it better, please share with us.
> 
> I'm not claiming anything, and to be honest, I have no idea what you're
> talking about.

Never mind. I'll keep you posted when it comes to further progress on
such and input_init2 is the needed better solution.

We have a whole chain of previously latest different Asus cards
supported by PCI subsystem identification, only this single one fails on
it and needs eeprom bogus detection.

On the Pinnacle stuff we have a complete mess, concerning LNAs, likely
even different LNAs, no LNA at all, different remotes etc., all with the
same PCI subsystem.

You can't even detect the LNA type, if you would know the meaning of the
complete eeprom content, since some to us unknown check-sums are in use
for that.

That I try to tell.

You are welcome,

Hermann







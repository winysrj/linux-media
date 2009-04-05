Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:60745 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbZDEVYd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 17:24:33 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andy Walls <awalls@radix.net>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>
In-Reply-To: <20090405222250.64ed67ae@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	 <20090405010539.187e6268@hyperion.delvare>
	 <200904050746.47451.hverkuil@xs4all.nl> <20090405143748.GC10556@aniel>
	 <1238953174.3337.12.camel@morgan.walls.org> <20090405183154.GE10556@aniel>
	 <1238957897.3337.50.camel@morgan.walls.org>
	 <20090405222250.64ed67ae@hyperion.delvare>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 23:22:03 +0200
Message-Id: <1238966523.6627.63.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Sonntag, den 05.04.2009, 22:22 +0200 schrieb Jean Delvare:
> On Sun, 05 Apr 2009 14:58:17 -0400, Andy Walls wrote:
> > On Sun, 2009-04-05 at 20:31 +0200, Janne Grunau wrote:
> > > I have devices for lirc_zilog (which should probably be merged with
> > > lirc_i2c) 
> > 
> > Hmmm. Following Jean's reasoning, that may be the wrong way to go, if
> > you want to avoid probing.  A module to handle each specific type of I2C
> > IR chip, splitting up lirc_i2c and leaving lirc_zilog as is, may be
> > better in the long run.
> 
> This really doesn't matter. With the new binding model, probing is
> under control. You can do probing on some cards and not others, and you
> can probe some addresses and not others. And one i2c drivers can
> cleanly support more than one device type.

Hmm, I'm still "happy" with the broken DVB-T for saa7134 on 2.6.29,
tasting some Chianti vine now and need to sleep soon, but I'm also not
that confident that your saa7134 MSI TV@nywhere Plus i2c remote does
work addressing it directly, since previous reports always said it
becomes only visible at all after other devices are probed previously.

Unfortunately I can't test it, but will try to reach some with such
hardware and ask for testing, likely not on the list currently.

> What should be considered to decide whether two devices should be
> supported by the same driver or not, is how much their supporting code
> has in common.

What can not be translated to the input system I would like to know.
Andy seems to have closer looked into that.

To have it was a need after 2.5.x turned into 2.6.x. It was not even in
sight if and when lirc would be ever usable on it again. You have it
from Gerd.

I also think we currently have lots of users with all sorts of "TV"
cards. Triple cards are still quite expensive and can have only one DVB
and one analog stream at once, Quad cards depend on special PCI slots
and PCIe multi capable cards are not yet supported.

Because of that, there are lots of mythtv and similar machines stuffed
with all sort of cards in every free PCI slot I think.

Cheers,
Hermann











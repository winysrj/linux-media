Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39552 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZKHB75 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 20:59:57 -0500
Subject: Re: [PATCH 10/75] V4L/DVB: declare MODULE_FIRMWARE for modules
 using  XC2028 and XC3028L tuners
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <829197380911071744q50fc6e18o527322e1120b9689@mail.gmail.com>
References: <1257630476.15927.400.camel@localhost>
	 <1257644240.6895.5.camel@palomino.walls.org>
	 <829197380911071744q50fc6e18o527322e1120b9689@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 07 Nov 2009 21:02:55 -0500
Message-Id: <1257645775.7399.12.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-11-07 at 20:44 -0500, Devin Heitmueller wrote:
> On Sat, Nov 7, 2009 at 8:37 PM, Andy Walls <awalls@radix.net> wrote:
> > On Sat, 2009-11-07 at 21:47 +0000, Ben Hutchings wrote:
> >> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> >> ---
> >> I'm not really sure whether it's better to do this in the drivers which
> >> specify which firmware file to use, or just once in the xc2028 tuner
> >> driver.  Your call.
> >>
> >> Ben.
> >
> > Ben,
> >
> > I would suspect it's better left in the xc2028 tuner driver module.
> >
> > Rationale:
> >
> > a. it will be consistent with other modules like the cx25840 module.
> > ivtv and cx23885 load the cx25840 module yet the MODULE_FIRMWARE
> > advertisement for the CX2584[0123] or CX2388[578] A/V core firmware is
> > in the cx25840 module.
> >
> > b. not every ivtv or cx18 supported TV card, for example, needs the
> > XCeive tuner chip firmware, so it's not a strict requirement for those
> > modules.  It is a strict(-er) requirement for the xc2028 module.
> >
> > My $0.02
> >
> > Regards,
> > Andy
> 
> It's not clear to me what this MODULE_FIRMWARE is going to be used
> for, but if it's for some sort of module dependency system, then it
> definitely should *not* be a dependency for em28xx.  There are lots of
> em28xx based devices that do not use the xc3028, and those users
> should not be expected to go out and find/extract the firmware for
> some tuner they don't have.
> 
> Also, how does this approach handle the situation where there are two
> different possible firmwares depending on the card using the firmware.
>  As in the example above, you the xc3028 can require either the xc3028
> or xc3028L firmware depending on the board they have.  Does this
> change now result in both firmware images being required?

Devin,

Maybe these old references will help answer questions:

http://lwn.net/Articles/197362/
http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-09/msg01007.html


I generally think (as likely you may) that V4L-DVB drivers may have a
somewhat unique position of having multi-card, multi-chip firmware image
needs.

Some firmware is mandatory for all cards supported by a driver - that's
not an issue.  

However, many drivers then have cases where "you may need these other
two firmwares files too, depending on the card you have and the version
of the card you have."

In the cx18 driver, the Yuan MPC-718 is a good example of such a card.

The ivtv driver has a number of required firmware permutations, given
the cards it supports.  The only firmware that is always required in
ivtv is the MPEG encoder firmware.

I'm not sure if MODULE_FIRMWARE advertisements won't cause people undue
worry/work without more amplifying information associated with the
firmware file names.  Maybe it's a "don't care" in the end;  I've
noticed a trend that many users don't know about /sbin/modinfo...

Regards,
Andy

> Devin



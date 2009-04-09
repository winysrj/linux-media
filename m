Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:45030 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936746AbZDIUuF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2009 16:50:05 -0400
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding model
Date: Thu, 9 Apr 2009 21:15:30 +0200
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Mark Schultz <n9xmj@yahoo.com>,
	Brian Rogers <brian_rogers@comcast.net>,
	Andy Walls <awalls@radix.net>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>
References: <20090404142427.6e81f316@hyperion.delvare> <20090406104045.58da67c7@hyperion.delvare> <1239052236.4925.20.camel@pc07.localdom.local>
In-Reply-To: <1239052236.4925.20.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904092115.30426.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 06 of April 2009 at 23:10:36, hermann pitton wrote:
> Hi Jean,
>
> Am Montag, den 06.04.2009, 10:40 +0200 schrieb Jean Delvare:
> > On Sun, 05 Apr 2009 23:22:03 +0200, drunk and tired hermann pitton wrote:
>
> don't tell me the French vine is always better.
> You likely know who introduced that currency once :)
>
> > > Hmm, I'm still "happy" with the broken DVB-T for saa7134 on 2.6.29,
> > > tasting some Chianti vine now and need to sleep soon, but I'm also not
> > > that confident that your saa7134 MSI TV@nywhere Plus i2c remote does
> > > work addressing it directly, since previous reports always said it
> > > becomes only visible at all after other devices are probed previously.
> > >
> > > Unfortunately I can't test it, but will try to reach some with such
> > > hardware and ask for testing, likely not on the list currently.
> >
> > Thanks for the heads up. I was curious about this as well. The original
> > comment said that the MSI TV@nywhere Plus IR receiver would not respond
> > to _probes_ before another device on the I2C bus was accessed. I didn't
> > know for sure if this only applied to the probe sequence or to any
> > attempt to access the IR receiver. As we no longer need to probe for
> > the device, I thought it may be OK to remove the extra code. But
> > probably the removal of the extra code should be delayed until we find
> > one tester to confirm the exact behavior. Here, done.
> >
> > Anyone out there with a MSI TV@nywhere Plus that could help with
> > testing?

Hi Jean,

I've tried your patches with AverMedia Cardbus Hybrid (E506R) and they works 
fine.

My current experience with AverMedia's IR chip (I don't know which one is on 
the card) is that I2C probing didn't find anything, but it got the chip into 
some strange state - next operation failed (so that the autodetection on 
address 0x40 and "subaddress" 0x0b/0x0d failed).

The chip at address 0x40 needs the write first (one byte: 0x0b or 0x0d) and 
immediate read, otherwise it would not respond. The saa7134's I2C 0xfd quirk 
(actually I would call it a hack :-)) caused failures in communication with 
the IR chip.

The way I'm doing the IR reading is the same as the Windows driver does - I 
got the information through the Qemu with pci-proxy patch applied.

Cheers,
Oldrich.

>
> Here is a link to one of the initial reports by Henry, others are close
> to it.
>
> http://marc.info/?l=linux-video&m=113324147429459&w=2
>
> There are two different variants of that MSI card, but that undocumented
> KS003 chip is the same on them.
>
> We still have lots of for the remote unsupported cards with KS chips,
> many from Kworld. Some of these chips are also seen on cx88xx cards
> already and other drivers may follow.
>
> Henry doesn't have this card anymore, but maybe Mark and Brian can test
> and Oldrich might give feedback for the Avermedia.
>



> Cheers,
> Hermann



Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37844 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbZK2OXz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 09:23:55 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: Matthias Fechner <idefix@fechner.net>
Cc: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@wilsonet.com>,
	"Igor M. Liplianin" <liplianin@me.by>, stoth@kernellabs.com
In-Reply-To: <4B0EB017.5000601@fechner.net>
References: <4B0459B1.50600@fechner.net> <4B081F0B.1060204@fechner.net>
	 <1258836102.1794.7.camel@localhost> <200911220303.36715.liplianin@me.by>
	 <1258858102.3072.14.camel@palomino.walls.org> <4B097E37.10402@fechner.net>
	 <1258920707.4201.16.camel@palomino.walls.org>
	 <4B099E37.5070405@fechner.net> <20091122213230.38650f8d@hyperion.delvare>
	 <1258935479.1896.29.camel@localhost>
	 <20091123095435.310fcdf3@hyperion.delvare>
	 <1259108724.3069.22.camel@palomino.walls.org>
	 <4B0EB017.5000601@fechner.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Nov 2009 09:22:39 -0500
Message-Id: <1259504559.2071.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-11-26 at 17:43 +0100, Matthias Fechner wrote:
> Hi Andy,
> 
> Andy Walls wrote:
> > I will inspect and test these with my HVR-1850 (CX23888) loaner board
> > this weekend (hopefully).
> >   
> 
> if you want me to test something on the Tevii S470 card, please let me know.

MAtthias,

Not right now.  I'll let you know.  If you wish, you can monitor

	http://linuxtv.org/hg/~awalls/cx23885-ir

Right now that repository has Jean's patches which I have minimally
tested.  They do fix the i2cdetect problems.

There are not TeVii S470 patches there, so I'm not sure how easy it will
be for you to test.

In the v4l2_subdev_ir_parameters and cx23888-ir.c, I need to improve a
minor point about carrier sense inversion (configuring if a carrier
burst means mark or space) and IO pin level inversion.  After that, I
can port cx23888-ir.c to a cx25840-ir.c implementation.

I also have to implement NEC decoding in cx23885-input.c.  I found a
remote in my house that implements the NEC protocol with Extended
addresses (although its timing is about 100 microseconds short for every
mark & space pair and the header pulse is almost 1 ms shorter than it
should be :P ).  I should be able to get NEC decoding worked out with
that remote and the HVR-1850 I have in hand.

Merging TeVii S470 fixes from Igor will then be a final step before I
ask you to correct my guess at the v4l2_subdev_ir_parameters setup in
cx23885-input.c for your card.


Regards,
Andy

> Bye,
> Matthias


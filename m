Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59256 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbZKUUnS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 15:43:18 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: Matthias Fechner <idefix@fechner.net>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B081F0B.1060204@fechner.net>
References: <4B0459B1.50600@fechner.net>  <4B081F0B.1060204@fechner.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Nov 2009 15:41:42 -0500
Message-Id: <1258836102.1794.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-11-21 at 18:10 +0100, Matthias Fechner wrote:
> Hi,
> 
> Matthias Fechner schrieb:
> > I bought some days ago a Tevii S470 DVB-S2 (PCI-E) card and got it 
> > running with the driver from:
> > http://mercurial.intuxication.org/hg/s2-liplianin
> > 
> > But I was not successfull in got the IR receiver working.
> > It seems that it is not supported yet by the driver.
> > 
> > Is there maybe some code available to get the IR receiver with evdev 
> > running?

What bridge chip does the TeVii S470 use: a CX23885, CX23887, or
CX23888?

Does the TeVii S470 have a separate microcontroller chip for IR
somewhere on the board, or does it not have one?  (If you can't tell,
just provide a list of the chip markings on the board.)


If the card is using the built in IR controller of the CX23888 than that
should be pretty easy to get working, we'll just need you to do some
experimentation with a patch.

If the card is using the built in IR controller in the CX23885, then
you'll have to wait until I port my CX23888 IR controller changes to
work with the IR controller in the CX23885.  That should be somewhat
straightforward, but will take time.  Then we'll still need you to
experiment with a patch.

If the card is using a separate IR microcontroller, I'm not sure where
to begin.... :P

Regards,
Andy


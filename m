Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab0HBSDU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 14:03:20 -0400
Date: Mon, 2 Aug 2010 13:51:27 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: jonsmirl@gmail.com, awalls@md.metrocast.net,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com
Subject: Re: Remote that breaks current system
Message-ID: <20100802175127.GE2296@redhat.com>
References: <AANLkTi=F4CQ2_pCDno1SNGS6w=7wERk1FwjezkwC=nS5@mail.gmail.com>
 <BU4OxfMZjFB@christoph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BU4OxfMZjFB@christoph>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 02, 2010 at 06:42:00PM +0200, Christoph Bartelmus wrote:
> Hi!
> 
> Jon Smirl "jonsmirl@gmail.com" wrote:
> [...]
> >> Got one. The Streamzap PC Remote. Its 14-bit RC5. Can't get it to properly
> >> decode in-kernel for the life of me. I got lirc_streamzap 99% of the way
> >> ported over the weekend, but this remote just won't decode correctly w/the
> >> in-kernel RC5 decoder.
> 
> > Manchester encoding may need a decoder that waits to get 2-3 edge
> > changes before deciding what the first bit. As you decode the output
> > is always a couple bits behind the current input data.
> >
> > You can build of a table of states
> > L0 S1 S0 L1  - emit a 1, move forward an edge
> > S0 S1 L0 L1 - emit a 0, move forward an edge
> >
> > By doing it that way you don't have to initially figure out the bit clock.
> >
> > The current decoder code may not be properly tracking the leading
> > zero. In Manchester encoding it is illegal for a bit to be 11 or 00.
> > They have to be 01 or 10. If you get a 11 or 00 bit, your decoding is
> > off by 1/2 a bit cycle.
> >
> > Did you note the comment that Extended RC-5 has only a single start
> > bit instead of two?
> 
> It has nothing to do with start bits.
> The Streamzap remote just sends 14 (sic!) bits instead of 13.
> The decoder expects 13 bits.
> Yes, the Streamzap remote does _not_ use standard RC-5.
> Did I mention this already? Yes. ;-)

D'oh, yeah, sorry, completely forgot you already mentioned this. That
would certainly explain why the rc5 decoder isn't happy with it. So the
*receiver* itself is perfectly functional, its just a goofy IR protocol
sent by its default remote. Blah. So yet another reason having ongoing
lirc compatibility is a Good Thing. ;)

-- 
Jarod Wilson
jarod@redhat.com


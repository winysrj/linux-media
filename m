Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0HBSV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 14:21:26 -0400
Date: Mon, 2 Aug 2010 14:09:40 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>,
	Jarod Wilson <jarod@wilsonet.com>, awalls@md.metrocast.net,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com
Subject: Re: Remote that breaks current system
Message-ID: <20100802180940.GF2296@redhat.com>
References: <AANLkTi=F4CQ2_pCDno1SNGS6w=7wERk1FwjezkwC=nS5@mail.gmail.com>
 <BU4OxfMZjFB@christoph>
 <AANLkTimXULCDLw6=kcFC2Kddbm4kuO4nqtXL6ozftMQj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimXULCDLw6=kcFC2Kddbm4kuO4nqtXL6ozftMQj@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 02, 2010 at 01:13:22PM -0400, Jon Smirl wrote:
> On Mon, Aug 2, 2010 at 12:42 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> > Hi!
> >
> > Jon Smirl "jonsmirl@gmail.com" wrote:
> > [...]
> >>> Got one. The Streamzap PC Remote. Its 14-bit RC5. Can't get it to properly
> >>> decode in-kernel for the life of me. I got lirc_streamzap 99% of the way
> >>> ported over the weekend, but this remote just won't decode correctly w/the
> >>> in-kernel RC5 decoder.
> >
> >> Manchester encoding may need a decoder that waits to get 2-3 edge
> >> changes before deciding what the first bit. As you decode the output
> >> is always a couple bits behind the current input data.
> >>
> >> You can build of a table of states
> >> L0 S1 S0 L1  - emit a 1, move forward an edge
> >> S0 S1 L0 L1 - emit a 0, move forward an edge
> >>
> >> By doing it that way you don't have to initially figure out the bit clock.
> >>
> >> The current decoder code may not be properly tracking the leading
> >> zero. In Manchester encoding it is illegal for a bit to be 11 or 00.
> >> They have to be 01 or 10. If you get a 11 or 00 bit, your decoding is
> >> off by 1/2 a bit cycle.
> >>
> >> Did you note the comment that Extended RC-5 has only a single start
> >> bit instead of two?
> >
> > It has nothing to do with start bits.
> > The Streamzap remote just sends 14 (sic!) bits instead of 13.
> > The decoder expects 13 bits.
> > Yes, the Streamzap remote does _not_ use standard RC-5.
> > Did I mention this already? Yes. ;-)
> 
> If the remote is sending a weird protocol then there are several choices:
>   1) implement raw mode
>   2) make a Stream-Zap protocol engine (it would be a 14b version of
> RC-5). Standard RC5 engine will still reject the messages.
>   3) throw away your Stream-Zap remotes
> 
> I'd vote for #3, but #2 will probably make people happier.

Hm. Yeah, I know a few people who are quite attached to their Streamzap
remotes. I'm not a particularly big fan of it, I only got the thing off
ebay to have the hardware so I could work on the driver. :) So yeah, #3 is
probably not the best route. But I don't know that I'm a huge fan of #2
either. Another decoder engine just for one quirky remote seems excessive,
and there's an option #4:

4) just keep passing data out to lirc by default.

Let lircd handle the default remote in this case. If you want to use
another remote that actually uses a standard protocol, and want to use
in-kernel decoding for that, its just an ir-keytable call away.

For giggles, I may tinker with implementing another decoder engine though,
if only to force myself to actually pay more attention to protocol
specifics. For the moment, I'm inclined to go ahead with the streamzap
port as it is right now, and include either an empty or not-empty, but
not-functional key table.

-- 
Jarod Wilson
jarod@redhat.com


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:46321 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786AbZCMITU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 04:19:20 -0400
Date: Fri, 13 Mar 2009 01:19:17 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: "Erik S. Beiser" <erikb@bu.edu>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] cx88: Add IR support to pcHDTV HD3000 & HD5500
In-Reply-To: <49B09734.9050302@bu.edu>
Message-ID: <Pine.LNX.4.58.0903130027270.28292@shell2.speakeasy.net>
References: <49A9E4F0.1030005@bu.edu> <Pine.LNX.4.58.0903041330510.24268@shell2.speakeasy.net>
 <49B09734.9050302@bu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Erik S. Beiser wrote:
> Thanks for your comments, Trent.  My responses below:
>
> Trent Piepho wrote:
> > On Sat, 28 Feb 2009, Erik S. Beiser wrote:
> >
> >> cx88: Add IR support to pcHDTV HD3000 & HD5500
> >>
> >> Signed-off-by: Erik S. Beiser <erikb@bu.edu>
> >>
> >> ---
> >>
> >> Idea originally from http://www.pchdtv.com/forum/viewtopic.php?t=1529
> >> I made it into this small patch and added the HD3000 support also, which I have  I've actually
> >> been using this for over a year, updating for new kernel versions.  I'm tired of doing so,
> >> and would like to try and have it merged upstream -- I hope I got all the patch-mechanics
> >> correct.  I just updated and tested it today on 2.6.28.7 vanilla.  Thanks.
> >
> > You forgot a patch description.
> Ok, I had looked around and saw many patches that had the one-liner
> descriptions, which I thought would be sufficient for a four line
> patch.  At your request, I can add a couple lines description when I
> fix it (see below).

You won't see such patch descriptions from me.  Clearly your patch made
some very significant changes and assumptions that really should have in
the description.

> > Since neither the HD-3000 or HD-5500 came with a remote, and at least my
> > HD-3000 didn't even come with an IR receiver.  So I have to ask why
> > configuring the driver to work a remote you happened to have is any more
> > correct than configuring it to work a remote someone else happens to have?
> True, the vendor doesn't seem to sell a remote or IR receiver with
> these cards.  I was actually surprised when I got mine to see the jack
> for an IR receiver, which can be made to work if one has those parts
> from another source.  I don't think that because these cards were sold
> without a remote and receiver should mean that we don't expose the
> receiver functionality.  I didn't see that happening elsewhere, so I
> adopted this 'worksforme' solution.  You have a valid point about the
> key mapping, which I did not fully consider.  I don't have a good
> justification.  OTOH how does someone with one of those cards use a
> remote different from what came with their card?  Is that possible?

The problem with exposing the receiver this way is that it's unlikely to be
useful to anyone but yourself.  Given the significant performance cost of
enabling ir sampling, and the very limited usefulness, I don't think this
belongs in the kernel.

> All I'm really trying to accomplish is to somehow get inputs from a
> remote exposed through some device, with which I could parse stuff
> with lirc.  This method exposed it via a /dev/input/eventN node.  I
> admit I hadn't paid too much attention to the keymapping before.
> (Just trying to get the thing to work.)  But you prompted me to dig
> deeper, and I see that in drivers/media/common/ir-keymaps.c there is a
> ir_codes_empty mapping.  I tried it tonight with that mapping instead,
> and a /dev/input/eventN device was created, but I don't seem to get
> anything from it.  Which I guess isn't too surprising, but if so, then
> how can I go about generically exposing signals from the IR port to
> userspace?

You might look at the patches from Jon Simrl that try to add IR support to
the input system.  They use configfs to define remote keycodes.

You could also create a device the exports the raw timings to lircd to
decode.  I think lircd might still use the "mode2" interface I created for
the ir serial driver over a decade ago.  That would be easy to copy.

> > This patch also causes these cards to generate 101 interrupts per second
> > per card, even when not in use.  That seems pretty costly for a card that
> > doesn't even come with an ir sensor.
> Whoa, I didn't realize that.  Can you point me to how I can verify
> that?  Is that simply an effect of the ir->sampling type?  Might a
> different type be preferred?  I could do some experimenting.

Just look at /proc/interrupts.  The ir sampling mode isn't documented in
the cx23880 datasheet, but it looks like it samples gpio16 at about 250 us
intervals and generate an interrupt each time 32 samples are ready.  Hugely
inefficient.  A serial port ir receiver would be much better.  The cx23880
can operate that way with gpio22 and gpio23, but I think the mpeg ts
interface uses those gpios.

Maybe there is some way to turn on the remote sampling when something is
listening for remote events?

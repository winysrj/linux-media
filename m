Return-path: <linux-media-owner@vger.kernel.org>
Received: from skynet.bu.edu ([128.197.167.9]:55624 "EHLO skynet.bu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZCFDXo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 22:23:44 -0500
Message-ID: <49B09734.9050302@bu.edu>
Date: Thu, 05 Mar 2009 22:23:32 -0500
From: "Erik S. Beiser" <erikb@bu.edu>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] cx88: Add IR support to pcHDTV HD3000 & HD5500
References: <49A9E4F0.1030005@bu.edu> <Pine.LNX.4.58.0903041330510.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0903041330510.24268@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your comments, Trent.  My responses below:

Trent Piepho wrote:
> On Sat, 28 Feb 2009, Erik S. Beiser wrote:
> 
>> cx88: Add IR support to pcHDTV HD3000 & HD5500
>>
>> Signed-off-by: Erik S. Beiser <erikb@bu.edu>
>>
>> ---
>>
>> Idea originally from http://www.pchdtv.com/forum/viewtopic.php?t=1529
>> I made it into this small patch and added the HD3000 support also, which I have  I've actually
>> been using this for over a year, updating for new kernel versions.  I'm tired of doing so,
>> and would like to try and have it merged upstream -- I hope I got all the patch-mechanics
>> correct.  I just updated and tested it today on 2.6.28.7 vanilla.  Thanks.
> 
> You forgot a patch description.
Ok, I had looked around and saw many patches that had the one-liner
descriptions, which I thought would be sufficient for a four line
patch.  At your request, I can add a couple lines description when I
fix it (see below).

> Since neither the HD-3000 or HD-5500 came with a remote, and at least my
> HD-3000 didn't even come with an IR receiver.  So I have to ask why
> configuring the driver to work a remote you happened to have is any more
> correct than configuring it to work a remote someone else happens to have?
True, the vendor doesn't seem to sell a remote or IR receiver with
these cards.  I was actually surprised when I got mine to see the jack
for an IR receiver, which can be made to work if one has those parts
from another source.  I don't think that because these cards were sold
without a remote and receiver should mean that we don't expose the
receiver functionality.  I didn't see that happening elsewhere, so I
adopted this 'worksforme' solution.  You have a valid point about the
key mapping, which I did not fully consider.  I don't have a good
justification.  OTOH how does someone with one of those cards use a
remote different from what came with their card?  Is that possible?

All I'm really trying to accomplish is to somehow get inputs from a
remote exposed through some device, with which I could parse stuff
with lirc.  This method exposed it via a /dev/input/eventN node.  I
admit I hadn't paid too much attention to the keymapping before.
(Just trying to get the thing to work.)  But you prompted me to dig
deeper, and I see that in drivers/media/common/ir-keymaps.c there is a
ir_codes_empty mapping.  I tried it tonight with that mapping instead,
and a /dev/input/eventN device was created, but I don't seem to get
anything from it.  Which I guess isn't too surprising, but if so, then
how can I go about generically exposing signals from the IR port to
userspace?

> This patch also causes these cards to generate 101 interrupts per second
> per card, even when not in use.  That seems pretty costly for a card that
> doesn't even come with an ir sensor.
Whoa, I didn't realize that.  Can you point me to how I can verify
that?  Is that simply an effect of the ir->sampling type?  Might a
different type be preferred?  I could do some experimenting.

Is there a better way of doing this?  I'm willing to do a little
legwork to see if I can make this a better, more generic solution.

--Erik

p.s.  I don't mean to appear rude, so FYI I will be w/o net access
this weekend and thus unable to respond to anyone until at least Monday.

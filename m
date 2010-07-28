Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52162 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0G1Cd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 22:33:56 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
References: <1280269990.21278.15.camel@maxim-laptop>
	<1280273550.32216.4.camel@maxim-laptop>
	<AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
Date: Tue, 27 Jul 2010 22:33:55 -0400
Message-ID: <AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
Subject: Re: Can I expect in-kernel decoding to work out of box?
From: Jarod Wilson <jarod@wilsonet.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-input <linux-input@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 27, 2010 at 9:29 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On Tue, Jul 27, 2010 at 7:32 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> On Wed, 2010-07-28 at 01:33 +0300, Maxim Levitsky wrote:
>>> Hi,
>>>
>>> I ported my ene driver to in-kernel decoding.
>>> It isn't yet ready to be released, but in few days it will be.
>>>
>>> Now, knowing about wonders of in-kernel decoding, I try to use it, but
>>> it just doesn't work.
>>>
>>> Mind you that lircd works with this remote.
>>> (I attach my lircd.conf)
>>>
>>> Here is the output of mode2 for a single keypress:
>
>    8850     4350      525     1575      525     1575
>     525      450      525      450      525      450
>     525      450      525     1575      525      450
>     525     1575      525      450      525     1575
>     525      450      525      450      525     1575
>     525      450      525      450      525    23625
>
> That decodes as:
> 1100 0010 1010 0100
>
> In the NEC protocol the second word is supposed to be the inverse of
> the first word and it isn't. The timing is too short for NEC protocol
> too.
>
> Valid NEC...
> 1100 0011 1010 0101
>
> Maybe JVC protocol but it is longer than normal.
>
> The JVC decoder was unable to get started decoding it.  I don't think
> the JVC decoder has been tested much. Take a look at it and see why it
> couldn't get out of state 0.

Personally, I haven't really tried much of anything but RC-6(A) and
RC-5 while working on mceusb, so they're the only ones I can really
vouch for myself at the moment. It seems that I don't have many
remotes that aren't an RC-x variant, outside of universals, which I
have yet to get around to programming for various other modes to test
any of the protocol decoders. I assume that David Hardeman already did
that much before submitting each of the ir protocol decoders with his
name one them (which were, if I'm not mistaken, based at least
partially on Jon's earlier work), but its entirely possible there are
slight variants of each that aren't handled properly just yet. That
right there is one of the major reasons I saw for writing the lirc
bridge driver plugin in the first place -- the lirc userspace decoder
has been around for a LOT longer, and thus is likely to know how to
handle more widely varying IR signals.

-- 
Jarod Wilson
jarod@wilsonet.com

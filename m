Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:39520 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbaCaQsA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 12:48:00 -0400
Date: Mon, 31 Mar 2014 18:47:56 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 10/11] [RFC] rc-core: use the full 32 bits for NEC
 scancodes
Message-ID: <20140331164756.GA9610@hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
 <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu>
 <5339390B.6030709@imgtec.com>
 <4af025b742df648556360db390351166@hardeman.nu>
 <533949F5.3080001@imgtec.com>
 <37fcf3abf63e258ee29b23dc3b0f3f12@hardeman.nu>
 <20140331122656.13266f88@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140331122656.13266f88@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 31, 2014 at 12:26:56PM -0300, Mauro Carvalho Chehab wrote:
>Inside the RC core, for all other protocols, the order always
>ADDRESS + COMMAND.
>
>Up to NEC-24 bits, this is preserved, as the command is always 0xDD
>and the address is either 0xaaAA or 0xAA.
>
>The 32-bits NEC is a little ackward, if we consider the command as
>also being 8 bits, and the address having 24 bits.
>
>The Tivo keytable is weird:
>
>	{ 0x3085f009, KEY_MEDIA },	/* TiVo Button */
>	{ 0x3085e010, KEY_POWER2 },	/* TV Power */
>	{ 0x3085e011, KEY_TV },		/* Live TV/Swap */
>	{ 0x3085c034, KEY_VIDEO_NEXT },	/* TV Input */
>	{ 0x3085e013, KEY_INFO },
>	{ 0x3085a05f, KEY_CYCLEWINDOWS }, /* Window */
>	{ 0x0085305f, KEY_CYCLEWINDOWS },
>	{ 0x3085c036, KEY_EPG },	/* Guide */
>	...
>
>There, the only part of the scancode that doesn't change is 0x85.
>It seems that they're using 8 bits for address (0xaa) and 24
>bits for command (0xAADDdd).
>
>So, it seems that they're actually sending address/command as:
>
>	[command >> 24><Address][(command >>8) & 0xff][command & 0xff]
>
>With seems too awkward.
>
>IMHO, it would make more sense to store those data as:
>	<address><command>
>
>So, KEY_MEDIA, for example, would be:
>+	{ 0x8530f009, KEY_MEDIA },	/* TiVo Button */
>
>However, I'm not sure how other 32 bits NEC scancodes might be.

And it's completely irrelevant. There's little to no value in trying to
determine what's a "command" and what's an "address". We have to
standardize on one in-memory representation of the 32 bits, and then we
should just treat it as that...as a u32 lookup key for the
scancode<->keycode table which lacks any further "meaning".

>So, I think we should keep the internal representation as-is,
>for now, while we're not sure about how other vendors handle
>it, as, for now, there's just one IR table with 32 bits nec.

It doesn't matter how other vendors handle (i.e. interpret) the
different bits, that's what we want to get away from, it's the whole
point of this discussion.

>That's said, I don't mind much how this is internally stored at
>the Kernel level, as we can always change it, but we should provide
>backward compatibility for userspace, when userspace sends
>to Kernel a 16 bit or a 24 bit keytable.

Yes, which is part of what I've proposed.

It's not a coicidence that I've proposed a new ioctl and the NEC32
standardization at the same time. A new ioctl is the perfect time and
place to get this right once and for all.

So with the new ioctl, the "protocol" is made explicit, and the
definition of a scancode follows from the "protocol" (protocol as in
RC_TYPE_*).

For RC_TYPE_NEC, that scancode would be a 32 bit int (exact byte and bit
order to be determined, but not terribly important for this discussion).

That removes *all* ambiguity and makes RC_TYPE_NEC behave *exactly* like
all other protocols. At the same time it removes pointless policy from
the kernel and causes a reduction in code (mostly thinking of the
pointless NEC16/24/32 parsing code that gets duplicated across drivers).

>So, I think we should first focus on how to properly get/set the
>bitsize at the API in a way that this is backward compatible.

No, adding bitsizes adds complexity and additional layers of abstraction
for no good reason. And it is not needed for *any other protocol*. Why?
Because the protocol already defines the bitsize. And so would NEC if we
would just use all 32 bits throughout.

With that change, the bitsize is implicit in *each protocol* and the new
ioctl I proposed makes the protocol explicit (while providing at least a
best-effort guess for NEC scancodes when the legacy ioctl is used).

(and no, please, don't suggest we add RC_TYPE_NEC, RC_TYPE_NEC24,
RC_TYPE_NEC32...) 

>Ok, the API actually sends the bit size of each keycode, as the
>size length is variable, but I'm not sure if this is reliable enough,
>as I think that the current userspace just sets it to 32 bits, even
>when passing a 16 bits key.

That won't work as you've noted yourself.

>In any case, it doesn't make any sense to require userspace to
>convert a 16 bits normal NEC table (or a 24 bits "extended" NEC
>table) into a 32 bits data+checksum bitpack on userspace.

I disagree. Strongly.

It makes perfect sense. Policy doesn't belong in the kernel and all
that. Asking userspace to provide a full description of the 32 bits that
are transmitted removes all ambiguity and makes any "bitsize"
irrelevant. For all the other protocols we support, the "bitsize" is
known on a per-protocol basis. The same can be true for RC_TYPE_NEC.

And userspace can still write nice user-friendly 16 bit keymaps if it
likes and convert to kernel scancode notation on the fly. That's
something userspace anyways has to do today.

Consider the 32 bit scancode as simply being the communication protocol
between userspace <-> kernel if you like. There's no reason to
complicate that with bitsizes and/or multiple protocols when a single 32
bit scancode describes exactly everything that the kernel and userspace
needs to know.

-- 
David Härdeman

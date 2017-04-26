Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51389 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1949645AbdDZLjM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 07:39:12 -0400
Date: Wed, 26 Apr 2017 12:39:10 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] rc-core: use the full 32 bits for NEC scancodes
Message-ID: <20170426113910.GA7924@gofer.mess.org>
References: <20170424155746.GA12437@gofer.mess.org>
 <149253062750.8732.14617348605110322157.stgit@zeus.hardeman.nu>
 <b5d0d7993ee9c705783e63ab228425d3@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5d0d7993ee9c705783e63ab228425d3@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 25, 2017 at 07:58:09AM +0000, David Härdeman wrote:
> April 24, 2017 5:58 PM, "Sean Young" <sean@mess.org> wrote:
> > On Tue, Apr 18, 2017 at 05:50:27PM +0200, David Härdeman wrote:
> >> Using the full 32 bits for all kinds of NEC scancodes simplifies rc-core
> >> and the nec decoder without any loss of functionality. At the same time
> >> it ensures that scancodes for NEC16/NEC24/NEC32 do not overlap and
> >> removes lots of duplication (as you can see from the patch, the same NEC
> >> disambiguation logic is contained in several different drivers).
> >> 
> >> Using NEC32 also removes ambiguity. For example, consider these two NEC
> >> messages:
> >> NEC16 message to address 0x05, command 0x03
> >> NEC24 message to address 0x0005, command 0x03
> >> 
> >> They'll both have scancode 0x00000503, and there's no way to tell which
> >> message was received.
> > 
> > More precisely, there is no way to tell which protocol variant it was sent
> > with.
> 
> Oh, but there is. The driver/rc-core will know. It's just that userspace cannot ever know.

Agreed.

> > With the Sony and rc6 protocols, you can also get the same scancode from
> > different protocol variants. I think the right solution is to pass the protocol
> > variant to user space (and the keymap mapper).
> 
> Yes, I'm working on refreshing my patches to add a new EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2 ioctl which includes the protocol.

That's a good idea and I look forward to those patches.

>  And actually, those patches are greatly simplified by only using NEC32.

At the moment your patches break userspace and I see no advantage in
representing a nec16 scancode as something like 0xe71824db rather than
0xe1724. It might reduce some code by a few lines/instructions.

Also note that having different nec variants makes a lot of sense, since
some hardware that decodes nec can only only handle specific variants,
e.g. nec16 only. By folding it all into nec32 you can longer specify
the specific variant(s) that some hardware can handle.

> > This also solves some other problems, e.g. rc6_6a_20:0x75460 is also decoded
> > by the sony protocol decoder (as scancode 0).
> 
> I know. And it also makes it possible to make /sys/class/rc/rc0/protocols fully automatic. And we could theoretically also refuse to set unsupported protocols in the keytable (not sure yet if that's something we should do).

Let's discuss that when we have the patches.

> >> In order to maintain backwards compatibility, some heuristics are added
> >> in rc-main.c to convert scancodes to NEC32 as necessary when userspace
> >> adds entries to the keytable using the regular input ioctls.
> > 
> > This is where it falls apart. In the patch below, you guess the protocol
> > variant from the scancode value. By your own example above, nec24 with
> > an address of 0x0005 would be not be possible in a keymap since it would
> > guessed as nec16 (see to_nec32() below) and expanded to 0x05fb03fc. An
> > actual nec24 would be 0x000503fc.
> 
> It's not 100% bulletproof. There's no way to fix this issue in a 100% backwards compatible manner. But the future EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2 ioctl would make the heuristics unnecessary.

There must be a very good reason to break this and at the moment I can't
see any advantage (at all).


Sean

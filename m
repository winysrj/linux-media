Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:49521 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755723AbcKVPts (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 10:49:48 -0500
Date: Tue, 22 Nov 2016 15:49:44 +0000
From: Sean Young <sean@mess.org>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] nec decoder: wrong bit order for nec32 protocol
Message-ID: <20161122154943.GA11405@gofer.mess.org>
References: <1478708015-1164-5-git-send-email-sean@mess.org>
 <20161122113506.1a604721@vento.lan>
 <20161122141919.GF21644@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161122141919.GF21644@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 22, 2016 at 09:19:19AM -0500, Jarod Wilson wrote:
> On Tue, Nov 22, 2016 at 11:35:06AM -0200, Mauro Carvalho Chehab wrote:
> > Em Wed,  9 Nov 2016 16:13:35 +0000
> > Sean Young <sean@mess.org> escreveu:
> > 
> > > The bits are sent in lsb first. Hardware decoders also send nec32
> > > in this order (e.g. dib0700). This should be consistent, however
> > > I have no way of knowing which order the LME2510 and Tivo keymaps
> > > are (the only two kernel keymaps with NEC32).
> > 
> > Hmm.. the lme2510 receives the scancode directly. So, this
> > patch shouldn't affect it. So, we're stuck with the Tivo IR.
> > 
> > On Tivo, only a few keys (with duplicated scancodes) don't start with
> > 0xa10c. So, it *seems* that this is an address.

The problem here is that each *byte* is sent lsb first, so only the 
ordering within each byte would change. 

> > The best here would be to try to get a Tivo remote controller[1], and
> > do some tests with a driver that has a hardware decoder capable of
> > output NEC32 data, and some driver that receives raw IR data in
> > order to be sure.
> > 
> > In any case, we need to patch both the NEC32 decoder and the table
> > at the same time, to be 100% sure.
> > 
> > [1] or some universal remote controller that could emulate
> > the Tivo's scan codes. I suspect that the IR in question is
> > this one, but maybe Jarod could shed some light here:
> > 	https://www.amazon.com/TiVo-Remote-Control-Universal-Replacement/dp/B00DYYKA04
> 
> Been away from the game for a few years now, so there are a good number of
> cobwebs in this section of my brain... I'm pretty sure I do have both a
> remote and receiver on hand that would fit the bill here though. Is the
> question primarily about what actually gets emitted by the TiVo remote?

Yes, it is. Hardware nec decoders send each byte lsb first, but 
ir-nec-decoder.c decoder does msb first for nec32 (not for extended nec or
plain nec).

If we have a mode2 recording of the remote (and if we know what button it
is), then we can replay it against a hardware nec decoder and the software
decoder. Rather than mode2, this can also be done with ir-ctl which is in
v4l-utils git.

Alternatively simply checking if the tivo keymap works with the
software decoder (mceusb hardware for example) should be sufficient.

That would be really helpful, thanks.


Sean

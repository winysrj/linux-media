Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43153
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932592AbcKVPRs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 10:17:48 -0500
Date: Tue, 22 Nov 2016 13:08:52 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] nec decoder: wrong bit order for nec32 protocol
Message-ID: <20161122130852.6f8d259f@vento.lan>
In-Reply-To: <20161122141919.GF21644@redhat.com>
References: <1478708015-1164-5-git-send-email-sean@mess.org>
        <20161122113506.1a604721@vento.lan>
        <20161122141919.GF21644@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 22 Nov 2016 09:19:19 -0500
Jarod Wilson <jarod@redhat.com> escreveu:

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
> > 
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

Yes. Sean suspects that we're decoding the NEC 32 bits in the
wrong order at the in-kernel NEC decoder on x86[1].

The idea here is to double-check how the bits are encapsulated, in order
to do the right thing at the IR decoder.

[1] the current code actually sucks, as it produces different
scancodes on big endian or little endian, so it needs to be
fixed anyway, as it simply does:
	scancode = data->bits;

instead of using be32_to_cpu().


Thanks,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53269 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753149AbcKVP42 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 10:56:28 -0500
Date: Tue, 22 Nov 2016 15:56:26 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] nec decoder: wrong bit order for nec32 protocol
Message-ID: <20161122155626.GB11405@gofer.mess.org>
References: <1478708015-1164-5-git-send-email-sean@mess.org>
 <20161122113506.1a604721@vento.lan>
 <20161122141919.GF21644@redhat.com>
 <20161122130852.6f8d259f@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161122130852.6f8d259f@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 22, 2016 at 01:08:52PM -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 22 Nov 2016 09:19:19 -0500
> Jarod Wilson <jarod@redhat.com> escreveu:
> > Been away from the game for a few years now, so there are a good number of
> > cobwebs in this section of my brain... I'm pretty sure I do have both a
> > remote and receiver on hand that would fit the bill here though. Is the
> > question primarily about what actually gets emitted by the TiVo remote?
> 
> Yes. Sean suspects that we're decoding the NEC 32 bits in the
> wrong order at the in-kernel NEC decoder on x86[1].
> 
> The idea here is to double-check how the bits are encapsulated, in order
> to do the right thing at the IR decoder.
> 
> [1] the current code actually sucks, as it produces different
> scancodes on big endian or little endian, so it needs to be
> fixed anyway, as it simply does:
> 	scancode = data->bits;
> 
> instead of using be32_to_cpu().

Bits are shifted in one at at time in the nec decoder so it is endian safe.

The problem is that the same NEC32 IR will produce different scancodes
with ir-nec-decoder.c and other nec decoders, e.g. dib0700_core.c


Sean

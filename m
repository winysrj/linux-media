Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34063 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755689AbcKVOT7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 09:19:59 -0500
Received: by mail-wm0-f45.google.com with SMTP id u144so5116394wmu.1
        for <linux-media@vger.kernel.org>; Tue, 22 Nov 2016 06:19:24 -0800 (PST)
Date: Tue, 22 Nov 2016 09:19:19 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] nec decoder: wrong bit order for nec32 protocol
Message-ID: <20161122141919.GF21644@redhat.com>
References: <1478708015-1164-5-git-send-email-sean@mess.org>
 <20161122113506.1a604721@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161122113506.1a604721@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 22, 2016 at 11:35:06AM -0200, Mauro Carvalho Chehab wrote:
> Em Wed,  9 Nov 2016 16:13:35 +0000
> Sean Young <sean@mess.org> escreveu:
> 
> > The bits are sent in lsb first. Hardware decoders also send nec32
> > in this order (e.g. dib0700). This should be consistent, however
> > I have no way of knowing which order the LME2510 and Tivo keymaps
> > are (the only two kernel keymaps with NEC32).
> 
> Hmm.. the lme2510 receives the scancode directly. So, this
> patch shouldn't affect it. So, we're stuck with the Tivo IR.
> 
> On Tivo, only a few keys (with duplicated scancodes) don't start with
> 0xa10c. So, it *seems* that this is an address.
> 
> The best here would be to try to get a Tivo remote controller[1], and
> do some tests with a driver that has a hardware decoder capable of
> output NEC32 data, and some driver that receives raw IR data in
> order to be sure.
> 
> In any case, we need to patch both the NEC32 decoder and the table
> at the same time, to be 100% sure.
> 
> [1] or some universal remote controller that could emulate
> the Tivo's scan codes. I suspect that the IR in question is
> this one, but maybe Jarod could shed some light here:
> 	https://www.amazon.com/TiVo-Remote-Control-Universal-Replacement/dp/B00DYYKA04

Been away from the game for a few years now, so there are a good number of
cobwebs in this section of my brain... I'm pretty sure I do have both a
remote and receiver on hand that would fit the bill here though. Is the
question primarily about what actually gets emitted by the TiVo remote?

-- 
Jarod Wilson
jarod@redhat.com


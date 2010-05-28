Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34657 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab0E1ThH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 15:37:07 -0400
Received: by vws9 with SMTP id 9so1407848vws.19
        for <linux-media@vger.kernel.org>; Fri, 28 May 2010 12:37:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>
References: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>
Date: Fri, 28 May 2010 15:31:28 -0400
Message-ID: <AANLkTimszcET1uW1f5r9n_bPv8YdrKloSoigDw_i57K2@mail.gmail.com>
Subject: Re: ir-core multi-protocol decode and mceusb
From: Jarod Wilson <jarod@wilsonet.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 28, 2010 at 12:47 AM, Jarod Wilson <jarod@wilsonet.com> wrote:
> So I'm inching closer to a viable mceusb driver submission -- both a
> first-gen and a third-gen transceiver are now working perfectly with
> multiple different mce remotes. However, that's only when I make sure
> the mceusb driver is loaded w/only the rc6 decoder loaded. When
> ir-core comes up, it requests all decoders to load, starting with the
> nec decoder, followed by the rc5 decoder, then the rc6 decoder and so
> on (init_decoders() in ir-raw-event.c). When I call
> ir_raw_event_handle, all decoders get run on the ir data buffer,
> starting with nec. Well, the nec decoder doesn't like the rc6 data, so
> it pukes. The RUN_DECODER macro break's out of the routine when that
> happens, and the rc6 decoder never gets a chance to run. (Similarly,
> if only ir-nec-decoder has been removed, the rc5 decoder pukes on the
> rc6 data, same problem).

A quasi-related problem: I seem to be unable to ever get the module
refcount on ir-core down to zero to be able to unload it. Seems
sometimes the ir-foo-decoder modules' unload doesn't reduce the
refcount, but even if I remove drivers first, then keymaps, then
decoders, then ir-common, I'm left w/ir-core having a refcount of 1.
Maybe I don't have the right ordering or something, but I suspect
something is slightly wonky here, shouldn't be that hard to unload
ir-core.

> If I'm thinking clearly, rather than breaking
> out of the loop in RUN_DECODER, we really ought to be issuing a
> continue to go on to the next decoder, and possibly be accumulating
> failures, though I don't know that _sumrc actually matters other than
> "greater than zero" (i.e., at least one decoder was successfully able
> to decode the signal). If I'm not thinking clearly, a pointer to what
> I'm missing would be appreciated. :)

I've tested this out, it works. I've got a 4-patch series that
includes this that I'll submit for review shortly...

-- 
Jarod Wilson
jarod@wilsonet.com

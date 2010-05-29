Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:7806 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988Ab0E2Mjl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 08:39:41 -0400
Subject: Re: ir-core multi-protocol decode and mceusb
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>
References: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 08:39:53 -0400
Message-ID: <1275136793.2260.18.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-05-28 at 00:47 -0400, Jarod Wilson wrote:
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

Yes, if the system kernel is going to attempt to discriminate between
various input singals, it needs to let all its "correlators" run and
produce a "confidence" number from each.

Then ideally one would take the result with the highest confidence.

Right now it looks like all the confidence determinations are boolean (0
or -EINVAL) and there is no chance to deal with the case that two
different decoders validly decode something.  The first decoder that
declares a match "wins" and sends an event.



>  If I'm thinking clearly, rather than breaking
> out of the loop in RUN_DECODER, we really ought to be issuing a
> continue to go on to the next decoder, and possibly be accumulating
> failures, though I don't know that _sumrc actually matters other than
> "greater than zero" (i.e., at least one decoder was successfully able
> to decode the signal). If I'm not thinking clearly, a pointer to what
> I'm missing would be appreciated. :)

You will have to deal with the case that two or more decoders may match
and each sends an IR event.  (Unless the ir-core already deals with this
somehow...)

Regards,
Andy


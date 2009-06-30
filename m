Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:56473 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZF3OhH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 10:37:07 -0400
To: linux-input@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: RFC: Remote control sensors and Linux input layer
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 30 Jun 2009 16:37:08 +0200
Message-ID: <m3ab3prdnv.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Any feedback, pointers etc. will be appreciated:

I'm currently implementing RC support for AverMedia Super 007 TV
adapter. The hardware is apparently simple: a TSOP18xx-style sensor jack
is connected almost directly to GPIO18 ball (active-low) of SAA7131E.

I added mask_keyup = 0x40000 and rc5_gpio = 1 in saa7134-input.c but the
existing code doesn't seem to work correctly for me. It looks like the
timings of my RC (using TV set RC) are a bit different than those of the
PC and it goes out of sync after. Currently the code depends on the
timestamp of the first transmission (rising edge) and doesn't check the
validity of all received bits. It doesn't process falling edges at all.
I thought my RC uses a different "gap" value but it doesn't seem to be
the case.

1. I propose a bit different algorithm, the most important thing is the
code would not depend on the absolute time from the first edge but it
would use the "last bit" (or two bits) time instead. It would make it
much more reliable and at the same time would allow detecting of many
spurious / faulty transmissions (which currently can't be detected).

I also considered acting on both (rising and falling) edges but it would
means twice as many IRQs. Another idea is acting on falling edge
(instead of rising), that would mean the last bit (in case it's 0) could
be detected by the IRQ handler instead of "timeout" routine. Will think
about it.
SAA713x is able to act on either (or both edges), but the code is also
used by the bttv driver, does it have the same capability?

Now this changed algorithm recognizes my RC5 remote's codes perfectly.


2. Currently a single board type seems to be limited to a particular RC
type. This is a problem with HTPC approach, where using the display's RC
would be natural (most TV set RCs have additional "modes" to work with
VCRs, SATs etc). I'm thinking about something similar to the keyboards
map (which can be modified on the fly).
Or perhaps there is something like that already available?


3. The existing RC5 decoder(s) assume 2-bit start, 1 toggle bit, 5-bit
"group code" and 6-bit command. This assumption doesn't seem valid
anymore - now the second start bit became MSB of command (it's inverted
for compatibility). Modifications to the decoder are trivial, though.


4. The raw "key" value (i.e., raw RC5). Is it available via the input
layer? That would make sense for multiple RCs, with LIRC daemon or
something similar. The current code only supports one RC5 "group" code
for each input (i.e., one RC or RC "mode").

I'm attaching a test patch for "1" and "3". It's incomplete, breaks
bttv, but it currently works with my Philips RC and Super 007 DVB-T
board.
-- 
Krzysztof Halasa

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab0HBPYK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 11:24:10 -0400
Date: Mon, 2 Aug 2010 11:12:25 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Christoph Bartelmus <lirc@bartelmus.de>, jarod@wilsonet.com,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, maximlevitsky@gmail.com,
	mchehab@redhat.com
Subject: Remote that breaks current system (was: IR: Port ene driver...) it.
Message-ID: <20100802151225.GA2296@redhat.com>
References: <AANLkTimaut1mMUXwbJAgjNjmQkxgsf-GOCTXmKYNm1Lz@mail.gmail.com>
 <BTtOJbzJjFB@christoph>
 <AANLkTikRBupAsSSk5QmudHrpEccMSOjmK2bT+xg8CocK@mail.gmail.com>
 <1280602281.20879.76.camel@localhost>
 <AANLkTi=tZaSGp3V8+4FHupzegmVrgM4-dzJb-y8YazOh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=tZaSGp3V8+4FHupzegmVrgM4-dzJb-y8YazOh@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 31, 2010 at 05:53:33PM -0400, Jon Smirl wrote:
> On Sat, Jul 31, 2010 at 2:51 PM, Andy Walls <awalls@md.metrocast.net> wrote:
...
> > Since these two protocols have such close timings that systematic errors
> > can cause misclassification when using simple mark or space measurements
> > against fixed thresholds, it indicates that a more sophisticated
> > discrimination mechanism would be needed.  Perhaps one that takes multiple
> > successive measurements into account?
> 
> If we get to the point where we need more sophisticated
> classifications we can build it. But are we at that point yet? I'd
> prefer to initially leave everything pretty strict as a way of
> flushing out driver implementation bugs.
> 
> Find some remotes and receivers that break the current system.

Got one. The Streamzap PC Remote. Its 14-bit RC5. Can't get it to properly
decode in-kernel for the life of me. I got lirc_streamzap 99% of the way
ported over the weekend, but this remote just won't decode correctly w/the
in-kernel RC5 decoder.

Working:
Streamzap receiver + RC6 (MCE) remote, in-kernel decoding
Streamzap receiver + RC5 (Streamzap) remote, lirc decoding

Not working:
Streamzap receiver + RC5 (Streamzap) remote, in-kernel decoding
MCE transceiver + RC5 (Streamzap) remote, in-kernel decoding

Failure mode is identical between the two, leading me to believe my
streamzap port is good to go, we just have an issue to track down with rc5
decoding.

Said failure mode is that RC5 fails at STATE_INACTIVE (0) with the initial
space provided by both receivers, then gets rolling with (I believe) the
first pulse. It then gets all the way to STATE_FINISHED, and bails,
because it should be on a space there, but its on a pulse.

I've twiddled the decoder to proceed even if its a pulse, but the
resulting decoding is still no good, as multiple adjacent keys (which have
proper decoded values that only differ by 1, per lirc decoding) get
decoded to the same value as one another.

Still poking around trying to figure out the problem, but here's what the
(slightly modified to not bail when it gets to STATE_FINISHED with a
pulse) rc5 decoder is seeing/doing:

ir_rc5_decode: RC5(x) decode started at state 0 (4292819813us space)
ir_rc5_decode: RC5(x) decode failed at state 0 (4292819813us space)
ir_rc5_decode: RC5(x) decode started at state 0 (896us pulse)
ir_rc5_decode: RC5(x) decode started at state 1 (7us pulse)
ir_rc5_decode: RC5(x) decode started at state 1 (896us space)
ir_rc5_decode: RC5(x) decode started at state 2 (1920us pulse)
ir_rc5_decode: RC5(x) decode started at state 1 (1031us pulse)
ir_rc5_decode: RC5(x) decode started at state 2 (1664us space)
ir_rc5_decode: RC5(x) decode started at state 1 (775us space)
ir_rc5_decode: RC5(x) decode started at state 2 (1664us pulse)
ir_rc5_decode: RC5(x) decode started at state 1 (775us pulse)
ir_rc5_decode: RC5(x) decode started at state 2 (896us space)
ir_rc5_decode: RC5(x) decode started at state 1 (7us space)
ir_rc5_decode: RC5(x) decode started at state 1 (896us pulse)
ir_rc5_decode: RC5(x) decode started at state 2 (896us space)
ir_rc5_decode: RC5(x) decode started at state 1 (7us space)
ir_rc5_decode: RC5(x) decode started at state 1 (896us pulse)
ir_rc5_decode: RC5(x) decode started at state 2 (1664us space)
ir_rc5_decode: RC5(x) decode started at state 1 (775us space)
ir_rc5_decode: RC5(x) decode started at state 2 (896us pulse)
ir_rc5_decode: RC5(x) decode started at state 3 (7us pulse)
ir_rc5_decode: RC5(x) decode started at state 3 (896us space)
ir_rc5_decode: RC5(x) decode started at state 1 (896us space)
ir_rc5_decode: RC5(x) decode started at state 2 (1920us pulse)
ir_rc5_decode: RC5(x) decode started at state 1 (1031us pulse)
ir_rc5_decode: RC5(x) decode started at state 2 (1664us space)
ir_rc5_decode: RC5(x) decode started at state 1 (775us space)
ir_rc5_decode: RC5(x) decode started at state 2 (1664us pulse)
ir_rc5_decode: RC5(x) decode started at state 1 (775us pulse)
ir_rc5_decode: RC5(x) decode started at state 2 (896us space)
ir_rc5_decode: RC5(x) decode started at state 1 (7us space)
ir_rc5_decode: RC5(x) decode started at state 1 (896us pulse)
ir_rc5_decode: RC5(x) decode started at state 2 (1664us space)
ir_rc5_decode: RC5(x) decode started at state 1 (775us space)
ir_rc5_decode: RC5(x) decode started at state 2 (1920us pulse)
ir_rc5_decode: RC5(x) decode started at state 4 (1031us pulse)
ir_rc5_decode: RC5 usually ends w/space, wtf?
ir_rc5_decode: RC5 scancode 0x1129 (toggle: 0)
ir_getkeycode: unknown key for scancode 0x1129

This was for the OK button on the remote, which in lircd, decodes to
scancode 0x12 in the lower 6 bits, high 8 bits are 0xa3 for all buttons.
At least, I think I'm decoding lircd.conf correctly. See here to be sure:

http://lirc.sourceforge.net/remotes/streamzap/lircd.conf.streamzap

-- 
Jarod Wilson
jarod@redhat.com


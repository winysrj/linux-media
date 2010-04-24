Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:57779 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0DXFML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 01:12:11 -0400
Date: Sat, 24 Apr 2010 07:12:06 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/15] ir-core: Several improvements to allow adding
 LIRC and decoder plugins
Message-ID: <20100424051206.GA3101@hardeman.nu>
References: <20100401145632.5631756f@pedra>
 <t2z9e4733911004011844pd155bbe8g13e4cbcc1a5bf1f6@mail.gmail.com>
 <20100402102011.GA6947@hardeman.nu>
 <p2ube3a4a1004051349y11e3004bk1c71e3ab38d3f669@mail.gmail.com>
 <20100407093205.GB3029@hardeman.nu>
 <z2hbe3a4a1004231040uce51091fnf24b97de215e3ef1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <z2hbe3a4a1004231040uce51091fnf24b97de215e3ef1@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 23, 2010 at 01:40:34PM -0400, Jarod Wilson wrote:
> So now that I'm more or less done with porting the imon driver, I
> think I'm ready to start tackling the mceusb driver. But I'm debating
> on what approach to take with respect to lirc support. It sort of
> feels like we should have lirc_dev ported as an ir "decoder"
> driver/plugin before starting to port mceusb to ir-core, so that we
> can maintain lirc compat and transmit support. Alternatively, I could
> port mceusb without lirc support for now, leaving it to only use
> in-kernel decoding and have no transmit support for the moment, then
> re-add lirc support. I'm thinking that porting lirc_dev as, say,
> ir-lirc-decoder first is probably the way to go though. Anyone else
> want to share their thoughts on this?

I think it would make sense to start with a mce driver without the TX 
and lirc bits first. Adding lirc rx support can be done as a separate 
"raw" decoder later (so its scope is outside the mce driver anyway) and 
TX support is not implemented in ir-core yet and we haven't had any 
discussion yet on which form it should take.

> (Actually, while sharing thoughts... Should drivers/media/IR become
> drivers/media/RC, ir-core.h become rc-core.h, ir-keytable.c become
> rc-keytable.c and so on?)

It will happen...and on a related note, I still think rc-core should in 
the end expose an API where drivers create "rc" devices and the input 
device(s) are kept as an internal detail in rc-core rather than the way 
it works now (where drivers create input devices and use ir-core to 
create a kind of addon device).

But that change is about as disruptive as the ir-core -> rc-core change, 
so it can also wait to a more convenient time.

-- 
David Härdeman

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.22]:6563 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab0HFJlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Aug 2010 05:41:05 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2317.sfr.fr (SMTP Server) with ESMTP id 919527000087
	for <linux-media@vger.kernel.org>; Fri,  6 Aug 2010 11:40:59 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (81.148.200-77.rev.gaoland.net [77.200.148.81])
	by msfrf2317.sfr.fr (SMTP Server) with SMTP id 441DD7000086
	for <linux-media@vger.kernel.org>; Fri,  6 Aug 2010 11:40:59 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.200.148.81] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Fri, 06 Aug 2010 11:40:57 +0200
Subject: Re: Fwd: No audio in HW Compressed MPEG2 container on HVR-1300
From: lawrence rust <lawrence@softsystem.co.uk>
To: Shane Harrison <shane.harrison@paragon.co.nz>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTik0UZmf5b4nTi1AgFiKQAGkvU47_dN0gUSw3urs@mail.gmail.com>
References: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
	 <1280741544.1361.17.camel@gagarin>
	 <AANLkTinHK8mVwrCnOZTUMsHVGTykj8bNdkKwcbMQ8LK_@mail.gmail.com>
	 <AANLkTi=M2wVY3vL8nGBg-YqUtRidBahpE5OXbjr5k96X@mail.gmail.com>
	 <1280750394.1361.87.camel@gagarin>
	 <AANLkTi=V3eKuJ1jXPcBuSxUy6djCoK4q2pR-V0zo_cMS@mail.gmail.com>
	 <1280843299.1492.127.camel@gagarin>
	 <AANLkTik0UZmf5b4nTi1AgFiKQAGkvU47_dN0gUSw3urs@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 11:40:50 +0200
Message-ID: <1281087650.1332.26.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-08-06 at 11:49 +1200, Shane Harrison wrote:
[snip]
> Well still no luck this end.  Have done the following:
> 1) Swapped boards - no change
> 2) Applied the patch - no change (we were detecting the WM8775 OK
> anyway and the other changes were either non HVR-1300 or we had
> already tried them so probably not too surprising
> 3) Made sure I2SINPUT is enabled - no change
> 
> So still have the following strange observations:
> 1) Repeatedly swapping between inputs eventually gives us audio
> 2) Once fixed it survives a warm reboot but not power cycle

Because of the the warm boot survival I'm tempted to think that this is
a cx23416 firmware problem.

I don't have any experience with cx23416 programming but from looking at
cx88-blackbird.c it appears that the firmware is only loaded from the
function blackbird_initialize_codec() if the chip doesn't respond to a
'ping' command.  blackbird_initialize_codec() is called during probing,
during the first open and whenever the tuner frequency is changed - i.e.
when inputs are changed.  I would be tempted to set this module's debug
parameter and see if there's a coincidence of resetting/reloading the
firmware and the audio path being enabled.

> 3) Putting a scope on the I2S line out of the CX2388x shows noise when
> TV input selected and no noise for Composite (unless inject a tone).

This confirms that the cx2388x is setup OK

> However MPEG-2 audio always contains hiss or hiss plus injected tone.

This tells me that the cx23416 is not configured right.

> So looks like two issues to me.  I'll try and modify the driver so
> that when switching inputs we only config the WM8775 or the CX2388x or
> the MPEG encoder and see if I can determine which item has the
> configuration issue.

Seems like a good idea, but I would put money on the cx23416.

I would recommend looking at the debug output from cx88-blackbird and if
there's anything unusual then temporarily disable the ping test in
blackbird_initialize_codec() and always reset and re-load the firmware.
If this helps then maybe add some delays around the reset for a long
term fix.

-- Lawrence Rust



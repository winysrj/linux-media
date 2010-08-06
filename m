Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:22365 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755390Ab0HFMQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Aug 2010 08:16:29 -0400
Subject: Re: Fwd: No audio in HW Compressed MPEG2 container on HVR-1300
From: Andy Walls <awalls@md.metrocast.net>
To: lawrence rust <lawrence@softsystem.co.uk>
Cc: Shane Harrison <shane.harrison@paragon.co.nz>,
	linux-media@vger.kernel.org
In-Reply-To: <1281087650.1332.26.camel@gagarin>
References: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
	 <1280741544.1361.17.camel@gagarin>
	 <AANLkTinHK8mVwrCnOZTUMsHVGTykj8bNdkKwcbMQ8LK_@mail.gmail.com>
	 <AANLkTi=M2wVY3vL8nGBg-YqUtRidBahpE5OXbjr5k96X@mail.gmail.com>
	 <1280750394.1361.87.camel@gagarin>
	 <AANLkTi=V3eKuJ1jXPcBuSxUy6djCoK4q2pR-V0zo_cMS@mail.gmail.com>
	 <1280843299.1492.127.camel@gagarin>
	 <AANLkTik0UZmf5b4nTi1AgFiKQAGkvU47_dN0gUSw3urs@mail.gmail.com>
	 <1281087650.1332.26.camel@gagarin>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 08:15:42 -0400
Message-ID: <1281096942.2052.11.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-08-06 at 11:40 +0200, lawrence rust wrote:
> On Fri, 2010-08-06 at 11:49 +1200, Shane Harrison wrote:
> [snip]
> > Well still no luck this end.  Have done the following:
> > 1) Swapped boards - no change
> > 2) Applied the patch - no change (we were detecting the WM8775 OK
> > anyway and the other changes were either non HVR-1300 or we had
> > already tried them so probably not too surprising
> > 3) Made sure I2SINPUT is enabled - no change
> > 
> > So still have the following strange observations:
> > 1) Repeatedly swapping between inputs eventually gives us audio
> > 2) Once fixed it survives a warm reboot but not power cycle
> 
> Because of the the warm boot survival I'm tempted to think that this is
> a cx23416 firmware problem.

I recommend you check the ivtv-devel list archives from earlier this
year.  A few fixes were put in place to deal with the CX23416 startup
and flickering video, and CX23416 audio not working.

I can only find this reference right now:

http://www.gossamer-threads.com/lists/ivtv/devel/40907#40907

You can check the latest changes to the ivtv driver for some help in
what actions may help the situation.  (Keep in mind many ivtv designs
are being fed from the I2S output of a CX25843 though.)


> I don't have any experience with cx23416 programming but from looking at
> cx88-blackbird.c it appears that the firmware is only loaded from the
> function blackbird_initialize_codec() if the chip doesn't respond to a
> 'ping' command.  blackbird_initialize_codec() is called during probing,
> during the first open and whenever the tuner frequency is changed - i.e.
> when inputs are changed.  I would be tempted to set this module's debug
> parameter and see if there's a coincidence of resetting/reloading the
> firmware and the audio path being enabled.
> 
> > 3) Putting a scope on the I2S line out of the CX2388x shows noise when
> > TV input selected and no noise for Composite (unless inject a tone).
> 
> This confirms that the cx2388x is setup OK
> 
> > However MPEG-2 audio always contains hiss or hiss plus injected tone.
> 
> This tells me that the cx23416 is not configured right.

Well maybe.  Looking at Martin's and Ian's troubleshooting on the
ivtv-devel list from earlier this year, there appear to be some races
within the firmware itself and some sensitivities to when clock lines
are active when reconfiguring.


> 
> > So looks like two issues to me.  I'll try and modify the driver so
> > that when switching inputs we only config the WM8775 or the CX2388x or
> > the MPEG encoder and see if I can determine which item has the
> > configuration issue.
> 
> Seems like a good idea, but I would put money on the cx23416.

I wouldn't bet against you on that one.


> I would recommend looking at the debug output from cx88-blackbird and if
> there's anything unusual then temporarily disable the ping test in
> blackbird_initialize_codec() and always reset and re-load the firmware.

The ping command itself should be harmless.


> If this helps then maybe add some delays around the reset for a long
> term fix.

Delays here and there and gating clocks off and then back on are about
all that you have at your disposal.

I don't know if the cx88 driver supports it, but the ivtv driver
provides a /dev/video24 that provides the raw PCM stream from the
CX23416.  If the cx88 driver supports that, it may be another test point
worth checking: aplay -f dat < /dev/video24 .


Regards,
Andy

> -- Lawrence Rust



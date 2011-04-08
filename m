Return-path: <mchehab@pedra>
Received: from smtp21.services.sfr.fr ([93.17.128.1]:10611 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab1DHQxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 12:53:48 -0400
Received: from smtp21.services.sfr.fr (msfrf2108 [10.18.25.22])
	by msfrf2105.sfr.fr (SMTP Server) with ESMTP id 64B2E7000CF5
	for <linux-media@vger.kernel.org>; Fri,  8 Apr 2011 18:53:45 +0200 (CEST)
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2108.sfr.fr (SMTP Server) with ESMTP id 10415700008C
	for <linux-media@vger.kernel.org>; Fri,  8 Apr 2011 18:50:44 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (unknown [93.14.171.92])
	by msfrf2108.sfr.fr (SMTP Server) with SMTP id B7AD27000097
	for <linux-media@vger.kernel.org>; Fri,  8 Apr 2011 18:50:43 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.14.171.92] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 18:50:42 +0200
Subject: Re: [PATCH] Fix cx88 remote control input
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com>
References: <1302267045.1749.38.camel@gagarin>
	 <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com>
	 <1302276147.1749.46.camel@gagarin>
	 <B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 18:50:41 +0200
Message-ID: <1302281441.1749.75.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2011-04-08 at 12:21 -0400, Jarod Wilson wrote:
> On Apr 8, 2011, at 11:22 AM, Lawrence Rust wrote:
> 
> > On Fri, 2011-04-08 at 10:41 -0400, Jarod Wilson wrote:
> >> On Apr 8, 2011, at 8:50 AM, Lawrence Rust wrote:
> >> 
> >>> This patch restores remote control input for cx2388x based boards on
> >>> Linux kernels >= 2.6.38.
> >>> 
> >>> After upgrading from Linux 2.6.37 to 2.6.38 I found that the remote
> >>> control input of my Hauppauge Nova-S plus was no longer functioning.  
> >>> I posted a question on this newsgroup and Mauro Carvalho Chehab gave
> >>> some helpful pointers as to the likely cause.
> >>> 
> >>> Turns out that there are 2 problems:
> >> ...
> >>> 2. The RC5 decoder appends the system code to the scancode and passes
> >>> the combination to rc_keydown().  Unfortunately, the combined value is
> >>> then forwarded to input_event() which then fails to recognise a valid
> >>> scancode and hence no input events are generated.
> >> 
> >> Just to clarify on this one, you're missing a step. We get the scancode,
> >> and its passed to rc_keydown. rc_keydown then looks for a match in the
> >> loaded keytable, then passes the *keycode* that matches the scancode
> >> along to input_event. If you fix the keytable to contain system and
> >> command, everything should work just fine again. Throwing away data is
> >> a no-no though -- take a look at recent changes to ir-kdb-i2c, which
> >> actually just recently made it start *including* system. :)
> > 
> > Don't shoot the messenger.
> 
> Wasn't my intention. I was simply trying to explain why your "fix"
> isn't correct.
> 
> 
> > I'm just reporting what I had to do to fix a clumsy hack by someone 6
> > months ago who didn't test their changes.  This patch _restores_ the
> > operation of a subsystem broken by those changes
> > 
> > Perhaps those responsible for commit
> > 2997137be8eba5bf9c07a24d5fda1f4225f9ca7d:
> > 
> >    Signed-off-by: David Härdeman <david@hardeman.nu>
> >    Acked-by: Jarod Wilson <jarod@redhat.com>
> >    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > should fix the keytable.  In the meantime (next year) I'll be using this
> > patch.
> 
> The entire commit message:
> 
>     [media] ir-core: convert drivers/media/video/cx88 to ir-core
>     
>     This patch converts the cx88 driver (for sampling hw) to use the
>     decoders provided by ir-core instead of the separate ones provided
>     by ir-functions (and gets rid of those).
>     
>     The value for MO_DDS_IO had a comment saying it corresponded to
>     a 4kHz samplerate. That comment was unfortunately misleading. The
>     actual samplerate was something like 3250Hz.
>     
>     The current value has been derived by analyzing the elapsed time
>     between interrupts for different values (knowing that each interrupt
>     corresponds to 32 samples).
>     
>     Thanks to Mariusz Bialonczyk <manio@skyboo.net> for testing my patches
>     (about one a day for two weeks!) on actual hardware.
> 
> Please note the part about how it *was* tested. And this certainly
> was not a "clumsy hack", I'd actually call it a fairly skilled bit
> of code de-duplication by David. Anyway...
> 
> The problem is that there isn't a "the keytable". There are many
> many keytables. And a lot of different hardware. Testing all possible
> combinations of hardware (both receiver side and remote side) is
> next to impossible.

Hauppauge have the lion's share of the DVB card market so this mod
should have been tested with a Haupauge RC, but clearly wasn't.  It also
clearly wasn't tested with a cx2388x card because the interrupt handler
has an obvious overflow.

>  We do what we can. Its unfortunate that your
> hardware regressed in functionality. It happens, but it *can* be
> fixed. The fix you provided just wasn't correct.

It is correct for 2.6.38, which is what was described.  I haven't
checked all the keymaps but a sample of 5 show that none include a
system ID.

>  The correct fix is
> trivially updating drivers/media/rc/keymaps/<insert-your-keymap-here>.

So, cherrypick the Hauppauge keytable from 2.6.39 and apply it to 2.6.38
together with the 2nd part of this patch.  It would be real nice if that
was in 2.6.38.3

-- 
Lawrence



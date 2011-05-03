Return-path: <mchehab@pedra>
Received: from smtp24.services.sfr.fr ([93.17.128.83]:55829 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1ECH2U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 03:28:20 -0400
Received: from smtp24.services.sfr.fr (msfrf2409 [10.18.29.23])
	by msfrf2410.sfr.fr (SMTP Server) with ESMTP id 8EE5770001F4
	for <linux-media@vger.kernel.org>; Tue,  3 May 2011 09:28:19 +0200 (CEST)
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2409.sfr.fr (SMTP Server) with ESMTP id 129F9700008D
	for <linux-media@vger.kernel.org>; Tue,  3 May 2011 09:25:17 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (145.245.194-77.rev.gaoland.net [77.194.245.145])
	by msfrf2409.sfr.fr (SMTP Server) with SMTP id B4B93700008A
	for <linux-media@vger.kernel.org>; Tue,  3 May 2011 09:25:16 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.193.80.239] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Tue, 03 May 2011 09:25:15 +0200
Subject: Re: [PATCH] Fix cx88 remote control input
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4DBEFD02.70906@redhat.com>
References: <1302267045.1749.38.camel@gagarin>  <4DBEFD02.70906@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 09:25:14 +0200
Message-ID: <1304407514.1739.22.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-05-02 at 15:50 -0300, Mauro Carvalho Chehab wrote:
> Em 08-04-2011 09:50, Lawrence Rust escreveu:
> > This patch restores remote control input for cx2388x based boards on
> > Linux kernels >= 2.6.38.
> > 
> > After upgrading from Linux 2.6.37 to 2.6.38 I found that the remote
> > control input of my Hauppauge Nova-S plus was no longer functioning.  
> > I posted a question on this newsgroup and Mauro Carvalho Chehab gave
> > some helpful pointers as to the likely cause.
> > 
> > Turns out that there are 2 problems:
> > 
> > 1. In the IR interrupt handler of cx88-input.c there's a 32-bit multiply
> > overflow which causes IR pulse durations to be incorrectly calculated.
> > 
> > 2. The RC5 decoder appends the system code to the scancode and passes
> > the combination to rc_keydown().  Unfortunately, the combined value is
> > then forwarded to input_event() which then fails to recognise a valid
> > scancode and hence no input events are generated.
> > 
> > I note that in commit 2997137be8eba5bf9c07a24d5fda1f4225f9ca7d, which
> > introduced these changes, David Härdeman changed the IR sample frequency
> > to a supposed 4kHz.  However, the registers dealing with IR input are
> > undocumented in the cx2388x datasheets and there's no publicly available
> > information on them.  I have to ask the question why this change was
> > made as it is of no apparent benefit and could have unanticipated
> > consequences.  IMHO that change should also be reverted unless there is
> > evidence to substantiate it.
> > 
> > Signed off by: Lawrence Rust <lvr at softsystem dot co dot uk>
> > 
> > diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
> > index ebdba55..c4052da 100644
> > --- a/drivers/media/rc/ir-rc5-decoder.c
> > +++ b/drivers/media/rc/ir-rc5-decoder.c
> > @@ -144,10 +144,15 @@ again:
> >  			system   = (data->bits & 0x007C0) >> 6;
> >  			toggle   = (data->bits & 0x00800) ? 1 : 0;
> >  			command += (data->bits & 0x01000) ? 0 : 0x40;
> > -			scancode = system << 8 | command;
> > -
> > -			IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
> > -				   scancode, toggle);
> > +            /* Notes
> > +             * 1. Should filter unknown systems e.g Hauppauge use 0x1e or 0x1f
> > +             * 2. Don't include system in the scancode otherwise input_event()
> > +             *    doesn't recognise the scancode
> > +             */
> > +			scancode = command;
> > +
> > +			IR_dprintk(1, "RC5 scancode 0x%02x (system: 0x%02x toggle: %u)\n",
> > +				   scancode, system, toggle);
> >  		}
> >  
> >  		rc_keydown(dev, scancode, toggle);
> 
> I agree with Jarod: The above hunk shouldn't go upstream, or else it would break _lots_ of
> remotes.
> 
> > diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
> > index c820e2f..7281db4 100644
> > --- a/drivers/media/video/cx88/cx88-input.c
> > +++ b/drivers/media/video/cx88/cx88-input.c
> > @@ -524,7 +524,7 @@ void cx88_ir_irq(struct cx88_core *core)
> >  	for (todo = 32; todo > 0; todo -= bits) {
> >  		ev.pulse = samples & 0x80000000 ? false : true;
> >  		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
> > -		ev.duration = (bits * NSEC_PER_SEC) / (1000 * ir_samplerate);
> > +		ev.duration = bits * (NSEC_PER_SEC / (1000 * ir_samplerate)); /* NB avoid 32-bit overflow */
> >  		ir_raw_event_store_with_filter(ir->dev, &ev);
> >  		samples <<= bits;
> >  	}
> 
> This change is OK, though. Yet. due to precision issues, it is better to do a 64-bit
> multiplication and use do_div for the division. This is compatible with 32 bits and 64
> bits systems, and will reduce error noise at the duration.
> 
> I've reworked that part of the patch, as follows.

The following is a much simpler change that maintains precision and
avoids 64-bit arithmetic.  Moving the division by 1000 and grouping it
with (NSEC_PER_SEC / 1000), an exact integer, avoids the 32-bit overflow
and allows the compiler to optimise the division without losing any
precision.

diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 06f7d1d..67a2b08 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -523,7 +523,7 @@ void cx88_ir_irq(struct cx88_core *core)
 	for (todo = 32; todo > 0; todo -= bits) {
 		ev.pulse = samples & 0x80000000 ? false : true;
 		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
-		ev.duration = (bits * NSEC_PER_SEC) / (1000 * ir_samplerate);
+		ev.duration = (bits * (NSEC_PER_SEC / 1000)) / ir_samplerate;
 		ir_raw_event_store_with_filter(ir->dev, &ev);
 		samples <<= bits;
 	}

And, FWIW the following patch fixes RC key input for Nova-S plus,
HVR1100, HVR3000 and HVR4000 in the 2.6.38 kernel.  Apparently a
Hauppauge keymap with system ID code was added in this release but the
cx88 code was not updated when the RC5 decoder changes were made:

diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 06f7d1d..67a2b08 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -283,7 +283,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PCHDTV_HD3000:
 	case CX88_BOARD_PCHDTV_HD5500:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
-		ir_codes = RC_MAP_HAUPPAUGE_NEW;
+		ir_codes = RC_MAP_RC5_HAUPPAUGE_NEW;
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:

Signed off by: Lawrence Rust < lvr at softsystem dot co dot uk >

> Thanks!
> Mauro
> 
> -
> >From 4c0fb469bf88e0b1880c703ab27895d66eb940d9 Mon Sep 17 00:00:00 2001
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date: Fri, 8 Apr 2011 09:50:45 -0300
> Subject: [PATCH] [media] Fix cx88 remote control input
> 
> As pointed by Lawrence Rust <lvr@softsystem.co.uk>:
> 
> In the IR interrupt handler of cx88-input.c there's a 32-bit multiply
> overflow which causes IR pulse durations to be incorrectly calculated.
> 
> This is a regression caused by commit 2997137be8eba.
> 
> Reported-by: Lawrence Rust <lvr@softsystem.co.uk>
> Cc: stable@kernel.org
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
> index c820e2f..97fdf5a 100644
> --- a/drivers/media/video/cx88/cx88-input.c
> +++ b/drivers/media/video/cx88/cx88-input.c
> @@ -27,6 +27,7 @@
>  #include <linux/pci.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> +#include <asm/div64.h>
>  
>  #include "cx88.h"
>  #include <media/rc-core.h>
> @@ -522,9 +523,16 @@ void cx88_ir_irq(struct cx88_core *core)
>  
>  	init_ir_raw_event(&ev);
>  	for (todo = 32; todo > 0; todo -= bits) {
> -		ev.pulse = samples & 0x80000000 ? false : true;
> +		u64 duration = NSEC_PER_SEC;
> +
>  		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
> -		ev.duration = (bits * NSEC_PER_SEC) / (1000 * ir_samplerate);
> +
> +		/* Avoid 32-bits overflow */
> +		duration = bits * duration;
> +		do_div(duration, 1000 * ir_samplerate);
> +
> +		ev.pulse = samples & 0x80000000 ? false : true;
> +		ev.duration = duration;
>  		ir_raw_event_store_with_filter(ir->dev, &ev);
>  		samples <<= bits;
>  	}
> 

-- 
Lawrence



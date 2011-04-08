Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40652 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab1DHOcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 10:32:32 -0400
Received: by qyg14 with SMTP id 14so2524232qyg.19
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 07:32:31 -0700 (PDT)
References: <1302267045.1749.38.camel@gagarin>
In-Reply-To: <1302267045.1749.38.camel@gagarin>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <AFD14A62-3E78-4183-94B2-9E6584241349@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH] Fix cx88 remote control input
Date: Fri, 8 Apr 2011 10:32:41 -0400
To: Lawrence Rust <lawrence@softsystem.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Apr 8, 2011, at 8:50 AM, Lawrence Rust wrote:

> This patch restores remote control input for cx2388x based boards on
> Linux kernels >= 2.6.38.
> 
> After upgrading from Linux 2.6.37 to 2.6.38 I found that the remote
> control input of my Hauppauge Nova-S plus was no longer functioning.  
> I posted a question on this newsgroup and Mauro Carvalho Chehab gave
> some helpful pointers as to the likely cause.
> 
> Turns out that there are 2 problems:
> 
> 1. In the IR interrupt handler of cx88-input.c there's a 32-bit multiply
> overflow which causes IR pulse durations to be incorrectly calculated.
> 
> 2. The RC5 decoder appends the system code to the scancode and passes
> the combination to rc_keydown().  Unfortunately, the combined value is
> then forwarded to input_event() which then fails to recognise a valid
> scancode and hence no input events are generated.
> 
> I note that in commit 2997137be8eba5bf9c07a24d5fda1f4225f9ca7d, which
> introduced these changes, David Härdeman changed the IR sample frequency
> to a supposed 4kHz.  However, the registers dealing with IR input are
> undocumented in the cx2388x datasheets and there's no publicly available
> information on them.  I have to ask the question why this change was
> made as it is of no apparent benefit and could have unanticipated
> consequences.  IMHO that change should also be reverted unless there is
> evidence to substantiate it.
> 
> Signed off by: Lawrence Rust <lvr at softsystem dot co dot uk>

Nacked-by: Jarod Wilson <jarod@redhat.com>

> diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
> index ebdba55..c4052da 100644
> --- a/drivers/media/rc/ir-rc5-decoder.c
> +++ b/drivers/media/rc/ir-rc5-decoder.c
> @@ -144,10 +144,15 @@ again:
> 			system   = (data->bits & 0x007C0) >> 6;
> 			toggle   = (data->bits & 0x00800) ? 1 : 0;
> 			command += (data->bits & 0x01000) ? 0 : 0x40;
> -			scancode = system << 8 | command;
> -
> -			IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
> -				   scancode, toggle);
> +            /* Notes
> +             * 1. Should filter unknown systems e.g Hauppauge use 0x1e or 0x1f
> +             * 2. Don't include system in the scancode otherwise input_event()
> +             *    doesn't recognise the scancode
> +             */
> +			scancode = command;
> +
> +			IR_dprintk(1, "RC5 scancode 0x%02x (system: 0x%02x toggle: %u)\n",
> +				   scancode, system, toggle);
> 		}
> 
> 		rc_keydown(dev, scancode, toggle);

This part is so very very wrong. We should NOT filter here. Filtering
can be achieved on the keymap side, and you *do* include the system
here. The fix for your issue is an update to the relevant keymap so
that its matching the system byte as well.

The divide fix looks sane though.

-- 
Jarod Wilson
jarod@wilsonet.com




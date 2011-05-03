Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57416 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab1ECRTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 13:19:43 -0400
Received: by gxk21 with SMTP id 21so109541gxk.19
        for <linux-media@vger.kernel.org>; Tue, 03 May 2011 10:19:42 -0700 (PDT)
References: <1302267045.1749.38.camel@gagarin>  <4DBEFD02.70906@redhat.com> <1304407514.1739.22.camel@gagarin>
In-Reply-To: <1304407514.1739.22.camel@gagarin>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <D7FAB30A-E204-47B9-A7A0-E3BF50EE7FBD@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH] Fix cx88 remote control input
Date: Tue, 3 May 2011 13:19:49 -0400
To: Lawrence Rust <lawrence@softsystem.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On May 3, 2011, at 3:25 AM, Lawrence Rust wrote:

> On Mon, 2011-05-02 at 15:50 -0300, Mauro Carvalho Chehab wrote:
>> Em 08-04-2011 09:50, Lawrence Rust escreveu:
>>> This patch restores remote control input for cx2388x based boards on
>>> Linux kernels >= 2.6.38.
>>> 
>>> After upgrading from Linux 2.6.37 to 2.6.38 I found that the remote
>>> control input of my Hauppauge Nova-S plus was no longer functioning.  
>>> I posted a question on this newsgroup and Mauro Carvalho Chehab gave
>>> some helpful pointers as to the likely cause.
>>> 
>>> Turns out that there are 2 problems:
>>> 
>>> 1. In the IR interrupt handler of cx88-input.c there's a 32-bit multiply
>>> overflow which causes IR pulse durations to be incorrectly calculated.
>>> 
>>> 2. The RC5 decoder appends the system code to the scancode and passes
>>> the combination to rc_keydown().  Unfortunately, the combined value is
>>> then forwarded to input_event() which then fails to recognise a valid
>>> scancode and hence no input events are generated.
>>> 
>>> I note that in commit 2997137be8eba5bf9c07a24d5fda1f4225f9ca7d, which
>>> introduced these changes, David Härdeman changed the IR sample frequency
>>> to a supposed 4kHz.  However, the registers dealing with IR input are
>>> undocumented in the cx2388x datasheets and there's no publicly available
>>> information on them.  I have to ask the question why this change was
>>> made as it is of no apparent benefit and could have unanticipated
>>> consequences.  IMHO that change should also be reverted unless there is
>>> evidence to substantiate it.
>>> 
>>> Signed off by: Lawrence Rust <lvr at softsystem dot co dot uk>
>>> 
>>> diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
>>> index ebdba55..c4052da 100644
>>> --- a/drivers/media/rc/ir-rc5-decoder.c
>>> +++ b/drivers/media/rc/ir-rc5-decoder.c
>>> @@ -144,10 +144,15 @@ again:
>>> 			system   = (data->bits & 0x007C0) >> 6;
>>> 			toggle   = (data->bits & 0x00800) ? 1 : 0;
>>> 			command += (data->bits & 0x01000) ? 0 : 0x40;
>>> -			scancode = system << 8 | command;
>>> -
>>> -			IR_dprintk(1, "RC5 scancode 0x%04x (toggle: %u)\n",
>>> -				   scancode, toggle);
>>> +            /* Notes
>>> +             * 1. Should filter unknown systems e.g Hauppauge use 0x1e or 0x1f
>>> +             * 2. Don't include system in the scancode otherwise input_event()
>>> +             *    doesn't recognise the scancode
>>> +             */
>>> +			scancode = command;
>>> +
>>> +			IR_dprintk(1, "RC5 scancode 0x%02x (system: 0x%02x toggle: %u)\n",
>>> +				   scancode, system, toggle);
>>> 		}
>>> 
>>> 		rc_keydown(dev, scancode, toggle);
>> 
>> I agree with Jarod: The above hunk shouldn't go upstream, or else it would break _lots_ of
>> remotes.
>> 
>>> diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
>>> index c820e2f..7281db4 100644
>>> --- a/drivers/media/video/cx88/cx88-input.c
>>> +++ b/drivers/media/video/cx88/cx88-input.c
>>> @@ -524,7 +524,7 @@ void cx88_ir_irq(struct cx88_core *core)
>>> 	for (todo = 32; todo > 0; todo -= bits) {
>>> 		ev.pulse = samples & 0x80000000 ? false : true;
>>> 		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
>>> -		ev.duration = (bits * NSEC_PER_SEC) / (1000 * ir_samplerate);
>>> +		ev.duration = bits * (NSEC_PER_SEC / (1000 * ir_samplerate)); /* NB avoid 32-bit overflow */
>>> 		ir_raw_event_store_with_filter(ir->dev, &ev);
>>> 		samples <<= bits;
>>> 	}
>> 
>> This change is OK, though. Yet. due to precision issues, it is better to do a 64-bit
>> multiplication and use do_div for the division. This is compatible with 32 bits and 64
>> bits systems, and will reduce error noise at the duration.
>> 
>> I've reworked that part of the patch, as follows.
> 
> The following is a much simpler change that maintains precision and
> avoids 64-bit arithmetic.  Moving the division by 1000 and grouping it
> with (NSEC_PER_SEC / 1000), an exact integer, avoids the 32-bit overflow
> and allows the compiler to optimise the division without losing any
> precision.
> 
> diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
> index 06f7d1d..67a2b08 100644
> --- a/drivers/media/video/cx88/cx88-input.c
> +++ b/drivers/media/video/cx88/cx88-input.c
> @@ -523,7 +523,7 @@ void cx88_ir_irq(struct cx88_core *core)
> 	for (todo = 32; todo > 0; todo -= bits) {
> 		ev.pulse = samples & 0x80000000 ? false : true;
> 		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
> -		ev.duration = (bits * NSEC_PER_SEC) / (1000 * ir_samplerate);
> +		ev.duration = (bits * (NSEC_PER_SEC / 1000)) / ir_samplerate;
> 		ir_raw_event_store_with_filter(ir->dev, &ev);
> 		samples <<= bits;
> 	}

ACK on this part for the devel tree.


> And, FWIW the following patch fixes RC key input for Nova-S plus,
> HVR1100, HVR3000 and HVR4000 in the 2.6.38 kernel.  Apparently a
> Hauppauge keymap with system ID code was added in this release but the
> cx88 code was not updated when the RC5 decoder changes were made:
> 
> diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
> index 06f7d1d..67a2b08 100644
> --- a/drivers/media/video/cx88/cx88-input.c
> +++ b/drivers/media/video/cx88/cx88-input.c
> @@ -283,7 +283,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
> 	case CX88_BOARD_PCHDTV_HD3000:
> 	case CX88_BOARD_PCHDTV_HD5500:
> 	case CX88_BOARD_HAUPPAUGE_IRONLY:
> -		ir_codes = RC_MAP_HAUPPAUGE_NEW;
> +		ir_codes = RC_MAP_RC5_HAUPPAUGE_NEW;
> 		ir->sampling = 1;
> 		break;
> 	case CX88_BOARD_WINFAST_DTV2000H:
> 
> Signed off by: Lawrence Rust < lvr at softsystem dot co dot uk >

ACK on this part for the 2.6.38.y stable tree.


-- 
Jarod Wilson
jarod@wilsonet.com




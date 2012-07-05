Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52499 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2GEOjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 10:39:19 -0400
Received: by gglu4 with SMTP id u4so7437998ggl.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 07:39:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9c21e63d50aba0e550a69a691dd12860@hardeman.nu>
References: <20120702115800.1275f944@kryten>
	<20120702115937.623d3b41@kryten>
	<20120703202825.GC29839@hardeman.nu>
	<20120705203035.196e238e@kryten>
	<9c21e63d50aba0e550a69a691dd12860@hardeman.nu>
Date: Thu, 5 Jul 2012 17:39:18 +0300
Message-ID: <CAF0Ff2nMFzW+M8wJG_Fx8Ah4_eyE7J9-YPWu-vt0wvC-Yo4BzQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] winbond-cir: Adjust sample frequency to
 improve reliability
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Anton Blanchard <anton@samba.org>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi David,

excuse me for my ignorance, but don't you think adjusting the IR
receiver to universal remote control is fundamentally wrong, while the
whole point of universal remote control like Logitech Harmony is to be
adjusted to the IR receiver and be able to be adjusted to any IR
receiver and not the other way around. so, that being said, my point
is maybe the whole discussion here is just wild goose chase until
those settings i mentioned in Logitech control software are not tried
and there is no evidence that has already being done based on the
information provided by Anton. we don't know what exactly those
settings applied to Logitech Harmony firmware via Logitech control
software do and it could be default pulse timings that are set trough
them are just out of specification for RC6 and need to be manually
refined using the Harmony firmware settings in question - once again
after all universal remote control is supposed to be able to fit any
IR receiver and any type of pulses and that's why provides series of
different settings in order to do that - the issue seems more like
misconfiguration of the universal remote control than Linux drivers
problem. i'm just trying to save you time chasing not existing
problems and don't mean anything else - i didn't even look at the
source code you're discussing - i just have practical experience with
Logitech Harmony 890 and thus i know keymaps and protocols are
independently set from the proper pulse timings with Logitech control
software.

best regards,
konstantin

On Thu, Jul 5, 2012 at 5:13 PM, David Härdeman <david@hardeman.nu> wrote:
> On Thu, 5 Jul 2012 20:30:35 +1000, Anton Blanchard <anton@samba.org>
> wrote:
>> I had a closer look. I dumped the RC6 debug, but I also printed the raw
>> data in the interrupt handler:
>>
>>     printk("%x %d %d\n", irdata, rawir.pulse, rawir.duration);
>>
> ...
>> That should have been a pulse but it came out as a space. This makes me
>> wonder if there is an issue with the run length encoding, perhaps when
>> a pulse is the right size to just saturate it. It does seem like we
>> set the top bit even though we should not have.
>
> It's quite weird to see a "short" space followed by a max space followed
> by a "short" space (0xdc 0xff 0xde). Almost like there's one or more
> (pulse) bytes missing in between.
>
> I've tested long pulses/spaces before and they've worked as expected (e.g.
> "max", "max", "short" events....the leading 0x7f 0x7f 0x08 sequence in your
> log is a good example).
>
> Now, there is a minor bug in the RLE decoding in that the duration should
> have 1 added to it (meaning that 0x00 or 0x80 are valid values).
>
> Just to make sure something like that isn't happening, could you correct
> the line in wbcir_irq_rx() which currently reads:
>
> rawir.duration = US_TO_NS((irdata & 0x7F) * 10);
>
> so that it reads
>
> rawir.duration = US_TO_NS(((irdata & 0x7F) + 1) * 10);
>
> However, I'm guessing you inserted the extra debug printk inside
> wbcir_irq_rx() so any 0x00 or 0x80 bytes would have been printed?
>
> Another possibility is that the printk in the interrupt handler causes
> overhead...could you do a debug run without the printk in the interrupt
> handler?
>
> Also, could you provide me with the full versions of both logs? (i.e. all
> the way to idle....it might help spot a missed pulse/space)
>
> Thanks,
> David
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

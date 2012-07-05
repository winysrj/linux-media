Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:39971 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2GEONT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 10:13:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 05 Jul 2012 16:13:15 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Anton Blanchard <anton@samba.org>
Cc: <mchehab@infradead.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] [media] winbond-cir: Adjust sample frequency to improve
 reliability
In-Reply-To: <20120705203035.196e238e@kryten>
References: <20120702115800.1275f944@kryten> <20120702115937.623d3b41@kryten> <20120703202825.GC29839@hardeman.nu> <20120705203035.196e238e@kryten>
Message-ID: <9c21e63d50aba0e550a69a691dd12860@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Jul 2012 20:30:35 +1000, Anton Blanchard <anton@samba.org>
wrote:
> I had a closer look. I dumped the RC6 debug, but I also printed the raw
> data in the interrupt handler:
> 
>     printk("%x %d %d\n", irdata, rawir.pulse, rawir.duration);
> 
...
> That should have been a pulse but it came out as a space. This makes me
> wonder if there is an issue with the run length encoding, perhaps when
> a pulse is the right size to just saturate it. It does seem like we
> set the top bit even though we should not have.

It's quite weird to see a "short" space followed by a max space followed
by a "short" space (0xdc 0xff 0xde). Almost like there's one or more
(pulse) bytes missing in between.

I've tested long pulses/spaces before and they've worked as expected (e.g.
"max", "max", "short" events....the leading 0x7f 0x7f 0x08 sequence in your
log is a good example).

Now, there is a minor bug in the RLE decoding in that the duration should
have 1 added to it (meaning that 0x00 or 0x80 are valid values).

Just to make sure something like that isn't happening, could you correct
the line in wbcir_irq_rx() which currently reads:

rawir.duration = US_TO_NS((irdata & 0x7F) * 10);

so that it reads

rawir.duration = US_TO_NS(((irdata & 0x7F) + 1) * 10);

However, I'm guessing you inserted the extra debug printk inside
wbcir_irq_rx() so any 0x00 or 0x80 bytes would have been printed?

Another possibility is that the printk in the interrupt handler causes
overhead...could you do a debug run without the printk in the interrupt
handler?

Also, could you provide me with the full versions of both logs? (i.e. all
the way to idle....it might help spot a missed pulse/space)

Thanks,
David


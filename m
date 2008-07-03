Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bld-mail02.adl2.internode.on.net ([203.16.214.66]
	helo=mail.internode.on.net) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sph3r3@internode.on.net>) id 1KEXKD-000778-WC
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 00:30:51 +0200
Message-ID: <486D5300.5010901@internode.on.net>
Date: Fri, 04 Jul 2008 08:00:24 +0930
From: Adam <sph3r3@internode.on.net>
MIME-Version: 1.0
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
References: <4865b170.2e5.6a9b.26067@internode.on.net>	<486966E8.3050509@internode.on.net>
	<486A57A2.8060904@gimpelevich.san-francisco.ca.us>
In-Reply-To: <486A57A2.8060904@gimpelevich.san-francisco.ca.us>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO FusionHDTV DVB-T Pro
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Daniel Gimpelevich wrote:

[...snip...]

> OK, after applying the patch and replacing the card definition, please 
> try under Linux everything you did under Windows, so that you may report 
> back any observable differences between the two. While they might not 
> all be taken care of in the short term, a catalog of them now would be a 
> resource for future improvements.

Daniel,

I've updated to head, applied the patch and replaced the card 
definition.  The behaviour of failing to tune is still the same.  dmesg 
still says "cx88[0]: Error: Calling callback for tuner 4".

Trying to use vlc to view analog TV, composite or svideo resulted in 
messages similar to the following in dmesg:

> Jul  4 07:56:24 localhost kernel: cx88[0]: video y / packed - dma channel status dump
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: initial risc: 0x10901000
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: cdt base    : 0x00180440
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: cdt size    : 0x0000000c
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: iq base     : 0x00180400
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: iq size     : 0x00000010
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: risc pc     : 0x10901034
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: iq wr ptr   : 0x0000010d
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: iq rd ptr   : 0x00000101
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: cdt current : 0x00000448
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: pci target  : 0x00000000
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cmds: line / byte : 0x00000000
> Jul  4 07:56:24 localhost kernel: cx88[0]:   risc0: 0x80008000 [ sync resync count=0 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   risc1: 0x1c0003c0 [ write sol eol count=960 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   risc2: 0x1088d000 [ arg #1 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   risc3: 0x1c0003c0 [ write sol eol count=960 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq 0: 0x80008000 [ sync resync count=0 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq 1: 0x1c0003c0 [ write sol eol count=960 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq 2: 0x1088d000 [ arg #1 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq 3: 0x1c0003c0 [ write sol eol count=960 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq 4: 0x1088d780 [ arg #1 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq 5: 0x18000100 [ write sol count=256 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq 6: 0x1088df00 [ arg #1 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq 7: 0x140002c0 [ write eol count=704 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq 8: 0x1088c000 [ arg #1 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq 9: 0x1c0003c0 [ write sol eol count=960 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq a: 0x1088c680 [ arg #1 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq b: 0x18000200 [ write sol count=512 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq c: 0x1088ce00 [ arg #1 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq d: 0x7248ca28 [ jump irq2 22 19 resync 14 count=2600 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq e: 0x72377f63 [ arg #1 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]:   iq f: 0x03b40a5b [ INVALID irq2 irq1 23 21 20 18 count=2651 ]
> Jul  4 07:56:24 localhost kernel: cx88[0]: fifo: 0x00180c00 -> 0x183400
> Jul  4 07:56:24 localhost kernel: cx88[0]: ctrl: 0x00180400 -> 0x180460
> Jul  4 07:56:24 localhost kernel: cx88[0]:   ptr1_reg: 0x001812a8
> Jul  4 07:56:24 localhost kernel: cx88[0]:   ptr2_reg: 0x00180458
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cnt1_reg: 0x00000064
> Jul  4 07:56:24 localhost kernel: cx88[0]:   cnt2_reg: 0x00000000
> Jul  4 07:56:24 localhost kernel: cx88[0]/0: [ebfe9e40/0] timeout - dma=0x10901000
> Jul  4 07:56:24 localhost kernel: cx88[0]/0: [ebfe99c0/1] timeout - dma=0x1097b000

Adam

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

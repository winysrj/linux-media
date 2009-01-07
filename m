Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LKMKY-0002od-1r
	for linux-dvb@linuxtv.org; Wed, 07 Jan 2009 01:31:31 +0100
From: Andy Walls <awalls@radix.net>
To: gimli@dark-green.com
In-Reply-To: <35565.62.178.208.71.1231285755.squirrel@webmail.dark-green.com>
References: <20090104113738.GD3551@gmail.com>
	<1231097304.3125.64.camel@palomino.walls.org>
	<20090105130720.GB3621@gmail.com>
	<1231202800.3110.13.camel@palomino.walls.org>
	<20090106144917.736584e7@pedra.chehab.org>
	<20090106170002.GC3403@gmail.com>
	<20090106170926.52575365@pedra.chehab.org>
	<7C301ED0-CA57-406B-BA34-43A6EB21D96C@WhiteCitadel.com>
	<35565.62.178.208.71.1231285755.squirrel@webmail.dark-green.com>
Date: Tue, 06 Jan 2009 19:33:36 -0500
Message-Id: <1231288416.3117.29.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org,
	Paul <Paul@WhiteCitadel.com>
Subject: Re: [linux-dvb] s2-lipliandvb oops (cx88) -> cx88 maintainer ?
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

On Wed, 2009-01-07 at 00:49 +0100, gimli wrote:
> Hi,
> 
> i use the same Card WinTV-HD-DVB-S2. Without additional DVB cards.
> 
> Kernel : Linux vdr 2.6.28 #1 SMP Fri Dec 26 13:58:23 CET 2008 x86_64
> GNU/Linux
> 
> 2 GB Ram
> 
> Dvb Tree : s2-liplianin
> 
> Firmware version 1.20.79.0.
> 
> For me the card works as expected. No problems at all.
> 
> cu
> 
> Edgar (gimli) Hucek

Edgar (Gimli),

Thanks for the report.  That's actually exactly what I would expect. 

The race I think happens should only happen after the first device is
added to the cx8802_devlist and while the cx88-dvb module is probing
devices a second device is being added to the cx8802_devlist with a
pointer not properly set yet.
(Of course, I'm not sure why Mauro's recent change didn't work for
Gregoire.)


As for Gregoire's tuning problem, I haven't looked into that, nor do I
have the hardware to play with.

Regards.
Andy

> >
> > On 6 Jan 2009, at 19:09, Mauro Carvalho Chehab wrote:
> >
> >>
> >> Gregoire and others,
> >> I've just commit a patch that should fix this and another reported
> >> issue when selecting parts of cx88 code as module and other parts
> >> as monolithic.
> >>
> >> Could you please test if the patch also fixed the OOPS and doesn't
> >> generate any regression?
> >>
> >
> > I saw that Gregoire is still getting a kernel oops, I am also getting
> > an oops and wanted to provide the details in case it helps?
> >
> > Kernel is: Linux version 2.6.27.9-159.fc10.x86_64
> > (mockbuild@x86-6.fedora.phx.redhat.com) (gcc version 4.3.2 20081105
> > (Red Hat 4.
> > 3.2-7) (GCC) ) #1 SMP Tue Dec 16 14:47:52 EST 2008
> >
> > I have a WinTV-HD-DVB-S2 (not the HVR-4000 board, the one the Kernel
> > identifies as 4000 lite, card type 69 to cx88). I may be of limited
> > help as this is a brand new card I am trying to get working for the
> > first time, can confirm firmware is in place as per wiki
> > instructions, but I thought additional information may help those
> > trying to resolve the issue.
> >
> > Only other card in the system is a Nova-T500 DVB-T using dib0700 so
> > unrelated. I read some of the discussion on race hazards but not the
> > case with just one card for this system as there is only one card
> > using this driver.
> >
> > It was my understanding that this DVB-S2 card has been working for
> > some time (hence my choice in purchase) so there has been a
> > regression somewhere in my view.
> >
> > Oops is below:
> >
> > cx2388x alsa driver version 0.0.6 loaded
> > ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> > cx88_audio 0000:01:06.1: PCI INT A -> Link[APC1] -> GSI 16 (level,
> > low) -> IRQ 16
> > cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite)
> > DVB-S/S2 [card=69,autodetected], frontend(s): 1
> > cx88[0]: TV tuner type -1, Radio tuner type -1
> > cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> > cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> > tveeprom 5-0050: Hauppauge model 69100, rev B2C3, serial# 5329065
> > tveeprom 5-0050: MAC address is 00-0D-FE-51-50-A9
> > tveeprom 5-0050: tuner model is Conexant CX24118A (idx 123, type 4)
> > tveeprom 5-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
> > tveeprom 5-0050: audio processor is None (idx 0)
> > tveeprom 5-0050: decoder processor is CX882 (idx 25)
> > tveeprom 5-0050: has no radio, has IR receiver, has no IR transmitter
> > cx88[0]: hauppauge eeprom: model=69100
> > input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/
> > pci0000:00/0000:00:04.0/0000:01:06.1/input/input9
> > cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
> > cx8800 0000:01:06.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -
> >  > IRQ 16
> > cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 16, latency: 32, mmio:
> > 0xf3000000
> > cx88[0]/0: registered device video0 [v4l2]
> > cx88[0]/0: registered device vbi0
> > cx88[0]/2: cx2388x 8802 Driver Manager
> > cx88-mpeg driver manager 0000:01:06.2: PCI INT A -> Link[APC1] -> GSI
> > 16 (level, low) -> IRQ 16
> > cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 16, latency: 32, mmio:
> > 0xf5000000
> > cx88/2: cx2388x dvb driver version 0.0.6 loaded
> > cx88/2: registering cx8802 driver, type: dvb access: shared
> > cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite)
> > DVB-S/S2 [card=69]
> > BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000000
> > IP: [<ffffffffa09e3119>] vp3054_i2c_probe+0xe/0x115 [cx88_vp3054_i2c]
> > PGD 344b0067 PUD 35101067 PMD 0
> > Oops: 0000 [1] SMP
> > CPU 1
> > Modules linked in: cx88_dvb(+) cx88_vp3054_i2c videobuf_dvb tuner
> > cx8802 cx8800 cx88_alsa cx88xx ir_common mt2060 dvb_
> > usb_dib0700(+) dib7000p i2c_algo_bit v4l2_common dib7000m tveeprom
> > nvidia(P) videodev v4l1_compat dvb_usb dvb_core v4l
> > 2_compat_ioctl32 dib3000mc videobuf_dma_sg videobuf_core forcedeth
> > i2c_nforce2 firewire_ohci btcx_risc dibx000_common
> > dib0070 i2c_core firewire_core k8temp hwmon snd_hda_intel
> > snd_seq_dummy pcspkr snd_seq_oss snd_seq_midi_event snd_seq
> > snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer
> > snd_page_alloc snd_hwdep snd soundcore serio_raw crc_itu_t
> > lirc_imon joydev lirc_dev floppy pata_amd ata_generic pata_acpi
> > sata_nv [last unloaded: scsi_wait_scan]
> > Pid: 1661, comm: modprobe Tainted: P
> > 2.6.27.9-159.fc10.x86_64 #1
> > RIP: 0010:[<ffffffffa09e3119>]  [<ffffffffa09e3119>] vp3054_i2c_probe
> > +0xe/0x115 [cx88_vp3054_i2c]
> > RSP: 0018:ffff8800345d1de8  EFLAGS: 00010202
> > RAX: ffff88003549f000 RBX: 00000000ffffffed RCX: 0000000000000000
> > RDX: ffff880001023f50 RSI: ffffffffa09ebeb0 RDI: 0000000000000000
> > RBP: ffff8800345d1e08 R08: 0000000000000000 R09: 0000000000008a04
> > R10: ffffffff817686c0 R11: 0000006000000000 R12: ffff88003549f000
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > FS:  00007f29c0f846f0(0000) GS:ffff880037804880(0000) knlGS:
> > 0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000000000000 CR3: 00000000345f0000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process modprobe (pid: 1661, threadinfo ffff8800345d0000, task
> > ffff8800350b2e20)
> > Stack:  00000000ffffffed ffff88003549f000 ffff880033195800
> > 0000000000000000
> >   ffff8800345d1e88 ffffffffa09e7ae2 0000000000000000 0000000000000018
> >   ffff8800345d1e88 ffffffff813307c4 0000000000000030 ffff8800345d1e98
> > Call Trace:
> >   [<ffffffffa09e7ae2>] cx8802_dvb_probe+0x8c/0x1b86 [cx88_dvb]
> >   [<ffffffff813307c4>] ? printk+0x3c/0x40
> >   [<ffffffffa09cf09c>] cx8802_register_driver+0x125/0x1d6 [cx8802]
> >   [<ffffffffa09e9672>] ? dvb_init+0x0/0x2a [cx88_dvb]
> >   [<ffffffffa09e9699>] dvb_init+0x27/0x2a [cx88_dvb]
> >   [<ffffffff8100a047>] do_one_initcall+0x47/0x12e
> >   [<ffffffff81065c2d>] sys_init_module+0xa9/0x1b6
> >   [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
> >
> >
> > Code: 83 b8 70 06 00 00 2a 75 10 48 89 df e8 b1 93 78 ff 48 89 df e8
> > a6 73 6d e0 58 5b c9 c3 55 48 89 e5 41 56 41 55 4
> > 9 89 fd 41 54 53 <4c> 8b 37 31 db 41 83 be 70 06 00 00 2a 0f 85 e6 00
> > 00 00 be d0
> > RIP  [<ffffffffa09e3119>] vp3054_i2c_probe+0xe/0x115 [cx88_vp3054_i2c]
> >   RSP <ffff8800345d1de8>
> > CR2: 0000000000000000
> > ---[ end trace 8b736803e6538324 ]---
> >
> > I apologise if my error is not related, but to me it looks very
> > similar to the oops Gregoire is seeing and I am hoping it will help.
> >
> > Paul
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> >
> >
> 
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

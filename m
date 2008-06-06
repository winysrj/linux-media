Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+dd70d9dfd2da98cc4570+1748+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1K4jc1-0001cI-2C
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 23:36:41 +0200
Date: Fri, 6 Jun 2008 18:36:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080606183617.5c2b6398@gaivota>
In-Reply-To: <1212785950.16279.17.camel@pc10.localdom.local>
References: <48498964.10301@iinet.net.au>
	<1212785950.16279.17.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: hartmut.hackmann@t-online.de, Nico Sabbi <Nicola.Sabbi@poste.it>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem with latest v4l-dvb hg
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

On Fri, 06 Jun 2008 22:59:10 +0200
hermann pitton <hermann-pitton@arcor.de> wrote:

> Hi,
> 
> Am Samstag, den 07.06.2008, 03:00 +0800 schrieb timf:
> > Hi,
> > I just downloaded the latest hg from linuxtv.org/hg/v4l-dvb, installed 
> > it, rebooted.
> > This is the dmesg:
> > 
> > [   37.241810] Linux video capture interface: v2.00
> > [   37.425032] saa7130/34: v4l2 driver version 0.2.14 loaded
> > [   37.425559] saa7133[0]: found at 0000:04:08.0, rev: 209, irq: 16, 
> > latency: 32, mmio: 0xfdbff000
> > [   37.425566] saa7133[0]: subsystem: 17de:7250, board: KWorld DVB-T 210 
> > [card=114,autodetected]
> > [   37.425574] saa7133[0]: board init: gpio is 100
> > [   37.576692] saa7133[0]: i2c eeprom 00: de 17 50 72 ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576701] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576707] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576713] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576718] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576724] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576729] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576735] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576740] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576745] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576751] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576756] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576762] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576767] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576773] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.576778] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   37.644644] saa7133[0]: registered device video0 [v4l2]
> > [   37.644664] saa7133[0]: registered device vbi0
> > [   37.644684] saa7133[0]: registered device radio0
> > [   37.877664] Unable to handle kernel NULL pointer dereference at 
> > 00000000000000b0 RIP:
> > [   37.877670]  [<ffffffff88ad9909>] :dvb_core:dvb_frontend_detach+0x9/0x90
> > [   37.877687] PGD 6d09c067 PUD 6d3d2067 PMD 0
> > [   37.877690] Oops: 0000 [1] SMP
> > [   37.877693] CPU 0
> > [   37.877695] Modules linked in: tda1004x saa7134_dvb videobuf_dvb 
> > dvb_core snd_seq_oss snd_seq_midi tuner snd_rawmidi snd_seq_midi_event 
> > saa7134 compat_ioctl32 snd_seq snd_timer snd_seq_device videodev 
> > v4l1_compat v4l2_common videobuf_dma_sg videobuf_core ir_kbd_i2c 
> > ir_common snd tveeprom nvidia(P) button k8temp parport_pc parport 
> > soundcore i2c_nforce2 i2c_core evdev shpchp pci_hotplug pcspkr ext3 jbd 
> > mbcache sg sd_mod ehci_hcd ohci_hcd pata_amd forcedeth usbcore sata_nv 
> > pata_acpi ata_generic libata scsi_mod thermal processor fan fbcon 
> > tileblit font bitblit softcursor fuse
> > [   37.877729] Pid: 3220, comm: modprobe Tainted: P        
> > 2.6.24-18-generic #1
> > [   37.877732] RIP: 0010:[<ffffffff88ad9909>]  [<ffffffff88ad9909>] 
> > :dvb_core:dvb_frontend_detach+0x9/0x90
> > [   37.877741] RSP: 0018:ffff81006d3fbd68  EFLAGS: 00010292
> > [   37.877743] RAX: 00000000ffffffea RBX: 00000000ffffffff RCX: 
> > ffffffff88af99b0
> > [   37.877745] RDX: 00000000ffffffea RSI: ffffffff88af2135 RDI: 
> > 0000000000000000
> > [   37.877747] RBP: 0000000000000000 R08: 0000000000000000 R09: 
> > ffff81006fe35180
> > [   37.877749] R10: 0000000000000000 R11: 0000000000000001 R12: 
> > ffffffff88af4b80
> > [   37.877751] R13: ffff81006b9c8170 R14: ffffffff88af4b80 R15: 
> > ffffc200008bccc8
> > [   37.877754] FS:  00007f8528bcf6e0(0000) GS:ffffffff805b9000(0000) 
> > knlGS:0000000000000000
> > [   37.877756] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [   37.877758] CR2: 00000000000000b0 CR3: 000000006ce31000 CR4: 
> > 00000000000006e0
> > [   37.877760] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> > 0000000000000000
> > [   37.877762] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
> > 0000000000000400
> > [   37.877765] Process modprobe (pid: 3220, threadinfo ffff81006d3fa000, 
> > task ffff81006d82f7a0)
> > [   37.877767] Stack:  ffff81006b9c8000 00000000ffffffff 
> > ffff81006b9c8000 ffffffff88aef7a8
> > [   37.877771]  7fffffff000000d8 ffff81006b9c8000 0000000000000001 
> > ffff81006d82f7a0
> > [   37.877775]  ffffffff80233e20 0000000000100100 0000000000200200 
> > 0000000000000001
> > [   37.877778] Call Trace:
> > [   37.877786]  [<ffffffff88aef7a8>] :saa7134_dvb:dvb_init+0x178/0x15a0
> > [   37.877793]  [<ffffffff80233e20>] default_wake_function+0x0/0x10
> > [   37.877813]  [<ffffffff88a84f8e>] :saa7134:mpeg_ops_attach+0x4e/0x60
> > [   37.877823]  [<ffffffff88a857eb>] :saa7134:saa7134_ts_register+0x2b/0x80
> > [   37.877829]  [<ffffffff80263c5e>] sys_init_module+0x18e/0x1a90
> > [   37.877842]  [<ffffffff80247d30>] msleep+0x0/0x30
> > [   37.877849]  [<ffffffff8020c37e>] system_call+0x7e/0x83
> > [   37.877856]
> > [   37.877857]
> > [   37.877857] Code: 48 8b 87 b0 00 00 00 48 85 c0 74 0e ff d0 48 8b bd 
> > b0 00 00
> > [   37.877865] RIP  [<ffffffff88ad9909>] 
> > :dvb_core:dvb_frontend_detach+0x9/0x90
> > [   37.877873]  RSP <ffff81006d3fbd68>
> > [   37.877874] CR2: 00000000000000b0
> > [   37.877877] ---[ end trace bbead029e56cc160 ]---
> > 
> > Any suggestions?
> > Regards,
> > Timf
> > 
> 
> Tim, on a first shot it looks like you are on an older kernel.
> 
> There are issues with the backward compat of the build scripts.
> 
> With "make" (all) not all dependencies are resolved, especially the
> tuner modules are not built. Should compile first of all and you seem
> not to have the tda827x.
> 

Ok, but you shouldn't be suffering an OOPS. Instead, the driver should just not
register dvb.

Tim,

Before upgrading the kernel or trying to fix tda827x, could you please try this
small patch? This should fix the OOPS.

diff -r 843710c95bf7 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Jun 06 17:16:38 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Jun 06 18:35:32 2008 -0300
@@ -1345,7 +1345,8 @@
 	return ret;
 
 dettach_frontend:
-	dvb_frontend_detach(dev->dvb.frontend);
+	if (dev->dvb.frontend)
+		dvb_frontend_detach(dev->dvb.frontend);
 	dev->dvb.frontend = NULL;
 
 	return -1;



Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

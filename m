Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from walker.ipnetwork.de ([83.246.120.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <admin@ipnetwork.de>) id 1JuDwj-00036k-Nd
	for linux-dvb@linuxtv.org; Thu, 08 May 2008 23:46:38 +0200
Received: from [192.168.0.20] (BAG0e2e.bag.pppool.de [77.134.14.46])
	(authenticated bits=0)
	by walker.ipnetwork.de (8.13.8/8.13.8/Debian-3) with ESMTP id
	m48LkQed014133
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Thu, 8 May 2008 23:46:26 +0200
Message-ID: <482374BA.7040508@ipnetwork.de>
Date: Thu, 08 May 2008 23:46:34 +0200
From: Ingo Peukes <admin@ipnetwork.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <481ED628.4070901@ipnetwork.de>
In-Reply-To: <481ED628.4070901@ipnetwork.de>
Subject: Re: [linux-dvb] Cinergy T2 Kernel Oops on Linkstation Live V1
 (Marvel Orion ARM Architecture)
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

Hello everyone...

a few days ago I bought e Pinnacle PCTV200e to try if it works with my 
Linkstation. After getting some drivers for it from here: 
http://ubuntuforums.org/showthread.php?t=511676&page=8
As result I just got the same kernel oops, only triggered by the dvb_usb 
module instead of the cinergyT2 one.

Today I found a patch sent to this list on 01/20/2008 by Michele 
Scorcia. Although it is for kernel 2.6.20.4 and written to fix a problem 
on a mips platform the description of the problem came close to mine. So 
I applied it to the usb-urb.c from the above archive and built the modules.
After that the oops was gone and the PCTV runs without problems.
The cinergy driver still triggers the oops but i think that's normal 
cause it does not use the dvb-usb module and would need a separate patch.
The new cinergyT2 driver from Tomi Orava works just fine so I give it a 
chance instead of fixing the old one.
Another reason for this is that I tried both receivers on my desktop 
with the same kernel and v4l-dvb sources as I use on the Linkstation and 
couldn't make them run both at the same time. dmesg shows no errors but
w_scan hangs when both drivers are loaded. Either receiver alone works
great but together none does.
This problem does not exist with the new driver.



Here's the patch I use, only difference to the one from Michele Scorcia 
are the line numbers:

--- v4l-dvb/linux/drivers/media/dvb/dvb-usb/usb-urb.c  2008-05-05 
09:12:09.000000000 +0200
+++ v4l-dvb-hardy-2daeefda69fe/linux/drivers/media/dvb/dvb-usb/usb-urb.c 
      2008-05-08 16:59:22.000000000 +0200
@@ -156,7 +156,8 @@
                                 stream->props.u.bulk.buffersize,
                                 usb_urb_complete, stream);

-               stream->urb_list[i]->transfer_flags = 0;
+               stream->urb_list[i]->transfer_flags = 
URB_NO_TRANSFER_DMA_MAP;
+               stream->urb_list[i]->transfer_dma = stream->dma_addr[i];
                 stream->urbs_initialized++;
         }
         return 0;


Would be great if this oops cause for arm and mips and maybe others 
could be fixed in the v4l-dvb source.

Many thanks to Michele Scorcia for finding and fixing the problem :)

Greetings

Ingo Peukes

Ingo Peukes wrote:
> Hello all,
> 
> I have a Cinergy T2 Usb Box connected to my Linkstation NAS running
> Debian Testing armel
> and a 2.6.25.1 vanilla Kernel.
> the Cinergy module loads just fine but when I try to tune a channel I
> get a kernel Oops ( see below ).
> What I've tried so far:
> asking the google crystal ball... no realy good answer...
> 
> different kernel:
> vanilla 2.6.25.1
> orion git repositry
> 
> used this kernels with hg repositries of
> v4l-dvb and v4l-dvb-experimental
> 
> 
> This is the output of a w_scan run:
> 
> mythvdr:/usr/src/w_scan-20080105# ./w_scan
> w_scan version 20080105
> Info: using DVB adapter auto detection.
>    Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> frontend TerraTec/qanu USB2.0 Highspeed DVB-T Receiver supports
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> 177500:
> 184500:
> 191500:
> 198500:
> 205500:
> 212500:
> 219500:
> 226500:
> 474000: no signal(0x07)
> 482000:
> 490000:
> 498000:
> 506000: signal ok (I999B8C999D999M999T999G999Y999)
> 514000:
> 522000:
> 530000:
> 538000: signal ok (I999B8C999D999M999T999G999Y999)
> 546000:
> 554000:
> 562000:
> 570000:
> 578000:
> 586000: signal ok (I999B8C999D999M999T999G999Y999)
> 594000:
> 602000:
> 610000:
> 618000:
> 626000:
> 634000:
> 642000:
> 650000:
> 658000:
> 666000:
> 674000:
> 682000:
> 690000: signal ok (I999B8C999D999M999T999G999Y999)
> 698000:
> 706000:
> 714000:
> 722000:
> 730000:
> 738000:
> 746000: signal ok (I999B8C999D999M999T999G999Y999)
> 754000:
> 762000: signal ok (I999B8C999D999M999T999G999Y999)
> 770000:
> 778000:
> 786000:
> 794000:
> 802000:
> 810000:
> 818000:
> 826000:
> 834000:
> 842000:
> 850000:
> 858000:
> tune to: :506000:I999B8C999D999M999T999G999Y999:T:27500:
> 
> here w_scan stops responding, no CTRL-C or kill can remove the process
> 
> and this is what I get on the serial console:
> 
> usb 2-1: new high speed USB device using orion-ehci and address 2/ttusb-budg
> usb 2-1: configuration #1 chosen from 1 choice
> usb 2-1: New USB device found, idVendor=0ccd, idProduct=0038
> usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 2-1: Product: Cinergy T
> usb 2-1: Manufacturer: TerraTec GmbH
> DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
> input: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver remote control as 
> /class/input/input0
> usbcore: registered new interface driver cinergyT2
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = c5b3c000
> [00000000] *pgd=05bfa031, *pte=00000000, *ppte=00000000
> Internal error: Oops: 817 [#1] PREEMPT
> Modules linked in: evdev cinergyT2 dvb_core
> CPU: 0    Not tainted  (2.6.25.1 #3)
> PC is at dma_cache_maint+0x40/0x88
> LR is at usb_hcd_submit_urb+0x14c/0x894
> pc : [<c002f08c>]    lr : [<c02909c8>]    psr: 20000013
> sp : c5ae3c90  ip : c5ae3ca0  fp : c5ae3c9c
> r10: c758cae8  r9 : 00000000  r8 : 00000020
> r7 : c758dc00  r6 : c758cae0  r5 : 00000002  r4 : ffc50000
> r3 : 00000000  r2 : 00000002  r1 : ffc50200  r0 : ffc50000
> Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: a005317f  Table: 05b3c000  DAC: 00000015
> Process w_scan (pid: 7384, stack limit = 0xc5ae2268)
> Stack: (0xc5ae3c90 to 0xc5ae4000)
> 3c80:                                     c5ae3d54 c5ae3ca0 c02909c8 
> c002f05c
> 3ca0: c758dc00 c18f9c19 000000d2 c0411180 c5ae3d1c c5ae3cc0 c0072680 
> c003b5c8
> 3cc0: 00000044 00000001 c5ae2000 00000000 00000000 00000044 c0411184 
> 00000000
> 3ce0: c5ae2000 00000000 00000001 00000000 20000013 00000001 000000d2 
> c0411180
> 3d00: 00000000 00000000 00100002 c7c3b3a0 c5ae3d74 c5ae3d20 c00728c0 
> c00723a8
> 3d20: 00000000 00000000 c0411184 c69f4000 00000002 00000000 00000020 
> 00000000
> 3d40: c648ee70 c067e26c c5ae3d74 c5ae3d58 c0291494 c029088c c067e000 
> c067e000
> 3d60: 00000000 c067e1d8 c5ae3d8c c5ae3d78 bf014280 c0291264 ffffffff 
> c067e000
> 3d80: c5ae3dac c5ae3d90 bf0143f4 bf014244 c067e000 c067e1e8 00000000 
> c067e1d8
> 3da0: c5ae3dcc c5ae3db0 bf014590 bf0143e0 c0084814 c8900000 c067e000 
> 00000000
> 3dc0: c5ae3df4 c5ae3dd0 bf003f94 bf014548 000010dc 00000000 c8a15000 
> 00000000
> 3de0: c8a15004 c067e230 c5ae3e34 c5ae3df8 bf0016e8 bf003e90 c009be90 
> 00000000
> 3e00: c5ae3e2c c5ae3e10 c00941d0 c01d55a8 c8a15038 c8a15000 c5ae3e68 
> 00000000
> 3e20: c8a1506c c067e26c c5ae3e5c c5ae3e38 bf001adc bf001464 bedf6b9c 
> c5ae3e68
> 3e40: 0000403c 403c6f2b 00000001 00000000 c5ae3f14 c5ae3e60 bf0001b0 
> bf0018e0
> 3e60: bf012a48 c77d1240 00000000 00000000 00000000 00000000 00000000 
> 00000000
> 3e80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
> 00000000
> 3ea0: 00000005 c5ae3eb0 c008f6e4 c0074bbc c77d1240 c5ae3f00 ffffff9c 
> 00000004
> 3ec0: c5a6d000 00000000 c5ae3ef4 c5ae3ed8 c008f7e4 c008f590 00000000 
> c5a6d000
> 3ee0: c5ae2000 00000002 c5ae3f64 c77d1240 bedf6b9c 403c6f2b c77d1240 
> c0028c28
> 3f00: c5ae2000 00000000 c5ae3f2c c5ae3f18 bf000e40 bf0000dc bf0018d0 
> 00000000
> 3f20: c5ae3f4c c5ae3f30 c009e6f0 bf000e34 40000013 c648ee70 c77d1240 
> bedf6b9c
> 3f40: c5ae3f7c c5ae3f50 c009e9d4 c009e684 c77d1240 00000004 c5ae3f94 
> 00000004
> 3f60: bedf6b9c 403c6f2b c0028c28 c5ae2000 c5ae3fa4 c5ae3f80 c009ea34 
> c009e71c
> 3f80: 00000005 00000000 bedf74fc 0001a2f4 00000000 00000036 00000000 
> c5ae3fa8
> 3fa0: c0028a80 c009ea04 bedf74fc 0001a2f4 00000004 403c6f2b bedf6b9c 
> 00000005
> 3fc0: bedf74fc 0001a2f4 00000000 00000036 00000001 00000000 bedf7bd4 
> 0001a250
> 3fe0: 0001a180 bedf6b90 0000a7e4 400e210c a0000010 00000004 00000000 
> 00000000
> Backtrace:
> [<c002f04c>] (dma_cache_maint+0x0/0x88) from [<c02909c8>] 
> (usb_hcd_submit_urb+0x14c/0x894)
> [<c029087c>] (usb_hcd_submit_urb+0x0/0x894) from [<c0291494>] 
> (usb_submit_urb+0x240/0x25c)
> [<c0291254>] (usb_submit_urb+0x0/0x25c) from [<bf014280>] 
> (cinergyt2_submit_stream_urb+0x4c/0xa4 [cinergyT2])
> r7:c067e1d8 r6:00000000 r5:c067e000 r4:c067e000
> [<bf014234>] (cinergyt2_submit_stream_urb+0x0/0xa4 [cinergyT2]) from 
> [<bf0143f4>] (cinergyt2_start_stream_xfer+0x24/0xa0 [cinergyT2])
> r4:c067e000
> [<bf0143d0>] (cinergyt2_start_stream_xfer+0x0/0xa0 [cinergyT2]) from 
> [<bf014590>] (cinergyt2_start_feed+0x58/0x7c [cinergyT2])
> r7:c067e1d8 r6:00000000 r5:c067e1e8 r4:c067e000
> [<bf014538>] (cinergyt2_start_feed+0x0/0x7c [cinergyT2]) from 
> [<bf003f94>] (dmx_section_feed_start_filtering+0x114/0x19c [dvb_core])
> r6:00000000 r5:c067e000 r4:c8900000
> [<bf003e80>] (dmx_section_feed_start_filtering+0x0/0x19c [dvb_core]) 
> from [<bf0016e8>] (dvb_dmxdev_filter_start+0x294/0x47c [dvb_core])
> r8:c067e230 r7:c8a15004 r6:00000000 r5:c8a15000 r4:00000000
> [<bf001454>] (dvb_dmxdev_filter_start+0x0/0x47c [dvb_core]) from 
> [<bf001adc>] (dvb_demux_do_ioctl+0x20c/0x478 [dvb_core])
> [<bf0018d0>] (dvb_demux_do_ioctl+0x0/0x478 [dvb_core]) from [<bf0001b0>] 
> (dvb_usercopy+0xe4/0x170 [dvb_core])
> [<bf0000cc>] (dvb_usercopy+0x0/0x170 [dvb_core]) from [<bf000e40>] 
> (dvb_demux_ioctl+0x1c/0x28 [dvb_core])
> [<bf000e24>] (dvb_demux_ioctl+0x0/0x28 [dvb_core]) from [<c009e6f0>] 
> (vfs_ioctl+0x7c/0x98)
> [<c009e674>] (vfs_ioctl+0x0/0x98) from [<c009e9d4>] 
> (do_vfs_ioctl+0x2c8/0x2e8)
> r6:bedf6b9c r5:c77d1240 r4:c648ee70
> [<c009e70c>] (do_vfs_ioctl+0x0/0x2e8) from [<c009ea34>] 
> (sys_ioctl+0x40/0x64)
> r9:c5ae2000 r8:c0028c28 r6:403c6f2b r5:bedf6b9c r4:00000004
> [<c009e9f4>] (sys_ioctl+0x0/0x64) from [<c0028a80>] 
> (ret_fast_syscall+0x0/0x2c)
> r7:00000036 r6:00000000 r5:0001a2f4 r4:bedf74fc
> Code: 9a000001 e15c0003 3a000001 e3a03000 (e5833000)
> ---[ end trace ed5fadb8ba4b59e4 ]---
> 
> At this point the serial console becomes a one way connection, I get 
> output but it doesn't take input anymore.
> ssh logins to the box are still possible and also init 6 works and the 
> box does a clean reboot.
> Additional information: the Cinergy works fine when attached to my AMD64 
> Desktop running debian etch and the debian
> kernel 2.6.18-6-amd64
> it also works on my NSLU2 NAS running debian etch for ARM and kernel 
> 2.6.18-6-ixp4xx
> I tried to compile this debian kernel for the Linkstation but it did not 
> boot... will try to find out what's wrong
> but would rather use the vanilla kernel.
> 
> I hope I gathered all needed informations to help me fix this problem.
> 
> Greetings
> Ingo
> 
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

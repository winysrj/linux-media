Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pih-relay06.plus.net ([212.159.14.133])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@adslpipe.co.uk>) id 1KEMYv-0003P2-Qn
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 13:01:21 +0200
Received: from [84.92.25.126] (helo=[192.168.1.100])
	by pih-relay06.plus.net with esmtp (Exim) id 1KEMYN-0004ak-U4
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 12:00:44 +0100
Message-ID: <486CB15A.1080005@adslpipe.co.uk>
Date: Thu, 03 Jul 2008 12:00:42 +0100
From: Andy Burns <linux-dvb@adslpipe.co.uk>
MIME-Version: 1.0
To: Linux DVB List <linux-dvb@linuxtv.org>
Subject: [linux-dvb] How to track down a DMA panic?
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

I've recently been experimenting with running a myth backend within a 
CentOS 5.2 xen domU, I had to patch the saa7134 driver, and use irqpoll 
due to shared interrupts, but then the driver was basically working.

I have installed mythtv in the domU, it can scan for muxes, record 
several simultaneous streams from one tuner, and playback just like a 
physical machine.

... but ...

I have a lingering problem, occasionally I get a kernel panic due to DMA 
problems, I've been running the same tuners without xen for years 
without problems, so it seems likely that it's xen that's upsetting the 
drivers rather than an out-an-out driver bug, obviously I'd like to see 
if I can fix it.

Here is a typical crash dump

Fatal DMA error! Please use 'swiotlb=force'
----------- [cut here ] --------- [please bite here ] ---------
Kernel BUG at arch/x86_64/kernel/../../i386/kernel/pci-dma-xen.c:165
invalid opcode: 0000 [1] SMP
last sysfs file: /block/xvdc/removable
CPU 0
Modules linked in: saa7134_dvb(U) dvb_pll(U) mt352(U) video_buf_dvb(U) 
dvb_core(U) nxt200x(U) tda1004x(U) autofs4(U) sunrpc(U) xennet(U) 
ip6t_REJECT(U) xt_tcpudp(U) ip6table_filter(U) ip6_tables(U) x_tables(U) 
ipv6(U) xfrm_nalgo(U) crypto_api(U) xfs(U) dm_multipath(U) parport_pc(U) 
lp(U) parport(U) saa7134(U) video_buf(U) compat_ioctl32(U) ir_kbd_i2c(U) 
i2c_core(U) ir_common(U) videodev(U) v4l1_compat(U) v4l2_common(U) 
pcspkr(U) dm_snapshot(U) dm_zero(U) dm_mirror(U) dm_mod(U) xenblk(U) 
ext3(U) jbd(U) uhci_hcd(U) ohci_hcd(U) ehci_hcd(U)
Pid: 5517, comm: saa7130[0] dvb Tainted: G      2.6.18-prep #6
RIP: e030:[<ffffffff802720a2>]  [<ffffffff802720a2>] dma_map_sg+0x13f/0x1ae
RSP: e02b:ffff88003ceb7e00  EFLAGS: 00010282
RAX: 000000000000002f RBX: ffff8800227c1bd0 RCX: ffffffff804da728
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000002 R08: ffffffff804da728 R09: 0000000000002373
R10: 000000000000002c R11: ffff88003ceb8000 R12: 0000000000000006
R13: ffff88003fded070 R14: ffff88003bfdcde8 R15: 0000000000000003
FS:  00002b67c1d1e750(0000) GS:ffffffff805ac000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000
Process saa7130[0] dvb (pid: 5517, threadinfo ffff88003ceb6000, task 
ffff88003041e820)
Stack:  ffff8800349ee9b0  ffff8800349ee9b0  ffff88003bfdcde8 
ffff88003fded000
  0000000000000080  ffffffff88133937  ffff8800349ee980  0000000000005e00
  ffff88003bfdc000  ffffffff88144d34
Call Trace:
  [<ffffffff88133937>] :video_buf:videobuf_dma_map+0x115/0x159
  [<ffffffff88144d34>] :saa7134:buffer_prepare+0xbb/0x19b
  [<ffffffff80298a84>] keventd_create_kthread+0x0/0xc4
  [<ffffffff88132d43>] :video_buf:videobuf_read_start+0xa8/0x139
  [<ffffffff8836234b>] :video_buf_dvb:videobuf_dvb_thread+0x2a/0x127

As per the first line of the error message, I did try with swiotlb=force 
   as a kernel option, but that forced the kernel to immediately crash 
on booting.

The machine will run for a few hours without crashing and my gut feeling 
is that the crash actually happens when the tuner is being re-tuned to a 
different mux, rather then when streaming data once a mux has been tuned.

I know what DMA does, but I don't know much detail about how it does it, 
   and even less about how linux dvb uses it, any suggestions for how I 
should proceed to try and track this down?

Any test suites as part of linuxtv?


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

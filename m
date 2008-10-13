Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marko.ristola@kolumbus.fi>) id 1KpTi5-0007yf-1J
	for linux-dvb@linuxtv.org; Mon, 13 Oct 2008 22:08:11 +0200
Message-ID: <48F3AAA0.6040301@kolumbus.fi>
Date: Mon, 13 Oct 2008 23:08:00 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Anssi Kolehmainen <anssi@aketzu.net>
References: <20081011163649.GU15309@aketzu.net>
In-Reply-To: <20081011163649.GU15309@aketzu.net>
Cc: linux-dvb@linuxtv.org, abraham.manu@gmail.com
Subject: Re: [linux-dvb] Mantis and CAM problems
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


Hi

My patch has helped for Terratec Cinergy C HD card stability problems.
Maybe somebody of you want to try or look at it? With Terratec card 
there were small
dropouts while saving data to disk. My patch fixed them (Jouni said so).
He didn't have any reboots or something, just small dropouts.

I suspect that the problem that my patch fixes is that the DMA transfer
from DVB to memory broke video/audio stream somehow.

Maybe if you have small dropouts (corrupted packets) in original data 
while feeding CAM,
you will have large dropouts after decrypting has been done?

Here is the patch:
http://linuxtv.org/pipermail/linux-dvb/2008-July/027226.html

I don't have CAM module to test Anssi your case.

Regards,
Marko Ristola

Anssi Kolehmainen kirjoitti:
> I have Terratec Cinergy C (dvb-c, 1822:4e35) card and when I try to use CAM I
> just get TS continuity errors with vdr and cannot watch any channel. I'm using
> latest driver from jusst.de/hg/mantis and it feels rather unstable at times
> (previous versions crashed machine almost instantly with CAM...)
>
> I can access CAM menu in vdr but after a while it says CAM not responding. If I
> do rmmod & modprobe mantis after that I get "dvb_ca adapter 0: Invalid PC card
> inserted :(". Removing & reattaching CAM doesn't do any better, after modprobe
> mantis everything freezes and caps+scroll lock blink on the keyboard.
>
> Linux 2.6.24i-1-686, Debian package
> Oct 11 19:08:18 ampere kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 20
> Oct 11 19:08:18 ampere kernel: irq: 20, latency: 32
> Oct 11 19:08:18 ampere kernel:  memory: 0xdf000000, mmio: 0xf8a76000
> Oct 11 19:08:18 ampere kernel: found a VP-2040 PCI DVB-C device on (02:09.0),
> Oct 11 19:08:18 ampere kernel:     Mantis Rev 1 [153b:1178], irq: 20, latency: 32
> Oct 11 19:08:18 ampere kernel:     memory: 0xdf000000, mmio: 0xf8a76000
> Oct 11 19:08:18 ampere kernel:     MAC Address=[00:08:ca:1c:87:ea]
> Oct 11 19:08:18 ampere kernel: mantis_alloc_buffers (0): DMA=0x36c70000 cpu=0xf6c70000 size=65536
> Oct 11 19:08:18 ampere kernel: mantis_alloc_buffers (0): RISC=0x1582f000 cpu=0xd582f000 size=1000
> Oct 11 19:08:18 ampere kernel: DVB: registering new adapter (Mantis dvb adapter)
> Oct 11 19:08:18 ampere kernel: mantis_frontend_init (0): Probing for CU1216 (DVB-C)
> Oct 11 19:08:18 ampere kernel: mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
> Oct 11 19:08:18 ampere kernel: mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
> Oct 11 19:08:18 ampere kernel: DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
> Oct 11 19:08:18 ampere kernel: mantis_ca_init (0): Registering EN50221 device
> Oct 11 19:08:18 ampere kernel: mantis_ca_init (0): Registered EN50221 device
> Oct 11 19:08:18 ampere kernel: mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
> Oct 11 19:08:22 ampere kernel: dvb_ca adapter 0: DVB CAM detected and initialised successfully
> Oct 11 19:08:27 ampere kernel: mantis start feed & dma
> Oct 11 19:08:35 ampere kernel: mantis stop feed and dma
>
> start vdr
> Oct 11 19:10:26 ampere vdr: [23112] CI adapter on device 0 thread started (pid=23108, tid=23112)
> Oct 11 19:10:26 ampere vdr: [23112] CAM 1: module present
> Oct 11 19:10:27 ampere vdr: [23108] device 1 provides: DVBC
> Oct 11 19:10:30 ampere kernel: dvb_ca adapter 0: DVB CAM detected and initialised successfully
> Oct 11 19:10:30 ampere vdr: [23112] CAM 1: module ready
> Oct 11 19:10:32 ampere vdr: [23112] CAM 1: Conax 4.00e, 01, 0B00, 04B1
> Oct 11 19:10:36 ampere vdr: [23112] CAM 1: doesn't reply to QUERY - only a single channel can be decrypted
> Oct 11 19:10:36 ampere vdr: [23108] switching to channel 1
> Oct 11 19:10:36 ampere kernel: mantis start feed & dma
> Oct 11 19:10:36 ampere vdr: [23121] transfer thread started (pid=23108, tid=23121)
> Oct 11 19:10:36 ampere vdr: [23122] receiver on device 1 thread started (pid=23108, tid=23122)
> Oct 11 19:10:36 ampere vdr: [23123] TS buffer on device 1 thread started (pid=23108, tid=23123)
> Oct 11 19:10:36 ampere kernel: dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (5)
> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (15)
> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (1)
> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (6)
> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (9)
> Oct 11 19:10:36 ampere vdr: [23121] TS continuity error (12)
>
> Something like ~150 TS continuity errors per sec. Video is pretty much garbage.
> However if I remove CAM then everything works perfectly (except I can't watch
> encrypted channels).
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

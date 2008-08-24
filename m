Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KXJ1X-0001bY-16
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 19:05:08 +0200
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KXJ1S-00018j-Pw
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 17:05:02 +0000
Received: from pool-71-164-182-254.dllstx.fios.verizon.net ([71.164.182.254])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 24 Aug 2008 17:05:02 +0000
Received: from kevinww by pool-71-164-182-254.dllstx.fios.verizon.net with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 24 Aug 2008 17:05:02 +0000
To: linux-dvb@linuxtv.org
From: Kevin Wambsganz <kevinww@verizon.net>
Date: Sun, 24 Aug 2008 16:21:13 +0000 (UTC)
Message-ID: <loom.20080824T155738-572@post.gmane.org>
Mime-Version: 1.0
Subject: [linux-dvb] SuSE 11.00 and DVB PCHDTV-5500 driver problem
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

Hi,

I built the DVB repository using "hg clone http://hg.jannau.net/hdpvr/" 
because it contains the driver for the Hauppauge HD-PVR. I also used the 
stable version of DVB w/o HD-PVR and I have the same problem.

I'm using SuSE 11.0 from opensuse.com, kernel is "Linux wambs-server 2.6.25.11-
0.1-pae #1 SMP 2008-07-13 20:48:28 +0200 i686 i686 i386 GNU/Linux"

I have two PCHDTV-HD500 cards installed and one HD-PVR connected to USB. 
The driver builds and installs fine, but when I load the driver or restart the 
server I get the following driver error.

Here's a partial dump of messages, please help!!

Can someone let me know what's going on with this? Is this specific to the 
SuSe 11.0 built. Should I rebuild the kernel and remove the installed DVB from 
it? Any other ideas?

Aug 23 19:14:33 wambs-server kernel: ACPI: PCI interrupt for device 
0000:01:01.2 disabled
Aug 23 19:14:33 wambs-server kernel: ACPI: PCI interrupt for device 
0000:01:00.2 disabled
Aug 23 19:14:38 wambs-server kernel: ACPI: PCI interrupt for device 
0000:01:01.0 disabled
Aug 23 19:14:38 wambs-server kernel: ACPI: PCI interrupt for device 
0000:01:00.0 disabled
Aug 23 19:15:00 wambs-server kernel: usbcore: registered new interface driver 
hdpvr
Aug 23 19:16:06 wambs-server kernel: cx88/0: cx2388x v4l2 driver version 0.0.6 
loaded
Aug 23 19:16:06 wambs-server kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> 
GSI 21 (level, low) -> IRQ 21
Aug 23 19:16:06 wambs-server kernel: cx88[0]: subsystem: 7063:5500, board: 
pcHDTV HD5500 HDTV [card=47,insmod option]
Aug 23 19:16:06 wambs-server kernel: cx88[0]: TV tuner type 64, Radio tuner 
type -1
Aug 23 19:16:06 wambs-server kernel: cx88[0]: Test OK
Aug 23 19:16:06 wambs-server modprobe: WARNING: module 'tda8290' is unsupported
Aug 23 19:16:06 wambs-server kernel: TUNER: Unable to find symbol tda829x_probe
()
Aug 23 19:16:06 wambs-server kernel: tuner' 1-0043: chip found @ 0x86 (cx88[0])
Aug 23 19:16:06 wambs-server modprobe: WARNING: module 'tda9887' is unsupported
Aug 23 19:16:06 wambs-server kernel: DVB: Unable to find symbol tda9887_attach
()
Aug 23 19:16:06 wambs-server kernel: tuner' 1-0061: chip found @ 0xc2 (cx88[0])
Aug 23 19:16:06 wambs-server modprobe: WARNING: module 'tuner_simple' is 
unsupported
Aug 23 19:16:06 wambs-server kernel: DVB: Unable to find symbol 
simple_tuner_attach()
Aug 23 19:16:06 wambs-server kernel: cx88[0]/0: found at 0000:01:00.0, rev: 5, 
irq: 21, latency: 64, mmio: 0xeb000000
Aug 23 19:16:06 wambs-server kernel: cx88[0]/0: registered device video0 [v4l2]
Aug 23 19:16:06 wambs-server kernel: cx88[0]/0: registered device vbi0
Aug 23 19:16:06 wambs-server kernel: tuner' 1-0061: Tuner has no way to set tv 
freq
Aug 23 19:16:06 wambs-server kernel: ACPI: PCI Interrupt 0000:01:01.0[A] -> 
GSI 22 (level, low) -> IRQ 22
Aug 23 19:16:06 wambs-server kernel: cx88[1]: subsystem: 7063:5500, board: 
pcHDTV HD5500 HDTV [card=47,insmod option]
Aug 23 19:16:06 wambs-server kernel: cx88[1]: TV tuner type 64, Radio tuner 
type -1
Aug 23 19:16:07 wambs-server kernel: cx88[1]: Test OK
Aug 23 19:16:07 wambs-server modprobe: WARNING: module 'tda8290' is unsupported
Aug 23 19:16:07 wambs-server kernel: TUNER: Unable to find symbol tda829x_probe
()
Aug 23 19:16:07 wambs-server kernel: tuner' 2-0043: chip found @ 0x86 (cx88[1])
Aug 23 19:16:07 wambs-server modprobe: WARNING: module 'tda9887' is unsupported
Aug 23 19:16:07 wambs-server kernel: DVB: Unable to find symbol tda9887_attach
()
Aug 23 19:16:07 wambs-server kernel: tuner' 2-0061: chip found @ 0xc2 (cx88[1])
Aug 23 19:16:07 wambs-server modprobe: WARNING: module 'tuner_simple' is 
unsupported
Aug 23 19:16:07 wambs-server kernel: DVB: Unable to find symbol 
simple_tuner_attach()
Aug 23 19:16:07 wambs-server kernel: cx88[1]/0: found at 0000:01:01.0, rev: 5, 
irq: 22, latency: 64, mmio: 0xe7000000
Aug 23 19:16:07 wambs-server kernel: cx88[1]/0: registered device video1 [v4l2]
Aug 23 19:16:07 wambs-server kernel: cx88[1]/0: registered device vbi1
Aug 23 19:16:07 wambs-server kernel: tuner' 2-0061: Tuner has no way to set tv 
freq
Aug 23 19:16:27 wambs-server kernel: cx88/2: cx2388x MPEG-TS Driver Manager 
version 0.0.6 loaded
Aug 23 19:16:27 wambs-server kernel: cx88[0]/2: cx2388x 8802 Driver Manager
Aug 23 19:16:27 wambs-server kernel: ACPI: PCI Interrupt 0000:01:00.2[A] -> 
GSI 21 (level, low) -> IRQ 21
Aug 23 19:16:27 wambs-server kernel: cx88[0]/2: found at 0000:01:00.2, rev: 5, 
irq: 21, latency: 64, mmio: 0xed000000
Aug 23 19:16:27 wambs-server kernel: cx88[1]/2: cx2388x 8802 Driver Manager
Aug 23 19:16:27 wambs-server kernel: ACPI: PCI Interrupt 0000:01:01.2[A] -> 
GSI 22 (level, low) -> IRQ 22
Aug 23 19:16:27 wambs-server kernel: cx88[1]/2: found at 0000:01:01.2, rev: 5, 
irq: 22, latency: 64, mmio: 0xe9000000
Aug 23 19:16:27 wambs-server kernel: cx88/2: cx2388x dvb driver version 0.0.6 
loaded
Aug 23 19:16:27 wambs-server kernel: cx88/2: registering cx8802 driver, type: 
dvb access: shared
Aug 23 19:16:27 wambs-server kernel: cx88[0]/2: subsystem: 7063:5500, board: 
pcHDTV HD5500 HDTV [card=47]
Aug 23 19:16:27 wambs-server kernel: cx88[0]/2: cx2388x based DVB/ATSC card
Aug 23 19:16:27 wambs-server modprobe: WARNING: module 'tuner_simple' is 
unsupported
Aug 23 19:16:27 wambs-server kernel: DVB: Unable to find symbol 
simple_tuner_attach()
Aug 23 19:16:27 wambs-server kernel: cx88[0]/2: dvb_register failed (err = -22)
Aug 23 19:16:27 wambs-server kernel: cx88[0]/2: cx8802 probe failed, err = -22
Aug 23 19:16:27 wambs-server kernel: cx88[1]/2: subsystem: 7063:5500, board: 
pcHDTV HD5500 HDTV [card=47]
Aug 23 19:16:27 wambs-server kernel: cx88[1]/2: cx2388x based DVB/ATSC card
Aug 23 19:16:27 wambs-server modprobe: WARNING: module 'tuner_simple' is 
unsupported
Aug 23 19:16:27 wambs-server kernel: DVB: Unable to find symbol 
simple_tuner_attach()
Aug 23 19:16:27 wambs-server kernel: cx88[1]/2: dvb_register failed (err = -22)
                                                                               
               
 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

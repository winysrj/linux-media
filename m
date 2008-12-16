Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <drappa@iinet.net.au>) id 1LCUU5-0003DW-HO
	for linux-dvb@linuxtv.org; Tue, 16 Dec 2008 08:36:52 +0100
Message-ID: <3373E53765AB44F8BF670FDF42C3CD3A@mce>
From: "drappa" <drappa@iinet.net.au>
To: <linux-dvb@linuxtv.org>
Date: Tue, 16 Dec 2008 17:36:55 +1000
MIME-Version: 1.0
Subject: [linux-dvb] DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2) - Remote
	Control Key Mapping
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

Hello

I installed a DVICO Dual digital 4 revision2 DVB-T card in a Mythbuntu 8.10 
system

The card wasn't originally detected so I built the driver from the current 
v4l-dvb tree and it works great.
Only problem is the included DVICO remote control has very limited 
functionality. Apart from the numeric keypad only three keys work.

DMESG is below.

Any pointers to getting the proper key mapping, please?

Ta
D

[   13.921567] dvb-usb: found a ' in warm state.
[   13.921802] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[   13.952919] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual 
Digital 4 (rev 2))
[   13.994729] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   14.117557] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[   14.120807] Linux agpgart interface v0.103
[   14.275066] DiB0070: successfully identified
[   14.275641] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:08.0/0000:01:08.2/usb5/5-1/input/input5
[   14.304726] dvb-usb: schedule remote query interval to 100 msecs.
[   14.304733] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2) 
successfully initialized and connected.
[   14.304750] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4 (rev 
2)' in warm state.
[   14.304877] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[   14.335977] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual 
Digital 4 (rev 2))
[   14.355636] nvidia: module license 'NVIDIA' taints kernel.
[   14.497865] DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
[   14.611161] ACPI: PCI Interrupt Link [SGRU] enabled at IRQ 20
[   14.611169] nvidia 0000:02:00.0: PCI INT A -> Link[SGRU] -> GSI 20 
(level, low) -> IRQ 20
[   14.611175] nvidia 0000:02:00.0: setting latency timer to 64
[   14.611408] NVRM: loading NVIDIA UNIX x86 Kernel Module  177.80  Wed Oct 
1 14:38:10 PDT 2008
[   14.655134] DiB0070: successfully identified
[   14.655812] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:08.0/0000:01:08.2/usb5/5-2/input/input6
[   14.680687] dvb-usb: schedule remote query interval to 100 msecs.
[   14.680693] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2) 
successfully initialized and connected.
[   14.680723] usbcore: registered new interface driver dvb_usb_cxusb 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

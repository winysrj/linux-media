Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 78.218.95.91.static.ter-s.siw.siwnet.net ([91.95.218.78]
	helo=gw) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <magnus@alefors.se>) id 1JfbLf-00035a-3Y
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 14:43:55 +0100
Received: from [192.168.0.10] (aria.alefors.se [192.168.0.10])
	by gw (Postfix) with ESMTP id 85D6C15A8B
	for <linux-dvb@linuxtv.org>; Sat, 29 Mar 2008 14:43:49 +0100 (CET)
Message-ID: <47EE4794.5050703@alefors.se>
Date: Sat, 29 Mar 2008 14:43:48 +0100
From: =?UTF-8?B?TWFnbnVzIEjDtnJsaW4=?= <magnus@alefors.se>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Twinhan Visionplus DVB-S works but not with multiproto
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

Hi. Sorry for posting this again. I just verified that it works 
perfectly with standard linuxtv hg drivers, but not in multiproto. The 
worst thing is that rmmoding dvb_bt8xx sometimes hang the whole machine.

I just bought an old Twinhan VisionPlus DVB-S card off ebay and I
can't get it to work. I have five other dvb cards running on this
machine, both dvb-s and dvb-t and latest multiproto on 2.6.24.3. A lot
of modules are loaded (dst,dst-ca,dvb-bt8xx and some) with this card and
the /dev/dvb/adapterX entry appears but when I try scan or szap on the
device, nothing happens. It just stops at:

scan -a 3 /usr/local/share/dvb/dvb-s/Thor-1.0W
scanning /usr/local/share/dvb/dvb-s/Thor-1.0W
using '/dev/dvb/adapter6/frontend0' and '/dev/dvb/adapter6/demux0'

VDR doesn't like it either. Is this supposed to work at all? How do I
debug it?
Best regards,
/Magnus H


Mar 27 13:15:05 tv kernel: [   31.468016] bttv: driver version 0.9.17 loaded
Mar 27 13:15:05 tv kernel: [   31.468020] bttv: using 8 buffers with
2080k (520 pages) each for capture
Mar 27 13:15:05 tv kernel: [   31.468080] bttv: Bt8xx card found (0).
Mar 27 13:15:05 tv kernel: [   31.468104] ACPI: PCI Interrupt
0000:01:05.0[A] -> GSI 22 (level, low) -> IRQ 21
Mar 27 13:15:05 tv kernel: [   31.468115] bttv0: Bt878 (rev 17) at
0000:01:05.0, irq: 21, latency: 64, mmio: 0xefefe000
Mar 27 13:15:05 tv kernel: [   31.468160] bttv0: detected: Twinhan
VisionPlus DVB [card=113], PCI subsystem ID is 1822:0001
Mar 27 13:15:05 tv kernel: [   31.468163] bttv0: using: Twinhan DST +
clones [card=113,autodetected]
Mar 27 13:15:05 tv kernel: [   31.468210] bttv0: tuner absent
Mar 27 13:15:05 tv kernel: [   31.468223] bttv0: add subdevice "dvb0"
Mar 27 13:15:05 tv kernel: [   31.502679] cx88/0: cx2388x v4l2 driver
version 0.0.6 loaded
Mar 27 13:15:05 tv kernel: [   31.502742] ACPI: PCI Interrupt
0000:01:04.0[A] -> GSI 21 (level, low) -> IRQ 23
Mar 27 13:15:05 tv kernel: [   31.502787] cx88[0]: subsystem: 17de:08a6,
board: KWorld/VStream XPert DVB-T [card=14,autodetected]
Mar 27 13:15:05 tv kernel: [   31.502789] cx88[0]: TV tuner type 4,
Radio tuner type -1
Mar 27 13:15:05 tv kernel: [   31.559783] cx88/2: cx2388x MPEG-TS Driver
Manager version 0.0.6 loaded
Mar 27 13:15:05 tv kernel: [   31.679581] input: cx88 IR (KWorld/VStream
XPert D as /devices/pci0000:00/0000:00:1e.0/0000:01:04.0/input/input4
Mar 27 13:15:05 tv kernel: [   31.685619] saa7146: register extension
'budget_ci dvb'.
Mar 27 13:15:05 tv kernel: [   31.688047] bt878: AUDIO driver version
0.0.0 loaded
Mar 27 13:15:05 tv kernel: [   31.706880] r8169: eth0: link up
Mar 27 13:15:05 tv kernel: [   31.706887] r8169: eth0: link up
Mar 27 13:15:05 tv kernel: [   31.727464] cx88[0]/0: found at
0000:01:04.0, rev: 5, irq: 23, latency: 64, mmio: 0xec000000
Mar 27 13:15:05 tv kernel: [   31.727507] cx88[0]/0: registered device
video0 [v4l2]
Mar 27 13:15:05 tv kernel: [   31.727523] cx88[0]/0: registered device vbi0
Mar 27 13:15:05 tv kernel: [   31.727672] cx88[0]/2: cx2388x 8802 Driver
Manager
Mar 27 13:15:05 tv kernel: [   31.727692] ACPI: PCI Interrupt
0000:01:04.2[A] -> GSI 21 (level, low) -> IRQ 23
Mar 27 13:15:05 tv kernel: [   31.727702] cx88[0]/2: found at
0000:01:04.2, rev: 5, irq: 23, latency: 64, mmio: 0xed000000
Mar 27 13:15:05 tv kernel: [   31.728050] ACPI: PCI Interrupt
0000:01:01.0[A] -> GSI 17 (level, low) -> IRQ 18
Mar 27 13:15:05 tv kernel: [   31.728087] saa7146: found saa7146 @ mem
f89e6400 (revision 1, irq 18) (0x13c2,0x1019).
Mar 27 13:15:05 tv kernel: [   31.728094] saa7146 (0): dma buffer size
192512
Mar 27 13:15:05 tv kernel: [   31.728097] DVB: registering new adapter
(TT-Budget S2-3200 PCI)
Mar 27 13:15:05 tv kernel: [   31.764258] adapter has MAC addr =
00:d0:5c:68:35:8a
Mar 27 13:15:05 tv kernel: [   31.764558] input: Budget-CI dvb ir
receiver saa7146 (0) as
/devices/pci0000:00/0000:00:1e.0/0000:01:01.0/input/input5
Mar 27 13:15:05 tv kernel: [   31.785042] cx88/2: cx2388x dvb driver
version 0.0.6 loaded
Mar 27 13:15:05 tv kernel: [   31.785046] cx88/2: registering cx8802
driver, type: dvb access: shared
Mar 27 13:15:05 tv kernel: [   31.785049] cx88[0]/2: subsystem:
17de:08a6, board: KWorld/VStream XPert DVB-T [card=14]
Mar 27 13:15:05 tv kernel: [   31.785052] cx88[0]/2: cx2388x based
DVB/ATSC card
Mar 27 13:15:05 tv kernel: [   32.004084] dib0700: loaded with support
for 6 different device-types
Mar 27 13:15:05 tv kernel: [   32.004627] dvb-usb: found a 'Hauppauge
Nova-T 500 Dual DVB-T' in cold state, will try to load a firmware
Mar 27 13:15:05 tv kernel: [   32.013924] dvb-usb: found a 'Opera1 DVB-S
USB2.0' in cold state, will try to load a firmware
Mar 27 13:15:05 tv kernel: [   32.143784] DVB: registering new adapter
(cx88[0])
Mar 27 13:15:05 tv kernel: [   32.143789] DVB: registering frontend 1
(Zarlink MT352 DVB-T)...
Mar 27 13:15:05 tv kernel: [   32.155130] stb0899_attach: Attaching STB0899
Mar 27 13:15:05 tv kernel: [   32.169076] stb6100_attach: Attaching STB6100
Mar 27 13:15:05 tv kernel: [   32.251589] DVB: registering frontend 0
(STB0899 Multistandard)...
Mar 27 13:15:05 tv kernel: [   32.251642] ACPI: PCI Interrupt
0000:01:03.0[A] -> GSI 20 (level, low) -> IRQ 17
Mar 27 13:15:05 tv kernel: [   32.251671] saa7146: found saa7146 @ mem
fcb7ac00 (revision 1, irq 17) (0x13c2,0x1011).
Mar 27 13:15:05 tv kernel: [   32.251678] saa7146 (1): dma buffer size
192512
Mar 27 13:15:05 tv kernel: [   32.251679] DVB: registering new adapter
(TT-Budget/WinTV-NOVA-T^I PCI)
Mar 27 13:15:05 tv kernel: [   32.291198] adapter has MAC addr =
00:d0:5c:23:18:6c
Mar 27 13:15:05 tv kernel: [   32.291445] input: Budget-CI dvb ir
receiver saa7146 (1) as
/devices/pci0000:00/0000:00:1e.0/0000:01:03.0/input/input6
Mar 27 13:15:05 tv kernel: [   32.371240] dvb-usb: downloading firmware
from file 'dvb-usb-opera-01.fw'
Mar 27 13:15:05 tv kernel: [   32.379217] DVB: registering frontend 2
(Philips TDA10045H DVB-T)...
Mar 27 13:15:05 tv kernel: [   32.379406] bt878: Bt878 AUDIO function
found (0).
Mar 27 13:15:05 tv kernel: [   32.379428] ACPI: PCI Interrupt
0000:01:05.1[A] -> GSI 22 (level, low) -> IRQ 21
Mar 27 13:15:05 tv kernel: [   32.379432] bt878_probe: card
id=[0x11822],[ Twinhan VisionPlus DVB ] has DVB functions.
Mar 27 13:15:05 tv kernel: [   32.379440] bt878(0): Bt878 (rev 17) at
01:05.1, irq: 21, latency: 64, memory: 0xefeff000
Mar 27 13:15:05 tv kernel: [   32.394416] dvb-usb: downloading firmware
from file 'dvb-usb-dib0700-1.10.fw'
Mar 27 13:15:05 tv kernel: [   32.439609] usb 1-1: USB disconnect, address 2
Mar 27 13:15:05 tv kernel: [   32.446115] dvb-usb: generic DVB-USB
module successfully deinitialized and disconnected.
Mar 27 13:15:05 tv kernel: [   32.462033] DVB: registering new adapter
(bttv0)
Mar 27 13:15:05 tv kernel: [   32.597128] dib0700: firmware started
successfully.
Mar 27 13:15:05 tv kernel: [   33.100810] dvb-usb: found a 'Hauppauge
Nova-T 500 Dual DVB-T' in warm state.
Mar 27 13:15:05 tv kernel: [   33.100870] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
Mar 27 13:15:05 tv kernel: [   33.101051] DVB: registering new adapter
(Hauppauge Nova-T 500 Dual DVB-T)
Mar 27 13:15:05 tv kernel: [   33.136779] NET: Registered protocol family 17
Mar 27 13:15:05 tv kernel: [   33.214639] DVB: registering frontend 4
(DiBcom 3000MC/P)...
Mar 27 13:15:05 tv kernel: [   33.231980] MT2060: successfully
identified (IF1 = 1217)
Mar 27 13:15:05 tv kernel: [   33.707872] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
Mar 27 13:15:05 tv kernel: [   33.708057] DVB: registering new adapter
(Hauppauge Nova-T 500 Dual DVB-T)
Mar 27 13:15:05 tv kernel: [   33.713737] DVB: registering frontend 5
(DiBcom 3000MC/P)...
Mar 27 13:15:05 tv kernel: [   33.718478] MT2060: successfully
identified (IF1 = 1228)
Mar 27 13:15:05 tv kernel: [   34.267827] input: IR-receiver inside an
USB DVB receiver as
/devices/pci0000:00/0000:00:1e.0/0000:01:02.2/usb2/2-1/input/input7
Mar 27 13:15:05 tv kernel: [   34.294333] dvb-usb: schedule remote query
interval to 150 msecs.
Mar 27 13:15:05 tv kernel: [   34.294338] dvb-usb: Hauppauge Nova-T 500
Dual DVB-T successfully initialized and connected.
Mar 27 13:15:05 tv kernel: [   34.294578] usbcore: registered new
interface driver dvb_usb_dib0700
Mar 27 13:15:05 tv kernel: [   34.294586] usbcore: registered new
interface driver usbserial
Mar 27 13:15:05 tv kernel: [   34.294607]
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
Mar 27 13:15:05 tv kernel: [   34.294642] usbcore: registered new
interface driver hiddev
Mar 27 13:15:05 tv kernel: [   34.294685] usbcore: registered new
interface driver opera1
Mar 27 13:15:05 tv kernel: [   34.513875] usb 1-1: new high speed USB
device using ehci_hcd and address 5
Mar 27 13:15:05 tv kernel: [   34.647000] usb 1-1: configuration #1
chosen from 1 choice
Mar 27 13:15:05 tv kernel: [   34.647512] opera: start downloading fpga
firmware dvb-usb-opera1-fpga-01.fw
Mar 27 13:15:05 tv kernel: [   36.019479] DST type flags : 0x1 newtuner
0x1000 VLF 0x10 firmware version = 2
Mar 27 13:15:05 tv kernel: [   39.360143] DVB: registering frontend 3
(DST DVB-S)...
Mar 27 13:15:05 tv kernel: [   39.832053] dvb-usb: found a 'Opera1 DVB-S
USB2.0' in warm state.
Mar 27 13:15:05 tv kernel: [   39.832326] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
Mar 27 13:15:05 tv kernel: [   39.832550] DVB: registering new adapter
(Opera1 DVB-S USB2.0)
Mar 27 13:15:05 tv kernel: [   39.834896] dvb-usb: MAC address:
00:e0:4f:00:24:97
Mar 27 13:15:05 tv kernel: [   40.078417] DVB: registering frontend 6
(ST STV0299 DVB-S)...
Mar 27 13:15:05 tv kernel: [   40.081499] input: IR-receiver inside an
USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/input/input8
Mar 27 13:15:05 tv kernel: [   40.126747] dvb-usb: schedule remote query
interval to 200 msecs.
Mar 27 13:15:05 tv kernel: [   40.126947] dvb-usb: Opera1 DVB-S USB2.0
successfully initialized and connected.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

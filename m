Return-path: <linux-media-owner@vger.kernel.org>
Received: from [194.250.18.140] ([194.250.18.140]:34615 "EHLO tv-numeric.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751720AbZEROxM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 10:53:12 -0400
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-media@vger.kernel.org>
Subject: Hauppauge Nova-TD-500 vs. T-500
Date: Mon, 18 May 2009 16:32:40 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAACtixxRYhkEeDGBNeWWfFCAEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Like many others, I have some problems with the Hauppauge Nova-TD-500.

I have been running a Fedora system with one Hauppauge Nova-T-500
(-T-, with one input connector, not -TD-) quite successfully for 2 years.
I just built another Fedora system and ordered two T-500 but I actually
received two TD-500 (the one with two input connectors).

So, I now have another Fedora box with two Hauppauge Nova-TD-500
and it does not work quite well.

The two systems (the first one with one T-500 and the second one with
two TD-500) are running the same O/S version, same drivers, same firmware:

- Fedora 10, up-to-date as of 2009-05-17
- Kernel 2.6.27.21-170.2.56.fc10.i686
- Latest V4L-DVB mercurial tree, same date
- Firmware dvb-usb-dib0700-1.20.fw

You will find below some outputs of dmesg, lspci, etc for the two
systems.

I use custom signal monitoring applications, no TV watching apps.
The same application is used in both systems, same antenna input
(roof antenna and wall socket, not the small antenna that comes
with the cards). The application continuously reads the complete
transport stream for analysis. From time to time, it tunes to
some frequency, then another, etc.

With the two TD-500, the 4 adapters are created under /dev/dvb. Using
them works more or less. As far as I tested now, I do not have any
reported error, no error message. But the input is "not good": many
packets are corrupted. This does not happen all the time. Sometimes,
the input is "reasonably correct" (a few packets seems incorrect)
and sometimes it is a mess (most packets are incorrect, the result
of the analysis report many non-existing PIDs, weird content, etc).

I guess that most of you will say "most probably an application pb"...
But the same application is working fine with:

1) Linux + Hauppauge Nova-T-500
2) Linux + Hauppauge Nova-T Stick
3) Linux + Pinnacle PCTV stick 72e
4) Windows + the two above sticks
4) Windows + Terratec Cinergy T USB XE Rev 2 (not supported on Linux)

Of course, on Windows, the input module is a custom DirectShow capture
filter instead of Linux DVB API but the rest of the application is identical.

Another weird behaviour: After running the monitoring application,
ioctl (frontend_fd, FE_GET_INFO, ...) returns "No such device" errno.
Example:

1) Run tool to get dvb device info, ie. ioctl FE_GET_INFO, right
   after system boot:

/dev/dvb/adapter0 (DiBcom 7000PC, DVB-T)

  Status:

  Bit error rate ......................... 2,097,151 (0%)
  Signal/noise ratio ............................. 0 (0%)
  Signal strength ................................ 0 (0%)
  Uncorrected blocks ............................. 0
  Frequencies:
    Current ...................................... 0 Hz
    Min ................................. 45,000,000 Hz
    Max ................................ 860,000,000 Hz
    Step .................................... 62,500 Hz
    Tolerance .................................... 0 Hz
  Spectral inversion .......................... auto
  Bandwidth .................................. 8-MHz
  FEC (high priority) .......................... 1/2
  FEC (low priority) ........................... 1/2
  Constellation ............................... QPSK
  Transmission mode ............................. 2K
  Guard interval .............................. 1/32
  Hierarchy ................................... none

2) Run monitoring application. OK, with corrupted packets.
3) Run previous tool doing ioctl FE_GET_INFO:
error getting info on /dev/dvb/adapter0/frontend0: No such device
Note: this error is reported by ioctl, opening the device is OK.
4) # ls -l /dev/dvb/adapter0/frontend0
crw-rw----+ 1 tlelegard video 212, 3 2009-05-18 15:59 /dev/dvb/adapter0/frontend0
5) Run monitoring application. OK, with corrupted packets.


Is there any new development regarding TD-500 ?
Any test I could make ?

Thanks in advance for your assistance.
-Thierry


-----------------------------------------------------------------
dmesg - one T-500
-----------------------------------------------------------------

# dmesg | grep -i -e dvb -e dib
dib0700: loaded with support for 9 different device-types
dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold state, will try to load a firmware
firmware: requesting dvb-usb-dib0700-1.20.fw
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
DVB: registering adapter 0 frontend 0 (DiBcom 3000MC/P)...
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700
#

-----------------------------------------------------------------
dmesg - two TD-500
-----------------------------------------------------------------

# dmesg | grep -i -e dvb -e dib
dib0700: loaded with support for 9 different device-types
dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in cold state, will try to load a firmware
firmware: requesting dvb-usb-dib0700-1.20.fw
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:05:04.2/usb3/3-1/input/input6
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: Hauppauge Nova-TD-500 (84xxx) successfully initialized and connected.
dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in cold state, will try to load a firmware
firmware: requesting dvb-usb-dib0700-1.20.fw
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
DVB: registering adapter 2 frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
DVB: registering adapter 3 frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:05:05.2/usb4/4-1/input/input7
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: Hauppauge Nova-TD-500 (84xxx) successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700
#

-----------------------------------------------------------------
lspci - one T-500
-----------------------------------------------------------------

# lspci
....
0c:02.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61)
0c:02.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61)
0c:02.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)
#

-----------------------------------------------------------------
lspci - two TD-500
-----------------------------------------------------------------

# lspci
05:04.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62)
05:04.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65)
05:05.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62)
05:05.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65)
#

-----------------------------------------------------------------
lspci -vv - one T-500
-----------------------------------------------------------------

# lspci -vv -s 0c:02
0c:02.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 4: I/O ports at bcc0 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: uhci_hcd

0c:02.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at bce0 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: uhci_hcd

0c:02.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63) (prog-if 20 [EHCI])
        Subsystem: VIA Technologies, Inc. USB 2.0
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 16
        Region 0: Memory at f3afff00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: ehci_hcd

#

-----------------------------------------------------------------
lspci -vv - two TD-500
-----------------------------------------------------------------

# lspci -vv -s 05:04
05:04.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at ccc0 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: uhci_hcd

05:04.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65) (prog-if 20 [EHCI])
        Subsystem: VIA Technologies, Inc. USB 2.0
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at f9dffe00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: ehci_hcd

#

-----------------------------------------------------------------
ls /dev/dvb - one T-500
-----------------------------------------------------------------

# ls -lR /dev/dvb
/dev/dvb:
total 0
drwxr-xr-x 2 root root 120 2009-05-12 15:53 adapter0
drwxr-xr-x 2 root root 120 2009-05-12 15:53 adapter1

/dev/dvb/adapter0:
total 0
crw-rw----+ 1 tlelegard video 212, 0 2009-05-12 15:53 demux0
crw-rw----+ 1 tlelegard video 212, 1 2009-05-12 15:53 dvr0
crw-rw----+ 1 tlelegard video 212, 3 2009-05-12 15:53 frontend0
crw-rw----+ 1 tlelegard video 212, 2 2009-05-12 15:53 net0

/dev/dvb/adapter1:
total 0
crw-rw----+ 1 tlelegard video 212, 4 2009-05-12 15:53 demux0
crw-rw----+ 1 tlelegard video 212, 5 2009-05-12 15:53 dvr0
crw-rw----+ 1 tlelegard video 212, 7 2009-05-12 15:53 frontend0
crw-rw----+ 1 tlelegard video 212, 6 2009-05-12 15:53 net0
#

-----------------------------------------------------------------
ls /dev/dvb - two TD-500
-----------------------------------------------------------------

# ls -lR /dev/dvb
/dev/dvb:
total 0
drwxr-xr-x 2 root root 120 2009-05-18 15:59 adapter0
drwxr-xr-x 2 root root 120 2009-05-18 15:59 adapter1
drwxr-xr-x 2 root root 120 2009-05-18 15:59 adapter2
drwxr-xr-x 2 root root 120 2009-05-18 15:59 adapter3

/dev/dvb/adapter0:
total 0
crw-rw----+ 1 tlelegard video 212, 0 2009-05-18 15:59 demux0
crw-rw----+ 1 tlelegard video 212, 1 2009-05-18 15:59 dvr0
crw-rw----+ 1 tlelegard video 212, 3 2009-05-18 15:59 frontend0
crw-rw----+ 1 tlelegard video 212, 2 2009-05-18 15:59 net0

/dev/dvb/adapter1:
total 0
crw-rw----+ 1 tlelegard video 212, 4 2009-05-18 15:59 demux0
crw-rw----+ 1 tlelegard video 212, 5 2009-05-18 15:59 dvr0
crw-rw----+ 1 tlelegard video 212, 7 2009-05-18 15:59 frontend0
crw-rw----+ 1 tlelegard video 212, 6 2009-05-18 15:59 net0

/dev/dvb/adapter2:
total 0
crw-rw----+ 1 tlelegard video 212,  8 2009-05-18 15:59 demux0
crw-rw----+ 1 tlelegard video 212,  9 2009-05-18 15:59 dvr0
crw-rw----+ 1 tlelegard video 212, 11 2009-05-18 15:59 frontend0
crw-rw----+ 1 tlelegard video 212, 10 2009-05-18 15:59 net0

/dev/dvb/adapter3:
total 0
crw-rw----+ 1 tlelegard video 212, 12 2009-05-18 15:59 demux0
crw-rw----+ 1 tlelegard video 212, 13 2009-05-18 15:59 dvr0
crw-rw----+ 1 tlelegard video 212, 15 2009-05-18 15:59 frontend0
crw-rw----+ 1 tlelegard video 212, 14 2009-05-18 15:59 net0
#


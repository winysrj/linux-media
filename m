Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <luca.i@gmx.net>) id 1JmuZF-0002FQ-6J
	for linux-dvb@linuxtv.org; Fri, 18 Apr 2008 19:40:10 +0200
From: Luca Ingianni <luca.i@gmx.net>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Fri, 18 Apr 2008 19:39:38 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804181939.39153.luca.i@gmx.net>
Subject: [linux-dvb] Hauppauge Nova-TD trouble: still or again?
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

Hi all,

I've just subscribed to this list, so a quick introduction might be in order. 
My name is Luca, I live in Munich, Germany. While I have no experience with 
Linux coding, I've been using it since the glorious days of kernel 1.2.13 or 
somesuch (around 1996 or so).

For the last few days, I've been searching high and low for a way to get my 
Nova-TD to work reliably. I've since found out about the problem with the 
SB600 southbridge (after buying the Nova :(   ), but from what I gathered it 
should have been fixed in kernel 2.6.24-14 . The problem is, I'm running 
2.6.24-16 (Ubuntu Hardy flavour) and still get the USB disconnects when using 
both tuners at once.
As soon as I close kaffeine, it reconnects immediately and is generally ready 
to use again.

Does anyone know a solution to my problem? I'm of course willing to help 
search for one within the constraints of my (rather limited) programming 
abilities.

TIA & have a nice weekend,
Luca

-------------------------------------------

For the record:

[29638.416360] dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV 
Diversity' in cold state, will try to load a firmware
[29638.450493] dvb-usb: downloading firmware from 
file 'dvb-usb-dib0700-1.10.fw'
[29638.619118] dib0700: firmware started successfully.
[29638.999238] dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV 
Diversity' in warm state.
[29638.999277] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[29638.999472] DVB: registering new adapter (Hauppauge Nova-TD Stick/Elgato 
Eye-TV Diversity)
[29639.169888] DVB: registering frontend 0 (DiBcom 7000PC)...
[29639.174369] MT2266: successfully identified
[29639.290991] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[29639.291135] DVB: registering new adapter (Hauppauge Nova-TD Stick/Elgato 
Eye-TV Diversity)
[29639.416945] DVB: registering frontend 1 (DiBcom 7000PC)...
[29639.419870] MT2266: successfully identified
[29639.551404] dvb-usb: Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity 
successfully initialized and connected.
[29639.551720] usb 6-1: USB disconnect, address 13
[39362.203648] hub 6-0:1.0: port 3 disabled by hub (EMI?), re-enabling...
[39362.203656] usb 6-3: USB disconnect, address 14
[39362.204130] MT2266 I2C write failed
[39362.204133] MT2266 I2C write failed
[40638.470641] MT2266 I2C write failed
[40638.470650] MT2266 I2C write failed
[40639.199539] dvb-usb: error while stopping stream.
[40639.199574] dvb-usb: error while stopping stream.
[40639.200395] dvb-usb: Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity 
successfully deinitialized and disconnected.
[40639.312141] usb 6-3: new high speed USB device using ehci_hcd and address 
15
[40639.447675] usb 6-3: configuration #1 chosen from 1 choice
[40639.447848] dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV 
Diversity' in warm state.
[40639.447869] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[40639.448049] DVB: registering new adapter (Hauppauge Nova-TD Stick/Elgato 
Eye-TV Diversity)
[40639.738729] DVB: registering frontend 0 (DiBcom 7000PC)...
[40639.742468] MT2266: successfully identified
[40639.906738] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[40639.906924] DVB: registering new adapter (Hauppauge Nova-TD Stick/Elgato 
Eye-TV Diversity)
[40640.134829] DVB: registering frontend 1 (DiBcom 7000PC)...
[40640.138691] MT2266: successfully identified
[40640.305787] dvb-usb: Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity 
successfully initialized and connected.

luca@godzilla:~$ uname -a
Linux godzilla 2.6.24-16-generic #1 SMP Thu Apr 10 12:47:45 UTC 2008 x86_64 
GNU/Linux
luca@godzilla:~$ lsusb
Bus 006 Device 015: ID 2040:9580 Hauppauge 
Bus 006 Device 001: ID 0000:0000  
Bus 005 Device 001: ID 0000:0000  
Bus 004 Device 001: ID 0000:0000  
Bus 003 Device 001: ID 0000:0000  
Bus 002 Device 001: ID 0000:0000  
Bus 001 Device 003: ID 046d:c517 Logitech, Inc. LX710 Cordless Desktop Laser
Bus 001 Device 001: ID 0000:0000  

luca@godzilla:~$ lspci
00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual slot 
PCI-e_GFX and HT3 K8 part
00:02.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (external 
gfx0 port A)
00:07.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI express 
gpp port D)
00:09.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI express 
gpp port E)
00:0a.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI express 
gpp port F)
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3870
01:00.1 Audio device: ATI Technologies Inc Radeon HD 3870 Audio device
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI 
Express Gigabit Ethernet controller (rev 01)
03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
Controller (rev 02)
03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
Controller (rev 02)
04:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
Controller (rev 02)
04:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
Controller (rev 02)
05:06.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213 
Multiprotocol MAC/baseband processor (rev 01)
05:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 
Controller (PHY/Link)


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

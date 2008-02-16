Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zmousm@admin.grnet.gr>) id 1JQR3P-00048P-KD
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 18:42:23 +0100
Message-Id: <B9DD88E0-E3EA-4E57-BABE-5FD4E520D6F4@admin.grnet.gr>
From: Zenon Mousmoulas <zmousm@admin.grnet.gr>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sat, 16 Feb 2008 19:40:36 +0200
Subject: [linux-dvb] Hauppauge WinTV-HVR4000 and DVB-S2...
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I know this has been discussed over and over again in the list,  
however after having read:
- http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000
- http://dev.kewl.org/hauppauge/
- most of the relevant threads on this list, at least the recent ones
I have been trying for half a day and I still can not get this to work.

My goal is to get this card to tune to a DVB-S2 transponder, more  
specifically this one:
http://en.kingofsat.net/tp.php?tp=2656
I have a dish with 4 LNBs connected to the HVR4000 through a DiSEqC  
1.0 4x1 switch.
The 4th LNB is pointed to this satellite and I can tune to DVB-S  
transponders there just fine with another card as well as this one  
(more on that later).

I assume multiproto is necessary for DVB-S2 tuning to actually work.  
Right? In all the above sources of information, this is only clearly  
noted in some threads in the list archives.

I have been following the steps noted on the wiki page:

Latest - 29-1-08
---------------------------
hg clone http://jusst.de/hg/multiproto
wget http://www.linuxtv.org/pipermail/linux-dvb/attachments/20080128/adee4c88/attachment-0001.bin
mv attachment-0001.bin multiproto-hvr4k-2008-01-28.patch.bz2
bunzip2 multiproto-hvr4k-2008-01-28.patch.bz2
ln -s multiproto a; ln -s multiproto b
patch -p0 < multiproto-hvr4k-2008-01-28.patch
cd multiproto
run make menuconfig and disable the USB capture cards as the em88  
drivers are broken and make sure customise frontends is enabled.
make && make install && reboot

I am working on a Debian testing/lenny system. I have tried the above  
with kernels 2.6.22 and 2.6.24. The sample kernel output on the wiki  
says 2.6.26.1. What is the minimum kernel version that must be used  
with multiproto in order for DVB-S2 to work?

These are the relevant parts of kernel log on 2.6.24:

cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 DVB-S/S2/ 
T/Hybrid [card=59,autodetected]
cx88[0]: TV tuner type 63, Radio tuner type -1
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx2388x alsa driver version 0.0.6 loaded
tveeprom 1-0050: Hauppauge model 69009, rev B2D3, serial# 3033667
tveeprom 1-0050: MAC address is 00-0D-FE-2E-4A-43
tveeprom 1-0050: tuner model is Philips FMD1216MEX (idx 133, type 63)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K)  
ATSC/DVB Digital (eeprom 0xf4)
tveeprom 1-0050: audio processor is CX882 (idx 33)
tveeprom 1-0050: decoder processor is CX882 (idx 25)
tveeprom 1-0050: has radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=69009
input: cx88 IR (Hauppauge WinTV-HVR400 as /class/input/input4
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:02:0b.2[A] -> GSI 23 (level, low) -> IRQ 19
cx88[0]/2: found at 0000:02:0b.2, rev: 5, irq: 19, latency: 64, mmio:  
0xf9000000
ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 23 (level, low) -> IRQ 19
cx88[0]/0: found at 0000:02:0b.0, rev: 5, irq: 19, latency: 64, mmio:  
0xf7000000
input: ImExPS/2 Logitech Explorer Mouse as /class/input/input5
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 DVB-S/ 
S2/T/Hybrid [card=59]
cx88[0]/2: cx2388x based DVB/ATSC card
tuner' 1-0043: chip found @ 0x86 (cx88[0])
tda9887 1-0043: tda988[5/6/7] found
tuner' 1-0061: chip found @ 0xc2 (cx88[0])
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner' 1-0063: chip found @ 0xc6 (cx88[0])
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Conexant CX24116/CX24118)...
ACPI: PCI Interrupt 0000:02:0b.1[A] -> GSI 23 (level, low) -> IRQ 19
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1f.5 to 64
[...]
cx24116_firmware_ondemand: Waiting for firmware upload (dvb-fe- 
cx24116.fw)...
cx24116_firmware_ondemand: Waiting for firmware upload(2)...
cx24116_load_firmware: FW version 1.20.79.0
cx24116_firmware_ondemand: Firmware upload complete

I have also tried the patches from http://dev.kewl.org/hauppauge/  
against the v4l-dvb tree. The patches didn't apply cleanly with the  
current tip. I had to go back to 7192 (b6e3eee46ca2) to apply the  
2008-02-07 sfe patch. Compiled for 2.4.22, DVB-S works, with the  
default sysctl value of dev.cx24116.modfec=0xfe30. After setting  
dev.cx24116.modfec=0x0d I can no longer scan a DVB-S or a DVB-S2  
transponder. With 2.4.24 neither of the above works.

Could someone please help? I am afraid that I am either getting it all  
wrong, or the recipes from two weeks ago no longer work. I'm not that  
new to linux-dvb, but I haven't followed the developments involving  
this card, multiproto and DVB-S2, and it's really overwhelming/ 
confusing...

One more thing: I've read about szap2 and perhaps other dvb-apps which  
have been specifically made compatible with multiproto. I've noticed  
these being casually mentioned in various list posts. However, I have  
only been able to find a few somewhat old "traces" of szap2, and not,  
say, a full patch against dvb-apps. Is there a distribution? Where at?

Thanks in advance.

Best regards,
Zenon


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

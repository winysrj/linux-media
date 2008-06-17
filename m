Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1K8jg7-00059g-6v
	for linux-dvb@linuxtv.org; Wed, 18 Jun 2008 00:29:28 +0200
Date: Wed, 18 Jun 2008 01:29:09 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: linux-dvb@linuxtv.org
In-Reply-To: <484F7A8B.1010602@dupondje.be>
Message-ID: <Pine.LNX.4.64.0806180120550.25378@shogun.pilppa.org>
References: <484EFB7B.7020505@pilppa.org> <484F7A8B.1010602@dupondje.be>
MIME-Version: 1.0
Subject: Re: [linux-dvb] HVR-1300 problems with new kernels
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

> I would try to fix the Firmware error. U prolly need to copy the firmware 
> into the firmware dir for the newest kernel. Check what it does if u be able 
> to make the driver load the firmware correctly.

Hi, sorry it took so long to answer as I was away from computer.

I installed the v4l-cx2341x-enc.fw from ivtv-firmware rpm and the firmware 
load warning went away.

DVB is however still not working with 2.6.24, 26.25 and 2.6.26-rc4 
kernels I have tested. But will work if I build and load v4l-dvb drivers.

cx88/dvb related dmesg output looks ok for me and I have things created 
under /dev/dvb...

cx2388x alsa driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:03:06.1[A] -> GSI 20 (level, low) -> IRQ 20
cx88[0]: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 DVB-T/Hybrid 
MPEG Encoder [card=56,autodetected]
cx88[0]: TV tuner type 63, Radio tuner type -1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
tuner' 1-0061: chip found @ 0xc2 (cx88[0])
tuner' 1-0063: chip found @ 0xc6 (cx88[0])
tveeprom 1-0050: Hauppauge model 96019, rev C6A0, serial# 1230818
tveeprom 1-0050: MAC address is 00-0D-FE-12-C7-E2
tveeprom 1-0050: tuner model is Philips FMD1216ME (idx 100, type 63)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) 
ATSC/DVB Digital (eeprom 0xf4)
tveeprom 1-0050: audio processor is CX882 (idx 33)
tveeprom 1-0050: decoder processor is CX882 (idx 25)
tveeprom 1-0050: has radio, has IR receiver, has IR transmitter
cx88[0]: hauppauge eeprom: model=96019
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 20 (level, low) -> IRQ 20
cx88[0]/0: found at 0000:03:06.0, rev: 5, irq: 20, latency: 32, mmio: 
0xfa000000
wm8775' 1-001b: chip found @ 0x36 (cx88[0])
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:03:06.2[A] -> GSI 20 (level, low) -> IRQ 20
cx88[0]/2: found at 0000:03:06.2, rev: 5, irq: 20, latency: 32, mmio: 
0xfb000000
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56]
cx88[0]/2: cx2388x based DVB/ATSC card
tuner-simple 1-0061: attaching existing instance
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
cx2388x blackbird driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: blackbird access: shared
cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56]
cx88[0]/2: cx23416 based mpeg encoder (blackbird reference design)
cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized or corrupted
firmware: requesting v4l-cx2341x-enc.fw
cx88[0]/2-bb: Firmware upload successful.
cx88[0]/2-bb: Firmware version is 0x02060039
cx88[0]/2: registered device video1 [mpeg]


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4TKR8bI011856
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 16:27:08 -0400
Received: from hermes.gsix.se (hermes.gsix.se [193.11.224.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4TKQp9Q009332
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 16:26:54 -0400
Received: from dng-gw.sgsnet.se ([193.11.230.69] helo=[172.16.172.22])
	by hermes.gsix.se with esmtp (Exim 4.63)
	(envelope-from <jonatan@akerlind.nu>) id 1K1ohx-0008Uk-Lg
	for video4linux-list@redhat.com; Thu, 29 May 2008 22:26:45 +0200
From: Jonatan =?ISO-8859-1?Q?=C5kerlind?= <jonatan@akerlind.nu>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Thu, 29 May 2008 22:26:27 +0200
Message-Id: <1212092787.7328.16.camel@skoll>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Hauppauge HVR-1300 analog troubles
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I'm trying to get the analog part of my HVR-1300 working. I have tried
several different approaches without any luck so far. Right now I have
the latest sources from http://linuxtv.org/hg/v4l-dvb compiled on a
gentoo system with a 2.6.24-gentoo-r8 kernel (without v4l in kernel).
The problem I have is that when using scantv to tune for channels the
tuner does not seem to actually tune, or perhaps there is no video
output on the v4l device node because scantv cannot find any channels.
When I connect a video source on the s-video input and use xawtv I get a
perfect picture from that input. Yes I have checked that the antenna is
correctly connected (I use the same cable switching with another tv-card
which is working). I'm using PAL B/G with western-europe frequency
table, but have not so far tried the digital receiver since i don't yet
have any proper antenna to use. 

Anyone have any clue or tip?
I have followed some different instructions for how to get this card
working, the latest I used was this:
http://gentoo-wiki.com/HARDWARE_Hauppauge_HVR_1300

Some info about my setup:

dmesg info when modprobing the cx8800 module:
(I have 
install cx88xx modprobe tuner; modprobe --ignore-install cx88xx
in my /etc/modprobe.conf to get the tuner loaded before the cx88xx)

Linux video capture interface: v2.00
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:00:14.0[A] -> GSI 17 (level, low) -> IRQ 19
cx88[0]: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56,autodetected]
cx88[0]: TV tuner type 63, Radio tuner type -1
tuner' 1-0061: chip found @ 0xc2 (cx88[0])
tuner' 1-0063: chip found @ 0xc6 (cx88[0])
tveeprom 1-0050: Hauppauge model 96019, rev D6D3, serial# 3218455
tveeprom 1-0050: MAC address is 00-0D-FE-31-1C-17
tveeprom 1-0050: tuner model is Philips FMD1216MEX (idx 133, type 63)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
tveeprom 1-0050: audio processor is CX882 (idx 33)
tveeprom 1-0050: decoder processor is CX882 (idx 25)
tveeprom 1-0050: has radio, has IR receiver, has IR transmitter
cx88[0]: hauppauge eeprom: model=96019
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
cx88[0]/0: found at 0000:00:14.0, rev: 5, irq: 19, latency: 32, mmio: 0xfa000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0

lspci output:

00:14.0 0400: 14f1:8800 (rev 05)
        Subsystem: 0070:9601
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx8800
        Kernel modules: cx8800

00:14.1 0480: 14f1:8811 (rev 05)
        Subsystem: 0070:9601
        Flags: bus master, medium devsel, latency 32, IRQ 5
        Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel modules: cx88-alsa

00:14.2 0480: 14f1:8802 (rev 05)
        Subsystem: 0070:9601
        Flags: bus master, medium devsel, latency 32, IRQ 5
        Memory at f8000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel modules: cx8802

/Jonatan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

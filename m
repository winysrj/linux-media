Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50026 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab1JKOn3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 10:43:29 -0400
Received: by qadb15 with SMTP id b15so4749417qad.19
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2011 07:43:29 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 11 Oct 2011 09:43:28 -0500
Message-ID: <CANut7vDGKcYD3zXNSGv3UAkLaE+_x=Yv2WuJQm8RFmZPOCAg9g@mail.gmail.com>
Subject: kernel settings and modules for radio tuner
From: Will Milspec <will.milspec@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Sorry if this is the wrong place for this question, but I've had
trouble finding recent information about fm card support in light of
recent kernel changes.

Context
=========
I use an fm card (WINTV-GO fm) for listening/recording radio.  It's a
great tool for building fair-use recordings.

Kernel upgrades--dropping V4L1 support-- forced upgrading fmtools
(from 1.0.2 to 2.0.1).  However, "fm" command fails:

 #fm on
Radio on (radio does not support volume control)
 # fm 98.7
/usr/local/bin/fm: Frequency 98.7 MHz out of range (0.0 - 0.0 MHz)

Tuner module
===============
For documentation, I've used the bttv howto:
   http://tldp.org/HOWTO/html_single/BTTV/

"modprobe tuner" succeeds but then "tuner" doesn't appear in the lsmod
output. I don't see any 'tuner' modules in the '/lib/modules/*

(I've appended dmesg output below).
Question
============
Does the tuner module still exist?
What kernnel config options to load it?

Google searches showed most of the documentation is 5-10 years old and
"last.fm" seems more popular than "over the air fm".


thanks

will


Appendix A. Dmesg Output
===========================
Here are relevent sections from dmesg:

bttv: driver version 0.9.18 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:05:0a.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
bttv0: Bt878 (rev 2) at 0000:05:0a.0, irq: 21, latency: 66, mmio: 0xf8500000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00fffffb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 0-0050: Hauppauge model 62471, rev A2  , serial# 1155176
tveeprom 0-0050: tuner model is Philips FM1236 (idx 23, type 2)
tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 0-0050: audio processor is TDA9850 (idx 3)
tveeprom 0-0050: has radio
bttv0: Hauppauge eeprom indicates model#62471
bttv: driver version 0.9.18 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:05:0a.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
bttv0: Bt878 (rev 2) at 0000:05:0a.0, irq: 21, latency: 66, mmio: 0xf8500000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00fffffb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 0-0050: Hauppauge model 62471, rev A2  , serial# 1155176
tveeprom 0-0050: tuner model is Philips FM1236 (idx 23, type 2)
tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 0-0050: audio processor is TDA9850 (idx 3)
tveeprom 0-0050: has radio
bttv0: Hauppauge eeprom indicates model#62471

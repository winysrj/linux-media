Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail14.opentransfer.com ([76.162.254.14])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dcoates@systemoverload.net>) id 1KXMYQ-0003ip-Md
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 22:51:21 +0200
From: "Dustin Coates" <dcoates@systemoverload.net>
To: "'Steven Toth'" <stoth@linuxtv.org>
References: <1219545012.23807.1.camel@sysmain> <48B16766.7070306@linuxtv.org>
In-Reply-To: <48B16766.7070306@linuxtv.org>
Date: Sun, 24 Aug 2008 15:50:44 -0500
Message-ID: <002801c9062b$141c01f0$3c5405d0$@net>
MIME-Version: 1.0
Content-Language: en-us
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1800 Analog issues
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

Thanks. 

I got all the modules loaded, but lspci -vnn is still show it as
unreconized. 
  
02:00.0 Multimedia video controller [0400]: Conexant Unknown device
[14f1:8880] (rev 0f)
	Subsystem: Hauppauge computer works Inc. Unknown device [0070:7801]
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at e9000000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: <access denied>

dmesg shows it as loading though.

[   37.521263] cx23885 driver version 0.0.1 loaded
[   37.605787] cx25840 0-0044: cx25843-24 found @ 0x88 (ivtv i2c driver
#0)
[   37.608154] tuner 0-0061: chip found @ 0xc2 (ivtv i2c driver #0)
[   37.608176] wm8775 0-001b: chip found @ 0x36 (ivtv i2c driver #0)
[   37.746626] tuner-simple 0-0061: creating new instance
[   37.746629] tuner-simple 0-0061: type set to 50 (TCL 2002N)
[   37.747851] ivtv0: Registered device video0 for encoder MPG (4096 kB)
[   37.747872] ivtv0: Registered device video32 for encoder YUV (2048
kB)
[   37.747895] ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
[   37.747915] ivtv0: Registered device video24 for encoder PCM (320 kB)
[   37.747917] ivtv0: Initialized card #0: Hauppauge WinTV PVR-150
[   37.747932] ivtv:  End initialization
[   37.748030] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   37.748040] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   37.748064] sky2 0000:03:00.0: v1.20 addr 0xe5000000 irq 17 Yukon-EC
Ultra (0xb4) rev 2
[   37.748420] sky2 eth0: addr 00:16:e6:d3:38:33
[   37.748478] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   37.748484] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   37.748569] NVRM: loading NVIDIA UNIX x86 Kernel Module  173.14.12
Thu Jul 17 18:11:36 PDT 2008
[   37.749928] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   37.749947] CORE cx23885[0]: subsystem: 0070:7801, board: Hauppauge
WinTV-HVR1800 [card=2,autodetected]
[   37.930305] tuner' 1-0061: chip found @ 0xc2 (cx23885[0])
[   37.932271] cx23885[0]: i2c bus 0 registered
[   37.959759] tuner' 2-0042: chip found @ 0x84 (cx23885[0])
[   37.995903] tda829x 2-0042: could not clearly identify tuner address,
defaulting to 60
[   38.055821] tda18271 2-0060: creating new instance
[   38.074523] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level,
low) -> IRQ 23
[   38.074541] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   38.091286] TDA18271HD/C1 detected @ 2-0060
[   39.257988] tda829x 2-0042: type set to tda8295+18271
[   40.363430] cx23885[0]: i2c bus 1 registered
[   40.364411] cx25840' 3-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   40.364782] cx23885[0]: i2c bus 2 registered
[   40.391559] tveeprom 1-0050: Hauppauge model 78521, rev C1E9, serial#
4851744
[   40.391562] tveeprom 1-0050: MAC address is 00-0D-FE-4A-08-20
[   40.391564] tveeprom 1-0050: tuner model is Philips 18271_8295 (idx
149, type 54)
[   40.391567] tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[   40.391569] tveeprom 1-0050: audio processor is CX23887 (idx 42)
[   40.391571] tveeprom 1-0050: decoder processor is CX23887 (idx 37)
[   40.391573] tveeprom 1-0050: has radio
[   40.391575] cx23885[0]: hauppauge eeprom: model=78521
[   40.396523] cx23885[0]/0: registered device video1 [v4l2]
[   42.106808] cx25840' 3-0044: loaded v4l-cx23885-avcore-01.fw firmware
(16382 bytes)
[   42.120465] cx23885[0]: registered device video2 [mpeg]
[   42.120469] cx23885[0]: cx23885 based dvb card
[   42.197123] MT2131: successfully identified at address 0x61
[   42.197127] DVB: registering new adapter (cx23885[0])
[   42.197130] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB
Frontend)...
[   42.197333] cx23885_dev_checkrevision() Hardware revision = 0xb1
[   42.197340] cx23885[0]/0: found at 0000:02:00.0, rev: 15, irq: 16,
latency: 0, mmio: 0xe9000000

I have the HVR-1800 MCE kit edition

Also another issue, don't know if this is mythtv relateed or drive
related. 

When i set the card up in mythtv is /dev/video0 lets me choos
television/s-video/composite whereas /dev/video1 is stuck on unset. 

Anything i can do to help? It's been ages since i've programmed, but i
have a high learning curve. 


-----Original Message-----
From: Steven Toth [mailto:stoth@linuxtv.org] 
Sent: Sunday, August 24, 2008 8:52 AM
To: dcoates@systemoverload.net
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1800 Analog issues

Dustin Coates wrote:
> Any news on this? I bought this card but i noticed alot of people are
> having problems with the anal nouge side of the card. I was wondering if
> thier was any new developments.

I've noticed a few posts but I'm not able to test or try and repro the 
problem. It sits on my todo list until I have a PCIe development system.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

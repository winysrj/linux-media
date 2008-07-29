Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1KNfNU-0004lx-AW
	for linux-dvb@linuxtv.org; Tue, 29 Jul 2008 04:55:59 +0200
From: Andy Walls <awalls@radix.net>
To: mpapet@yahoo.com
In-Reply-To: <878306.34570.qm@web62009.mail.re1.yahoo.com>
References: <878306.34570.qm@web62009.mail.re1.yahoo.com>
Date: Mon, 28 Jul 2008 22:54:48 -0400
Message-Id: <1217300088.2978.36.camel@morgan.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18/hvr-1600 Issues and Updates
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

On Sun, 2008-07-27 at 23:33 -0700, Michael Papet wrote:
> Andy,
> 
> Thanks for the info.  See below for the data you requested and
> v4l2-ctl stuff.  As an FYI, I did all of the below over ssh, with X11
> forwarding just fine.  
> 
> After trying all kinds of mplayer incantations, this at least rendered
> an empty overlay box.    mplayer tv://
> tv=driver=v4l2:input=1:width=320:height=240:device=/dev/video0:freq=67.25 -vo x11

I have never used the "tv://" URI(?) of mplayer to playback MPEG from
the ivtv or cx18 drivers; it shouldn't be necessary.

You may want to try a sequence like this to test things a step at a
time:

$ newgrp video
 
$ ./v4l2-ctl -d /dev/video0 -f 67.25
Frequency set to 1076 (67.250000 MHz)

$ cat /dev/video0 >test.mpg
^C

$ ls -al test.mpg
-rw-rw-r-- 1 andy andy 909312 2008-07-28 22:18 test.mpg

$ file test.mpg
test.mpg: MPEG sequence, v2, program multiplex

$ mplayer test.mpg -vo x11


Note, there is a known bug that the first analog capture (i.e.
cat /dev/video0 > test.mpg) will have no audio or very weird audio and
video.  Every subsequent capture should be fine.

Let me know what step above doesn't work.  If you have verbose logging
turned on in the driver, what were the log messages that were generated
by the first step that didn't work?


[snip]

> ############################
> 
> Using v4l2-ctl as root to force setting the tuner, standard, and a
> frequency doesn't improve mplayer's failure to recognize a tuner
> interface.  As regular user, no changes were applied.... ls
> -l /dev/video0 gets me crw-rw---- 1 root video 81, 0 2008-07-26
> 21:10 /dev/video0.  My user is in video.
> 
> I'll increase debugging on the kernel modules to see what I get and
> report back.  If any of the information provided assists resolving the
> situation, let me know.
> 
> Michael
> 
> lspci -v gives me the following output.
> 
> ##############################
> 00:00.0 Host bridge: Intel Corporation 82830 830 Chipset Host Bridge (rev 04)
> 	Subsystem: IBM Device 021d
> 	Flags: bus master, fast devsel, latency 0
> 	Memory at d0000000 (32-bit, prefetchable) [size=256M]
> 	Capabilities: [40] Vendor Specific Information <?>
> 	Capabilities: [a0] AGP version 2.0
> 	Kernel driver in use: agpgart-intel
> 	Kernel modules: intel-agp
> 
> 00:01.0 PCI bridge: Intel Corporation 82830 830 Chipset AGP Bridge (rev 04)
> 	Flags: bus master, 66MHz, fast devsel, latency 96
> 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
> 	Memory behind bridge: c0100000-c01fffff
> 	Prefetchable memory behind bridge: e0000000-ebffffff
> 	Kernel modules: shpchp
> 
> 00:1d.0 USB Controller: Intel Corporation 82801CA/CAM USB Controller #1 (rev 02)
> 	Subsystem: IBM Device 0220
> 	Flags: bus master, medium devsel, latency 0, IRQ 11
> 	I/O ports at 1800 [size=32]
> 	Kernel driver in use: uhci_hcd
> 	Kernel modules: uhci-hcd
> 
> 00:1d.1 USB Controller: Intel Corporation 82801CA/CAM USB Controller #2 (rev 02)
> 	Subsystem: IBM Device 0220
> 	Flags: bus master, medium devsel, latency 0, IRQ 11
> 	I/O ports at 1820 [size=32]
> 	Kernel driver in use: uhci_hcd
> 	Kernel modules: uhci-hcd
> 
> 00:1d.2 USB Controller: Intel Corporation 82801CA/CAM USB Controller #3 (rev 02)
> 	Subsystem: IBM Device 0220
> 	Flags: bus master, medium devsel, latency 0, IRQ 11
> 	I/O ports at 1840 [size=32]
> 	Kernel driver in use: uhci_hcd
> 	Kernel modules: uhci-hcd
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 42)
> 	Flags: bus master, fast devsel, latency 0
> 	Bus: primary=00, secondary=02, subordinate=08, sec-latency=64
> 	I/O behind bridge: 00002000-00006fff
> 	Memory behind bridge: c0200000-cfffffff
> 	Prefetchable memory behind bridge: f0000000-f7ffffff
> 	Kernel modules: shpchp
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801CAM ISA Bridge (LPC) (rev 02)
> 	Flags: bus master, medium devsel, latency 0
> 	Kernel modules: intel-rng, iTCO_wdt
> 
> 00:1f.1 IDE interface: Intel Corporation 82801CAM IDE U100 Controller (rev 02) (prog-if 8a [Master SecP PriP])
> 	Subsystem: IBM Device 0220
> 	Flags: bus master, medium devsel, latency 0, IRQ 11
> 	I/O ports at 01f0 [size=8]
> 	I/O ports at 03f4 [size=1]
> 	I/O ports at 0170 [size=8]
> 	I/O ports at 0374 [size=1]
> 	I/O ports at 1860 [size=16]
> 	Memory at 30000000 (32-bit, non-prefetchable) [size=1K]
> 	Kernel driver in use: PIIX_IDE
> 	Kernel modules: piix
> 
> 00:1f.3 SMBus: Intel Corporation 82801CA/CAM SMBus Controller (rev 02)
> 	Subsystem: IBM Device 0220
> 	Flags: medium devsel, IRQ 11
> 	I/O ports at 1880 [size=32]
> 	Kernel driver in use: i801_smbus
> 	Kernel modules: i2c-i801
> 
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801CA/CAM AC'97 Audio Controller (rev 02)
> 	Subsystem: IBM Device 0222
> 	Flags: bus master, medium devsel, latency 0, IRQ 11
> 	I/O ports at 1c00 [size=256]
> 	I/O ports at 18c0 [size=64]
> 	Kernel driver in use: Intel ICH
> 	Kernel modules: snd-intel8x0
> 
> 01:00.0 VGA compatible controller: S3 Inc. SuperSavage IX/C SDR (rev 05)
> 	Subsystem: IBM Device 01fc
> 	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
> 	Memory at c0100000 (32-bit, non-prefetchable) [size=512K]
> 	Memory at e8000000 (32-bit, prefetchable) [size=64M]
> 	Memory at e4000000 (32-bit, prefetchable) [size=64M]
> 	Memory at e0000000 (32-bit, prefetchable) [size=32M]
> 	[virtual] Expansion ROM at e2000000 [disabled] [size=64K]
> 	Capabilities: [dc] Power Management version 2
> 	Capabilities: [80] AGP version 2.0
> 	Kernel modules: savagefb
> 
> 02:00.0 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
> 	Subsystem: IBM Device 023b
> 	Flags: bus master, medium devsel, latency 168, IRQ 11

Latency 168 is a relatively generous timeslice of the PCI bus.  If this
controller is ever busy while you are doing a video capture, you may
notice some jitter.

> 	Memory at 50000000 (32-bit, non-prefetchable) [size=4K]
> 	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
> 	Memory window 0: f0000000-f3fff000 (prefetchable)
> 	Memory window 1: c4000000-c7fff000
> 	I/O window 0: 00002000-000020ff
> 	I/O window 1: 00002400-000024ff
> 	16-bit legacy interface ports at 0001
> 	Kernel driver in use: yenta_cardbus
> 	Kernel modules: yenta_socket
> 
> 02:00.1 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
> 	Subsystem: IBM Device 023b
> 	Flags: bus master, medium devsel, latency 168, IRQ 11
Same as previous comment.

> 	Memory at 51000000 (32-bit, non-prefetchable) [size=4K]
> 	Bus: primary=02, secondary=07, subordinate=07, sec-latency=176
> 	Memory window 0: f4000000-f7fff000 (prefetchable)
> 	Memory window 1: c8000000-cbfff000
> 	I/O window 0: 00002800-000028ff
> 	I/O window 1: 00002c00-00002cff
> 	16-bit legacy interface ports at 0001
> 	Kernel driver in use: yenta_cardbus
> 	Kernel modules: yenta_socket
> 
> 02:02.0 Communication controller: Agere Systems WinModem 56k (rev 01)
> 	Subsystem: AMBIT Microsystem Corp. Device 0410
> 	Flags: bus master, medium devsel, latency 0, IRQ 11
> 	Memory at c0201000 (32-bit, non-prefetchable) [size=256]
> 	I/O ports at 6440 [size=8]
> 	I/O ports at 6000 [size=256]
> 	Capabilities: [f8] Power Management version 2
> 
> 02:08.0 Ethernet controller: Intel Corporation 82801CAM (ICH3) PRO/100 VE (LOM) Ethernet Controller (rev 42)
> 	Subsystem: IBM Device 0209
> 	Flags: bus master, medium devsel, latency 66, IRQ 11
> 	Memory at c0200000 (32-bit, non-prefetchable) [size=4K]
> 	I/O ports at 6400 [size=64]
> 	Capabilities: [dc] Power Management version 2
> 	Kernel driver in use: e100
> 	Kernel modules: eepro100, e100
> ##########################################

Hmmm.  I don't see the HVR-1600 in the list, but I assume it's behind
the bridge at 00:1e.0 which is an Intel 82801 bridge device.  I know the
stand alone 82801 is for sure PCI v2.2 (The CX23418 is a PCI v2.3
device); I'll have to check on the 82830 chipset.

I have a hypothesis that the CX23418 doesn't work well in a PCI v2.2 or
older PCI bus (under linux at least), but I'm still collecting data to
verify or refute that.  I think this may be why many users get the
dreaded -121 on trying to access the EEPROM over the I2C bus.  The -121
error may be just a symptom of a broader problem of communicating with
the CX23418 over the PCI bus.

That fact that you found a method reliably get the EEPROM recognized is
unusual.  Normally users with the problem only get the EERPOM recognized
once in a great number of attempts.  When you try to start a capture, do
you get firmware load messages in dmesg or /var/log/messages as well?


> v4l2-ctl status incantation returns
> 
>    [84674.257981] cx18-0: =================  START STATUS CARD #0  =================
>    [84674.426935] tveeprom 2-0050: Hauppauge model 74041, rev C5B2, serial# 2914795 
>    [84674.426968] tveeprom 2-0050: MAC address is 00-0D-FE-2C-79-EB                 
>    [84674.427028] tveeprom 2-0050: tuner model is TCL M2523_5N_E (idx 112, type 50) 
>    [84674.427060] tveeprom 2-0050: TV standards NTSC(M) (eeprom 0x08)               
>    [84674.427091] tveeprom 2-0050: audio processor is CX23418 (idx 38)              
>    [84674.427122] tveeprom 2-0050: decoder processor is CX23418 (idx 31)            
>    [84674.427154] tveeprom 2-0050: has no radio, has IR receiver, has IR transmitter
>    [84674.427216] cx18-0: Video signal:              not present                    

No video signal detected from the analog tuner would explain no video,
but usually you will still see MPEG encoded static on a mostly black
screen.

>    [84674.427248] cx18-0: Detected format:           NTSC-M                         
>    [84674.427279] cx18-0: Specified standard:        NTSC-M                         
>    [84674.427282] cx18-0: Specified video input:     Composite 7                    
>    [84674.427312] cx18-0: Specified audioclock freq: 48000 Hz                       
>    [84674.427407] cx18-0: Detected audio mode:       stereo                         
>    [84674.427438] cx18-0: Detected audio standard:   BTSC                           
>    [84674.427469] cx18-0: Audio muted:               no                             
>    [84674.427472] cx18-0: Audio microcontroller:     running                        
>    [84674.427503] cx18-0: Configured audio standard: automatic detection            
>    [84674.427534] cx18-0: Configured audio system:   BTSC                           
>    [84674.427565] cx18-0: Specified audio input:     Tuner (In8)
>    [84674.427596] cx18-0: Preferred audio mode:      stereo
>    [84674.438182] cs5345 2-004c: Input:  1
>    [84674.438213] cs5345 2-004c: Volume: 0 dB
>    [84674.438274] tuner 3-0061: Tuner mode:      analog TV
>    [84674.438306] tuner 3-0061: Frequency:       55.25 MHz

That's not channel 4 that you tried to set with mplayer.

>    [84674.438337] tuner 3-0061: Standard:        0x0000b000
>    [84674.438369] cx18-0: Video Input: Tuner 1
>    [84674.438371] cx18-0: Audio Input: Tuner 1
>    [84674.438402] cx18-0: GPIO:  direction 0x00003001, value 0x00003001
>    [84674.438432] cx18-0: Tuner: TV
>    [84674.438463] cx18-0: Stream: MPEG-2 Program Stream
>    [84674.438494] cx18-0: VBI Format: No VBI
>    [84674.438497] cx18-0: Video:  720x480, 30 fps
>    [84674.438528] cx18-0: Video:  MPEG-2, 16x9, Variable Bitrate, 4500000, Peak 6000000
>    [84674.438589] cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
>    [84674.438621] cx18-0: Audio:  48 kHz, Layer II, 384 kbps, Stereo, No Emphasis, No CRC
>    [84674.438654] cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
>    [84674.438685] cx18-0: Temporal Filter: Manual, 8
>    [84674.438716] cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
>    [84674.438747] cx18-0: Status flags: 0x00200001
>    [84674.438778] cx18-0: Stream encoder MPEG: status 0x0000, 0% of 2016 KiB (63 buffers) in use
>    [84674.438810] cx18-0: Stream encoder YUV: status 0x0000, 0% of 2048 KiB (16 buffers) in use
>    [84674.438842] cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1008 KiB (63 buffers) in use
>    [84674.438873] cx18-0: Read MPEG/VBI: 13756416/0 bytes

The driver apparently thinks something was read from the MPEG encoder.
It has logged 13.7 million bytes read.

>    [84674.438904] cx18-0: ==================  END STATUS CARD #0  ==================

Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

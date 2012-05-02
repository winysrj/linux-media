Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49064 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2EBExI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 00:53:08 -0400
Received: by ghrr11 with SMTP id r11so248982ghr.19
        for <linux-media@vger.kernel.org>; Tue, 01 May 2012 21:53:07 -0700 (PDT)
Message-ID: <4FA0BDB0.50106@gmail.com>
Date: Wed, 02 May 2012 00:53:04 -0400
From: Bob Lightfoot <boblfoot@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppage HVR1600 - CX18 Issue with Centos 6.2 - Analog Sound comes
 and goes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mailing List linux-media:

	I am attempting to use a Hauppage HVR-1600 purchased new in 2010 as an
analog tv tuner in my HP Pavillion Elite M9040n PC running Centos 6.2
x86_64.  The problem I am experiencing is that with every kernel update
and/or mythtv and/or vlc or other media update it seems I loose sound on
my captured avi/mpeg files.  After as bit of tweaking it seems to come
back and I've never been able to pin down exactly what is hosing the
sound.  I should mention the unit has an HVR 1850 at slot 2 which works
for DVB tuning jsut fine.  The HVR 1600 is in pci slot 1 and from what I
can see in dmesg it also loaded fine.  Maybe someone who is more
intimate with linux-media can review the data I've included and suggest
a troubleshooting approach.  I am beginning to suspect I need to specify
a conf file for module cx18 but not sure where to begin that.  I am
trying to maintain the package management on this system so I have not
isntalled sources or compiled anything, everything has been managed by
yum and pulled from the centos-base, centos-updates or atrpms repos for
99% of things.  There may be an elrepo or rpmfusion rpm or two, but they
would be an exception.  Below I am providing what I think is the
relevant starter information.


uname -a ==> Linux mythbox.ladodomain 2.6.32-220.13.1.el6.x86_64 #1 SMP
Tue Apr 17 23:56:34 BST 2012 x86_64 x86_64 x86_64 GNU/Linux

lspci output follows:

00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
Controller (rev 02)
00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI
Express Root Port (rev 02)
00:19.0 Ethernet controller: Intel Corporation 82566DC-2 Gigabit Network
Connection (rev 02)
00:1a.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #4 (rev 02)
00:1a.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #5 (rev 02)
00:1a.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 2 (rev 02)
00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #1 (rev 02)
00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #2 (rev 02)
00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #3 (rev 02)
00:1d.3 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #6 (rev 02)
00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 4
port SATA Controller [IDE mode] (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller
(rev 02)
00:1f.5 IDE interface: Intel Corporation 82801I (ICH9 Family) 2 port
SATA Controller [IDE mode] (rev 02)
01:00.0 Multimedia video controller: Conexant Systems, Inc. CX23418
Single-Chip MPEG-2 Encoder with Integrated Analog Video/Broadcast Audio
Decoder
01:05.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 70)
02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8
PCIe Broadcast Audio and Video Decoder with 3D Comb (rev 0f)
04:00.0 VGA compatible controller: nVidia Corporation G98 [GeForce 8400
GS] (rev a1)

Output from dmesg | grep -A 3 -B 3 cx18 --> follows below:
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
lo: Disabled Privacy Extensions
SELinux: initialized (dev proc, type proc), uses genfs_contexts
cx18:  Start initialization, version 1.5.1
cx18-0: Initializing card 0
cx18-0: Autodetected Hauppauge card
cx18 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
cx18-0: cx23418 revision 01010000 (B)
tveeprom 4-0050: Hauppauge model 74041, rev C6B2, serial# 5267091
tveeprom 4-0050: MAC address is 00:0d:fe:50:5e:93
tveeprom 4-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
--
tveeprom 4-0050: audio processor is CX23418 (idx 38)
tveeprom 4-0050: decoder processor is CX23418 (idx 31)
tveeprom 4-0050: has no radio, has IR receiver, has IR transmitter
cx18-0: Autodetected Hauppauge HVR-1600
cx18-0: Simultaneous Digital and Analog TV capture supported
IRQ 17/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
tuner 5-0061: Tuner -1 found with type(s) Radio TV.
cs5345 4-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
tuner-simple 5-0061: creating new instance
tuner-simple 5-0061: type set to 50 (TCL 2002N)
cx18-0: Registered device video2 for encoder MPEG (64 x 32.00 kB)
DVB: registering new adapter (cx18)
cx18 0000:01:00.0: firmware: requesting v4l-cx23418-cpu.fw
MXL5005S: Attached at address 0x63
DVB: registering adapter 1 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx18-0: DVB Frontend registered
cx18-0: Registered DVB adapter1 for TS (32 x 32.00 kB)
cx18-0: Registered device video34 for encoder YUV (20 x 101.25 kB)
cx18-0: Registered device vbi2 for encoder VBI (20 x 51984 bytes)
cx18-0: Registered device video26 for encoder PCM audio (256 x 4.00 kB)
cx18-0: Initialized card: Hauppauge HVR-1600
cx18:  End initialization
cx18-alsa: module loading...
cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
cx18 0000:01:00.0: firmware: requesting v4l-cx23418-apu.fw
cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
cx18 0000:01:00.0: firmware: requesting v4l-cx23418-cpu.fw
cx18 0000:01:00.0: firmware: requesting v4l-cx23418-apu.fw
cx18 0000:01:00.0: firmware: requesting v4l-cx23418-dig.fw
cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
cx18-0 843: verified load of v4l-cx23418-dig.fw firmware (16382 bytes)
readahead-collector: starting delayed service auditd
readahead-collector: sorting
readahead-collector: finished
--
hda-intel: Invalid position buffer, using LPIB read method instead.
hda-intel: IRQ timing workaround is activated for card #0. Suggest a
bigger bdl_pos_adj.
fuse init (API version 7.13)
cx18-0: ignoring gop_end: not (yet?) supported by the firmware
cx18-0: ignoring gop_end: not (yet?) supported by the firmware
cx18-0: Could not find MDL 1 for stream encoder MPEG
cx18-0: Skipped encoder MPEG, MDL 0, 32 times - it must have dropped out
of rotation
cx18-0: Skipped encoder VBI, MDL 130, 9 times - it must have dropped out
of rotation
cx18-0: Could not find MDL 130 for stream encoder VBI
usb 2-4.2: reset high speed USB device using ehci_hcd and address 6
cx18-0: Could not find MDL 75 for stream TS
cx18-0: Skipped encoder VBI, MDL 120, 19 times - it must have dropped
out of rotation
cx18-0: ignoring gop_end: not (yet?) supported by the firmware
cx18-0: Skipped encoder MPEG, MDL 44, 5 times - it must have dropped out
of rotation
cx18-0: Skipped TS, MDL 75, 31 times - it must have dropped out of rotation
usb 2-4.2: reset high speed USB device using ehci_hcd and address 6
usb 2-4.2: reset high speed USB device using ehci_hcd and address 6
usb 2-4.2: reset high speed USB device using ehci_hcd and address 6


At present I do not have an /etc/modprobe.conf file or and
/etc/modprobe.d/cx18.conf or any /etc/modprobe.d/*.conf which mentions cx18.

I also checked the /etc/sysconfig/modules folder and found nothing
relevent to the cx18 modules.

Checking the current NOT WORKING config with v4l2-ctl I get the following:
[bob@mythbox ~]$ v4l2-ctl -d 2 --all
Driver Info (not using libv4l2):
	Driver name   : cx18
	Card type     : Hauppauge HVR-1600
	Bus info      : PCI:0000:01:00.0
	Driver version: 3.2.0
	Capabilities  : 0x01030051
		Video Capture
		VBI Capture
		Sliced VBI Capture
		Tuner
		Audio
		Read/Write
Format Video Capture:
	Width/Height  : 720/480
	Pixel Format  : 'MPEG'
	Field         : Interlaced
	Bytes per Line: 0
	Size Image    : 131072
	Colorspace    : Broadcast NTSC/PAL (SMPTE170M/ITU601)
Format Sliced VBI Capture:
	Service Set    : cc
	Service Line  0:          /
	Service Line  1:          /
	Service Line  2:          /
	Service Line  3:          /
	Service Line  4:          /
	Service Line  5:          /
	Service Line  6:          /
	Service Line  7:          /
	Service Line  8:          /
	Service Line  9:          /
	Service Line 10:       cc / cc
	Service Line 11:       cc / cc
	Service Line 12:       cc / cc
	Service Line 13:       cc / cc
	Service Line 14:       cc / cc
	Service Line 15:       cc / cc
	Service Line 16:       cc / cc
	Service Line 17:       cc / cc
	Service Line 18:       cc / cc
	Service Line 19:       cc / cc
	Service Line 20:       cc / cc
	Service Line 21:       cc / cc
	Service Line 22:          /
	Service Line 23:          /
	I/O Size       : 2304
Format VBI Capture:
	Sampling Rate   : 27000000 Hz
	Offset          : 248 samples (9.18519e-06 secs after leading edge)
	Samples per Line: 1440
	Sample Format   : GREY
	Start 1st Field : 10
	Count 1st Field : 12
	Start 2nd Field : 273
	Count 2nd Field : 12
Crop Capability Video Capture:
	Bounds      : Left 0, Top 0, Width 720, Height 480
	Default     : Left 0, Top 0, Width 720, Height 480
	Pixel Aspect: 10/11
Video input : 0 (Tuner 1: ok)
Audio input : 0 (Tuner 1)
Frequency: 1076 (67.250000 MHz)
Video Standard = 0x0000b000
	NTSC-M/M-JP/M-KR
Streaming Parameters Video Capture:
	Frames per second: 29.970 (30000/1001)
	Read buffers     : 0
Tuner:
	Name                 : cx18 TV Tuner
	Capabilities         : 62.5 kHz multi-standard stereo lang1 lang2
	Frequency range      : 44.0 MHz - 958.0 MHz
	Signal strength/AFC  : 100%/0
	Current audio mode   : lang1
	Available subchannels: mono
Priority: 2


I'll end here and hope for someone to have an idea as I've about
exhausted my brain on this.

Sincerely,
Bob Lightfoot

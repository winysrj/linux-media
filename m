Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56354 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756946Ab2ECXjF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 19:39:05 -0400
Subject: Re: Hauppage HVR1600 - CX18 Issue with Centos 6.2 - Analog Sound
 comes and goes
From: Andy Walls <awalls@md.metrocast.net>
To: Bob Lightfoot <boblfoot@gmail.com>
Cc: linux-media@vger.kernel.org, Mark Lord <kernel@teksavvy.com>
Date: Thu, 03 May 2012 19:38:50 -0400
In-Reply-To: <4FA0BDB0.50106@gmail.com>
References: <4FA0BDB0.50106@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1336088335.2496.33.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-05-02 at 00:53 -0400, Bob Lightfoot wrote:
> Dear Mailing List linux-media:
> 
> 	I am attempting to use a Hauppage HVR-1600 purchased new in 2010 as an
> analog tv tuner in my HP Pavillion Elite M9040n PC running Centos 6.2
> x86_64.  The problem I am experiencing is that with every kernel update
> and/or mythtv and/or vlc or other media update it seems I loose sound on
> my captured avi/mpeg files.  After as bit of tweaking it seems to come
> back and I've never been able to pin down exactly what is hosing the
> sound.  I should mention the unit has an HVR 1850 at slot 2 which works
> for DVB tuning jsut fine.  The HVR 1600 is in pci slot 1 and from what I
> can see in dmesg it also loaded fine.  Maybe someone who is more
> intimate with linux-media can review the data I've included and suggest
> a troubleshooting approach. 

1. If you ever lose sound in the ATSC or QAM DTV streams captured with
the HVR-1600, then you do not have and HVR-1600 problem, you have a
systems sound playback problem.  In this case you must address that
problem.

If not, then go on to #2.

2. If you never lose sound in ATSC/QAM DTV captures, but do sometimes
lose sound with MPEG captures from the analog baseband CVBS or S-Video
w/ L and R audio inputs, then this is a driver problem with the
CX23418's audio processing unit (APU).

In this case there is are a few things to try:

a. prevent the cx18-alsa.ko module from loading by removing it from your
filesystem (make a back-up of the module if you wish), and reboot your
computer.  This will stop things like HAL and/or PulseAudio from messing
with the HVR-1600 via the ALSA sound interface.

b. Update to the laters cx18 driver, which will require updating many
supporting media (video, dvb and common/tuner modules as well.  (No
guarantee this will work right on older enterprise kernels where the I2C
binding model is very different from modern kernels.)

c. Write a patch to the cx18 driver that has it act a little smarter
about the CX23418 Capture Processing Unit (CPU) and Audio Processing
Unit (APU) initialzation.  Right now the processors are brought out of
reset and allowed to run executing uninitialized memory as instructions
before their firmware is actually loaded and the processors restarted.

d. Ask me to write the patch mentioned in c.  Be prepared to wait a very
long time and still have to update to the latest cx18 module.


If you never lose audip in MPEG captures from baseband inputs, then go
to step 3.

3. If you never lose sound in ATSC/QAM DTV captures, and never lose
sound with MPEG captures from the analog baseband CVBS or S-Video w/ L
and R audio inputs, but you do sometimes lose audio with MPEG captures
from the analog RF tuner, then the broadcast audio microcontroller in
the integrated CX25843 inside the CX23418 is likely unable to identify
the broadcast audio standard properly and is staying muted.

If so, then

a. Use 'v4l2-ctl -d /dev/videoN --log-status' to verify the audio
standard is not detected and the microcontroller is muted when an analog
RF capture is ongoing.

b. Try installing an in-line attenuator in the RF line before it reaches
the analog RF tuner input of the HVR-1600.  The audio microcontroller
uses spectral analysis hardware to detect the broadcast audio standard.
Intermodulation products, caused by overdriving the tuner with too
strong of a signal, can throw off the spectral analysis and confuse the
audio standard detection microcontroller.

c. Ask Mark Lord for a copy of his script/tool mentioned in this long
thread:
http://patchwork.linuxtv.org/patch/3162/
That periodically does some userspace actions to try and get audio back.

d. Write a patch to the cx18 driver and the cx18-av-*c files
specifically, that allows manual specification of audio standard to BTSC
without any attaempts at auto-detection.

e. Ask me to write the patch in d.  Be prepared to wait a long time,
etc. etc.

f. See 2.c.

g. See 2.d.



>  I am beginning to suspect I need to specify
> a conf file for module cx18 but not sure where to begin that.  I am
> trying to maintain the package management on this system so I have not
> isntalled sources or compiled anything, everything has been managed by
> yum and pulled from the centos-base, centos-updates or atrpms repos for
> 99% of things.  There may be an elrepo or rpmfusion rpm or two, but they
> would be an exception.  Below I am providing what I think is the
> relevant starter information.
> 
> 
> uname -a ==> Linux mythbox.ladodomain 2.6.32-220.13.1.el6.x86_64 #1 SMP
> Tue Apr 17 23:56:34 BST 2012 x86_64 x86_64 x86_64 GNU/Linux
> 
> lspci output follows:
> 
> 00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
> Controller (rev 02)
> 00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI
> Express Root Port (rev 02)
> 00:19.0 Ethernet controller: Intel Corporation 82566DC-2 Gigabit Network
> Connection (rev 02)
> 00:1a.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #4 (rev 02)
> 00:1a.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #5 (rev 02)
> 00:1a.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
> Controller #2 (rev 02)
> 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
> Controller (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
> Port 1 (rev 02)
> 00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
> Port 2 (rev 02)
> 00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #1 (rev 02)
> 00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #2 (rev 02)
> 00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #3 (rev 02)
> 00:1d.3 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #6 (rev 02)
> 00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
> Controller #1 (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
> 00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface
> Controller (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 4
> port SATA Controller [IDE mode] (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller
> (rev 02)
> 00:1f.5 IDE interface: Intel Corporation 82801I (ICH9 Family) 2 port
> SATA Controller [IDE mode] (rev 02)
> 01:00.0 Multimedia video controller: Conexant Systems, Inc. CX23418
> Single-Chip MPEG-2 Encoder with Integrated Analog Video/Broadcast Audio
> Decoder
> 01:05.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 70)
> 02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8
> PCIe Broadcast Audio and Video Decoder with 3D Comb (rev 0f)
> 04:00.0 VGA compatible controller: nVidia Corporation G98 [GeForce 8400
> GS] (rev a1)
> 
> Output from dmesg | grep -A 3 -B 3 cx18 --> follows below:
> SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> lo: Disabled Privacy Extensions
> SELinux: initialized (dev proc, type proc), uses genfs_contexts
> cx18:  Start initialization, version 1.5.1
> cx18-0: Initializing card 0
> cx18-0: Autodetected Hauppauge card
> cx18 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> cx18-0: cx23418 revision 01010000 (B)
> tveeprom 4-0050: Hauppauge model 74041, rev C6B2, serial# 5267091
> tveeprom 4-0050: MAC address is 00:0d:fe:50:5e:93
> tveeprom 4-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
> --
> tveeprom 4-0050: audio processor is CX23418 (idx 38)
> tveeprom 4-0050: decoder processor is CX23418 (idx 31)
> tveeprom 4-0050: has no radio, has IR receiver, has IR transmitter
> cx18-0: Autodetected Hauppauge HVR-1600
> cx18-0: Simultaneous Digital and Analog TV capture supported
> IRQ 17/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
> tuner 5-0061: Tuner -1 found with type(s) Radio TV.
> cs5345 4-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
> tuner-simple 5-0061: creating new instance
> tuner-simple 5-0061: type set to 50 (TCL 2002N)
> cx18-0: Registered device video2 for encoder MPEG (64 x 32.00 kB)
> DVB: registering new adapter (cx18)
> cx18 0000:01:00.0: firmware: requesting v4l-cx23418-cpu.fw
> MXL5005S: Attached at address 0x63
> DVB: registering adapter 1 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
> cx18-0: DVB Frontend registered
> cx18-0: Registered DVB adapter1 for TS (32 x 32.00 kB)
> cx18-0: Registered device video34 for encoder YUV (20 x 101.25 kB)
> cx18-0: Registered device vbi2 for encoder VBI (20 x 51984 bytes)
> cx18-0: Registered device video26 for encoder PCM audio (256 x 4.00 kB)
> cx18-0: Initialized card: Hauppauge HVR-1600
> cx18:  End initialization
> cx18-alsa: module loading...
> cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
> cx18 0000:01:00.0: firmware: requesting v4l-cx23418-apu.fw
> cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
> cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
> cx18 0000:01:00.0: firmware: requesting v4l-cx23418-cpu.fw
> cx18 0000:01:00.0: firmware: requesting v4l-cx23418-apu.fw
> cx18 0000:01:00.0: firmware: requesting v4l-cx23418-dig.fw
> cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
> cx18-0 843: verified load of v4l-cx23418-dig.fw firmware (16382 bytes)
> readahead-collector: starting delayed service auditd
> readahead-collector: sorting
> readahead-collector: finished
> --


> hda-intel: Invalid position buffer, using LPIB read method instead.
> hda-intel: IRQ timing workaround is activated for card #0. Suggest a
> bigger bdl_pos_adj.

That's your audio chipset driver blurting out that something isn't
right.  You should investigate that too.




> 
> I'll end here and hope for someone to have an idea as I've about
> exhausted my brain on this.

Hopefully I gave you enough to work with for a while.

Regards,
Andy

> Sincerely,
> Bob Lightfoot



Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:60451 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753431Ab2JMP2C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Oct 2012 11:28:02 -0400
Received: from [69.22.83.79] (helo=localhost.localdomain)
	by elasmtp-galgo.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <jonathan.625266@earthlink.net>)
	id 1TN3dB-0002N0-5R
	for linux-media@vger.kernel.org; Sat, 13 Oct 2012 11:28:01 -0400
Date: Sat, 13 Oct 2012 11:28:00 -0400
From: Jonathan <jonathan.625266@earthlink.net>
To: linux-media@vger.kernel.org
Subject: Re: HD-PVR fails consistently on Linux, works on Windows
Message-ID: <20121013112800.2d7a1a42@earthlink.net>
In-Reply-To: <5063BD18.4060309@austin.rr.com>
References: <5063BD18.4060309@austin.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Sep 2012 21:42:32 -0500
Keith Pyle <kpyle@austin.rr.com> wrote:

> I recently purchased a Hauppauge HD-PVR (the 1212 version, label on 
> bottom 49001LF, Rev F2).  I have consistent capture failures on Linux 
> where data from the device simply stops, generally within a few minutes 
> of starting a capture.  Yet, the device works flawlessly on Windows with 
> the same USB and component cables, same power supply, and same physical 
> position.  This suggests that the device itself has acceptable power, is 
> not overheating, etc.  I'll detail below the testing I've done thus far 
> and would appreciate any suggestions on how to further test or address 
> the problem.
> 
> The good news is that I have a highly reproducible failure on Linux, but 
> then that's the bad news too.
> 
> Thanks.
> 
> Keith
> 
> -- Linux tests --
> I started trying to use the HD-PVR directly with my MythTV backend. I 
> have subsequently switched all of my testing to simple direct captures 
> from the /dev/video? device using /bin/cat to eliminate as many 
> variables as possible.
> 
> I've done a large number of tests with combinations of the following:
> 
> OS: gentoo 3.4.7, gentoo 3.5.4
> HD-PVR firmware: 1.5.7.0 (0x15), 1.7.1.30059 (0x1e)
> Input resolution: fixed to 720p, fixed to 1080i, floating based on input
> USB ports: motherboard ports on Intel DP45SG, motherboard ports on MSI 
> X58 Pro-E, ports on SIIG USB PCIe card
> 
> Captures fail consistently.
> 
> I've verified that the HD-PVR is the only device on the USB bus and that 
> the bus shows as "Linux Foundation 2.0 root hub" in all tests. I've 
> increased the debug output level for the hdpvr driver to 6 
> (/sys/module/hdpvr/parameters/hdpvr_debug) and collected the following:
> 
> Sep 21 17:01:00 mythbe kernel: [535043.504450] usb 9-1: New USB device 
> found, idVendor=2040, idProduct=4903
> Sep 21 17:01:00 mythbe kernel: [535043.504453] usb 9-1: New USB device 
> strings: Mfr=1, Product=2, SerialNumber=3
> Sep 21 17:01:00 mythbe kernel: [535043.504456] usb 9-1: Product: 
> Hauppauge HD PVR
> Sep 21 17:01:00 mythbe kernel: [535043.504458] usb 9-1: Manufacturer: AMBA
> Sep 21 17:01:00 mythbe kernel: [535043.504459] usb 9-1: SerialNumber: 
> 00A6DD48
> Sep 21 17:01:00 mythbe kernel: [535043.504523] usb 9-1: ep 0x1 - 
> rounding interval to 32768 microframes, ep desc says 0 microframes
> Sep 21 17:01:00 mythbe kernel: [535043.504528] usb 9-1: ep 0x81 - 
> rounding interval to 32768 microframes, ep desc says 0 microframes
> Sep 21 17:01:01 mythbe kernel: [535043.703947] hdpvr 9-1:1.0: firmware 
> version 0x15 dated Jun 17 2010 09:26:53
> Sep 21 17:01:01 mythbe kernel: [535043.889144] IR keymap rc-hauppauge 
> not found
> Sep 21 17:01:01 mythbe kernel: [535043.889146] Registered IR keymap 
> rc-empty
> Sep 21 17:01:01 mythbe kernel: [535043.889190] input: i2c IR (HD-PVR) as 
> /devices/virtual/rc/rc5/input16
> Sep 21 17:01:01 mythbe kernel: [535043.889415] rc5: i2c IR (HD-PVR) as 
> /devices/virtual/rc/rc5
> Sep 21 17:01:01 mythbe kernel: [535043.889417] ir-kbd-i2c: i2c IR 
> (HD-PVR) detected at i2c-8/8-0071/ir0 [Hauppage HD PVR I2C]
> Sep 21 17:01:01 mythbe kernel: [535043.889518] hdpvr 9-1:1.0: device now 
> attached to video6
> Sep 21 17:01:01 mythbe kernel: [535043.889534] usbcore: registered new 
> interface driver hdpvr
> Sep 21 17:05:11 mythbe kernel: [535293.776318] hdpvr 9-1:1.0: video 
> signal: 1920x1080@30hz
> Sep 21 17:05:14 mythbe kernel: [535297.312589] hdpvr 9-1:1.0: encoder 
> start control request returned 0
> Sep 21 17:05:15 mythbe kernel: [535297.670830] hdpvr 9-1:1.0: config 
> call request for value 0x700 returned 1
> Sep 21 17:05:15 mythbe kernel: [535297.670833] hdpvr 9-1:1.0: streaming 
> started
> Sep 21 17:05:15 mythbe kernel: [535297.670839] hdpvr 9-1:1.0: 
> hdpvr_read:442 buffer stat: 64 free, 0 proc
> Sep 21 17:05:15 mythbe kernel: [535297.670882] hdpvr 9-1:1.0: 
> hdpvr_submit_buffers:209 buffer stat: 0 free, 64 proc
> Sep 21 17:05:15 mythbe kernel: [535297.709079] hdpvr 9-1:1.0: 
> hdpvr_read:502 buffer stat: 1 free, 63 proc
> Sep 21 17:05:15 mythbe kernel: [535297.709088] hdpvr 9-1:1.0: 
> hdpvr_submit_buffers:209 buffer stat: 0 free, 64 proc
> 
> (many repeats of the above two line sequence)
> 
> Sep 21 17:17:09 mythbe kernel: [536011.936858] hdpvr 9-1:1.0: 
> hdpvr_read:502 buffer stat: 1 free, 63 proc
> Sep 21 17:17:09 mythbe kernel: [536011.936866] hdpvr 9-1:1.0: 
> hdpvr_submit_buffers:209 buffer stat: 0 free, 64 proc
> Sep 21 17:17:36 mythbe kernel: [536038.853044] hdpvr 9-1:1.0: config 
> call request for value 0x800 returned -110
> Sep 21 17:17:36 mythbe kernel: [536038.853052] hdpvr 9-1:1.0: transmit 
> worker exited
> Sep 21 17:17:36 mythbe kernel: [536038.996035] hdpvr 9-1:1.0: used 0 
> urbs to empty device buffers
> 
> If I understand correctly, this is showing a ETIMEDOUT error.  When I've 
> looked at the cat with strace, it is always blocked on a read. So, it 
> seems like the HD-PVR just stops sending.
> 
> I also ran a USB capture with wireshark and see much the same thing.  
> While I haven't tried to decode the USB packets, the pattern is that the 
> HD-PVR sends, the host sends a message/ack, this pattern repeats, and 
> then nothing.  The majority of the failures occur in less than 15 minutes.
> 
> -- Windows tests --
> 
> I installed the Hauppauge software on a Windows 7 system and moved the 
> USB cable to the Windows system.  Nothing else was changed. I've run 
> many hours of successful captures.  I've checked each recording with 
> ffprobe and verified that each is the expected length (i.e., no data 
> drops at all).  The recordings are of good quality. This shows that the 
> HD-PVR is capable of working as expected and quite reliably.

It may be a coincidence  but I since I started using  irqbalance ( https://code.google.com/p/irqbalance/ ) my HD-PVR has been  completely stable.  Before that I was experiencing daily lockups. 

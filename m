Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s34.blu0.hotmail.com ([65.55.111.109]:10728 "EHLO
	blu0-omc2-s34.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760682Ab2CPJbk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 05:31:40 -0400
Message-ID: <BLU0-SMTP683E9C15A4921407384A82B15F0@phx.gbl>
Date: Fri, 16 Mar 2012 10:33:43 +0100
From: Daniele Rogora <dodoeg@hotmail.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Fwd: ADS InstantFM Music RDX-155-EF
References: <4F630866.9080306@hotmail.it>
In-Reply-To: <4F630866.9080306@hotmail.it>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,
I need your help. I can't get any sound from the device in the subject.

I'm actually on Gentoo 64bit, vanilla kernel 3.3.0-rc2 with usb-audio 
support and radio-si470x with usb support built-in. I'm using alsa 1.0.25.

When i plug the device I get the following dmesg:

[ 1704.922092] usb 6-1: new full-speed USB device number 3 using uhci_hcd
[ 1705.054408] usb 6-1: skipped 4 descriptors after interface
[ 1705.054415] usb 6-1: skipped 2 descriptors after interface
[ 1705.054420] usb 6-1: skipped 1 descriptor after endpoint
[ 1705.054425] usb 6-1: skipped 1 descriptor after interface
[ 1705.057396] usb 6-1: default language 0x0409
[ 1705.065250] usb 6-1: udev 3, busnum 6, minor = 642
[ 1705.065256] usb 6-1: New USB device found, idVendor=06e1, idProduct=a155
[ 1705.065261] usb 6-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[ 1705.065265] usb 6-1: Product: ADS InstantFM Music
[ 1705.065269] usb 6-1: Manufacturer: ADS TECH
[ 1705.065457] usb 6-1: usb_probe_device
[ 1705.065463] usb 6-1: configuration #1 chosen from 1 choice
[ 1705.067252] usb 6-1: adding 6-1:1.0 (config #1, interface 0)
[ 1705.067332] snd-usb-audio 6-1:1.0: usb_probe_interface
[ 1705.067340] snd-usb-audio 6-1:1.0: usb_probe_interface - got id
[ 1705.074898] usb 6-1: adding 6-1:1.1 (config #1, interface 1)
[ 1705.074950] usb 6-1: adding 6-1:1.2 (config #1, interface 2)
[ 1705.075028] radio-si470x 6-1:1.2: usb_probe_interface
[ 1705.075033] radio-si470x 6-1:1.2: usb_probe_interface - got id
[ 1705.076251] radio-si470x 6-1:1.2: DeviceID=0xffff ChipID=0xffff
[ 1705.077239] radio-si470x 6-1:1.2: software version 1, hardware version 7
[ 1705.077244] radio-si470x 6-1:1.2: This driver is known to work with 
software version 7,
[ 1705.077249] radio-si470x 6-1:1.2: but the device has software version 1.
[ 1705.077253] radio-si470x 6-1:1.2: If you have some trouble using this 
driver,
[ 1705.077257] radio-si470x 6-1:1.2: please report to V4L ML at 
linux-media@vger.kernel.org

lsusb
Bus 006 Device 003: ID 06e1:a155 ADS Technologies, Inc. FM Radio 
Receiver/Instant FM Music (RDX-155-EF).

Then I can see the new device /dev/radio0 and in alsamixer there is the 
new usb audio capture device.

The problem is that I can't get any audio from it. If I try to "cat 
/dev/dsp1 > /dev/dsp" I can hear some noise, but I can't tell if that is 
the normal noise of the fm signal or what else.

I also tried with the "radio" utility. It doesn't do anything whatever I 
try. Also it gives me these errors (popping out from the red background)
VIDIOCGAUDIO: Inappropriate ioctl for device │
VIDIOCSAUDIO: Inappropriate ioctl for device

If I try to "radio -c /dev/radio0 -i" to scan for available freqs, it 
just goes from 87.5 to 108.00 in a couple of seconds finding nothing.

I've tried also with a stock Ubuntu 11.10, with exactly the same 
results. Also the first time I plugged the device the software version 
was 0; then I tried it with Windows 7 (where it works), and it updated 
the software to version 1.

So, I'd like to get this device to work; please tell me if there is any 
informatio you need to figure out what's going on.

Thanks, Daniele


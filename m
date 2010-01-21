Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53704 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0AURdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 12:33:00 -0500
Received: by fxm20 with SMTP id 20so258086fxm.1
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 09:32:59 -0800 (PST)
Message-ID: <4B588FDE.3090203@googlemail.com>
Date: Thu, 21 Jan 2010 18:33:18 +0100
From: Hans-Peter Wolf <hapewolf@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Remote for Terratec Cinergy C PCI HD (DVB-C)
References: <4B578073.4030103@googlemail.com>
In-Reply-To: <4B578073.4030103@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I got it finally running! I just took the last s2-liplianin source and 
it was detected automatically:

I: Bus=0001 Vendor=0000 Product=0000 Version=0001
N: Name="Mantis VP-2040 IR Receiver"
P: Phys=pci-0000:01:06.0/ir0
S: Sysfs=/devices/virtual/input/input5
U: Uniq=
H: Handlers=kbd event5
B: EV=100003
B: KEY=108fc330 284204100000000 0 2000000018000 218040000801 
9e96c000000000 ffc

Strange, that it didn't work with v4l-dvb sources.

Thank you very much. I really appreciate your work!

Regards
Hans-Peter

Hans-Peter Wolf schrieb:
> Hi,
> 
> I installed the mantis driver from the v4l-dvb mercurial repository and 
> got my tv-card Terratec Cinergy C PCI HD running successfully.
> 
> However, I cannot find any information if the included remote, which 
> also directly connected to the PCI card, is also working. The dmesg 
> output gives me these lines at the startup (not comparable to the lines 
> listed on linuxtv.org):
> 
> [    7.402278] Mantis 0000:01:06.0: PCI INT A -> Link[LNKA] -> GSI 16 
> (level, low) -> IRQ 16
> [    7.403356] DVB: registering new adapter (Mantis DVB adapter)
> [    8.322027] DVB: registering adapter 0 frontend 0 (Philips TDA10023 
> DVB-C)...
> 
> (I also had to add the module 'mantis' to /etc/modules to run it 
> automatically at startup. Is this normal?)
> 
> I also tried cat /proc/bus/input/devices but couldn't find a plausible 
> device (output attached below).
> 
> Can anyone tell me how to find out if the device is properly installed? 
> Or better: How to install the remote device? Is there any special module 
> required?
> 
> Thank you very much in advance!
> Hans-Peter
> 
> cat /proc/bus/input/devices
> I: Bus=0019 Vendor=0000 Product=0001 Version=0000
> N: Name="Power Button"
> P: Phys=LNXPWRBN/button/input0
> S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> U: Uniq=
> H: Handlers=kbd event0
> B: EV=3
> B: KEY=10000000000000 0
> 
> I: Bus=0019 Vendor=0000 Product=0001 Version=0000
> N: Name="Power Button"
> P: Phys=PNP0C0C/button/input0
> S: Sysfs=/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> U: Uniq=
> H: Handlers=kbd event1
> B: EV=3
> B: KEY=10000000000000 0
> 
> I: Bus=0017 Vendor=0001 Product=0001 Version=0100
> N: Name="Macintosh mouse button emulation"
> P: Phys=
> S: Sysfs=/devices/virtual/input/input2
> U: Uniq=
> H: Handlers=mouse0 event2
> B: EV=7
> B: KEY=70000 0 0 0 0
> B: REL=3
> 
> I: Bus=0019 Vendor=0000 Product=0006 Version=0000
> N: Name="Video Bus"
> P: Phys=/video/input0
> S: 
> Sysfs=/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:12/device:13/input/input3 
> 
> U: Uniq=
> H: Handlers=kbd event3
> B: EV=3
> B: KEY=3f000b00000000 0 0 0
> 
> I: Bus=0003 Vendor=046d Product=c01f Version=0110
> N: Name="Logitech USB-PS/2 Optical Mouse"
> P: Phys=usb-0000:00:02.0-6/input0
> S: Sysfs=/devices/pci0000:00/0000:00:02.0/usb3/3-6/3-6:1.0/input/input4
> U: Uniq=
> H: Handlers=mouse1 event4
> B: EV=17
> B: KEY=f0000 0 0 0 0
> B: REL=103
> B: MSC=10
> 
> I: Bus=0003 Vendor=046a Product=0011 Version=0110
> N: Name="HID 046a:0011"
> P: Phys=usb-0000:00:04.0-6/input0
> S: Sysfs=/devices/pci0000:00/0000:00:04.0/usb4/4-6/4-6:1.0/input/input5
> U: Uniq=
> H: Handlers=kbd event5
> B: EV=120013
> B: KEY=1000000000007 ff800000000007ff febeffdff3cfffff fffffffffffffffe
> B: MSC=10
> B: LED=7
> 
> I: Bus=0001 Vendor=10ec Product=0888 Version=0001
> N: Name="HDA Digital PCBeep"
> P: Phys=card0/codec#0/beep0
> S: Sysfs=/devices/pci0000:00/0000:00:07.0/input/input6
> U: Uniq=
> H: Handlers=kbd event6
> B: EV=40001
> B: SND=6
> 

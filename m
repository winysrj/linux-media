Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab1LGOyc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 09:54:32 -0500
Message-ID: <4EDF7E23.3090904@redhat.com>
Date: Wed, 07 Dec 2011 12:54:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Fredrik Lingvall <fredrik.lingvall@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-930C problems
References: <4ED929E7.2050808@gmail.com> <4EDF6262.2000209@redhat.com> <4EDF6AB8.5050201@gmail.com> <4EDF7048.2030304@redhat.com> <4EDF7758.3080309@gmail.com>
In-Reply-To: <4EDF7758.3080309@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07-12-2011 12:25, Fredrik Lingvall wrote:
> On 12/07/11 14:55, Mauro Carvalho Chehab wrote:
>>
>>> <snip>
>>>
>>> Bus 2 doesn't seem to do anything [Alloc= 0/800 us ( 0%)] while I'm scanning!?
>>
>>
>> Scanning envolves 2 different things:
>> 1) tuning and locking into a channel;
>> 2) streaming and filtering, in order to seek for program tables
>> inside the MPEG-TS.
>>
>> Step 1 uses USB control messages.
>>
>> Only at step 2, the device will use the USB ISOC packets. The USB core will
>> see if is there enough bandwidth to reserve for ISOC transfers on that time
>> (based on other traffic data), and submit the URB's (or return -ENOSPC otherwise).
>>
>>>
>>> BTW: I'm running Gentoo x86_64 (amd64) on a Dell M2400 laptop with an SSD disk.
>>>
>>> Other hardware connected is a 200 GB disk using the eSata slot, a 1TB WD disk connected using another USB slot, a RME Multiface II soundcard using the expresscard slot.
>>
>> The external USB disk may be interfering, if it is also at bus 2.
>> Also, some laptops use USB for some internal components like wireless.
>>
>> Please remove all other USB devices, disable wireless (if your device is USB)
>> and try again.
>>
>> Regards,
>> Mauro
>
> No there's nothing else at Bus 2 (I did a umount on the WD usb disk, cannot unplug devices since I'm logged in remotely right now), and Wireless is a pci device:
>
> lin-tv ~ # lspci
> 00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
> 00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express Graphics Port (rev 07)
> 00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
> 00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
> 00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
> 00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
> 00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
> 00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
> 00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 (rev 03)
> 00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
> 00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
> 00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
> 00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
> 00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
> 00:1f.2 RAID bus controller: Intel Corporation Mobile 82801 SATA RAID Controller (rev 03)
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
> 01:00.0 VGA compatible controller: nVidia Corporation Device 06fb (rev a1)
> 03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04)
> 03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
> 03:01.2 SD Host controller: Ricoh Co Ltd R5C843 MMC Host Controller (rev 11)
> 0c:00.0 Network controller: Intel Corporation PRO/Wireless 5300 AGN [Shiloh] Network Connection
> 0e:00.0 Multimedia audio controller: Xilinx Corporation RME Hammerfall DSP (rev 3c)
>
> lin-tv ~ # lsusb
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 001 Device 003: ID 413c:2513 Dell Computer Corp. internal USB Hub of E-Port Replicator
> Bus 001 Device 005: ID 0c45:63f8 Microdia Sonix Integrated Webcam
> Bus 003 Device 002: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub (part of BCM2046 Bluetooth)
> Bus 005 Device 002: ID 0a5c:5800 Broadcom Corp. BCM5880 Secure Applications Processor
> Bus 006 Device 002: ID 0451:2036 Texas Instruments, Inc. TUSB2036 Hub
> Bus 003 Device 003: ID 413c:8157 Dell Computer Corp. Integrated Keyboard
> Bus 003 Device 004: ID 413c:8158 Dell Computer Corp. Integrated Touchpad / Trackstick
> Bus 006 Device 004: ID 046d:c704 Logitech, Inc. diNovo Wireless Desktop
> Bus 003 Device 005: ID 413c:8156 Dell Computer Corp. Wireless 370 Bluetooth Mini-card
> Bus 002 Device 008: ID 2040:1605 Hauppauge
>
> Devices at Bus 2:
>
> lin-tv ~ # lsusb | grep "Bus 002"
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 008: ID 2040:1605 Hauppauge

There's nothing at the DVB core returning -ENOSPC.

Try to add just one line to a channels file, like this one:
	C 602000000 6900000 NONE QAM256

(this is the transponder that failed with w_scan. You could also use one
of the transponders where you got a pid timeout with scan)

Then call scan with this file, using strace:

$ strace -e ioctl dvbscan channelfile

This would allow to see what ioctl returned -ENOSPC (error -28).

Regards,
Mauro


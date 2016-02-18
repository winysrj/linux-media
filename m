Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout-fallback.aon.at ([195.3.96.120]:38919 "EHLO
	smtpout-fallback.aon.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424543AbcBRFSa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 00:18:30 -0500
Received: from unknown (HELO smtpout.aon.at) ([172.18.1.199])
          (envelope-sender <klammerj@a1.net>)
          by fallback44.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-media@vger.kernel.org>; 18 Feb 2016 05:11:48 -0000
Message-ID: <56C55273.7040407@a1.net>
Date: Thu, 18 Feb 2016 06:11:15 +0100
From: Johann Klammer <klammerj@a1.net>
MIME-Version: 1.0
To: lorenz.giefing@physio-geidorf.at
CC: linux-media@vger.kernel.org
Subject: Re: Terratec CINERGY T/C Stick
References: <20160217201920.yq8h5szz5wogsso0@www.mail4me.at>
In-Reply-To: <20160217201920.yq8h5szz5wogsso0@www.mail4me.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/17/2016 08:19 PM, lorenz.giefing@physio-geidorf.at wrote:
> Hi!
> I bought such a stick to build a linux driven video recorder.
> But the stick istn't recognized by the kernel
> 
> uname -a
> Linux ESPRIMO 4.2.0-27-generic #32-Ubuntu SMP Fri Jan 22 04:49:08 UTC  
> 2016 x86_64 x86_64 x86_64 GNU/Linux
> 
> dmesg
> Feb 17 20:06:42 ESPRIMO kernel: [35572.460078] usb 2-3: new high-speed  
> USB device number 5 using ehci-pci
> Feb 17 20:06:42 ESPRIMO kernel: [35572.604226] usb 2-3: New USB device  
> found, idVendor=0ccd, idProduct=5103
> Feb 17 20:06:42 ESPRIMO kernel: [35572.604233] usb 2-3: New USB device  
> strings: Mfr=1, Product=2, SerialNumber=3
> Feb 17 20:06:42 ESPRIMO kernel: [35572.604237] usb 2-3: Product: RTL2841UHIDIR
> Feb 17 20:06:42 ESPRIMO kernel: [35572.604240] usb 2-3: Manufacturer: Realtek
> Feb 17 20:06:42 ESPRIMO kernel: [35572.604243] usb 2-3: SerialNumber: 00000140
> Feb 17 20:06:42 ESPRIMO mtp-probe: checking bus 2, device 5:  
> "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3"
> Feb 17 20:06:42 ESPRIMO mtp-probe: bus: 2, device: 5 was not an MTP device
> Feb 17 20:08:11 ESPRIMO colord-sane: io/hpmud/pp.c 627: unable to read  
> device-id ret=-1
> 
> lsusb
> Bus 002 Device 006: ID 0ccd:5103 TerraTec Electronic GmbH
> 
> I compiled the media_build successfully, but nothing changed.
> 
> I dind't find the ID anywhere in the net... ;-(
> 
> Any idea what to try next?
> Thanks!
> Lorenz
> 
> 
0x5103 is not in the list:
<https://github.com/torvalds/linux/blob/master/drivers/media/dvb-core/dvb-usb-ids.h>
It's likely not supported.
You can try to find a separate driver. 
You can try to figure out the chipset and load a driver if one already exists. 
You'll have to alter the drivers product id so the kernel will be able to use 
the driver with your device.  

You may want to watch this video:
<https://archive.fosdem.org/2014/schedule/event/making_the_linux_kernel_better/>

Or you throw that stick out the window....



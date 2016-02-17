Return-path: <linux-media-owner@vger.kernel.org>
Received: from cloudsmtp1.emerion.com ([37.235.0.34]:53906 "EHLO
	smtp.emerion.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030376AbcBQT0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 14:26:51 -0500
Received: from webmail.emerion.com (webmail.emerion.com [212.69.178.144])
	(Authenticated sender: lorenz.giefing.physio-geido487)
	by smtp1.emerion.com (Postfix) with ESMTPA id 6EE4B3A102
	for <linux-media@vger.kernel.org>; Wed, 17 Feb 2016 20:19:20 +0100 (CET)
Message-ID: <20160217201920.yq8h5szz5wogsso0@www.mail4me.at>
Date: Wed, 17 Feb 2016 20:19:20 +0100
From: lorenz.giefing@physio-geidorf.at
To: linux-media <linux-media@vger.kernel.org>
Subject: Terratec CINERGY T/C Stick
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!
I bought such a stick to build a linux driven video recorder.
But the stick istn't recognized by the kernel

uname -a
Linux ESPRIMO 4.2.0-27-generic #32-Ubuntu SMP Fri Jan 22 04:49:08 UTC  
2016 x86_64 x86_64 x86_64 GNU/Linux

dmesg
Feb 17 20:06:42 ESPRIMO kernel: [35572.460078] usb 2-3: new high-speed  
USB device number 5 using ehci-pci
Feb 17 20:06:42 ESPRIMO kernel: [35572.604226] usb 2-3: New USB device  
found, idVendor=0ccd, idProduct=5103
Feb 17 20:06:42 ESPRIMO kernel: [35572.604233] usb 2-3: New USB device  
strings: Mfr=1, Product=2, SerialNumber=3
Feb 17 20:06:42 ESPRIMO kernel: [35572.604237] usb 2-3: Product: RTL2841UHIDIR
Feb 17 20:06:42 ESPRIMO kernel: [35572.604240] usb 2-3: Manufacturer: Realtek
Feb 17 20:06:42 ESPRIMO kernel: [35572.604243] usb 2-3: SerialNumber: 00000140
Feb 17 20:06:42 ESPRIMO mtp-probe: checking bus 2, device 5:  
"/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3"
Feb 17 20:06:42 ESPRIMO mtp-probe: bus: 2, device: 5 was not an MTP device
Feb 17 20:08:11 ESPRIMO colord-sane: io/hpmud/pp.c 627: unable to read  
device-id ret=-1

lsusb
Bus 002 Device 006: ID 0ccd:5103 TerraTec Electronic GmbH

I compiled the media_build successfully, but nothing changed.

I dind't find the ID anywhere in the net... ;-(

Any idea what to try next?
Thanks!
Lorenz



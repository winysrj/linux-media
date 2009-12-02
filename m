Return-path: <linux-media-owner@vger.kernel.org>
Received: from m0-if0.velocitynet.com.au ([203.17.154.50]:47167 "EHLO
	m0.velocity.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753719AbZLBEPl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 23:15:41 -0500
Received: from [192.168.0.10] (110.143.46.202-static.velocitynet.com.au [202.46.143.110])
	by m0.velocity.net.au (Postfix) with ESMTP id 679116042A
	for <linux-media@vger.kernel.org>; Wed,  2 Dec 2009 15:15:44 +1100 (EST)
Message-ID: <4B15E9F0.3050701@wilsononline.id.au>
Date: Wed, 02 Dec 2009 15:15:44 +1100
From: Paul <mylists@wilsononline.id.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: dvb_usb_dib0700  ( T14BR) not initializing on reboot
References: <4B15C45F.7020909@wilsononline.id.au>
In-Reply-To: <4B15C45F.7020909@wilsononline.id.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/12/2009 12:35 PM, Paul wrote:
> I have a DVB-T USB device ( T14BR),
> which seems to work fine when I plug in my Fedora 10 box but I if I
> reboot with device connected it regularity fails to initialise correctly
> and to correct I have to remove unplug-device remove the module and
> reload module to fix up and only after system has been fully booted
> 
> eg
> modprobe -r dvb-usb-dib0700
> then
> modprobe dvb-usb-dib0700  adapter_nr=2
> and then plug device in.
> I get the following msgs when it seems to fail and the second set when
> it works
> 
> kernel log (failed)
> 
> Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using
> ohci_hcd and address 2
> Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using
> ohci_hcd and address 3
> Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using
> ohci_hcd and address 4
> Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using
> ohci_hcd and address 5
> Nov 22 13:51:50 mythbox kernel: usb 2-8: new low speed USB device using
> ohci_hcd and address 6
> Nov 22 13:51:50 mythbox kernel: usb 2-8: configuration #1 chosen from 1
> choice
> Nov 22 13:51:50 mythbox kernel: usb 2-8: New USB device found,
> idVendor=413c, idProduct=3010
> Nov 22 13:51:50 mythbox kernel: usb 2-8: New USB device strings: Mfr=0,
> Product=0, SerialNumber=0
> Nov 22 13:51:50 mythbox kernel: usbcore: registered new interface driver
> hiddev
> Nov 22 13:51:50 mythbox kernel: input: HID 413c:3010 as
> /devices/pci0000:00/0000:00:02.0/usb2/2-8/2-8:1.0/input/input4
> Nov 22 13:51:50 mythbox kernel: input,hidraw0: USB HID v1.00 Mouse [HID
> 413c:3010] on usb-0000:00:02.0-8
> Nov 22 13:51:50 mythbox kernel: usbcore: registered new interface driver
> usbhid
> Nov 22 13:51:50 mythbox kernel: usbhid: v2.6:USB HID core driver
> 
> 
> http://www.artectv.com/ehtm/products/t14.htm
> 
> kernel log (working)
> 
> Nov 29 09:58:20 mythbox kernel: usb 1-8: new high speed USB device using
> ehci_hcd and address 3
> Nov 29 09:58:20 mythbox kernel: usb 1-8: configuration #1 chosen from 1
> choice
> Nov 29 09:58:20 mythbox kernel: usb 1-8: New USB device found,
> idVendor=05d8, idProduct=810f
> Nov 29 09:58:20 mythbox kernel: usb 1-8: New USB device strings: Mfr=1,
> Product=2, SerialNumber=3
> Nov 29 09:58:20 mythbox kernel: usb 1-8: Product: ART7070
> Nov 29 09:58:20 mythbox kernel: usb 1-8: Manufacturer: Ultima
> Nov 29 09:58:20 mythbox kernel: usb 1-8: SerialNumber: 001
> Nov 29 09:58:20 mythbox kernel: dib0700: loaded with support for 7
> different device-types
> Nov 29 09:58:20 mythbox kernel: dvb-usb: found a 'Artec T14BR DVB-T' in
> cold state, will try to load a firmware
> Nov 29 09:58:20 mythbox kernel: firmware: requesting 
> dvb-usb-dib0700-1.10.fw
> Nov 29 09:58:20 mythbox kernel: dvb-usb: downloading firmware from file
> 'dvb-usb-dib0700-1.10.fw'
> Nov 29 09:58:22 mythbox kernel: dib0700: firmware started successfully.
> Nov 29 09:58:23 mythbox kernel: dvb-usb: found a 'Artec T14BR DVB-T' in
> warm state.
> Nov 29 09:58:23 mythbox kernel: dvb-usb: will pass the complete MPEG2
> transport stream to the software demuxer.
> Nov 29 09:58:23 mythbox kernel: DVB: registering new adapter (Artec
> T14BR DVB-T)
> Nov 29 09:58:23 mythbox kernel: DiB0070: successfully identified
> Nov 29 09:58:23 mythbox kernel: input: IR-receiver inside an USB DVB
> receiver as /devices/pci0000:00/0000:00:02.1/usb1/1
> -8/input/input7
> Nov 29 09:58:23 mythbox kernel: dvb-usb: schedule remote query interval
> to 150 msecs.
> Nov 29 09:58:23 mythbox kernel: dvb-usb: Artec T14BR DVB-T successfully
> initialized and connected.
> 
> 


Note I googled a few other people with the same issue:

http://www.linuxtv.org/pipermail/linux-dvb/2007-November/022145.html
http://ubuntuforums.org/archive/index.php/t-1233131.html

so I'm assuming its a known issue, right?

Paul

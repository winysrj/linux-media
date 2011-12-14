Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52649 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab1LNSkV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 13:40:21 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RatkZ-00031l-QV
	for linux-media@vger.kernel.org; Wed, 14 Dec 2011 19:40:19 +0100
Received: from 77-253-230-77.ip.netia.com.pl ([77.253.230.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2011 19:40:19 +0100
Received: from adexmail by 77-253-230-77.ip.netia.com.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2011 19:40:19 +0100
To: linux-media@vger.kernel.org
From: Adeq <adexmail@tlen.pl>
Subject: Re: [PATCH] it913x add support for IT9135 9006 devices
Date: Wed, 14 Dec 2011 06:13:42 +0000 (UTC)
Message-ID: <loom.20111214T071004-336@post.gmane.org>
References: <1323719580.2235.3.camel@tvbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Malcolm Priestley <tvboxspy <at> gmail.com> writes:

> 
> Support for IT1935 9006 devices.
> 
> 9006 have version 2 type chip.
> 
> 9006 devices should use dvb-usb-it9135-02.fw firmware.
> 
> On the device tested the tuner id was set to 0 which meant
> the driver used tuner id 0x38. The device functioned normally.
> 

Hello,

my device (048d:9006) isn't fully working, here is dmesg log:

[code]
[  281.724044] usb 1-3: new high-speed USB device number 10 using ehci_hcd
[  281.860585] usb 1-3: New USB device found, idVendor=048d, idProduct=9006
[  281.860594] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  281.860601] usb 1-3: Product: DVB-T TV Stick
[  281.860607] usb 1-3: Manufacturer: ITE Technologies, Inc.
[  281.861694] it913x: Chip Version=02 Chip Type=9135
[  281.863193] it913x: Dual mode=0 Remote=1 Tuner Type=0
[  281.864444] dvb-usb: found a 'ITE 9135(9006) Generic' in cold state, will try
to load a firmware
[  281.870053] dvb-usb: downloading firmware from file 'dvb-usb-it9135-02.fw'
[  281.870438] it913x: FRM Starting Firmware Download
[  282.388032] it913x: FRM Firmware Download Failed (ffffffff)
[  282.588116] it913x: Chip Version=79 Chip Type=4af3
[  283.224203] it913x: DEV it913x Error
[  283.227753] input: ITE Technologies, Inc. DVB-T TV Stick as
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3:1.1/input/input17
[  283.228415] generic-usb 0003:048D:9006.0007: input,hidraw0: USB HID v1.01
Keyboard [ITE Technologies, Inc. DVB-T TV Stick] on usb-0000:00:1d.7-3/input1

or

[  292.444049] usb 1-3: new high-speed USB device number 11 using ehci_hcd
[  292.580449] usb 1-3: New USB device found, idVendor=048d, idProduct=9006
[  292.580458] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  292.580465] usb 1-3: Product: DVB-T TV Stick
[  292.580471] usb 1-3: Manufacturer: ITE Technologies, Inc.
[  292.581557] it913x: Chip Version=02 Chip Type=9135
[  292.583051] it913x: Dual mode=0 Remote=1 Tuner Type=0
[  292.584284] dvb-usb: found a 'ITE 9135(9006) Generic' in cold state, will try
to load a firmware
[  292.589938] dvb-usb: downloading firmware from file 'dvb-usb-it9135-02.fw'
[  292.590302] it913x: FRM Starting Firmware Download
[  292.908023] it913x: FRM Firmware Download Completed - Resetting Device
[  292.908534] it913x: Chip Version=02 Chip Type=9135
[  292.909032] it913x: Firmware Version 52887808
[  293.144182] it913x: DEV it913x Error
[  293.147862] input: ITE Technologies, Inc. DVB-T TV Stick as
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3:1.1/input/input18
[  293.152345] generic-usb 0003:048D:9006.0008: input,hidraw0: USB HID v1.01
Keyboard [ITE Technologies, Inc. DVB-T TV Stick] on usb-0000:00:1d.7-3/input1
[/code]

I'm using this device: http://www.runteck.com/products_view.php?Id=24&S_Id=2




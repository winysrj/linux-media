Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.lightlink.com ([64.57.176.21]:39142 "EHLO
	vm0.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3FNNta (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 09:49:30 -0400
Received: from [172.16.10.72] (cpe-24-58-232-40.twcny.res.rr.com [24.58.232.40])
	by vm0.lightlink.com (Postfix) with ESMTP id 9EFC93F03CE
	for <linux-media@vger.kernel.org>; Fri, 14 Jun 2013 09:43:22 -0400 (EDT)
Message-ID: <51BB1DAF.2000801@lightlink.com>
Date: Fri, 14 Jun 2013 09:42:07 -0400
From: Bob McConnell <rmcconne@lightlink.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Ion Video 2 PC converter
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Has anyone here tried the Ion "Video 2 PC" converter? I picked one up 
from the clearance shelf at Staples yesterday, but don't see any way to 
use it on my Slackware workstations. I did plug it in and got the 
following data.

-----8< --------------------------------------------------
tail /var/log/messages
Jun 14 06:59:54 widedesk -- MARK --
Jun 14 07:04:53 widedesk kernel: [1104320.179041] usb 1-6: new 
high-speed USB device number 6 using ehci_hcd
Jun 14 07:04:54 widedesk kernel: [1104320.300452] usb 1-6: New USB 
device found, idVendor=eb1a, idProduct=5051
Jun 14 07:04:54 widedesk kernel: [1104320.300462] usb 1-6: New USB 
device strings: Mfr=3, Product=1, SerialNumber=2
Jun 14 07:04:54 widedesk kernel: [1104320.300468] usb 1-6: Product: ION 
Audio USB 2861 Device
Jun 14 07:04:54 widedesk kernel: [1104320.300474] usb 1-6: Manufacturer: 
ION Audio
Jun 14 07:04:54 widedesk kernel: [1104320.300479] usb 1-6: SerialNumber: 0
Jun 14 07:04:54 widedesk mtp-probe: checking bus 1, device 6: 
"/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-6"
Jun 14 07:04:54 widedesk mtp-probe: bus: 1, device: 6 was not an MTP device
Jun 14 07:04:54 widedesk kernel: [1104321.105329] usbcore: registered 
new interface driver snd-usb-audio

<Nothing in syslog>

lsusb
Bus 001 Device 006: ID eb1a:5051 eMPIA Technology, Inc.

<unplugged>
Jun 14 07:09:09 widedesk kernel: [1104575.751244] usb 1-6: USB 
disconnect, device number 6
-----8< --------------------------------------------------

 From this I am guessing that it might be usable for audio capture, but 
nothing about the video.

This is on a Slackware 14.0 system.

My wife can still use it on her MS-Windows 7 laptop, but I was hoping to 
play with it as well.

Thank you,

Bob McConnell
N2SPP


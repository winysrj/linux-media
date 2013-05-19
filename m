Return-path: <linux-media-owner@vger.kernel.org>
Received: from li248-118.members.linode.com ([173.255.238.118]:49010 "EHLO
	kahlo.theo.to" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754167Ab3ESUZN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 May 2013 16:25:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by kahlo.theo.to (Postfix) with ESMTP id BDE6EE0004
	for <linux-media@vger.kernel.org>; Sun, 19 May 2013 16:18:26 -0400 (EDT)
Received: from kahlo.theo.to ([127.0.0.1])
	by localhost (kahlo.theo.to [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3YiTTVTlpUsG for <linux-media@vger.kernel.org>;
	Sun, 19 May 2013 16:18:25 -0400 (EDT)
Received: from [192.168.2.66] (pool-108-22-230-94.bltmmd.east.verizon.net [108.22.230.94])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: rainexpected@theo.to)
	by kahlo.theo.to (Postfix) with ESMTPSA id AA1C7E0001
	for <linux-media@vger.kernel.org>; Sun, 19 May 2013 16:18:25 -0400 (EDT)
Message-ID: <51993390.6080202@theo.to>
Date: Sun, 19 May 2013 16:18:24 -0400
From: Ted To <rainexpected@theo.to>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: InstantFM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I purchased this device and while the device driver loads and I can set
up gnomeradio to access it, it picks up no radio stations, despite being
the model with an external antenna.  The log output says "software
version 0, hardware version 7".  I'm running Debian Wheezy and the
output from dmesg is:

[66842.724036] usb 2-3: new full-speed USB device number 3 using ohci_hcd
[66842.936144] usb 2-3: New USB device found, idVendor=06e1, idProduct=a155
[66842.936150] usb 2-3: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[66842.936154] usb 2-3: Product: ADS InstantFM Music
[66842.936156] usb 2-3: Manufacturer: ADS TECH
[66843.275730] Linux media interface: v0.10
[66843.296811] Linux video capture interface: v2.00
[66843.321815] USB radio driver for Si470x FM Radio Receivers, Version
1.0.10
[66843.323136] radio-si470x 2-3:1.2: DeviceID=0xffff ChipID=0xffff
[66843.326127] radio-si470x 2-3:1.2: software version 0, hardware version 7
[66843.326131] radio-si470x 2-3:1.2: This driver is known to work with
software version 7,
[66843.326135] radio-si470x 2-3:1.2: but the device has software version 0.
[66843.326138] radio-si470x 2-3:1.2: If you have some trouble using this
driver,
[66843.326141] radio-si470x 2-3:1.2: please report to V4L ML at
linux-media@vger.kernel.org
[66843.338247] usbcore: registered new interface driver radio-si470x
[66843.407477] usbcore: registered new interface driver snd-usb-audio

Any help on what I need to do to get this working would be much appreciated.

Cheers,
Ted To

Return-path: <linux-media-owner@vger.kernel.org>
Received: from www49.your-server.de ([213.133.104.49]:46492 "EHLO
	www49.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab0ANPfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 10:35:40 -0500
Received: from [188.97.242.148] (helo=[192.168.1.22])
	by www49.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <besse@motama.com>)
	id 1NVRjX-0004Wi-8u
	for linux-media@vger.kernel.org; Thu, 14 Jan 2010 16:35:39 +0100
Message-ID: <4B4F39BB.2060605@motama.com>
Date: Thu, 14 Jan 2010 16:35:23 +0100
From: Andreas Besse <besse@motama.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Order of dvb devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

if a system contains multiple DVB cards of the same type, how is the
order of devices determined by the driver/kernel?

I use 2 Technotrend S2-3200 cards in a system and observerd that if I
load the driver driver budget_ci manually as follows:

modprobe budget_ci adapter_nr=0,1

the device with the lower pci ID 0000:08:00.0 is assigned to adapter0 and the device with the higher pci ID 0000:08:01.0
is assigned to adapter1:


udevinfo -a -p $(udevinfo -q path -n /dev/dvb/adapter0/frontend0)
[...]
  looking at parent device '/devices/pci0000:00/0000:00:1e.0/0000:08:00.0':
    KERNELS=="0000:08:00.0"
    SUBSYSTEMS=="pci"


udevinfo -a -p $(udevinfo -q path -n /dev/dvb/adapter1/frontend0)
[...]
  looking at parent device '/devices/pci0000:00/0000:00:1e.0/0000:08:01.0':
    KERNELS=="0000:08:01.0"
    SUBSYSTEMS=="pci"


Is it true for all DVB drives that the device with the lower PCI id gets the lower adapter name?









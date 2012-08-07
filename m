Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59877 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab2HGOAU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 10:00:20 -0400
Message-ID: <50211F65.607@iki.fi>
Date: Tue, 07 Aug 2012 17:00:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: it913x: DEV it913x Error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am running Linux media for 3.7 and got this error all the time all the 
IT9135 devices. Is that coming from the udev issues? At least it looks 
different than those earlier udev fw dl problemd I have seen.

Aug  7 16:55:23 localhost kernel: [53625.353211] usb 2-2: new high-speed 
USB device number 22 using ehci_hcd
Aug  7 16:55:23 localhost kernel: [53625.469720] usb 2-2: New USB device 
found, idVendor=048d, idProduct=9135
Aug  7 16:55:23 localhost kernel: [53625.469731] usb 2-2: New USB device 
strings: Mfr=0, Product=0, SerialNumber=0
Aug  7 16:55:23 localhost kernel: [53625.471127] it913x: DEV it913x Error

regards
Antti

-- 
http://palosaari.fi/

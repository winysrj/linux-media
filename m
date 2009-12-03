Return-path: <linux-media-owner@vger.kernel.org>
Received: from 0x55535970.adsl.cybercity.dk ([85.83.89.112]:29025 "EHLO
	kultorvet.udgaard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbZLCUa7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 15:30:59 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by kultorvet.udgaard.com (8.14.3/8.14.3) with ESMTP id nB3K9mLI002846
	for <linux-media@vger.kernel.org>; Thu, 3 Dec 2009 21:09:48 +0100
Message-ID: <4B181B0C.2070503@udgaard.com>
Date: Thu, 03 Dec 2009 21:09:48 +0100
From: Peter Rasmussen <plr@udgaard.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: How to help with RTL2832U based TV?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I looked around in the archives of:

	http://dir.gmane.org/gmane.linux.drivers.video-input-infrastructure
	http://www.spinics.net/lists/linux-media/

as mentioned in the welcome email of this list, but it isn't apparent to me what the status in Linux of using a device based on this chip is?


When inserting the USB dongle I get the following:

Dec  3 20:56:22 kultorvet kernel: usb 1-1: new high speed USB device 
using ehci_hcd and address 5
Dec  3 20:56:22 kultorvet kernel: usb 1-1: New USB device found, 
idVendor=1d19, idProduct=1102
Dec  3 20:56:22 kultorvet kernel: usb 1-1: New USB device strings: 
Mfr=1, Product=2, SerialNumber=3
Dec  3 20:56:22 kultorvet kernel: usb 1-1: Product: Rtl2832UDVB
Dec  3 20:56:22 kultorvet kernel: usb 1-1: Manufacturer: Realtek
Dec  3 20:56:22 kultorvet kernel: usb 1-1: SerialNumber: 1
Dec  3 20:56:22 kultorvet kernel: usb 1-1: configuration #1 chosen from 
1 choice

In Windows Vista it runs fine, showing TV using both MPEG2 and MPEG4 
encoded signals, but I would much rather run it with Linux.

I am also developing software for a living, but not this close to 
hardware, however I would like to help out the way I can.

Thanks,
Peter

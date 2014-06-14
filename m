Return-path: <linux-media-owner@vger.kernel.org>
Received: from x1.w4w.guest.it ([77.95.174.1]:56446 "EHLO x1.w4w.guest.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbaFNRfn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jun 2014 13:35:43 -0400
Received: from [185.5.61.116] (helo=[192.168.1.33])
	by x1.w4w.guest.it with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <danjde@msw.it>)
	id 1WvrcJ-0006q5-A2
	for linux-media@vger.kernel.org; Sat, 14 Jun 2014 19:19:47 +0200
Message-ID: <539C8431.10205@msw.it>
Date: Sat, 14 Jun 2014 19:19:45 +0200
From: Davide Marchi <danjde@msw.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Usb-dvb Pinnacle PCTV 200e
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi friends,

I've a Pinnacle PCTV 200e on Ubuntu LTS 14.04, kernel Linux 
3.13.0-24-generic
#47-Ubuntu SMP Fri May 2 23:31:42 UTC 2014 i686 i686 i686 GNU/Linux:

lsusb:
#Bus 001 Device 004: ID 2304:020e Pinnacle Systems, Inc. PCTV 200e

dmesg:
[ 5287.516227] usb 1-8: new high-speed USB device number 4 using ehci-pci
[ 5287.649014] usb 1-8: New USB device found, idVendor=2304, idProduct=020e
[ 5287.649026] usb 1-8: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[ 5287.649034] usb 1-8: Product: DVB-T
[ 5287.649041] usb 1-8: Manufacturer: Pinnacle Systems, Inc.
[ 5287.649048] usb 1-8: SerialNumber: 0C22175D0319C8EA

I've seen the page:
http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_200e#Development_ToDo_List 


I've installed headers and source kernel but for kernel 3.13.0-24 I 
don't know exactly what to do;

could you suggest if is it possible, how to give up Pinnacle PCTV 200e 
on Linux?
many many thanks

Davide
Italy

-- 
firma

cosmogoniA <http://www.cosmogonia.org/>
noprovarenofareononfarenonc'èprovare

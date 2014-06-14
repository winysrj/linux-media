Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <danjde@msw.it>) id 1WvpQ8-0003qR-Ml
	for linux-dvb@linuxtv.org; Sat, 14 Jun 2014 16:59:07 +0200
Received: from smtp.msw.it ([94.86.179.29])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-7) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1WvpQ7-0008DX-0o; Sat, 14 Jun 2014 16:59:04 +0200
Received: from localhost (unknown [127.0.0.1])
	by smtp.msw.it (Postfix) with ESMTP id 504803A28B
	for <linux-dvb@linuxtv.org>; Sat, 14 Jun 2014 14:59:03 +0000 (UTC)
Received: from smtp.msw.it ([127.0.0.1])
	by localhost (smtp.msw.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ogpt84+iSUen for <linux-dvb@linuxtv.org>;
	Sat, 14 Jun 2014 16:58:57 +0200 (CEST)
Received: from msw.it (mediaweb2.msw.it [10.220.254.1])
	by smtp.msw.it (Postfix) with ESMTPA id 994543A233
	for <linux-dvb@linuxtv.org>; Sat, 14 Jun 2014 16:58:57 +0200 (CEST)
From: "Marchi Davide" <danjde@msw.it>
To: linux-dvb@linuxtv.org
Date: Sat, 14 Jun 2014 16:58:55 +0200
Message-Id: <20140614144416.M15596@msw.it>
MIME-Version: 1.0
Subject: [linux-dvb] Usb-dvb Pinnacle PCTV 200e
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi friends,
I've a Pinnacle PCTV 200e on Ubuntu LTS 14.04, kernel Linux 3.13.0-24-generic
#47-Ubuntu SMP Fri May 2 23:31:42 UTC 2014 i686 i686 i686 GNU/Linux:


lsusb:
#Bus 001 Device 004: ID 2304:020e Pinnacle Systems, Inc. PCTV 200e

dmesg:
[ 5287.516227] usb 1-8: new high-speed USB device number 4 using ehci-pci
[ 5287.649014] usb 1-8: New USB device found, idVendor=2304, idProduct=020e
[ 5287.649026] usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 5287.649034] usb 1-8: Product: DVB-T
[ 5287.649041] usb 1-8: Manufacturer: Pinnacle Systems, Inc.
[ 5287.649048] usb 1-8: SerialNumber: 0C22175D0319C8EA

I've seen the page:
http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_200e#Development_ToDo_List

but for kernel 3.13.0-24 I don't know what to do;

could you suggest if is it possible, how to give up Pinnacle PCTV 200e on Linux?
many many thanks

Davide
Italy


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

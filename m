Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout11.t-online.de ([194.25.134.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yusuf.altin@t-online.de>) id 1LJDKI-0004PG-Uy
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 21:42:31 +0100
From: Yusuf Altin <yusuf.altin@t-online.de>
To: linux-dvb@linuxtv.org
Date: Sat, 03 Jan 2009 21:42:20 +0100
Message-Id: <1231015340.2963.7.camel@yusuf.laptop>
Mime-Version: 1.0
Subject: [linux-dvb] TerraTec Cinergy T Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I own a TerraTec Cinergy T Express DVB-T Card and it doesn't work with
Fedora 10.

My kernel is 2.6.27.10-167.fc10.i686.

lsusb:
Bus 001 Device 008: ID 0ccd:0062 TerraTec Electronic GmbH

dmesg:
usb 1-6: new high speed USB device using ehci_hcd and address 8
usb 1-6: configuration #1 chosen from 1 choice
usb 1-6: New USB device found, idVendor=0ccd, idProduct=0062
usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-6: Product: STK7700D
usb 1-6: Manufacturer: YUANRD
usb 1-6: SerialNumber: 0000000001

The card has afaik a dib7700PC chip.

Is it possible to get the card working?

Greeting

Yusuf Altin


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

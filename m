Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from tuc.ic3s.de ([80.146.164.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas@ic3s.de>) id 1Kzsmj-0001QJ-C6
	for linux-dvb@linuxtv.org; Tue, 11 Nov 2008 13:55:58 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by tuc.ic3s.de (Postfix) with ESMTP id A75F71440E2
	for <linux-dvb@linuxtv.org>; Tue, 11 Nov 2008 13:55:53 +0100 (CET)
Received: from tuc.ic3s.de ([127.0.0.1])
	by localhost (tuc.ic3s.de [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 02093-08 for <linux-dvb@linuxtv.org>;
	Tue, 11 Nov 2008 13:55:40 +0100 (CET)
Received: from [172.17.33.64] (thomasws2.dhcp.ic3s.de [172.17.33.64])
	by tuc.ic3s.de (Postfix) with ESMTP id 666C5144023
	for <linux-dvb@linuxtv.org>; Tue, 11 Nov 2008 13:55:40 +0100 (CET)
Message-ID: <491980CC.3000708@ic3s.de>
Date: Tue, 11 Nov 2008 13:55:40 +0100
From: Thomas <thomas@ic3s.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] af9015 problem on fedora rawhide 9.93 with 2.6.27x
	kernel
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

Hi List,


since fedora use 2.6.27 kernels this
is all what happens when i plug in the stick:

Nov 11 13:24:56 thomas-lt kernel: usb 2-6: new high speed USB device using ehci_hcd and address 3
Nov 11 13:24:57 thomas-lt kernel: usb 2-6: configuration #1 chosen from 1 choice
Nov 11 13:24:57 thomas-lt kernel: Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 16 -> 8
Nov 11 13:24:57 thomas-lt kernel: input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:1d.7/usb2/2-6/2-6:1.1/input/input9
Nov 11 13:24:57 thomas-lt kernel: input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:1d.7-6
Nov 11 13:24:57 thomas-lt kernel: usb 2-6: New USB device found, idVendor=15a4, idProduct=9016
Nov 11 13:24:57 thomas-lt kernel: usb 2-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Nov 11 13:24:57 thomas-lt kernel: usb 2-6: Product: DVB-T 2
Nov 11 13:24:57 thomas-lt kernel: usb 2-6: Manufacturer: Afatech
Nov 11 13:24:57 thomas-lt kernel: usb 2-6: SerialNumber: 010101010600001
Nov 11 13:24:57 thomas-lt kernel: dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a firmware
Nov 11 13:24:57 thomas-lt kernel: firmware: requesting dvb-usb-af9015.fw
Nov 11 13:24:57 thomas-lt kernel: dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
Nov 11 13:24:57 thomas-lt kernel: usbcore: registered new interface driver dvb_usb_af9015


if the stick is connected at boot time everything is working correctly.

can someone please give me a hint where to look for the problem?

version is af9015-e0e0e4ee5b33


Best Regards
Thomas



-- 
[:O]###[O:]



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

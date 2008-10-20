Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from poplet2.per.eftel.com ([203.24.100.45] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <the.teasdales@yahoo.com.au>) id 1KrlgD-0006Sw-3k
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 05:43:42 +0200
Received: from mail.aanet.com.au (mail.aanet.com.au [203.24.100.34])
	by poplet2.per.eftel.com (Postfix) with ESMTP id 2173F1734AF
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 11:43:33 +0800 (WST)
Received: from [192.168.1.2] (202.7.249.240.dynamic.rev.aanet.com.au
	[202.7.249.240])
	by mail.aanet.com.au (Postfix) with ESMTP id 93513460380
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 11:43:32 +0800 (WST)
From: Rob Teasdale <the.teasdales@yahoo.com.au>
To: linux-dvb@linuxtv.org
Date: Mon, 20 Oct 2008 14:43:34 +1100
Message-Id: <1224474214.6898.13.camel@rob-desktop>
Mime-Version: 1.0
Subject: [linux-dvb] Asus MyCinema U3000 mini
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

Hi all,

I am relatively new to linux and I have been trying to get my USB tuner
to work in ubuntu (kernel 2.6.24-21-generic).  According to my searches
this tuner should be supported in this kernel however it is not working.

Oct 20 11:39:04 rob-desktop kernel:
[ 6942.035771] /build/buildd/linux-2.6.24/drivers/hid/usbhid/hid-core.c:
timeout initializing reports
Oct 20 11:39:04 rob-desktop kernel: [ 6942.035917] input: ASUS  U3000
as /devices/pci0000:00/0000:00:03.3/usb4/4-7/4-7:1.1/input/input8
Oct 20 11:39:04 rob-desktop kernel: [ 6942.063272]
input,hiddev96,hidraw0: USB HID v1.11 Keyboard [ASUS  U3000 ] on
usb-0000:00:03.3-7

and also

rob@rob-desktop:~$ lsusb
Bus 004 Device 006: ID 0b05:1713 ASUSTek Computer, Inc. 
...

As can be seen the vendor id is correct, however the device id is
different to that on the linuxtv
wiki(http://www.linuxtv.org/wiki/index.php/Asus_My-Cinema-U3000_Mini). I
would assume that this would cause problems and needs to be resolved, I
am just not sure how and would appreciate any assistance. I think that
this problem is leading to my device being recognised as a keyboard?

I would really like to get this device working, and would appreciate any
pointers as to how to get this device working.  

Cheers
Rob



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from omta05sl.mx.bigpond.com ([144.140.93.195])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ptay1685@Bigpond.net.au>) id 1Jfnkn-0003oN-6r
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 04:58:49 +0200
Received: from oaamta03sl.mx.bigpond.com ([58.172.153.185])
	by omta05sl.mx.bigpond.com with ESMTP id
	<20080330025757.CXCT21921.omta05sl.mx.bigpond.com@oaamta03sl.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Sun, 30 Mar 2008 02:57:57 +0000
Message-ID: <002501c891b5$a81585b0$6e00a8c0@barny1e59e583e>
From: "ptay1685" <ptay1685@Bigpond.net.au>
To: <linux-dvb@linuxtv.org>
References: <007201c88ce2$5909c850$6e00a8c0@barny1e59e583e>
	<47E6DD2D.9040204@iki.fi>
	<001501c88ee1$f0466470$6e00a8c0@barny1e59e583e>
	<47E9AEFF.7030504@gmail.com>
	<002301c88ee9$fd998500$6e00a8c0@barny1e59e583e>
	<47E9B972.3050809@gmail.com>
	<000001c8906a$ff079800$6e00a8c0@barny1e59e583e>
	<1206776111.18375.11.camel@localhost.localdomain>
Date: Sun, 30 Mar 2008 02:57:57 +1100
MIME-Version: 1.0
Cc: Antti Palosaari <crope@iki.fi>, k.bannister@ieee.org
Subject: Re: [linux-dvb] leadtek dtv dongle lsusb
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

Here is the info as requested:
___________________________________________________________________________________

[barny@localhost ~]$ /sbin/lsusb -v -d 0413:6f01

Bus 002 Device 003: ID 0413:6f01 Leadtek Research, Inc.

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 2.00

bDeviceClass 0 (Defined at Interface level)

bDeviceSubClass 0

bDeviceProtocol 0

bMaxPacketSize0 64

idVendor 0x0413 Leadtek Research, Inc.

idProduct 0x6f01

bcdDevice 0.02

iManufacturer 1

iProduct 2

iSerial 3

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 46

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0

bmAttributes 0xa0

Remote Wakeup

MaxPower 500mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 4

bInterfaceClass 255 Vendor Specific Class

bInterfaceSubClass 0

bInterfaceProtocol 0

iInterface 0

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x01 EP 1 OUT

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0040 1x 64 bytes

bInterval 10

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x82 EP 2 IN

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x83 EP 3 IN

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

can't get device qualifier: Operation not permitted

can't get debug descriptor: Operation not permitted

Bus 002 Device 002: ID 0413:6f01 Leadtek Research, Inc.

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 2.00

bDeviceClass 0 (Defined at Interface level)

bDeviceSubClass 0

bDeviceProtocol 0

bMaxPacketSize0 64

idVendor 0x0413 Leadtek Research, Inc.

idProduct 0x6f01

bcdDevice 0.02

iManufacturer 1

iProduct 2

iSerial 3

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 46

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0

bmAttributes 0xa0

Remote Wakeup

MaxPower 500mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 4

bInterfaceClass 255 Vendor Specific Class

bInterfaceSubClass 0

bInterfaceProtocol 0

iInterface 0

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x01 EP 1 OUT

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0040 1x 64 bytes

bInterval 10

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x82 EP 2 IN

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x83 EP 3 IN

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

can't get device qualifier: Operation not permitted

can't get debug descriptor: Operation not permitted



----- Original Message ----- 
From: "J" <bitumen.surfer@gmail.com>
To: "ptay1685" <ptay1685@Bigpond.net.au>
Cc: <k.bannister@ieee.org>; "Antti Palosaari" <crope@iki.fi>
Sent: Saturday, March 29, 2008 6:35 PM
Subject: Re: [linux-dvb] leadtek dtv dongle lsusb


> Hi Phil,
>
> that's a good listing, I haven't had a chance to try Antti's patch yet
> (will do so soon), been busy solving AIX headaches. So I can't say if it
> fixes the issue's that Keith and myself were experiencing
>
> However, would you be able to do one thing for me. I noticed a slight
> discrepancy between your lsusb listing and mine. While yours appears to
> have the same USB id's it does have at least one field different
> (bmAttributes). For reference, Keith has published an identical listing
> to mine here:
> http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022373.html
>
> Could you run this command (as root) and publish the result.
> "/sbin/lsusb -v -d 0413:6f01"
>
> Thanks,
>
> John
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

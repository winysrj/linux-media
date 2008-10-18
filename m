Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sd-green-bigip-66.dreamhost.com ([208.97.132.66]
	helo=postalmail-a6.g.dreamhost.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <m.malone@homicidalteddybear.net>) id 1Kr5GJ-00030i-OE
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 08:26:11 +0200
Received: from [192.168.1.100] (c210-49-252-223.kelvn1.qld.optusnet.com.au
	[210.49.252.223])
	by postalmail-a6.g.dreamhost.com (Postfix) with ESMTP id 8FAB288644
	for <linux-dvb@linuxtv.org>; Fri, 17 Oct 2008 23:26:00 -0700 (PDT)
From: Miles Malone <m.malone@homicidalteddybear.net>
To: linux-dvb@linuxtv.org
Date: Sat, 18 Oct 2008 16:25:58 +1000
Message-Id: <1224311158.4381.6.camel@hades>
Mime-Version: 1.0
Subject: [linux-dvb] LiteOn TVT-1060 PCI-e minicard support
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

I've got a notebook that has one of the above cards embedded.  They dont
appear to currently be supported, however having pulled it out and had a
look, it's using a dibcom 7700c, using the usb2 lane of the minicard.
I've tried hacking the USB id into dib0700_devices.c, and have got it to
register but not a whole lot else, mostly because the code's a bit
beyond me.

I wonder if there's been any attempt to get support for this card added?
If not, here's the output from lsusb -v which I hope is somewhat
helpful.  If some photos of the card itself would help I'm sure I can
bash a couple up.

What else would be needed to get support for this card happening?  

Miles Malone

output from lsusb -v:

Bus 002 Device 002: ID 04ca:f016 Lite-On Technology Corp.
        Device Descriptor:
        bLength 18
        bDescriptorType 1
        bcdUSB 2.00
        bDeviceClass 0 (Defined at Interface level)
        bDeviceSubClass 0
        bDeviceProtocol 0
        bMaxPacketSize0 64
        idVendor 0x04ca Lite-On Technology Corp.
        idProduct 0xf016
        bcdDevice 1.00
        iManufacturer 1 LITEON
        iProduct 2 TVT-1060
        iSerial 3 0000000100
        bNumConfigurations 1
        Configuration Descriptor:
        bLength 9
        bDescriptorType 2
        wTotalLength 46
        bNumInterfaces 1
        bConfigurationValue 1
        iConfiguration 0
        bmAttributes 0xa0
        (Bus Powered)
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
        bmAttributes 2
        Transfer Type Bulk
        Synch Type None
        Usage Type Data
        wMaxPacketSize 0x0200 1x 512 bytes
        bInterval 1
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
        Device Qualifier (for other device speed):
        bLength 10
        bDescriptorType 6
        bcdUSB 2.00
        bDeviceClass 0 (Defined at Interface level)
        bDeviceSubClass 0
        bDeviceProtocol 0
        bMaxPacketSize0 64
        bNumConfigurations 1
        Device Status: 0x0000
        (Bus Powered)


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

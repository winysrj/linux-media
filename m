Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <alex@list.priv.at>) id 1U5zoK-0004f9-RQ
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2013 15:29:17 +0100
Received: from mail.list.priv.at ([87.230.15.114])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1U5zoK-0005RQ-Az; Thu, 14 Feb 2013 15:29:16 +0100
Received: from localhost (localhost [127.0.0.1])
	by mail.list.priv.at (Postfix) with ESMTP id DFED54B0C02B
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2013 15:29:13 +0100 (CET)
Received: from mail.list.priv.at ([127.0.0.1])
	by localhost (mail.list.priv.at [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LEiPn9lAKYbK for <linux-dvb@linuxtv.org>;
	Thu, 14 Feb 2013 15:29:13 +0100 (CET)
Received: from [192.168.42.180] (unknown [202.4.201.57])
	by mail.list.priv.at (Postfix) with ESMTPSA id 2E1F24B0C02A
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2013 15:28:56 +0100 (CET)
Message-ID: <511CF49D.9010007@list.priv.at>
Date: Thu, 14 Feb 2013 22:28:45 +0800
From: Alexander List <alex@list.priv.at>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------060408040807060202010503"
Subject: [linux-dvb] DMB-H USB Sticks: MagicPro ProHDTV Mini 2 USB
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------060408040807060202010503
Content-Type: multipart/alternative;
 boundary="------------050905060702090101080306"


--------------050905060702090101080306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

frustrated that I couldn't watch the Chinese New Years' Fireworks using
my RTL2832U based DVB-T stick in Hong Kong, I just bought a

MagicPro ProHDTV Mini 2 USB stick. Given that HK is now part of China
(somehow), they decided to follow the mainland DTV standard, so it's
DTMB (DMB-T/H) over here.

The package says it only supports Windows, but I never believe the
packaging :)

lsusb -v says:

Bus 001 Device 008: ID 1b80:d39f Afatech

This looks *very* similar to the RTL2832U, in fact dmesg says it's a
Realtek chip:

[58773.739843] usb 1-1.1: new high-speed USB device number 8 using ehci_hcd
[58773.835657] usb 1-1.1: New USB device found, idVendor=1b80,
idProduct=d39f
[58773.835665] usb 1-1.1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[58773.835670] usb 1-1.1: Product: usbtv
[58773.835673] usb 1-1.1: Manufacturer: realtek

Full lsusb -v output is attached.

I checked here but it's not listed, but other (PCIe) devices from the
same manufacturer are:

http://linuxtv.org/wiki/index.php/DMB-T/H_PCIe_Cards

I'm more than willing to get this thing supported under Linux - just let
me know what I can do to help.

I have

a) the stick
b) the Windows driver/software CD (soon as an ISO)

What I can provide is

a) help getting more info on the hardware (taking it apart etc.)
b) provide remote access to a box with the stick plugged in if necessary
c) test new code / patches

Cheers

Alex

--------------050905060702090101080306
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    Hi,<br>
    <br>
    frustrated that I couldn't watch the Chinese New Years' Fireworks
    using my RTL2832U based DVB-T stick in Hong Kong, I just bought a <br>
    <br>
    MagicPro ProHDTV Mini 2 USB stick. Given that HK is now part of
    China (somehow), they decided to follow the mainland DTV standard,
    so it's DTMB (DMB-T/H) over here.<br>
    <br>
    The package says it only supports Windows, but I never believe the
    packaging :)<br>
    <br>
    lsusb -v says:<br>
    <br>
    Bus 001 Device 008: ID 1b80:d39f Afatech <br>
    <br>
    This looks *very* similar to the RTL2832U, in fact dmesg says it's a
    Realtek chip:<br>
    <br>
    [58773.739843] usb 1-1.1: new high-speed USB device number 8 using
    ehci_hcd<br>
    [58773.835657] usb 1-1.1: New USB device found, idVendor=1b80,
    idProduct=d39f<br>
    [58773.835665] usb 1-1.1: New USB device strings: Mfr=1, Product=2,
    SerialNumber=0<br>
    [58773.835670] usb 1-1.1: Product: usbtv<br>
    [58773.835673] usb 1-1.1: Manufacturer: realtek<br>
    <br>
    Full lsusb -v output is attached.<br>
    <br>
    I checked here but it's not listed, but other (PCIe) devices from
    the same manufacturer are:<br>
    <br>
    <meta http-equiv="content-type" content="text/html;
      charset=ISO-8859-1">
    <a href="http://linuxtv.org/wiki/index.php/DMB-T/H_PCIe_Cards">http://linuxtv.org/wiki/index.php/DMB-T/H_PCIe_Cards</a><br>
    <br>
    I'm more than willing to get this thing supported under Linux - just
    let me know what I can do to help.<br>
    <br>
    I have<br>
    <br>
    a) the stick<br>
    b) the Windows driver/software CD (soon as an ISO)<br>
    <br>
    What I can provide is<br>
    <br>
    a) help getting more info on the hardware (taking it apart etc.)<br>
    b) provide remote access to a box with the stick plugged in if
    necessary<br>
    c) test new code / patches<br>
    <br>
    Cheers<br>
    <br>
    Alex<br>
  </body>
</html>

--------------050905060702090101080306--

--------------060408040807060202010503
Content-Type: text/plain; charset=UTF-8;
 name="lsusb.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsusb.txt"

Bus 001 Device 008: ID 1b80:d39f Afatech 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1b80 Afatech
  idProduct          0xd39f 
  bcdDevice            1.00
  iManufacturer           1 
  iProduct                2 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              5 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0

          

--------------060408040807060202010503
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------060408040807060202010503--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-eu.gmx.com ([213.165.64.43]:54569 "HELO
	mailout-eu.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753351Ab1ITLtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 07:49:25 -0400
Message-ID: <4E787C1B.8050304@gmx.com>
Date: Tue, 20 Sep 2011 21:42:19 +1000
From: David Shepherd <daveshep@gmx.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Leadtek DTV 2000DS Not Working in Mythbuntu 11.04
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm running Mythbuntu 11.04 (2.6.38-11 kernel) and recently bought a 
Leadtek Winfast DTV2000DS PCI dual tuner card. It's supposed to work 
out-of-the-box but mine just doesn't... I've tried the card in a Windows 
7 Media PC and it worked sweet as, so I know there's nothing wrong with 
the hardware...

So the relevant section from lsusb is

$lsusb
/
Bus 006 Device 002: ID 0413:6a04 Leadtek Research, Inc./

and with more detail

$sudo lsusb -v -s 006:002

/Bus 006 Device 002: ID 0413:6a04 Leadtek Research, Inc.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0413 Leadtek Research, Inc.
   idProduct          0x6a04
   bcdDevice            2.00
   iManufacturer           1
   iProduct                2
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           46
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x85  EP 5 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
Device Status:     0x0000
   (Bus Powered)
/
The relevant section from dmesg is

$dmesg

/[   84.230061] usb 6-1: new full speed USB device using uhci_hcd and
address 2
[   99.085019] IR NEC protocol handler initialized
[   99.100323] IR RC5(x) protocol handler initialized
[   99.104296] IR RC6 protocol handler initialized
[   99.107529] IR JVC protocol handler initialized
[   99.110847] IR Sony protocol handler initialized
[   99.119084] lirc_dev: IR Remote Control driver registered, major 250
[   99.133810] IR LIRC bridge handler initialized
[  104.704513] af9015: bulk message failed:-110 (8/0)
[  104.704524] af9015: eeprom read failed:-110
[  104.704547] dvb_usb_af9015: probe of 6-1:1.0 failed with error -110
[  104.706480] usbcore: registered new interface driver dvb_usb_af9015
/
if i try and manually load the driver i get

$sudo modprobe dvb-usb-af9015
$ dmesg

/[ 6163.061092] usb 6-1: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 
128 rq 6 len 255 ret -110/

I've messed around a lot, different versions of the firmware etc, i 
chucked in an empty HDD and tried a clean install of 11.04, and tried to 
install 11.10 Beta 1 (that doesn't work - it freezes after the Remote 
Control Setup page as someone reported here 
https://bugs.launchpad.net/bugs/854426), and nothing has worked besides 
using it in a Windows machine.

Any ideas?

cheers

Shep

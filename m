Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm9-vm0.bullet.mail.ird.yahoo.com ([77.238.189.197]:45341 "HELO
	nm9-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750951Ab2E2Ihb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 04:37:31 -0400
Message-ID: <1338280649.4393.YahooMailNeo@web29805.mail.ird.yahoo.com>
Date: Tue, 29 May 2012 09:37:29 +0100 (BST)
From: dz <danzax69@yahoo.gr>
Reply-To: dz <danzax69@yahoo.gr>
Subject: TurboX Hybrid TV Tuner HTT-1000 SUPPORT?
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I have bought recently TurboX Hybrid TV Tuner HTT-1000, which don't work on linux at all.
from lsusb, appears as:
Bus 001 Device 003: ID 1b80:d418 Afatech 

and no other infos are available.
dmesg doesn't give any info about it.

lsusb -v gives these:

-----------------------------------------------------------------------------------
Bus 001 Device 010: ID 1b80:d418 Afatech 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
 
 bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x1b80 Afatech
  idProduct          0xd418 
  bcdDevice           40.01
  iManufacturer           1 Conexant Corporation
  iProduct                2 Polaris AV Capture
  iSerial                 3
 0000000000
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          344
    bNumInterfaces          7
    bConfigurationValue     1
    iConfiguration          4 Polaris AV Capture
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
   
 MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor
 Specific Protocol
      iInterface             32 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8e  EP 14 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch
 Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0e  EP 14
 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               4
    Interface Association:
     
 bLength                 8
      bDescriptorType        11
      bFirstInterface         1
      bInterfaceCount         6
      bFunctionClass        255 Vendor Specific Class
      bFunctionSubClass     255 Vendor Specific Subclass
      bFunctionProtocol     255 Vendor Specific Protocol
      iFunction               0 
    Interface Descriptor:
     
 bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              7 Polaris AV
 Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8f  EP 15 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage
 Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               7
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
     
 bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              8 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
       
 bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
     
 bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              9 Polaris AV
 Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage
 Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       2
      bNumEndpoints           1
     
 bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             10 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes           
 5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0080  1x 128 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
     
 bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             11 Polaris AV Capture
      Endpoint Descriptor:
       
 bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type              
 Data
        wMaxPacketSize     0x013c  1x 316 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific
 Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             12 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer
 Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x02c8  1x 712 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType        
 4
      bInterfaceNumber        2
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             13 Polaris AV Capture
      Endpoint Descriptor:
        bLength                
 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0ac8  2x 712
 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific
 Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             20 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type           
 Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber       
 3
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             21 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
       
 bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x001c  1x 28 bytes
       
 bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255
 Vendor Specific Protocol
      iInterface             22 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch
 Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0034  1x 52 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
     
 bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             23 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType        
 5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              
 0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
     
 iInterface             24 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type              
 Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x00b8  1x 184 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       2
     
 bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             25 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4
 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x02d8  1x 728 bytes
        bInterval               1
    Interface Descriptor:
     
 bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             26 Polaris AV
 Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage
 Type               Data
        wMaxPacketSize     0x13c4  3x 964 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       4
      bNumEndpoints           1
     
 bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             27 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes           
 5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0b84  2x 900 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
     
 bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             28 Polaris AV Capture
      Endpoint Descriptor:
       
 bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
       
 wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
     
 bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             31 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer
 Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
     
 bInterfaceNumber        6
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             29 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
       
 bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
       
 bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        6
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255
 Vendor Specific Protocol
      iInterface             30 Polaris AV Capture
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch
 Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0240  1x 576 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
 
 bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)
------------------------------------------------------------------------------
I've extracted the firmware from windows driver and found that is the v4l-cx25840.fw.
Also from what I can see from device' s chips labels, seems that has
the cx231xx (appears as CX23102-11Z)
and RTL 2832.

Here all the infos on the card:

-----------------------------------------------------------------------------------------------------------------
-------Hybrid TV Tuner HTT-1000--------------------

CX23102-11Z
N2F644.05
1031 SG

RTL
 2832
BAD 70A1
    GB46D

HU 4122 ver: c.
FKX E315599
1150 94v-0


HT24L C02
B117P1315G3

N28.800
8D20PB

BGM2
48M


      18272/M
N
X   cs7113
P        05
TXD11441

NTK
16.000 F


CO2-1C0002  HU4122-D
13020-10200-05020-G
           021
--------------------------------------------------------------------------------------------------------------------------------

So, I think that can be work but I don' t know how to input the informations, so the v4-dvb can load it.
I've read the related stuf on wiki, but I can really understand what needed to be done for my situation. 

Any help, or guides?

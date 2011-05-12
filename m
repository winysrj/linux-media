Return-path: <mchehab@gaivota>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45902 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab1ELN17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 09:27:59 -0400
Received: by eyx24 with SMTP id 24so422326eyx.19
        for <linux-media@vger.kernel.org>; Thu, 12 May 2011 06:27:58 -0700 (PDT)
Message-ID: <4DCBE059.8030906@gmail.com>
Date: Thu, 12 May 2011 15:27:53 +0200
From: Per Kofod <per.s.kofod@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Help needed: Anysee E30C Plus (DVB-C Tuner)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi

I am new to this mailing list, so bare with me if this have been asked 
before.

I have just bought an Anysee E30C Plus, as I had read, that this device 
is supported
in Linux, my plan is building a Mythtv media center, to replace my old 
harddisk recorder.

However I cannot get it to work, and then I read thatt the newest 
version might not work,
and that I should join this list.

I have tried to compile a new kernel with the newest dvb stuff from the 
git repository, just
to make sure, that I have the newest drivers.  I have alsio blacklistet 
the zl10353 module
to avoid the device being loaded as an DVB-T device (which it is not, it 
is a cable only version).

What information do you need me to obtain, or do you have a hint to how 
I might get this working?

The device is reconnized OK as seen here from dmesg:

[   11.354973] dvb-usb: found a 'Anysee DVB USB2.0' in warm state.
[   11.355004] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[   11.355239] DVB: registering new adapter (Anysee DVB USB2.0)
[   11.356661] anysee: firmware version:0.1.2 hardware id:15
[   11.391192] IR NEC protocol handler initialized
[   11.412221] IR RC5(x) protocol handler initialized
[   11.412611] DVB: Unable to find symbol zl10353_attach()
[   11.414527] DVB: Unable to find symbol zl10353_attach()
[   11.417536] DVB: registering adapter 1 frontend 0 (Philips TDA10023 
DVB-C)...
[   11.430950] IR RC6 protocol handler initialized
[   11.553821] IR JVC protocol handler initialized
[   11.555642] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-5/input/input6
[   11.555682] dvb-usb: schedule remote query interval to 200 msecs.
[   11.555689] dvb-usb: Anysee DVB USB2.0 successfully initialized and 
connected.
[   11.557207] usbcore: registered new interface driver dvb_usb_anysee
[   11.569445] IR Sony protocol handler initialized
[   11.584259] lirc_dev: IR Remote Control driver registered, major 251
[   11.586747] IR LIRC bridge handler initialized

but lsusb reports this as an DVB-T Device:

tux3:~ # lsusb -s 002:002 -v

Bus 002 Device 002: ID 1c73:861f AMT Anysee E30 USB 2.0 DVB-T Receiver
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x1c73 AMT
   idProduct          0x861f Anysee E30 USB 2.0 DVB-T Receiver
   bcdDevice            1.00
   iManufacturer           1 AMT.CO.KR
   iProduct                2 anysee-FA(LP)
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           83
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
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
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
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
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
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1400  3x 1024 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1400  3x 1024 bytes
         bInterval               1
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0002
   (Bus Powered)
   Remote Wakeup Enabled

The problem is, that I cannot get it to tune into any frequency:

using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
initial transponder 143000000 6875000 0 3
initial transponder 156000000 6875000 0 3
initial transponder 378000000 6875000 0 3
initial transponder 394000000 6875000 0 3
initial transponder 442000000 6875000 0 3
initial transponder 490000000 6875000 0 3
initial transponder 498000000 6875000 0 3
initial transponder 514000000 6875000 0 3
initial transponder 530000000 6875000 0 3
initial transponder 538000000 6875000 0 3
initial transponder 554000000 6875000 0 3
initial transponder 570000000 6875000 0 3
initial transponder 578000000 6875000 0 3
initial transponder 618000000 6875000 0 3
initial transponder 626000000 6875000 0 3
initial transponder 714000000 6875000 0 3
initial transponder 730000000 6875000 0 3
initial transponder 770000000 6875000 0 3
initial transponder 786000000 6875000 0 3
initial transponder 794000000 6875000 0 3
 >>> tune to: 143000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64
WARNING: >>> tuning failed!!!
 >>> tune to: 143000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64 (tuning 
failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 156000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64
WARNING: >>> tuning failed!!!
 >>> tune to: 156000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64 (tuning 
failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 378000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64
WARNING: >>> tuning failed!!!
ETC


Rgds Per


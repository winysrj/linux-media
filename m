Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:53999 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbZL0BHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Dec 2009 20:07:39 -0500
Received: by fxm25 with SMTP id 25so3908839fxm.21
        for <linux-media@vger.kernel.org>; Sat, 26 Dec 2009 17:07:37 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 27 Dec 2009 02:07:37 +0100
Message-ID: <355c45860912261707w49478f15oaadd65a61f992ede@mail.gmail.com>
Subject: Afatech USB ID 1b80:e39a (please disregard my last mail)
From: Tomislav Strelar <tstrelar@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, I accidentally pushed the "Send button" before time. :) So here
it is again (and complete this time) :)


Hi everyone,

Would it be possible to add support for KWorld USB Stick II,
KW-D-395UR? It's USB ID is 1b80:e39a?
On the chip it's written:
AF9015A-N1
0817 HL2R2

There is a support for KWorld USB Stick II in current version of
v4l-dvb. However, it seems that supported device(s) (VS-DVB-T 395U)
are not the same as KW-D-395UR. Their IDs are e395, e396 and e39b.
I've tried just adding e39a, but had no luck in making it work.

This is what happens when I connect the device after adding newly built fw:
Dec 27 02:03:30 Studio kernel: [ 2407.329254] dvb-usb: found a 'KWorld
USB DVB-T TV Stick II (VS-DVB-T 395U)' in cold state, will try to load
a firmware
Dec 27 02:03:30 Studio kernel: [ 2407.329261] usb 1-4: firmware:
requesting dvb-usb-af9015.fw
Dec 27 02:03:30 Studio kernel: [ 2407.345722] dvb-usb: downloading
firmware from file 'dvb-usb-af9015.fw'
Dec 27 02:03:30 Studio kernel: [ 2407.399634] dvb-usb: found a 'KWorld
USB DVB-T TV Stick II (VS-DVB-T 395U)' in warm state.
Dec 27 02:03:30 Studio kernel: [ 2407.399682] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
Dec 27 02:03:30 Studio kernel: [ 2407.400029] DVB: registering new
adapter (KWorld USB DVB-T TV Stick II (VS-DVB-T 395U))
Dec 27 02:03:32 Studio kernel: [ 2409.400212] af9015: recv bulk
message failed:-110
Dec 27 02:03:34 Studio kernel: [ 2411.410168] af9015: bulk message
failed:-110 (8/0)
Dec 27 02:03:36 Studio kernel: [ 2413.400122] af9015: bulk message
failed:-110 (8/0)
Dec 27 02:03:38 Studio kernel: [ 2415.400076] af9015: bulk message
failed:-110 (8/0)
Dec 27 02:03:40 Studio kernel: [ 2417.400156] af9015: bulk message
failed:-110 (8/0)

The last message then repeats forever.

Kernel is 2.6.31-15-generic

lsusb output for device:

Device Descriptor:
 bLength                18
 bDescriptorType         1
 bcdUSB               2.00
 bDeviceClass            0 (Defined at Interface level)
 bDeviceSubClass         0
 bDeviceProtocol         0
 bMaxPacketSize0        64
 idVendor           0x1b80 Afatech
 idProduct          0xe39a
 bcdDevice            2.00
 iManufacturer           1 Afatech
 iProduct                2 DVB-T 2
 iSerial                 0
 bNumConfigurations      1
 Configuration Descriptor:
   bLength                 9
   bDescriptorType         2
   wTotalLength           46
   bNumInterfaces          1
   bConfigurationValue     1
   iConfiguration          0
   bmAttributes         0x80
     (Bus Powered)
   MaxPower              500mA
   Interface Descriptor:
     bLength                 9
     bDescriptorType         4
     bInterfaceNumber        0
     bAlternateSetting       0
     bNumEndpoints           4
     bInterfaceClass       255 Vendor Specific Class
     bInterfaceSubClass      0
     bInterfaceProtocol      0
     iInterface              0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x81  EP 1 IN
       bmAttributes            2
         Transfer Type            Bulk
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x02  EP 2 OUT
       bmAttributes            2
         Transfer Type            Bulk
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x84  EP 4 IN
       bmAttributes            2
         Transfer Type            Bulk
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x85  EP 5 IN
       bmAttributes            2
         Transfer Type            Bulk
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
Device Qualifier (for other device speed):
 bLength                10
 bDescriptorType         6
 bcdUSB               2.00
 bDeviceClass            0 (Defined at Interface level)
 bDeviceSubClass         0
 bDeviceProtocol         0
 bMaxPacketSize0        64
 bNumConfigurations      1
Device Status:     0x0000
 (Bus Powered)

Thanks.

Cheerio!
Tomislav

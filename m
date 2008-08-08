Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.thanes.org ([64.79.219.36] helo=thanes.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <grendel@twistedcode.net>) id 1KRYz8-0007iV-VS
	for linux-dvb@linuxtv.org; Fri, 08 Aug 2008 22:54:57 +0200
Received: from twistedcode.net (77-253-24-61.adsl.inetia.pl [77.253.24.61])
	by thanes.org (Postfix) with ESMTPSA id 0CC412241275
	for <linux-dvb@linuxtv.org>; Fri,  8 Aug 2008 22:54:47 +0200 (CEST)
Date: Fri, 8 Aug 2008 22:54:43 +0200
From: Marek Habersack <grendel@twistedcode.net>
To: linux-dvb@linuxtv.org
Message-ID: <20080808225443.73bdd51a@twistedcode.net>
Mime-Version: 1.0
Subject: [linux-dvb] Leadtek WinFast Dongle H device support?
Reply-To: grendel@twistedcode.net
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

Hello everybody,

	I've just gotten the device mentioned in the subject
(http://www.leadtek.com/eng/tv_tuner/overview.asp?lineid=6&pronameid=403) and
discovered that it's not yet supported under Linux. I tried adding its ID to both
dib0700 and af9015 drivers, but the hardware doesn't work with those. I don't want
to open the device to check what chipset it is built on (I might just return it if
there's no way it can work under Linux) - perhaps someone played with it already and
it's known what's inside? If yes, is there any Linux driver for the dongle? If no,
what can I do to help? Here's the output of lsusb for the device:

Bus 001 Device 003: ID 0413:60f6 Leadtek Research, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0413 Leadtek Research, Inc.
  idProduct          0x60f6 
  bcdDevice            0.01
  iManufacturer           1 Leadtek
  iProduct                2 DTV Dongle H
  iSerial                 3 1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
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
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
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
Device Status:     0x0000
  (Bus Powered)

thanks in advance,

marek

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

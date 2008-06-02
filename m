Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2.unimelb.edu.au ([128.250.20.112]
	helo=cygnus.its.unimelb.EDU.AU)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rns@unimelb.edu.au>) id 1K31JZ-0006hc-Tm
	for linux-dvb@linuxtv.org; Mon, 02 Jun 2008 06:06:37 +0200
Received: from CONVERSION-DAEMON.SMTP.UNIMELB.EDU.AU by SMTP.UNIMELB.EDU.AU
	(PMDF V6.3-x3 #31385) id <01MVIOKJL64GC1TTGB@SMTP.UNIMELB.EDU.AU> for
	linux-dvb@linuxtv.org; Mon, 02 Jun 2008 14:06:28 +1000
Received: from granville.its.unimelb.edu.au
	(granville.its.unimelb.edu.au [128.250.146.85])
	by SMTP.UNIMELB.EDU.AU (PMDF V6.3-x3 #31385)
	with ESMTP id <01MVIOKJJXM8C1UJEO@SMTP.UNIMELB.EDU.AU> for
	linux-dvb@linuxtv.org; Mon, 02 Jun 2008 14:06:27 +1000
Date: Mon, 02 Jun 2008 14:06:32 +1000
From: Robert Sturrock <rns@unimelb.edu.au>
To: linux-dvb@linuxtv.org
Message-id: <20080602040632.GI4833@unimelb.edu.au>
MIME-version: 1.0
Content-disposition: inline
Subject: [linux-dvb] Leadtek Winfast Gold USB Dongle - USB id 0x6029?
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

Hi All.

I recently acquired a Leadtek Winfast Gold USB Dongle, which unfortunately
does not seem to be recognised at present.  I think this may have been
mentioned in a couple of other threads:

    http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024330.html    
    http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024931.html

However, the one I have seems to come up with a USB-id of 6029 (maybe
this is a particular Australian variant as the other threads mention an
id of 6f01, not sure).

Does anyone have any ideas about how I might get this card working?  I
attach the output of an "lsusb -v" below.

The current dvb-usb-ids.h has only these ids:

#define USB_PID_WINFAST_DTV_DONGLE_COLD                 0x6025
#define USB_PID_WINFAST_DTV_DONGLE_WARM                 0x6026
#define USB_PID_WINFAST_DTV_DONGLE_STK7700P             0x6f00
#define USB_PID_WINFAST_DTV_DONGLE_STK7700P_2           0x6f01

Regards,

Robert.


Bus 004 Device 007: ID 0413:6029 Leadtek Research, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0413 Leadtek Research, Inc.
  idProduct          0x6029 
  bcdDevice            2.00
  iManufacturer           1 Leadtek
  iProduct                2 WinFast DTV Dongle Gold
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           71
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
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
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              16
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

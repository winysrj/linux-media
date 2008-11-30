Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bemorgan@gmail.com>) id 1L6dY8-0003pN-Cq
	for linux-dvb@linuxtv.org; Sun, 30 Nov 2008 05:04:51 +0100
Received: by rv-out-0506.google.com with SMTP id b25so1909937rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 29 Nov 2008 20:04:43 -0800 (PST)
Message-ID: <3d623cf80811292004u282db50crcb17ea9f376578dd@mail.gmail.com>
Date: Sun, 30 Nov 2008 14:04:43 +1000
From: "Benjamin Morgan" <bemorgan@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Hauppauge Nova-T 500 problem, probably erased eeprom
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

Hi All,

I'm experiencing problems getting a hauppauge Nova T 500 to work on my
system, based on the thread
http://www.mail-archive.com/linux-dvb@linuxtv.org/msg26676.html it
sounds like my card has an erased eeprom, how can I check this? Is
there a line from lsusb that shows this?

I've tried doing what was suggested in the thread to force the driver
to recognise the device as a Nova T 500 however this hasn't worked.
For reference I edited the following:

linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h - added the following lines:
#define USB_PID_HAUPPAUGE_NOVA_T_500_4                  0x10b8
#define USB_PID_HAUPPAUGE_NOVA_T_500_5                  0x0066

/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c - added the following lines:
       { USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500_4) },
        { USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500_5) },

and then ran a make, make install and shutdown the computer and
restarted it however it is still not being recognised.

The system I am running it on is a fresh install of Ubuntu 8.10, some
details as follows:

Details from the card:

uname -a
Linux tv 2.6.27-9-generic #1 SMP Thu Nov 20 21:57:00 UTC 2008 i686 GNU/Linux

lsusb
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 003: ID 0609:0322 SMK Manufacturing, Inc. eHome Infrared Receiver
Bus 002 Device 002: ID 045e:008a Microsoft Corp. Wireless Keyboard and Mouse
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 002: ID 10b8:0066 DiBcom
Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

lsusb -vd 10b8:0066

Bus 005 Device 002: ID 10b8:0066 DiBcom
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x10b8 DiBcom
  idProduct          0x0066
  bcdDevice            2.00
  iManufacturer           1 DiBcom SA
  iProduct                2 HOOK
  iSerial                 0
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

modprobe dvb-usb-dib0700 debug=8 then dmesg:
[ 1144.779172] dib0700: loaded with support for 8 different device-types
[ 1144.783648] usbcore: registered new interface driver dvb_usb_dib0700

any suggestions would be most welcome

Ben

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

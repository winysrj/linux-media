Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smeagol.cambrium.nl ([217.19.16.145] ident=qmailr)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1JUjPR-0000Ot-Th
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 15:06:54 +0100
Received: from [192.168.1.70] (ashley.powercraft.nl [84.245.7.46])
	by ashley.powercraft.nl (Postfix) with ESMTP id 195511C812
	for <linux-dvb@linuxtv.org>; Thu, 28 Feb 2008 15:06:50 +0100 (CET)
Message-ID: <47C6BFF9.5050902@powercraft.nl>
Date: Thu, 28 Feb 2008 15:06:49 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------000805070602080207090800"
Subject: [linux-dvb] AVerTV Hybrid Volar HX A827 - device ID not supported -
	no driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------000805070602080207090800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Fellow dvb'ers,

My friend bought a AVerTV Hybrid Volar HX A827 for is linux pc and hoped 
it would work. After he spent a day to get it working he asked my help.

I tried a hole list of things, and went through the code. I tried to get 
it working with the a800 driver and added some device ID's but i cant 
make it to work. There is no firmware or datasheets for the device.

Can the device be added to the list of not working devices?
Will somebody else be able to make a good driver for the device?

I added a lot of good info in the attachment.

Kind regards,

Jelle de Jong

--------------000805070602080207090800
Content-Type: text/plain;
 name="AVerTV Hybrid Volar HX A827.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="AVerTV Hybrid Volar HX A827.txt"

dib3000-common.ko
dib3000mc.ko
dvb-usb.ko
dvb-usb-dibusb-common.ko
dvb-usb-a800.ko

sudo depmod -a

/lib/firmware/2.6.22-14-generic/dvb-usb-avertv-a800-02.fw

cp /lib/firmware/2.6.22-14-generic/dvb-usb-avertv-a800-02.fw /lib/firmware/dvb-usb-avertv-a800-02.fw
sudo cp --verbose /lib/firmware/2.6.22-14-generic/dvb-usb-avertv-a800-02.fw /lib/firmware/dvb-usb-avertv-a800-02.fw


sudo insmod /lib/modules/2.6.22-14-generic/kernel/drivers/media/dvb/frontends/dib3000mb.ko
sudo insmod /lib/modules/2.6.22-14-generic/kernel/drivers/media/dvb/frontends/dib3000mc.ko
sudo insmod /lib/modules/2.6.22-14-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb.ko
sudo insmod /lib/modules/2.6.22-14-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dibusb-common.ko
sudo insmod /lib/modules/2.6.22-14-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-a800.ko

sudo modprobe i2c-core
sudo modprobe dvb-core
sudo modprobe dib3000mc
sudo modprobe dvb-usb
sudo modprobe dvb-usb-dibusb-common
sudo modprobe dvb-usb-a800
sudo modprobe dib3000mb
sudo modprobe dibx000_common
sudo modprobe dib7000p
sudo modprobe dvb-usb-firmware

sudo rmmod -f i2c-core
sudo rmmod -f dvb-core
sudo rmmod -f dib3000mc
sudo rmmod -f dvb-usb
sudo rmmod -f dvb-usb-dibusb-common
sudo rmmod -f dvb-usb-a800
sudo rmmod -f dib3000mb
sudo rmmod -f dibx000_common
sudo rmmod -f dib7000p
sudo rmmod -f dvb-usb-firmware

sudo insmod /home/jelle/v4l-dvb/v4l/dvb-core.ko
sudo insmod /home/jelle/v4l-dvb/v4l/dvb-pll.ko
sudo insmod /home/jelle/v4l-dvb/v4l/dvb-usb-a800.ko
sudo insmod /home/jelle/v4l-dvb/v4l/dvb-usb-dibusb-common.ko
sudo insmod /home/jelle/v4l-dvb/v4l/dvb-usb-dibusb-mb.ko
sudo insmod /home/jelle/v4l-dvb/v4l/dvb-usb-dibusb-mc.ko
sudo insmod /home/jelle/v4l-dvb/v4l/dib3000mb.ko
sudo insmod /home/jelle/v4l-dvb/v4l/dib3000mc.ko
sudo insmod /home/jelle/v4l-dvb/v4l/dib7000p.ko
sudo insmod /home/jelle/v4l-dvb/v4l/dib0070.ko
sudo insmod /home/jelle/v4l-dvb/v4l/dibx000_common.ko

sudo modprobe dvb-core
sudo modprobe dvb-pll
sudo modprobe dvb-usb-a800
sudo modprobe dvb-usb-dibusb-common
sudo modprobe dvb-usb-dibusb-mb
sudo modprobe dvb-usb-dibusb-mc
sudo modprobe dib3000mb
sudo modprobe dib3000mc
sudo modprobe dib7000p
sudo modprobe dib0070
sudo modprobe dibx000_common

http://www.mythtv.org/wiki/index.php/AVerTV_DVB-T_Volar

sudo apt-get install dvb-utils mercurial build-essential linux-headers-$(uname -r)


hg clone http://linuxtv.org/hg/v4l-dvb
cd v4l-dvb
make
sudo make install
sudo depmod -a

sudo find . '*' -type f -exec sudo grep -H -n "0x07ca" '{}' \;
sudo find . '*' -type f -exec sudo grep -H -n "0xa827" '{}' \;

sudo find . '*' -type f -exec sudo grep -H -n "0xa800" '{}' \;
sudo find . '*' -type f -exec sudo grep -H -n "AVERMEDIA" '{}' \;

cd $HOME
vim ./v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
vim ./v4l-dvb/linux/drivers/media/dvb/dvb-usb/a800.c

sudo modinfo /home/jelle/v4l-dvb/v4l/dvb-usb-a800.ko
sudo modinfo dvb-usb-a800

AVerTV Hybrid Volar HX A827
http://www.avermedia.com/AVerTV/Product/ProductDetail.aspx?Id=293

Bus 002 Device 003: ID 07ca:a827 AVerMedia Technologies, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x07ca AVerMedia Technologies, Inc.
  idProduct          0xa827
  bcdDevice            1.03
  iManufacturer           1 AVerMedia
  iProduct                2 AVerTV
  iSerial                 3 300367002364
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          219
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
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1
      bInterfaceProtocol      1
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
        bEndpointAddress     0x01  EP 1 OUT
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1
      bInterfaceProtocol      1
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
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
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x13f2  3x 1010 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       2
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1
      bInterfaceProtocol      1
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
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
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x12d6  3x 726 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       3
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1
      bInterfaceProtocol      1
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
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
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x12ae  3x 686 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       4
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1
      bInterfaceProtocol      1
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
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
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x03ca  1x 970 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       5
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1
      bInterfaceProtocol      1
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
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
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x02ac  1x 684 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       6
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1
      bInterfaceProtocol      1
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
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
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x03ac  1x 940 bytes
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


--------------000805070602080207090800
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000805070602080207090800--

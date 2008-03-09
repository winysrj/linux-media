Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m29968XX019970
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 05:06:08 -0400
Received: from cabrera.red.sld.cu (cabrera.red.sld.cu [201.220.222.139])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2995WG4014198
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 05:05:34 -0400
Received: from [201.220.219.1] by cabrera.red.sld.cu with esmtp (Exim 4.63)
	(envelope-from <moya-lists@infomed.sld.cu>) id 1JYHSw-0007P8-Ca
	for video4linux-list@redhat.com; Sun, 09 Mar 2008 05:05:12 -0400
From: Maykel Moya <moya-lists@infomed.sld.cu>
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="=-oU62t/FuuPQE3qT54QBb"
Date: Sun, 09 Mar 2008 05:08:14 -0400
Message-Id: <1205053694.6188.312.camel@gloria.red.sld.cu>
Mime-Version: 1.0
Subject: Problems setting up Sabrent Mini Stick USB 2.0 TV Tuner (TV-USBST)
	6000:0001
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--=-oU62t/FuuPQE3qT54QBb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

device: Sabrent Mini Stick USB 2.0 TV Tuner (TV-USBST)
url: http://www.sabrent.com/products/specs/TV-USBST.htm
id: 6000:0001
chip: TM5600

And lsusb -d 6000:0001 -v output is attached.

I have a stock Debian 2.6.24 kernel. This is what I did:

1. hg clone http://.../v4l-dvb v4l-dvb-upstream
2. hg clone http://.../tm6010 tm6010-upstream
3. hg clone v4l-dvb-upstream v4l-dvb
4. cd v4l-dvb
5. hg fetch ../tm6010-upstream
   (some minor issues with file 
    linux/drivers/media/video/tuner-xc2028.c during merge)
6. make && sudo make install
7. cd ../tm6010-upstream
8. copy /from/install/cd/the/right/tridvid.sys .
9. perl get_firmware.pl

Then I got the tm6000_xc2028_firmware{1,2}.fw files. As per this
message[1] I tried both files one at a time. The module claimed the
firmware file is corrupt both times. Find attached dmesg log for tm6000
modprobing with debug=3 for each firmware file.

FTR, the md5 sums of fw files
dbd46281bba4d1ff192823560ae515b0  tm6000_xc2028_firmware1.fw
3c431f5a3f9a99fd19908418d86c7227  tm6000_xc2028_firmware2.fw

I'm willing to test as much as I can in order to get the device working.
A friend of mine have bought an identical tuner, they have XP on his
machine and I could access it for testing if necessary.

Regards,
maykel

[1]
https://www.redhat.com/mailman/private/video4linux-list/2008-February/msg00109.html


--=-oU62t/FuuPQE3qT54QBb
Content-Disposition: attachment; filename="modprobe-tm6000-debug=3-fw1.dmesg"
Content-Type: text/plain; name="modprobe-tm6000-debug=3-fw1.dmesg";
	charset=UTF-8
Content-Transfer-Encoding: quoted-printable

tm6000 v4l2 driver version 0.0.1 loaded
tm6000: alt 0, interface 0, class 255
tm6000: alt 0, interface 0, class 255
tm6000: Bulk IN endpoint: 0x82 (max size=3D512 bytes)
tm6000: alt 1, interface 0, class 255
tm6000: ISOC IN endpoint: 0x81 (max size=3D3072 bytes)
tm6000: alt 1, interface 0, class 255
tm6000: alt 2, interface 0, class 255
tm6000: alt 2, interface 0, class 255
tm6000: New video device @ 480 Mbps (6000:0001, ifnum 0)
tm6000: Found 10Moons UT 821
Error -32 while retrieving board version
Hack: enabling device at addr 0xc2
tuner' 1-0061: chip found @ 0xc2 (tm6000 #0)
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 1-0061: xc2028/3028 firmware name not set!
tm6000 #0: i2c eeprom 00: 00 99 5b 49 ff ff ff ff ff ff ff ff ff ff ff ff  =
..[I............
tm6000 #0: i2c eeprom 10: ff ff ff ff 31 30 4d 4f 4f 4e 53 35 36 30 30 ff  =
....10MOONS5600.
tm6000 #0: i2c eeprom 20: 45 5b ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
E[..............
tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
  ................
Trident TVMaster TM5600/TM6000 USB2 board (Load status: 0)
Setting firmware parameters for xc2028
xc2028 1-0061: Loading 9073 firmware images from tm6000-xc3028.fw, type: tm=
6000/xcv v1=0D*=03=C8=E0, ver 15.211
xc2028 1-0061: Firmware type BASE D2633 DTV6 QAM DTV7 DTV78 ATSC LG60 DIBCO=
M52 CHINA INPUT2 SCODE (b50501f1), id c100d12a0d0f60d0 is corrupted (size=
=3D8133, expected 774720)
xc2028 1-0061: Error: firmware file is corrupted!
xc2028 1-0061: Releasing partially loaded firmware file.
xc2028 1-0061: Loading 9073 firmware images from tm6000-xc3028.fw, type: tm=
6000/xcv v1=0D*=03=C8=E0, ver 15.211
xc2028 1-0061: Firmware type BASE D2633 DTV6 QAM DTV7 DTV78 ATSC LG60 DIBCO=
M52 CHINA INPUT2 SCODE (b50501f1), id c100d12a0d0f60d0 is corrupted (size=
=3D8133, expected 774720)
xc2028 1-0061: Error: firmware file is corrupted!
xc2028 1-0061: Releasing partially loaded firmware file.
usbcore: registered new interface driver tm6000

--=-oU62t/FuuPQE3qT54QBb
Content-Disposition: attachment; filename="modprobe-tm6000-debug=3-fw2.dmesg"
Content-Type: text/plain; name="modprobe-tm6000-debug=3-fw2.dmesg";
	charset=UTF-8
Content-Transfer-Encoding: quoted-printable

tm6000 v4l2 driver version 0.0.1 loaded
tm6000: alt 0, interface 0, class 255
tm6000: alt 0, interface 0, class 255
tm6000: Bulk IN endpoint: 0x82 (max size=3D512 bytes)
tm6000: alt 1, interface 0, class 255
tm6000: ISOC IN endpoint: 0x81 (max size=3D3072 bytes)
tm6000: alt 1, interface 0, class 255
tm6000: alt 2, interface 0, class 255
tm6000: alt 2, interface 0, class 255
tm6000: New video device @ 480 Mbps (6000:0001, ifnum 0)
tm6000: Found 10Moons UT 821
Error -32 while retrieving board version
Hack: enabling device at addr 0xc2
tuner' 1-0061: chip found @ 0xc2 (tm6000 #0)
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 1-0061: xc2028/3028 firmware name not set!
tm6000 #0: i2c eeprom 00: 00 99 5b 49 ff ff ff ff ff ff ff ff ff ff ff ff  =
..[I............
tm6000 #0: i2c eeprom 10: ff ff ff ff 31 30 4d 4f 4f 4e 53 35 36 30 30 ff  =
....10MOONS5600.
tm6000 #0: i2c eeprom 20: 45 5b ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
E[..............
tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  =
................
  ................
Trident TVMaster TM5600/TM6000 USB2 board (Load status: 0)
Setting firmware parameters for xc2028
xc2028 1-0061: Loading 2319 firmware images from tm6000-xc3028.fw, type: tm=
6000/xcv v1	*=03=D5=E0, ver 15.211
xc2028 1-0061: Firmware type INIT1 F8MHZ D2620 DTV6 DTV78 LCD NOGD ATSC IF =
OREN36 DIBCOM52 INPUT2 SCODE HAS_IF_0 (f123712a), id 2a090f60d0c30501 is co=
rrupted (size=3D8852, expected 198312145)
xc2028 1-0061: Error: firmware file is corrupted!
xc2028 1-0061: Releasing partially loaded firmware file.
xc2028 1-0061: Loading 2319 firmware images from tm6000-xc3028.fw, type: tm=
6000/xcv v1	*=03=D5=E0, ver 15.211
xc2028 1-0061: Firmware type INIT1 F8MHZ D2620 DTV6 DTV78 LCD NOGD ATSC IF =
OREN36 DIBCOM52 INPUT2 SCODE HAS_IF_0 (f123712a), id 2a090f60d0c30501 is co=
rrupted (size=3D8852, expected 198312145)
xc2028 1-0061: Error: firmware file is corrupted!
xc2028 1-0061: Releasing partially loaded firmware file.
usbcore: registered new interface driver tm6000

--=-oU62t/FuuPQE3qT54QBb
Content-Disposition: attachment; filename="lsusb_-d_6000:0001_-v"
Content-Type: text/plain; name="lsusb_-d_6000:0001_-v"; charset=UTF-8
Content-Transfer-Encoding: 7bit


Bus 001 Device 022: ID 6000:0001  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x6000 
  idProduct          0x0001 
  bcdDevice            0.01
  iManufacturer          16 Trident
  iProduct               32 TVBOX
  iSerial                64 2004090820040908
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           78
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration         48 2.0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
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
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
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
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       2
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
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
        bInterval               0
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

--=-oU62t/FuuPQE3qT54QBb
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-oU62t/FuuPQE3qT54QBb--

Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39678 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1FCNeo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 09:34:44 -0400
Received: by iyb14 with SMTP id 14so1384134iyb.19
        for <linux-media@vger.kernel.org>; Fri, 03 Jun 2011 06:34:43 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Jun 2011 19:02:33 +0530
Message-ID: <BANLkTi=PunBT8D=XHSR4ycycJ=+L5WQjjg@mail.gmail.com>
Subject: TM5600 based tuner not working
From: Rajendra Mishra <rpm.indian@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi All,
   I had bought a "USB 2.0 laptop TV tuner card" (as mentioned on the device).
It has a TM5600 chip with following written on it.

TVMASTER
TM5600 B HCCO2
D49KK 1 0923
2013F0F906F071003

Downloaded the v4l code and compiled on Ubuntu 2.6.32-25-generic.

Loaded the drivers in following order.

insmod v4l1-compat.ko
insmod videodev.ko
insmod v4l2-common.ko
insmod videobuf-core.ko
insmod videobuf-vmalloc.ko
insmod tm6000.ko
insmod tea5761.ko
insmod mt20xx.ko
insmod tda9887.ko
insmod videodev.ko
insmod tea5767.ko
insmod xc5000.ko
insmod tuner-xc2028.ko
insmod tda8290.ko
insmod tuner-types.ko
insmod tuner-simple.ko
insmod tuner.ko

Kernel was able to detect the card with a usb id of (0x6000, 0x0001)
tried to load the firmware which seems to succeed.

=== LOG BEGIN ===
kernel: [ 5125.600265] usb 2-1: new high speed USB device using
ehci_hcd and address 9
kernel: [ 5125.742106] usb 2-1: configuration #1 chosen from 1 choice
kernel: [ 5125.745661] tm6000: alt 0, interface 0, class 255
kernel: [ 5125.745669] tm6000: alt 0, interface 0, class 255
kernel: [ 5125.745675] tm6000: Bulk IN endpoint: 0x82 (max size=512 bytes)
kernel: [ 5125.745681] tm6000: alt 1, interface 0, class 255
kernel: [ 5125.745686] tm6000: ISOC IN endpoint: 0x81 (max size=3072 bytes)
kernel: [ 5125.745692] tm6000: alt 1, interface 0, class 255
kernel: [ 5125.745698] tm6000: alt 2, interface 0, class 255
kernel: [ 5125.745703] tm6000: alt 2, interface 0, class 255
kernel: [ 5125.745709] tm6000: New video device @ 480 Mbps (6000:0001, ifnum 0)
kernel: [ 5125.745714] tm6000: Found 10Moons UT 821
kernel: [ 5126.524188] Board version = 0x67980cf3
kernel: [ 5126.724163] tm6000 #5: i2c eeprom 00: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5127.012071] tm6000 #5: i2c eeprom 10: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5127.300225] tm6000 #5: i2c eeprom 20: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5127.588227] tm6000 #5: i2c eeprom 30: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5127.876192] tm6000 #5: i2c eeprom 40: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5128.164118] tm6000 #5: i2c eeprom 50: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5128.456206] tm6000 #5: i2c eeprom 60: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5128.744170] tm6000 #5: i2c eeprom 70: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5129.032200] tm6000 #5: i2c eeprom 80: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5129.320109] tm6000 #5: i2c eeprom 90: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5129.604091] tm6000 #5: i2c eeprom a0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5129.892102] tm6000 #5: i2c eeprom b0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5130.181833] tm6000 #5: i2c eeprom c0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5130.468116] tm6000 #5: i2c eeprom d0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5130.764229] tm6000 #5: i2c eeprom e0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5131.053186] tm6000 #5: i2c eeprom f0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00  ................
kernel: [ 5131.320180]   ................
kernel: [ 5131.323658] tuner 5-0061: chip found @ 0xc2 (tm6000 #5)
kernel: [ 5131.323675] xc2028 5-0061: creating new instance
kernel: [ 5131.323682] xc2028 5-0061: type set to XCeive xc2028/xc3028 tuner
kernel: [ 5131.323687] Setting firmware parameters for xc2028
kernel: [ 5131.323700] usb 2-1: firmware: requesting xc3028-v24.fw
kernel: [ 5131.328769] xc2028 5-0061: Loading 77 firmware images from
xc3028-v24.fw, type: xc2028 firmware, ver 2.4
kernel: [ 5131.432183] xc2028 5-0061: Loading firmware for type=BASE
(1), id 0000000000000000.
kernel: [ 5165.608114] xc2028 5-0061: Loading firmware for type=(0),
id 000000000000b700.
kernel: [ 5166.868179] SCODE (20000000), id 000000000000b700:
kernel: [ 5166.868194] xc2028 5-0061: Loading SCODE for type=MONO
SCODE HAS_IF_4320 (60008000), id 0000000000008000.
kernel: [ 5167.328194] xc2028 5-0061: Loading firmware for type=BASE
(1), id 0000000000000000.
kernel: [ 5201.500190] xc2028 5-0061: Loading firmware for type=(0),
id 000000000000b700.
kernel: [ 5202.761170] SCODE (20000000), id 000000000000b700:
kernel: [ 5202.761186] xc2028 5-0061: Loading SCODE for type=MONO
SCODE HAS_IF_4320 (60008000), id 0000000000008000.
kernel: [ 5203.564193] xc2028 5-0061: Loading firmware for type=BASE
(1), id 0000000000000000.
kernel: [ 5237.764133] xc2028 5-0061: Loading firmware for type=(0),
id 000000000000b700.
kernel: [ 5239.028085] SCODE (20000000), id 000000000000b700:
kernel: [ 5239.028101] xc2028 5-0061: Loading SCODE for type=MONO
SCODE HAS_IF_4320 (60008000), id 0000000000008000.
kernel: [ 5239.488226] xc2028 5-0061: Loading firmware for type=BASE
(1), id 0000000000000000.
kernel: [ 5273.669181] xc2028 5-0061: Loading firmware for type=(0),
id 000000000000b700.
kernel: [ 5274.932188] SCODE (20000000), id 000000000000b700:
kernel: [ 5274.932204] xc2028 5-0061: Loading SCODE for type=MONO
SCODE HAS_IF_4320 (60008000), id 0000000000008000.
kernel: [ 5275.632325] Trident TVMaster TM5600/TM6000/TM6010 USB2
board (Load status: 0)
=== LOG END ===

Now when I try to access /dev/vide0,  I get the urb failed error messages.

I doubt that the Firmware did not load correctly. After digging into
more details, it seems that the
existing "tm6000" driver is written assuming that the device has an XC
2028 chip inside, while in my
case I do not see any such chip.

I am not much familiar with organization of these chip,
what I saw inside was only the following chips.

1. TM5600 tvmaster
2. NXD TDA9801T (VFX7K0)
3. One big receiver with TNF9022-BF written on it
4. Two more small IC's (difficult to read)

>From my debugging I concluded that since I do not have the XC2028
chip, so the firmware will not work.

The device works fine on windows XP and has the following driver files.

-r-------- 1 pm pm   3584 2011-06-01 20:20 triddev.sys
-r-------- 1 pm pm   8050 2011-06-01 20:20 tridvid.inf
-r-------- 1 pm pm 201216 2011-06-01 20:20 tridvid.sys
-r-------- 1 pm pm  28672 2011-06-01 20:20 VendorCmdRW.dll

I ran usb snoop to dump the USB packets in windows and have a log for
the same. I do
not have much of experience in doing this kind of engineering (yet !)

Here is the log of the packets I get from SnoopyPro in windows

===============
URB Header (length: 80)
SequenceNumber: 4
Function: 0017 (VENDOR_DEVICE)
PipeHandle: 8682dba8

SetupPacket:
0000: 00 07 df 00 1f 00 00 00
bmRequestType: 00
  DIR: Host-To-Device
  TYPE: Standard
  RECIPIENT: Device
bRequest: 07
  SET_DESCRIPTOR


No TransferBuffer

4       out up  n/a     0.026   CONTROL_TRANSFER        -       0x00000000
URB Header (length: 80)
SequenceNumber: 4
Function: 0008 (CONTROL_TRANSFER)
PipeHandle: 869356a8

SetupPacket:
0000: 40 07 df 00 1f 00 00 00
bmRequestType: 40
  DIR: Host-To-Device
  TYPE: Vendor
  RECIPIENT: Device
bRequest: 07


No TransferBuffer
================
(NOTE: THERE ARE MANY SUCH PACKETS, I HAVE LISTED ONLY TWO)

I have done some reverse engineering before and I am keen on making my
device work
under Linux.

Would request some pointer/guidance on how to extract the firmware from the
USB snoop log or any other alternative approach.

thanks,
~Raj

(PS: I am not in the linux-media list, would request a reply-all)

Return-path: <linux-media-owner@vger.kernel.org>
Received: from 168-93-115-130.ipv4.firstcomm.com ([168.93.115.130]:47028 "EHLO
	server2.tcghosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbbBOAfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2015 19:35:33 -0500
Received: from [63.142.161.6] (port=49244 helo=[10.10.0.242])
	by server2.tcghosting.com with esmtpa (Exim 4.84)
	(envelope-from <ron@tallent.ws>)
	id 1YMmJa-0002Dp-MA
	for linux-media@vger.kernel.org; Sat, 14 Feb 2015 17:39:59 -0600
Message-ID: <1423957059.4536.4.camel@Amy>
Subject: Driver Request
From: Ronald Tallent <ron@tallent.ws>
To: linux-media@vger.kernel.org
Date: Sat, 14 Feb 2015 17:37:39 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

Trying to get an Empia EasyCap USB video capture device to work in Ubuntu
14.04 and only audio capture works, no video capture device detected. 
Kind of new at this but I'll give you all the information I have. 
More info available upon request.

Parent Company: Geniatech
Make: MyGica
Model: iGrabber for MAC
Vendor/Product ID: [1f4d:1abe]

Opened the case and found the following text printed on the board:
   HandyCap
   v1.51
   2007-4-24

Three chips on board are:
1: empia
   EM2860
   P8367-010
   201036-01AG

2: Trident
   SAA7113H
   C2P409.00 02
   A5G11152

3: eMPIA
   Technology
   EMP202
   UT11958
   1027

uname -a:
3.13.0-45-generic #74-Ubuntu SMP Tue Jan 13 19:36:28 UTC 2015 x86_64
x86_64 x86_64 GNU/Linux

dmesg:
 [74.661399] usb 3-2: new high-speed USB device number 6 using xhci_hcd
 [74.680016] usb 3-2: New USB device found, idVendor=1f4d, idProduct=1abe
 [74.680019] usb 3-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
 [74.680021] usb 3-2: Product: USB Device
 [74.701455] usbcore: registered new interface driver snd-usb-audio

Tried loading 5 additional modules but didn't help:
   saa7115
   em28xx
   em28xx_dvb
   em28xx_rc
   em28xx_alsa

lsusb -v:
Bus 003 Device 015: ID 1f4d:1abe G-Tek Electronics Group 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1f4d G-Tek Electronics Group
  idProduct          0x1abe 
  bcdDevice            1.00
  iManufacturer           0 
  iProduct                1 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          555
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA


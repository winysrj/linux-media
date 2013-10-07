Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:36801 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab3JGUes (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Oct 2013 16:34:48 -0400
Received: from [IPv6:2a01:e35:8a98:4160:224:8cff:fe9b:8195] (unknown [IPv6:2a01:e35:8a98:4160:224:8cff:fe9b:8195])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 72777A62E1
	for <linux-media@vger.kernel.org>; Mon,  7 Oct 2013 22:34:40 +0200 (CEST)
Message-ID: <52531ADE.3000107@free.fr>
Date: Mon, 07 Oct 2013 22:34:38 +0200
From: Rodolphe M <rudy1210@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx: new board id [0213:0258]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Got this DVB-S2 USB stick from PCTV Model 461e.

Firmware for 460e does not work. Chipset must be different.

Here are data from Windows driver : PCTV Empia

PCTVEMP_x86_x64.inf

%PCTV461e.DeviceDesc% = USB28179_461e,USB\VID_2013&PID_0258           ; 
PCTV 461e

[USB28179_461e.NTx86]
Include       = ks.inf, kscaptur.inf, ksfilter.inf, bda.inf
Needs         = KS.Registration, KSCAPTUR.Registration.NT, 
BDA.Installation.NT
DelReg          = OEM.DelReg, UTL.DelReg
AddReg        = CAP.AddRegx86, OEM.AddReg, OEM.Defaults.AddReg, 
UTL.AddReg, OEM_461e.AddReg
CopyFiles     = CAP.CopySYSx86, CAP.CopyDLLx86, UTL.CopyList

[USB28179_461e.NTx86.HW]
AddReg = InstFilter28xx

[USB28179_461e.NTx86.Interfaces]
AddInterface = %KSCATEGORY_BDA_RECEIVER%,%BDACapFilter%, 
BDACap28179.Interface
AddInterface = %KSCATEGORY_BDA_TUNER%, 
%BDATunerFilter%,BDATuner28179.Interface
AddInterface = %KSCATEGORY_BDA_TUNER%, 
%BDATunerFilterC%,BDATuner28179-C.Interface
AddInterface = %KSCATEGORY_BDA_TUNER%, 
%BDATunerFilterS%,BDATuner28179-S.Interface



lsusb -vvv

Bus 001 Device 002: ID 2013:0258 PCTV Systems
Couldn't open device, some information will be missing
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x2013 PCTV Systems
   idProduct          0x0258
   bcdDevice            1.00
   iManufacturer           3
   iProduct                1
   iSerial                 2
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           41
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
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x03ac  1x 940 bytes
         bInterval               1


dmesg

[    1.283468] usb 1-1: New USB device found, idVendor=2013, idProduct=0258
[    1.283473] usb 1-1: New USB device strings: Mfr=3, Product=1, 
SerialNumber=2
[    1.283476] usb 1-1: Product: PCTV 461
[    1.283478] usb 1-1: Manufacturer: PCTV
[    1.283481] usb 1-1: SerialNumber: 0011317106


Thanks for helping to get this work...

Cheerio
Rudy


Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:45556 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZEGRfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2009 13:35:38 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate01.web.de (Postfix) with ESMTP id 91CAA10189F56
	for <linux-media@vger.kernel.org>; Thu,  7 May 2009 19:35:37 +0200 (CEST)
Received: from [93.192.143.159] (helo=[192.168.0.103])
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1M27VR-00060y-00
	for linux-media@vger.kernel.org; Thu, 07 May 2009 19:35:37 +0200
Message-ID: <4A031BE8.2080900@web.de>
Date: Thu, 07 May 2009 19:35:36 +0200
From: Reinhard Katzmann <suamor@web.de>
MIME-Version: 1.0
To: gspca list <linux-media@vger.kernel.org>
Subject: [GSPCA] Driver Development for Speed Link VAD Laplace
Content-Type: multipart/mixed;
 boundary="------------030406070005040504030904"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030406070005040504030904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I hope I'm on the correct list for gspca driver development. By
searching I came up to the old driver page and the gspca project
page http://linuxtv.org/hg/~jfrancois/gspca/

I recently bought a nice new webcam without Linux support (that was not
very important for me as I have a working webcam already but this one
has several useful features especially at work where I often don't or
can't use Linux unfortunately). The webcam is called VAD (Vicious and
Divine) Laplace from the manufacturer Speed Link.

So I thought helping to get a driver for this cam. What I can offer is
USB sniffing on a certain OS (no MAC drivers available too so there is
not much choice). I already know that the cam is not UVC compliant.

I have searched for some more hardware information than from the vendor
available but in vain (though the cam is about 1 year old already).
I know that especially the video format the webcam delivers would be
important to know for driver development.

If there are any (freeware) tools available except those USB sniffers to
find out any more hardware details please let me know, so I can help
with the driver.

The basic hardware SPECS are below and I attached USB HW information
from /proc/bus/usb/devices (with lsusb). IDs are idVendor=1ae7, 
idProduct=9003 (9004 is the other variant of the webcam in black).

- 2 MP Photo, 1.3 MP Video resolution, USB 2.0 (1.1 supported)
- 3x digital zoom, Flash, Night illumination (3 hardware buttons)
- Noise-suppressing microphone, Mute button
- Z-fold positioning, 0.6m cable CAM, 1.4m extra USB extension cable
- max. resolution 1280x960/15fps, 640x480/30fps, photo 1600x1200

Sorry, it's not really much I found out so far. But I hope that I can
be of further help for driver work. I intend to do some further tests.

I think it's most appropriate to post results on the linuxtv wiki, so
I created a new page there:
http://linuxtv.org/wiki/index.php/VAD_Laplace

Regards,

Reinhard Katzmann
-- 
Software-Engineer, Developer of User Interfaces
Project: Canorus - the next generation music score editor - 
http://canorus.berlios.de
GnuPG Public Key available on request

--------------030406070005040504030904
Content-Type: text/plain;
 name="laplace-lsusb-v.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="laplace-lsusb-v.txt"

[suamor@localhost]$ sudo lsusb -v

Bus 006 Device 008: ID 1ae7:9003  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1ae7 
  idProduct          0x9003 
  bcdDevice            2.03
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          126
    bNumInterfaces          3
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
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0 
      iInterface              0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength           40
        bInCollection           1
        baInterfaceNr( 0)       1
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Microphone
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0000
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                10
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 2
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x03
          Mute
          Volume
        bmaControls( 1)      0x00
        bmaControls( 2)      0x00
        iFeature                0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               2
        iTerminal               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]         8000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c8  1x 200 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x00
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    234 
      bInterfaceProtocol      0 
      iInterface              0 
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


--------------030406070005040504030904--

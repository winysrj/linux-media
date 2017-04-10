Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.phoenitydawn.de ([213.202.223.74]:35519 "EHLO
        mail.phoenitydawn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdDJSBV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 14:01:21 -0400
From: Daniel Roschka <danielroschka@phoenitydawn.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Quirk for webcam in MacBook Pro 2016
Date: Mon, 10 Apr 2017 20:01:18 +0200
Message-ID: <3400997.bXbnOMutrN@buzzard>
In-Reply-To: <9504811.tIhrXQ8rYn@avalon>
References: <4643839.ui0SUBUoba@buzzard> <2780663.rcqhCkWply@buzzard> <9504811.tIhrXQ8rYn@avalon>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2312073.jvMT867Xu9"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart2312073.jvMT867Xu9
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hi Laurent,

I'm really sorry for all the wrong formatting. I already took measures so it 
won't happen again.

> Your patch is now in my git tree, and I will push it upstream for v4.13
> (v4.11 will be released very soon, and given the pending pull requests for
> v4.12 in the Linux media tree I don't think I can add another one).

Thanks a lot. Highly appreciated.

> I collect USB descriptors for UVC devices. Could you please send me the
> output of
> 
> lsusb -d 05ac:8600

I guess you want the verbose output of lsusb. You'll find it in the attached 
file. It might contain more than than you expect as the iBridge device is a 
custom ARM processor (probably very similar to the one in the Apple Watch), 
not just connecting the webcam to the rest of the system, but also the Touch 
Bar and the Touch ID sensor.

Regards,
Daniel
--nextPart2312073.jvMT867Xu9
Content-Disposition: attachment; filename="ibridge-descriptors.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="ibridge-descriptors.txt"

Bus 001 Device 002: ID 05ac:8600 Apple, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x05ac Apple, Inc.
  idProduct          0x8600 
  bcdDevice            1.01
  iManufacturer           1 Apple Inc.
  iProduct                2 iBridge
  iSerial                 3 nomac?123456
  bNumConfigurations      3
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          469
    bNumInterfaces          4
    bConfigurationValue     1
    iConfiguration          5 Default iBridge Interfaces
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       1 Video Control
      bFunctionProtocol       0 
      iFunction               6 FaceTime HD Camera (Build-in)
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface             15 FaceTime HD Camera (Build-in, SN:CC264856L1KGJJM11)
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.50
        wTotalLength           54
        dwClockFrequency        1.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                18
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0 
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  3
        bmControls           0x00000000
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             2
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               1
        iTerminal               0 
      VideoControl Interface Descriptor:
        bLength                14
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
        bUnitID                 3
        bSourceID               1
        wMaxMultiplier          0
        bControlSize            4
        bmControls     0x00000000
        iProcessing             0 
        bmVideoStandards     0x 0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                      323
        bEndPointAddress                  129
        bmInfo                              0
        bTerminalLink                       2
        bStillCaptureMethod                 0
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    11
      VideoStreaming Interface Descriptor:
        bLength                            11
        bDescriptorType                    36
        bDescriptorSubtype                  6 (FORMAT_MJPEG)
        bFormatIndex                        1
        bNumFrameDescriptors                2
        bFlags                              0
          Fixed-size samples: No
        bDefaultFrameIndex                  2
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                           146
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                   276480
        dwMaxBitRate                  8294400
        dwMaxVideoFrameBufferSize      276480
        dwDefaultFrameInterval         333333
        bFrameIntervalType                 30
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            344827
        dwFrameInterval( 2)            357142
        dwFrameInterval( 3)            370370
        dwFrameInterval( 4)            384615
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            416666
        dwFrameInterval( 7)            434782
        dwFrameInterval( 8)            454545
        dwFrameInterval( 9)            476190
        dwFrameInterval(10)            500000
        dwFrameInterval(11)            526315
        dwFrameInterval(12)            555555
        dwFrameInterval(13)            588235
        dwFrameInterval(14)            625000
        dwFrameInterval(15)            666666
        dwFrameInterval(16)            714285
        dwFrameInterval(17)            769230
        dwFrameInterval(18)            833333
        dwFrameInterval(19)            909090
        dwFrameInterval(20)           1000000
        dwFrameInterval(21)           1111111
        dwFrameInterval(22)           1250000
        dwFrameInterval(23)           1428571
        dwFrameInterval(24)           1666666
        dwFrameInterval(25)           2000000
        dwFrameInterval(26)           2500000
        dwFrameInterval(27)           3333333
        dwFrameInterval(28)           5000000
        dwFrameInterval(29)          10000000
      VideoStreaming Interface Descriptor:
        bLength                           146
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                    92160
        dwMaxBitRate                  2764800
        dwMaxVideoFrameBufferSize       92160
        dwDefaultFrameInterval         333333
        bFrameIntervalType                 30
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            344827
        dwFrameInterval( 2)            357142
        dwFrameInterval( 3)            370370
        dwFrameInterval( 4)            384615
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            416666
        dwFrameInterval( 7)            434782
        dwFrameInterval( 8)            454545
        dwFrameInterval( 9)            476190
        dwFrameInterval(10)            500000
        dwFrameInterval(11)            526315
        dwFrameInterval(12)            555555
        dwFrameInterval(13)            588235
        dwFrameInterval(14)            625000
        dwFrameInterval(15)            666666
        dwFrameInterval(16)            714285
        dwFrameInterval(17)            769230
        dwFrameInterval(18)            833333
        dwFrameInterval(19)            909090
        dwFrameInterval(20)           1000000
        dwFrameInterval(21)           1111111
        dwFrameInterval(22)           1250000
        dwFrameInterval(23)           1428571
        dwFrameInterval(24)           1666666
        dwFrameInterval(25)           2000000
        dwFrameInterval(26)           2500000
        dwFrameInterval(27)           3333333
        dwFrameInterval(28)           5000000
        dwFrameInterval(29)          10000000
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      83
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
        bInterval               7
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
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
          wDescriptorLength     634
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               7
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          662
    bNumInterfaces          8
    bConfigurationValue     2
    iConfiguration          7 Default iBridge Interfaces(OS X)
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       1 Video Control
      bFunctionProtocol       0 
      iFunction               8 FaceTime HD Camera (Build-in)
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface             16 FaceTime HD Camera (Build-in, SN:CC264856L1KGJJM11)
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.50
        wTotalLength           54
        dwClockFrequency        1.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                18
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0 
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  3
        bmControls           0x00000000
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             2
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               1
        iTerminal               0 
      VideoControl Interface Descriptor:
        bLength                14
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
        bUnitID                 3
        bSourceID               1
        wMaxMultiplier          0
        bControlSize            4
        bmControls     0x00000000
        iProcessing             0 
        bmVideoStandards     0x 0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                      400
        bEndPointAddress                  129
        bmInfo                              0
        bTerminalLink                       2
        bStillCaptureMethod                 0
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    52
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 19         Invalid desc subtype: 01 02 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      VideoStreaming Interface Descriptor:
        bLength                           164
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 01 00 05 d0 02 01 00 01 00 00 4d 33 00 00 00 00 01 00 02 00 00 00 00 00 00 00 00 00 00 2d 31 01 00 2d 31 01 15 16 05 00 1e 15 16 05 00 fb 42 05 00 16 73 05 00 c2 a6 05 00 67 de 05 00 80 1a 06 00 9a 5b 06 00 5e a2 06 00 91 ef 06 00 1e 44 07 00 20 a1 07 00 eb 07 08 00 23 7a 08 00 cb f9 08 00 68 89 09 00 2a 2c 0a 00 2d e6 0a 00 ce bc 0b 00 35 b7 0c 00 22 df 0d 00 40 42 0f 00 47 f4 10 00 d0 12 13 00 5b cc 15 00 6a 6e 19 00 80 84 1e 00 a0 25 26 00 d5 dc 32 00 40 4b 4c 00 80 96 98 00
      VideoStreaming Interface Descriptor:
        bLength                           164
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 02 80 02 e0 01 01 00 01 00 00 4d 33 00 00 00 00 01 00 02 00 00 00 00 00 00 00 00 00 00 2d 31 01 00 2d 31 01 15 16 05 00 1e 15 16 05 00 fb 42 05 00 16 73 05 00 c2 a6 05 00 67 de 05 00 80 1a 06 00 9a 5b 06 00 5e a2 06 00 91 ef 06 00 1e 44 07 00 20 a1 07 00 eb 07 08 00 23 7a 08 00 cb f9 08 00 68 89 09 00 2a 2c 0a 00 2d e6 0a 00 ce bc 0b 00 35 b7 0c 00 22 df 0d 00 40 42 0f 00 47 f4 10 00 d0 12 13 00 5b cc 15 00 6a 6e 19 00 80 84 1e 00 a0 25 26 00 d5 dc 32 00 40 4b 4c 00 80 96 98 00
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
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
          wDescriptorLength     774
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
        bInterval               5
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        16 
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              10
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              10
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         2 Communications
      bInterfaceSubClass     13 
      bInterfaceProtocol      0 
      iInterface             12 NCM Control
      CDC Header:
        bcdCDC               1.10
      CDC Union:
        bMasterInterface        4
        bSlaveInterface         5 
      CDC Ethernet:
        iMacAddress                     11 ACDE48001122
        bmEthernetStatistics    0x00000000
        wMaxSegmentSize               1514
        wNumberMCFilters            0x0000
        bNumberPowerFilters              0
      CDC NCM:
        bcdNcmVersion        1.00
        bmNetworkCapabilities 0x33
          8-byte ntb input size
          crc mode
          net address
          packet filter
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      1 
      iInterface             14 NCM Data
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      1 
      iInterface             14 NCM Data
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        6
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
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
          wDescriptorLength     634
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x87  EP 7 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               7
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        7
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    249 
      bInterfaceProtocol     17 
      iInterface             13 Apple USB SEP Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          539
    bNumInterfaces          6
    bConfigurationValue     3
    iConfiguration          9 Default iBridge Interfaces(Recovery)
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       1 Video Control
      bFunctionProtocol       0 
      iFunction              10 FaceTime HD Camera (Build-in)
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface             15 FaceTime HD Camera (Build-in, SN:CC264856L1KGJJM11)
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.50
        wTotalLength           54
        dwClockFrequency        1.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                18
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0 
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  3
        bmControls           0x00000000
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             2
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               1
        iTerminal               0 
      VideoControl Interface Descriptor:
        bLength                14
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
        bUnitID                 3
        bSourceID               1
        wMaxMultiplier          0
        bControlSize            4
        bmControls     0x00000000
        iProcessing             0 
        bmVideoStandards     0x 0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                      323
        bEndPointAddress                  129
        bmInfo                              0
        bTerminalLink                       2
        bStillCaptureMethod                 0
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    11
      VideoStreaming Interface Descriptor:
        bLength                            11
        bDescriptorType                    36
        bDescriptorSubtype                  6 (FORMAT_MJPEG)
        bFormatIndex                        1
        bNumFrameDescriptors                2
        bFlags                              0
          Fixed-size samples: No
        bDefaultFrameIndex                  2
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                           146
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                   276480
        dwMaxBitRate                  8294400
        dwMaxVideoFrameBufferSize      276480
        dwDefaultFrameInterval         333333
        bFrameIntervalType                 30
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            344827
        dwFrameInterval( 2)            357142
        dwFrameInterval( 3)            370370
        dwFrameInterval( 4)            384615
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            416666
        dwFrameInterval( 7)            434782
        dwFrameInterval( 8)            454545
        dwFrameInterval( 9)            476190
        dwFrameInterval(10)            500000
        dwFrameInterval(11)            526315
        dwFrameInterval(12)            555555
        dwFrameInterval(13)            588235
        dwFrameInterval(14)            625000
        dwFrameInterval(15)            666666
        dwFrameInterval(16)            714285
        dwFrameInterval(17)            769230
        dwFrameInterval(18)            833333
        dwFrameInterval(19)            909090
        dwFrameInterval(20)           1000000
        dwFrameInterval(21)           1111111
        dwFrameInterval(22)           1250000
        dwFrameInterval(23)           1428571
        dwFrameInterval(24)           1666666
        dwFrameInterval(25)           2000000
        dwFrameInterval(26)           2500000
        dwFrameInterval(27)           3333333
        dwFrameInterval(28)           5000000
        dwFrameInterval(29)          10000000
      VideoStreaming Interface Descriptor:
        bLength                           146
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                    92160
        dwMaxBitRate                  2764800
        dwMaxVideoFrameBufferSize       92160
        dwDefaultFrameInterval         333333
        bFrameIntervalType                 30
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            344827
        dwFrameInterval( 2)            357142
        dwFrameInterval( 3)            370370
        dwFrameInterval( 4)            384615
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            416666
        dwFrameInterval( 7)            434782
        dwFrameInterval( 8)            454545
        dwFrameInterval( 9)            476190
        dwFrameInterval(10)            500000
        dwFrameInterval(11)            526315
        dwFrameInterval(12)            555555
        dwFrameInterval(13)            588235
        dwFrameInterval(14)            625000
        dwFrameInterval(15)            666666
        dwFrameInterval(16)            714285
        dwFrameInterval(17)            769230
        dwFrameInterval(18)            833333
        dwFrameInterval(19)            909090
        dwFrameInterval(20)           1000000
        dwFrameInterval(21)           1111111
        dwFrameInterval(22)           1250000
        dwFrameInterval(23)           1428571
        dwFrameInterval(24)           1666666
        dwFrameInterval(25)           2000000
        dwFrameInterval(26)           2500000
        dwFrameInterval(27)           3333333
        dwFrameInterval(28)           5000000
        dwFrameInterval(29)          10000000
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      83
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
        bInterval               7
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
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
          wDescriptorLength     634
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               7
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         2 Communications
      bInterfaceSubClass     13 
      bInterfaceProtocol      0 
      iInterface             12 NCM Control
      CDC Header:
        bcdCDC               1.10
      CDC Union:
        bMasterInterface        4
        bSlaveInterface         5 
      CDC Ethernet:
        iMacAddress                     11 ACDE48001122
        bmEthernetStatistics    0x00000000
        wMaxSegmentSize               1514
        wNumberMCFilters            0x0000
        bNumberPowerFilters              0
      CDC NCM:
        bcdNcmVersion        1.00
        bmNetworkCapabilities 0x33
          8-byte ntb input size
          crc mode
          net address
          packet filter
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      1 
      iInterface             14 NCM Data
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      1 
      iInterface             14 NCM Data
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
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
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      3
Device Status:     0x0000
  (Bus Powered)

--nextPart2312073.jvMT867Xu9--

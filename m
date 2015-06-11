Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33155 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbbFKUNd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 16:13:33 -0400
Message-ID: <1434053610.2501.5.camel@gmail.com>
Subject: Re: [PATCH] USB: uvc: add support for the Microsoft Surface Pro 3
 Cameras
From: Dennis Chen <barracks510@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Date: Thu, 11 Jun 2015 13:13:30 -0700
In-Reply-To: <6864236.zlxWyD7sh8@avalon>
References: <1433879614.3036.3.camel@gmail.com> <2450709.nghA4lNjjK@avalon>
	 <1433900441.11979.11.camel@gmail.com> <6864236.zlxWyD7sh8@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Could you please send me the output of 'lsusb -v -d 045e:07be' and 
> 'lsusb -v -
> d 045e:07bf' (running as root if possible) ?


Bus 001 Device 004: ID 045e:07bf Microsoft Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x045e Microsoft Corp.
  idProduct          0x07bf 
  bcdDevice           21.52
  iManufacturer           1 QCM
  iProduct                2 Microsoft LifeCam Rear
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength         1982
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          2 Microsoft LifeCam Rear
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              250mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         3
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               2 Microsoft LifeCam Rear
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      1 
      iInterface              2 Microsoft LifeCam Rear
      VideoControl Interface Descriptor:
        bLength                14
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.50
        wTotalLength          105
        dwClockFrequency      150.000000MHz
        bInCollection           2
        baInterfaceNr( 0)       1
        baInterfaceNr( 1)       2
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
        bmControls           0x00000a0e
          Auto-Exposure Mode
          Auto-Exposure Priority
          Exposure Time (Absolute)
          Zoom (Absolute)
          PanTilt (Absolute)
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
        bUnitID                 2
        bSourceID               1
        wMaxMultiplier          0
        bControlSize            3
        bmControls     0x0000155b
          Brightness
          Contrast
          Saturation
          Sharpness
          White Balance Temperature
          Backlight Compensation
          Power Line Frequency
          White Balance Temperature, Auto
        iProcessing             0 
        bmVideoStandards     0x 0
      VideoControl Interface Descriptor:
        bLength                29
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 4
        guidExtensionCode         {29a787c9-d359-6945-8467-ff0849fc19e8}
        bNumControl            22
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            4
        bmControls( 0)       0xbf
        bmControls( 1)       0xfb
        bmControls( 2)       0xff
        bmControls( 3)       0x00
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      7 (unknown)
        Invalid desc subtype: 0b 04 00 03 cd 3e 00 cd 3e 00
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             8
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               4
        iTerminal               0 
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             9
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID              11
        iTerminal               0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               6
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      1 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            15
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         2
        wTotalLength                      563
        bEndPointAddress                  130
        bmInfo                              0
        bTerminalLink                       8
        bStillCaptureMethod                 1
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    27
        bmaControls( 1)                    27
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        1
        bNumFrameDescriptors                9
        guidFormat                            {59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 2 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           360
        dwMinBitRate                 55296000
        dwMaxBitRate                110592000
        dwMaxVideoFrameBufferSize      460800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 73728000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x01
          Still image supported
        wWidth                            480
        wHeight                           270
        dwMinBitRate                 31104000
        dwMaxBitRate                 62208000
        dwMaxVideoFrameBufferSize      259200
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x01
          Still image supported
        wWidth                            424
        wHeight                           240
        dwMinBitRate                 24422400
        dwMaxBitRate                 48844800
        dwMaxVideoFrameBufferSize      203520
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x01
          Still image supported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                 18432000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         6
        bmCapabilities                   0x01
          Still image supported
        wWidth                            320
        wHeight                           180
        dwMinBitRate                 13824000
        dwMaxBitRate                 27648000
        dwMaxVideoFrameBufferSize      115200
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         7
        bmCapabilities                   0x01
          Still image supported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  4608000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         8
        bmCapabilities                   0x01
          Still image supported
        wWidth                           2592
        wHeight                          1944
        dwMinBitRate                161243136
        dwMaxBitRate                161243136
        dwMaxVideoFrameBufferSize    10077696
        dwDefaultFrameInterval        5000000
        bFrameIntervalType                  1
        dwFrameInterval( 0)           5000000
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         9
        bmCapabilities                   0x01
          Still image supported
        wWidth                            848
        wHeight                           480
        dwMinBitRate                 97689600
        dwMaxBitRate                195379200
        dwMaxVideoFrameBufferSize      814080
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
      VideoStreaming Interface Descriptor:
        bLength                            11
        bDescriptorType                    36
        bDescriptorSubtype                  6 (FORMAT_MJPEG)
        bFormatIndex                        2
        bNumFrameDescriptors                6
        bFlags                              1
          Fixed-size samples: Yes
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         1
        bmCapabilities                   0x01
          Still image supported
        wWidth                           1920
        wHeight                          1080
        dwMinBitRate                248832000
        dwMaxBitRate                497664000
        dwMaxVideoFrameBufferSize     4147200
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         2
        bmCapabilities                   0x01
          Still image supported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                110592000
        dwMaxBitRate                221184000
        dwMaxVideoFrameBufferSize     1843200
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         3
        bmCapabilities                   0x01
          Still image supported
        wWidth                            960
        wHeight                           540
        dwMinBitRate                 62208000
        dwMaxBitRate                124416000
        dwMaxVideoFrameBufferSize     1036800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         4
        bmCapabilities                   0x01
          Still image supported
        wWidth                           2592
        wHeight                          1944
        dwMinBitRate                604661760
        dwMaxBitRate                604661760
        dwMaxVideoFrameBufferSize    10077696
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  1
        dwFrameInterval( 0)            666666
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         5
        bmCapabilities                   0x01
          Still image supported
        wWidth                           2592
        wHeight                          1728
        dwMinBitRate                537477120
        dwMaxBitRate                537477120
        dwMaxVideoFrameBufferSize     8957952
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  1
        dwFrameInterval( 0)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         6
        bmCapabilities                   0x01
          Still image supported
        wWidth                           1296
        wHeight                           864
        dwMinBitRate                134369280
        dwMaxBitRate                268738560
        dwMaxVideoFrameBufferSize     2239488
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      1 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                     1210
        bEndPointAddress                  131
        bmInfo                              0
        bTerminalLink                       9
        bStillCaptureMethod                 1
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    52
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 19         Invalid desc subtype: 01 16 02 03 00 43 03 00 0d f5 00 00 00 00 00 00 00 f5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 01 80 07 38 04 01 00 01 00 40 42 29 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 b1 4f 01 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 02 80 07 38 04 01 00 01 00 0c 64 29 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 b1 4f 01 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 03 00 05 d0 02 01 00 01 00 40 42 20 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 c0 e1 e4 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 04 00 05 d0 02 01 00 01 00 0c 64 20 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 c0 e1 e4 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 05 c0 03 1c 02 01 00 01 00 40 42 1f 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 9f d5 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 06 c0 03 1c 02 01 00 01 00 0c 64 1f 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 9f d5 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 07 50 03 e0 01 01 00 01 00 40 42 1f 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 9f d5 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 08 50 03 e0 01 01 00 01 00 0c 64 1f 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 9f d5 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 09 80 02 e0 01 01 00 01 00 40 42 1e 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 96 98 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0a 80 02 e0 01 01 00 01 00 0c 64 1e 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 96 98 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0b 80 02 68 01 01 00 01 00 40 42 1e 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 96 98 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0c 80 02 68 01 01 00 01 00 0c 64 1e 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 96 98 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0d e0 01 0e 01 01 00 01 00 40 42 15 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 00 09 3d 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0e e0 01 0e 01 01 00 01 00 0c 64 15 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 00 09 3d 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0f a8 01 f0 00 01 00 01 00 40 42 15 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 00 09 3d 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 10 a8 01 f0 00 01 00 01 00 0c 64 15 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 00 09 3d 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 11 40 01 f0 00 01 00 01 00 40 42 14 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 12 40 01 f0 00 01 00 01 00 0c 64 14 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 13 40 01 b4 00 01 00 01 00 40 42 14 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 14 40 01 b4 00 01 00 01 00 0c 64 14 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 15 a0 00 78 00 01 00 01 00 40 42 14 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 16 a0 00 78 00 01 00 01 00 0c 64 14 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0100  1x 256 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

--------------------------------------------------


Bus 001 Device 003: ID 045e:07be Microsoft Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x045e Microsoft Corp.
  idProduct          0x07be 
  bcdDevice           21.52
  iManufacturer           1 QCM
  iProduct                2 Microsoft LifeCam Front
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength         1982
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          2 Microsoft LifeCam Front
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              250mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         3
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               2 Microsoft LifeCam Front
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      1 
      iInterface              2 Microsoft LifeCam Front
      VideoControl Interface Descriptor:
        bLength                14
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.50
        wTotalLength          105
        dwClockFrequency      150.000000MHz
        bInCollection           2
        baInterfaceNr( 0)       1
        baInterfaceNr( 1)       2
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
        bmControls           0x00000a0e
          Auto-Exposure Mode
          Auto-Exposure Priority
          Exposure Time (Absolute)
          Zoom (Absolute)
          PanTilt (Absolute)
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
        bUnitID                 2
        bSourceID               1
        wMaxMultiplier          0
        bControlSize            3
        bmControls     0x0000155b
          Brightness
          Contrast
          Saturation
          Sharpness
          White Balance Temperature
          Backlight Compensation
          Power Line Frequency
          White Balance Temperature, Auto
        iProcessing             0 
        bmVideoStandards     0x 0
      VideoControl Interface Descriptor:
        bLength                29
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 4
        guidExtensionCode         {29a787c9-d359-6945-8467-ff0849fc19e8}
        bNumControl            22
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            4
        bmControls( 0)       0xbf
        bmControls( 1)       0xfb
        bmControls( 2)       0xff
        bmControls( 3)       0x00
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      7 (unknown)
        Invalid desc subtype: 0b 04 00 03 cd 3e 00 cd 3e 00
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             8
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               4
        iTerminal               0 
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             9
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID              11
        iTerminal               0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               6
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      1 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            15
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         2
        wTotalLength                      563
        bEndPointAddress                  130
        bmInfo                              0
        bTerminalLink                       8
        bStillCaptureMethod                 1
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    27
        bmaControls( 1)                    27
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        1
        bNumFrameDescriptors                9
        guidFormat                            {59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 2 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           360
        dwMinBitRate                 55296000
        dwMaxBitRate                110592000
        dwMaxVideoFrameBufferSize      460800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 73728000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x01
          Still image supported
        wWidth                            480
        wHeight                           270
        dwMinBitRate                 31104000
        dwMaxBitRate                 62208000
        dwMaxVideoFrameBufferSize      259200
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x01
          Still image supported
        wWidth                            424
        wHeight                           240
        dwMinBitRate                 24422400
        dwMaxBitRate                 48844800
        dwMaxVideoFrameBufferSize      203520
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x01
          Still image supported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                 18432000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         6
        bmCapabilities                   0x01
          Still image supported
        wWidth                            320
        wHeight                           180
        dwMinBitRate                 13824000
        dwMaxBitRate                 27648000
        dwMaxVideoFrameBufferSize      115200
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         7
        bmCapabilities                   0x01
          Still image supported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  4608000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         8
        bmCapabilities                   0x01
          Still image supported
        wWidth                           2592
        wHeight                          1944
        dwMinBitRate                161243136
        dwMaxBitRate                161243136
        dwMaxVideoFrameBufferSize    10077696
        dwDefaultFrameInterval        5000000
        bFrameIntervalType                  1
        dwFrameInterval( 0)           5000000
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         9
        bmCapabilities                   0x01
          Still image supported
        wWidth                            848
        wHeight                           480
        dwMinBitRate                 97689600
        dwMaxBitRate                195379200
        dwMaxVideoFrameBufferSize      814080
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
      VideoStreaming Interface Descriptor:
        bLength                            11
        bDescriptorType                    36
        bDescriptorSubtype                  6 (FORMAT_MJPEG)
        bFormatIndex                        2
        bNumFrameDescriptors                6
        bFlags                              1
          Fixed-size samples: Yes
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         1
        bmCapabilities                   0x01
          Still image supported
        wWidth                           1920
        wHeight                          1080
        dwMinBitRate                248832000
        dwMaxBitRate                497664000
        dwMaxVideoFrameBufferSize     4147200
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         2
        bmCapabilities                   0x01
          Still image supported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                110592000
        dwMaxBitRate                221184000
        dwMaxVideoFrameBufferSize     1843200
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         3
        bmCapabilities                   0x01
          Still image supported
        wWidth                            960
        wHeight                           540
        dwMinBitRate                 62208000
        dwMaxBitRate                124416000
        dwMaxVideoFrameBufferSize     1036800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         4
        bmCapabilities                   0x01
          Still image supported
        wWidth                           2592
        wHeight                          1944
        dwMinBitRate                604661760
        dwMaxBitRate                604661760
        dwMaxVideoFrameBufferSize    10077696
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  1
        dwFrameInterval( 0)            666666
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         5
        bmCapabilities                   0x01
          Still image supported
        wWidth                           2592
        wHeight                          1728
        dwMinBitRate                537477120
        dwMaxBitRate                537477120
        dwMaxVideoFrameBufferSize     8957952
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  1
        dwFrameInterval( 0)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         6
        bmCapabilities                   0x01
          Still image supported
        wWidth                           1296
        wHeight                           864
        dwMinBitRate                134369280
        dwMaxBitRate                268738560
        dwMaxVideoFrameBufferSize     2239488
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      1 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                     1210
        bEndPointAddress                  131
        bmInfo                              0
        bTerminalLink                       9
        bStillCaptureMethod                 1
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    52
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 19         Invalid desc subtype: 01 16 02 03 00 43 03 00 0d f5 00 00 00 00 00 00 00 f5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 01 80 07 38 04 01 00 01 00 40 42 29 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 b1 4f 01 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 02 80 07 38 04 01 00 01 00 0c 64 29 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 b1 4f 01 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 03 00 05 d0 02 01 00 01 00 40 42 20 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 c0 e1 e4 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 04 00 05 d0 02 01 00 01 00 0c 64 20 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 c0 e1 e4 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 05 c0 03 1c 02 01 00 01 00 40 42 1f 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 9f d5 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 06 c0 03 1c 02 01 00 01 00 0c 64 1f 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 9f d5 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 07 50 03 e0 01 01 00 01 00 40 42 1f 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 9f d5 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 08 50 03 e0 01 01 00 01 00 0c 64 1f 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 9f d5 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 09 80 02 e0 01 01 00 01 00 40 42 1e 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 96 98 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0a 80 02 e0 01 01 00 01 00 0c 64 1e 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 96 98 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0b 80 02 68 01 01 00 01 00 40 42 1e 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 96 98 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0c 80 02 68 01 01 00 01 00 0c 64 1e 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 96 98 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0d e0 01 0e 01 01 00 01 00 40 42 15 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 00 09 3d 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0e e0 01 0e 01 01 00 01 00 0c 64 15 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 00 09 3d 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 0f a8 01 f0 00 01 00 01 00 40 42 15 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 00 09 3d 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 10 a8 01 f0 00 01 00 01 00 0c 64 15 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 00 09 3d 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 11 40 01 f0 00 01 00 01 00 40 42 14 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 12 40 01 f0 00 01 00 01 00 0c 64 14 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 13 40 01 b4 00 01 00 01 00 40 42 14 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 14 40 01 b4 00 01 00 01 00 0c 64 14 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 15 a0 00 78 00 01 00 01 00 40 42 14 00 00 03 00 01 00 21 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
      VideoStreaming Interface Descriptor:
        bLength                            52
        bDescriptorType                    36
        bDescriptorSubtype                 20         Invalid desc subtype: 16 a0 00 78 00 01 00 01 00 0c 64 14 00 00 03 00 01 00 2b 00 01 00 00 00 00 00 00 00 01 00 00 00 80 84 1e 00 15 16 05 00 02 15 16 05 00 2a 2c 0a 00
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0100  1x 256 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

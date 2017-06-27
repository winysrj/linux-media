Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:37871 "EHLO
        mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbdF0Jbm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 05:31:42 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail1.trendhosting.net (Postfix) with ESMTP id 7E8C8150B1
        for <linux-media@vger.kernel.org>; Tue, 27 Jun 2017 10:25:38 +0100 (BST)
Received: from mail1.trendhosting.net ([127.0.0.1])
        by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 9E84iyJsjACd for <linux-media@vger.kernel.org>;
        Tue, 27 Jun 2017 10:25:34 +0100 (BST)
From: Daniel Pocock <daniel@pocock.pro>
Subject: Logitech B990 (UVC) slow initialization, WebRTC problems
To: linux-media@vger.kernel.org
Message-ID: <f0b32584-4d70-4e32-f5a6-7a85563213e3@pocock.pro>
Date: Tue, 27 Jun 2017 11:25:35 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------29E6CDF0D4A26E4BE4BA5E30"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------29E6CDF0D4A26E4BE4BA5E30
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

(re-posted here because linux-uvc[10]'s list is a sourceforge list,
sourceforge recently bumped a lot of users off their lists by trying to
coerce them to agree to a "privacy" policy and the list archives appear
inactive[11])


Hi,

I have a Logitech B990 webcam, it is a UVC webcam:

ID 046d:0828 Logitech, Inc. HD Webcam B990


When I start guvcview, the webcam's blue lights flash for 5 - 7 seconds
and then a greenish picture appears.

If I go to the video tab in guvcview and change it from MJPG to YUYV or
H264 then the picture looks normal.

My WebRTC browser often tries to initialize the webcam but gives a
JavaScript error before it becomes ready.  It doesn't appear to work
with cheese either.

I've attached the following details:


lsusb.log  (from lsusb -v -d 046d:0828)

dmesg.out  (uvcvideo traces)

guvcview.out  (stdout/stderr from guvcview)


Is this a defect with the webcam or is it simply not supported?  I
notice it is not in the list[1].  This was originally discussed on the
Jitsi Users list[2]

Regards,

Daniel


1. http://www.ideasonboard.org/uvc/#devices
2. http://lists.jitsi.org/pipermail/users/2017-June/013268.html

10. http://www.ideasonboard.org/uvc/
11.
https://sourceforge.net/p/linux-uvc/mailman/linux-uvc-devel/?viewmonth=201705


--------------29E6CDF0D4A26E4BE4BA5E30
Content-Type: text/x-log;
 name="lsusb.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsusb.log"


Bus 001 Device 010: ID 046d:0828 Logitech, Inc. HD Webcam B990
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x046d Logitech, Inc.
  idProduct          0x0828 HD Webcam B990
  bcdDevice            0.11
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength         2334
    bNumInterfaces          4
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface              0 
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength          240
        dwClockFrequency       48.000000MHz
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
        bmControls           0x00020a2e
          Auto-Exposure Mode
          Auto-Exposure Priority
          Exposure Time (Absolute)
          Focus (Absolute)
          Zoom (Absolute)
          PanTilt (Absolute)
          Focus, Auto
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 2
        bSourceID               1
        wMaxMultiplier      16384
        bControlSize            2
        bmControls     0x0000175b
          Brightness
          Contrast
          Saturation
          Sharpness
          White Balance Temperature
          Backlight Compensation
          Gain
          Power Line Frequency
          White Balance Temperature, Auto
        iProcessing             0 
        bmVideoStandards     0x1b
          None
          NTSC - 525/60
          SECAM - 625/50
          NTSC - 625/50
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 3
        guidExtensionCode         {e48e6769-0f41-db40-a850-7420d7d8240e}
        bNumControl             9
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            2
        bmControls( 0)       0x3f
        bmControls( 1)       0x07
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                26
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 4
        guidExtensionCode         {1502e449-34f4-fe47-b158-0e885023e51b}
        bNumControl             2
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            1
        bmControls( 0)       0x03
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                28
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 6
        guidExtensionCode         {a94c5d1f-11de-8744-840d-50933c8ec8d1}
        bNumControl            20
        bNrPins                 1
        baSourceID( 0)          4
        bControlSize            3
        bmControls( 0)       0xff
        bmControls( 1)       0xff
        bmControls( 2)       0x1f
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 7
        guidExtensionCode         {212de5ff-3080-2c4e-82d9-f587d00540bd}
        bNumControl             6
        bNrPins                 1
        baSourceID( 0)          4
        bControlSize            2
        bmControls( 0)       0x00
        bmControls( 1)       0x3f
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 8
        guidExtensionCode         {b600cd9a-4adc-bd4b-bdf8-5ffbb0c0d366}
        bNumControl             6
        bNrPins                 1
        baSourceID( 0)          4
        bControlSize            2
        bmControls( 0)       0x3f
        bmControls( 1)       0x00
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 9
        guidExtensionCode         {a032c549-154f-fc4c-908a-5bce154b1cea}
        bNumControl             3
        bNrPins                 1
        baSourceID( 0)          4
        bControlSize            2
        bmControls( 0)       0x07
        bmControls( 1)       0x00
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                10
        guidExtensionCode         {41769ea2-04de-e347-8b2b-f4341aff003b}
        bNumControl             9
        bNrPins                 1
        baSourceID( 0)          4
        bControlSize            2
        bmControls( 0)       0xcf
        bmControls( 1)       0x0b
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             5
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               4
        iTerminal               0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x87  EP 7 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               8
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            16
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         3
        wTotalLength                     1634
        bEndPointAddress                  129
        bmInfo                              0
        bTerminalLink                       5
        bStillCaptureMethod                 0
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    27
        bmaControls( 1)                    27
        bmaControls( 2)                    27
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        1
        bNumFrameDescriptors                7
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
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  1536000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           176
        dwMinBitRate                  4505600
        dwMaxBitRate                 27033600
        dwMaxVideoFrameBufferSize      112640
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                  6144000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                  8110080
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         6
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           360
        dwMinBitRate                 18432000
        dwMaxBitRate                110592000
        dwMaxVideoFrameBufferSize      460800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         7
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                 73728000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize     1843200
        dwDefaultFrameInterval        1000000
        bFrameIntervalType                  2
        dwFrameInterval( 0)           1000000
        dwFrameInterval( 1)           2000000
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
      VideoStreaming Interface Descriptor:
        bLength                            28
        bDescriptorType                    36
        bDescriptorSubtype                 16 (FORMAT_FRAME_BASED)
        bFormatIndex                        2
        bNumFrameDescriptors               12
        guidFormat                            {48323634-0000-1000-8000-00aa00389b71}
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
          bVariableSize                     1
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  1536000
        dwMaxBitRate                  9216000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           176
        dwMinBitRate                  4505600
        dwMaxBitRate                 27033600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                         4
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                  6144000
        dwMaxBitRate                 36864000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                  8110080
        dwMaxBitRate                 48660480
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                         6
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           360
        dwMinBitRate                 18432000
        dwMaxBitRate                110592000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                         7
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           448
        dwMinBitRate                 28672000
        dwMaxBitRate                172032000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                         8
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           600
        dwMinBitRate                 38400000
        dwMaxBitRate                230400000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                         9
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            864
        wHeight                           480
        dwMinBitRate                 33177600
        dwMaxBitRate                199065600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                        10
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            960
        wHeight                           720
        dwMinBitRate                 55296000
        dwMaxBitRate                331776000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                        11
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1024
        wHeight                           576
        dwMinBitRate                 47185920
        dwMaxBitRate                283115520
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
        bFrameIndex                        12
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                 73728000
        dwMaxBitRate                442368000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwBytesPerLine                      0
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
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
        bFormatIndex                        3
        bNumFrameDescriptors               12
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
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  1536000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           176
        dwMinBitRate                  4505600
        dwMaxBitRate                 27033600
        dwMaxVideoFrameBufferSize      112640
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         4
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                  6144000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                  8110080
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         6
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           360
        dwMinBitRate                 18432000
        dwMaxBitRate                110592000
        dwMaxVideoFrameBufferSize      460800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         7
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           448
        dwMinBitRate                 28672000
        dwMaxBitRate                172032000
        dwMaxVideoFrameBufferSize      716800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         8
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           600
        dwMinBitRate                 38400000
        dwMaxBitRate                230400000
        dwMaxVideoFrameBufferSize      960000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         9
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            864
        wHeight                           480
        dwMinBitRate                 33177600
        dwMaxBitRate                199065600
        dwMaxVideoFrameBufferSize      829440
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        10
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            960
        wHeight                           720
        dwMinBitRate                 55296000
        dwMaxBitRate                331776000
        dwMaxVideoFrameBufferSize     1382400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        11
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1024
        wHeight                           576
        dwMinBitRate                 47185920
        dwMaxBitRate                283115520
        dwMaxVideoFrameBufferSize     1179648
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                        12
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                 73728000
        dwMaxBitRate                442368000
        dwMaxVideoFrameBufferSize     1843200
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            416666
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
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
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x00c0  1x 192 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0180  1x 384 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0280  1x 640 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0320  1x 800 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       6
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x03b0  1x 944 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       7
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0a80  2x 640 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       8
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0b20  2x 800 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       9
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0be0  2x 992 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting      10
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1380  3x 896 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting      11
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x13fc  3x 1020 bytes
        bInterval               1
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         2
      bInterfaceCount         2
      bFunctionClass          1 Audio
      bFunctionSubClass       2 Streaming
      bFunctionProtocol       0 
      iFunction               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
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
        wTotalLength           38
        bInCollection           1
        baInterfaceNr( 0)       3
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
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          1
        bSourceID               5
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 5
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x03
          Mute Control
          Volume Control
        bmaControls( 1)      0x00
        iFeature                0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
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
        tSamFreq[ 0]        16000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0044  1x 68 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       2
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
        tSamFreq[ 0]        24000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0064  1x 100 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       3
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
        tSamFreq[ 0]        32000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0084  1x 132 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       4
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
        tSamFreq[ 0]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
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



--------------29E6CDF0D4A26E4BE4BA5E30
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.out"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg.out"

WzI0ODQ5Ni4yOTM0ODhdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9vcGVuClsyNDg0OTYuMzU4Njgx
XSB1dmN2aWRlbzogUmVzdW1pbmcgaW50ZXJmYWNlIDAKWzI0ODQ5Ni4zNTg2ODVdIHV2Y3Zp
ZGVvOiBSZXN1bWluZyBpbnRlcmZhY2UgMQpbMjQ4NDk2LjM1OTc4MF0gdXZjdmlkZW86IHV2
Y192NGwyX3JlbGVhc2UKWzI0ODQ5Ni4zNjI1NjZdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9vcGVu
ClsyNDg0OTYuNDMwNzUxXSB1dmN2aWRlbzogUmVzdW1pbmcgaW50ZXJmYWNlIDAKWzI0ODQ5
Ni40MzA3NTRdIHV2Y3ZpZGVvOiBSZXN1bWluZyBpbnRlcmZhY2UgMQpbMjQ4NDk2LjQzMTQ1
M10gdXZjdmlkZW86IHV2Y192NGwyX3JlbGVhc2UKWzI0ODQ5Ni40MzQzNjJdIHV2Y3ZpZGVv
OiB1dmNfdjRsMl9vcGVuClsyNDg0OTYuNTY4MjUwXSB1dmN2aWRlbzogVHJ5aW5nIGZvcm1h
dCAweDQ3NTA0YTRkIChNSlBHKTogMTI4MHg3MjAuClsyNDg0OTYuNTY4MjUzXSB1dmN2aWRl
bzogVXNpbmcgZGVmYXVsdCBmcmFtZSBpbnRlcnZhbCAzMzMzMy4zIHVzICgzMC4wIGZwcyku
ClsyNDg0OTYuNTkzOTExXSB1dmN2aWRlbzogVHJ5aW5nIGZvcm1hdCAweDQ3NTA0YTRkIChN
SlBHKTogMTI4MHg3MjAuClsyNDg0OTYuNTkzOTE1XSB1dmN2aWRlbzogVXNpbmcgZGVmYXVs
dCBmcmFtZSBpbnRlcnZhbCAzMzMzMy4zIHVzICgzMC4wIGZwcykuClsyNDg0OTYuNjIyOTc1
XSB1dmN2aWRlbzogdXZjX3Y0bDJfbW1hcApbMjQ4NDk2LjYyMzA0Ml0gdXZjdmlkZW86IHV2
Y192NGwyX21tYXAKWzI0ODQ5Ni42MjMwOTNdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9tbWFwClsy
NDg0OTYuNjIzMTM4XSB1dmN2aWRlbzogdXZjX3Y0bDJfbW1hcApbMjQ4NDk2LjYyMzIwNF0g
dXZjdmlkZW86IFNldHRpbmcgZnJhbWUgaW50ZXJ2YWwgdG8gMS8zMCAoMzMzMzMzKS4KWzI0
ODQ5Ny4yNTcyMTVdIHV2Y3ZpZGVvOiBEZXZpY2UgcmVxdWVzdGVkIDMwNjAgQi9mcmFtZSBi
YW5kd2lkdGguClsyNDg0OTcuMjU3MjI0XSB1dmN2aWRlbzogU2VsZWN0aW5nIGFsdGVybmF0
ZSBzZXR0aW5nIDExICgzMDYwIEIvZnJhbWUgYmFuZHdpZHRoKS4KWzI0ODQ5Ny4yNTc1ODZd
IHV2Y3ZpZGVvOiBBbGxvY2F0ZWQgNSBVUkIgYnVmZmVycyBvZiAzMngzMDYwIGJ5dGVzIGVh
Y2guClsyNDg0OTcuMjU3NzAwXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NDk3LjU0
MDgxM10gdXZjdmlkZW86IEZhaWxlZCB0byBxdWVyeSAoR0VUX0NVUikgVVZDIGNvbnRyb2wg
MyBvbiB1bml0IDEwOiAwIChleHAuIDEpLgpbMjQ4NDk3LjU0NTUwMl0gdXZjdmlkZW86IEZh
aWxlZCB0byBxdWVyeSAoR0VUX0NVUikgVVZDIGNvbnRyb2wgMyBvbiB1bml0IDEwOiAwIChl
eHAuIDEpLgpbMjQ4NDk4LjI1ODgxNF0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODQ5
OC4yNzkzODZdIHV2Y3ZpZGVvOiBTZXR0aW5nIGZyYW1lIGludGVydmFsIHRvIDEvMzAgKDMz
MzMzMykuClsyNDg0OTguMzA0MDgwXSB1dmN2aWRlbzogdXZjX3Y0bDJfbW1hcApbMjQ4NDk4
LjMwNDE5Ml0gdXZjdmlkZW86IHV2Y192NGwyX21tYXAKWzI0ODQ5OC4zMDQyNjJdIHV2Y3Zp
ZGVvOiB1dmNfdjRsMl9tbWFwClsyNDg0OTguMzA0MzIzXSB1dmN2aWRlbzogdXZjX3Y0bDJf
bW1hcApbMjQ4NDk4LjMxMDUxMl0gdXZjdmlkZW86IERldmljZSByZXF1ZXN0ZWQgMzA2MCBC
L2ZyYW1lIGJhbmR3aWR0aC4KWzI0ODQ5OC4zMTA1MTddIHV2Y3ZpZGVvOiBTZWxlY3Rpbmcg
YWx0ZXJuYXRlIHNldHRpbmcgMTEgKDMwNjAgQi9mcmFtZSBiYW5kd2lkdGgpLgpbMjQ4NDk4
LjMxMDkzMV0gdXZjdmlkZW86IEFsbG9jYXRlZCA1IFVSQiBidWZmZXJzIG9mIDMyeDMwNjAg
Ynl0ZXMgZWFjaC4KWzI0ODQ5OC4zMTA5NzNdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsy
NDg0OTguNjk0MzU5XSB1dmN2aWRlbzogU3VzcGVuZGluZyBpbnRlcmZhY2UgMQpbMjQ4NDk4
LjY5NDM2NF0gdXZjdmlkZW86IFN1c3BlbmRpbmcgaW50ZXJmYWNlIDAKWzI0ODQ5OS4zMTIw
NjhdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg0OTkuMzEyMTQyXSB1dmN2aWRlbzog
dXZjX3Y0bDJfcG9sbApbMjQ4NTAwLjMxMzIzNF0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwK
WzI0ODUwMC4zMTMzMDNdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDEuMzE0NDI5
XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTAxLjMxNDUxNF0gdXZjdmlkZW86IHV2
Y192NGwyX3BvbGwKWzI0ODUwMi4zMTU2NTNdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsy
NDg1MDIuMzE1NzQ4XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTAzLjMxNjY5M10g
dXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwMy4zMTY3NzBdIHV2Y3ZpZGVvOiB1dmNf
djRsMl9wb2xsClsyNDg1MDQuMzE3ODY3XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4
NTA0LjMxNzk1MV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNS4zMTkwODZdIHV2
Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDUuMzE5MTY3XSB1dmN2aWRlbzogdXZjX3Y0
bDJfcG9sbApbMjQ4NTA1LjU4NDI1NV0gdXZjdmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0Yg
Zm91bmQpLgpbMjQ4NTA1LjU4NDI3MF0gdXZjdmlkZW86IGZyYW1lIDEgc3RhdHM6IDU4MTQ2
LzU4MTQ5LzU4MTU4IHBhY2tldHMsIDEvNDg1OTEvNTgxNTggcHRzIChlYXJseSBpbml0aWFs
KSwgNTgxNTcvNTgxNTggc2NyLCBsYXN0IHB0cy9zdGMvc29mIDE4NzYxNTIwNjkvMTkzMzU0
OTcwNy8xMDgKWzI0ODUwNS41ODQzMTBdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1
MDUuNjExMjg5XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA1LjYxNjMyM10gdXZj
dmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4NTA1LjYxNjMzN10gdXZj
dmlkZW86IGZyYW1lIDIgc3RhdHM6IDI1OS8yNjIvMjcxIHBhY2tldHMsIDAvMC8yNzEgcHRz
IChlYXJseSBpbml0aWFsKSwgMjcwLzI3MSBzY3IsIGxhc3QgcHRzL3N0Yy9zb2YgMTkzMzU1
NTM2NS8xOTM1MTc1NjYzLzE0MgpbMjQ4NTA1LjYxNjM3NF0gdXZjdmlkZW86IHV2Y192NGwy
X3BvbGwKWzI0ODUwNS42MjE1OTddIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDYu
MDgwMjA2XSB1dmN2aWRlbzogRnJhbWUgY29tcGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDYu
MDgwMjIxXSB1dmN2aWRlbzogZnJhbWUgMyBzdGF0czogMzY4MS8zNjg1LzM2OTMgcGFja2V0
cywgMC8wLzM2OTMgcHRzIChlYXJseSBpbml0aWFsKSwgMzY5Mi8zNjkzIHNjciwgbGFzdCBw
dHMvc3RjL3NvZiAxOTM1MTc4MjE1LzE5NTczMzMwNDcvNjA0ClsyNDg1MDYuMDgwMjUyXSB1
dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2LjA4NTc4OF0gdXZjdmlkZW86IHV2Y192
NGwyX3BvbGwKWzI0ODUwNi4xMDQzMDZdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9G
IGZvdW5kKS4KWzI0ODUwNi4xMDQzMTddIHV2Y3ZpZGVvOiBmcmFtZSA0IHN0YXRzOiAxOTIv
MTk1LzIwNCBwYWNrZXRzLCAwLzAvMjA0IHB0cyAoZWFybHkgaW5pdGlhbCksIDIwMy8yMDQg
c2NyLCBsYXN0IHB0cy9zdGMvc29mIDE5NTczMzU5OTQvMTk1ODU1NzAxMy82MjkKWzI0ODUw
Ni4xMDQzMzJdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDYuMTA3NjE2XSB1dmN2
aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2LjEzNjE1Nl0gdXZjdmlkZW86IEZyYW1lIGNv
bXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4NTA2LjEzNjE3OV0gdXZjdmlkZW86IHV2Y192NGwy
X3BvbGwKWzI0ODUwNi4xNDAyMzRdIHV2Y3ZpZGVvOiBmcmFtZSA1IHN0YXRzOiAyNTQvMjU3
LzI2NiBwYWNrZXRzLCAwLzAvMjY2IHB0cyAoZWFybHkgaW5pdGlhbCksIDI2NS8yNjYgc2Ny
LCBsYXN0IHB0cy9zdGMvc29mIDE5NTg1NjI2NzIvMTk2MDE1Mjk2OC82NjIKWzI0ODUwNi4x
NDA3MjldIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDYuMTU2MTc0XSB1dmN2aWRl
bzogRnJhbWUgY29tcGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDYuMTU2MTgzXSB1dmN2aWRl
bzogZnJhbWUgNiBzdGF0czogMTM1LzEzOC8xNTAgcGFja2V0cywgMC8wLzE1MCBwdHMgKGVh
cmx5IGluaXRpYWwpLCAxNDkvMTUwIHNjciwgbGFzdCBwdHMvc3RjL3NvZiAxOTYwMTU4NjAz
LzE5NjEwNTI5NDQvNjgxClsyNDg1MDYuMTU2MjE0XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9s
bApbMjQ4NTA2LjE1OTkxN10gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi4xODAy
NjFdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi4xODAy
NzBdIHV2Y3ZpZGVvOiBmcmFtZSA3IHN0YXRzOiAxODEvMTg1LzE5NyBwYWNrZXRzLCAxLzEv
MTk3IHB0cyAoZWFybHkgaW5pdGlhbCksIDE5Ni8xOTcgc2NyLCBsYXN0IHB0cy9zdGMvc29m
IDE5NjEwNTkxNTIvMTk2MjIzNDkxMS83MDYKWzI0ODUwNi4xODAyNzRdIHV2Y3ZpZGVvOiB1
dmNfdjRsMl9wb2xsClsyNDg1MDYuMTg1MDgxXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApb
MjQ4NTA2LjIwODIzMl0gdXZjdmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQpLgpb
MjQ4NTA2LjIwODI0MV0gdXZjdmlkZW86IGZyYW1lIDggc3RhdHM6IDE3MC8xNzUvMjAyIHBh
Y2tldHMsIDAvMC8yMDIgcHRzIChlYXJseSBpbml0aWFsKSwgMjAxLzIwMiBzY3IsIGxhc3Qg
cHRzL3N0Yy9zb2YgMTk2MjI0MDE5NS8xOTYzNDQ2ODc3LzczMQpbMjQ4NTA2LjIwODI3NF0g
dXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi4yMTM4ODldIHV2Y3ZpZGVvOiB1dmNf
djRsMl9wb2xsClsyNDg1MDYuMjI4MjUzXSB1dmN2aWRlbzogRnJhbWUgY29tcGxldGUgKEVP
RiBmb3VuZCkuClsyNDg1MDYuMjI4MjY2XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4
NTA2LjIzMjMyNF0gdXZjdmlkZW86IGZyYW1lIDkgc3RhdHM6IDE1Ni8xNjEvMTg3IHBhY2tl
dHMsIDAvMC8xODcgcHRzIChlYXJseSBpbml0aWFsKSwgMTg2LzE4NyBzY3IsIGxhc3QgcHRz
L3N0Yy9zb2YgMTk2MzQ1MTUyMi8xOTY0NTY4ODQ3Lzc1NApbMjQ4NTA2LjIzNDUyMl0gdXZj
dmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi4yNTIxNjFdIHV2Y3ZpZGVvOiBGcmFtZSBj
b21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi4yNTIxNzBdIHV2Y3ZpZGVvOiBmcmFtZSAx
MCBzdGF0czogMTU0LzE2MC8xODYgcGFja2V0cywgMC8wLzE4NiBwdHMgKGVhcmx5IGluaXRp
YWwpLCAxODUvMTg2IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAxOTY0NTcxMTEwLzE5NjU2ODQ4
MTUvNzc4ClsyNDg1MDYuMjUyMTc0XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2
LjI1ODc4Nl0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi4yNzIzNDZdIHV2Y3Zp
ZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi4yNzIzNThdIHV2Y3Zp
ZGVvOiBmcmFtZSAxMSBzdGF0czogMTE0LzExOC8xNDYgcGFja2V0cywgMC8wLzE0NiBwdHMg
KGVhcmx5IGluaXRpYWwpLCAxNDUvMTQ2IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAxOTY1Njg3
OTAwLzE5NjY1NjA3OTEvNzk2ClsyNDg1MDYuMjcyMzY4XSB1dmN2aWRlbzogdXZjX3Y0bDJf
cG9sbApbMjQ4NTA2LjI3Nzk3MV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi4y
OTYyMzFdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi4y
OTYyNDRdIHV2Y3ZpZGVvOiBmcmFtZSAxMiBzdGF0czogMTY0LzE2OS8xOTYgcGFja2V0cywg
MC8wLzE5NiBwdHMgKGVhcmx5IGluaXRpYWwpLCAxOTUvMTk2IHNjciwgbGFzdCBwdHMvc3Rj
L3NvZiAxOTY2NTYyODAzLzE5Njc3MzY3NTkvODIwClsyNDg1MDYuMjk2MjY1XSB1dmN2aWRl
bzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2LjMwMTQwNF0gdXZjdmlkZW86IHV2Y192NGwyX3Bv
bGwKWzI0ODUwNi4zMTYyNTddIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5k
KS4KWzI0ODUwNi4zMTYyNjddIHV2Y3ZpZGVvOiBmcmFtZSAxMyBzdGF0czogMTQ0LzE0OS8x
NzUgcGFja2V0cywgMC8wLzE3NSBwdHMgKGVhcmx5IGluaXRpYWwpLCAxNzQvMTc1IHNjciwg
bGFzdCBwdHMvc3RjL3NvZiAxOTY3NzQyNjE3LzE5Njg3ODY3MzAvODQyClsyNDg1MDYuMzE2
Mjg3XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2LjMyMTU5MF0gdXZjdmlkZW86
IHV2Y192NGwyX3BvbGwKWzI0ODUwNi4zNDAzNjFdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0
ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi4zNDAzNzBdIHV2Y3ZpZGVvOiBmcmFtZSAxNCBzdGF0
czogMTU1LzE1OC8xODYgcGFja2V0cywgMS8xLzE4NiBwdHMgKGVhcmx5IGluaXRpYWwpLCAx
ODUvMTg2IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAxOTY4NzkyNzg0LzE5Njk5MDI2OTgvODY1
ClsyNDg1MDYuMzQwMzg5XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2LjM0NzAx
OV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi4zNTYyOTZdIHV2Y3ZpZGVvOiBG
cmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi4zNTYzMTFdIHV2Y3ZpZGVvOiBm
cmFtZSAxNSBzdGF0czogMTAxLzEwNi8xMzMgcGFja2V0cywgMC8wLzEzMyBwdHMgKGVhcmx5
IGluaXRpYWwpLCAxMzIvMTMzIHNjciwgbGFzdCBwdHMvc3RjL3NvZiAxOTY5OTA3NzI3LzE5
NzA3MDA2NzUvODgyClsyNDg1MDYuMzU2MzM1XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApb
MjQ4NTA2LjM2MzEzNF0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi4zODg0MDRd
IHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi4zODg0MTRd
IHV2Y3ZpZGVvOiBmcmFtZSAxNiBzdGF0czogMjEyLzIxNi8yNDQgcGFja2V0cywgMC8wLzI0
NCBwdHMgKGVhcmx5IGluaXRpYWwpLCAyNDMvMjQ0IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAx
OTcwNzA0MTQ0LzE5NzIxNjQ2MzUvOTEzClsyNDg1MDYuMzg4NDM1XSB1dmN2aWRlbzogdXZj
X3Y0bDJfcG9sbApbMjQ4NTA2LjM5NDM4MV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0
ODUwNi40MjgzNDJdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0
ODUwNi40MjgzNTRdIHV2Y3ZpZGVvOiBmcmFtZSAxNyBzdGF0czogMjkxLzI5NS8zMjEgcGFj
a2V0cywgMC8wLzMyMSBwdHMgKGVhcmx5IGluaXRpYWwpLCAzMjAvMzIxIHNjciwgbGFzdCBw
dHMvc3RjL3NvZiAxOTcyMTY1OTg0LzE5NzQwOTA1ODMvOTUzClsyNDg1MDYuNDI4MzU4XSB1
dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2LjQzNDY0NV0gdXZjdmlkZW86IHV2Y192
NGwyX3BvbGwKWzI0ODUwNi40NTIyNDhdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9G
IGZvdW5kKS4KWzI0ODUwNi40NTIyNTldIHV2Y3ZpZGVvOiBmcmFtZSAxOCBzdGF0czogMTY2
LzE3Mi8xOTcgcGFja2V0cywgMC8wLzE5NyBwdHMgKGVhcmx5IGluaXRpYWwpLCAxOTYvMTk3
IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAxOTc0MDk2MTYzLzE5NzUyNzI1NDkvOTc3ClsyNDg1
MDYuNDUyMjY2XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2LjQ1ODIyOF0gdXZj
dmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi40ODQyODRdIHV2Y3ZpZGVvOiBGcmFtZSBj
b21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi40ODQyOTVdIHV2Y3ZpZGVvOiBmcmFtZSAx
OSBzdGF0czogMjI3LzIzMS8yNTggcGFja2V0cywgMC8wLzI1OCBwdHMgKGVhcmx5IGluaXRp
YWwpLCAyNTcvMjU4IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAxOTc1MjczODk2LzE5NzY4MjA1
MDYvMTAxMApbMjQ4NTA2LjQ4NDMwM10gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUw
Ni40OTI0NjBdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDYuNTIwMjEwXSB1dmN2
aWRlbzogRnJhbWUgY29tcGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDYuNTIwMjIzXSB1dmN2
aWRlbzogZnJhbWUgMjAgc3RhdHM6IDI0MC8yNDUvMjcxIHBhY2tldHMsIDAvMC8yNzEgcHRz
IChlYXJseSBpbml0aWFsKSwgMjcwLzI3MSBzY3IsIGxhc3QgcHRzL3N0Yy9zb2YgMTk3Njgy
NTc1Mi8xOTc4NDQ2NDYxLzEwNDMKWzI0ODUwNi41MjAyMzFdIHV2Y3ZpZGVvOiB1dmNfdjRs
Ml9wb2xsClsyNDg1MDYuNTI3MDA5XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2
LjU2NDMxNV0gdXZjdmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4NTA2
LjU2NDMyN10gdXZjdmlkZW86IGZyYW1lIDIxIHN0YXRzOiAzMTQvMzE4LzM0NSBwYWNrZXRz
LCAwLzAvMzQ1IHB0cyAoZWFybHkgaW5pdGlhbCksIDM0NC8zNDUgc2NyLCBsYXN0IHB0cy9z
dGMvc29mIDE5Nzg0NTEzNzEvMTk4MDUxNjQwMy8xMDg3ClsyNDg1MDYuNTY0MzU2XSB1dmN2
aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2LjU3MjY0M10gdXZjdmlkZW86IHV2Y192NGwy
X3BvbGwKWzI0ODUwNi41ODg0MDRdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZv
dW5kKS4KWzI0ODUwNi41ODg0MTddIHV2Y3ZpZGVvOiBmcmFtZSAyMiBzdGF0czogMTY2LzE3
MS8xOTggcGFja2V0cywgMC8wLzE5OCBwdHMgKGVhcmx5IGluaXRpYWwpLCAxOTcvMTk4IHNj
ciwgbGFzdCBwdHMvc3RjL3NvZiAxOTgwNTIwODI2LzE5ODE3MDQzNzAvMTExMQpbMjQ4NTA2
LjU4ODQ1M10gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi41OTQ5MTldIHV2Y3Zp
ZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDYuNjIwMjc2XSB1dmN2aWRlbzogRnJhbWUgY29t
cGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDYuNjIwMjg3XSB1dmN2aWRlbzogZnJhbWUgMjMg
c3RhdHM6IDIzMC8yMzQvMjYxIHBhY2tldHMsIDAvMC8yNjEgcHRzIChlYXJseSBpbml0aWFs
KSwgMjYwLzI2MSBzY3IsIGxhc3QgcHRzL3N0Yy9zb2YgMTk4MTcwNzIzOC8xOTgzMjcwMzI3
LzExNDQKWzI0ODUwNi42MjAzMTVdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDYu
NjI2OTMxXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2LjY1MjM0OV0gdXZjdmlk
ZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4NTA2LjY1MjM2MV0gdXZjdmlk
ZW86IGZyYW1lIDI0IHN0YXRzOiAyMzMvMjM2LzI2NCBwYWNrZXRzLCAxLzEvMjY0IHB0cyAo
ZWFybHkgaW5pdGlhbCksIDI2My8yNjQgc2NyLCBsYXN0IHB0cy9zdGMvc29mIDE5ODMyNzY1
ODgvMTk4NDg1NDI4Mi8xMTc3ClsyNDg1MDYuNjUyMzgzXSB1dmN2aWRlbzogdXZjX3Y0bDJf
cG9sbApbMjQ4NTA2LjY1OTc5NV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi42
OTYyMTddIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi42
OTYyMzFdIHV2Y3ZpZGVvOiBmcmFtZSAyNSBzdGF0czogMzE4LzMyMy8zNTAgcGFja2V0cywg
MC8wLzM1MCBwdHMgKGVhcmx5IGluaXRpYWwpLCAzNDkvMzUwIHNjciwgbGFzdCBwdHMvc3Rj
L3NvZiAxOTg0ODU5NTgzLzE5ODY5NTQyMjQvMTIyMQpbMjQ4NTA2LjY5NjI2MV0gdXZjdmlk
ZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi43MDI5ODRdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9w
b2xsClsyNDg1MDYuNzIwMzEyXSB1dmN2aWRlbzogRnJhbWUgY29tcGxldGUgKEVPRiBmb3Vu
ZCkuClsyNDg1MDYuNzIwMzIyXSB1dmN2aWRlbzogZnJhbWUgMjYgc3RhdHM6IDE2NS8xNjcv
MTk2IHBhY2tldHMsIDAvMC8xOTYgcHRzIChlYXJseSBpbml0aWFsKSwgMTk1LzE5NiBzY3Is
IGxhc3QgcHRzL3N0Yy9zb2YgMTk4Njk1ODIwNy8xOTg4MTMwMTkxLzEyNDUKWzI0ODUwNi43
MjAzMjldIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDYuNzI2OTg2XSB1dmN2aWRl
bzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2Ljc1MjE4MV0gdXZjdmlkZW86IEZyYW1lIGNvbXBs
ZXRlIChFT0YgZm91bmQpLgpbMjQ4NTA2Ljc1MjE5MF0gdXZjdmlkZW86IGZyYW1lIDI3IHN0
YXRzOiAyMjcvMjMyLzI1OSBwYWNrZXRzLCAxLzEvMjU5IHB0cyAoZWFybHkgaW5pdGlhbCks
IDI1OC8yNTkgc2NyLCBsYXN0IHB0cy9zdGMvc29mIDE5ODgxMzY5MTYvMTk4OTY4NDE0OS8x
Mjc4ClsyNDg1MDYuNzUyMjIyXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2Ljc1
Njc1NV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi43ODgzMzFdIHV2Y3ZpZGVv
OiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi43ODgzNDFdIHV2Y3ZpZGVv
OiBmcmFtZSAyOCBzdGF0czogMjQ1LzI1MC8yNzUgcGFja2V0cywgMC8wLzI3NSBwdHMgKGVh
cmx5IGluaXRpYWwpLCAyNzQvMjc1IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAxOTg5Njg1MTI1
LzE5OTEzMzQxMDMvMTMxMgpbMjQ4NTA2Ljc4ODM2MF0gdXZjdmlkZW86IHV2Y192NGwyX3Bv
bGwKWzI0ODUwNi43OTMxMjNdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDYuODMy
MjE3XSB1dmN2aWRlbzogRnJhbWUgY29tcGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDYuODMy
MjI3XSB1dmN2aWRlbzogZnJhbWUgMjkgc3RhdHM6IDMxOS8zMjMvMzUwIHBhY2tldHMsIDAv
MC8zNTAgcHRzIChlYXJseSBpbml0aWFsKSwgMzQ5LzM1MCBzY3IsIGxhc3QgcHRzL3N0Yy9z
b2YgMTk5MTMzOTUwNy8xOTkzNDM0MDQzLzEzNTYKWzI0ODUwNi44MzIyNTldIHV2Y3ZpZGVv
OiB1dmNfdjRsMl9wb2xsClsyNDg1MDYuODM2OTY2XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9s
bApbMjQ4NTA2Ljg1NjMyMF0gdXZjdmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQp
LgpbMjQ4NTA2Ljg1NjMyOF0gdXZjdmlkZW86IGZyYW1lIDMwIHN0YXRzOiAxNjQvMTcwLzE5
NiBwYWNrZXRzLCAwLzAvMTk2IHB0cyAoZWFybHkgaW5pdGlhbCksIDE5NS8xOTYgc2NyLCBs
YXN0IHB0cy9zdGMvc29mIDE5OTM0MzUxNTcvMTk5NDYxMDAxMS8xMzgwClsyNDg1MDYuODU2
MzYxXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2Ljg2MTE4Nl0gdXZjdmlkZW86
IHV2Y192NGwyX3BvbGwKWzI0ODUwNi44ODgzODRdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0
ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNi44ODgzOTNdIHV2Y3ZpZGVvOiBmcmFtZSAzMSBzdGF0
czogMjIyLzIyNy8yNTMgcGFja2V0cywgMC8wLzI1MyBwdHMgKGVhcmx5IGluaXRpYWwpLCAy
NTIvMjUzIHNjciwgbGFzdCBwdHMvc3RjL3NvZiAxOTk0NjE1NDE4LzE5OTYxMjc5NjgvMTQx
MgpbMjQ4NTA2Ljg4ODQyNl0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi44OTMw
OTJdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDYuOTIwNDQxXSB1dmN2aWRlbzog
RnJhbWUgY29tcGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDYuOTIwNDUxXSB1dmN2aWRlbzog
ZnJhbWUgMzIgc3RhdHM6IDIzNC8yNDAvMjY1IHBhY2tldHMsIDAvMC8yNjUgcHRzIChlYXJs
eSBpbml0aWFsKSwgMjY0LzI2NSBzY3IsIGxhc3QgcHRzL3N0Yy9zb2YgMTk5NjEzMzkzNS8x
OTk3NzE3OTI1LzE0NDUKWzI0ODUwNi45MjA0ODJdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xs
ClsyNDg1MDYuOTI1MzMxXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA2Ljk2NDM2
MV0gdXZjdmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4NTA2Ljk2NDM3
N10gdXZjdmlkZW86IGZyYW1lIDMzIHN0YXRzOiAzMTgvMzIzLzM1MCBwYWNrZXRzLCAwLzAv
MzUwIHB0cyAoZWFybHkgaW5pdGlhbCksIDM0OS8zNTAgc2NyLCBsYXN0IHB0cy9zdGMvc29m
IDE5OTc3MTk0OTkvMTk5OTgxNzg2Ni8xNDg5ClsyNDg1MDYuOTY0NDIyXSB1dmN2aWRlbzog
dXZjX3Y0bDJfcG9sbApbMjQ4NTA2Ljk3MDQ4M10gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwK
WzI0ODUwNi45ODg0NDRdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4K
WzI0ODUwNi45ODg0NTRdIHV2Y3ZpZGVvOiBmcmFtZSAzNCBzdGF0czogMTY1LzE3MC8xOTYg
cGFja2V0cywgMC8wLzE5NiBwdHMgKGVhcmx5IGluaXRpYWwpLCAxOTUvMTk2IHNjciwgbGFz
dCBwdHMvc3RjL3NvZiAxOTk5ODIxODcwLzIwMDA5OTM4MzQvMTUxMwpbMjQ4NTA2Ljk4ODQ4
Nl0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNi45OTQwNThdIHV2Y3ZpZGVvOiB1
dmNfdjRsMl9wb2xsClsyNDg1MDcuMDIwMzEwXSB1dmN2aWRlbzogRnJhbWUgY29tcGxldGUg
KEVPRiBmb3VuZCkuClsyNDg1MDcuMDIwMzE5XSB1dmN2aWRlbzogZnJhbWUgMzUgc3RhdHM6
IDIyOC8yMzIvMjYwIHBhY2tldHMsIDAvMC8yNjAgcHRzIChlYXJseSBpbml0aWFsKSwgMjU5
LzI2MCBzY3IsIGxhc3QgcHRzL3N0Yy9zb2YgMjAwMDk5NjM0MS8yMDAyNTUzNzkxLzE1NDYK
WzI0ODUwNy4wMjAzMzNdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDcuMDI1NzMx
XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA3LjA1NjIzNV0gdXZjdmlkZW86IEZy
YW1lIGNvbXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4NTA3LjA1NjI0OF0gdXZjdmlkZW86IGZy
YW1lIDM2IHN0YXRzOiAyMzUvMjM4LzI2NyBwYWNrZXRzLCAwLzAvMjY3IHB0cyAoZWFybHkg
aW5pdGlhbCksIDI2Ni8yNjcgc2NyLCBsYXN0IHB0cy9zdGMvc29mIDIwMDI1NTU5NDAvMjAw
NDE1NTc0Ni8xNTc5ClsyNDg1MDcuMDU2MjgyXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApb
MjQ4NTA3LjA2MzA5NF0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy4xMDAzNDRd
IHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNy4xMDAzNjBd
IHV2Y3ZpZGVvOiBmcmFtZSAzNyBzdGF0czogMzE4LzMyMi8zNDkgcGFja2V0cywgMC8wLzM0
OSBwdHMgKGVhcmx5IGluaXRpYWwpLCAzNDgvMzQ5IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAy
MDA0MTYwMTE3LzIwMDYyNDk2ODcvMTYyMwpbMjQ4NTA3LjEwMDQxMF0gdXZjdmlkZW86IHV2
Y192NGwyX3BvbGwKWzI0ODUwNy4xMDYxMzddIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsy
NDg1MDcuMTI0NDUxXSB1dmN2aWRlbzogRnJhbWUgY29tcGxldGUgKEVPRiBmb3VuZCkuClsy
NDg1MDcuMTI0NDYxXSB1dmN2aWRlbzogZnJhbWUgMzggc3RhdHM6IDE3NC8xNzgvMjA2IHBh
Y2tldHMsIDAvMC8yMDYgcHRzIChlYXJseSBpbml0aWFsKSwgMjA1LzIwNiBzY3IsIGxhc3Qg
cHRzL3N0Yy9zb2YgMjAwNjI1MjUzNi8yMDA3NDg1NjUzLzE2NDgKWzI0ODUwNy4xMjQ0ODFd
IHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDcuMTMxMTUzXSB1dmN2aWRlbzogdXZj
X3Y0bDJfcG9sbApbMjQ4NTA3LjE1NjMwMF0gdXZjdmlkZW86IEZyYW1lIGNvbXBsZXRlIChF
T0YgZm91bmQpLgpbMjQ4NTA3LjE1NjMxMV0gdXZjdmlkZW86IGZyYW1lIDM5IHN0YXRzOiAy
MjEvMjI2LzI1MyBwYWNrZXRzLCAwLzAvMjUzIHB0cyAoZWFybHkgaW5pdGlhbCksIDI1Mi8y
NTMgc2NyLCBsYXN0IHB0cy9zdGMvc29mIDIwMDc0OTA4NjIvMjAwOTAwMzYxMS8xNjgwClsy
NDg1MDcuMTU2MzQ0XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA3LjE2MjM0N10g
dXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy4xODgzODFdIHV2Y3ZpZGVvOiBGcmFt
ZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNy4xODgzOThdIHV2Y3ZpZGVvOiBmcmFt
ZSA0MCBzdGF0czogMjM4LzI0NC8yNjkgcGFja2V0cywgMS8xLzI2OSBwdHMgKGVhcmx5IGlu
aXRpYWwpLCAyNjgvMjY5IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDA5MDEwMjk4LzIwMTA2
MTc1NjUvMTcxNApbMjQ4NTA3LjE4ODQzN10gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0
ODUwNy4xOTg1MzZdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDcuMjMyMjU5XSB1
dmN2aWRlbzogRnJhbWUgY29tcGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDcuMjMyMjcyXSB1
dmN2aWRlbzogZnJhbWUgNDEgc3RhdHM6IDMxMS8zMTMvMzQyIHBhY2tldHMsIDAvMC8zNDIg
cHRzIChlYXJseSBpbml0aWFsKSwgMzQxLzM0MiBzY3IsIGxhc3QgcHRzL3N0Yy9zb2YgMjAx
MDYxOTY5OC8yMDEyNjY5NTA5LzE3NTYKWzI0ODUwNy4yMzIzMDhdIHV2Y3ZpZGVvOiB1dmNf
djRsMl9wb2xsClsyNDg1MDcuMjM5NzcyXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4
NTA3LjI1NjM2N10gdXZjdmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4
NTA3LjI1NjM3OV0gdXZjdmlkZW86IGZyYW1lIDQyIHN0YXRzOiAxNjQvMTcwLzE5NiBwYWNr
ZXRzLCAxLzEvMTk2IHB0cyAoZWFybHkgaW5pdGlhbCksIDE5NS8xOTYgc2NyLCBsYXN0IHB0
cy9zdGMvc29mIDIwMTI2NzYzMTQvMjAxMzg0NTQ3NS8xNzgxClsyNDg1MDcuMjU2NDEyXSB1
dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA3LjI2MzA4OV0gdXZjdmlkZW86IHV2Y192
NGwyX3BvbGwKWzI0ODUwNy4yODg0MThdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9G
IGZvdW5kKS4KWzI0ODUwNy4yODg0MzNdIHV2Y3ZpZGVvOiBmcmFtZSA0MyBzdGF0czogMjI1
LzIyOC8yNTYgcGFja2V0cywgMC8wLzI1NiBwdHMgKGVhcmx5IGluaXRpYWwpLCAyNTUvMjU2
IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDEzODQ3NTE5LzIwMTUzODE0MzQvMTgxMwpbMjQ4
NTA3LjI4ODQ3M10gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy4yOTU1MThdIHV2
Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDcuMzI0MzI5XSB1dmN2aWRlbzogRnJhbWUg
Y29tcGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDcuMzI0MzM5XSB1dmN2aWRlbzogZnJhbWUg
NDQgc3RhdHM6IDIzNy8yNDAvMjY5IHBhY2tldHMsIDAvMC8yNjkgcHRzIChlYXJseSBpbml0
aWFsKSwgMjY4LzI2OSBzY3IsIGxhc3QgcHRzL3N0Yy9zb2YgMjAxNTM4MzI1Mi8yMDE2OTk1
Mzg3LzE4NDcKWzI0ODUwNy4zMjQzNDVdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1
MDcuMzMyMzg4XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA3LjM2ODQyOV0gdXZj
dmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4NTA3LjM2ODQ0NV0gdXZj
dmlkZW86IGZyYW1lIDQ1IHN0YXRzOiAzMjAvMzI1LzM1MiBwYWNrZXRzLCAwLzAvMzUyIHB0
cyAoZWFybHkgaW5pdGlhbCksIDM1MS8zNTIgc2NyLCBsYXN0IHB0cy9zdGMvc29mIDIwMTY5
OTc4MDUvMjAxOTEwNzMzMC8xODkxClsyNDg1MDcuMzY4NDg5XSB1dmN2aWRlbzogdXZjX3Y0
bDJfcG9sbApbMjQ4NTA3LjM3NzQ3N10gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUw
Ny4zOTIzMzBdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUw
Ny4zOTIzNDldIHV2Y3ZpZGVvOiBmcmFtZSA0NiBzdGF0czogMTcyLzE3NS8yMDMgcGFja2V0
cywgMC8wLzIwMyBwdHMgKGVhcmx5IGluaXRpYWwpLCAyMDIvMjAzIHNjciwgbGFzdCBwdHMv
c3RjL3NvZiAyMDE5MTEyNDE1LzIwMjAzMjUyOTUvMTkxNgpbMjQ4NTA3LjM5MjM4NV0gdXZj
dmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy40MDEyNDFdIHV2Y3ZpZGVvOiB1dmNfdjRs
Ml9wb2xsClsyNDg1MDcuNDI0MzY0XSB1dmN2aWRlbzogRnJhbWUgY29tcGxldGUgKEVPRiBm
b3VuZCkuClsyNDg1MDcuNDI0Mzg0XSB1dmN2aWRlbzogZnJhbWUgNDcgc3RhdHM6IDIxOS8y
MjMvMjUwIHBhY2tldHMsIDAvMC8yNTAgcHRzIChlYXJseSBpbml0aWFsKSwgMjQ5LzI1MCBz
Y3IsIGxhc3QgcHRzL3N0Yy9zb2YgMjAyMDMyNjM0MC8yMDIxODI1MjUzLzE5NDcKWzI0ODUw
Ny40MjQ0NDJdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDcuNDMwNjk4XSB1dmN2
aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA3LjQ1NjQyMV0gdXZjdmlkZW86IEZyYW1lIGNv
bXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4NTA3LjQ1NjQzMl0gdXZjdmlkZW86IGZyYW1lIDQ4
IHN0YXRzOiAyMzQvMjM5LzI2NiBwYWNrZXRzLCAwLzAvMjY2IHB0cyAoZWFybHkgaW5pdGlh
bCksIDI2NS8yNjYgc2NyLCBsYXN0IHB0cy9zdGMvc29mIDIwMjE4MjY3NzEvMjAyMzQyMTIx
MC8xOTgwClsyNDg1MDcuNDU2NDYwXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA3
LjQ2MzUyOV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy41MDAzMjZdIHV2Y3Zp
ZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNy41MDAzNDBdIHV2Y3Zp
ZGVvOiBmcmFtZSA0OSBzdGF0czogMzIwLzMyNS8zNTIgcGFja2V0cywgMC8wLzM1MiBwdHMg
KGVhcmx5IGluaXRpYWwpLCAzNTEvMzUyIHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDIzNDI2
MDk4LzIwMjU1MzMxNTEvMjAyNApbMjQ4NTA3LjUwMDM3N10gdXZjdmlkZW86IHV2Y192NGwy
X3BvbGwKWzI0ODUwNy41MDU1ODVdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDcu
NTI0NDIxXSB1dmN2aWRlbzogRnJhbWUgY29tcGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDcu
NTI0NDMzXSB1dmN2aWRlbzogZnJhbWUgNTAgc3RhdHM6IDE2NC8xNzEvMTk2IHBhY2tldHMs
IDAvMC8xOTYgcHRzIChlYXJseSBpbml0aWFsKSwgMTk1LzE5NiBzY3IsIGxhc3QgcHRzL3N0
Yy9zb2YgMjAyNTUzNDkxOS8yMDI2NzA5MTE3LzEKWzI0ODUwNy41MjQ0NzBdIHV2Y3ZpZGVv
OiB1dmNfdjRsMl9wb2xsClsyNDg1MDcuNTMwMjU1XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9s
bApbMjQ4NTA3LjU1NjI3Nl0gdXZjdmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQp
LgpbMjQ4NTA3LjU1NjI4N10gdXZjdmlkZW86IGZyYW1lIDUxIHN0YXRzOiAyMjUvMjMxLzI1
NyBwYWNrZXRzLCAwLzAvMjU3IHB0cyAoZWFybHkgaW5pdGlhbCksIDI1Ni8yNTcgc2NyLCBs
YXN0IHB0cy9zdGMvc29mIDIwMjY3MTA1MzgvMjAyODI1MTA3NC8zMwpbMjQ4NTA3LjU1NjI5
Ml0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy41NjE4MzJdIHV2Y3ZpZGVvOiB1
dmNfdjRsMl9wb2xsClsyNDg1MDcuNTg4MzY0XSB1dmN2aWRlbzogRnJhbWUgY29tcGxldGUg
KEVPRiBmb3VuZCkuClsyNDg1MDcuNTg4NDA4XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApb
MjQ4NTA3LjU5MjQyMV0gdXZjdmlkZW86IGZyYW1lIDUyIHN0YXRzOiAyMzUvMjM4LzI2NiBw
YWNrZXRzLCAwLzAvMjY2IHB0cyAoZWFybHkgaW5pdGlhbCksIDI2NS8yNjYgc2NyLCBsYXN0
IHB0cy9zdGMvc29mIDIwMjgyNTIzNDgvMjAyOTg0NzAzMS82NgpbMjQ4NTA3LjU5NTM1N10g
dXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy42MzYzMjVdIHV2Y3ZpZGVvOiBGcmFt
ZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNy42MzYzMzhdIHV2Y3ZpZGVvOiBmcmFt
ZSA1MyBzdGF0czogMzIxLzMyNS8zNTQgcGFja2V0cywgMC8wLzM1NCBwdHMgKGVhcmx5IGlu
aXRpYWwpLCAzNTMvMzU0IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDI5ODUyNDIzLzIwMzE5
NzA5NzEvMTExClsyNDg1MDcuNjM2Mzc3XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4
NTA3LjY0NTI0N10gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy42NjA0MTldIHV2
Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNy42NjA0MzBdIHV2
Y3ZpZGVvOiBmcmFtZSA1NCBzdGF0czogMTY1LzE2OC8xOTUgcGFja2V0cywgMC8wLzE5NSBw
dHMgKGVhcmx5IGluaXRpYWwpLCAxOTQvMTk1IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDMx
OTczMzk3LzIwMzMxNDA5MzgvMTM1ClsyNDg1MDcuNjYwNDYzXSB1dmN2aWRlbzogdXZjX3Y0
bDJfcG9sbApbMjQ4NTA3LjY2ODg1NV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUw
Ny42OTIyNTldIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUw
Ny42OTIyNjldIHV2Y3ZpZGVvOiBmcmFtZSA1NSBzdGF0czogMjI1LzIyNy8yNTYgcGFja2V0
cywgMC8wLzI1NiBwdHMgKGVhcmx5IGluaXRpYWwpLCAyNTUvMjU2IHNjciwgbGFzdCBwdHMv
c3RjL3NvZiAyMDMzMTQ1OTk5LzIwMzQ2NzY4OTUvMTY3ClsyNDg1MDcuNjkyMjg4XSB1dmN2
aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA3LjY5OTc3MF0gdXZjdmlkZW86IHV2Y192NGwy
X3BvbGwKWzI0ODUwNy43MjQzNDBdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZv
dW5kKS4KWzI0ODUwNy43MjQzNTFdIHV2Y3ZpZGVvOiBmcmFtZSA1NiBzdGF0czogMjQ0LzI0
OC8yNzUgcGFja2V0cywgMC8wLzI3NSBwdHMgKGVhcmx5IGluaXRpYWwpLCAyNzQvMjc1IHNj
ciwgbGFzdCBwdHMvc3RjL3NvZiAyMDM0Njc5MTE3LzIwMzYzMjY4NTAvMjAxClsyNDg1MDcu
NzI0Mzg1XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA3LjczMTIyMl0gdXZjdmlk
ZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy43Njg0MjZdIHV2Y3ZpZGVvOiBGcmFtZSBjb21w
bGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNy43Njg0MzldIHV2Y3ZpZGVvOiBmcmFtZSA1NyBz
dGF0czogMzE0LzMxNy8zNDUgcGFja2V0cywgMS8xLzM0NSBwdHMgKGVhcmx5IGluaXRpYWwp
LCAzNDQvMzQ1IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDM2MzMzMzI0LzIwMzgzOTY3OTIv
MjQ0ClsyNDg1MDcuNzY4NDU2XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA3Ljc3
NTAzNV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy43OTIzNDhdIHV2Y3ZpZGVv
OiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNy43OTIzNjZdIHV2Y3ZpZGVv
OiBmcmFtZSA1OCBzdGF0czogMTYzLzE2Ni8xOTQgcGFja2V0cywgMC8wLzE5NCBwdHMgKGVh
cmx5IGluaXRpYWwpLCAxOTMvMTk0IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDM4NDAwOTQz
LzIwMzk1NjA3NTkvMjY5ClsyNDg1MDcuNzkyMzc5XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9s
bApbMjQ4NTA3LjgwMDA3OF0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy44MjQz
ODBdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNy44MjQz
OTFdIHV2Y3ZpZGVvOiBmcmFtZSA1OSBzdGF0czogMjI3LzIzMS8yNTggcGFja2V0cywgMC8w
LzI1OCBwdHMgKGVhcmx5IGluaXRpYWwpLCAyNTcvMjU4IHNjciwgbGFzdCBwdHMvc3RjL3Nv
ZiAyMDM5NTY1NDM4LzIwNDExMDg3MTUvMzAxClsyNDg1MDcuODI0Mzk1XSB1dmN2aWRlbzog
dXZjX3Y0bDJfcG9sbApbMjQ4NTA3LjgzMDQ2Ml0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwK
WzI0ODUwNy44NTY0NDBdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4K
WzI0ODUwNy44NTY0NjldIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDcuODYwMjg5
XSB1dmN2aWRlbzogZnJhbWUgNjAgc3RhdHM6IDIzNi8yNDIvMjY3IHBhY2tldHMsIDAvMC8y
NjcgcHRzIChlYXJseSBpbml0aWFsKSwgMjY2LzI2NyBzY3IsIGxhc3QgcHRzL3N0Yy9zb2Yg
MjA0MTExNDA4MS8yMDQyNzEwNjcxLzMzNApbMjQ4NTA3Ljg2MjY2Ml0gdXZjdmlkZW86IHV2
Y192NGwyX3BvbGwKWzI0ODUwNy45MDAzNjZdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAo
RU9GIGZvdW5kKS4KWzI0ODUwNy45MDA0MDddIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsy
NDg1MDcuOTA0NDAzXSB1dmN2aWRlbzogZnJhbWUgNjEgc3RhdHM6IDMyMS8zMjQvMzUyIHBh
Y2tldHMsIDAvMC8zNTIgcHRzIChlYXJseSBpbml0aWFsKSwgMzUxLzM1MiBzY3IsIGxhc3Qg
cHRzL3N0Yy9zb2YgMjA0MjcxMzUwNC8yMDQ0ODIyNjEzLzM3OApbMjQ4NTA3LjkwNjkwMF0g
dXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy45MjgzMDVdIHV2Y3ZpZGVvOiBGcmFt
ZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNy45MjgzMTZdIHV2Y3ZpZGVvOiBmcmFt
ZSA2MiBzdGF0czogMTczLzE3NS8yMDMgcGFja2V0cywgMC8wLzIwMyBwdHMgKGVhcmx5IGlu
aXRpYWwpLCAyMDIvMjAzIHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDQ0ODI0ODk5LzIwNDYw
NDA1NzgvNDA0ClsyNDg1MDcuOTI4MzQyXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4
NTA3LjkzNjM4N10gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwNy45NjAzNDhdIHV2
Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwNy45NjAzNTddIHV2
Y3ZpZGVvOiBmcmFtZSA2MyBzdGF0czogMjI0LzIyNy8yNTUgcGFja2V0cywgMS8xLzI1NSBw
dHMgKGVhcmx5IGluaXRpYWwpLCAyNTQvMjU1IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDQ2
MDQ3MDE0LzIwNDc1NzA1MzYvNDM2ClsyNDg1MDcuOTYwMzk0XSB1dmN2aWRlbzogdXZjX3Y0
bDJfcG9sbApbMjQ4NTA3Ljk2NzkyNl0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUw
Ny45OTI0MjFdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUw
Ny45OTI0MjldIHV2Y3ZpZGVvOiBmcmFtZSA2NCBzdGF0czogMjMzLzIzNy8yNjQgcGFja2V0
cywgMC8wLzI2NCBwdHMgKGVhcmx5IGluaXRpYWwpLCAyNjMvMjY0IHNjciwgbGFzdCBwdHMv
c3RjL3NvZiAyMDQ3NTcyNDE2LzIwNDkxNTQ0OTEvNDY5ClsyNDg1MDcuOTkyNDU5XSB1dmN2
aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA3Ljk5ODcxOF0gdXZjdmlkZW86IHV2Y192NGwy
X3BvbGwKWzI0ODUwOC4wMzYzMTZdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZv
dW5kKS4KWzI0ODUwOC4wMzYzMzNdIHV2Y3ZpZGVvOiBmcmFtZSA2NSBzdGF0czogMzE5LzMy
Ni8zNTEgcGFja2V0cywgMC8wLzM1MSBwdHMgKGVhcmx5IGluaXRpYWwpLCAzNTAvMzUxIHNj
ciwgbGFzdCBwdHMvc3RjL3NvZiAyMDQ5MTU4ODQyLzIwNTEyNjA0MzIvNTEyClsyNDg1MDgu
MDM2MzU0XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA4LjA0MTk4NF0gdXZjdmlk
ZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC4wNjA0MDddIHV2Y3ZpZGVvOiBGcmFtZSBjb21w
bGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwOC4wNjA0MTZdIHV2Y3ZpZGVvOiBmcmFtZSA2NiBz
dGF0czogMTY0LzE2OC8xOTUgcGFja2V0cywgMC8wLzE5NSBwdHMgKGVhcmx5IGluaXRpYWwp
LCAxOTQvMTk1IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDUxMjYzNzU5LzIwNTI0MzA0MDAv
NTM3ClsyNDg1MDguMDYwNDUxXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA4LjA2
NjkwOF0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC4wOTI0NTRdIHV2Y3ZpZGVv
OiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwOC4wOTI0NjNdIHV2Y3ZpZGVv
OiBmcmFtZSA2NyBzdGF0czogMjI1LzIyOC8yNTYgcGFja2V0cywgMC8wLzI1NiBwdHMgKGVh
cmx5IGluaXRpYWwpLCAyNTUvMjU2IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDUyNDMyNzk1
LzIwNTM5NjYzNTcvNTY5ClsyNDg1MDguMDkyNDk1XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9s
bApbMjQ4NTA4LjA5Nzk3MF0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC4xMjQz
MjldIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwOC4xMjQz
OTFdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDguMTI4NDE3XSB1dmN2aWRlbzog
ZnJhbWUgNjggc3RhdHM6IDIzNi8yNDAvMjY4IHBhY2tldHMsIDAvMC8yNjggcHRzIChlYXJs
eSBpbml0aWFsKSwgMjY3LzI2OCBzY3IsIGxhc3QgcHRzL3N0Yy9zb2YgMjA1Mzk2OTUwOC8y
MDU1NTc0MzEyLzYwMgpbMjQ4NTA4LjEyOTgzMl0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwK
WzI0ODUwOC4xNjg0MTFdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4K
WzI0ODUwOC4xNjg0NzhdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDguMTcyMjc1
XSB1dmN2aWRlbzogZnJhbWUgNjkgc3RhdHM6IDMyMS8zMjUvMzUyIHBhY2tldHMsIDAvMC8z
NTIgcHRzIChlYXJseSBpbml0aWFsKSwgMzUxLzM1MiBzY3IsIGxhc3QgcHRzL3N0Yy9zb2Yg
MjA1NTU3NjAyNC8yMDU3Njg2MjUzLzY0NgpbMjQ4NTA4LjE3Mzg0N10gdXZjdmlkZW86IHV2
Y192NGwyX3BvbGwKWzI0ODUwOC4xOTYzNDNdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAo
RU9GIGZvdW5kKS4KWzI0ODUwOC4xOTYzNTRdIHV2Y3ZpZGVvOiBmcmFtZSA3MCBzdGF0czog
MTY1LzE3MC8xOTcgcGFja2V0cywgMC8wLzE5NyBwdHMgKGVhcmx5IGluaXRpYWwpLCAxOTYv
MTk3IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDU3Njg4NjAzLzIwNTg4NjgyMjEvNjcxClsy
NDg1MDguMTk2MzU5XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA4LjIwMjk2Nl0g
dXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC4yMjg0MDFdIHV2Y3ZpZGVvOiBGcmFt
ZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwOC4yMjg0MDldIHV2Y3ZpZGVvOiBmcmFt
ZSA3MSBzdGF0czogMjMzLzIzOC8yNjQgcGFja2V0cywgMC8wLzI2NCBwdHMgKGVhcmx5IGlu
aXRpYWwpLCAyNjMvMjY0IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDU4ODY5MDk4LzIwNjA0
NTIxNzYvNzA0ClsyNDg1MDguMjI4NDE1XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4
NTA4LjIzNDA0Ml0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC4yNjA0NTFdIHV2
Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwOC4yNjA0NjBdIHV2
Y3ZpZGVvOiBmcmFtZSA3MiBzdGF0czogMjI5LzIzMi8yNTkgcGFja2V0cywgMC8wLzI1OSBw
dHMgKGVhcmx5IGluaXRpYWwpLCAyNTgvMjU5IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDYw
NDUzMDc0LzIwNjIwMDYxMzMvNzM2ClsyNDg1MDguMjYwNDkxXSB1dmN2aWRlbzogdXZjX3Y0
bDJfcG9sbApbMjQ4NTA4LjI2NjkyMl0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUw
OC4zMDg0NDJdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUw
OC4zMDg0NTFdIHV2Y3ZpZGVvOiBmcmFtZSA3MyBzdGF0czogMzYyLzM2NS8zOTMgcGFja2V0
cywgMC8wLzM5MyBwdHMgKGVhcmx5IGluaXRpYWwpLCAzOTIvMzkzIHNjciwgbGFzdCBwdHMv
c3RjL3NvZiAyMDYyMDExMjY3LzIwNjQzNjQwNjcvNzg1ClsyNDg1MDguMzA4NDgzXSB1dmN2
aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA4LjMxMzQ4N10gdXZjdmlkZW86IHV2Y192NGwy
X3BvbGwKWzI0ODUwOC4zMzI1MjldIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZv
dW5kKS4KWzI0ODUwOC4zMzI1MzldIHV2Y3ZpZGVvOiBmcmFtZSA3NCBzdGF0czogMTUzLzE1
OC8xODUgcGFja2V0cywgMC8wLzE4NSBwdHMgKGVhcmx5IGluaXRpYWwpLCAxODQvMTg1IHNj
ciwgbGFzdCBwdHMvc3RjL3NvZiAyMDY0MzY3OTEzLzIwNjU0NzQwMzUvODA5ClsyNDg1MDgu
MzMyNTc3XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA4LjMzNzk5MV0gdXZjdmlk
ZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC4zNjQzODZdIHV2Y3ZpZGVvOiBGcmFtZSBjb21w
bGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwOC4zNjQ0MDBdIHV2Y3ZpZGVvOiBmcmFtZSA3NSBz
dGF0czogMjExLzIxNS8yNDEgcGFja2V0cywgMC8wLzI0MSBwdHMgKGVhcmx5IGluaXRpYWwp
LCAyNDAvMjQxIHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDY1NDc1ODM0LzIwNjY5MTk5OTUv
ODM5ClsyNDg1MDguMzY0NDI5XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA4LjM3
MDMzNl0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC4zOTY0NDNdIHV2Y3ZpZGVv
OiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwOC4zOTY0NTVdIHV2Y3ZpZGVv
OiBmcmFtZSA3NiBzdGF0czogMjI1LzIzMC8yNTYgcGFja2V0cywgMC8wLzI1NiBwdHMgKGVh
cmx5IGluaXRpYWwpLCAyNTUvMjU2IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDY2OTI0MjEw
LzIwNjg0NTU5NTIvODcxClsyNDg1MDguMzk2NzA1XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9s
bApbMjQ4NTA4LjQwMzUzOF0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC40MzY0
NzVdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwOC40MzY1
MzJdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDguNDQwMzI4XSB1dmN2aWRlbzog
ZnJhbWUgNzcgc3RhdHM6IDMxOC8zMjEvMzQ5IHBhY2tldHMsIDAvMC8zNDkgcHRzIChlYXJs
eSBpbml0aWFsKSwgMzQ4LzM0OSBzY3IsIGxhc3QgcHRzL3N0Yy9zb2YgMjA2ODQ2MDgwMi8y
MDcwNTQ5ODk1LzkxNApbMjQ4NTA4LjQ0MjEyMV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwK
WzI0ODUwOC40NjQ0MzZdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4K
WzI0ODUwOC40NjQ0NTBdIHV2Y3ZpZGVvOiBmcmFtZSA3OCBzdGF0czogMTY0LzE2OC8xOTUg
cGFja2V0cywgMC8wLzE5NSBwdHMgKGVhcmx5IGluaXRpYWwpLCAxOTQvMTk1IHNjciwgbGFz
dCBwdHMvc3RjL3NvZiAyMDcwNTU0NTExLzIwNzE3MTk4NjEvOTM5ClsyNDg1MDguNDY0NDgy
XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA4LjQ3MDE5Ml0gdXZjdmlkZW86IHV2
Y192NGwyX3BvbGwKWzI0ODUwOC40OTYyOTBdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAo
RU9GIGZvdW5kKS4KWzI0ODUwOC40OTYzMDNdIHV2Y3ZpZGVvOiBmcmFtZSA3OSBzdGF0czog
MjI2LzIzMC8yNTggcGFja2V0cywgMC8wLzI1OCBwdHMgKGVhcmx5IGluaXRpYWwpLCAyNTcv
MjU4IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDcxNzIzMjIxLzIwNzMyNjc4MTgvOTcxClsy
NDg1MDguNDk2MzM1XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA4LjUwMjczNl0g
dXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC41MjgzNjFdIHV2Y3ZpZGVvOiBGcmFt
ZSBjb21wbGV0ZSAoRU9GIGZvdW5kKS4KWzI0ODUwOC41MjgzNzJdIHV2Y3ZpZGVvOiBmcmFt
ZSA4MCBzdGF0czogMjM2LzI0Mi8yNjcgcGFja2V0cywgMC8wLzI2NyBwdHMgKGVhcmx5IGlu
aXRpYWwpLCAyNjYvMjY3IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDczMjcxNzIwLzIwNzQ4
Njk3NzMvMTAwNApbMjQ4NTA4LjUyODM5OV0gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0
ODUwOC41MzQ1MjBdIHV2Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDguNTcyNDcwXSB1
dmN2aWRlbzogRnJhbWUgY29tcGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDguNTcyNDgwXSB1
dmN2aWRlbzogZnJhbWUgODEgc3RhdHM6IDMyMC8zMjMvMzUxIHBhY2tldHMsIDAvMC8zNTEg
cHRzIChlYXJseSBpbml0aWFsKSwgMzUwLzM1MSBzY3IsIGxhc3QgcHRzL3N0Yy9zb2YgMjA3
NDg3MTE5Ni8yMDc2OTc1NzE1LzEwNDgKWzI0ODUwOC41NzI1MDFdIHV2Y3ZpZGVvOiB1dmNf
djRsMl9wb2xsClsyNDg1MDguNTc4NTE4XSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4
NTA4LjU5NjM2Ml0gdXZjdmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4
NTA4LjU5NjM3M10gdXZjdmlkZW86IGZyYW1lIDgyIHN0YXRzOiAxNjQvMTcwLzE5NiBwYWNr
ZXRzLCAwLzAvMTk2IHB0cyAoZWFybHkgaW5pdGlhbCksIDE5NS8xOTYgc2NyLCBsYXN0IHB0
cy9zdGMvc29mIDIwNzY5Nzg3NjYvMjA3ODE1MTY4Mi8xMDczClsyNDg1MDguNTk2NDA0XSB1
dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA4LjYwMTY5M10gdXZjdmlkZW86IHV2Y192
NGwyX3BvbGwKWzI0ODUwOC42Mjg0MjBdIHV2Y3ZpZGVvOiBGcmFtZSBjb21wbGV0ZSAoRU9G
IGZvdW5kKS4KWzI0ODUwOC42Mjg0MzFdIHV2Y3ZpZGVvOiBmcmFtZSA4MyBzdGF0czogMjMy
LzIzNC8yNjMgcGFja2V0cywgMC8wLzI2MyBwdHMgKGVhcmx5IGluaXRpYWwpLCAyNjIvMjYz
IHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDc4MTU1NDY3LzIwNzk3Mjk2MzkvMTEwNgpbMjQ4
NTA4LjYyODQ2N10gdXZjdmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC42MzUxOTNdIHV2
Y3ZpZGVvOiB1dmNfdjRsMl9wb2xsClsyNDg1MDguNjYwNDc4XSB1dmN2aWRlbzogRnJhbWUg
Y29tcGxldGUgKEVPRiBmb3VuZCkuClsyNDg1MDguNjYwNDkwXSB1dmN2aWRlbzogdXZjX3Y0
bDJfcG9sbApbMjQ4NTA4LjY2NDM3M10gdXZjdmlkZW86IGZyYW1lIDg0IHN0YXRzOiAyMzEv
MjM2LzI2MiBwYWNrZXRzLCAxLzEvMjYyIHB0cyAoZWFybHkgaW5pdGlhbCksIDI2MS8yNjIg
c2NyLCBsYXN0IHB0cy9zdGMvc29mIDIwNzk3MzYwMTQvMjA4MTMwMTU5NC8xMTM4ClsyNDg1
MDguNjY2NjMwXSB1dmN2aWRlbzogdXZjX3Y0bDJfcG9sbApbMjQ4NTA4LjcwNDM5MF0gdXZj
dmlkZW86IEZyYW1lIGNvbXBsZXRlIChFT0YgZm91bmQpLgpbMjQ4NTA4LjcwNDQzOF0gdXZj
dmlkZW86IHV2Y192NGwyX3BvbGwKWzI0ODUwOC43MDg0MzFdIHV2Y3ZpZGVvOiBmcmFtZSA4
NSBzdGF0czogMzIwLzMyNS8zNTIgcGFja2V0cywgMC8wLzM1MiBwdHMgKGVhcmx5IGluaXRp
YWwpLCAzNTEvMzUyIHNjciwgbGFzdCBwdHMvc3RjL3NvZiAyMDgxMzAzMjQwLzIwODM0MTM1
MzUvMTE4MgpbMjQ4NTA4LjczODkyMV0gdXZjdmlkZW86IHV2Y192NGwyX3JlbGVhc2UKWzI0
ODUxMC43NDMwOTFdIHV2Y3ZpZGVvOiBTdXNwZW5kaW5nIGludGVyZmFjZSAxClsyNDg1MTAu
NzQzMDk1XSB1dmN2aWRlbzogU3VzcGVuZGluZyBpbnRlcmZhY2UgMAo=
--------------29E6CDF0D4A26E4BE4BA5E30
Content-Type: text/plain; charset=UTF-8;
 name="guvcview.out"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="guvcview.out"

VjRMMl9DT1JFOiAoVVZDSU9DX0NUUkxfTUFQKSBFcnJvcjogTm8gc3VjaCBmaWxlIG9yIGRp
cmVjdG9yeQpWNEwyX0NPUkU6IChVVkNJT0NfQ1RSTF9NQVApIEVycm9yOiBObyBzdWNoIGZp
bGUgb3IgZGlyZWN0b3J5ClY0TDJfQ09SRTogKFVWQ0lPQ19DVFJMX01BUCkgRXJyb3I6IE5v
IHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKVjRMMl9DT1JFOiAoVVZDSU9DX0NUUkxfTUFQKSBF
cnJvcjogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpWNEwyX0NPUkU6IChVVkNJT0NfQ1RS
TF9NQVApIEVycm9yOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5ClY0TDJfQ09SRTogKFVW
Q0lPQ19DVFJMX01BUCkgRXJyb3I6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKVjRMMl9D
T1JFOiAoVVZDSU9DX0NUUkxfTUFQKSBFcnJvcjogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9y
eQpWNEwyX0NPUkU6IChVVkNJT0NfQ1RSTF9NQVApIEVycm9yOiBObyBzdWNoIGZpbGUgb3Ig
ZGlyZWN0b3J5ClY0TDJfQ09SRTogKFVWQ0lPQ19DVFJMX01BUCkgRXJyb3I6IE5vIHN1Y2gg
ZmlsZSBvciBkaXJlY3RvcnkKQUxTQSBsaWIgcGNtLmM6MjQ5NTooc25kX3BjbV9vcGVuX25v
dXBkYXRlKSBVbmtub3duIFBDTSBjYXJkcy5wY20ucmVhcgpBTFNBIGxpYiBwY20uYzoyNDk1
OihzbmRfcGNtX29wZW5fbm91cGRhdGUpIFVua25vd24gUENNIGNhcmRzLnBjbS5jZW50ZXJf
bGZlCkFMU0EgbGliIHBjbS5jOjI0OTU6KHNuZF9wY21fb3Blbl9ub3VwZGF0ZSkgVW5rbm93
biBQQ00gY2FyZHMucGNtLnNpZGUKQUxTQSBsaWIgcGNtX3JvdXRlLmM6ODY3OihmaW5kX21h
dGNoaW5nX2NobWFwKSBGb3VuZCBubyBtYXRjaGluZyBjaGFubmVsIG1hcApBTFNBIGxpYiBw
Y21fcm91dGUuYzo4Njc6KGZpbmRfbWF0Y2hpbmdfY2htYXApIEZvdW5kIG5vIG1hdGNoaW5n
IGNoYW5uZWwgbWFwCkFMU0EgbGliIHBjbV9yb3V0ZS5jOjg2NzooZmluZF9tYXRjaGluZ19j
aG1hcCkgRm91bmQgbm8gbWF0Y2hpbmcgY2hhbm5lbCBtYXAKQUxTQSBsaWIgcGNtX3JvdXRl
LmM6ODY3OihmaW5kX21hdGNoaW5nX2NobWFwKSBGb3VuZCBubyBtYXRjaGluZyBjaGFubmVs
IG1hcApWNEwyX0NPUkU6IFVWQ0lPQ19DVFJMX1FVRVJZICgxMjkpIC0gRXJyb3I6IElucHV0
L291dHB1dCBlcnJvcgpWNEwyX0NPUkU6IChVVkNYX1JBVEVfQ09OVFJPTF9NT0RFKSBxdWVy
eSAoMTI5KSBlcnJvcjogSW5wdXQvb3V0cHV0IGVycm9yClY0TDJfQ09SRTogVVZDSU9DX0NU
UkxfUVVFUlkgKDEyOSkgLSBFcnJvcjogSW5wdXQvb3V0cHV0IGVycm9yClY0TDJfQ09SRTog
KFVWQ1hfUkFURV9DT05UUk9MX01PREUpIHF1ZXJ5ICgxMjkpIGVycm9yOiBJbnB1dC9vdXRw
dXQgZXJyb3IKR1VWQ1ZJRVc6IChIMjY0IHByb2JlKSB1bmtub3duIHByb2ZpbGUgbW9kZSAw
eEZGMDAKVjRMMl9DT1JFOiBDb3VsZCBub3QgZ3JhYiBpbWFnZSAoc2VsZWN0IHRpbWVvdXQp
OiBSZXNvdXJjZSB0ZW1wb3JhcmlseSB1bmF2YWlsYWJsZQpWNEwyX0NPUkU6IENvdWxkIG5v
dCBncmFiIGltYWdlIChzZWxlY3QgdGltZW91dCk6IFJlc291cmNlIHRlbXBvcmFyaWx5IHVu
YXZhaWxhYmxlClY0TDJfQ09SRTogQ291bGQgbm90IGdyYWIgaW1hZ2UgKHNlbGVjdCB0aW1l
b3V0KTogUmVzb3VyY2UgdGVtcG9yYXJpbHkgdW5hdmFpbGFibGUKVjRMMl9DT1JFOiBDb3Vs
ZCBub3QgZ3JhYiBpbWFnZSAoc2VsZWN0IHRpbWVvdXQpOiBSZXNvdXJjZSB0ZW1wb3Jhcmls
eSB1bmF2YWlsYWJsZQpWNEwyX0NPUkU6IENvdWxkIG5vdCBncmFiIGltYWdlIChzZWxlY3Qg
dGltZW91dCk6IFJlc291cmNlIHRlbXBvcmFyaWx5IHVuYXZhaWxhYmxlClY0TDJfQ09SRTog
Q291bGQgbm90IGdyYWIgaW1hZ2UgKHNlbGVjdCB0aW1lb3V0KTogUmVzb3VyY2UgdGVtcG9y
YXJpbHkgdW5hdmFpbGFibGUKVjRMMl9DT1JFOiBDb3VsZCBub3QgZ3JhYiBpbWFnZSAoc2Vs
ZWN0IHRpbWVvdXQpOiBSZXNvdXJjZSB0ZW1wb3JhcmlseSB1bmF2YWlsYWJsZQpWNEwyX0NP
UkU6IENvdWxkIG5vdCBncmFiIGltYWdlIChzZWxlY3QgdGltZW91dCk6IFJlc291cmNlIHRl
bXBvcmFyaWx5IHVuYXZhaWxhYmxlCkdVVkNWSUVXOiB2ZXJzaW9uIDIuMC40Cg==
--------------29E6CDF0D4A26E4BE4BA5E30--

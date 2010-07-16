Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-001.topalis.com ([195.243.109.4]:59346 "EHLO
	mx-001.topalis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab0GPQnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 12:43:16 -0400
In-Reply-To: 
References: 
Subject: Chicony Electronics 04f2:b1b4 webcam device unsupported (yet)
MIME-Version: 1.0
From: Michael Kromer <Michael.Kromer@millenux.com>
To: laurent.pinchart@skynet.be
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Message-ID: <OF56E589E0.BB18B6B2-ONC1257762.005AE925-C1257762.005AE95B@topalis.com>
Date: Fri, 16 Jul 2010 18:32:59 +0200
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I have bought myself a rather new Lenovo Thinkpad X100e, and there is no
support for the webcam device in the current (2.6.34) kernel (yet).
2.6.35 doesn't seem to have a driver for it either. Is there any
possibility for one of you guys to take a look at it?

I could provide you with an SSH-session, as there is no critical data on
the device. I'm currently running stock 2.6.34-12 from openSUSE 11.3
with minor modifications.

Please let me know if you could take a look at it. Thanks!

---


Bus 002 Device 003: ID 04f2:b1b4 Chicony Electronics Co., Ltd
Device Descriptor::
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x04f2 Chicony Electronics Co., Ltd
  idProduct          0xb1b4
  bcdDevice           30.08
  iManufacturer           1 Image Processor
  iProduct                2 Integrated Camera
  iSerial                 2 Integrated Camera
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          529
    bNumInterfaces          2
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
        wTotalLength           77
        dwClockFrequency       30.000000MHz
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
        bmControls           0x00002a0e
          Auto-Exposure Mode
          Auto-Exposure Priority
          Exposure Time (Absolute)
          Zoom (Absolute)
          PanTilt (Absolute)
          Roll (Absolute)
      VideoControl Interface Descriptor:
        bLength                26
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 2
        guidExtensionCode         {92423946-d10c-e34a-8783-3133f9eaaa3b}
        bNumControl             3
        bNrPins                 1
        baSourceID( 0)          1
        bControlSize            1
        bmControls( 0)       0xff
        iExtension              0
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 3
        bSourceID               2
        wMaxMultiplier          0
        bControlSize            2
        bmControls     0x0000157f
          Brightness
          Contrast
          Hue
          Saturation
          Sharpness
          Gamma
          White Balance Temperature
          Backlight Compensation
          Power Line Frequency
          White Balance Temperature, Auto
        iProcessing             0
        bmVideoStandards     0x 9
          None
          SECAM - 625/50
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             4
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               3
        iTerminal               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              16
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
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                      341
        bEndPointAddress                  129
        bmInfo                              0
        bTerminalLink                       4
        bStillCaptureMethod                 1
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    27
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        1
        bNumFrameDescriptors                7
        guidFormat
        {59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
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
        bLength                            42
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  4
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            333334
        dwFrameInterval( 2)            333335
        dwFrameInterval( 3)            333336
      VideoStreaming Interface Descriptor:
        bLength                            42
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x01
          Still image supported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize     1843200
        dwDefaultFrameInterval        1333333
        bFrameIntervalType                  4
        dwFrameInterval( 0)           1333333
        dwFrameInterval( 1)           1333334
        dwFrameInterval( 2)           1333335
        dwFrameInterval( 3)           1333336
      VideoStreaming Interface Descriptor:
        bLength                            42
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x01
          Still image supported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  4
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            333334
        dwFrameInterval( 2)            333335
        dwFrameInterval( 3)            333336
      VideoStreaming Interface Descriptor:
        bLength                            42
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x01
          Still image supported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  4
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            333334
        dwFrameInterval( 2)            333335
        dwFrameInterval( 3)            333336
      VideoStreaming Interface Descriptor:
        bLength                            42
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x01
          Still image supported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  4
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            333334
        dwFrameInterval( 2)            333335
        dwFrameInterval( 3)            333336
      VideoStreaming Interface Descriptor:
        bLength                            42
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         6
        bmCapabilities                   0x01
          Still image supported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  4
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            333334
        dwFrameInterval( 2)            333335
        dwFrameInterval( 3)            333336
      VideoStreaming Interface Descriptor:
        bLength                            42
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         7
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           360
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize      460800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  4
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            333334
        dwFrameInterval( 2)            333335
        dwFrameInterval( 3)            333336
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     0 (Unspecified)
        bTransferCharacteristics            0 (Unspecified)
        bMatrixCoefficients                 0 (Unspecified)
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
        wMaxPacketSize     0x1400  3x 1024 bytes
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
        wMaxPacketSize     0x1340  3x 832 bytes
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
        wMaxPacketSize     0x1300  3x 768 bytes
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
        wMaxPacketSize     0x13fc  3x 1020 bytes
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
  (Bus Powered):


/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/3p, 12M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/3p, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/3p, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
    |__ Port 1: Dev 2, If 0, Class=stor., Driver=usb-storage, 480M
    |__ Port 2: Dev 3, If 0, Class='bInterfaceClass 0x0e not yet
    handled', Driver=uvcvideo, 480M
    |__ Port 2: Dev 3, If 1, Class='bInterfaceClass 0x0e not yet
    handled', Driver=uvcvideo, 480M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
    |__ Port 3: Dev 2, If 1, Class=vend., Driver=qcserial, 480M




Mit freundlichen Grüßen,
Kind regards,
Sincères salutations,
Cordialmente,
Met vriendelijke groet,

Michael Kromer [Senior IT Consultant & Linux Engineer]
Fon +49 711 88770-100
Fax +49 711 88770-199
Cel +49 170 791 77 17
michael.kromer@topalis.com

Unternehmensgruppe Topalis
Zentrale Stuttgart, Lilienthalstraße 2/1, 70825 Korntal-Münchingen [DE]
Niederlassung München, Balanstraße 73 Haus 10, 81541 München [DE]

Topalis AG [Sitz und Amtsgericht Stuttgart, HRB 23163]
Vorstand: Thomas Uhl (Vors.), Rudolf Zimmermann, Markus Klingspor
Aufsichtsratsvorsitzender: Markus Geray

INFOLOGICA Systems GmbH [Sitz und Amtsgericht Stuttgart, HRB 25069]
Geschäftsführer: Thomas Uhl

InnoviData GmbH [Sitz und Amtsgericht Stuttgart, HRB 21082]
Geschäftsführer: Thomas Uhl

Millenux GmbH [Sitz und Amtsgericht Stuttgart, HRB 21058]
Geschäftsführer: Markus Klingspor, Thomas Uhl

Thinking Objects GmbH [Sitz und Amtsgericht Stuttgart, HRB 19769]
Geschäftsführer: Markus Klingspor, Thomas Uhl, Rolf Zimmermann

Topalis Service GmbH [Sitz und Amtsgericht Stuttgart, HRB 722446]
Geschäftsführer: Markus Klingspor, Peter Röder


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45047 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752691AbZJ1J6X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 05:58:23 -0400
Subject: Re: [Linux-uvc-devel] again "Logitech QuickCam Pro for Notebooks
 046d:0991"
From: Alexey Fisher <bug-track@fisher-privat.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <200910280027.38292.laurent.pinchart@ideasonboard.com>
References: <1255514751.15164.17.camel@zwerg>
	 <1256557968.12179.5.camel@zwerg> <4AE5ACF1.3080606@redhat.com>
	 <200910280027.38292.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 10:58:24 +0100
Message-ID: <1256723904.3452.6.camel@zwerg>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 28.10.2009, 00:27 +0100 schrieb Laurent Pinchart:
> On Monday 26 October 2009 15:06:41 Hans de Goede wrote:
> > On 10/26/2009 12:52 PM, Alexey Fisher wrote:
> > > Am Sonntag, den 25.10.2009, 14:21 +0100 schrieb Hans de Goede:
> 
> [snip]
> 
> > > > fwiw I'm a v4l kernel developer, but I'm not involved in the UVC driver,
> > > > I'm however a contributor to cheese, I thought that my input that cheese
> > > > would give up even if the driver has a long enough timeout would be
> > > > helpful.
> > > >
> > > > To try and see if this (the cheese timeout is the issue), you will need
> > > > to re-compile cheese from source, after unpacking cheese, edit
> > > > src/cheese-webcam.c and goto line 716 (in 2.28.0)
> > > >
> > > > And change the "10 * GST_SECOND" there in something bigger. I also see
> > > > that I'm mistaken and the timeout in cheese is not 3 but 10 seconds, it
> > > > might have changed recently, or my memory has been playing tricks on me.
> > > >
> > > > I still believe this might be the cause, the trace you have posted seems
> > > > consistent with cheese's behaviour. Also noticed that there never is a
> > > > successfull DQBUF the first time cheese opens the device. If cheese
> > > > (or rather gstreamer) does not manage to DQBUF the first time, then
> > > > cheese will not work with the device. There is a limitation in gstreamer
> > > > (or maybe in the way cheese uses it) where gstreamer needs to be
> > > > streaming before cheese can tell the properties of the cam. If the
> > > > stream does not start within the first 10 seconds, then cheese will fail
> > > > to get the properties.
> > > >
> > > > If you go to cheese's edit ->  preferences menu, and your cam has no
> > > > resolutions listed there (the resolution drop down is grayed out). This
> > > > is what is happening.
> > > >
> > > > As for empathy, I'm not familiar with that. But if we can get cheese to
> > > > work first I'm sure that that would be a good step in the right
> > > > direction.
> > >
> > > Hallo Hans,
> > > thank you for your constructive response,
> > > I increased timeout to 15 seconds i now i can't reproduce camera freeze,
> > > i'll play with it more to be sure. There is still one issue with it - on
> > > cold start the image is zoomed in.
> > > I need to close cheese and open it again to get normal zoom. The
> > > resolution seems to be the same.
> 
> Zoomed in ? Really ? As far as I know the QuickCam Pro for Notebooks has no 
> optical or digital zoom. Could you please send me lsusb's output for your 
> device ?

Yes. I can use digital zoom under M$Win with Logitech software. lsusb
goto bottom:

> > That definitely sounds like a camera bug, but maybe we can do something
> > on the driver side (like forcing a resolution change even if not necessary)
> > to work around this. Laurent ?
> 
> The driver already sends a video format and resolution set request to the 
> device when starting the video stream.
> 
> > Note re-adding the mailing list and Laurent to the CC, they somehow got
> > dropped.
> 
> Thanks.
> 

sudo lsusb -vd 046d:0991

Bus 001 Device 007: ID 046d:0991 Logitech, Inc. QuickCam Pro for
Notebooks
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x046d Logitech, Inc.
  idProduct          0x0991 QuickCam Pro for Notebooks
  bcdDevice            0.05
  iManufacturer           0 
  iProduct                0 
  iSerial                 2 [removed]
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength         1433
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
        wTotalLength          133
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
        bmControls           0x0000000e
          Auto-Exposure Mode
          Auto-Exposure Priority
          Exposure Time (Absolute)
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
        bUnitID                 4
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d221e}
        bNumControl            10
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            2
        bmControls( 0)       0xff
        bmControls( 1)       0x03
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                13
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d221f}
        bNumControl             8
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            2
        bmControls( 0)       0x7f
        bmControls( 1)       0x01
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                28
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                10
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d2252}
        bNumControl            24
        bNrPins                 1
        baSourceID( 0)          4
        bControlSize            3
        bmControls( 0)       0xff
        bmControls( 1)       0xff
        bmControls( 2)       0xff
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
      ** UNRECOGNIZED:  20 41 01 0c 82 06 61 63 70 50 ab 49 b8 cc b3 85
5e 8d 22 50 14 01 04 03 ff ff 0f 00 00 00 00 00
      ** UNRECOGNIZED:  20 41 01 08 82 06 61 63 70 50 ab 49 b8 cc b3 85
5e 8d 22 51 03 01 04 03 19 00 00 00 00 00 01 00
      ** UNRECOGNIZED:  20 41 01 0b 82 06 61 63 70 50 ab 49 b8 cc b3 85
5e 8d 22 55 01 01 04 03 01 00 00 00 00 00 00 00
      ** UNRECOGNIZED:  20 41 01 09 82 06 61 63 70 50 ab 49 b8 cc b3 85
5e 8d 22 56 02 01 04 03 0c 00 00 00 00 00 00 00
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
        wTotalLength                      842
        bEndPointAddress                  129
        bmInfo                              0
        bTerminalLink                       5
        bStillCaptureMethod                 2
        bTriggerSupport                     1
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    11
        bmaControls( 1)                    11
        bmaControls( 2)                    11
      VideoStreaming Interface Descriptor:
        bLength                            11
        bDescriptorType                    36
        bDescriptorSubtype                  6 (FORMAT_MJPEG)
        bFormatIndex                        1
        bNumFrameDescriptors                7
        bFlags                              1
          Fixed-size samples: Yes
        bDefaultFrameIndex                  3
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
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  1536000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
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
        wWidth                            176
        wHeight                           144
        dwMinBitRate                  2027520
        dwMaxBitRate                 12165120
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
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
        wHeight                           240
        dwMinBitRate                  6144000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
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
        wWidth                            352
        wHeight                           288
        dwMinBitRate                  8110080
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
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
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
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
        wWidth                            800
        wHeight                           600
        dwMinBitRate                 38400000
        dwMaxBitRate                230400000
        dwMaxVideoFrameBufferSize      960000
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         7
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            960
        wHeight                           720
        dwMinBitRate                 55296000
        dwMaxBitRate                165888000
        dwMaxVideoFrameBufferSize     1382400
        dwDefaultFrameInterval        1000000
        bFrameIntervalType                  3
        dwFrameInterval( 0)            666666
        dwFrameInterval( 1)           1000000
        dwFrameInterval( 2)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            39
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns               7
        wWidth( 0)                        160
        wHeight( 0)                       120
        wWidth( 1)                        176
        wHeight( 1)                       144
        wWidth( 2)                        320
        wHeight( 2)                       240
        wWidth( 3)                        352
        wHeight( 3)                       288
        wWidth( 4)                        640
        wHeight( 4)                       480
        wWidth( 5)                        800
        wHeight( 5)                       600
        wWidth( 6)                        960
        wHeight( 6)                       720
        bNumCompressionPatterns             7
        bCompression( 0)                    5
        bCompression( 1)                   10
        bCompression( 2)                   15
        bCompression( 3)                   20
        bCompression( 4)                   25
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        2
        bNumFrameDescriptors                8
        guidFormat
{59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  3
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
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
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
        dwFrameInterval( 1)            400000
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
        wWidth                            176
        wHeight                           144
        dwMinBitRate                  2027520
        dwMaxBitRate                 12165120
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
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
        wHeight                           240
        dwMinBitRate                  6144000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
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
        wWidth                            352
        wHeight                           288
        dwMinBitRate                  8110080
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
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
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            46
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         6
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           600
        dwMinBitRate                 38400000
        dwMaxBitRate                192000000
        dwMaxVideoFrameBufferSize      960000
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  5
        dwFrameInterval( 0)            400000
        dwFrameInterval( 1)            500000
        dwFrameInterval( 2)            666666
        dwFrameInterval( 3)           1000000
        dwFrameInterval( 4)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         7
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            960
        wHeight                           720
        dwMinBitRate                 55296000
        dwMaxBitRate                110592000
        dwMaxVideoFrameBufferSize     1382400
        dwDefaultFrameInterval        1000000
        bFrameIntervalType                  2
        dwFrameInterval( 0)           1000000
        dwFrameInterval( 1)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         8
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1600
        wHeight                          1200
        dwMinBitRate                153600000
        dwMaxBitRate                153600000
        dwMaxVideoFrameBufferSize     3840000
        dwDefaultFrameInterval        2000000
        bFrameIntervalType                  1
        dwFrameInterval( 0)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            39
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns               8
        wWidth( 0)                        160
        wHeight( 0)                       120
        wWidth( 1)                        176
        wHeight( 1)                       144
        wWidth( 2)                        320
        wHeight( 2)                       240
        wWidth( 3)                        352
        wHeight( 3)                       288
        wWidth( 4)                        640
        wHeight( 4)                       480
        wWidth( 5)                        800
        wHeight( 5)                       600
        wWidth( 6)                        960
        wHeight( 6)                       720
        wWidth( 7)                       1600
        wHeight( 7)                      1200
        bNumCompressionPatterns             8
        bCompression( 0)                    5
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
        bNrChannels             1
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
        bLength                 8
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 5
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x03
          Mute
          Volume
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
        bNrChannels             1
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


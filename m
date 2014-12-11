Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33355 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933184AbaLKBTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 20:19:53 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id C558F208DD
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 20:19:52 -0500 (EST)
Message-ID: <5488F136.6050907@williammanley.net>
Date: Thu, 11 Dec 2014 01:19:50 +0000
From: William Manley <will@williammanley.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] [media] uvcvideo: Add GUID for BGR 8:8:8
References: <1418065078-27791-1-git-send-email-will@williammanley.net> <1514839.CAtLhmhmvy@avalon>
In-Reply-To: <1514839.CAtLhmhmvy@avalon>
Content-Type: multipart/mixed;
 boundary="------------020500040300090904070207"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020500040300090904070207
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 10/12/14 23:54, Laurent Pinchart wrote:
> Hi William,
> 
> Thank you for the patch.
> 
> On Monday 08 December 2014 18:57:58 William Manley wrote:
>> The Magewell XI100DUSB-HDMI[1] video capture device reports the pixel
>> format "e436eb7d-524f-11ce-9f53-0020af0ba770".  This is its GUID for
>> BGR 8:8:8.
>>
>> The UVC 1.5 spec[2] only defines GUIDs for YUY2, NV12, M420 and I420.
>> This seems to be an extension documented in the Microsoft Windows Media
>> Format SDK[3] - or at least the Media Format SDK was the only hit that
>> Google gave when searching for the GUID.  This Media Format SDK defines
>> this GUID as corresponding to `MEDIASUBTYPE_RGB24`.  Note though, the
>> XI100DUSB outputs BGR e.g. byte-reversed.  I don't know if its the
>> capture device in error or Microsoft mean BGR when they say RGB.
> 
> I believe Microsoft defines RGB as BGR. They do at least in BMP 
> (https://en.wikipedia.org/wiki/BMP_file_format), probably because they 
> consider the RGB pixel to be stored in little-endian format.

Thanks, that's helpful.

> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I'll apply the patch to my tree and submit it for v3.20.

Great

> Could you please send me the output of 'lsusb -v' for your device, if possible 
> running as root ?

lsusb output attached.

Thanks

Will

--------------020500040300090904070207
Content-Type: text/plain; charset=UTF-8;
 name="lsusb-Magewell-XI100DUSB-HDMI.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsusb-Magewell-XI100DUSB-HDMI.txt"

Bus 003 Device 002: ID 2935:0001  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0         9
  idVendor           0x2935 
  idProduct          0x0001 
  bcdDevice            0.00
  iManufacturer           1 Magewell
  iProduct                2 XI100DUSB-HDMI
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength         2474
    bNumInterfaces          5
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              200mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               3 XI100DUSB-HDMI Video
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface              3 XI100DUSB-HDMI Video
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength           52
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
        bmControls           0x00000000
      VideoControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 2
        bSourceID               1
        wMaxMultiplier      16384
        bControlSize            3
        bmControls     0x0000000f
          Brightness
          Contrast
          Hue
          Saturation
        iProcessing             0 
        bmVideoStandards     0x 9
          None
          SECAM - 625/50
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               2
        iTerminal               0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
        bMaxBurst               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              3 XI100DUSB-HDMI Video
      VideoStreaming Interface Descriptor:
        bLength                            15
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         2
        wTotalLength                     2235
        bEndPointAddress                  131
        bmInfo                              0
        bTerminalLink                       3
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
        bNumFrameDescriptors               20
        guidFormat                            {59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                 19
        bAspectRatioX                      16
        bAspectRatioY                       9
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 2 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            640
        wHeight                           360
        dwMinBitRate                 55296000
        dwMaxBitRate                221184000
        dwMaxVideoFrameBufferSize      460800
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 73728000
        dwMaxBitRate                294912000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            720
        wHeight                           480
        dwMinBitRate                 82944000
        dwMaxBitRate                331776000
        dwMaxVideoFrameBufferSize      691200
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            720
        wHeight                           576
        dwMinBitRate                 99532800
        dwMaxBitRate                398131200
        dwMaxVideoFrameBufferSize      829440
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            768
        wHeight                           576
        dwMinBitRate                106168320
        dwMaxBitRate                424673280
        dwMaxVideoFrameBufferSize      884736
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         6
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            800
        wHeight                           600
        dwMinBitRate                115200000
        dwMaxBitRate                460800000
        dwMaxVideoFrameBufferSize      960000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         7
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            856
        wHeight                           480
        dwMinBitRate                 98611200
        dwMaxBitRate                394444800
        dwMaxVideoFrameBufferSize      821760
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         8
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            960
        wHeight                           540
        dwMinBitRate                124416000
        dwMaxBitRate                497664000
        dwMaxVideoFrameBufferSize     1036800
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         9
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1024
        wHeight                           576
        dwMinBitRate                141557760
        dwMaxBitRate                566231040
        dwMaxVideoFrameBufferSize     1179648
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        10
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1024
        wHeight                           768
        dwMinBitRate                188743680
        dwMaxBitRate                754974720
        dwMaxVideoFrameBufferSize     1572864
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        11
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                221184000
        dwMaxBitRate                884736000
        dwMaxVideoFrameBufferSize     1843200
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        12
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1280
        wHeight                           800
        dwMinBitRate                245760000
        dwMaxBitRate                983040000
        dwMaxVideoFrameBufferSize     2048000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        13
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1280
        wHeight                           960
        dwMinBitRate                294912000
        dwMaxBitRate                1179648000
        dwMaxVideoFrameBufferSize     2457600
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        14
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1280
        wHeight                          1024
        dwMinBitRate                314572800
        dwMaxBitRate                1258291200
        dwMaxVideoFrameBufferSize     2621440
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        15
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1368
        wHeight                           768
        dwMinBitRate                252149760
        dwMaxBitRate                1008599040
        dwMaxVideoFrameBufferSize     2101248
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        16
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1440
        wHeight                           900
        dwMinBitRate                311040000
        dwMaxBitRate                1244160000
        dwMaxVideoFrameBufferSize     2592000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        17
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1600
        wHeight                          1200
        dwMinBitRate                460800000
        dwMaxBitRate                1843200000
        dwMaxVideoFrameBufferSize     3840000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        18
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1680
        wHeight                          1050
        dwMinBitRate                423360000
        dwMaxBitRate                1693440000
        dwMaxVideoFrameBufferSize     3528000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        19
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1920
        wHeight                          1080
        dwMinBitRate                497664000
        dwMaxBitRate                1990656000
        dwMaxVideoFrameBufferSize     4147200
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        20
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1920
        wHeight                          1200
        dwMinBitRate                552960000
        dwMaxBitRate                2211840000
        dwMaxVideoFrameBufferSize     4608000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 1 (BT.709)
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        2
        bNumFrameDescriptors               20
        guidFormat                            {7deb36e4-4f52-ce11-9f53-0020af0ba770}
        bBitsPerPixel                      24
        bDefaultFrameIndex                 19
        bAspectRatioX                      16
        bAspectRatioY                       9
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 2 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            640
        wHeight                           360
        dwMinBitRate                 82944000
        dwMaxBitRate                331776000
        dwMaxVideoFrameBufferSize      691200
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            640
        wHeight                           480
        dwMinBitRate                110592000
        dwMaxBitRate                442368000
        dwMaxVideoFrameBufferSize      921600
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            720
        wHeight                           480
        dwMinBitRate                124416000
        dwMaxBitRate                497664000
        dwMaxVideoFrameBufferSize     1036800
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            720
        wHeight                           576
        dwMinBitRate                149299200
        dwMaxBitRate                597196800
        dwMaxVideoFrameBufferSize     1244160
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            768
        wHeight                           576
        dwMinBitRate                159252480
        dwMaxBitRate                637009920
        dwMaxVideoFrameBufferSize     1327104
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         6
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            800
        wHeight                           600
        dwMinBitRate                172800000
        dwMaxBitRate                691200000
        dwMaxVideoFrameBufferSize     1440000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         7
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            856
        wHeight                           480
        dwMinBitRate                147916800
        dwMaxBitRate                591667200
        dwMaxVideoFrameBufferSize     1232640
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         8
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                            960
        wHeight                           540
        dwMinBitRate                186624000
        dwMaxBitRate                746496000
        dwMaxVideoFrameBufferSize     1555200
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         9
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1024
        wHeight                           576
        dwMinBitRate                212336640
        dwMaxBitRate                849346560
        dwMaxVideoFrameBufferSize     1769472
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        10
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1024
        wHeight                           768
        dwMinBitRate                283115520
        dwMaxBitRate                1132462080
        dwMaxVideoFrameBufferSize     2359296
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        11
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                331776000
        dwMaxBitRate                1327104000
        dwMaxVideoFrameBufferSize     2764800
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        12
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1280
        wHeight                           800
        dwMinBitRate                368640000
        dwMaxBitRate                1474560000
        dwMaxVideoFrameBufferSize     3072000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        13
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1280
        wHeight                           960
        dwMinBitRate                442368000
        dwMaxBitRate                1769472000
        dwMaxVideoFrameBufferSize     3686400
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        14
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1280
        wHeight                          1024
        dwMinBitRate                471859200
        dwMaxBitRate                1887436800
        dwMaxVideoFrameBufferSize     3932160
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        15
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1368
        wHeight                           768
        dwMinBitRate                378224640
        dwMaxBitRate                1512898560
        dwMaxVideoFrameBufferSize     3151872
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        16
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1440
        wHeight                           900
        dwMinBitRate                466560000
        dwMaxBitRate                1866240000
        dwMaxVideoFrameBufferSize     3888000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        17
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1600
        wHeight                          1200
        dwMinBitRate                691200000
        dwMaxBitRate                2764800000
        dwMaxVideoFrameBufferSize     5760000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        18
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1680
        wHeight                          1050
        dwMinBitRate                635040000
        dwMaxBitRate                2540160000
        dwMaxVideoFrameBufferSize     5292000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        19
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1920
        wHeight                          1080
        dwMinBitRate                746496000
        dwMaxBitRate                2985984000
        dwMaxVideoFrameBufferSize     6220800
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      VideoStreaming Interface Descriptor:
        bLength                            54
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        20
        bmCapabilities                   0x03
          Still image supported
          Fixed frame-rate
        wWidth                           1920
        wHeight                          1200
        dwMinBitRate                829440000
        dwMaxBitRate                3317760000
        dwMaxVideoFrameBufferSize     6912000
        dwDefaultFrameInterval         166667
        bFrameIntervalType                  7
        dwFrameInterval( 0)            166667
        dwFrameInterval( 1)            166834
        dwFrameInterval( 2)            200000
        dwFrameInterval( 3)            333333
        dwFrameInterval( 4)            333667
        dwFrameInterval( 5)            400000
        dwFrameInterval( 6)            666667
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         2
      bInterfaceCount         2
      bFunctionClass          1 Audio
      bFunctionSubClass       1 Control Device
      bFunctionProtocol       0 
      iFunction               4 XI100DUSB-HDMI Audio
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0 
      iInterface              4 XI100DUSB-HDMI Audio
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength           30
        bInCollection           1
        baInterfaceNr( 0)       3
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0602 Digital Audio Interface
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             2
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               1
        iTerminal               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              4 XI100DUSB-HDMI Audio
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              4 XI100DUSB-HDMI Audio
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           2
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
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x00c0  1x 192 bytes
        bInterval               4
        bMaxBurst               0
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
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     153
          Report Descriptor: (length is 153)
            Item(Global): Usage Page, data= [ 0x00 0xff ] 65280
                            (null)
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0xff 0x00 ] 255
            Item(Global): Report ID, data= [ 0x10 ] 16
            Item(Global): Report Count, data= [ 0x04 ] 4
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x01 ] 1
            Item(Global): Report Count, data= [ 0x01 ] 1
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x02 ] 2
            Item(Global): Report Count, data= [ 0x04 ] 4
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Main  ): Output, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x03 ] 3
            Item(Global): Report Count, data= [ 0x01 ] 1
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x04 ] 4
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x04 ] 4
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x04 ] 4
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x04 ] 4
            Item(Main  ): Output, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x05 ] 5
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x00 0x01 ] 256
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x05 ] 5
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x00 0x01 ] 256
            Item(Main  ): Output, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x20 ] 32
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x08 ] 8
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x21 ] 33
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x09 ] 9
            Item(Main  ): Output, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x22 ] 34
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x02 ] 2
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x22 ] 34
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x02 ] 2
            Item(Main  ): Output, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x23 ] 35
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x08 ] 8
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x23 ] 35
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x08 ] 8
            Item(Main  ): Output, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x30 ] 48
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x06 ] 6
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x30 ] 48
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x06 ] 6
            Item(Main  ): Output, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x40 ] 64
            Item(Local ): Usage, data= [ 0x01 ] 1
                            (null)
            Item(Global): Report Count, data= [ 0x11 ] 17
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength           22
  bNumDeviceCaps          2
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000002
      Link Power Management (LPM) Supported
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
    wSpeedsSupported   0x000e
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   3
      Lowest fully-functional device speed is SuperSpeed (5Gbps)
    bU1DevExitLat          10 micro seconds
    bU2DevExitLat        2047 micro seconds
Device Status:     0x000c
  (Bus Powered)
  U1 Enabled
  U2 Enabled

--------------020500040300090904070207--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:57618 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbeJaAmT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 20:42:19 -0400
Subject: Re: uvcvideo: IR camera lights only every second frame
To: Jiri Slaby <jslaby@suse.cz>, laurent.pinchart@ideasonboard.com,
        linux-media <linux-media@vger.kernel.org>
References: <3377b60e-afee-97bb-8714-36d4df048cef@suse.cz>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <2bd43354-4a41-e73b-9071-8287e1f0f754@ideasonboard.com>
Date: Tue, 30 Oct 2018 15:48:12 +0000
MIME-Version: 1.0
In-Reply-To: <3377b60e-afee-97bb-8714-36d4df048cef@suse.cz>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jiri,

On 30/10/2018 14:36, Jiri Slaby wrote:
> Hi,
> 
> I have a Dell Lattitude 7280 with two webcams. The standard one works
> fine (/dev/video0). The other one is an IR camera (/dev/video1). The
> camera proper works fine and produces 340x374 frames. But there is an IR
> led supposed to light the object. The video is 30fps, but the LED seems
> to emit light only on half of the frames, i.e. on every second frame (15
> fps). This makes the video blink a lot. The two consecutive frames look
> like:
> https://www.fi.muni.cz/~xslaby/sklad/mpv-shot0002.jpg
> https://www.fi.muni.cz/~xslaby/sklad/mpv-shot0003.jpg
> 
> Do you have any ideas what to check/test?

I have an HP Spectre with IR camera, and it also 'flashes' alternate frames.

I assumed this was something to do with controlling the lighting for
face recognition some how.

I'm fairly sure we don't control the 'IR flash' from the UVC.

I wonder if there is a control parameter for the IR led in the
extension-units?

--
Regards

Kieran



> $ v4l2-ctl  --all -d /dev/video2
> Driver Info (not using libv4l2):
>         Driver name   : uvcvideo
>         Card type     : Integrated_Webcam_HD: Integrate
>         Bus info      : usb-0000:00:14.0-5
>         Driver version: 4.18.15
>         Capabilities  : 0x84A00001
>                 Video Capture
>                 Metadata Capture
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x04200001
>                 Video Capture
>                 Streaming
>                 Extended Pix Format
> Priority: 2
> Video input : 0 (Camera 11: ok)
> Format Video Capture:
>         Width/Height      : 340/374
>         Pixel Format      : 'YUYV'
>         Field             : None
>         Bytes per Line    : 680
>         Size Image        : 254320
>         Colorspace        : sRGB
>         Transfer Function : Default (maps to sRGB)
>         YCbCr/HSV Encoding: Default (maps to ITU-R 601)
>         Quantization      : Default (maps to Limited Range)
>         Flags             :
> Crop Capability Video Capture:
>         Bounds      : Left 0, Top 0, Width 340, Height 374
>         Default     : Left 0, Top 0, Width 340, Height 374
>         Pixel Aspect: 1/1
> Selection: crop_default, Left 0, Top 0, Width 340, Height 374
> Selection: crop_bounds, Left 0, Top 0, Width 340, Height 374
> Streaming Parameters Video Capture:
>         Capabilities     : timeperframe
>         Frames per second: 30.000 (30/1)
>         Read buffers     : 0
> 
> 
> 
> 
> 
> $ lsusb -vs 1:3
> Bus 001 Device 003: ID 0bda:5691 Realtek Semiconductor Corp.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   idVendor           0x0bda Realtek Semiconductor Corp.
>   idProduct          0x5691
>   bcdDevice           60.12
>   iManufacturer           3 CNFGE16N5214300025C2
>   iProduct                1 Integrated_Webcam_HD
>   iSerial                 2 0001
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength         1041
>     bNumInterfaces          4
>     bConfigurationValue     1
>     iConfiguration          4 USB Camera
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     ** UNRECOGNIZED:  28 ff 42 49 53 54 00 01 06 06 10 00 00 00 00 00 01
> 07 f4 01 02 08 f4 01 03 09 f4 01 04 0a f4 01 05 0b f4 01 06 0c e8 03
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         0
>       bInterfaceCount         2
>       bFunctionClass         14 Video
>       bFunctionSubClass       3 Video Interface Collection
>       bFunctionProtocol       0
>       iFunction               5 Integrated Webcam
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      1 Video Control
>       bInterfaceProtocol      0
>       iInterface              5 Integrated Webcam
>       VideoControl Interface Descriptor:
>         bLength                13
>         bDescriptorType        36
>         bDescriptorSubtype      1 (HEADER)
>         bcdUVC               1.00
>         wTotalLength          107
>         dwClockFrequency       15.000000MHz
>         bInCollection           1
>         baInterfaceNr( 0)       1
>       VideoControl Interface Descriptor:
>         bLength                18
>         bDescriptorType        36
>         bDescriptorSubtype      2 (INPUT_TERMINAL)
>         bTerminalID             1
>         wTerminalType      0x0201 Camera Sensor
>         bAssocTerminal          0
>         iTerminal               0
>         wObjectiveFocalLengthMin      0
>         wObjectiveFocalLengthMax      0
>         wOcularFocalLength            0
>         bControlSize                  3
>         bmControls           0x0000000e
>           Auto-Exposure Mode
>           Auto-Exposure Priority
>           Exposure Time (Absolute)
>       VideoControl Interface Descriptor:
>         bLength                11
>         bDescriptorType        36
>         bDescriptorSubtype      5 (PROCESSING_UNIT)
>       Warning: Descriptor too short
>         bUnitID                 2
>         bSourceID               1
>         wMaxMultiplier          0
>         bControlSize            2
>         bmControls     0x0000177f
>           Brightness
>           Contrast
>           Hue
>           Saturation
>           Sharpness
>           Gamma
>           White Balance Temperature
>           Backlight Compensation
>           Gain
>           Power Line Frequency
>           White Balance Temperature, Auto
>         iProcessing             0
>         bmVideoStandards     0x09
>           None
>           SECAM - 625/50
>       VideoControl Interface Descriptor:
>         bLength                 9
>         bDescriptorType        36
>         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
>         bTerminalID             3
>         wTerminalType      0x0101 USB Streaming
>         bAssocTerminal          0
>         bSourceID               4
>         iTerminal               0
>       VideoControl Interface Descriptor:
>         bLength                27
>         bDescriptorType        36
>         bDescriptorSubtype      6 (EXTENSION_UNIT)
>         bUnitID                 4
>         guidExtensionCode         {1229a78c-47b4-4094-b0ce-db07386fb938}
>         bNumControl             2
>         bNrPins                 1
>         baSourceID( 0)          7
>         bControlSize            2
>         bmControls( 0)       0x00
>         bmControls( 1)       0x06
>         iExtension              0
>       VideoControl Interface Descriptor:
>         bLength                29
>         bDescriptorType        36
>         bDescriptorSubtype      6 (EXTENSION_UNIT)
>         bUnitID                 7
>         guidExtensionCode         {0fb885c3-68c2-4547-90f7-8f47579d95fc}
>         bNumControl             0
>         bNrPins                 1
>         baSourceID( 0)          2
>         bControlSize            4
>         bmControls( 0)       0x0f
>         bmControls( 1)       0x00
>         bmControls( 2)       0x00
>         bmControls( 3)       0x00
>         iExtension              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0010  1x 16 bytes
>         bInterval               6
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       VideoStreaming Interface Descriptor:
>         bLength                            15
>         bDescriptorType                    36
>         bDescriptorSubtype                  1 (INPUT_HEADER)
>         bNumFormats                         2
>         wTotalLength                      395
>         bEndPointAddress                  129
>         bmInfo                              0
>         bTerminalLink                       3
>         bStillCaptureMethod                 1
>         bTriggerSupport                     1
>         bTriggerUsage                       0
>         bControlSize                        1
>         bmaControls( 0)                     0
>         bmaControls( 1)                     0
>       VideoStreaming Interface Descriptor:
>         bLength                            11
>         bDescriptorType                    36
>         bDescriptorSubtype                  6 (FORMAT_MJPEG)
>         bFormatIndex                        1
>         bNumFrameDescriptors                5
>         bFlags                              1
>           Fixed-size samples: Yes
>         bDefaultFrameIndex                  1
>         bAspectRatioX                       0
>         bAspectRatioY                       0
>         bmInterlaceFlags                 0x00
>           Interlaced stream or variable: No
>           Fields per frame: 1 fields
>           Field 1 first: No
>           Field pattern: Field 1 only
>         bCopyProtect                        0
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  7 (FRAME_MJPEG)
>         bFrameIndex                         1
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                            640
>         wHeight                           480
>         dwMinBitRate                147456000
>         dwMaxBitRate                147456000
>         dwMaxVideoFrameBufferSize      614400
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  7 (FRAME_MJPEG)
>         bFrameIndex                         2
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                           1280
>         wHeight                           720
>         dwMinBitRate                442368000
>         dwMaxBitRate                442368000
>         dwMaxVideoFrameBufferSize     1843200
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  7 (FRAME_MJPEG)
>         bFrameIndex                         3
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                            960
>         wHeight                           540
>         dwMinBitRate                248832000
>         dwMaxBitRate                248832000
>         dwMaxVideoFrameBufferSize     1036800
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  7 (FRAME_MJPEG)
>         bFrameIndex                         4
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                            848
>         wHeight                           480
>         dwMinBitRate                195379200
>         dwMaxBitRate                195379200
>         dwMaxVideoFrameBufferSize      814080
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  7 (FRAME_MJPEG)
>         bFrameIndex                         5
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                            640
>         wHeight                           360
>         dwMinBitRate                110592000
>         dwMaxBitRate                110592000
>         dwMaxVideoFrameBufferSize      460800
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                             6
>         bDescriptorType                    36
>         bDescriptorSubtype                 13 (COLORFORMAT)
>         bColorPrimaries                     1 (BT.709,sRGB)
>         bTransferCharacteristics            1 (BT.709)
>         bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
>       VideoStreaming Interface Descriptor:
>         bLength                            27
>         bDescriptorType                    36
>         bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
>         bFormatIndex                        2
>         bNumFrameDescriptors                6
>         guidFormat
> {32595559-0000-0010-8000-00aa00389b71}
>         bBitsPerPixel                      16
>         bDefaultFrameIndex                  1
>         bAspectRatioX                       0
>         bAspectRatioY                       0
>         bmInterlaceFlags                 0x00
>           Interlaced stream or variable: No
>           Fields per frame: 2 fields
>           Field 1 first: No
>           Field pattern: Field 1 only
>         bCopyProtect                        0
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>         bFrameIndex                         1
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                            640
>         wHeight                           480
>         dwMinBitRate                147456000
>         dwMaxBitRate                147456000
>         dwMaxVideoFrameBufferSize      614400
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>         bFrameIndex                         2
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                            640
>         wHeight                           360
>         dwMinBitRate                110592000
>         dwMaxBitRate                110592000
>         dwMaxVideoFrameBufferSize      460800
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>         bFrameIndex                         3
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                            424
>         wHeight                           240
>         dwMinBitRate                 48844800
>         dwMaxBitRate                 48844800
>         dwMaxVideoFrameBufferSize      203520
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>         bFrameIndex                         4
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                            320
>         wHeight                           240
>         dwMinBitRate                 36864000
>         dwMaxBitRate                 36864000
>         dwMaxVideoFrameBufferSize      153600
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>         bFrameIndex                         5
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                            320
>         wHeight                           180
>         dwMinBitRate                 27648000
>         dwMaxBitRate                 27648000
>         dwMaxVideoFrameBufferSize      115200
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>         bFrameIndex                         6
>         bmCapabilities                   0x01
>           Still image supported
>         wWidth                            160
>         wHeight                           120
>         dwMinBitRate                  9216000
>         dwMaxBitRate                  9216000
>         dwMaxVideoFrameBufferSize       38400
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                             6
>         bDescriptorType                    36
>         bDescriptorSubtype                 13 (COLORFORMAT)
>         bColorPrimaries                     1 (BT.709,sRGB)
>         bTransferCharacteristics            1 (BT.709)
>         bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       1
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0080  1x 128 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       2
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       3
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       4
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0b00  2x 768 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       5
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0c00  2x 1024 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       6
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x13aa  3x 938 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       7
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x1400  3x 1024 bytes
>         bInterval               1
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         2
>       bInterfaceCount         2
>       bFunctionClass         14 Video
>       bFunctionSubClass       3 Video Interface Collection
>       bFunctionProtocol       0
>       iFunction               6 Integrated Webcam
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      1 Video Control
>       bInterfaceProtocol      0
>       iInterface              6 Integrated Webcam
>       VideoControl Interface Descriptor:
>         bLength                13
>         bDescriptorType        36
>         bDescriptorSubtype      1 (HEADER)
>         bcdUVC               1.00
>         wTotalLength          103
>         dwClockFrequency       15.000000MHz
>         bInCollection           1
>         baInterfaceNr( 0)       3
>       VideoControl Interface Descriptor:
>         bLength                18
>         bDescriptorType        36
>         bDescriptorSubtype      2 (INPUT_TERMINAL)
>         bTerminalID            11
>         wTerminalType      0x0201 Camera Sensor
>         bAssocTerminal          0
>         iTerminal               0
>         wObjectiveFocalLengthMin      0
>         wObjectiveFocalLengthMax      0
>         wOcularFocalLength            0
>         bControlSize                  3
>         bmControls           0x00000000
>       VideoControl Interface Descriptor:
>         bLength                11
>         bDescriptorType        36
>         bDescriptorSubtype      5 (PROCESSING_UNIT)
>       Warning: Descriptor too short
>         bUnitID                 9
>         bSourceID              11
>         wMaxMultiplier          0
>         bControlSize            2
>         bmControls     0x00000000
>         iProcessing             0
>         bmVideoStandards     0x09
>           None
>           SECAM - 625/50
>       VideoControl Interface Descriptor:
>         bLength                 9
>         bDescriptorType        36
>         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
>         bTerminalID             8
>         wTerminalType      0x0101 USB Streaming
>         bAssocTerminal          0
>         bSourceID              10
>         iTerminal               0
>       VideoControl Interface Descriptor:
>         bLength                25
>         bDescriptorType        36
>         bDescriptorSubtype      6 (EXTENSION_UNIT)
>         bUnitID                12
>         guidExtensionCode         {45b5da73-23c1-4a3d-a368-610f078c4397}
>         bNumControl             0
>         bNrPins                 1
>         baSourceID( 0)          9
>         bControlSize            0
>         iExtension              0
>       VideoControl Interface Descriptor:
>         bLength                27
>         bDescriptorType        36
>         bDescriptorSubtype      6 (EXTENSION_UNIT)
>         bUnitID                10
>         guidExtensionCode         {1229a78c-47b4-4094-b0ce-db07386fb938}
>         bNumControl             2
>         bNrPins                 1
>         baSourceID( 0)         12
>         bControlSize            2
>         bmControls( 0)       0x00
>         bmControls( 1)       0x06
>         iExtension              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0010  1x 16 bytes
>         bInterval               6
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       VideoStreaming Interface Descriptor:
>         bLength                            14
>         bDescriptorType                    36
>         bDescriptorSubtype                  1 (INPUT_HEADER)
>         bNumFormats                         1
>         wTotalLength                       87
>         bEndPointAddress                  130
>         bmInfo                              0
>         bTerminalLink                       8
>         bStillCaptureMethod                 2
>         bTriggerSupport                     1
>         bTriggerUsage                       0
>         bControlSize                        1
>         bmaControls( 0)                     0
>       VideoStreaming Interface Descriptor:
>         bLength                            27
>         bDescriptorType                    36
>         bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
>         bFormatIndex                        1
>         bNumFrameDescriptors                1
>         guidFormat
> {32595559-0000-0010-8000-00aa00389b71}
>         bBitsPerPixel                      16
>         bDefaultFrameIndex                  1
>         bAspectRatioX                       0
>         bAspectRatioY                       0
>         bmInterlaceFlags                 0x00
>           Interlaced stream or variable: No
>           Fields per frame: 2 fields
>           Field 1 first: No
>           Field pattern: Field 1 only
>         bCopyProtect                        0
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>         bFrameIndex                         1
>         bmCapabilities                   0x00
>           Still image unsupported
>         wWidth                            340
>         wHeight                           374
>         dwMinBitRate                 61036800
>         dwMaxBitRate                 61036800
>         dwMaxVideoFrameBufferSize      254320
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            10
>         bDescriptorType                    36
>         bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
>         bEndpointAddress                    0
>         bNumImageSizePatterns               1
>         wWidth( 0)                        340
>         wHeight( 0)                       374
>         bNumCompressionPatterns             0
>       VideoStreaming Interface Descriptor:
>         bLength                             6
>         bDescriptorType                    36
>         bDescriptorSubtype                 13 (COLORFORMAT)
>         bColorPrimaries                     1 (BT.709,sRGB)
>         bTransferCharacteristics            1 (BT.709)
>         bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       1
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0080  1x 128 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       2
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       3
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       4
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0b00  2x 768 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       5
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x0c00  2x 1024 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       6
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x13aa  3x 938 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       7
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x1400  3x 1024 bytes
>         bInterval               1
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)
> 
> 
> 
> thanks,
> 

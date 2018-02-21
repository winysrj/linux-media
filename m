Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53898 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeBUVXy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 16:23:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: chf.fritz@googlemail.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Norbert Wesp <n.wesp@phytec.de>,
        Dirk Bender <D.bender@phytec.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH] uvcvideo: add quirk to force Phytec CAM 004H to GBRG
Date: Wed, 21 Feb 2018 23:24:36 +0200
Message-ID: <2434247.Ztdr7ET7Sd@avalon>
In-Reply-To: <1519245765.11643.44.camel@googlemail.com>
References: <1519212389.11643.13.camel@googlemail.com> <1971379.NnuTUWjF6a@avalon> <1519245765.11643.44.camel@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,

(CC'ing Philipp Zabel)

On Wednesday, 21 February 2018 22:42:45 EET Christoph Fritz wrote:
> Hi Laurent
> 
> > Could you please send me the output of 'lsusb -d 199e:8302 -v' (if
> > possible running as root) ?
> 
> please see bottom of this mail
> 
> >> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> >> Tested-by: Norbert Wesp <n.wesp@phytec.de>
> >> ---
> >> 
> >>  drivers/media/usb/uvc/uvc_driver.c | 16 ++++++++++++++++
> >>  drivers/media/usb/uvc/uvcvideo.h   |  1 +
> >>  2 files changed, 17 insertions(+)
> >> 
> >> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> >> b/drivers/media/usb/uvc/uvc_driver.c index cde43b6..8bfa40b 100644
> >> --- a/drivers/media/usb/uvc/uvc_driver.c
> >> +++ b/drivers/media/usb/uvc/uvc_driver.c
> >> @@ -406,6 +406,13 @@ static int uvc_parse_format(struct uvc_device *dev,
> >>  				width_multiplier = 2;
> >>  			}
> >>  		}
> >> 
> >> +		if (dev->quirks & UVC_QUIRK_FORCE_GBRG) {
> >> +			if (format->fcc == V4L2_PIX_FMT_SGRBG8) {
> >> +				strlcpy(format->name, "GBRG Bayer (GBRG)",
> >> +					sizeof(format->name));
> >> +				format->fcc = V4L2_PIX_FMT_SGBRG8;
> >> +			}
> >> +		}
> >> 
> >>  		if (buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED) {
> >>  			ftype = UVC_VS_FRAME_UNCOMPRESSED;
> >> @@ -2631,6 +2638,15 @@ static struct usb_device_id uvc_ids[] = {
> >>  	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
> >>  	  .bInterfaceSubClass	= 1,
> >>  	  .bInterfaceProtocol	= 0 },
> >> +	/* PHYTEC CAM 004H cameras */
> >> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> >> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> >> +	  .idVendor		= 0x199e,
> >> +	  .idProduct		= 0x8302,
> >> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> >> +	  .bInterfaceSubClass	= 1,
> >> +	  .bInterfaceProtocol	= 0,
> >> +	  .driver_info		= UVC_QUIRK_FORCE_GBRG },
> >>  	/* Bodelin ProScopeHR */
> >>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> >>  				| USB_DEVICE_ID_MATCH_DEV_HI
> >> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> >> b/drivers/media/usb/uvc/uvcvideo.h index 7e4d3ee..ad51002 100644
> >> --- a/drivers/media/usb/uvc/uvcvideo.h
> >> +++ b/drivers/media/usb/uvc/uvcvideo.h
> >> @@ -164,6 +164,7 @@
> >>  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
> >>  #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
> >>  #define UVC_QUIRK_FORCE_Y8		0x00000800
> >> +#define UVC_QUIRK_FORCE_GBRG		0x00001000
> > 
> > I don't think we should add a quirk flag for every format that needs to be
> > forced. Instead, now that we have a new way to store per-device parameters
> > since commit 3bc85817d798 ("media: uvcvideo: Add extensible device
> > information"), how about making use of it and adding a field to the
> > uvc_device_info structure to store the forced format ?
> 
> I'm currently stuck on kernel 4.9, but for mainline I'll use extensible
> device information and send a v2 in the next weeks.
> 
> output of 'lsusb -d 199e:8302 -v':
> 
> Bus 001 Device 010: ID 199e:8302 The Imaging Source Europe GmbH
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   idVendor           0x199e The Imaging Source Europe GmbH
>   idProduct          0x8302
>   bcdDevice            8.13
>   iManufacturer           2 ?
>   iProduct                1 ?
>   iSerial                 3 ?
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          349
>     bNumInterfaces          2
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         0
>       bInterfaceCount         2
>       bFunctionClass         14 Video
>       bFunctionSubClass       3 Video Interface Collection
>       bFunctionProtocol       0
>       iFunction               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      1 Video Control
>       bInterfaceProtocol      0
>       iInterface              0
>       VideoControl Interface Descriptor:
>         bLength                13
>         bDescriptorType        36
>         bDescriptorSubtype      1 (HEADER)
>         bcdUVC               1.00
>         wTotalLength           78
>         dwClockFrequency        6.000000MHz
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
>         bmControls           0x0004001a
>           Auto-Exposure Mode
>           Exposure Time (Absolute)
>           Exposure Time (Relative)
>           Privacy
>       VideoControl Interface Descriptor:
>         bLength                12
>         bDescriptorType        36
>         bDescriptorSubtype      5 (PROCESSING_UNIT)
>       Warning: Descriptor too short
>         bUnitID                 3
>         bSourceID               1
>         wMaxMultiplier          0
>         bControlSize            3
>         bmControls     0x00000200
>           Gain
>         iProcessing             0
>         bmVideoStandards     0x1a
>           NTSC - 525/60
>           SECAM - 625/50
>           NTSC - 625/50
>       VideoControl Interface Descriptor:
>         bLength                26
>         bDescriptorType        36
>         bDescriptorSubtype      6 (EXTENSION_UNIT)
>         bUnitID                 4
>         guidExtensionCode         {95d63e92-f256-e111-83f7-37704824019b}
>         bNumControl             0
>         bNrPins                 1
>         baSourceID( 0)          3
>         bControlSize            1
>         bmControls( 0)       0x0f
>         iExtension              0
>       VideoControl Interface Descriptor:
>         bLength                 9
>         bDescriptorType        36
>         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
>         bTerminalID             2
>         wTerminalType      0x0101 USB Streaming
>         bAssocTerminal          0
>         bSourceID               4
>         iTerminal               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               9
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0
>       iInterface              0
>       VideoStreaming Interface Descriptor:
>         bLength                            15
>         bDescriptorType                    36
>         bDescriptorSubtype                  1 (INPUT_HEADER)
>       Warning: Descriptor too short
>         bNumFormats                         3
>         wTotalLength                      169
>         bEndPointAddress                  130
>         bmInfo                              0
>         bTerminalLink                       2
>         bStillCaptureMethod                 2
>         bTriggerSupport                     1
>         bTriggerUsage                       0
>         bControlSize                        2
>         bmaControls( 0)                     5
>         bmaControls( 1)                     5
>         bmaControls( 2)                     5
>       VideoStreaming Interface Descriptor:
>         bLength                            28
>         bDescriptorType                    36
>         bDescriptorSubtype                 16 (FORMAT_FRAME_BASED)
>         bFormatIndex                        1
>         bNumFrameDescriptors                5
>         guidFormat                           
> {47524247-0000-1000-8000-00aa00389b71}

I only know of two devices supporting this format, this one and the DFx 
72BUC02. The only two devices I'm aware of that use other Bayer formats are 
the DFK 23UV024 and DFK 23UX249, and they both report a GBRG format.

I wonder if the DFx 72BUC02 is affected too. In any case, as your device 
exposes a single format, you can force the format to V4L2_PIX_FMT_SGBRG8 
without first checking whether it is equal to V4L2_PIX_FMT_SGRBG8. Feel free 
to patch the existing FORCE_Y8 code to also remove the format check, I've 
discussed it today with Philipp Zabel who implemented the FORCE_Y8 quirk and 
he's fine with that.

>         bBitsPerPixel                       8
>         bDefaultFrameIndex                  1
>         bAspectRatioX                      16
>         bAspectRatioY                       9
>         bmInterlaceFlags                 0x86
>           Interlaced stream or variable: No
>           Fields per frame: 1 fields
>           Field 1 first: Yes
>           Field pattern: Field 1 only
>           bCopyProtect                      0
>           bVariableSize                     0
>       VideoStreaming Interface Descriptor:
>         bLength                            42
>         bDescriptorType                    36
>         bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
>         bFrameIndex                         1
>         bmCapabilities                   0x00
>           Still image unsupported
>         wWidth                            744
>         wHeight                           480
>         dwMinBitRate                4294950144
>         dwMaxBitRate                4294964224
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  4
>         dwBytesPerLine                    744
>         dwFrameInterval( 0)            166667
>         dwFrameInterval( 1)            333333
>         dwFrameInterval( 2)            400000
>         dwFrameInterval( 3)            666667
>       VideoStreaming Interface Descriptor:
>         bLength                            42
>         bDescriptorType                    36
>         bDescriptorSubtype                 17 (FRAME_FRAME_BASED)
>         bFrameIndex                         4
>         bmCapabilities                   0x00
>           Still image unsupported
>         wWidth                            640
>         wHeight                           480
>         dwMinBitRate                4294946816
>         dwMaxBitRate                4294942720
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  4
>         dwBytesPerLine                    640
>         dwFrameInterval( 0)            166667
>         dwFrameInterval( 1)            333333
>         dwFrameInterval( 2)            400000
>         dwFrameInterval( 3)            666667
>       VideoStreaming Interface Descriptor:
>         bLength                             6
>         bDescriptorType                    36
>         bDescriptorSubtype                 13 (COLORFORMAT)
>         bColorPrimaries                     0 (Unspecified)
>         bTransferCharacteristics            0 (Unspecified)
>         bMatrixCoefficients                 0 (Unspecified)
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               1
>         ** UNRECOGNIZED:  02 23
>         ** UNRECOGNIZED:  20 ac 75 10 02 75 11 e8 02 1d 4b 12 20 5e 7d 40 7c
> 01 7f 04 12 28 33 7d f0 7c 00 7f 03 12 28 33 Device Qualifier (for other
> device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)

Thank you.

-- 
Regards,

Laurent Pinchart

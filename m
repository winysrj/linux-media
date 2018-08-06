Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:47634 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732726AbeHGBYp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 21:24:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: chf.fritz@googlemail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Norbert Wesp <n.wesp@phytec.de>,
        Dirk Bender <D.bender@phytec.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH] uvcvideo: add quirk to force Phytec CAM 004H to GBRG
Date: Tue, 07 Aug 2018 02:14:07 +0300
Message-ID: <1860315.IXoSrtTCf6@avalon>
In-Reply-To: <2434247.Ztdr7ET7Sd@avalon>
References: <1519212389.11643.13.camel@googlemail.com> <1519245765.11643.44.camel@googlemail.com> <2434247.Ztdr7ET7Sd@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,

On Wednesday, 21 February 2018 23:24:36 EEST Laurent Pinchart wrote:
> On Wednesday, 21 February 2018 22:42:45 EET Christoph Fritz wrote:
> > Hi Laurent
> > 
> >> Could you please send me the output of 'lsusb -d 199e:8302 -v' (if
> >> possible running as root) ?
> > 
> > please see bottom of this mail
> > 
> >>> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> >>> Tested-by: Norbert Wesp <n.wesp@phytec.de>
> >>> ---
> >>> 
> >>>  drivers/media/usb/uvc/uvc_driver.c | 16 ++++++++++++++++
> >>>  drivers/media/usb/uvc/uvcvideo.h   |  1 +
> >>>  2 files changed, 17 insertions(+)
> >>> 
> >>> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> >>> b/drivers/media/usb/uvc/uvc_driver.c index cde43b6..8bfa40b 100644
> >>> --- a/drivers/media/usb/uvc/uvc_driver.c
> >>> +++ b/drivers/media/usb/uvc/uvc_driver.c
> >>> @@ -406,6 +406,13 @@ static int uvc_parse_format(struct uvc_device
> >>> *dev,
> >>>  				width_multiplier = 2;
> >>>  			}
> >>>  		}
> >>> +		if (dev->quirks & UVC_QUIRK_FORCE_GBRG) {
> >>> +			if (format->fcc == V4L2_PIX_FMT_SGRBG8) {
> >>> +				strlcpy(format->name, "GBRG Bayer (GBRG)",
> >>> +					sizeof(format->name));
> >>> +				format->fcc = V4L2_PIX_FMT_SGBRG8;
> >>> +			}
> >>> +		}
> >>> 
> >>>  		if (buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED) {
> >>>  			ftype = UVC_VS_FRAME_UNCOMPRESSED;
> >>> @@ -2631,6 +2638,15 @@ static struct usb_device_id uvc_ids[] = {
> >>>  	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
> >>>  	  .bInterfaceSubClass	= 1,
> >>>  	  .bInterfaceProtocol	= 0 },
> >>> +	/* PHYTEC CAM 004H cameras */
> >>> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> >>> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> >>> +	  .idVendor		= 0x199e,
> >>> +	  .idProduct		= 0x8302,
> >>> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> >>> +	  .bInterfaceSubClass	= 1,
> >>> +	  .bInterfaceProtocol	= 0,
> >>> +	  .driver_info		= UVC_QUIRK_FORCE_GBRG },
> >>>  	/* Bodelin ProScopeHR */
> >>>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> >>>  				| USB_DEVICE_ID_MATCH_DEV_HI
> >>> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> >>> b/drivers/media/usb/uvc/uvcvideo.h index 7e4d3ee..ad51002 100644
> >>> --- a/drivers/media/usb/uvc/uvcvideo.h
> >>> +++ b/drivers/media/usb/uvc/uvcvideo.h
> >>> @@ -164,6 +164,7 @@
> >>>  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
> >>>  #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
> >>>  #define UVC_QUIRK_FORCE_Y8		0x00000800
> >>> +#define UVC_QUIRK_FORCE_GBRG		0x00001000
> >> 
> >> I don't think we should add a quirk flag for every format that needs to
> >> be forced. Instead, now that we have a new way to store per-device
> >> parameters since commit 3bc85817d798 ("media: uvcvideo: Add extensible
> >> device information"), how about making use of it and adding a field to
> >> the uvc_device_info structure to store the forced format ?
> > 
> > I'm currently stuck on kernel 4.9, but for mainline I'll use extensible
> > device information and send a v2 in the next weeks.
> > 
> > output of 'lsusb -d 199e:8302 -v':
> > 
> > Bus 001 Device 010: ID 199e:8302 The Imaging Source Europe GmbH
> > 
> > Device Descriptor:
> >   bLength                18
> >   bDescriptorType         1
> >   bcdUSB               2.00
> >   bDeviceClass          239 Miscellaneous Device
> >   bDeviceSubClass         2 ?
> >   bDeviceProtocol         1 Interface Association
> >   bMaxPacketSize0        64
> >   idVendor           0x199e The Imaging Source Europe GmbH
> >   idProduct          0x8302
> >   bcdDevice            8.13
> >   iManufacturer           2 ?
> >   iProduct                1 ?
> >   iSerial                 3 ?
> >   bNumConfigurations      1

[snip]

> >       VideoStreaming Interface Descriptor:
> >         bLength                            28
> >         bDescriptorType                    36
> >         bDescriptorSubtype                 16 (FORMAT_FRAME_BASED)
> >         bFormatIndex                        1
> >         bNumFrameDescriptors                5
> >         guidFormat
> > {47524247-0000-1000-8000-00aa00389b71}
> 
> I only know of two devices supporting this format, this one and the DFx
> 72BUC02. The only two devices I'm aware of that use other Bayer formats are
> the DFK 23UV024 and DFK 23UX249, and they both report a GBRG format.
> 
> I wonder if the DFx 72BUC02 is affected too. In any case, as your device
> exposes a single format, you can force the format to V4L2_PIX_FMT_SGBRG8
> without first checking whether it is equal to V4L2_PIX_FMT_SGRBG8. Feel free
> to patch the existing FORCE_Y8 code to also remove the format check, I've
> discussed it today with Philipp Zabel who implemented the FORCE_Y8 quirk
> and he's fine with that.

Any update on a v2 for this patch ?

-- 
Regards,

Laurent Pinchart

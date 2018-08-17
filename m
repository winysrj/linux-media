Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37516 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbeHQLvS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 07:51:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: chf.fritz@googlemail.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Norbert Wesp <n.wesp@phytec.de>,
        Dirk Bender <D.bender@phytec.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH] uvcvideo: add quirk to force Phytec CAM 004H to GBRG
Date: Fri, 17 Aug 2018 11:49:35 +0300
Message-ID: <59022590.4QMSz7CzYA@avalon>
In-Reply-To: <1534489752.2514.2.camel@googlemail.com>
References: <1519212389.11643.13.camel@googlemail.com> <4073605.T2oYED4Iz8@avalon> <1534489752.2514.2.camel@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,

On Friday, 17 August 2018 10:09:12 EEST Christoph Fritz wrote:
> On Thu, 2018-08-16 at 19:39 +0300, Laurent Pinchart wrote:
> > On Thursday, 16 August 2018 15:48:15 EEST Christoph Fritz wrote:
> >>> On Wednesday, 21 February 2018 23:24:36 EEST Laurent Pinchart wrote:
> >>>> On Wednesday, 21 February 2018 22:42:45 EET Christoph Fritz wrote:

[snip]

> >>>>>>> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> >>>>>>> b/drivers/media/usb/uvc/uvcvideo.h index 7e4d3ee..ad51002 100644
> >>>>>>> --- a/drivers/media/usb/uvc/uvcvideo.h
> >>>>>>> +++ b/drivers/media/usb/uvc/uvcvideo.h
> >>>>>>> @@ -164,6 +164,7 @@
> >>>>>>>  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
> >>>>>>>  #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
> >>>>>>>  #define UVC_QUIRK_FORCE_Y8		0x00000800
> >>>>>>> +#define UVC_QUIRK_FORCE_GBRG		0x00001000
> >>>>>> 
> >>>>>> I don't think we should add a quirk flag for every format that
> >>>>>> needs to be forced. Instead, now that we have a new way to store
> >>>>>> per-device parameters since commit 3bc85817d798 ("media: uvcvideo:
> >>>>>> Add extensible device information"), how about making use of it and
> >>>>>> adding a field to the uvc_device_info structure to store the forced
> >>>>>> format ?
> >> 
> >> you mean something like:
> >>  
> >>  struct uvc_device_info {
> >>         u32     quirks;
> >> +       u32     forced_color_format;
> >>         u32     meta_format;
> >>  };
> >> 
> >> and
> >> 
> >> +static const struct uvc_device_info uvc_forced_color_sgbrg8 = {
> >> +       .forced_color_format = V4L2_PIX_FMT_SGBRG8,
> >> +};
> >> 
> >> and
> >> 
> >> @@ -2817,7 +2820,7 @@ static const struct usb_device_id uvc_ids[] = {
> >>           .bInterfaceClass      = USB_CLASS_VENDOR_SPEC,
> >>           .bInterfaceSubClass   = 1,
> >>           .bInterfaceProtocol   = 0,
> >> -         .driver_info          = (kernel_ulong_t)&uvc_quirk_force_y8 },
> >> +         .driver_info          = (kernel_ulong_t)&uvc_forced_color_y8
> >> },
> >> 
> >> ?
> > 
> > With an additional
> > 
> > static const struct uvc_device_info uvc_forced_color_y8 = {
> > 	.forced_color_format = V4L2_PIX_FMT_GREY,
> > };
> > 
> >> If yes:
> >>  - there would be a need for forced_color_format in struct uvc_device
> > 
> > Why so ?
> 
> What is the alternative?
> Is there a better way to access "uvc_device_info->forced_color_format"
> from within function uvc_parse_format()?

I'd rather do that, yes. We can store a pointer to uvc_device_info in the 
uvc_device structure to make that easier. I'll post a patch to do so in reply 
to this e-mail.

> >>  - module-parameter quirk would not test force color format any more
> >>  
> >>  - the actual force/quirk changes not only format->fcc:
> >>                 if (dev->forced_color_format == V4L2_PIX_FMT_SGBRG8) {
> > 
> > The test should be if (dev->forced_color_format) to cover both the Y8 and
> > SGBRG8 cases.
> > 
> >>                         strlcpy(format->name, "Greyscale 8-bit (Y8  )",
> >>                                 sizeof(format->name));
> > 
> > You can get the name from the uvc_fmts entry corresponding to dev->
> > forced_color_format.
> >>
> >>                         format->fcc = dev->forced_color_format;
> >>                         format->bpp = 8;
> >>                         width_multiplier = 2;
> > 
> > bpp and multiplier are more annoying. bpp is a property of the format,
> > which we could add to the uvc_fmts array.
> > 
> > I believe the multiplier could be computed by device bpp / bpp from
> > uvc_fmts. That would work at least for the Oculus VR Positional Tracker
> > DK2, but I don't have the Oculus VR Rift Sensor descriptors to check
> > that. Philipp, if you still have access to the device, could you send
> > that to me ?
> > 
> >>                 }
> >> 
> >> Is this the way you want me to go?

-- 
Regards,

Laurent Pinchart

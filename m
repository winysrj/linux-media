Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55519 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaJFOes (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 10:34:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] [media] uvcvideo: Add quirk to force the Oculus DK2 IR tracker to grayscale
Date: Mon, 06 Oct 2014 17:34:54 +0300
Message-ID: <2999205.OqlimhFfiu@avalon>
In-Reply-To: <CA+gwMccqt9zP4bOdDKyiZa=S+xPuZgcpg4aWcdUCyqwobAnKfQ@mail.gmail.com>
References: <1407358249-19605-1-git-send-email-philipp.zabel@gmail.com> <CA+gwMccqt9zP4bOdDKyiZa=S+xPuZgcpg4aWcdUCyqwobAnKfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Monday 29 September 2014 21:38:39 Philipp Zabel wrote:
> On Wed, Aug 6, 2014 at 10:50 PM, Philipp Zabel wrote:
> > This patch adds a quirk to force Y8 pixel format even if the camera
> > reports half-width YUYV.
> > 
> > Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> 
> do you have any further comments on this patch?

Sorry for the late reply. Please see below for a couple of small comments.

> > ---
> > 
> >  drivers/media/usb/uvc/uvc_driver.c | 29 ++++++++++++++++++++++++++++-
> >  drivers/media/usb/uvc/uvcvideo.h   |  1 +
> >  2 files changed, 29 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index c3bb250..90a8f10 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -311,6 +311,7 @@ static int uvc_parse_format(struct uvc_device *dev,
> >         struct uvc_format_desc *fmtdesc;
> >         struct uvc_frame *frame;
> >         const unsigned char *start = buffer;
> > +       bool force_yuy2_to_y8 = false;

To keep things a bit more generic, how about an unsigned int width_multiplier 
initialized to 1 and set to 2 when the quirk applies ?

> >         unsigned int interval;
> >         unsigned int i, n;
> >         __u8 ftype;
> > @@ -333,6 +334,22 @@ static int uvc_parse_format(struct uvc_device *dev,
> > 
> >                 /* Find the format descriptor from its GUID. */
> >                 fmtdesc = uvc_format_by_guid(&buffer[5]);
> > +               format->bpp = buffer[21];
> > +
> > +               if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
> > +                       if (fmtdesc && fmtdesc->fcc == V4L2_PIX_FMT_YUYV
> > &&
> > +                           format->bpp == 16) {

I wonder if that check is really needed, all YUYV formats should have 16bpp.

> > +                               force_yuy2_to_y8 = true;
> > +                               fmtdesc = &uvc_fmts[9];

The hardcoded index here is hair-raising :-) How about something like the 
following instead ?

 		}
 
 		format->bpp = buffer[21];
+
+		/* Some devices report a format that doesn't match what they
+		 * really send.
+		 */
+		if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
+			if (format->fcc == V4L2_PIX_FMT_YUYV) {
+				strlcpy(format->name, "Greyscale 8-bit (Y8  )",
+					sizeof(format->name));
+				format->fcc = V4L2_PIX_FMT_GREY;
+				format->bpp = 8;
+				width_multiplier = 2;
+			}
+		}
+
 		if (buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED) {
 			ftype = UVC_VS_FRAME_UNCOMPRESSED;
 		} else {

I know it duplicates the format string, but as we're trying to move them to 
the V4L2 core anyway, I don't see that as being a big problem.


> > +                               format->bpp = 8;
> > +                       } else {
> > +                               uvc_printk(KERN_WARNING,
> > +                                       "Forcing %d-bit %s to %s not
> > supported",
> > +                                       format->bpp, fmtdesc->name,
> > +                                       uvc_fmts[9].name);
> > +                       }
> > +               }
> > +
> >                 if (fmtdesc != NULL) {
> >                         strlcpy(format->name, fmtdesc->name,
> >                                 sizeof format->name);
> > @@ -345,7 +362,6 @@ static int uvc_parse_format(struct uvc_device *dev,
> >                         format->fcc = 0;
> >                 }
> > 
> > -               format->bpp = buffer[21];
> >                 if (buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED) {
> >                         ftype = UVC_VS_FRAME_UNCOMPRESSED;
> >                 } else {
> > @@ -455,6 +471,8 @@ static int uvc_parse_format(struct uvc_device *dev,
> >                 frame->bFrameIndex = buffer[3];
> >                 frame->bmCapabilities = buffer[4];
> >                 frame->wWidth = get_unaligned_le16(&buffer[5]);
> > +               if (force_yuy2_to_y8)
> > +                       frame->wWidth *= 2;

This would become

+		frame->wWidth = get_unaligned_le16(&buffer[5])
+			      * width_multiplier;

If you're fine with that there's no need to resubmit, I'll modify the patch 
when applying it to my tree.

> >                 frame->wHeight = get_unaligned_le16(&buffer[7]);
> >                 frame->dwMinBitRate = get_unaligned_le32(&buffer[9]);
> >                 frame->dwMaxBitRate = get_unaligned_le32(&buffer[13]);
> > @@ -2467,6 +2485,15 @@ static struct usb_device_id uvc_ids[] = {
> >           .bInterfaceProtocol   = 0,
> >           .driver_info          = UVC_QUIRK_PROBE_MINMAX
> >                                 | UVC_QUIRK_IGNORE_SELECTOR_UNIT },
> > +       /* Oculus VR Positional Tracker DK2 */
> > +       { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
> > +                               | USB_DEVICE_ID_MATCH_INT_INFO,
> > +         .idVendor             = 0x2833,
> > +         .idProduct            = 0x0201,
> > +         .bInterfaceClass      = USB_CLASS_VIDEO,
> > +         .bInterfaceSubClass   = 1,
> > +         .bInterfaceProtocol   = 0,
> > +         .driver_info          = UVC_QUIRK_FORCE_Y8 },
> >         /* Generic USB Video Class */
> >         { USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, 0) },
> >         {}
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h
> > b/drivers/media/usb/uvc/uvcvideo.h index 9e35982..1dd78c0 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -137,6 +137,7 @@
> >  #define UVC_QUIRK_FIX_BANDWIDTH                0x00000080
> >  #define UVC_QUIRK_PROBE_DEF            0x00000100
> >  #define UVC_QUIRK_RESTRICT_FRAME_RATE  0x00000200
> > +#define UVC_QUIRK_FORCE_Y8             0x00000400
> > 
> >  /* Format flags */
> >  #define UVC_FMT_FLAG_COMPRESSED                0x00000001

-- 
Regards,

Laurent Pinchart


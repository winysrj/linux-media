Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45930 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728936AbeHGAMn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 20:12:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pavel Rojtberg <rojtberg@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: extend UVC_QUIRK_FIX_BANDWIDTH to MJPEG streams
Date: Tue, 07 Aug 2018 01:02:20 +0300
Message-ID: <3352116.QQFTFoArGT@avalon>
In-Reply-To: <CA+b0ujcJ3+vzPJNJVN01gXaaJYXob0zdB0SWK3-aH2yJUqQ6tQ@mail.gmail.com>
References: <1504512857-4202-1-git-send-email-rojtberg@gmail.com> <3504719.Oh46EvsF34@avalon> <CA+b0ujcJ3+vzPJNJVN01gXaaJYXob0zdB0SWK3-aH2yJUqQ6tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tuesday, 5 September 2017 20:27:39 EEST Pavel Rojtberg wrote:
> 2017-09-04 11:56 GMT+02:00 Laurent Pinchart:
> > On Monday, 4 September 2017 11:14:17 EEST Pavel Rojtberg wrote:
> >> From: Pavel Rojtberg <rojtberg@gmail.com>
> >> 
> >> attaching two Logitech C615 webcams currently results in
> >> 
> >>     VIDIOC_STREAMON: No space left on device
> >> 
> >> as the required bandwidth is not estimated correctly by the device.
> >> In fact it always requests 3060 bytes - no matter the format or
> >> resolution.
> >> 
> >> setting UVC_QUIRK_FIX_BANDWIDTH does not help either as it is only
> >> implemented for uncompressed streams.
> >> 
> >> This patch extends UVC_QUIRK_FIX_BANDWIDTH to MJPEG streams by making a
> >> (conservative) assumption of 4bpp for MJPEG streams.
> >> As the actual compression ration is often closer to 1bpp this can be
> >> overridden via the new mjpeg_bpp parameter.
> >> 
> >> Based on:
> >> https://www.mail-archive.com/linux-uvc-devel@lists.berlios.de/msg05724.ht
> >> ml
> >> ---
> >> 
> >>  drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++++-
> >>  drivers/media/usb/uvc/uvc_video.c  |  3 ++-
> >>  2 files changed, 15 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> >> b/drivers/media/usb/uvc/uvc_driver.c index 70842c5..f7b759e 100644
> >> --- a/drivers/media/usb/uvc/uvc_driver.c
> >> +++ b/drivers/media/usb/uvc/uvc_driver.c
> >> @@ -37,6 +37,7 @@ unsigned int uvc_no_drop_param;
> >>  static unsigned int uvc_quirks_param = -1;
> >>  unsigned int uvc_trace_param;
> >>  unsigned int uvc_timeout_param = UVC_CTRL_STREAMING_TIMEOUT;
> >> +static unsigned int uvc_mjpeg_bpp_param;
> >> 
> >>  /* ---------------------------------------------------------------------
> >>   * Video formats
> >> @@ -463,7 +464,16 @@ static int uvc_parse_format(struct uvc_device *dev,
> >>               strlcpy(format->name, "MJPEG", sizeof format->name);
> >>               format->fcc = V4L2_PIX_FMT_MJPEG;
> >>               format->flags = UVC_FMT_FLAG_COMPRESSED;
> >> -             format->bpp = 0;
> >> +             if ((uvc_mjpeg_bpp_param >= 1) && (uvc_mjpeg_bpp_param <=
> >> 16)) {
> >> +                     format->bpp = uvc_mjpeg_bpp_param;
> >> +             } else {
> >> +                     /* conservative estimate. Actual values are around
> >> 1bpp.
> >> +                      * see e.g.
> >> +                      *
> >> https://developers.google.com/speed/webp/docs/webp_study
> >> +                      */
> >> +                     format->bpp = 4;
> >> +             }
> >> +
> >> 
> >>               ftype = UVC_VS_FRAME_MJPEG;
> >>               break;
> >> 
> >> @@ -2274,6 +2284,8 @@ module_param_named(trace, uvc_trace_param, uint,
> >> S_IRUGO|S_IWUSR); MODULE_PARM_DESC(trace, "Trace level bitmask");
> >> 
> >>  module_param_named(timeout, uvc_timeout_param, uint, S_IRUGO|S_IWUSR);
> >>  MODULE_PARM_DESC(timeout, "Streaming control requests timeout");
> >> 
> >> +module_param_named(mjpeg_bpp, uvc_mjpeg_bpp_param, uint,
> >> S_IRUGO|S_IWUSR);
> >> +MODULE_PARM_DESC(mjpeg_bpp, "MJPEG bits per pixel for bandwidth quirk");
> > 
> > I'd rather avoid adding a new module parameter for this, it would be
> > confusing for users. What is your use case to make the MJPEG average BPP
> > configurable ? Can't we come up with a heuristic that would calculate it
> > automatically ?
> 
> this is the minimal expected JPEG compression ratio. It depends on the
> JPEG quality chosen by the hardware (which we do not know) as well as the
> actual image (which we can not control either).
> We could hardcode it to the average bpp which 1 - but this will break
> when somebody films a high-frequency checkerborad. We could leave it at 4,
> but this would again artificially limit the number of possible cameras when
> not filming a checkerboard.
> 4 would already be a noticable improvement over the current state though.
> 
> If you can come up with a working heuristic - I am open for that too.

So it's basically an estimate of the MJPEG compression ratio, which depends on 
multiple parameters, some of which we could possibly control (such as the 
compression quality), and some of which we have no influence on (such as the 
scene in front of the camera).

What really bothers me is that if even we can't estimate the value, exposing 
it as a module parameter will only confuse most users. How about starting with 
a fixed conservative estimate (such as 4bpp) and see where that leads us ?

I would also not try to fake a bpp value in uvc_parse_format() for MJPEG 
formats, but instead adapt uvc_fixup_video_ctrl() with MJPEG-specific 
calculation. This would allow expressing a compression ratio in the code 
instead of an artificial bpp value, allowing more precision in the future if 
needed.

> >>  /* ---------------------------------------------------------------------
> >>   * Driver initialization and cleanup
> >> diff --git a/drivers/media/usb/uvc/uvc_video.c
> >> b/drivers/media/usb/uvc/uvc_video.c index fb86d6a..382a0be 100644
> >> --- a/drivers/media/usb/uvc/uvc_video.c
> >> +++ b/drivers/media/usb/uvc/uvc_video.c
> >> @@ -127,7 +127,8 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming
> >> *stream,
> >>  		if ((ctrl->dwMaxPayloadTransferSize & 0xffff0000) == 0xffff0000)
> >>  			ctrl->dwMaxPayloadTransferSize &= ~0xffff0000;
> >> 
> >> -     if (!(format->flags & UVC_FMT_FLAG_COMPRESSED) &&
> >> +     if ((!(format->flags & UVC_FMT_FLAG_COMPRESSED) ||
> >> +                     (format->fcc == V4L2_PIX_FMT_MJPEG)) &&
> >>           stream->dev->quirks & UVC_QUIRK_FIX_BANDWIDTH &&
> >>           stream->intf->num_altsetting > 1) {
> >>               u32 interval;

-- 
Regards,

Laurent Pinchart

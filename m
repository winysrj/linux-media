Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:57190 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaJGQlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Oct 2014 12:41:37 -0400
Received: by mail-vc0-f177.google.com with SMTP id hq11so5013276vcb.8
        for <linux-media@vger.kernel.org>; Tue, 07 Oct 2014 09:41:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3718548.sH2BZ4J8RZ@avalon>
References: <CAP_ceTz8BRQoFxkgb085_gOh29x8anvQNodAGMkgOukk02x29g@mail.gmail.com>
 <1412629559-16624-1-git-send-email-vpalatin@chromium.org> <3718548.sH2BZ4J8RZ@avalon>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Tue, 7 Oct 2014 09:41:16 -0700
Message-ID: <CAP_ceTymjiPAcRQ1jBbnM20iLiwhqm20wM197VOfVLat-ZUbvA@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] V4L: uvcvideo: Add support for pan/tilt speed controls
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Pawel Osciak <posciak@chromium.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Olof Johansson <olofj@chromium.org>,
	Zach Kuznia <zork@chromium.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 7, 2014 at 9:36 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Vincent,
>
> Thank you for the patch. Mauro has already merged this in his tree, it should
> appear in v3.18-rc1.
>

Great ! I missed the merge.

Thanks,
-- 
Vincent

>
> On Monday 06 October 2014 14:05:59 Vincent Palatin wrote:
> > Map V4L2_CID_TILT_SPEED and V4L2_CID_PAN_SPEED to the standard UVC
> > CT_PANTILT_RELATIVE_CONTROL terminal control request.
> >
> > Tested by plugging a Logitech ConferenceCam C3000e USB camera
> > and controlling pan/tilt from the userspace using the VIDIOC_S_CTRL ioctl.
> > Verified that it can pan and tilt at the same time in both directions.
> >
> > Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> > Reviewed-by: Pawel Osciak <posciak@chromium.org>
> > ---
> > Changes from v1/v2:
> > - rebased
> > Changes from v3:
> > - removed gerrit-id
> > Chnages from v4:
> > - switched "offset" to unsigned int
> >
> >  drivers/media/usb/uvc/uvc_ctrl.c | 58 ++++++++++++++++++++++++++++++++++---
> >  1 file changed, 55 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> > b/drivers/media/usb/uvc/uvc_ctrl.c index 0eb82106..d2d1755 100644
> > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > @@ -309,9 +309,8 @@ static struct uvc_control_info uvc_ctrls[] = {
> >               .selector       = UVC_CT_PANTILT_RELATIVE_CONTROL,
> >               .index          = 12,
> >               .size           = 4,
> > -             .flags          = UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_MIN
> > -                             | UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_RES
> > -                             | UVC_CTRL_FLAG_GET_DEF
> > +             .flags          = UVC_CTRL_FLAG_SET_CUR
> > +                             | UVC_CTRL_FLAG_GET_RANGE
> >
> >                               | UVC_CTRL_FLAG_AUTO_UPDATE,
> >
> >       },
> >       {
> > @@ -391,6 +390,35 @@ static void uvc_ctrl_set_zoom(struct
> > uvc_control_mapping *mapping, data[2] = min((int)abs(value), 0xff);
> >  }
> >
> > +static __s32 uvc_ctrl_get_rel_speed(struct uvc_control_mapping *mapping,
> > +     __u8 query, const __u8 *data)
> > +{
> > +     unsigned int first = mapping->offset / 8;
> > +     __s8 rel = (__s8)data[first];
> > +
> > +     switch (query) {
> > +     case UVC_GET_CUR:
> > +             return (rel == 0) ? 0 : (rel > 0 ? data[first+1]
> > +                                              : -data[first+1]);
> > +     case UVC_GET_MIN:
> > +             return -data[first+1];
> > +     case UVC_GET_MAX:
> > +     case UVC_GET_RES:
> > +     case UVC_GET_DEF:
> > +     default:
> > +             return data[first+1];
> > +     }
> > +}
> > +
> > +static void uvc_ctrl_set_rel_speed(struct uvc_control_mapping *mapping,
> > +     __s32 value, __u8 *data)
> > +{
> > +     unsigned int first = mapping->offset / 8;
> > +
> > +     data[first] = value == 0 ? 0 : (value > 0) ? 1 : 0xff;
> > +     data[first+1] = min_t(int, abs(value), 0xff);
> > +}
> > +
> >  static struct uvc_control_mapping uvc_ctrl_mappings[] = {
> >       {
> >               .id             = V4L2_CID_BRIGHTNESS,
> > @@ -677,6 +705,30 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] =
> > { .data_type  = UVC_CTRL_DATA_TYPE_SIGNED,
> >       },
> >       {
> > +             .id             = V4L2_CID_PAN_SPEED,
> > +             .name           = "Pan (Speed)",
> > +             .entity         = UVC_GUID_UVC_CAMERA,
> > +             .selector       = UVC_CT_PANTILT_RELATIVE_CONTROL,
> > +             .size           = 16,
> > +             .offset         = 0,
> > +             .v4l2_type      = V4L2_CTRL_TYPE_INTEGER,
> > +             .data_type      = UVC_CTRL_DATA_TYPE_SIGNED,
> > +             .get            = uvc_ctrl_get_rel_speed,
> > +             .set            = uvc_ctrl_set_rel_speed,
> > +     },
> > +     {
> > +             .id             = V4L2_CID_TILT_SPEED,
> > +             .name           = "Tilt (Speed)",
> > +             .entity         = UVC_GUID_UVC_CAMERA,
> > +             .selector       = UVC_CT_PANTILT_RELATIVE_CONTROL,
> > +             .size           = 16,
> > +             .offset         = 16,
> > +             .v4l2_type      = V4L2_CTRL_TYPE_INTEGER,
> > +             .data_type      = UVC_CTRL_DATA_TYPE_SIGNED,
> > +             .get            = uvc_ctrl_get_rel_speed,
> > +             .set            = uvc_ctrl_set_rel_speed,
> > +     },
> > +     {
> >               .id             = V4L2_CID_PRIVACY,
> >               .name           = "Privacy",
> >               .entity         = UVC_GUID_UVC_CAMERA,
>
> --
> Regards,
>
> Laurent Pinchart
>

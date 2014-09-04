Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:36378 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbaIDAiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 20:38:25 -0400
Received: by mail-vc0-f175.google.com with SMTP id lf12so9656466vcb.6
        for <linux-media@vger.kernel.org>; Wed, 03 Sep 2014 17:38:24 -0700 (PDT)
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com [209.85.220.181])
        by mx.google.com with ESMTPSA id 14sm5433405vdh.22.2014.09.03.17.38.22
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 03 Sep 2014 17:38:22 -0700 (PDT)
Received: by mail-vc0-f181.google.com with SMTP id ij19so9659883vcb.26
        for <linux-media@vger.kernel.org>; Wed, 03 Sep 2014 17:38:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409773238-32177-1-git-send-email-vpalatin@chromium.org>
References: <CACHYQ-qST1gyyKCZp+tN9FbR3_=2q_+=PbVwfu3KgfTpkdDFCA@mail.gmail.com>
 <1409773238-32177-1-git-send-email-vpalatin@chromium.org>
From: Pawel Osciak <posciak@chromium.org>
Date: Thu, 4 Sep 2014 09:37:42 +0900
Message-ID: <CACHYQ-r-+czyEBySdjNWr-3XmY1C2ErDJV0dnL=GDJOYPi1asw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] V4L: uvcvideo: Add support for pan/tilt speed controls
To: Vincent Palatin <vpalatin@chromium.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Olof Johansson <olofj@chromium.org>,
	Zach Kuznia <zork@chromium.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 4, 2014 at 4:40 AM, Vincent Palatin <vpalatin@chromium.org> wrote:
> Map V4L2_CID_TILT_SPEED and V4L2_CID_PAN_SPEED to the standard UVC
> CT_PANTILT_RELATIVE_CONTROL terminal control request.
>
> Tested by plugging a Logitech ConferenceCam C3000e USB camera
> and controlling pan/tilt from the userspace using the VIDIOC_S_CTRL ioctl.
> Verified that it can pan and tilt at the same time in both directions.
>
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
>
> Change-Id: I7b70b228e5c0126683f5f0be34ffd2807f5783dc

Sorry, forgot to mention this previously, please remove gerrit ids
from the patches.
Thanks,
P.

> ---
> Changes from v1/v2:
> - rebased
>
>  drivers/media/usb/uvc/uvc_ctrl.c | 58 +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 55 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index 0eb82106..d703cb0 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -309,9 +309,8 @@ static struct uvc_control_info uvc_ctrls[] = {
>                 .selector       = UVC_CT_PANTILT_RELATIVE_CONTROL,
>                 .index          = 12,
>                 .size           = 4,
> -               .flags          = UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_MIN
> -                               | UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_RES
> -                               | UVC_CTRL_FLAG_GET_DEF
> +               .flags          = UVC_CTRL_FLAG_SET_CUR
> +                               | UVC_CTRL_FLAG_GET_RANGE
>                                 | UVC_CTRL_FLAG_AUTO_UPDATE,
>         },
>         {
> @@ -391,6 +390,35 @@ static void uvc_ctrl_set_zoom(struct uvc_control_mapping *mapping,
>         data[2] = min((int)abs(value), 0xff);
>  }
>
> +static __s32 uvc_ctrl_get_rel_speed(struct uvc_control_mapping *mapping,
> +       __u8 query, const __u8 *data)
> +{
> +       int first = mapping->offset / 8;
> +       __s8 rel = (__s8)data[first];
> +
> +       switch (query) {
> +       case UVC_GET_CUR:
> +               return (rel == 0) ? 0 : (rel > 0 ? data[first+1]
> +                                                : -data[first+1]);
> +       case UVC_GET_MIN:
> +               return -data[first+1];
> +       case UVC_GET_MAX:
> +       case UVC_GET_RES:
> +       case UVC_GET_DEF:
> +       default:
> +               return data[first+1];
> +       }
> +}
> +
> +static void uvc_ctrl_set_rel_speed(struct uvc_control_mapping *mapping,
> +       __s32 value, __u8 *data)
> +{
> +       int first = mapping->offset / 8;
> +
> +       data[first] = value == 0 ? 0 : (value > 0) ? 1 : 0xff;
> +       data[first+1] = min_t(int, abs(value), 0xff);
> +}
> +
>  static struct uvc_control_mapping uvc_ctrl_mappings[] = {
>         {
>                 .id             = V4L2_CID_BRIGHTNESS,
> @@ -677,6 +705,30 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
>                 .data_type      = UVC_CTRL_DATA_TYPE_SIGNED,
>         },
>         {
> +               .id             = V4L2_CID_PAN_SPEED,
> +               .name           = "Pan (Speed)",
> +               .entity         = UVC_GUID_UVC_CAMERA,
> +               .selector       = UVC_CT_PANTILT_RELATIVE_CONTROL,
> +               .size           = 16,
> +               .offset         = 0,
> +               .v4l2_type      = V4L2_CTRL_TYPE_INTEGER,
> +               .data_type      = UVC_CTRL_DATA_TYPE_SIGNED,
> +               .get            = uvc_ctrl_get_rel_speed,
> +               .set            = uvc_ctrl_set_rel_speed,
> +       },
> +       {
> +               .id             = V4L2_CID_TILT_SPEED,
> +               .name           = "Tilt (Speed)",
> +               .entity         = UVC_GUID_UVC_CAMERA,
> +               .selector       = UVC_CT_PANTILT_RELATIVE_CONTROL,
> +               .size           = 16,
> +               .offset         = 16,
> +               .v4l2_type      = V4L2_CTRL_TYPE_INTEGER,
> +               .data_type      = UVC_CTRL_DATA_TYPE_SIGNED,
> +               .get            = uvc_ctrl_get_rel_speed,
> +               .set            = uvc_ctrl_set_rel_speed,
> +       },
> +       {
>                 .id             = V4L2_CID_PRIVACY,
>                 .name           = "Privacy",
>                 .entity         = UVC_GUID_UVC_CAMERA,
> --
> 2.1.0.rc2.206.gedb03e5
>

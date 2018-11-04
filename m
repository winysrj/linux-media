Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:46558 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730332AbeKEBbG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2018 20:31:06 -0500
Received: by mail-io1-f67.google.com with SMTP id y22-v6so4726430ioj.13
        for <linux-media@vger.kernel.org>; Sun, 04 Nov 2018 08:15:37 -0800 (PST)
MIME-Version: 1.0
References: <1536734527-3770-1-git-send-email-sergey.dorodnicov@intel.com>
 <1536734527-3770-3-git-send-email-sergey.dorodnicov@intel.com> <1887189.gMKOtKLMbF@avalon>
In-Reply-To: <1887189.gMKOtKLMbF@avalon>
From: Sergey Dorodnic <dorodnic@gmail.com>
Date: Sun, 4 Nov 2018 08:10:24 -0800
Message-ID: <CAPZdoaP1SeE0=HA9w-R9SpU5BJWWmJ_BNM7guhrT8X1jEy0ZNA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] [media] CNF4 pixel format for media subsystem
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org,
        Evgeni Raikhel <evgeni.raikhel@intel.com>,
        "Dorodnicov, Sergey" <sergey.dorodnicov@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

Thank you for the review and the comments.
Please modify the subject / description as you see fit.
I will make sure to use the right prefix in future submissions.

Best regards,
Sergey
On Thu, Nov 1, 2018 at 9:10 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Sergey,
>
> Thank you for the patch.
>
> As for patch 1/2, the subject line needs a prefix. Furthermore it doesn't
> really describe the patch. I propose writing it as
>
> media: uvcvideo: Add support for the CNF4 format
>
> On Wednesday, 12 September 2018 09:42:07 EET dorodnic@gmail.com wrote:
> > From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> >
> > Registering new GUID used by Intel RealSense cameras with fourcc CNF4,
> > encoding depth sensor confidence information for every pixel.
>
> And there I would write "Register the GUID ...".
>
> Apart from that the patch looks good to me,
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> If you're fine with the subject line change there's no need to resubmit, I'll
> fix it when applying the patch to my tree.
>
> > Signed-off-by: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> > Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
> > ---
> >  drivers/media/usb/uvc/uvc_driver.c | 5 +++++
> >  drivers/media/usb/uvc/uvcvideo.h   | 3 +++
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index d46dc43..19f129f 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -214,6 +214,11 @@ static struct uvc_format_desc uvc_fmts[] = {
> >               .guid           = UVC_GUID_FORMAT_INZI,
> >               .fcc            = V4L2_PIX_FMT_INZI,
> >       },
> > +     {
> > +             .name           = "4-bit Depth Confidence (Packed)",
> > +             .guid           = UVC_GUID_FORMAT_CNF4,
> > +             .fcc            = V4L2_PIX_FMT_CNF4,
> > +     },
> >  };
> >
> >  /* ------------------------------------------------------------------------
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h
> > b/drivers/media/usb/uvc/uvcvideo.h index e5f5d84..779bab2 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -154,6 +154,9 @@
> >  #define UVC_GUID_FORMAT_INVI \
> >       { 'I',  'N',  'V',  'I', 0xdb, 0x57, 0x49, 0x5e, \
> >        0x8e, 0x3f, 0xf4, 0x79, 0x53, 0x2b, 0x94, 0x6f}
> > +#define UVC_GUID_FORMAT_CNF4 \
> > +     { 'C',  ' ',  ' ',  ' ', 0x00, 0x00, 0x10, 0x00, \
> > +      0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> >
> >  #define UVC_GUID_FORMAT_D3DFMT_L8 \
> >       {0x32, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, \
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>

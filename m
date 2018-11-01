Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:38812 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbeKAXvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 19:51:00 -0400
Received: by mail-it1-f195.google.com with SMTP id j9so2344469itl.3
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2018 07:47:42 -0700 (PDT)
MIME-Version: 1.0
References: <1536734527-3770-1-git-send-email-sergey.dorodnicov@intel.com>
 <f752d94f-d1fc-5276-aa58-ef7cdff6b21b@xs4all.nl> <AA09C8071EEEFC44A7852ADCECA86673726CDB16@hasmsx107.ger.corp.intel.com>
 <348ff3bc-7fce-57ab-05a2-3d7bfd232e6e@xs4all.nl>
In-Reply-To: <348ff3bc-7fce-57ab-05a2-3d7bfd232e6e@xs4all.nl>
From: Sergey Dorodnic <dorodnic@gmail.com>
Date: Thu, 1 Nov 2018 07:42:32 -0700
Message-ID: <CAPZdoaM2-aMzcTbauzhFQUYWhRrcohpQBVcktimBS7jKZxniHQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] [media] Depth confidence pixel-format for Intel
 RealSense cameras
To: hverkuil@xs4all.nl
Cc: Evgeni Raikhel <evgeni.raikhel@intel.com>,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        "Dorodnicov, Sergey" <sergey.dorodnicov@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans, Laurent

Could you please comment on this topic?
If the patches require any additional work, we will be eager to address it.
For now we are publishing a custom DKMS, but it would be great to see
better 3D-camera hardware support in the near future.

Regards,
Sergey
(sorry, re-sending in plain-text mode)

On Wed, Oct 3, 2018 at 5:27 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 10/03/18 14:08, Raikhel, Evgeni wrote:
> > Hans hello,
> >
> > Can you update this patch series status ?
> > Thanks in advance,
> >
> > With regards,
> > Evgeni
> >
> > -----Original Message-----
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > Sent: Wednesday, September 12, 2018 09:40
> > To: dorodnic@gmail.com; linux-media@vger.kernel.org
> > Cc: laurent.pinchart@ideasonboard.com; Raikhel, Evgeni <evgeni.raikhel@intel.com>; Dorodnicov, Sergey <sergey.dorodnicov@intel.com>
> > Subject: Re: [PATCH v2 0/2] [media] Depth confidence pixel-format for Intel RealSense cameras
> >
> > On 09/12/2018 08:42 AM, dorodnic@gmail.com wrote:
> >> From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> >>
> >> Define new fourcc describing depth sensor confidence data used in Intel RealSense cameras.
> >> Confidence information is stored as packed 4 bits per pixel single-plane image.
> >> The patches were tested on 4.18-rc2 and merged with media_tree/master.
> >> Addressing code-review comments by Hans Verkuil <hverkuil@xs4all.nl>
> >> and Laurent Pinchart <laurent.pinchart@ideasonboard.com>.
> >>
> >> Sergey Dorodnicov (2):
> >>   CNF4 fourcc for 4 bit-per-pixel packed depth confidence information
> >>   CNF4 pixel format for media subsystem
> >>
> >>  Documentation/media/uapi/v4l/depth-formats.rst |  1 +
> >>  Documentation/media/uapi/v4l/pixfmt-cnf4.rst   | 31 ++++++++++++++++++++++++++
> >>  drivers/media/usb/uvc/uvc_driver.c             |  5 +++++
> >>  drivers/media/usb/uvc/uvcvideo.h               |  3 +++
> >>  drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
> >>  include/uapi/linux/videodev2.h                 |  1 +
> >>  6 files changed, 42 insertions(+)
> >>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-cnf4.rst
> >>
> >
> > Laurent, this looks good to me. Do you want to take this series or shall I?
> >
> > If you take it, then you can add my:
> >
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > to these patches. If you want me to take it, then I'll need your Ack of course.
>
> Still waiting for a reply from Laurent. But thanks for reminding us,
> I've pinged Laurent and he will hopefully come back with an Ack or review
> by the end of the week.
>
> Regards,
>
>         Hans
>
> >
> > Regards,
> >
> >       Hans
> > ---------------------------------------------------------------------
> > Intel Israel (74) Limited
> >
> > This e-mail and any attachments may contain confidential material for
> > the sole use of the intended recipient(s). Any review or distribution
> > by others is strictly prohibited. If you are not the intended
> > recipient, please contact the sender and delete all copies.
> >
>

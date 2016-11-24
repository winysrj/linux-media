Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59712 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbcKXDrc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 22:47:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Matt Ranostay <matt@ranostay.consulting>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Attila Kinali <attila@kinali.ch>, Marek Vasut <marex@denx.de>,
        Luca Barbato <lu_zero@gentoo.org>
Subject: Re: [PATCH v3] media: i2c-polling: add i2c-polling driver
Date: Thu, 24 Nov 2016 05:47:01 +0200
Message-ID: <5424666.GP8tthhb7m@avalon>
In-Reply-To: <CAJ_EiSRhiLMpF=6exnnO8fbjRR6MT2t4MBB6vMa-dpr21U0Y5A@mail.gmail.com>
References: <1479863920-14708-1-git-send-email-matt@ranostay.consulting> <2379913.pFkGVXK2x8@avalon> <CAJ_EiSRhiLMpF=6exnnO8fbjRR6MT2t4MBB6vMa-dpr21U0Y5A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matt,

On Wednesday 23 Nov 2016 18:37:29 Matt Ranostay wrote:
> On Wed, Nov 23, 2016 at 8:30 AM, Laurent Pinchart wrote:
> > On Tuesday 22 Nov 2016 17:18:40 Matt Ranostay wrote:
> >> There are several thermal sensors that only have a low-speed bus
> >> interface but output valid video data. This patchset enables support
> >> for the AMG88xx "Grid-Eye" sensor family.
> >> 
> >> Cc: Attila Kinali <attila@kinali.ch>
> >> Cc: Marek Vasut <marex@denx.de>
> >> Cc: Luca Barbato <lu_zero@gentoo.org>
> >> Signed-off-by: Matt Ranostay <matt@ranostay.consulting>
> >> ---
> >> Changes from v1:
> >> * correct i2c_polling_remove() operations
> >> * fixed delay calcuation in buffer_queue()
> >> * add include linux/slab.h
> >> 
> >> Changes from v2:
> >> * fix build error due to typo in include of slab.h
> >> 
> >>  drivers/media/i2c/Kconfig       |   8 +
> >>  drivers/media/i2c/Makefile      |   1 +
> >>  drivers/media/i2c/i2c-polling.c | 469 ++++++++++++++++++++++++++++++++++
> > 
> > Just looking at the driver name I believe a rename is needed. i2c-polling
> > is a very generic name and would mislead many people into thinking about
> > an I2C subsystem core feature instead of a video driver. "video-i2c" is
> > one option, I'm open to other ideas.
> > 
> >>  3 files changed, 478 insertions(+)
> >>  create mode 100644 drivers/media/i2c/i2c-polling.c

[snip]

> >> diff --git a/drivers/media/i2c/i2c-polling.c
> >> b/drivers/media/i2c/i2c-polling.c new file mode 100644
> >> index 000000000000..46a4eecde2d2
> >> --- /dev/null
> >> +++ b/drivers/media/i2c/i2c-polling.c

[snip]

> >> +static const struct v4l2_ioctl_ops i2c_polling_ioctl_ops = {
> >> +     .vidioc_querycap                = i2c_polling_querycap,
> >> +     .vidioc_g_input                 = i2c_polling_g_input,
> >> +     .vidioc_s_input                 = i2c_polling_s_input,
> >> +     .vidioc_enum_input              = i2c_polling_enum_input,
> >> +     .vidioc_enum_fmt_vid_cap        = i2c_polling_enum_fmt_vid_cap,
> >> +     .vidioc_enum_framesizes         = i2c_polling_enum_framesizes,
> >> +     .vidioc_enum_frameintervals     = i2c_polling_enum_frameintervals,
> >> +     .vidioc_g_fmt_vid_cap           = i2c_polling_fmt_vid_cap,
> >> +     .vidioc_s_fmt_vid_cap           = i2c_polling_fmt_vid_cap,
> >> +     .vidioc_g_parm                  = i2c_polling_g_parm,
> >> +     .vidioc_s_parm                  = i2c_polling_s_parm,
> >> +     .vidioc_try_fmt_vid_cap         = i2c_polling_try_fmt_vid_cap,
> >> +     .vidioc_reqbufs                 = vb2_ioctl_reqbufs,
> >> +     .vidioc_create_bufs             = vb2_ioctl_create_bufs,
> >> +     .vidioc_prepare_buf             = vb2_ioctl_prepare_buf,
> >> +     .vidioc_querybuf                = vb2_ioctl_querybuf,
> >> +     .vidioc_qbuf                    = vb2_ioctl_qbuf,
> >> +     .vidioc_dqbuf                   = vb2_ioctl_dqbuf,
> >> +     .vidioc_streamon                = vb2_ioctl_streamon,
> >> +     .vidioc_streamoff               = vb2_ioctl_streamoff,
> > 
> > No need to set the buffer-related .vidioc_* pointers to vb2_ioctl_*
> > explicitly, the core will use vb2 if the fields are left unset.
> 
> Not so sure about that from getting these ioctl errors with those removed:
> 
> avconv -f video4linux2 -s 8x8 -r 10 -i /dev/video0 test%3d.png
> avconv version 8cd084d, Copyright (c) 2000-2016 the Libav developers
>   built on Nov  8 2016 02:26:17 with gcc 4.7.3 (Linaro GCC
> 4.7-2013.02-01) 20130205 (prerelease)
> [video4linux2 @ 0x10390c0] ioctl(VIDIOC_QUERYBUF)
> /dev/video0: Inappropriate ioctl for device

My comment was wrong, I've mistaken it with the control-related ioctls. I'm 
very sorry about that.

> >> +     .vidioc_log_status              = v4l2_ctrl_log_status,
> >> +     .vidioc_subscribe_event         = v4l2_ctrl_subscribe_event,
> >> +     .vidioc_unsubscribe_event       = v4l2_event_unsubscribe,
> >> +};

-- 
Regards,

Laurent Pinchart


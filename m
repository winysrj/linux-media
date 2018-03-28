Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39204 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbeC1XWS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 19:22:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset="utf-8"
Message-id: <5ABC23A0.20907@samsung.com>
Date: Thu, 29 Mar 2018 08:22:08 +0900
From: Inki Dae <inki.dae@samsung.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Brian Warner <brian.warner@samsung.com>
Subject: Re: [PATCH for v3.18 00/18] Backport CVE-2017-13166 fixes to Kernel
 3.18
In-reply-to: <cover.1522260310.git.mchehab@s-opensource.com>
References: <CGME20180328181304epcas4p2593efec8fcccbf6bf30ed30d9b5f0093@epcas4p2.samsung.com>
        <cover.1522260310.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

2018년 03월 29일 03:12에 Mauro Carvalho Chehab 이(가) 쓴 글:
> Hi Greg,
> 
> Those are the backports meant to solve CVE-2017-13166 on Kernel 3.18.
> 
> It contains two v4l2-ctrls fixes that are required to avoid crashes
> at the test application.
> 
> I wrote two patches myself for Kernel 3.18 in order to solve some
> issues specific for Kernel 3.18 with aren't needed upstream.
> one is actually a one-line change backport. The other one makes
> sure that both 32-bits and 64-bits version of some ioctl calls
> will return the same value for a reserved field.
> 
> I noticed an extra bug while testing it, but the bug also hits upstream,
> and should be backported all the way down all stable/LTS versions.
> So, I'll send it the usual way, after merging upsream.

Really thanks for doing this. :) There would be many users who use Linux-3.18 for their products yet.

Thanks,
Inki Dae

> 
> Regards,
> Mauro
> 
> 
> Daniel Mentz (2):
>   media: v4l2-compat-ioctl32: Copy v4l2_window->global_alpha
>   media: v4l2-compat-ioctl32.c: refactor compat ioctl32 logic
> 
> Hans Verkuil (12):
>   media: v4l2-ioctl.c: don't copy back the result for -ENOTTY
>   media: v4l2-compat-ioctl32.c: add missing VIDIOC_PREPARE_BUF
>   media: v4l2-compat-ioctl32.c: fix the indentation
>   media: v4l2-compat-ioctl32.c: move 'helper' functions to
>     __get/put_v4l2_format32
>   media: v4l2-compat-ioctl32.c: avoid sizeof(type)
>   media: v4l2-compat-ioctl32.c: copy m.userptr in put_v4l2_plane32
>   media: v4l2-compat-ioctl32.c: fix ctrl_is_pointer
>   media: v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs
>   media: v4l2-compat-ioctl32.c: copy clip list in put_v4l2_window32
>   media: v4l2-compat-ioctl32.c: drop pr_info for unknown buffer type
>   media: v4l2-compat-ioctl32.c: don't copy back the result for certain
>     errors
>   media: v4l2-ctrls: fix sparse warning
> 
> Mauro Carvalho Chehab (2):
>   media: v4l2-compat-ioctl32: use compat_u64 for video standard
>   media: v4l2-compat-ioctl32: initialize a reserved field
> 
> Ricardo Ribalda (2):
>   vb2: V4L2_BUF_FLAG_DONE is set after DQBUF
>   media: media/v4l2-ctrls: volatiles should not generate CH_VALUE
> 
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 1020 +++++++++++++++----------
>  drivers/media/v4l2-core/v4l2-ctrls.c          |   96 ++-
>  drivers/media/v4l2-core/v4l2-ioctl.c          |    5 +-
>  drivers/media/v4l2-core/videobuf2-core.c      |    5 +
>  4 files changed, 691 insertions(+), 435 deletions(-)
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f170.google.com ([209.85.219.170]:32848 "EHLO
        mail-yb1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729665AbeKVVLK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 16:11:10 -0500
Received: by mail-yb1-f170.google.com with SMTP id i78-v6so3408340ybg.0
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 02:32:20 -0800 (PST)
Received: from mail-yw1-f42.google.com (mail-yw1-f42.google.com. [209.85.161.42])
        by smtp.gmail.com with ESMTPSA id 203-v6sm12524191ywg.29.2018.11.22.02.32.18
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Nov 2018 02:32:18 -0800 (PST)
Received: by mail-yw1-f42.google.com with SMTP id d190so3434695ywd.12
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 02:32:18 -0800 (PST)
MIME-Version: 1.0
References: <d7afaa30-6d5b-2d4f-4a84-04ad813a3280@xs4all.nl> <6fca8409-3c12-41fb-d5b9-95aa74fa6420@xs4all.nl>
In-Reply-To: <6fca8409-3c12-41fb-d5b9-95aa74fa6420@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 22 Nov 2018 19:32:06 +0900
Message-ID: <CAAFQd5DGW1YAZ9bV8rOV+o_i3KNaCHrfHRDjos_Uu1dQtuxivA@mail.gmail.com>
Subject: Re: [GIT PULL FOR v4.21] Add Rockchip VPU JPEG encoder
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 22, 2018 at 7:29 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Ezeguiel,
>
> Just saw Tomasz' in-depth review and decided to drop this pull request.
>
> He found a few too many issues and I prefer those are addressed first.
>
> Sorry, still more work for you, on to v11!

I'm really sorry for the late review. Hopefully I can do better from
now on. (Still have quite a big pile of backlog, though...)

Best regards,
Tomasz

>
> Regards,
>
>         Hans
>
> On 11/22/2018 10:39 AM, Hans Verkuil wrote:
> > The following changes since commit 5200ab6a32d6055428896a49ec9e3b1652c1a100:
> >
> >   media: vidioc_cropcap -> vidioc_g_pixelaspect (2018-11-20 13:57:21 -0500)
> >
> > are available in the Git repository at:
> >
> >   git://linuxtv.org/hverkuil/media_tree.git tags/br-jpeg
> >
> > for you to fetch changes up to cbf7592cb57ec9986c4d1becfd80b85486fd318a:
> >
> >   media: add Rockchip VPU JPEG encoder driver (2018-11-22 10:12:29 +0100)
> >
> > ----------------------------------------------------------------
> > Tag branch
> >
> > ----------------------------------------------------------------
> > Ezequiel Garcia (1):
> >       media: add Rockchip VPU JPEG encoder driver
> >
> >  MAINTAINERS                                                 |   7 +
> >  drivers/staging/media/Kconfig                               |   2 +
> >  drivers/staging/media/Makefile                              |   1 +
> >  drivers/staging/media/rockchip/vpu/Kconfig                  |  13 +
> >  drivers/staging/media/rockchip/vpu/Makefile                 |  10 +
> >  drivers/staging/media/rockchip/vpu/TODO                     |   6 +
> >  drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c          | 118 ++++++++
> >  drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c | 133 ++++++++
> >  drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h        | 442 +++++++++++++++++++++++++++
> >  drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c          | 118 ++++++++
> >  drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c | 160 ++++++++++
> >  drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h        | 600 ++++++++++++++++++++++++++++++++++++
> >  drivers/staging/media/rockchip/vpu/rockchip_vpu.h           | 237 +++++++++++++++
> >  drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h    |  29 ++
> >  drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c       | 535 +++++++++++++++++++++++++++++++++
> >  drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c       | 702 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h        |  58 ++++
> >  drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c      | 290 ++++++++++++++++++
> >  drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h      |  14 +
> >  19 files changed, 3475 insertions(+)
> >  create mode 100644 drivers/staging/media/rockchip/vpu/Kconfig
> >  create mode 100644 drivers/staging/media/rockchip/vpu/Makefile
> >  create mode 100644 drivers/staging/media/rockchip/vpu/TODO
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu.h
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
> >
>

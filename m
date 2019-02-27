Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F694C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 14:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D584E2133D
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 14:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="guo1Bhk1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbfB0ON7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 09:13:59 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:37939 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfB0ON7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 09:13:59 -0500
Received: by mail-it1-f196.google.com with SMTP id l66so10036857itg.3
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2019 06:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m3PJNiDhK5CQ3cZNm7dbtVwWTqwCG6d4RZhzFvPJiWw=;
        b=guo1Bhk1VN+vpi//Fg2CUojS5GDKbLWUc790Wiw+5lhrqsYxmCqAeSpDrcuwsj/Qek
         c+RDG1c1dvWT/U1vwTcOztkhy+qTRpLm/e9InLPtxtprvOMuJ+cU5wN2twW3jApZIHEG
         8hjeKQNLzs+CXox2ZZMUwLZJ3F0KC4QyHTShw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m3PJNiDhK5CQ3cZNm7dbtVwWTqwCG6d4RZhzFvPJiWw=;
        b=rVcQwXHJhvjQ6DA/DmEH8cmghDT01F7j76CZzkMOeuckzo6JmeqM8OX5aMrVLH7gKi
         djng/agcVf/KgxIMzzz6ZUivx8hO9cnVNknZpirC1Er4w0HvmhERAnpk9eJGdh114zxJ
         agPAoM5skM1Wca7Z+eCn8maMq7pOvnotiYHfEgc2Dj2p2+Y7Z4XMY9VQpy/6kG28F2K9
         iMe8x/gonAa9G4x4+8xVMSVkp0zovirDpImR3VlYxYxKmFGCHSeZ+a0CJbBNC1srrQqw
         dGpn4wygxCDlInNbwjg/MS0aPN76hU4gar5bXv/rpiWBwfMsrWATqJK44qia9Z+3XKVx
         DbaQ==
X-Gm-Message-State: AHQUAubVNSJXF0fUymMBJQuy6wjngxiXwxFnHT4LSsk5ne4kpm3zBSti
        YLHKqAbUtFX6qJ/VLimNKag/Gd8hGr6Y1yxwUgxUg6J+48s=
X-Google-Smtp-Source: APXvYqxwvDQQHMpLkNw20WJwmaWF4a1d1wD0rmm3gzUqfEHvIoA0i2uL1yZxHDPX+c83uRAUWCcjF1abxhSMFobYJVY=
X-Received: by 2002:a24:59cf:: with SMTP id p198mr1457177itb.51.1551276837406;
 Wed, 27 Feb 2019 06:13:57 -0800 (PST)
MIME-Version: 1.0
References: <1550953697-7288-1-git-send-email-hyun.kwon@xilinx.com>
 <1550953697-7288-2-git-send-email-hyun.kwon@xilinx.com> <20190226115311.GA4094@kroah.com>
 <CAKMK7uE=dSyo5vdjtQf=k1rdoegiBgSozCOotXLSW2VAkz2Ldw@mail.gmail.com> <20190226221817.GB10631@smtp.xilinx.com>
In-Reply-To: <20190226221817.GB10631@smtp.xilinx.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Wed, 27 Feb 2019 15:13:45 +0100
Message-ID: <CAKMK7uFay0mjHFhQqmQ7fneS2B0xNW_Nv4AWqp-FK1NnHVe5uw@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] uio: Add dma-buf import ioctls
To:     Hyun Kwon <hyun.kwon@xilinx.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hyun Kwon <hyunk@xilinx.com>,
        Stefano Stabellini <stefanos@xilinx.com>,
        Sonal Santan <sonals@xilinx.com>,
        Cyril Chemparathy <cyrilc@xilinx.com>,
        Jiaying Liang <jliang@xilinx.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>,
        Michal Simek <michals@xilinx.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 26, 2019 at 11:20 PM Hyun Kwon <hyun.kwon@xilinx.com> wrote:
>
> Hi Daniel,
>
> Thanks for the comment.
>
> On Tue, 2019-02-26 at 04:06:13 -0800, Daniel Vetter wrote:
> > On Tue, Feb 26, 2019 at 12:53 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sat, Feb 23, 2019 at 12:28:17PM -0800, Hyun Kwon wrote:
> > > > Add the dmabuf map / unmap interfaces. This allows the user driver
> > > > to be able to import the external dmabuf and use it from user space.
> > > >
> > > > Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> > > > ---
> > > >  drivers/uio/Makefile         |   2 +-
> > > >  drivers/uio/uio.c            |  43 +++++++++
> > > >  drivers/uio/uio_dmabuf.c     | 210 +++++++++++++++++++++++++++++++++++++++++++
> > > >  drivers/uio/uio_dmabuf.h     |  26 ++++++
> > > >  include/uapi/linux/uio/uio.h |  33 +++++++
> > > >  5 files changed, 313 insertions(+), 1 deletion(-)
> > > >  create mode 100644 drivers/uio/uio_dmabuf.c
> > > >  create mode 100644 drivers/uio/uio_dmabuf.h
> > > >  create mode 100644 include/uapi/linux/uio/uio.h
> > > >
> > > > diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> > > > index c285dd2..5da16c7 100644
> > > > --- a/drivers/uio/Makefile
> > > > +++ b/drivers/uio/Makefile
> > > > @@ -1,5 +1,5 @@
> > > >  # SPDX-License-Identifier: GPL-2.0
> > > > -obj-$(CONFIG_UIO)    += uio.o
> > > > +obj-$(CONFIG_UIO)    += uio.o uio_dmabuf.o
> > > >  obj-$(CONFIG_UIO_CIF)        += uio_cif.o
> > > >  obj-$(CONFIG_UIO_PDRV_GENIRQ)        += uio_pdrv_genirq.o
> > > >  obj-$(CONFIG_UIO_DMEM_GENIRQ)        += uio_dmem_genirq.o
> > > > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> > > > index 1313422..6841f98 100644
> > > > --- a/drivers/uio/uio.c
> > > > +++ b/drivers/uio/uio.c
> > > > @@ -24,6 +24,12 @@
> > > >  #include <linux/kobject.h>
> > > >  #include <linux/cdev.h>
> > > >  #include <linux/uio_driver.h>
> > > > +#include <linux/list.h>
> > > > +#include <linux/mutex.h>
> > > > +
> > > > +#include <uapi/linux/uio/uio.h>
> > > > +
> > > > +#include "uio_dmabuf.h"
> > > >
> > > >  #define UIO_MAX_DEVICES              (1U << MINORBITS)
> > > >
> > > > @@ -454,6 +460,8 @@ static irqreturn_t uio_interrupt(int irq, void *dev_id)
> > > >  struct uio_listener {
> > > >       struct uio_device *dev;
> > > >       s32 event_count;
> > > > +     struct list_head dbufs;
> > > > +     struct mutex dbufs_lock; /* protect @dbufs */
> > > >  };
> > > >
> > > >  static int uio_open(struct inode *inode, struct file *filep)
> > > > @@ -500,6 +508,9 @@ static int uio_open(struct inode *inode, struct file *filep)
> > > >       if (ret)
> > > >               goto err_infoopen;
> > > >
> > > > +     INIT_LIST_HEAD(&listener->dbufs);
> > > > +     mutex_init(&listener->dbufs_lock);
> > > > +
> > > >       return 0;
> > > >
> > > >  err_infoopen:
> > > > @@ -529,6 +540,10 @@ static int uio_release(struct inode *inode, struct file *filep)
> > > >       struct uio_listener *listener = filep->private_data;
> > > >       struct uio_device *idev = listener->dev;
> > > >
> > > > +     ret = uio_dmabuf_cleanup(idev, &listener->dbufs, &listener->dbufs_lock);
> > > > +     if (ret)
> > > > +             dev_err(&idev->dev, "failed to clean up the dma bufs\n");
> > > > +
> > > >       mutex_lock(&idev->info_lock);
> > > >       if (idev->info && idev->info->release)
> > > >               ret = idev->info->release(idev->info, inode);
> > > > @@ -652,6 +667,33 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
> > > >       return retval ? retval : sizeof(s32);
> > > >  }
> > > >
> > > > +static long uio_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> > >
> > > We have resisted adding a uio ioctl for a long time, can't you do this
> > > through sysfs somehow?
> > >
> > > A meta-comment about your ioctl structure:
> > >
> > > > +#define UIO_DMABUF_DIR_BIDIR 1
> > > > +#define UIO_DMABUF_DIR_TO_DEV        2
> > > > +#define UIO_DMABUF_DIR_FROM_DEV      3
> > > > +#define UIO_DMABUF_DIR_NONE  4
> > >
> > > enumerated type?
> > >
> > > > +
> > > > +struct uio_dmabuf_args {
> > > > +     __s32   dbuf_fd;
> > > > +     __u64   dma_addr;
> > > > +     __u64   size;
> > > > +     __u32   dir;
> > >
> > > Why the odd alignment?  Are you sure this is the best packing for such a
> > > structure?
> > >
> > > Why is dbuf_fd __s32?  dir can be __u8, right?
> > >
> > > I don't know that dma layer very well, it would be good to get some
> > > review from others to see if this really is even a viable thing to do.
> > > The fd handling seems a bit "odd" here, but maybe I just do not
> > > understand it.
> >
> > Frankly looks like a ploy to sidestep review by graphics folks. We'd
> > ask for the userspace first :-)
>
> Please refer to pull request [1].
>
> For any interest in more details, the libmetal is the abstraction layer
> which provides platform independent APIs. The backend implementation
> can be selected per different platforms: ex, rtos, linux,
> standalone (xilinx),,,. For Linux, it supports UIO / vfio as of now.
> The actual user space drivers sit on top of libmetal. Such drivers can be
> found in [2]. This is why I try to avoid any device specific code in
> Linux kernel.
>
> >
> > Also, exporting dma_addr to userspace is considered a very bad idea.
>
> I agree, hence the RFC to pick some brains. :-) Would it make sense
> if this call doesn't export the physicall address, but instead takes
> only the dmabuf fd and register offsets to be programmed?
>
> > If you want to do this properly, you need a minimal in-kernel memory
> > manager, and those tend to be based on top of drm_gem.c and merged
> > through the gpu tree. The last place where we accidentally leaked a
> > dma addr for gpu buffers was in the fbdev code, and we plugged that
> > one with
>
> Could you please help me understand how having a in-kernel memory manager
> helps? Isn't it just moving same dmabuf import / paddr export functionality
> in different modules: kernel memory manager vs uio. In fact, Xilinx does have
> such memory manager based on drm gem in downstream. But for this time we took
> the approach of implementing this through generic dmabuf allocator, ION, and
> enabling the import capability in the UIO infrastructure instead.

There's a group of people working on upstreaming a xilinx drm driver
already. Which driver are we talking about? Can you pls provide a link
to that xilinx drm driver?

Thanks, Daniel

> Thanks,
> -hyun
>
> [1] https://github.com/OpenAMP/libmetal/pull/82/commits/951e2762bd487c98919ad12f2aa81773d8fe7859
> [2] https://github.com/Xilinx/embeddedsw/tree/master/XilinxProcessorIPLib/drivers
>
> >
> > commit 4be9bd10e22dfc7fc101c5cf5969ef2d3a042d8a (tag:
> > drm-misc-next-fixes-2018-10-03)
> > Author: Neil Armstrong <narmstrong@baylibre.com>
> > Date:   Fri Sep 28 14:05:55 2018 +0200
> >
> >     drm/fb_helper: Allow leaking fbdev smem_start
> >
> > Together with cuse the above patch should be enough to implement a drm
> > driver entirely in userspace at least.
> >
> > Cheers, Daniel
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > +41 (0) 79 365 57 48 - http://blog.ffwll.ch



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

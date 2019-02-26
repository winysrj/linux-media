Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B83C4360F
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 12:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A898121852
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 12:06:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="Ih3NfUSF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfBZMGd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:06:33 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:40252 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfBZMG1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 07:06:27 -0500
Received: by mail-it1-f193.google.com with SMTP id l139so1513371ita.5
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 04:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g5Ov+RxKwl/mKZYYxN4XrdesfyZ+XBCP+/DRAcMvDBk=;
        b=Ih3NfUSFo3kJvGozOKt3/XFrX/Ys15EcmTGZJWiclYvBcXRkLDaOmfHljoCVRTePqr
         RoFq3ma1iNasuxa7/ExGCZWxVxb1AloMRBV/u4YddyATmo1anFvh6sbQpeVEOO440rpW
         bzZvyyVAy6qYa4sWU7B+5YFopUx8ccwhuwydQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g5Ov+RxKwl/mKZYYxN4XrdesfyZ+XBCP+/DRAcMvDBk=;
        b=XsYcMYSN0EwwsyBeEDjBNiD3lVqhvYTBsypYGMBEz7cpknX38Rm7VxDjZie+IHy1Hf
         7x4ZKy/LnzNs+thlLAqzg0oIhkMUCETGIpUQaKwuxBlsO/4xOlJT9acnjLkatEC2/GNq
         VPG+v5TrNBwDXArYR5EMGwddG2+ItGY5p3fZoTvj5M8RRPluw8mkzDc8sclC2axeBuHv
         3fgCTD/LkMKaEIm0kxPC2Y49z5RNvOrQzcG9O7z4UqF7Ohhd/Uvf9DVgi3blWaXCAoeb
         i5SlHdHv6GX78H8gWDRp3YZAPtut0Su3YMP/zZMPZyHTFmS/6rjUCqOFVAan7QCEJxsp
         XTEA==
X-Gm-Message-State: AHQUAuYmaKOQ+GOz0krhOUW9bYaqcky3CvhzLNzKEXPCTsfh/rTMs7A7
        sbe1rkkD2QyyFt6sgjQG7QSRzN2X2XOas6zO/0DxWA==
X-Google-Smtp-Source: AHgI3IbRgruUICrNp06lvsUlwbjyV/pJTH9wUMVQUzidn105nq31ExX0LnywuLcDnXdcppTs93Et3mU66K2VBgsnRWQ=
X-Received: by 2002:a24:7412:: with SMTP id o18mr2143337itc.117.1551182786028;
 Tue, 26 Feb 2019 04:06:26 -0800 (PST)
MIME-Version: 1.0
References: <1550953697-7288-1-git-send-email-hyun.kwon@xilinx.com>
 <1550953697-7288-2-git-send-email-hyun.kwon@xilinx.com> <20190226115311.GA4094@kroah.com>
In-Reply-To: <20190226115311.GA4094@kroah.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 26 Feb 2019 13:06:13 +0100
Message-ID: <CAKMK7uE=dSyo5vdjtQf=k1rdoegiBgSozCOotXLSW2VAkz2Ldw@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] uio: Add dma-buf import ioctls
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hyun Kwon <hyun.kwon@xilinx.com>,
        Stefano Stabellini <stefanos@xilinx.com>,
        Sonal Santan <sonals@xilinx.com>,
        Cyril Chemparathy <cyrilc@xilinx.com>,
        Jiaying Liang <jliang@xilinx.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 26, 2019 at 12:53 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Feb 23, 2019 at 12:28:17PM -0800, Hyun Kwon wrote:
> > Add the dmabuf map / unmap interfaces. This allows the user driver
> > to be able to import the external dmabuf and use it from user space.
> >
> > Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> > ---
> >  drivers/uio/Makefile         |   2 +-
> >  drivers/uio/uio.c            |  43 +++++++++
> >  drivers/uio/uio_dmabuf.c     | 210 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/uio/uio_dmabuf.h     |  26 ++++++
> >  include/uapi/linux/uio/uio.h |  33 +++++++
> >  5 files changed, 313 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/uio/uio_dmabuf.c
> >  create mode 100644 drivers/uio/uio_dmabuf.h
> >  create mode 100644 include/uapi/linux/uio/uio.h
> >
> > diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> > index c285dd2..5da16c7 100644
> > --- a/drivers/uio/Makefile
> > +++ b/drivers/uio/Makefile
> > @@ -1,5 +1,5 @@
> >  # SPDX-License-Identifier: GPL-2.0
> > -obj-$(CONFIG_UIO)    += uio.o
> > +obj-$(CONFIG_UIO)    += uio.o uio_dmabuf.o
> >  obj-$(CONFIG_UIO_CIF)        += uio_cif.o
> >  obj-$(CONFIG_UIO_PDRV_GENIRQ)        += uio_pdrv_genirq.o
> >  obj-$(CONFIG_UIO_DMEM_GENIRQ)        += uio_dmem_genirq.o
> > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> > index 1313422..6841f98 100644
> > --- a/drivers/uio/uio.c
> > +++ b/drivers/uio/uio.c
> > @@ -24,6 +24,12 @@
> >  #include <linux/kobject.h>
> >  #include <linux/cdev.h>
> >  #include <linux/uio_driver.h>
> > +#include <linux/list.h>
> > +#include <linux/mutex.h>
> > +
> > +#include <uapi/linux/uio/uio.h>
> > +
> > +#include "uio_dmabuf.h"
> >
> >  #define UIO_MAX_DEVICES              (1U << MINORBITS)
> >
> > @@ -454,6 +460,8 @@ static irqreturn_t uio_interrupt(int irq, void *dev_id)
> >  struct uio_listener {
> >       struct uio_device *dev;
> >       s32 event_count;
> > +     struct list_head dbufs;
> > +     struct mutex dbufs_lock; /* protect @dbufs */
> >  };
> >
> >  static int uio_open(struct inode *inode, struct file *filep)
> > @@ -500,6 +508,9 @@ static int uio_open(struct inode *inode, struct file *filep)
> >       if (ret)
> >               goto err_infoopen;
> >
> > +     INIT_LIST_HEAD(&listener->dbufs);
> > +     mutex_init(&listener->dbufs_lock);
> > +
> >       return 0;
> >
> >  err_infoopen:
> > @@ -529,6 +540,10 @@ static int uio_release(struct inode *inode, struct file *filep)
> >       struct uio_listener *listener = filep->private_data;
> >       struct uio_device *idev = listener->dev;
> >
> > +     ret = uio_dmabuf_cleanup(idev, &listener->dbufs, &listener->dbufs_lock);
> > +     if (ret)
> > +             dev_err(&idev->dev, "failed to clean up the dma bufs\n");
> > +
> >       mutex_lock(&idev->info_lock);
> >       if (idev->info && idev->info->release)
> >               ret = idev->info->release(idev->info, inode);
> > @@ -652,6 +667,33 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
> >       return retval ? retval : sizeof(s32);
> >  }
> >
> > +static long uio_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>
> We have resisted adding a uio ioctl for a long time, can't you do this
> through sysfs somehow?
>
> A meta-comment about your ioctl structure:
>
> > +#define UIO_DMABUF_DIR_BIDIR 1
> > +#define UIO_DMABUF_DIR_TO_DEV        2
> > +#define UIO_DMABUF_DIR_FROM_DEV      3
> > +#define UIO_DMABUF_DIR_NONE  4
>
> enumerated type?
>
> > +
> > +struct uio_dmabuf_args {
> > +     __s32   dbuf_fd;
> > +     __u64   dma_addr;
> > +     __u64   size;
> > +     __u32   dir;
>
> Why the odd alignment?  Are you sure this is the best packing for such a
> structure?
>
> Why is dbuf_fd __s32?  dir can be __u8, right?
>
> I don't know that dma layer very well, it would be good to get some
> review from others to see if this really is even a viable thing to do.
> The fd handling seems a bit "odd" here, but maybe I just do not
> understand it.

Frankly looks like a ploy to sidestep review by graphics folks. We'd
ask for the userspace first :-)

Also, exporting dma_addr to userspace is considered a very bad idea.
If you want to do this properly, you need a minimal in-kernel memory
manager, and those tend to be based on top of drm_gem.c and merged
through the gpu tree. The last place where we accidentally leaked a
dma addr for gpu buffers was in the fbdev code, and we plugged that
one with

commit 4be9bd10e22dfc7fc101c5cf5969ef2d3a042d8a (tag:
drm-misc-next-fixes-2018-10-03)
Author: Neil Armstrong <narmstrong@baylibre.com>
Date:   Fri Sep 28 14:05:55 2018 +0200

    drm/fb_helper: Allow leaking fbdev smem_start

Together with cuse the above patch should be enough to implement a drm
driver entirely in userspace at least.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

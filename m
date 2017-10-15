Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:49838 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751261AbdJOXJ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 19:09:27 -0400
Received: by mail-qk0-f172.google.com with SMTP id q83so7730721qke.6
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 16:09:27 -0700 (PDT)
Message-ID: <1508108964.4502.6.camel@ndufresne.ca>
Subject: Re: [PATCH] media: vb2: unify calling of set_page_dirty_lock
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 15 Oct 2017 19:09:24 -0400
In-Reply-To: <20171015204014.2awhhygw6hi3lxas@valkosipuli.retiisi.org.uk>
References: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
         <1507650010.2784.11.camel@ndufresne.ca>
         <20171015204014.2awhhygw6hi3lxas@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le dimanche 15 octobre 2017 à 23:40 +0300, Sakari Ailus a écrit :
> Hi Nicolas,
> 
> On Tue, Oct 10, 2017 at 11:40:10AM -0400, Nicolas Dufresne wrote:
> > Le mardi 29 août 2017 à 14:26 +0300, Stanimir Varbanov a écrit :
> > > Currently videobuf2-dma-sg checks for dma direction for
> > > every single page and videobuf2-dc lacks any dma direction
> > > checks and calls set_page_dirty_lock unconditionally.
> > > 
> > > Thus unify and align the invocations of set_page_dirty_lock
> > > for videobuf2-dc, videobuf2-sg  memory allocators with
> > > videobuf2-vmalloc, i.e. the pattern used in vmalloc has been
> > > copied to dc and dma-sg.
> > 
> > Just before we go too far in "doing like vmalloc", I would like to
> > share this small video that display coherency issues when rendering
> > vmalloc backed DMABuf over various KMS/DRM driver. I can reproduce
> > this
> > easily with Intel and MSM display drivers using UVC or Vivid as
> > source.
> > 
> > The following is an HDMI capture of the following GStreamer
> > pipeline
> > running on Dragonboard 410c.
> > 
> >     gst-launch-1.0 -v v4l2src device=/dev/video2 ! video/x-
> > raw,format=NV16,width=1280,height=720 ! kmssink
> >     https://people.collabora.com/~nicolas/vmalloc-issue.mov
> > 
> > Feedback on this issue would be more then welcome. It's not clear
> > to me
> > who's bug is this (v4l2, drm or iommu). The software is unlikely to
> > be
> > blamed as this same pipeline works fine with non-vmalloc based
> > sources.
> 
> Could you elaborate this a little bit more? Which Intel CPU do you
> have
> there?

I have tested with Skylake and Ivy Bridge and on Dragonboard 410c
(Qualcomm APQ8016 SoC) (same visual artefact)

> 
> Where are the buffers allocated for this GStreamer pipeline, is it
> v4l2src
> or another element or somewhere else?

This is from V4L2 capture driver, exported as DMABuf, drivers are UVC
and VIVID, both are using the vmalloc allocator.

Nicolas

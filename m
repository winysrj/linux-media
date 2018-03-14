Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:33678 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932769AbeCNAoM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 20:44:12 -0400
Received: by mail-qt0-f175.google.com with SMTP id a23so1754216qtn.0
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 17:44:12 -0700 (PDT)
Message-ID: <1520988249.5128.13.camel@ndufresne.ca>
Subject: Re: [PATCH] media: vb2: unify calling of set_page_dirty_lock
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Mar 2018 20:44:09 -0400
In-Reply-To: <8f1eda59-fc51-b77e-ae43-9603b5759b14@linaro.org>
References: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
         <1507650010.2784.11.camel@ndufresne.ca>
         <20171015204014.2awhhygw6hi3lxas@valkosipuli.retiisi.org.uk>
         <1508108964.4502.6.camel@ndufresne.ca>
         <20171017101420.5a5cvyhkadmcqgfy@valkosipuli.retiisi.org.uk>
         <1508249953.19297.4.camel@ndufresne.ca>
         <8f1eda59-fc51-b77e-ae43-9603b5759b14@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mercredi 18 octobre 2017 à 11:34 +0300, Stanimir Varbanov a écrit :
> 
> On 10/17/2017 05:19 PM, Nicolas Dufresne wrote:
> > Le mardi 17 octobre 2017 à 13:14 +0300, Sakari Ailus a écrit :
> > > On Sun, Oct 15, 2017 at 07:09:24PM -0400, Nicolas Dufresne wrote:
> > > > Le dimanche 15 octobre 2017 à 23:40 +0300, Sakari Ailus a écrit
> > > > :
> > > > > Hi Nicolas,
> > > > > 
> > > > > On Tue, Oct 10, 2017 at 11:40:10AM -0400, Nicolas Dufresne
> > > > > wrote:
> > > > > > Le mardi 29 août 2017 à 14:26 +0300, Stanimir Varbanov a
> > > > > > écrit :
> > > > > > > Currently videobuf2-dma-sg checks for dma direction for
> > > > > > > every single page and videobuf2-dc lacks any dma
> > > > > > > direction
> > > > > > > checks and calls set_page_dirty_lock unconditionally.
> > > > > > > 
> > > > > > > Thus unify and align the invocations of
> > > > > > > set_page_dirty_lock
> > > > > > > for videobuf2-dc, videobuf2-sg  memory allocators with
> > > > > > > videobuf2-vmalloc, i.e. the pattern used in vmalloc has
> > > > > > > been
> > > > > > > copied to dc and dma-sg.
> > > > > > 
> > > > > > Just before we go too far in "doing like vmalloc", I would
> > > > > > like to
> > > > > > share this small video that display coherency issues when
> > > > > > rendering
> > > > > > vmalloc backed DMABuf over various KMS/DRM driver. I can
> > > > > > reproduce
> > > > > > this
> > > > > > easily with Intel and MSM display drivers using UVC or
> > > > > > Vivid as
> > > > > > source.
> > > > > > 
> > > > > > The following is an HDMI capture of the following GStreamer
> > > > > > pipeline
> > > > > > running on Dragonboard 410c.
> > > > > > 
> > > > > >     gst-launch-1.0 -v v4l2src device=/dev/video2 ! video/x-
> > > > > > raw,format=NV16,width=1280,height=720 ! kmssink
> > > > > >     https://people.collabora.com/~nicolas/vmalloc-issue.mov
> > > > > > 
> > > > > > Feedback on this issue would be more then welcome. It's not
> > > > > > clear
> > > > > > to me
> > > > > > who's bug is this (v4l2, drm or iommu). The software is
> > > > > > unlikely to
> > > > > > be
> > > > > > blamed as this same pipeline works fine with non-vmalloc
> > > > > > based
> > > > > > sources.
> > > > > 
> > > > > Could you elaborate this a little bit more? Which Intel CPU
> > > > > do you
> > > > > have
> > > > > there?
> > > > 
> > > > I have tested with Skylake and Ivy Bridge and on Dragonboard
> > > > 410c
> > > > (Qualcomm APQ8016 SoC) (same visual artefact)
> > > 
> > > I presume kmssink draws on the display. Which GPU did you use?
> > 
> > In order, GPU will be Iris Pro 580, Intel® Ivybridge Mobile and an
> > Adreno (3x ?). Why does it matter ? I'm pretty sure the GPU is not
> > used
> > on the DB410c for this use case.
> 
> Nicolas, for me this looks like a problem in v4l2. In the case of
> vivid
> the stats overlay (where the coherency issues are observed, and most
> probably the issue will be observed on the whole image but
> fortunately
> it is a static image pattern) are filled by the CPU but I cannot see
> where the cache is flushed. Also I'm wondering why .finish method is
> missing for dma-vmalloc mem_ops.
> 
> To be sure that the problem is in vmalloc v4l2 allocator, could you
> change the allocator to dma-contig, there is a module param for that
> called 'allocators'.

I've looked into this again. I have hit the same issue but with CPU to
DRM, using DMABuf allocated from DRM Dumb buffers. In that case, using
DMA_BUF_IOCTL_SYNC fixes the issues.

This raises a lot of question around the model used in V4L2. As you
mention, prepare/finish are missing in dma-vmalloc mem_ops. I'll give a
try implementing that, it should cover my initial use case, but then I
believe it will fail if my pipeline is:

  UVC -> in plane CPU modification -> DRM

Because we don't implement begin/end_cpu_access on our exported DMABuf.
It should also fail for the following use case:

  UVC (importer) -> DRM

UVC driver won't call the remote dmabuf being/end_cpu_access method.
This one is difficult because UVC driver and vivid don't seem to be
aware of being an importer, exported or simply exporting to CPU
(through mmap). I believe what we have now pretty much assumes the what
we export as vmalloc is to be used by CPU only. Also, the usual
direction used by prepare/finish ops won't work for drivers like vivid
and UVC that write into the buffers using the cpu.

To be continued ...

Nicolas

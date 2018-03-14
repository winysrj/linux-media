Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:40155 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932954AbeCNCCI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 22:02:08 -0400
Received: by mail-qk0-f180.google.com with SMTP id o25so1887634qkl.7
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 19:02:08 -0700 (PDT)
Message-ID: <1520992925.5128.18.camel@ndufresne.ca>
Subject: Re: [PATCH] media: vb2: unify calling of set_page_dirty_lock
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Mar 2018 22:02:05 -0400
In-Reply-To: <1520989785.5128.16.camel@ndufresne.ca>
References: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
         <1507650010.2784.11.camel@ndufresne.ca>
         <20171015204014.2awhhygw6hi3lxas@valkosipuli.retiisi.org.uk>
         <1508108964.4502.6.camel@ndufresne.ca>
         <20171017101420.5a5cvyhkadmcqgfy@valkosipuli.retiisi.org.uk>
         <1508249953.19297.4.camel@ndufresne.ca>
         <8f1eda59-fc51-b77e-ae43-9603b5759b14@linaro.org>
         <1520988249.5128.13.camel@ndufresne.ca>
         <1520989785.5128.16.camel@ndufresne.ca>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 13 mars 2018 à 21:09 -0400, Nicolas Dufresne a écrit :
> > I've looked into this again. I have hit the same issue but with CPU
> > to
> > DRM, using DMABuf allocated from DRM Dumb buffers. In that case,
> > using
> > DMA_BUF_IOCTL_SYNC fixes the issues.
> > 
> > This raises a lot of question around the model used in V4L2. As you
> > mention, prepare/finish are missing in dma-vmalloc mem_ops. I'll
> > give
> > a
> > try implementing that, it should cover my initial use case, but
> > then
> > I
> > believe it will fail if my pipeline is:
> > 
> >    UVC -> in plane CPU modification -> DRM
> > 
> > Because we don't implement begin/end_cpu_access on our exported
> > DMABuf.
> > It should also fail for the following use case:
> > 
> >    UVC (importer) -> DRM
> > 
> > UVC driver won't call the remote dmabuf being/end_cpu_access
> > method.
> > This one is difficult because UVC driver and vivid don't seem to be
> > aware of being an importer, exported or simply exporting to CPU
> > (through mmap). I believe what we have now pretty much assumes the
> > what
> > we export as vmalloc is to be used by CPU only. Also, the usual
> > direction used by prepare/finish ops won't work for drivers like
> > vivid
> > and UVC that write into the buffers using the cpu.
> > 
> > To be continued ...
> 
> While I was writing that, I was already outdated, as of now, we only
> have one ops, called sync. This implements the to_cpu direction only.

Replying to myself again, obviously looking at the old videobuf code
can only get one confused.

Nicolas

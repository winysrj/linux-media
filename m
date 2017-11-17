Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:42876 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbdKQLa7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 06:30:59 -0500
Date: Fri, 17 Nov 2017 09:30:52 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 09/11] [media] vb2: add infrastructure to support
 out-fences
Message-ID: <20171117113052.GC19033@jade>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-10-gustavo@padovan.org>
 <17276dda-817b-4977-bb6e-77a818fe5f3e@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17276dda-817b-4977-bb6e-77a818fe5f3e@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-11-17 Alexandre Courbot <acourbot@chromium.org>:

> On Thursday, November 16, 2017 2:10:55 AM JST, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Add vb2_setup_out_fence() and the needed members to struct vb2_buffer.
> > 
> > v3:
> > 	- Do not hold yet another ref to the out_fence (Brian Starkey)
> > 
> > v2:	- change it to reflect fd_install at DQEVENT
> > 	- add fence context for out-fences
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> >  drivers/media/v4l2-core/videobuf2-core.c | 28 ++++++++++++++++++++++++++++
> >  include/media/videobuf2-core.h           | 20 ++++++++++++++++++++
> >  2 files changed, 48 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c
> > index 26de4c80717d..8b4f0e9bcb36 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -24,8 +24,10 @@
> >  #include <linux/freezer.h>
> >  #include <linux/kthread.h>
> >  #include <linux/dma-fence-array.h>
> > +#include <linux/sync_file.h>
> >  #include <media/videobuf2-core.h>
> > +#include <media/videobuf2-fence.h>
> >  #include <media/v4l2-mc.h>
> >  #include <trace/events/vb2.h>
> > @@ -1320,6 +1322,32 @@ int vb2_core_prepare_buf(struct vb2_queue *q,
> > unsigned int index, void *pb)
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
> > +int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index)
> > +{
> > +	struct vb2_buffer *vb;
> > +
> > +	vb = q->bufs[index];
> > +
> > +	vb->out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
> 
> out_fence_fd is allocated in this patch but not used anywhere for the
> moment.
> For consistency, maybe move its allocation to the next patch, or move the
> call
> to fd_install() here if that is possible? In both cases, the call to
> get_unused_fd() can be moved right before fd_install() so you don't need to
> call put_unused_fd() in the error paths below.
> 
> ... same thing for sync_file too. Maybe this patch can just be merged into
> the next one? The current patch just creates an incomplete version of
> vb2_setup_out_fence() for which no user exist yet.

It turned out that out-fences patch is not big at all, so I can merge
them both. I think it will be cleaner, thanks for the suggestion.

Gustavo

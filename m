Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34202 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933784AbcLQAu5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 19:50:57 -0500
Date: Sat, 17 Dec 2016 02:50:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 11/11] vb2: dma-contig: Add WARN_ON_ONCE() to check
 for potential bugs
Message-ID: <20161217005052.GQ16630@valkosipuli.retiisi.org.uk>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com>
 <1441972234-8643-12-git-send-email-sakari.ailus@linux.intel.com>
 <1547868.pze7WEjWy0@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547868.pze7WEjWy0@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 15, 2016 at 11:57:54PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday 11 Sep 2015 14:50:34 Sakari Ailus wrote:
> > The scatterlist should always be present when the cache would need to be
> > flushed. Each buffer type has its own means to provide that. Add
> > WARN_ON_ONCE() to check the scatterist exists.
> 
> Do you think such a check is really needed ? Have you run into this before ?

I think I may have, but the reason was that the code is non-trivial and
letting the user know what went wrong and where is nice. I guess this one
could be dropped, too.

> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > b/drivers/media/v4l2-core/videobuf2-dma-contig.c index 65ee122..58c35c5
> > 100644
> > --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > @@ -145,6 +145,9 @@ static void vb2_dc_prepare(void *buf_priv)
> >  	    !dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs))
> >  		return;
> > 
> > +	if (WARN_ON_ONCE(!sgt))
> > +		return;
> > +
> >  	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> >  }
> > 
> > @@ -161,6 +164,9 @@ static void vb2_dc_finish(void *buf_priv)
> >  	    !dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs))
> >  		return;
> > 
> > +	if (WARN_ON_ONCE(!sgt))
> > +		return;
> > +
> >  	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> >  }
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

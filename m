Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54459
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbcISTKh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 15:10:37 -0400
Date: Mon, 19 Sep 2016 16:10:31 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] [media] vsp1: fix CodingStyle violations on multi-line
 comments
Message-ID: <20160919161031.066ec318@vento.lan>
In-Reply-To: <81909867.ShMgWNknpr@avalon>
References: <b61873922d2c0029411304e66f810f5133b32c4d.1474309567.git.mchehab@s-opensource.com>
        <81909867.ShMgWNknpr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Sep 2016 21:35:36 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> 
> On Monday 19 Sep 2016 15:26:19 Mauro Carvalho Chehab wrote:
> > Several multi-line comments added at the vsp1 patch series
> > violate the Kernel CodingStyle. Fix them.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> I prefer the current style but that seems to be a hopeless battle :-) I have a 
> small comment, please see below.
> 
> > ---
> >  drivers/media/platform/vsp1/vsp1_bru.c    |  3 ++-
> >  drivers/media/platform/vsp1/vsp1_clu.c    |  3 ++-
> >  drivers/media/platform/vsp1/vsp1_dl.c     | 21 ++++++++++++++-------
> >  drivers/media/platform/vsp1/vsp1_drm.c    |  3 ++-
> >  drivers/media/platform/vsp1/vsp1_entity.h |  2 +-
> >  drivers/media/platform/vsp1/vsp1_pipe.c   |  2 +-
> >  drivers/media/platform/vsp1/vsp1_rpf.c    |  9 ++++++---
> >  drivers/media/platform/vsp1/vsp1_rwpf.c   |  6 ++++--
> >  drivers/media/platform/vsp1/vsp1_video.c  | 20 +++++++++++++-------
> >  drivers/media/platform/vsp1/vsp1_wpf.c    |  9 ++++++---
> >  10 files changed, 51 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_bru.c
> > b/drivers/media/platform/vsp1/vsp1_bru.c index 2f5788c1a5be..ee8355c28f94
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_bru.c
> > +++ b/drivers/media/platform/vsp1/vsp1_bru.c
> > @@ -242,7 +242,8 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
> > goto done;
> >  	}
> > 
> > -	/* The compose rectangle top left corner must be inside the output
> > +	/*
> > +	 * The compose rectangle top left corner must be inside the output
> >  	 * frame.
> >  	 */
> >  	format = vsp1_entity_get_pad_format(&bru->entity, config,
> > diff --git a/drivers/media/platform/vsp1/vsp1_clu.c
> > b/drivers/media/platform/vsp1/vsp1_clu.c index f052abd05166..f2fb26e5ab4e
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_clu.c
> > +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> > @@ -224,7 +224,8 @@ static void clu_configure(struct vsp1_entity *entity,
> > 
> >  	switch (params) {
> >  	case VSP1_ENTITY_PARAMS_INIT: {
> > -		/* The format can't be changed during streaming, only verify   
> it
> > +		/*
> > +		 * The format can't be changed during streaming, only verify   
> it
> >  		 * at setup time and store the information internally for   
> future
> >  		 * runtime configuration calls.
> >  		 */
> > diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> > b/drivers/media/platform/vsp1/vsp1_dl.c index 0af3e8fdc714..ad545aff4e35
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_dl.c
> > +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> > @@ -296,7 +296,8 @@ struct vsp1_dl_list *vsp1_dl_list_get(struct
> > vsp1_dl_manager *dlm) dl = list_first_entry(&dlm->free, struct
> > vsp1_dl_list, list);
> >  		list_del(&dl->list);
> > 
> > -		/* The display list chain must be initialised to ensure every
> > +		/*
> > +		 * The display list chain must be initialised to ensure every
> >  		 * display list can assert list_empty() if it is not in a   
> chain.
> >  		 */
> >  		INIT_LIST_HEAD(&dl->chain);
> > @@ -315,7 +316,8 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
> >  	if (!dl)
> >  		return;
> > 
> > -	/* Release any linked display-lists which were chained for a single
> > +	/*
> > +	 * Release any linked display-lists which were chained for a single
> >  	 * hardware operation.
> >  	 */
> >  	if (dl->has_chain) {
> > @@ -325,7 +327,8 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
> > 
> >  	dl->has_chain = false;
> > 
> > -	/* We can't free fragments here as DMA memory can only be freed in
> > +	/*
> > +	 * We can't free fragments here as DMA memory can only be freed in
> >  	 * interruptible context. Move all fragments to the display list
> >  	 * manager's list of fragments to be freed, they will be
> >  	 * garbage-collected by the work queue.
> > @@ -437,7 +440,8 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list
> > *dl, bool is_last) struct vsp1_dl_body *dlb;
> >  	unsigned int num_lists = 0;
> > 
> > -	/* Fill the header with the display list bodies addresses and sizes.   
> The
> > +	/*
> > +	 * Fill the header with the display list bodies addresses and sizes.   
> The
> >  	 * address of the first body has already been filled when the display
> >  	 * list was allocated.
> >  	 */
> > @@ -456,7 +460,8 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list
> > *dl, bool is_last)
> > 
> >  	dl->header->num_lists = num_lists;
> > 
> > -	/* If this display list's chain is not empty, we are on a list, where
> > +	/*
> > +	 * If this display list's chain is not empty, we are on a list, where
> >  	 * the next item in the list is the display list entity which should   
> be
> >  	 * automatically queued by the hardware.
> >  	 */
> > @@ -482,7 +487,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
> >  	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
> >  		struct vsp1_dl_list *dl_child;
> > 
> > -		/* In header mode the caller guarantees that the hardware is
> > +		/*
> > +		 * In header mode the caller guarantees that the hardware is
> >  		 * idle at this point.
> >  		 */
> > 
> > @@ -495,7 +501,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
> >  			vsp1_dl_list_fill_header(dl_child, last);
> >  		}
> > 
> > -		/* Commit the head display list to hardware. Chained headers
> > +		/*
> > +		 * Commit the head display list to hardware. Chained headers
> >  		 * will auto-start.
> >  		 */
> >  		vsp1_write(vsp1, VI6_DL_HDR_ADDR(dlm->index), dl->dma);
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > b/drivers/media/platform/vsp1/vsp1_drm.c index 54795b5e5a8a..cd209dccff1b
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > @@ -283,7 +283,8 @@ int vsp1_du_atomic_update(struct device *dev, unsigned
> > int rpf_index, cfg->pixelformat, cfg->pitch, &cfg->mem[0], &cfg->mem[1],
> >  		&cfg->mem[2], cfg->zpos);
> > 
> > -	/* Store the format, stride, memory buffer address, crop and compose
> > +	/*
> > +	 * Store the format, stride, memory buffer address, crop and compose
> >  	 * rectangles and Z-order position and for the input.
> >  	 */
> >  	fmtinfo = vsp1_get_format_info(vsp1, cfg->pixelformat);
> > diff --git a/drivers/media/platform/vsp1/vsp1_entity.h
> > b/drivers/media/platform/vsp1/vsp1_entity.h index
> > 90a4d95c0a50..901146f807b9 100644
> > --- a/drivers/media/platform/vsp1/vsp1_entity.h
> > +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> > @@ -35,7 +35,7 @@ enum vsp1_entity_type {
> >  	VSP1_ENTITY_WPF,
> >  };
> > 
> > -/*
> > +/**  
> 
> Quoting another mail I've sent:
> 
> I don't think those comments should become part of the kernel documentation. 
> They're really about driver internals, and meant for the driver developers. In 
> particular only a subset of the driver is documented that way, when I've 
> considered that the code or structures were complex enough to need proper 
> documentation. A generated doc would then be quite incomplete and not very 
> useful, the comments are meant to be read while working on the code.

Just doing the above won't make it part of the Kernel documentation.

It will only be part of it if you explicitly include the file with
the ".. kernel-doc::" directive.

Even if you don't add it at the Kernel documentation, I strongly
suggest to use the kernel-doc tags and format, due to two reasons:

1) If you later want to add a book, there's no need to touch at the
function/struct documentation. Everything will there already;

2) Markus Raiser is writing validation tool for those tags:
	install: https://return42.github.io/linuxdoc/install.html
	lint:    https://return42.github.io/linuxdoc/cmd-line.html#kernel-lintdoc

By using his tool, you would be able to check if a patch is keeping
the documentation documented, as you modify it.

Btw, on several places inside the vsp1 documentation, you're using the
"/**" tag already for other function/struct descriptions.


Regards,
Mauro

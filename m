Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37010 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030751AbeE1KSA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 06:18:00 -0400
Date: Mon, 28 May 2018 07:17:54 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Message-ID: <20180528071754.2b594656@vento.lan>
In-Reply-To: <3755894.Y1GIYirAvc@avalon>
References: <10831984.07PNLvckhh@avalon>
        <20180526082818.70a369b5@vento.lan>
        <7346563.L0Ry6hIlrs@avalon>
        <3755894.Y1GIYirAvc@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 May 2018 11:31:01 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro and Dan,
> 
> Dan, there's a question for you below.
> 
> On Monday, 28 May 2018 11:28:41 EEST Laurent Pinchart wrote:
> > On Saturday, 26 May 2018 14:28:18 EEST Mauro Carvalho Chehab wrote:  
> > > Em Sat, 26 May 2018 03:24:00 +0300 Laurent Pinchart escreveu:  
> > [snip]
> >   
> > > > I've reproduced the issue and created a minimal test case.
> > > > 
> > > >  1. struct vsp1_pipeline;
> > > >  2.
> > > >  3. struct vsp1_entity {
> > > >  4.         struct vsp1_pipeline *pipe;
> > > >  5.         struct vsp1_entity *sink;
> > > >  6.         unsigned int source_pad;
> > > >  7. };
> > > >  8.
> > > >  9. struct vsp1_pipeline {
> > > > 10.         struct vsp1_entity *brx;
> > > > 11. };
> > > > 12.
> > > > 13. struct vsp1_brx {
> > > > 14.         struct vsp1_entity entity;
> > > > 15. };
> > > > 16.
> > > > 17. struct vsp1_device {
> > > > 18.         struct vsp1_brx *bru;
> > > > 19.         struct vsp1_brx *brs;
> > > > 20. };
> > > > 21.
> > > > 22. unsigned int frob(struct vsp1_device *vsp1, struct vsp1_pipeline
> > > > *pipe)
> > > > 23. {
> > > > 24.         struct vsp1_entity *brx;
> > > > 25.
> > > > 26.         if (pipe->brx)
> > > > 27.                 brx = pipe->brx;
> > > > 28.         else if (!vsp1->bru->entity.pipe)
> > > > 29.                 brx = &vsp1->bru->entity;
> > > > 30.         else
> > > > 31.                 brx = &vsp1->brs->entity;
> > > > 32.
> > > > 33.         if (brx != pipe->brx)
> > > > 34.                 pipe->brx = brx;
> > > > 35.
> > > > 36.         return pipe->brx->source_pad;
> > > > 37. }
> > > > 
> > > > The reason why smatch complains is that it has no guarantee that
> > > > vsp1->brs is not NULL. It's quite tricky:
> > > > 
> > > > - On line 26, smatch assumes that pipe->brx can be NULL
> > > > - On line 27, brx is assigned a non-NULL value (as pipe->brx is not NULL
> > > > due to line 26)
> > > > - On line 28, smatch assumes that vsp1->bru is not NULL
> > > > - On line 29, brx is assigned a non-NULL value (as vsp1->bru is not NULL
> > > > due to line 28)
> > > > - On line 31, brx is assigned a possibly NULL value (as there's no
> > > > information regarding vsp1->brs)
> > > > - On line 34, pipe->brx is not assigned a non-NULL value if brx is NULL
> > > > - On line 36 pipe->brx is dereferenced
> > > > 
> > > > The problem comes from the fact that smatch assumes that vsp1->brs isn't
> > > > NULL. Adding a "(void)vsp1->brs->entity;" statement on line 25 makes the
> > > > warning disappear.
> > > > 
> > > > So how do we know that vsp1->brs isn't NULL in the original code ?
> > > > 
> > > >         if (pipe->num_inputs > 2)
> > > >                 brx = &vsp1->bru->entity;
> > > >         else if (pipe->brx && !drm_pipe->force_brx_release)
> > > >                 brx = pipe->brx;
> > > >         else if (!vsp1->bru->entity.pipe)
> > > >                 brx = &vsp1->bru->entity;
> > > >         else
> > > >                 brx = &vsp1->brs->entity;
> > > > 
> > > > A VSP1 instance can have no brs, so in general vsp1->brs can be NULL.
> > > > However, when that's the case, the following conditions are fulfilled.
> > > > 
> > > > - drm_pipe->force_brx_release will be false
> > > > - either pipe->brx will be non-NULL, or vsp1->bru->entity.pipe will be
> > > > NULL
> > > > 
> > > > The fourth branch should thus never be taken.  
> > > 
> > > I don't think that adding a forth branch there would solve.
> > > 
> > > The thing is that Smatch knows that pipe->brx can be NULL, as the function
> > > explicly checks if pipe->brx != NULL.
> > > 
> > > When Smatch handles this if:
> > > 	if (brx != pipe->brx) {
> > > 
> > > It wrongly assumes that this could be false if pipe->brx is NULL.
> > > I don't know why, as Smatch should know that brx can't be NULL.  
> > 
> > brx can be NULL here if an only if vsp1->brs is NULL (as the entity field is
> > first in the vsp1->brs structure, so &vsp1->brs->entity has the same
> > address as vsp1->brs).
> > 
> > vsp1->brs can be NULL on some devices, but in that case we have the
> > following guarantees:
> > 
> > - drm_pipe->force_brx_release will always be FALSE
> > - either pipe->brx will be non-NULL or vsp1->bru->entity.pipe will be NULL
> > 
> > So the fourth branch is never taken.
> > 
> > The above conditions come from outside this function, and smatch can't know
> > about them. However, I don't know whether the problems comes from smatch
> > assuming that vsp1->brs can be NULL, or from somewhere else.
> >   
> > > On such case, the next code to be executed would be:
> > > 	format.pad = pipe->brx->source_pad;
> > > 
> > > With would be trying to de-ref a NULL pointer.
> > > 
> > > There are two ways to fix it:
> > > 
> > > 1) with my patch.
> > > 
> > > It is based to the fact that, if pipe->brx is null, then brx won't be
> > > NULL. So, the logic that "Switch BRx if needed." will always be called:
> > > 
> > > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > > b/drivers/media/platform/vsp1/vsp1_drm.c index 095dc48aa25a..cb6b60843400
> > > 100644
> > > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > > @@ -185,7 +185,7 @@ static int vsp1_du_pipeline_setup_brx(struct
> > > vsp1_device *vsp1,
> > >  	brx = &vsp1->brs->entity;
> > > 
> > >  	/* Switch BRx if needed. */
> > > -	if (brx != pipe->brx) {
> > > +	if (brx != pipe->brx || !pipe->brx) {
> > >  		struct vsp1_entity *released_brx = NULL;
> > >  		
> > >  		/* Release our BRx if we have one. */
> > > 
> > > The code with switches BRx ensures that pipe->brx won't be null, as
> > > 
> > > in the end, it sets:
> > > 	pipe->brx = brx;
> > > 
> > > And brx can't be NULL.  
> > 
> > The reason I don't like this is because the problem originally comes from
> > the fact that smatch assumes that vsp1->brs can be NULL when it can't. I'd
> > rather modify the code in a way that explicitly tests for vsp1->brs.
> > However, smatch won't accept that happily :-/ I tried
> > 
> >         if (pipe->num_inputs > 2)
> >                 brx = &vsp1->bru->entity;
> >         else if (pipe->brx && !drm_pipe->force_brx_release)
> >                 brx = pipe->brx;
> >         else if (!vsp1->bru->entity.pipe)
> >                 brx = &vsp1->bru->entity;
> >         else if (vsp1->brs)
> >                 brx = &vsp1->brs->entity;
> >         else
> >                 return -EINVAL;
> > 
> > and I still get the same warning. I had to write the following (which is
> > obviously not correct) to silence the warning.
> > 
> >         if (pipe->num_inputs > 2)
> >                 brx = &vsp1->bru->entity;
> >         else if (pipe->brx)
> >                 brx = pipe->brx;
> >         else if (!vsp1->bru->entity.pipe)
> >                 brx = &vsp1->bru->entity;
> >         else {
> >                 (void)vsp1->brs->entity;
> >                 brx = &vsp1->brs->entity;
> >         }
> > 
> > Both the (void)vsp1->brs->entity and the removal of the !drm_pipe-
> >   
> > >force_brx_release were needed, any of those on its own didn't fix the  
> > 
> > problem.
> >   
> > > From my PoV, this patch has the advantage of explicitly showing
> > > to humans that the code inside the if statement will always be
> > > executed when pipe->brx is NULL.
> > > 
> > > -
> > > 
> > > Another way to solve would be to explicitly check if pipe->brx is still
> > > null before de-referencing:
> > > 
> > > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > > b/drivers/media/platform/vsp1/vsp1_drm.c index edb35a5c57ea..9fe063d6df31
> > > 100644
> > > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > > @@ -327,6 +327,9 @@ static int vsp1_du_pipeline_setup_brx(struct
> > > vsp1_device *vsp1,
> > >  		list_add_tail(&pipe->brx->list_pipe, &pipe->entities);
> > >  	}
> > > 
> > > +	if (!pipe->brx)
> > > +		return -EINVAL;
> > > +
> > >  	/*
> > >  	 * Configure the format on the BRx source and verify that it matches
> > >  	 the
> > >  	 * requested format. We don't set the media bus code as it is
> > >  	 configured
> > > 
> > > The right fix would be, instead, to fix Smatch to handle the:
> > > 	if (brx != pipe->brx)
> > > 
> > > for the cases where one var can be NULL while the other can't be NULL,
> > > but, as I said before, I suspect that this can be a way more complex.  
> > 
> > I'm not sure smatch is faulty here, or at least not when it interprets the
> > brx != pipe->brx check. The problem seems to come from the fact that is
> > believes brx can be NULL.  
> 
> And that being said, I just tried
> 
>         if (pipe->num_inputs > 2)
>                 brx = &vsp1->bru->entity;
>         else if (pipe->brx && !drm_pipe->force_brx_release)
>                 brx = pipe->brx;
>         else if (!vsp1->bru->entity.pipe)
>                 brx = &vsp1->bru->entity;
>         else
>                 brx = &vsp1->brs->entity;
> 
>         if (!brx)
>                 return -EINVAL;
> 
> and that didn't help either... Dan, would you have some light to shed on this 
> problem ?
> 

This (obviously wrong patch) shut up the warning:

--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -248,6 +248,9 @@ static int vsp1_du_pipeline_setup_brx(struct vsp1_device *vsp1,
        else
                brx = &vsp1->brs->entity;
 
+       if (pipe->brx == brx)
+               pipe->brx = &vsp1->brs->entity;
+
        /* Switch BRx if needed. */
        if (brx != pipe->brx) {
                struct vsp1_entity *released_brx = NULL;

The problem here is that:

1) Smatch knows that pipe->brx can be NULL;
2) Smatch is not smart enough to detect that, if pipe->brx == NULL, brx
   won't be NULL and the if will always succeed.

However, Smatch seems to be smart enough to detect that brx is
not null, as it properly identifies that this code segment:

		pipe->brx = brx;
                pipe->brx->pipe = pipe;
                pipe->brx->sink = &pipe->output->entity;
                pipe->brx->sink_pad = 0;

will initialize pipe->brx with a non-NULL value.

Thanks,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38314 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163332AbeE1KsV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 06:48:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Date: Mon, 28 May 2018 13:48:22 +0300
Message-ID: <3294867.nEPE3mz4Dc@avalon>
In-Reply-To: <20180528070305.40d5f07a@vento.lan>
References: <10831984.07PNLvckhh@avalon> <7346563.L0Ry6hIlrs@avalon> <20180528070305.40d5f07a@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday, 28 May 2018 13:03:05 EEST Mauro Carvalho Chehab wrote:
> Em Mon, 28 May 2018 11:28:41 +0300 Laurent Pinchart escreveu:
> > On Saturday, 26 May 2018 14:28:18 EEST Mauro Carvalho Chehab wrote:
> >> Em Sat, 26 May 2018 03:24:00 +0300 Laurent Pinchart escreveu:
> > [snip]
> > 
> >>> I've reproduced the issue and created a minimal test case.
> >>> 
> >>>  1. struct vsp1_pipeline;
> >>>  2.
> >>>  3. struct vsp1_entity {
> >>>  4.         struct vsp1_pipeline *pipe;
> >>>  5.         struct vsp1_entity *sink;
> >>>  6.         unsigned int source_pad;
> >>>  7. };
> >>>  8.
> >>>  9. struct vsp1_pipeline {
> >>> 10.         struct vsp1_entity *brx;
> >>> 11. };
> >>> 12.
> >>> 13. struct vsp1_brx {
> >>> 14.         struct vsp1_entity entity;
> >>> 15. };
> >>> 16.
> >>> 17. struct vsp1_device {
> >>> 18.         struct vsp1_brx *bru;
> >>> 19.         struct vsp1_brx *brs;
> >>> 20. };
> >>> 21.
> >>> 22. unsigned int frob(struct vsp1_device *vsp1, struct vsp1_pipeline
> >>> *pipe)
> >>> 23. {
> >>> 24.         struct vsp1_entity *brx;
> >>> 25.
> >>> 26.         if (pipe->brx)
> >>> 27.                 brx = pipe->brx;
> >>> 28.         else if (!vsp1->bru->entity.pipe)
> >>> 29.                 brx = &vsp1->bru->entity;
> >>> 30.         else
> >>> 31.                 brx = &vsp1->brs->entity;
> >>> 32.
> >>> 33.         if (brx != pipe->brx)
> >>> 34.                 pipe->brx = brx;
> >>> 35.
> >>> 36.         return pipe->brx->source_pad;
> >>> 37. }
> >>> 
> >>> The reason why smatch complains is that it has no guarantee that
> >>> vsp1->brs is not NULL. It's quite tricky:
> >>> 
> >>> - On line 26, smatch assumes that pipe->brx can be NULL
> >>> - On line 27, brx is assigned a non-NULL value (as pipe->brx is not
> >>> NULL due to line 26)
> >>> - On line 28, smatch assumes that vsp1->bru is not NULL
> >>> - On line 29, brx is assigned a non-NULL value (as vsp1->bru is not
> >>> NULL due to line 28)
> >>> - On line 31, brx is assigned a possibly NULL value (as there's no
> >>> information regarding vsp1->brs)
> >>> - On line 34, pipe->brx is not assigned a non-NULL value if brx is
> >>> NULL
> >>> - On line 36 pipe->brx is dereferenced
> >>> 
> >>> The problem comes from the fact that smatch assumes that vsp1->brs
> >>> isn't NULL. Adding a "(void)vsp1->brs->entity;" statement on line 25
> >>> makes the warning disappear.
> >>> 
> >>> So how do we know that vsp1->brs isn't NULL in the original code ?
> >>> 
> >>>         if (pipe->num_inputs > 2)
> >>>                 brx = &vsp1->bru->entity;
> >>>         else if (pipe->brx && !drm_pipe->force_brx_release)
> >>>                 brx = pipe->brx;
> >>>         else if (!vsp1->bru->entity.pipe)
> >>>                 brx = &vsp1->bru->entity;
> >>>         else
> >>>                 brx = &vsp1->brs->entity;
> >>> 
> >>> A VSP1 instance can have no brs, so in general vsp1->brs can be NULL.
> >>> However, when that's the case, the following conditions are fulfilled.
> >>> 
> >>> - drm_pipe->force_brx_release will be false
> >>> - either pipe->brx will be non-NULL, or vsp1->bru->entity.pipe will be
> >>> NULL
> >>> 
> >>> The fourth branch should thus never be taken.
> >> 
> >> I don't think that adding a forth branch there would solve.
> >> 
> >> The thing is that Smatch knows that pipe->brx can be NULL, as the
> >> function explicly checks if pipe->brx != NULL.
> >> 
> >> When Smatch handles this if:
> >> 	if (brx != pipe->brx) {
> >> 
> >> It wrongly assumes that this could be false if pipe->brx is NULL.
> >> I don't know why, as Smatch should know that brx can't be NULL.
> > 
> > brx can be NULL here if an only if vsp1->brs is NULL (as the entity field
> > is first in the vsp1->brs structure, so &vsp1->brs->entity has the same
> > address as vsp1->brs).
> 
> I can't see how brx can be NULL. At the sequence of ifs:
> 
> 	if (pipe->num_inputs > 2)
>                 brx = &vsp1->bru->entity;
>         else if (pipe->brx && !drm_pipe->force_brx_release)
>                 brx = pipe->brx;
>         else if (!vsp1->bru->entity.pipe)
>                 brx = &vsp1->bru->entity;
>         else
>                 brx = &vsp1->brs->entity;
> 
> 
> The usage of brx = &(something) will always return a non NULL value[1].

I don't agree. When vsp1->brs is NULL, &vsp1->brs->entity will evaluate to 
NULL as well.

> The only clause where it doesn't use this pattern is:
> 
> 	...
> 	if (pipe->brx && !drm_pipe->force_brx_release)
>                 brx = pipe->brx;
> 	...
> 
> This one explicitly checks if pipe->brx is NULL, so it will only
> hit on a non-NULL value. If it doesn't hit, brx will be initialized
> by a pointer too either bru or brs entity.
> 
> So, brx will always be non-NULL, even if pipe->brx is NULL.
> 
> [1] It might be doing a NULL deref - with seems to be your concern
>     when you're talking about the case where vsp1->brs is NULL - but
>     that's not what Smatch is complaining here.

&vsp1->brs->entity will not cause a NULL dereference, it doesn't cause vsp1-
>brs to be dereferenced.

> > vsp1->brs can be NULL on some devices, but in that case we have the
> > following guarantees:
> > 
> > - drm_pipe->force_brx_release will always be FALSE
> > - either pipe->brx will be non-NULL or vsp1->bru->entity.pipe will be NULL
> > 
> > So the fourth branch is never taken.
> > 
> > The above conditions come from outside this function, and smatch can't
> > know about them. However, I don't know whether the problems comes from
> > smatch assuming that vsp1->brs can be NULL, or from somewhere else.
> > 
> >> On such case, the next code to be executed would be:
> >> 	format.pad = pipe->brx->source_pad;
> >> 
> >> With would be trying to de-ref a NULL pointer.
> >> 
> >> There are two ways to fix it:
> >> 
> >> 1) with my patch.
> >> 
> >> It is based to the fact that, if pipe->brx is null, then brx won't be
> >> NULL. So, the logic that "Switch BRx if needed." will always be called:
> >> 
> >> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> >> b/drivers/media/platform/vsp1/vsp1_drm.c index
> >> 095dc48aa25a..cb6b60843400
> >> 100644
> >> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> >> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> >> @@ -185,7 +185,7 @@ static int vsp1_du_pipeline_setup_brx(struct
> >> vsp1_device *vsp1,
> >>  	brx = &vsp1->brs->entity;
> >> 
> >>  	/* Switch BRx if needed. */
> >> -	if (brx != pipe->brx) {
> >> +	if (brx != pipe->brx || !pipe->brx) {
> >>  		struct vsp1_entity *released_brx = NULL;
> >>  		
> >>  		/* Release our BRx if we have one. */
> >> 
> >> The code with switches BRx ensures that pipe->brx won't be null, as
> >> in the end, it sets:
> >> 
> >> 	pipe->brx = brx;
> >> 
> >> And brx can't be NULL.
> > 
> > The reason I don't like this is because the problem originally comes from
> > the fact that smatch assumes that vsp1->brs can be NULL when it can't.
> 
> No, that's not Smatch assumption. If it where, it would print a different
> kind of warning, at this statement:
> 	brx = &vsp1->brs->entity;
> 
> It only complains later at this line:
> 
> 	format.pad = pipe->brx->source_pad;
> 
> because it thinks that pipe->brx can be NULL. This happens only if
> pipe->brx is NULL and this if fails:
> 
> 	/* Switch BRx if needed. */
>  if (pipe->brx != brx) {

Correct, and I think that smatch believes that branch is not necessarily taken 
when pipe->brx is NULL, because brx can also be NULL.

> > I'd rather modify the code in a way that explicitly tests for vsp1->brs.
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
> > Both the (void)vsp1->brs->entity and the removal of the !drm_pipe->
> > force_brx_release were needed, any of those on its own didn't fix the
> > problem.
> > 
> >> From my PoV, this patch has the advantage of explicitly showing
> >> to humans that the code inside the if statement will always be
> >> executed when pipe->brx is NULL.
> >> 
> >> -
> >> 
> >> Another way to solve would be to explicitly check if pipe->brx is still
> >> null before de-referencing:
> >> 
> >> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> >> b/drivers/media/platform/vsp1/vsp1_drm.c index
> >> edb35a5c57ea..9fe063d6df31
> >> 100644
> >> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> >> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> >> @@ -327,6 +327,9 @@ static int vsp1_du_pipeline_setup_brx(struct
> >> vsp1_device *vsp1,
> >>  		list_add_tail(&pipe->brx->list_pipe, &pipe->entities);
> >>  	}
> >> 
> >> +	if (!pipe->brx)
> >> +		return -EINVAL;
> >> +
> >>  	/*
> >>  	 * Configure the format on the BRx source and verify that it matches
> >>  	 the
> >>  	 * requested format. We don't set the media bus code as it is
> >>  	 configured
> >> 
> >> The right fix would be, instead, to fix Smatch to handle the:
> >> 	if (brx != pipe->brx)
> >> 
> >> for the cases where one var can be NULL while the other can't be NULL,
> >> but, as I said before, I suspect that this can be a way more complex.
> > 
> > I'm not sure smatch is faulty here, or at least not when it interprets the
> > brx != pipe->brx check. The problem seems to come from the fact that is
> > believes brx can be NULL.
> 
> The brx dependency logic is complex, with, IMHO, tricks enough Smatch to
> not be able of properly evaluate that the if will always be true if
> pipe->brx is NULL.

-- 
Regards,

Laurent Pinchart

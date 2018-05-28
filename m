Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38386 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937817AbeE1K6k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 06:58:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Date: Mon, 28 May 2018 13:58:41 +0300
Message-ID: <5458207.P65NUnc4kr@avalon>
In-Reply-To: <20180528103608.3hwqenzdbvbopuqj@mwanda>
References: <10831984.07PNLvckhh@avalon> <3755894.Y1GIYirAvc@avalon> <20180528103608.3hwqenzdbvbopuqj@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Monday, 28 May 2018 13:36:08 EEST Dan Carpenter wrote:
> On Mon, May 28, 2018 at 11:31:01AM +0300, Laurent Pinchart wrote:
> > And that being said, I just tried
> > 
> >         if (pipe->num_inputs > 2)
> >                 brx = &vsp1->bru->entity;
> >         else if (pipe->brx && !drm_pipe->force_brx_release)
> >                 brx = pipe->brx;
> >         else if (!vsp1->bru->entity.pipe)
> >                 brx = &vsp1->bru->entity;
> >         else
> >                 brx = &vsp1->brs->entity;
> >         
> >         if (!brx)
> >                 return -EINVAL;
> > 
> > and that didn't help either... Dan, would you have some light to shed on
> > this problem ?
> 
> This is a problem in Smatch.
> 
> We should be able to go backwards and say that "If we know 'brx' is
> non-NULL then let's mark &vsp1->brs->entity, vsp1->brs,
> &vsp1->bru->entity and vsp1->bru all as non-NULL as well".  But Smatch
> doesn't go backwards like that.  The information is mostly there to do
> it, but my instinct is that it's really hard to implement.
> 
> The other potential problem here is that Smatch stores comparisons and
> values separately.  In other words smatch_comparison.c has all the
> information about brx == &vsp1->bru->entity and smatch_extra.c has the
> information about if brx is NULL or non-NULL.  They don't really share
> information very well.

It would indeed be useful to implement, but I share your concern that this 
would be pretty difficult.

However, there's still something that puzzles me. Let's add a bit more 
context.

        if (pipe->num_inputs > 2)
                brx = &vsp1->bru->entity;
        else if (pipe->brx && !drm_pipe->force_brx_release)
                brx = pipe->brx;
        else if (!vsp1->bru->entity.pipe)
                brx = &vsp1->bru->entity;
        else
                brx = &vsp1->brs->entity;

1.      if (!brx)
                return -EINVAL;

2.      if (brx != pipe->brx) {
                ...
3.              pipe->brx = brx;
                ...
        }

4.      format.pad = pipe->brx->source_pad


(1) ensures that brx can't be NULL. (2) is thus always true if pipe->brx is 
NULL. (3) then assigns a non-NULL value to pipe->brx. Smatch should thus never 
complain about (4), even if it can't backtrack.

-- 
Regards,

Laurent Pinchart

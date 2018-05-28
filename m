Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45740 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161792AbeE1KgZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 06:36:25 -0400
Date: Mon, 28 May 2018 13:36:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Message-ID: <20180528103608.3hwqenzdbvbopuqj@mwanda>
References: <10831984.07PNLvckhh@avalon>
 <20180526082818.70a369b5@vento.lan>
 <7346563.L0Ry6hIlrs@avalon>
 <3755894.Y1GIYirAvc@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3755894.Y1GIYirAvc@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 11:31:01AM +0300, Laurent Pinchart wrote:
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

This is a problem in Smatch.

We should be able to go backwards and say that "If we know 'brx' is
non-NULL then let's mark &vsp1->brs->entity, vsp1->brs,
&vsp1->bru->entity and vsp1->bru all as non-NULL as well".  But Smatch
doesn't go backwards like that.  The information is mostly there to do
it, but my instinct is that it's really hard to implement.

The other potential problem here is that Smatch stores comparisons and
values separately.  In other words smatch_comparison.c has all the
information about brx == &vsp1->bru->entity and smatch_extra.c has the
information about if brx is NULL or non-NULL.  They don't really share
information very well.

regards,
dan carpenter

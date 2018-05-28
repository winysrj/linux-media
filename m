Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44812 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165004AbeE1MKx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 08:10:53 -0400
Date: Mon, 28 May 2018 15:10:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Message-ID: <20180528121032.lgkw7r3oebqs4n6i@mwanda>
References: <10831984.07PNLvckhh@avalon>
 <3755894.Y1GIYirAvc@avalon>
 <20180528103608.3hwqenzdbvbopuqj@mwanda>
 <5458207.P65NUnc4kr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5458207.P65NUnc4kr@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 01:58:41PM +0300, Laurent Pinchart wrote:
> It would indeed be useful to implement, but I share your concern that this 
> would be pretty difficult.
> 
> However, there's still something that puzzles me. Let's add a bit more 
> context.
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
> 1.      if (!brx)
>                 return -EINVAL;
> 
> 2.      if (brx != pipe->brx) {
>                 ...
> 3.              pipe->brx = brx;
>                 ...
>         }
> 
> 4.      format.pad = pipe->brx->source_pad
> 
> 
> (1) ensures that brx can't be NULL. (2) is thus always true if pipe->brx is 
> NULL. (3) then assigns a non-NULL value to pipe->brx. Smatch should thus never 
> complain about (4), even if it can't backtrack.

Oh wow...  That's a very basic and ancient bug.  I've written a fix and
will push it out tomorrow if it passes my testing.

regards,
dan carpenter

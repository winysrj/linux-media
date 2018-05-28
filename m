Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42368 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033303AbeE1KVI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 06:21:08 -0400
Date: Mon, 28 May 2018 13:20:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Message-ID: <20180528102049.vnrej5by7dvkeiyd@mwanda>
References: <10831984.07PNLvckhh@avalon>
 <1657947.LKPPaiEoOV@avalon>
 <20180526082818.70a369b5@vento.lan>
 <7346563.L0Ry6hIlrs@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7346563.L0Ry6hIlrs@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 11:28:41AM +0300, Laurent Pinchart wrote:
> and I still get the same warning. I had to write the following (which is 
> obviously not correct) to silence the warning.
> 
>         if (pipe->num_inputs > 2)
>                 brx = &vsp1->bru->entity;
>         else if (pipe->brx)
>                 brx = pipe->brx;
>         else if (!vsp1->bru->entity.pipe)
>                 brx = &vsp1->bru->entity;
>         else { 
>                 (void)vsp1->brs->entity;
>                 brx = &vsp1->brs->entity;
>         }
> 
> Both the (void)vsp1->brs->entity and the removal of the !drm_pipe-
> >force_brx_release were needed, any of those on its own didn't fix the 
> problem.

The problem in this case is the first "brx = &vsp1->bru->entity;".
Smatch assumes &vsp1->bru->entity can be == to pipe->brx and NULL.
Adding a "(void)vsp1->bru->entity;" on that path will silence the
warning (hopefully).

regards,
dan carpenter

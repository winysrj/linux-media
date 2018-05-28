Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38354 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164229AbeE1KyR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 06:54:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Date: Mon, 28 May 2018 13:54:18 +0300
Message-ID: <3330729.SuyROXNipa@avalon>
In-Reply-To: <20180528102049.vnrej5by7dvkeiyd@mwanda>
References: <10831984.07PNLvckhh@avalon> <7346563.L0Ry6hIlrs@avalon> <20180528102049.vnrej5by7dvkeiyd@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thank you for your quick reply.

On Monday, 28 May 2018 13:20:49 EEST Dan Carpenter wrote:
> On Mon, May 28, 2018 at 11:28:41AM +0300, Laurent Pinchart wrote:
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
> 
> The problem in this case is the first "brx = &vsp1->bru->entity;".
> Smatch assumes &vsp1->bru->entity can be == to pipe->brx and NULL.

Why does smatch assume that &vsp1->bru->entity can be NULL, when the previous 
line dereferences vsp1->bru ?

> Adding a "(void)vsp1->bru->entity;" on that path will silence the
> warning (hopefully).

-- 
Regards,

Laurent Pinchart

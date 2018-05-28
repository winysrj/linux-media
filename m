Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36462 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937874AbeE1K5o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 06:57:44 -0400
Date: Mon, 28 May 2018 13:57:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Message-ID: <20180528105728.vp3v73tfk2egdqgi@mwanda>
References: <10831984.07PNLvckhh@avalon>
 <1657947.LKPPaiEoOV@avalon>
 <20180526082818.70a369b5@vento.lan>
 <7346563.L0Ry6hIlrs@avalon>
 <20180528070305.40d5f07a@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180528070305.40d5f07a@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 07:03:05AM -0300, Mauro Carvalho Chehab wrote:
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
> The usage of brx = &(something) will always return a non NULL
> value[1].

That's not right.  It can be NULL if it's &foo->first_struct_member
and ->entity is the first struct member.  If it weren't the first struct
member then Smatch would say that brx was non-NULL.

> [1] It might be doing a NULL deref - with seems to be your concern
>     when you're talking about the case where vsp1->brs is NULL - but 
>     that's not what Smatch is complaining here.

If vsp1->bru were NULL, it wouldn't be a NULL dereference because it's
not dereferencing it; it's just taking the address.  On the path where
we do:
	else if (!vsp1->bru->entity.pipe)
		brx = &vsp1->bru->entity;

Then Smatch sees that vsp1->bru is dereferenced and marks "brx" as
non-NULL.

regards,
dan carpenter

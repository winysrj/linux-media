Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43370 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424700AbeE1LTC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 07:19:02 -0400
Date: Mon, 28 May 2018 14:18:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Message-ID: <20180528111841.cevpbkzmrro25ysm@mwanda>
References: <10831984.07PNLvckhh@avalon>
 <20180526082818.70a369b5@vento.lan>
 <7346563.L0Ry6hIlrs@avalon>
 <3755894.Y1GIYirAvc@avalon>
 <20180528071754.2b594656@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180528071754.2b594656@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 07:17:54AM -0300, Mauro Carvalho Chehab wrote:
> This (obviously wrong patch) shut up the warning:
> 
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -248,6 +248,9 @@ static int vsp1_du_pipeline_setup_brx(struct vsp1_device *vsp1,
>         else
>                 brx = &vsp1->brs->entity;
>  
> +       if (pipe->brx == brx)
> +               pipe->brx = &vsp1->brs->entity;
> +
>         /* Switch BRx if needed. */
>         if (brx != pipe->brx) {
>                 struct vsp1_entity *released_brx = NULL;
> 

Just to be clear.  After this patch, Smatch does *NOT* think that
"pipe->brx" is necessarily non-NULL.  What this patch does it that
Smatch says "pipe->brx has been modified on every code path since we
checked for NULL, so forget about the earlier check".

regards,
dan carpenter

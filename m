Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:51967
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752294AbdHHMt4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 08:49:56 -0400
Date: Tue, 8 Aug 2017 14:49:39 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] [media] uvcvideo: constify video_subdev structures
In-Reply-To: <2365094.bHN9TxZSFH@avalon>
Message-ID: <alpine.DEB.2.20.1708081449060.28470@hadrien>
References: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr> <1502189912-28794-7-git-send-email-Julia.Lawall@lip6.fr> <2365094.bHN9TxZSFH@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 8 Aug 2017, Laurent Pinchart wrote:

> Hi Julia,
>
> Thank you for the patch.
>
> On Tuesday 08 Aug 2017 12:58:32 Julia Lawall wrote:
> > uvc_subdev_ops is only passed as the second argument of
> > v4l2_subdev_init, which is const, so uvc_subdev_ops can be
> > const as well.
> >
> > Done with the help of Coccinelle.
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> and applied to my tree (with the first word of the commit message after the
> prefix capitalized to match the rest of the driver's commit messages, let me
> know if that's a problem :-)).

No, of course not.  I will try to watch out for that in the future.

julia

> >
> > ---
> >  drivers/media/usb/uvc/uvc_entity.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_entity.c
> > b/drivers/media/usb/uvc/uvc_entity.c index ac386bb..554063c 100644
> > --- a/drivers/media/usb/uvc/uvc_entity.c
> > +++ b/drivers/media/usb/uvc/uvc_entity.c
> > @@ -61,7 +61,7 @@ static int uvc_mc_create_links(struct uvc_video_chain
> > *chain, return 0;
> >  }
> >
> > -static struct v4l2_subdev_ops uvc_subdev_ops = {
> > +static const struct v4l2_subdev_ops uvc_subdev_ops = {
> >  };
> >
> >  void uvc_mc_cleanup_entity(struct uvc_entity *entity)
>
> --
> Regards,
>
> Laurent Pinchart
>
>

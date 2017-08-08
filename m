Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47265 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbdHHMst (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 08:48:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] [media] uvcvideo: constify video_subdev structures
Date: Tue, 08 Aug 2017 15:49:02 +0300
Message-ID: <2365094.bHN9TxZSFH@avalon>
In-Reply-To: <1502189912-28794-7-git-send-email-Julia.Lawall@lip6.fr>
References: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr> <1502189912-28794-7-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

Thank you for the patch.

On Tuesday 08 Aug 2017 12:58:32 Julia Lawall wrote:
> uvc_subdev_ops is only passed as the second argument of
> v4l2_subdev_init, which is const, so uvc_subdev_ops can be
> const as well.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree (with the first word of the commit message after the 
prefix capitalized to match the rest of the driver's commit messages, let me 
know if that's a problem :-)).
> 
> ---
>  drivers/media/usb/uvc/uvc_entity.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_entity.c
> b/drivers/media/usb/uvc/uvc_entity.c index ac386bb..554063c 100644
> --- a/drivers/media/usb/uvc/uvc_entity.c
> +++ b/drivers/media/usb/uvc/uvc_entity.c
> @@ -61,7 +61,7 @@ static int uvc_mc_create_links(struct uvc_video_chain
> *chain, return 0;
>  }
> 
> -static struct v4l2_subdev_ops uvc_subdev_ops = {
> +static const struct v4l2_subdev_ops uvc_subdev_ops = {
>  };
> 
>  void uvc_mc_cleanup_entity(struct uvc_entity *entity)

-- 
Regards,

Laurent Pinchart

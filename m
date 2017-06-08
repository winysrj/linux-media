Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58691
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751132AbdFHSAa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 14:00:30 -0400
Date: Thu, 8 Jun 2017 15:00:22 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v4] v4l: subdev: tolerate null in
 media_entity_to_v4l2_subdev
Message-ID: <20170608150022.5f696e58@vento.lan>
In-Reply-To: <1496829127-28375-1-git-send-email-kbingham@kernel.org>
References: <1496829127-28375-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  7 Jun 2017 10:52:07 +0100
Kieran Bingham <kbingham@kernel.org> escreveu:

> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Return NULL, if a null entity is parsed for it's v4l2_subdev
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Could you please improve this patch description?

I'm unsure if this is a bug fix, or some sort of feature...

On what situations would a null entity be passed to this function?

Regards,
Mauro

> 
> ---
> Not sure if this patch ever made it out of my mailbox:
> 
> Here's the respin with the parameter evaluated only once.
> 
> v4:
>  - Improve macro usage to evaluate ent only once
> 
>  include/media/v4l2-subdev.h | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index a40760174797..0f92ebd2d710 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -826,8 +826,15 @@ struct v4l2_subdev {
>  	struct v4l2_subdev_platform_data *pdata;
>  };
>  
> -#define media_entity_to_v4l2_subdev(ent) \
> -	container_of(ent, struct v4l2_subdev, entity)
> +#define media_entity_to_v4l2_subdev(ent)				\
> +({									\
> +	typeof(ent) __me_sd_ent = (ent);				\
> +									\
> +	__me_sd_ent ?							\
> +		container_of(__me_sd_ent, struct v4l2_subdev, entity) :	\
> +		NULL;							\
> +})
> +
>  #define vdev_to_v4l2_subdev(vdev) \
>  	((struct v4l2_subdev *)video_get_drvdata(vdev))
>  



Thanks,
Mauro

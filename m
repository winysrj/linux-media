Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34418 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164342AbdD0WuA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 18:50:00 -0400
Received: by mail-lf0-f43.google.com with SMTP id t144so25285431lff.1
        for <linux-media@vger.kernel.org>; Thu, 27 Apr 2017 15:50:00 -0700 (PDT)
Date: Fri, 28 Apr 2017 00:49:57 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH] rcar-vin: Use of_nodes as specified by the subdev
Message-ID: <20170427224957.GA1532@bigcity.dyn.berto.se>
References: <1493132100-31901-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1493132100-31901-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your patch. I took it for a spin on my Koelsch and it worked 
nicely.

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

On 2017-04-25 15:55:00 +0100, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> The rvin_digital_notify_bound() call dereferences the subdev->dev
> pointer to obtain the of_node. On some error paths, this dev node can be
> set as NULL. The of_node is mapped into the subdevice structure on
> initialisation, so this is a safer source to compare the nodes.
> 
> Dereference the of_node from the subdev structure instead of the dev
> structure.
> 
> Fixes: 83fba2c06f19 ("rcar-vin: rework how subdevice is found and
> 	bound")
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 5861ab281150..a530dc388b95 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -469,7 +469,7 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
>  
>  	v4l2_set_subdev_hostdata(subdev, vin);
>  
> -	if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
> +	if (vin->digital.asd.match.of.node == subdev->of_node) {
>  		/* Find surce and sink pad of remote subdevice */
>  
>  		ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund

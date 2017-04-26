Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:40979 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1953170AbdDZHX1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 03:23:27 -0400
Date: Wed, 26 Apr 2017 09:23:20 +0200
From: Simon Horman <horms@verge.net.au>
To: Kieran Bingham <kbingham@kernel.org>
Cc: niklas.soderlund@ragnatech.se, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH] rcar-vin: Use of_nodes as specified by the subdev
Message-ID: <20170426072320.GD25517@verge.net.au>
References: <1493132100-31901-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493132100-31901-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tue, Apr 25, 2017 at 03:55:00PM +0100, Kieran Bingham wrote:
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

I see two different accesses to subdev->dev->of_node in the version of
rcar-core.c in linux-next. So I'm unsure if the following comment makes
sense in the context of the version you are working on. It is that
I wonder if all accesses to subdev->dev->of_node should be updated.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:36624 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752630AbeDZGMu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 02:12:50 -0400
Date: Wed, 25 Apr 2018 09:18:51 +0200
From: Simon Horman <horms@verge.net.au>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-vin: fix null pointer dereference in
 rvin_group_get()
Message-ID: <20180425071851.tcytzfkpofsbkxgm@verge.net.au>
References: <20180424234506.22630-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180424234506.22630-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 01:45:06AM +0200, Niklas Söderlund wrote:
> Store the group pointer before disassociating the VIN from the group.
> 
> Fixes: 3bb4c3bc85bf77a7 ("media: rcar-vin: add group allocator functions")
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 7bc2774a11232362..d3072e166a1ca24f 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -338,19 +338,21 @@ static int rvin_group_get(struct rvin_dev *vin)
>  
>  static void rvin_group_put(struct rvin_dev *vin)
>  {
> -	mutex_lock(&vin->group->lock);
> +	struct rvin_group *group = vin->group;
> +
> +	mutex_lock(&group->lock);

Hi Niklas, its not clear to me why moving the lock is safe.
Could you explain the locking scheme a little?

>  
>  	vin->group = NULL;
>  	vin->v4l2_dev.mdev = NULL;
>  
> -	if (WARN_ON(vin->group->vin[vin->id] != vin))
> +	if (WARN_ON(group->vin[vin->id] != vin))
>  		goto out;
>  
> -	vin->group->vin[vin->id] = NULL;
> +	group->vin[vin->id] = NULL;
>  out:
> -	mutex_unlock(&vin->group->lock);
> +	mutex_unlock(&group->lock);
>  
> -	kref_put(&vin->group->refcount, rvin_group_release);
> +	kref_put(&group->refcount, rvin_group_release);
>  }
>  
>  /* -----------------------------------------------------------------------------
> -- 
> 2.17.0
> 

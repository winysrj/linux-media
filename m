Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:46913 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751021AbdIFHpe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Sep 2017 03:45:34 -0400
Subject: Re: [PATCH v8 10/21] omap3isp: Print the name of the entity where no
 source pads could be found
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-11-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bbc1ae7e-6bb1-6679-b0b0-6d9cefd5ba2b@xs4all.nl>
Date: Wed, 6 Sep 2017 09:45:29 +0200
MIME-Version: 1.0
In-Reply-To: <20170905130553.1332-11-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2017 03:05 PM, Sakari Ailus wrote:
> If no source pads are found in an entity, print the name of the entity.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/omap3isp/isp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 3b1a9cd0e591..9a694924e46e 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1669,8 +1669,8 @@ static int isp_link_entity(
>  			break;
>  	}
>  	if (i == entity->num_pads) {
> -		dev_err(isp->dev, "%s: no source pad in external entity\n",
> -			__func__);
> +		dev_err(isp->dev, "%s: no source pad in external entity %s\n",
> +			__func__, entity->name);
>  		return -EINVAL;
>  	}
>  
> 

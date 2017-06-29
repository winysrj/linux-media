Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:36221 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbdF2IkR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 04:40:17 -0400
Received: by mail-lf0-f41.google.com with SMTP id h22so48529992lfk.3
        for <linux-media@vger.kernel.org>; Thu, 29 Jun 2017 01:40:16 -0700 (PDT)
Date: Thu, 29 Jun 2017 10:40:14 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        hverkuil@xs4all.nl
Subject: Re: [PATCH 1/2] v4l: fwnode: link_frequency is an optional property
Message-ID: <20170629084014.GN30481@bigcity.dyn.berto.se>
References: <1498721410-28199-1-git-send-email-sakari.ailus@linux.intel.com>
 <1498721410-28199-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1498721410-28199-2-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your patch.

On 2017-06-29 10:30:09 +0300, Sakari Ailus wrote:
> v4l2_fwnode_endpoint_alloc_parse() is intended as a replacement for
> v4l2_fwnode_endpoint_parse(). It parses the "link-frequency" property and
> if the property isn't found, it returns an error. However,
> "link-frequency" is an optional property and if it does not exist is not
> an error. Instead, the number of link frequencies is simply zero in that
> case.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 153c53c..0ec6c14 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -247,23 +247,23 @@ struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
>  
>  	rval = fwnode_property_read_u64_array(fwnode, "link-frequencies",
>  					      NULL, 0);
> -	if (rval < 0)
> -		goto out_err;
> -
> -	vep->link_frequencies =
> -		kmalloc_array(rval, sizeof(*vep->link_frequencies), GFP_KERNEL);
> -	if (!vep->link_frequencies) {
> -		rval = -ENOMEM;
> -		goto out_err;
> -	}
> +	if (rval > 0) {
> +		vep->link_frequencies =
> +			kmalloc_array(rval, sizeof(*vep->link_frequencies),
> +				      GFP_KERNEL);
> +		if (!vep->link_frequencies) {
> +			rval = -ENOMEM;
> +			goto out_err;
> +		}
>  
> -	vep->nr_of_link_frequencies = rval;
> +		vep->nr_of_link_frequencies = rval;
>  
> -	rval = fwnode_property_read_u64_array(fwnode, "link-frequencies",
> -					      vep->link_frequencies,
> -					      vep->nr_of_link_frequencies);
> -	if (rval < 0)
> -		goto out_err;
> +		rval = fwnode_property_read_u64_array(
> +			fwnode, "link-frequencies", vep->link_frequencies,
> +			vep->nr_of_link_frequencies);
> +		if (rval < 0)
> +			goto out_err;
> +	}
>  
>  	return vep;
>  
> -- 
> 2.1.4
> 
> 

-- 
Regards,
Niklas Söderlund

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36041 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdL2NYG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 08:24:06 -0500
Received: by mail-lf0-f68.google.com with SMTP id c19so28241334lfg.3
        for <linux-media@vger.kernel.org>; Fri, 29 Dec 2017 05:24:06 -0800 (PST)
Date: Fri, 29 Dec 2017 14:24:03 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 1/1] v4l: fwnode: Use fwnode_graph_for_each_endpoint
Message-ID: <20171229132403.GE15612@bigcity.dyn.berto.se>
References: <20171221124546.31028-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171221124546.31028-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your patch.

On 2017-12-21 14:45:46 +0200, Sakari Ailus wrote:
> Use fwnode_graph_for_each_endpoint iterator for better readability.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 3cc8b6b69b41..c33d519281a2 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -472,8 +472,7 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
>  	if (WARN_ON(asd_struct_size < sizeof(struct v4l2_async_subdev)))
>  		return -EINVAL;
>  
> -	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
> -				     dev_fwnode(dev), fwnode)); ) {
> +	fwnode_graph_for_each_endpoint(dev_fwnode(dev), fwnode) {
>  		struct fwnode_handle *dev_fwnode;
>  		bool is_available;
>  
> -- 
> 2.11.0
> 
> 

-- 
Regards,
Niklas Söderlund

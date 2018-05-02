Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38154 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbeEBL0e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2018 07:26:34 -0400
Date: Wed, 2 May 2018 14:26:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][media-next] media: davinci_vpfe: fix memory leaks of
 params
Message-ID: <20180502112615.rsx43yoqiiz54dra@mwanda>
References: <20180502091658.17110-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502091658.17110-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 02, 2018 at 10:16:58AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are memory leaks of params; when copy_to_user fails and also
> the exit via the label 'error'.  Fix this by kfree'ing params in
> error exit path and jumping to this on the copy_to_user failure path.
> 
> Detected by CoverityScan, CID#1467966 ("Resource leak")
> 
> Fixes: da43b6ccadcf ("[media] davinci: vpfe: dm365: add IPIPE support for media controller driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> index 95942768639c..3e67ee6e92f9 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> @@ -1252,12 +1252,12 @@ static const struct ipipe_module_if ipipe_modules[VPFE_IPIPE_MAX_MODULES] = {
>  static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
>  {
>  	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
> +	struct ipipe_module_params *params;
>  	unsigned int i;
>  	int rval = 0;
>  
>  	for (i = 0; i < ARRAY_SIZE(ipipe_modules); i++) {
>  		const struct ipipe_module_if *module_if;
> -		struct ipipe_module_params *params;
>  		void *from, *to;
>  		size_t size;
>  
> @@ -1275,7 +1275,7 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
>  		if (to && from && size) {
                    ^^

This "to" check is wrong.  Say "params" is NULL and
module_if->param_offset is non-zero then "to" is a bogus pointer.  We
should just test "params" and give up the first time an allocation
fails.

>  			if (copy_from_user(to, (void __user *)from, size)) {
>  				rval = -EFAULT;
> -				break;
> +				goto error;
>  			}
>  			rval = module_if->set(ipipe, to);
>  			if (rval)
> @@ -1287,7 +1287,9 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
>  		}
>  		kfree(params);
>  	}
> +	return rval;

Doing a "return 0;" is more readable than "return rval;".

regards,
dan carpenter

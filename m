Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2427 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3DKSYX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 14:24:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: Re: [patch] [media] radio-si476x: check different function pointers
Date: Thu, 11 Apr 2013 20:24:06 +0200
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20130410114051.GA21419@longonot.mountain>
In-Reply-To: <20130410114051.GA21419@longonot.mountain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304112024.06542.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed April 10 2013 13:40:51 Dan Carpenter wrote:
> This is a static checker where it complains if we check for one function
> pointer and then call a different function on the next line.
> 
> In most cases, the code does the same thing before and after this patch.
> For example, when ->phase_diversity is non-NULL then ->phase_div_status
> is also non-NULL.
> 
> The one place where that's not true is when we check ->rds_blckcnt
> instead of ->rsq_status.  In those cases, we would want to call
> ->rsq_status but we instead return -ENOENT.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Please review this carefully.  I don't have the hardware to test it.

Andrey, can you review this? I think the first two chunks are correct, but
the last two chunks are probably not what you want. In the case of an AM
receiver there is no RDS data, so an error is probably correct.

Regards,

	Hans

> 
> diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
> index 9430c6a..817fc0c 100644
> --- a/drivers/media/radio/radio-si476x.c
> +++ b/drivers/media/radio/radio-si476x.c
> @@ -854,7 +854,7 @@ static int si476x_radio_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>  	switch (ctrl->id) {
>  	case V4L2_CID_SI476X_INTERCHIP_LINK:
>  		if (si476x_core_has_diversity(radio->core)) {
> -			if (radio->ops->phase_diversity) {
> +			if (radio->ops->phase_div_status) {
>  				retval = radio->ops->phase_div_status(radio->core);
>  				if (retval < 0)
>  					break;
> @@ -1285,7 +1285,7 @@ static ssize_t si476x_radio_read_agc_blob(struct file *file,
>  	struct si476x_agc_status_report report;
>  
>  	si476x_core_lock(radio->core);
> -	if (radio->ops->rds_blckcnt)
> +	if (radio->ops->agc_status)
>  		err = radio->ops->agc_status(ZZradio->core, &report);
>  	else
>  		err = -ENOENT;
> @@ -1320,7 +1320,7 @@ static ssize_t si476x_radio_read_rsq_blob(struct file *file,
>  	};
>  
>  	si476x_core_lock(radio->core);
> -	if (radio->ops->rds_blckcnt)
> +	if (radio->ops->rsq_status)
>  		err = radio->ops->rsq_status(radio->core, &args, &report);
>  	else
>  		err = -ENOENT;
> @@ -1355,7 +1355,7 @@ static ssize_t si476x_radio_read_rsq_primary_blob(struct file *file,
>  	};
>  
>  	si476x_core_lock(radio->core);
> -	if (radio->ops->rds_blckcnt)
> +	if (radio->ops->rsq_status)
>  		err = radio->ops->rsq_status(radio->core, &args, &report);
>  	else
>  		err = -ENOENT;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

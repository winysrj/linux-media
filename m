Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelv0142.ext.ti.com ([198.47.23.249]:35998 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbeIPVHJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Sep 2018 17:07:09 -0400
Date: Sun, 16 Sep 2018 10:43:38 -0500
From: Benoit Parrot <bparrot@ti.com>
To: zhong jiang <zhongjiang@huawei.com>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: platform: remove redundant null pointer check
 before of_node_put
Message-ID: <20180916154338.GE17511@ti.com>
References: <1537103811-63670-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1537103811-63670-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zhong,

Thank you for the patch.

zhong jiang <zhongjiang@huawei.com> wrote on Sun [2018-Sep-16 21:16:51 +0800]:
> of_node_put has taken the null pinter check into account. So it is

s/pinter/pointer/

> safe to remove the duplicated check before of_node_put.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

with the above change,

Reviewed-by: Benoit Parrot <bparrot@ti.com>

> ---
>  drivers/media/platform/ti-vpe/cal.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index cc052b2..5f9d4e0 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -1747,14 +1747,10 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  	}
>  
>  cleanup_exit:
> -	if (remote_ep)
> -		of_node_put(remote_ep);
> -	if (sensor_node)
> -		of_node_put(sensor_node);
> -	if (ep_node)
> -		of_node_put(ep_node);
> -	if (port)
> -		of_node_put(port);
> +	of_node_put(remote_ep);
> +	of_node_put(sensor_node);
> +	of_node_put(ep_node);
> +	of_node_put(port);
>  
>  	return ret;
>  }
> -- 
> 1.7.12.4
> 

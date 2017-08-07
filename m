Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:39789 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751516AbdHGG5u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 02:57:50 -0400
Subject: Re: [PATCH][resend] media: ti-vpe: cal: use
 of_graph_get_remote_endpoint()
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <871soojfl3.wl%kuninori.morimoto.gx@renesas.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <44f9257e-b489-996e-2167-47343a0f62c9@xs4all.nl>
Date: Mon, 7 Aug 2017 08:57:47 +0200
MIME-Version: 1.0
In-Reply-To: <871soojfl3.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/17 04:13, Kuninori Morimoto wrote:
> 
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Now, we can use of_graph_get_remote_endpoint(). Let's use it.

I'm not sure why this is resent. It's part of a pending pull request
so I expect it to be merged this week.

Regards,

	Hans

> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
>  drivers/media/platform/ti-vpe/cal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index 177faa3..0c7ddf8 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -1702,7 +1702,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
>  	asd->match.fwnode.fwnode = of_fwnode_handle(sensor_node);
>  
> -	remote_ep = of_parse_phandle(ep_node, "remote-endpoint", 0);
> +	remote_ep = of_graph_get_remote_endpoint(ep_node);
>  	if (!remote_ep) {
>  		ctx_dbg(3, ctx, "can't get remote-endpoint\n");
>  		goto cleanup_exit;
> 

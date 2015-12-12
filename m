Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39261 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbbLLPWU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 10:22:20 -0500
Date: Sat, 12 Dec 2015 13:22:15 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: Re: [PATCH v2 11/22] v4l: xilinx: Use the new
 media_entity_graph_walk_start() interface
Message-ID: <20151212132215.6a11d723@recife.lan>
In-Reply-To: <1448824823-10372-12-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
	<1448824823-10372-12-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 29 Nov 2015 21:20:12 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

description is missing. Patch looks ok, except for that.

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hyun Kwon <hyun.kwon@xilinx.com>
> ---
>  drivers/media/platform/xilinx/xilinx-dma.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index bc244a0..0a19824 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -182,10 +182,17 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
>  	struct media_device *mdev = entity->graph_obj.mdev;
>  	unsigned int num_inputs = 0;
>  	unsigned int num_outputs = 0;
> +	int ret;
>  
>  	mutex_lock(&mdev->graph_mutex);
>  
>  	/* Walk the graph to locate the video nodes. */
> +	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
> +	if (ret) {
> +		mutex_unlock(&mdev->graph_mutex);
> +		return ret;
> +	}
> +
>  	media_entity_graph_walk_start(&graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
> @@ -206,6 +213,8 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
>  
>  	mutex_unlock(&mdev->graph_mutex);
>  
> +	media_entity_graph_walk_cleanup(&graph);
> +
>  	/* We need exactly one output and zero or one input. */
>  	if (num_outputs != 1 || num_inputs > 1)
>  		return -EPIPE;

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39272 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbbLLPYa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 10:24:30 -0500
Date: Sat, 12 Dec 2015 13:24:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: Re: [PATCH v2 12/22] v4l: vsp1: Use the new
 media_entity_graph_walk_start() interface
Message-ID: <20151212132425.6a16917f@recife.lan>
In-Reply-To: <1448824823-10372-13-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
	<1448824823-10372-13-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 29 Nov 2015 21:20:13 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

Same as the other similar patches: description is missing.

I would prefer if you could merge those patches that do the same
thing on different drivers. Less emails to write ;)

Won't be replying anymore to patches that are ok but misses
descriptions.

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/vsp1/vsp1_video.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index f741582..ce10d86 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -415,6 +415,12 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
>  	mutex_lock(&mdev->graph_mutex);
>  
>  	/* Walk the graph to locate the entities and video nodes. */
> +	ret = media_entity_graph_walk_init(&graph, mdev);
> +	if (ret) {
> +		mutex_unlock(&mdev->graph_mutex);
> +		return ret;
> +	}
> +
>  	media_entity_graph_walk_start(&graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
> @@ -448,6 +454,8 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
>  
>  	mutex_unlock(&mdev->graph_mutex);
>  
> +	media_entity_graph_walk_cleanup(&graph);
> +
>  	/* We need one output and at least one input. */
>  	if (pipe->num_inputs == 0 || !pipe->output) {
>  		ret = -EPIPE;

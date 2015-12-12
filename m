Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39230 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbbLLPPs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 10:15:48 -0500
Date: Sat, 12 Dec 2015 13:15:42 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: Re: [PATCH v2 05/22] media: Add KernelDoc documentation for struct
 media_entity_graph
Message-ID: <20151212131542.7d09890e@recife.lan>
In-Reply-To: <1448824823-10372-6-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
	<1448824823-10372-6-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 29 Nov 2015 21:20:06 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/media/media-entity.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 2601bb0..8fd888f 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -95,6 +95,14 @@ struct media_entity_enum {
>  	int idx_max;
>  };
>  
> +/*
> + * struct media_entity_graph - Media graph traversal state
> + *
> + * @stack.entity:	Media entity in the stack
> + * @stack.link:		Link through which the entity was reached
> + * @entities:		Visited entities

The above is ok, but I guess you could get something better at the
documentation, for example using, instead:
	@stack.@entity

This requires some testing with ./scripts/kernel-doc, though.

> + * @top:		The top of the stack
> + */
>  struct media_entity_graph {
>  	struct {
>  		struct media_entity *entity;

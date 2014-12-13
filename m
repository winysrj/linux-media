Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59721 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965152AbaLMMIT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 07:08:19 -0500
Date: Sat, 13 Dec 2014 14:08:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 05/10] media-entity: fix sparse warnings
Message-ID: <20141213120813.GB17565@valkosipuli.retiisi.org.uk>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
 <1418471580-26510-6-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418471580-26510-6-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Dec 13, 2014 at 12:52:55PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> drivers/media/media-entity.c:238:17: warning: Variable length array is used.
> drivers/media/media-entity.c:239:17: warning: Variable length array is used.
> 
> Replace variable length by MEDIA_ENTITY_ENUM_MAX_ID.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/media-entity.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 4d8e01c..dcf322b 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -235,8 +235,8 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  	media_entity_graph_walk_start(&graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
> -		DECLARE_BITMAP(active, entity->num_pads);
> -		DECLARE_BITMAP(has_no_links, entity->num_pads);
> +		DECLARE_BITMAP(active, MEDIA_ENTITY_ENUM_MAX_ID);
> +		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_ENUM_MAX_ID);
>  		unsigned int i;
>  
>  		entity->stream_count++;

NAK.

MEDIA_ENTITY_ENUM_MAX_ID is the number of *entities* the graph parsing code
can handle, whereas the bitmap has to be large enough for the *pads* in an
entity.

There is no guarantee that the number of pads would be less than
MEDIA_ENTITY_ENUM_MAX_ID, which could lead to memory corruption. Also
MEDIA_ENTITY_ENUM_MAX_ID is probably about ten times as large as there
usually are pads.

What's wrong with using variable length arrays in general? Of course, there
needs to be a guarantee that the length is decently small, which is the case
in here.

We could define an upper limit for the number of pads, and check that the
number of pads actually is not greater than this.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

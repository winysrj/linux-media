Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50132 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751348AbbL1Abj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2015 19:31:39 -0500
Date: Mon, 28 Dec 2015 02:31:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] [media] media: move MEDIA_LNK_FL_INTERFACE_LINK
 logic to link creation
Message-ID: <20151228003132.GV17128@valkosipuli.retiisi.org.uk>
References: <1cb01ccf2694e93040738f4dd12a86bcf8ce4994.1449865071.git.mchehab@osg.samsung.com>
 <8b0b503ba0b1246fab5519df7fe675c78989e4e9.1449865071.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b0b503ba0b1246fab5519df7fe675c78989e4e9.1449865071.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

(Resending, there was an error in handling the cc field.)

On Fri, Dec 11, 2015 at 06:17:53PM -0200, Mauro Carvalho Chehab wrote:
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 181ca0de6e52..7895e17aeee9 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -526,7 +526,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
>  
>  	link->source = &source->pads[source_pad];
>  	link->sink = &sink->pads[sink_pad];
> -	link->flags = flags;
> +	link->flags = flags && ~MEDIA_LNK_FL_INTERFACE_LINK;

s/&&/&/

>  
>  	/* Initialize graph object embedded at the new link */
>  	media_gobj_create(source->graph_obj.mdev, MEDIA_GRAPH_LINK,
> @@ -756,7 +756,7 @@ struct media_link *media_create_intf_link(struct media_entity *entity,
>  
>  	link->intf = intf;
>  	link->entity = entity;
> -	link->flags = flags;
> +	link->flags = flags | MEDIA_LNK_FL_INTERFACE_LINK;
>  
>  	/* Initialize graph object embedded at the new link */
>  	media_gobj_create(intf->graph_obj.mdev, MEDIA_GRAPH_LINK,

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

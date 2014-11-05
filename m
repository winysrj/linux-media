Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51202 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751500AbaKEN7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 08:59:52 -0500
Date: Wed, 5 Nov 2014 15:52:41 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: Re: [PATCH v2 01/13] media: entity: Document the media_entity_ops
 structure
Message-ID: <20141105135241.GQ3136@valkosipuli.retiisi.org.uk>
References: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1414940018-3016-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414940018-3016-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 02, 2014 at 04:53:26PM +0200, Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/media/media-entity.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index e004591..786906b 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -44,6 +44,15 @@ struct media_pad {
>  	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
>  };
>  
> +/**
> + * struct media_entity_operations - Media entity operations
> + * @link_setup:		Notify the entity of link changes. The operation can
> + *			return an error, in which case link setup will be
> + *			cancelled. Optional.
> + * @link_validate:	Return whether a link is valid from the entity point of
> + *			view. The media_entity_pipeline_start() function
> + *			validates all links by calling this operation. Optional.
> + */
>  struct media_entity_operations {
>  	int (*link_setup)(struct media_entity *entity,
>  			  const struct media_pad *local,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50104 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1422947AbdD1KdA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 06:33:00 -0400
Date: Fri, 28 Apr 2017 13:32:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/2] media: entity: Add pad_from_dt_regs entity operation
Message-ID: <20170428103256.GG7456@valkosipuli.retiisi.org.uk>
References: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427223323.13861-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170427223323.13861-2-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Fri, Apr 28, 2017 at 12:33:22AM +0200, Niklas Söderlund wrote:
> The optional operation can be used by entities to report how it maps its
> DT node ports and endpoints to media pad numbers. This is useful for
> devices which require more advanced mappings of pads then DT port
> number is equivalent with media port number.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  include/media/media-entity.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index c7c254c5bca1761b..47efaf4d825e671b 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -171,6 +171,9 @@ struct media_pad {
>  
>  /**
>   * struct media_entity_operations - Media entity operations
> + * @pad_from_dt_regs:	Return the pad number based on DT port and reg
> + *			properties. This operation can be used to map a
> + *			DT port and reg to a media pad number. Optional.

Don't you need to provide entity as an argument as well? The driver will be
a little bit loss due to lack of context. :-)

How about using the endpoint's device node (or fwnode; you can get it using
of_fwnode_handle() soon) instead? You can always obtain the port node by
just getting the parent.

>   * @link_setup:		Notify the entity of link changes. The operation can
>   *			return an error, in which case link setup will be
>   *			cancelled. Optional.
> @@ -184,6 +187,7 @@ struct media_pad {
>   *    mutex held.
>   */
>  struct media_entity_operations {
> +	int (*pad_from_dt_regs)(int port_reg, int reg, unsigned int *pad);
>  	int (*link_setup)(struct media_entity *entity,
>  			  const struct media_pad *local,
>  			  const struct media_pad *remote, u32 flags);

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

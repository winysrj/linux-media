Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46372 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbbHNPPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 11:15:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Harry Wei <harryxiyou@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Ricardo Ribald a Delgado <ricardo.ribalda@gmail.com>,
	Axel Lin <axel.lin@ingics.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Bryan Wu <cooloney@gmail.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	anuvazhayil <anuv.1994@gmail.com>,
	Mahati Chamarthy <mahati.chamarthy@gmail.com>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	linux-doc@vger.kernel.org, linux-kernel@zh-kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH v4 1/6] media: get rid of unused "extra_links" param on media_entity_init()
Date: Fri, 14 Aug 2015 18:16:49 +0300
Message-ID: <3975256.nCAQDV8Exf@avalon>
In-Reply-To: <b0b576e0bfcc043b4fdab3a57665b525fc054add.1439563682.git.mchehab@osg.samsung.com>
References: <cover.1439563682.git.mchehab@osg.samsung.com> <b0b576e0bfcc043b4fdab3a57665b525fc054add.1439563682.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Friday 14 August 2015 11:56:38 Mauro Carvalho Chehab wrote:
> Currently, media_entity_init() creates an array with the links,
> allocated at init time. It provides a parameter (extra_links)
> that would allocate more links than the current needs, but this
> is not used by any driver.
> 
> As we want to be able to do dynamic link allocation/removal,
> we'll need to change the implementation of the links. So,
> before doing that, let's first remove that extra unused
> parameter, in order to cleanup the interface first.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> diff --git a/Documentation/media-framework.txt
> b/Documentation/media-framework.txt index f552a75c0e70..2cc6019f7147 100644
> --- a/Documentation/media-framework.txt
> +++ b/Documentation/media-framework.txt
> @@ -104,7 +104,7 @@ although drivers can allocate entities directly.
>  Drivers initialize entities by calling
> 
>  	media_entity_init(struct media_entity *entity, u16 num_pads,
> -			  struct media_pad *pads, u16 extra_links);
> +			  struct media_pad *pads);
> 
>  The media_entity name, type, flags, revision and group_id fields can be
>  initialized before or after calling media_entity_init. Entities embedded in

The extra_links parameter is documented later on in this file. Could you 
replace the paragraph

"Unlike the number of pads, the total number of links isn't always known in
advance by the entity driver. As an initial estimate, media_entity_init
pre-allocates a number of links equal to the number of pads plus an optional
number of extra links. The links array will be reallocated if it grows beyond
the initial estimate."

with

"Unlike the number of pads, the total number of links isn't always known in
advance by the entity driver. As an initial estimate, media_entity_init
pre-allocates a number of links equal to the number of pads. The links array 
will be reallocated if it grows beyond the initial estimate."

?

[snip]

> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 4d8e01c7b1b2..78440c7aad94 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -30,7 +30,6 @@
>   * media_entity_init - Initialize a media entity
>   *
>   * @num_pads: Total number of sink and source pads.
> - * @extra_links: Initial estimate of the number of extra links.
>   * @pads: Array of 'num_pads' pads.
>   *
>   * The total number of pads is an intrinsic property of entities known by
> the

Similarly here, I would rewrite the documentation as

 * The total number of pads is an intrinsic property of entities known by the
 * entity driver, while the total number of links depends on hardware design
 * and is an extrinsic property unknown to the entity driver. However, in most
 * use cases the number of links can safely be assumed to be equal to or
 * larger than the number of pads.
 *
 * For those reasons the links array can be preallocated based on the number
 * of pads and will be reallocated later if extra links need to be created.
 *
 * This function allocates a links array with enough space to hold at least
 * 'num_pads' elements. The media_entity::max_links field will be set to the
 * number of allocated elements.

With that fixed,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

And feel free to merge this patch for v4.3 independently of the rest.

> @@ -52,10 +51,10 @@
>   */
>  int
>  media_entity_init(struct media_entity *entity, u16 num_pads,
> -		  struct media_pad *pads, u16 extra_links)
> +		  struct media_pad *pads)
>  {
>  	struct media_link *links;
> -	unsigned int max_links = num_pads + extra_links;
> +	unsigned int max_links = num_pads;
>  	unsigned int i;
> 
>  	links = kzalloc(max_links * sizeof(links[0]), GFP_KERNEL);

-- 
Regards,

Laurent Pinchart


Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34578 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933981Ab3FSKf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 06:35:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC v3 1/3] media: added managed media entity initialization
Date: Wed, 19 Jun 2013 12:36:09 +0200
Message-ID: <3699560.VO8nIerPms@avalon>
In-Reply-To: <51C188E7.4020208@samsung.com>
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com> <2229025.9VJ8P9QgzO@avalon> <51C188E7.4020208@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On Wednesday 19 June 2013 12:33:11 Andrzej Hajda wrote:
> On 06/19/2013 12:03 AM, Laurent Pinchart wrote:
> > On Thursday 16 May 2013 10:14:32 Andrzej Hajda wrote:
> >> This patch adds managed versions of initialization
> >> function for media entity.
> >> 
> >> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> 
> >> v3:
> >> 	- removed managed cleanup
> >> 
> >> ---
> >> 
> >>  drivers/media/media-entity.c |   44 ++++++++++++++++++++++++++++++++++++
> >>  include/media/media-entity.h |    5 +++++
> >>  2 files changed, 49 insertions(+)
> >> 
> >> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> >> index e1cd132..b1e29a7 100644
> >> --- a/drivers/media/media-entity.c
> >> +++ b/drivers/media/media-entity.c
> >> @@ -82,9 +82,53 @@ void
> >>  media_entity_cleanup(struct media_entity *entity)
> >>  {
> >>  	kfree(entity->links);
> >> +	entity->links = NULL;
> >>  }
> >>  EXPORT_SYMBOL_GPL(media_entity_cleanup);
> >> 
> >> +static void devm_media_entity_release(struct device *dev, void *res)
> >> +{
> >> +	struct media_entity **entity = res;
> >> +
> >> +	media_entity_cleanup(*entity);
> >> +}
> >> +
> >> +/**
> >> + * devm_media_entity_init - managed media entity initialization
> >> + *
> >> + * @dev: Device for which @entity belongs to.
> >> + * @entity: Entity to be initialized.
> >> + * @num_pads: Total number of sink and source pads.
> >> + * @pads: Array of 'num_pads' pads.
> >> + * @extra_links: Initial estimate of the number of extra links.
> >> + *
> >> + * This is a managed version of media_entity_init. Entity initialized
> >> with
> >> + * this function will be automatically cleaned up on driver detach.
> >> + */
> >> +int
> >> +devm_media_entity_init(struct device *dev, struct media_entity *entity,
> >> +		       u16 num_pads, struct media_pad *pads, u16 extra_links)
> > 
> > What kind of users do you see for this function ? Aren't subdev drivers
> > supposed to use the devm_* functions from patch 3/3 instead ? We should at
> > least make it clear in the documentation that drivers must not use both
> > devm_media_entity_init() and devm_v4l2_subdev_i2c_init().
> 
> It can be used for media entities which are not part of subdev.
> I will add statement about it.
> Besides subdev, for now only video_device uses media entity.
> I am not 100% sure about advantages of adding devm_media_entity_init -
> currently only 7 drivers in kernel uses video_device and
> media_entity_cleanup in those drivers is called not as straightforward
> as in subdevs.
> Replacing it with managed version would require deeper analysis :)

Thank you fhr the explanation. Maybe we should then delay introducing 
devm_media_entity_init until needed ?

-- 
Regards,

Laurent Pinchart


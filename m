Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54337 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754907AbaKYLhB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 06:37:01 -0500
Date: Tue, 25 Nov 2014 13:36:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hans.verkuil@cisco.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v4 01/11] mediactl: Introduce v4l2_subdev structure
Message-ID: <20141125113655.GK8907@valkosipuli.retiisi.org.uk>
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
 <1416586480-19982-2-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416586480-19982-2-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

Thank you for the updated patchset.

On Fri, Nov 21, 2014 at 05:14:30PM +0100, Jacek Anaszewski wrote:
> Add struct v4l2_subdev as a representation of the v4l2 sub-device
> related to a media entity. Add sd property, the pointer to
> the newly introduced structure, to the struct media_entity
> and move fd property to it.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  utils/media-ctl/libmediactl.c   |   30 +++++++++++++++++++++++++-----
>  utils/media-ctl/libv4l2subdev.c |   34 +++++++++++++++++-----------------
>  utils/media-ctl/mediactl-priv.h |    5 +++++
>  utils/media-ctl/mediactl.h      |   22 ++++++++++++++++++++++
>  4 files changed, 69 insertions(+), 22 deletions(-)
> 
> diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
> index ec360bd..53921f5 100644
> --- a/utils/media-ctl/libmediactl.c
> +++ b/utils/media-ctl/libmediactl.c
> @@ -511,7 +511,6 @@ static int media_enum_entities(struct media_device *media)
>  
>  		entity = &media->entities[media->entities_count];
>  		memset(entity, 0, sizeof(*entity));
> -		entity->fd = -1;

I think I'd definitely leave the fd to the media_entity itself. Not all the
entities are sub-devices, even right now.

>  		entity->info.id = id | MEDIA_ENT_ID_FLAG_NEXT;
>  		entity->media = media;
>  
> @@ -529,11 +528,13 @@ static int media_enum_entities(struct media_device *media)
>  
>  		entity->pads = malloc(entity->info.pads * sizeof(*entity->pads));
>  		entity->links = malloc(entity->max_links * sizeof(*entity->links));
> -		if (entity->pads == NULL || entity->links == NULL) {
> +		entity->sd = calloc(1, sizeof(*entity->sd));
> +		if (entity->pads == NULL || entity->links == NULL || entity->sd == NULL) {
>  			ret = -ENOMEM;
>  			break;
>  		}
>  
> +		entity->sd->fd = -1;
>  		media->entities_count++;
>  
>  		if (entity->info.flags & MEDIA_ENT_FL_DEFAULT) {
> @@ -704,8 +705,9 @@ void media_device_unref(struct media_device *media)
>  
>  		free(entity->pads);
>  		free(entity->links);
> -		if (entity->fd != -1)
> -			close(entity->fd);
> +		if (entity->sd->fd != -1)
> +			close(entity->sd->fd);
> +		free(entity->sd);
>  	}
>  
>  	free(media->entities);
> @@ -726,13 +728,17 @@ int media_device_add_entity(struct media_device *media,
>  	if (entity == NULL)
>  		return -ENOMEM;
>  
> +	entity->sd = calloc(1, sizeof(*entity->sd));
> +	if (entity->sd == NULL)
> +		return -ENOMEM;
> +
>  	media->entities = entity;
>  	media->entities_count++;
>  
>  	entity = &media->entities[media->entities_count - 1];
>  	memset(entity, 0, sizeof *entity);
>  
> -	entity->fd = -1;
> +	entity->sd->fd = -1;
>  	entity->media = media;
>  	strncpy(entity->devname, devnode, sizeof entity->devname);
>  	entity->devname[sizeof entity->devname - 1] = '\0';
> @@ -955,3 +961,17 @@ int media_parse_setup_links(struct media_device *media, const char *p)
>  
>  	return *end ? -EINVAL : 0;
>  }
> +
> +/* -----------------------------------------------------------------------------
> + * Media entity access
> + */
> +
> +int media_entity_get_fd(struct media_entity *entity)
> +{
> +	return entity->sd->fd;
> +}
> +
> +void media_entity_set_fd(struct media_entity *entity, int fd)
> +{
> +	entity->sd->fd = fd;
> +}

You access the fd directly now inside the library. I don't think there
should be a need to set it.

> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index 8015330..09e0081 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -41,11 +41,11 @@
>  
>  int v4l2_subdev_open(struct media_entity *entity)
>  {
> -	if (entity->fd != -1)
> +	if (entity->sd->fd != -1)
>  		return 0;
>  
> -	entity->fd = open(entity->devname, O_RDWR);
> -	if (entity->fd == -1) {
> +	entity->sd->fd = open(entity->devname, O_RDWR);
> +	if (entity->sd->fd == -1) {
>  		int ret = -errno;
>  		media_dbg(entity->media,
>  			  "%s: Failed to open subdev device node %s\n", __func__,
> @@ -58,8 +58,8 @@ int v4l2_subdev_open(struct media_entity *entity)
>  
>  void v4l2_subdev_close(struct media_entity *entity)
>  {
> -	close(entity->fd);
> -	entity->fd = -1;
> +	close(entity->sd->fd);
> +	entity->sd->fd = -1;
>  }
>  
>  int v4l2_subdev_get_format(struct media_entity *entity,
> @@ -77,7 +77,7 @@ int v4l2_subdev_get_format(struct media_entity *entity,
>  	fmt.pad = pad;
>  	fmt.which = which;
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FMT, &fmt);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_FMT, &fmt);
>  	if (ret < 0)
>  		return -errno;
>  
> @@ -101,7 +101,7 @@ int v4l2_subdev_set_format(struct media_entity *entity,
>  	fmt.which = which;
>  	fmt.format = *format;
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FMT, &fmt);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_FMT, &fmt);
>  	if (ret < 0)
>  		return -errno;
>  
> @@ -128,7 +128,7 @@ int v4l2_subdev_get_selection(struct media_entity *entity,
>  	u.sel.target = target;
>  	u.sel.which = which;
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_SELECTION, &u.sel);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_SELECTION, &u.sel);
>  	if (ret >= 0) {
>  		*rect = u.sel.r;
>  		return 0;
> @@ -140,7 +140,7 @@ int v4l2_subdev_get_selection(struct media_entity *entity,
>  	u.crop.pad = pad;
>  	u.crop.which = which;
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_CROP, &u.crop);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_CROP, &u.crop);
>  	if (ret < 0)
>  		return -errno;
>  
> @@ -168,7 +168,7 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
>  	u.sel.which = which;
>  	u.sel.r = *rect;
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_SELECTION, &u.sel);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_SELECTION, &u.sel);
>  	if (ret >= 0) {
>  		*rect = u.sel.r;
>  		return 0;
> @@ -181,7 +181,7 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
>  	u.crop.which = which;
>  	u.crop.rect = *rect;
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_CROP, &u.crop);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_CROP, &u.crop);
>  	if (ret < 0)
>  		return -errno;
>  
> @@ -202,7 +202,7 @@ int v4l2_subdev_get_dv_timings_caps(struct media_entity *entity,
>  	memset(caps, 0, sizeof(*caps));
>  	caps->pad = pad;
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_DV_TIMINGS_CAP, caps);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_DV_TIMINGS_CAP, caps);
>  	if (ret < 0)
>  		return -errno;
>  
> @@ -220,7 +220,7 @@ int v4l2_subdev_query_dv_timings(struct media_entity *entity,
>  
>  	memset(timings, 0, sizeof(*timings));
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_QUERY_DV_TIMINGS, timings);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_QUERY_DV_TIMINGS, timings);
>  	if (ret < 0)
>  		return -errno;
>  
> @@ -238,7 +238,7 @@ int v4l2_subdev_get_dv_timings(struct media_entity *entity,
>  
>  	memset(timings, 0, sizeof(*timings));
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_DV_TIMINGS, timings);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_DV_TIMINGS, timings);
>  	if (ret < 0)
>  		return -errno;
>  
> @@ -254,7 +254,7 @@ int v4l2_subdev_set_dv_timings(struct media_entity *entity,
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_DV_TIMINGS, timings);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_DV_TIMINGS, timings);
>  	if (ret < 0)
>  		return -errno;
>  
> @@ -273,7 +273,7 @@ int v4l2_subdev_get_frame_interval(struct media_entity *entity,
>  
>  	memset(&ival, 0, sizeof(ival));
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, &ival);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, &ival);
>  	if (ret < 0)
>  		return -errno;
>  
> @@ -294,7 +294,7 @@ int v4l2_subdev_set_frame_interval(struct media_entity *entity,
>  	memset(&ival, 0, sizeof(ival));
>  	ival.interval = *interval;
>  
> -	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, &ival);
> +	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, &ival);
>  	if (ret < 0)
>  		return -errno;
>  
> diff --git a/utils/media-ctl/mediactl-priv.h b/utils/media-ctl/mediactl-priv.h
> index a0d3a55..4bcb1e0 100644
> --- a/utils/media-ctl/mediactl-priv.h
> +++ b/utils/media-ctl/mediactl-priv.h
> @@ -34,7 +34,12 @@ struct media_entity {
>  	unsigned int max_links;
>  	unsigned int num_links;
>  
> +	struct v4l2_subdev *sd;
> +
>  	char devname[32];
> +};
> +
> +struct v4l2_subdev {
>  	int fd;

struct v4l2_subdev should be defined in v4l2subdev.h.

>  };
>  
> diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
> index 77ac182..b8cefe8 100644
> --- a/utils/media-ctl/mediactl.h
> +++ b/utils/media-ctl/mediactl.h
> @@ -420,4 +420,26 @@ int media_parse_setup_link(struct media_device *media,
>   */
>  int media_parse_setup_links(struct media_device *media, const char *p);
>  
> +/**
> + * @brief Get file descriptor of the entity sub-device
> + * @param entity - media entity
> + *
> + * This function gets the file descriptor of the opened
> + * sub-device node related to the entity.
> + *
> + * @return file descriptor of the opened sub-device,
> +	   or -1 if the sub-device is closed
> + */
> +int media_entity_get_fd(struct media_entity *entity);
> +
> +/**
> + * @brief Set file descriptor of the entity sub-device
> + * @param entity - media entity
> + * @param fd - entity sub-device file descriptor
> + *
> + * This function sets the file descriptor of the opened
> + * sub-device node related to the entity.
> + */
> +void media_entity_set_fd(struct media_entity *entity, int fd);
> +
>  #endif

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

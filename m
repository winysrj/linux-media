Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41801 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750956AbaCGHeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 02:34:09 -0500
Date: Fri, 7 Mar 2014 09:34:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH/RFC v2 1/5] Split media_device creation and opening
Message-ID: <20140307073402.GS15635@valkosipuli.retiisi.org.uk>
References: <1394040741-22503-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1394040741-22503-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394040741-22503-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the set.

On Wed, Mar 05, 2014 at 06:32:17PM +0100, Laurent Pinchart wrote:
...
> diff --git a/src/main.c b/src/main.c
> index 4a27c8c..8b48fde 100644
> --- a/src/main.c
> +++ b/src/main.c
> diff --git a/src/mediactl.c b/src/mediactl.c
> index 57cf86b..c71d4e1 100644
> --- a/src/mediactl.c
> +++ b/src/mediactl.c
> @@ -101,6 +101,42 @@ struct media_entity *media_get_entity_by_id(struct media_device *media,
>  	return NULL;
>  }
>  
> +/* -----------------------------------------------------------------------------
> + * Open/close
> + */
> +
> +static int media_device_open(struct media_device *media)
> +{
> +	int ret;
> +
> +	if (media->fd != -1)
> +		return 0;
> +
> +	media_dbg(media, "Opening media device %s\n", media->devnode);
> +
> +	media->fd = open(media->devnode, O_RDWR);
> +	if (media->fd < 0) {
> +		ret = -errno;
> +		media_dbg(media, "%s: Can't open media device %s\n",
> +			  __func__, media->devnode);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void media_device_close(struct media_device *media)
> +{
> +	if (media->fd != -1) {
> +		close(media->fd);
> +		media->fd = -1;
> +	}
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Link setup
> + */
> +
>  int media_setup_link(struct media_device *media,
>  		     struct media_pad *source,
>  		     struct media_pad *sink,
> @@ -111,6 +147,10 @@ int media_setup_link(struct media_device *media,
>  	unsigned int i;
>  	int ret;
>  
> +	ret = media_device_open(media);
> +	if (ret < 0)
> +		goto done;
> +
>  	for (i = 0; i < source->entity->num_links; i++) {
>  		link = &source->entity->links[i];
>  
> @@ -123,7 +163,8 @@ int media_setup_link(struct media_device *media,
>  
>  	if (i == source->entity->num_links) {
>  		media_dbg(media, "%s: Link not found\n", __func__);
> -		return -ENOENT;
> +		ret = -ENOENT;

Please use errno before further function calls, i.e. reverse the order of
the print and ret assignment.

> +		goto done;
>  	}
>  
>  	/* source pad */
> @@ -142,12 +183,18 @@ int media_setup_link(struct media_device *media,
>  	if (ret == -1) {
>  		media_dbg(media, "%s: Unable to setup link (%s)\n",
>  			  __func__, strerror(errno));
> -		return -errno;
> +		ret = -errno;

Same here.

> +		goto done;
>  	}
>  
>  	link->flags = ulink.flags;
>  	link->twin->flags = ulink.flags;
> -	return 0;
> +
> +	ret = 0;
> +
> +done:
> +	media_device_close(media);
> +	return ret;
>  }
>  
>  int media_reset_links(struct media_device *media)
> @@ -425,6 +472,58 @@ static int media_enum_entities(struct media_device *media)
>  	return ret;
>  }
>  
> +int media_device_enumerate(struct media_device *media)
> +{
> +	int ret;
> +
> +	if (media->entities)
> +		return 0;
> +
> +	ret = media_device_open(media);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ioctl(media->fd, MEDIA_IOC_DEVICE_INFO, &media->info);
> +	if (ret < 0) {
> +		media_dbg(media, "%s: Unable to retrieve media device "
> +			  "information for device %s (%s)\n", __func__,

Splitting strings is not recommended since this breaks grepping them. But
perhaps this is so small project it doesn't make a big difference. I
wouldn't still.

> +			  media->devnode, strerror(errno));
> +		ret = -errno;

And here.

> +		goto done;
> +	}
> +
> +	media_dbg(media, "Enumerating entities\n");
> +
> +	ret = media_enum_entities(media);
> +	if (ret < 0) {
> +		media_dbg(media,
> +			  "%s: Unable to enumerate entities for device %s (%s)\n",
> +			  __func__, media->devnode, strerror(-ret));
> +		goto done;
> +	}
> +
> +	media_dbg(media, "Found %u entities\n", media->entities_count);
> +	media_dbg(media, "Enumerating pads and links\n");
> +
> +	ret = media_enum_links(media);
> +	if (ret < 0) {
> +		media_dbg(media,
> +			  "%s: Unable to enumerate pads and linksfor device %s\n",
> +			  __func__, media->devnode);
> +		goto done;
> +	}
> +
> +	ret = 0;
> +
> +done:
> +	media_device_close(media);
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Create/destroy
> + */
> +
>  static void media_debug_default(void *ptr, ...)
>  {
>  }

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

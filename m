Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56702 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965649AbcKXOYf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 09:24:35 -0500
Date: Thu, 24 Nov 2016 16:23:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4l-utils v7 1/7] mediactl: Add support for
 v4l2-ctrl-binding config
Message-ID: <20161124142320.GP16630@valkosipuli.retiisi.org.uk>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-2-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476282922-11544-2-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, Oct 12, 2016 at 04:35:16PM +0200, Jacek Anaszewski wrote:
> Make struct v4l2_subdev capable of aggregating v4l2-ctrl-bindings -
> media device configuration entries. Added are also functions for
> validating support for the control on given media entity and checking
> whether a v4l2-ctrl-binding has been defined for a media entity.

I still don't think this belongs here.

I think I told you about the generic pipeline configuration library I worked
on years ago; unfortunately it was left on prototype stage. Still, what I
realised was that something very similar is needed in that library ---
associating information to the representation of the media entities (or the
V4L2 sub-devices) in user space that has got nothing to do with the devices
themselves.

We could have e.g. a list of key--value pairs where the key is a pointer
provided by the user (i.e. application, another library) that could be
associated with the value. That would avoid having explicit information on
that in the struct media_entity itself.

An quicker alternative would be to manage a list of controls e.g. in the
plugin itself and store the media entity where they're implemented in that
list, with the control value.

Cc Laurent as well.

> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  utils/media-ctl/libv4l2subdev.c | 32 ++++++++++++++++++++++++++++++++
>  utils/media-ctl/v4l2subdev.h    | 19 +++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index c3439d7..4f8ee7f 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -50,7 +50,15 @@ int v4l2_subdev_create(struct media_entity *entity)
>  
>  	entity->sd->fd = -1;
>  
> +	entity->sd->v4l2_ctrl_bindings = malloc(sizeof(__u32));
> +	if (entity->sd->v4l2_ctrl_bindings == NULL)
> +		goto err_v4l2_ctrl_bindings_alloc;
> +
>  	return 0;
> +
> +err_v4l2_ctrl_bindings_alloc:
> +	free(entity->sd);
> +	return -ENOMEM;
>  }
>  
>  int v4l2_subdev_create_opened(struct media_entity *entity, int fd)
> @@ -102,6 +110,7 @@ void v4l2_subdev_close(struct media_entity *entity)
>  	if (entity->sd->fd_owner)
>  		close(entity->sd->fd);
>  
> +	free(entity->sd->v4l2_ctrl_bindings);
>  	free(entity->sd);
>  }
>  
> @@ -884,3 +893,26 @@ const enum v4l2_mbus_pixelcode *v4l2_subdev_pixelcode_list(unsigned int *length)
>  
>  	return mbus_codes;
>  }
> +
> +int v4l2_subdev_supports_v4l2_ctrl(struct media_device *media,
> +				   struct media_entity *entity,
> +				   __u32 ctrl_id)
> +{
> +	struct v4l2_queryctrl queryctrl = {};
> +	int ret;
> +
> +	ret = v4l2_subdev_open(entity);
> +	if (ret < 0)
> +		return ret;
> +
> +	queryctrl.id = ctrl_id;
> +
> +	ret = ioctl(entity->sd->fd, VIDIOC_QUERYCTRL, &queryctrl);
> +	if (ret < 0)
> +		return ret;
> +
> +	media_dbg(media, "Validated control \"%s\" (0x%8.8x) on entity %s\n",
> +		  queryctrl.name, queryctrl.id, entity->info.name);
> +
> +	return 0;
> +}
> diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
> index 011fab1..4dee6b1 100644
> --- a/utils/media-ctl/v4l2subdev.h
> +++ b/utils/media-ctl/v4l2subdev.h
> @@ -26,10 +26,14 @@
>  
>  struct media_device;
>  struct media_entity;
> +struct media_device;
>  
>  struct v4l2_subdev {
>  	int fd;
>  	unsigned int fd_owner:1;
> +
> +	__u32 *v4l2_ctrl_bindings;
> +	unsigned int num_v4l2_ctrl_bindings;
>  };
>  
>  /**
> @@ -314,4 +318,19 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string);
>  const enum v4l2_mbus_pixelcode *v4l2_subdev_pixelcode_list(
>  	unsigned int *length);
>  
> +/**
> + * @brief Check if sub-device supports given v4l2 control
> + * @param media - media device.
> + * @param entity - media entity.
> + * @param ctrl_id - id of the v4l2 control to check.
> + *
> + * Verify if the sub-device associated with given media entity
> + * supports v4l2-control with given ctrl_id.
> + *
> + * @return 1 if the control is supported, 0 otherwise.
> + */
> +int v4l2_subdev_supports_v4l2_ctrl(struct media_device *device,
> +				   struct media_entity *entity,
> +				   __u32 ctrl_id);
> +
>  #endif

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2011 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbcBOK6s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 05:58:48 -0500
Subject: Re: [PATCH 02/15] mediactl: Add support for v4l2-ctrl-redir config
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, gjasny@googlemail.com,
	hdegoede@redhat.com, hverkuil@xs4all.nl
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
 <1453133860-21571-3-git-send-email-j.anaszewski@samsung.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <56C1AF5F.3060702@linux.intel.com>
Date: Mon, 15 Feb 2016 12:58:39 +0200
MIME-Version: 1.0
In-Reply-To: <1453133860-21571-3-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

Jacek Anaszewski wrote:
> Make struct v4l2_subdev capable of aggregating v4l2-ctrl-redir
> media device configuration entries. Added are also functions for
> validating the config and checking whether a v4l2 sub-device
> expects to receive ioctls related to the v4l2-control with given id.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  utils/media-ctl/libv4l2subdev.c |   49 ++++++++++++++++++++++++++++++++++++++-
>  utils/media-ctl/v4l2subdev.h    |   30 ++++++++++++++++++++++++
>  2 files changed, 78 insertions(+), 1 deletion(-)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index 3977ce5..069ded6 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -26,7 +26,6 @@
>  #include <ctype.h>
>  #include <errno.h>
>  #include <fcntl.h>
> -#include <stdbool.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> @@ -50,7 +49,15 @@ int v4l2_subdev_create(struct media_entity *entity)
>  
>  	entity->sd->fd = -1;
>  
> +	entity->sd->v4l2_control_redir = malloc(sizeof(__u32));
> +	if (entity->sd->v4l2_control_redir == NULL)
> +		goto err_v4l2_control_redir_alloc;
> +
>  	return 0;
> +
> +err_v4l2_control_redir_alloc:
> +	free(entity->sd);
> +	return -ENOMEM;
>  }
>  
>  int v4l2_subdev_create_with_fd(struct media_entity *entity, int fd)
> @@ -870,3 +877,43 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string,
>  
>  	return fields[i].field;
>  }
> +
> +int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
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
> +
> +bool v4l2_subdev_has_v4l2_control_redir(struct media_device *media,
> +				  struct media_entity *entity,
> +				  int ctrl_id)
> +{
> +	struct v4l2_subdev *sd = entity->sd;
> +	int i;
> +
> +	if (!sd)
> +		return false;
> +
> +	for (i = 0; i < sd->v4l2_control_redir_num; ++i)
> +		if (sd->v4l2_control_redir[i] == ctrl_id)
> +			return true;
> +
> +	return false;
> +}
> diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
> index ba9b8c4..f395065 100644
> --- a/utils/media-ctl/v4l2subdev.h
> +++ b/utils/media-ctl/v4l2subdev.h
> @@ -23,12 +23,17 @@
>  #define __SUBDEV_H__
>  
>  #include <linux/v4l2-subdev.h>
> +#include <stdbool.h>
>  
>  struct media_device;
>  struct media_entity;
> +struct media_device;
>  
>  struct v4l2_subdev {
>  	int fd;
> +
> +	__u32 *v4l2_control_redir;
> +	unsigned int v4l2_control_redir_num;
>  };
>  
>  /**
> @@ -316,5 +321,30 @@ const char *v4l2_subdev_field_to_string(enum v4l2_field field);
>   */
>  enum v4l2_field v4l2_subdev_string_to_field(const char *string,
>  					    unsigned int length);
> +/**
> + * @brief Validate v4l2 control for a sub-device
> + * @param media - media device.
> + * @param entity - subdev-device media entity.
> + * @param ctrl_id - id of the v4l2 control to validate.
> + *
> + * Verify if the entity supports v4l2-control with given ctrl_id.
> + *
> + * @return 1 if the control is supported, 0 otherwise.
> + */
> +int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
> +				   struct media_entity *entity,
> +				   __u32 ctrl_id);
> +/**
> + * @brief Check if there was a v4l2_control redirection defined for the entity
> + * @param media - media device.
> + * @param entity - subdev-device media entity.
> + * @param ctrl_id - v4l2 control identifier.
> + *
> + * Check if there was a v4l2-ctrl-redir entry defined for the entity.
> + *
> + * @return true if the entry exists, false otherwise
> + */
> +bool v4l2_subdev_has_v4l2_control_redir(struct media_device *media,
> +	struct media_entity *entity, int ctrl_id);
>  
>  #endif
> 

Where do you need this?

If you have an application that's aware of V4L2 sub-devices (and thus
multiple devices)), I'd expect it to set the controls on the sub-devices
the controls are implemented in rather than rely on them being redirected.

This would make perfect sense IMO when implementing plain V4L2 interface
support on top of drivers that expose MC/V4L2 subdev/V4L2 APIs. But I
wouldn't implement it in libv4l2subdev.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com

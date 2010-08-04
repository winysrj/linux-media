Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1835 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0HDSay (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 14:30:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v3 3/7] v4l: subdev: Merge v4l2_i2c_new_subdev_cfg and v4l2_i2c_new_subdev
Date: Wed, 4 Aug 2010 20:30:44 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278948352-17892-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278948352-17892-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278948352-17892-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042030.44606.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 12 July 2010 17:25:48 Laurent Pinchart wrote:
> v4l2_i2c_new_subdev_cfg is called by v4l2_i2c_new_subdev only. Merge the
> two functions into v4l2_i2c_new_subdev.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

> ---
>  drivers/media/video/v4l2-common.c |    7 ++-----
>  include/media/v4l2-common.h       |   15 +--------------
>  2 files changed, 3 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
> index 4e53b0b..bbda421 100644
> --- a/drivers/media/video/v4l2-common.c
> +++ b/drivers/media/video/v4l2-common.c
> @@ -897,10 +897,9 @@ error:
>  }
>  EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_board);
>  
> -struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
> +struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
>  		struct i2c_adapter *adapter,
>  		const char *module_name, const char *client_type,
> -		int irq, void *platform_data,
>  		u8 addr, const unsigned short *probe_addrs)
>  {
>  	struct i2c_board_info info;
> @@ -910,13 +909,11 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
>  	memset(&info, 0, sizeof(info));
>  	strlcpy(info.type, client_type, sizeof(info.type));
>  	info.addr = addr;
> -	info.irq = irq;
> -	info.platform_data = platform_data;
>  
>  	return v4l2_i2c_new_subdev_board(v4l2_dev, adapter, module_name,
>  			&info, probe_addrs);
>  }
> -EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_cfg);
> +EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
>  
>  /* Return i2c client address of v4l2_subdev. */
>  unsigned short v4l2_i2c_subdev_addr(struct v4l2_subdev *sd)
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 98b3264..6fc3d7a 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -139,24 +139,11 @@ struct v4l2_subdev_ops;
>  /* Load an i2c module and return an initialized v4l2_subdev struct.
>     Only call request_module if module_name != NULL.
>     The client_type argument is the name of the chip that's on the adapter. */
> -struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
> +struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
>  		struct i2c_adapter *adapter,
>  		const char *module_name, const char *client_type,
> -		int irq, void *platform_data,
>  		u8 addr, const unsigned short *probe_addrs);
>  
> -/* Load an i2c module and return an initialized v4l2_subdev struct.
> -   Only call request_module if module_name != NULL.
> -   The client_type argument is the name of the chip that's on the adapter. */
> -static inline struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
> -		struct i2c_adapter *adapter,
> -		const char *module_name, const char *client_type,
> -		u8 addr, const unsigned short *probe_addrs)
> -{
> -	return v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter, module_name,
> -				client_type, 0, NULL, addr, probe_addrs);
> -}
> -
>  struct i2c_board_info;
>  
>  struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbaGQKWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 06:22:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] smiapp: Set sub-device owner
Date: Thu, 17 Jul 2014 12:22:47 +0200
Message-ID: <4340191.d162iopR0n@avalon>
In-Reply-To: <1396017313-3990-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1396017313-3990-1-git-send-email-sakari.ailus@linux.intel.com> <1396017313-3990-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

What happened to this patch ? 1/3 and 3/3 from the same series seem to have 
been applied, but not 2/3.

On Friday 28 March 2014 16:35:12 Sakari Ailus wrote:
> The smiapp driver is the owner of the sub-devices exposed by the smiapp
> driver. This prevents unloading the module whilst it's in use.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index 69c11ec..5179cf4 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2569,7 +2569,7 @@ static int smiapp_registered(struct v4l2_subdev
> *subdev)
> 
>  		this->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  		this->sd.internal_ops = &smiapp_internal_ops;
> -		this->sd.owner = NULL;
> +		this->sd.owner = THIS_MODULE;
>  		v4l2_set_subdevdata(&this->sd, client);
> 
>  		rval = media_entity_init(&this->sd.entity,

-- 
Regards,

Laurent Pinchart


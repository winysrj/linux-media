Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36932 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754669AbdD0Vnx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 17:43:53 -0400
Date: Fri, 28 Apr 2017 00:43:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kbingham@kernel.org>
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH 1/5] v4l2-subdev: Provide a port mapping for asynchronous
 subdevs
Message-ID: <20170427214346.GB7456@valkosipuli.retiisi.org.uk>
References: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
 <1493317564-18026-2-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493317564-18026-2-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Could I ask you to rebase your patches on top of my V4L2 fwnode patches
here?

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi>

It depends on the fwnode graph patches, merged here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi-merge>

I expect the fwnode graph patches in v4.12 so we'll have them in media-tree
master soon.

(I'm pushing these branches right now, it may take a while until it's really
there.)

On Thu, Apr 27, 2017 at 07:26:00PM +0100, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Devices such as the the ADV748x support multiple parallel stream routes
> through a single chip. This leads towards needing to provide multiple
> distinct entities and subdevs from a single device-tree node.
> 
> To distinguish these separate outputs, the device-tree binding must
> specify each endpoint link with a unique (to the device) non-zero port
> number.
> 
> This number allows async subdev registrations to identify the correct
> subdevice to bind and link.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c  | 7 +++++++
>  drivers/media/v4l2-core/v4l2-subdev.c | 1 +
>  include/media/v4l2-async.h            | 1 +
>  include/media/v4l2-subdev.h           | 2 ++
>  4 files changed, 11 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 1815e54e8a38..875e6ce646ec 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -42,6 +42,13 @@ static bool match_devname(struct v4l2_subdev *sd,
>  
>  static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>  {
> +	/*
> +	 * If set, we must match the device tree port, with the subdev port.
> +	 * This is a fast match, so do this first
> +	 */
> +	if (sd->port && sd->port != asd->match.of.port)

Zero is an entirely valid value for a port. I think it'd be good not to
depend on non-zero port values for port matching.

> +		return -1;

Any particular reason to return -1 from a function with bool return type?

> +
>  	return !of_node_cmp(of_node_full_name(sd->of_node),
>  			    of_node_full_name(asd->match.of.node));
>  }
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index da78497ae5ed..67f816f90ac3 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -607,6 +607,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>  	sd->flags = 0;
>  	sd->name[0] = '\0';
>  	sd->grp_id = 0;
> +	sd->port = 0;
>  	sd->dev_priv = NULL;
>  	sd->host_priv = NULL;
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 5b501309b6a7..2988960613ec 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -56,6 +56,7 @@ struct v4l2_async_subdev {
>  	union {
>  		struct {
>  			const struct device_node *node;
> +			u32 port;

What if instead of storing the device's OF node, you'd store the port node
and used that for matching?

Would that also solve the problem or do I miss something?

>  		} of;
>  		struct {
>  			const char *name;
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 0ab1c5df6fac..1c1731b491e5 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -782,6 +782,7 @@ struct v4l2_subdev_platform_data {
>   * @ctrl_handler: The control handler of this subdev. May be NULL.
>   * @name: Name of the sub-device. Please notice that the name must be unique.
>   * @grp_id: can be used to group similar subdevs. Value is driver-specific
> + * @port: driver-specific value to bind multiple subdevs with a single DT node.
>   * @dev_priv: pointer to private data
>   * @host_priv: pointer to private data used by the device where the subdev
>   *	is attached.
> @@ -814,6 +815,7 @@ struct v4l2_subdev {
>  	struct v4l2_ctrl_handler *ctrl_handler;
>  	char name[V4L2_SUBDEV_NAME_SIZE];
>  	u32 grp_id;
> +	u32 port;
>  	void *dev_priv;
>  	void *host_priv;
>  	struct video_device *devnode;

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

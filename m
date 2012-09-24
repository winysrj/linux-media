Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46978 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752410Ab2IXNo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 09:44:59 -0400
Date: Mon, 24 Sep 2012 16:44:54 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, a.hajda@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC] V4L: Add s_rx_buffer subdev video operation
Message-ID: <20120924134453.GH12025@valkosipuli.retiisi.org.uk>
References: <1348493213-32278-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348493213-32278-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Mon, Sep 24, 2012 at 03:26:53PM +0200, Sylwester Nawrocki wrote:
> The s_rx_buffer callback allows the host to set buffer for non-image
> (meta) data at a subdev. This callback can be implemented by an image
> sensor or a MIPI-CSI receiver, allowing the host to retrieve the frame
> embedded data from a subdev.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/media/v4l2-subdev.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 22ab09e..28067ed 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -274,6 +274,10 @@ struct v4l2_subdev_audio_ops {
>     s_mbus_config: set a certain mediabus configuration. This operation is added
>  	for compatibility with soc-camera drivers and should not be used by new
>  	software.
> +
> +   s_rx_buffer: set a host allocated memory buffer for the subdev. The subdev
> +	can adjust @size to a lower value and must not write more data to the
> +	buffer starting at @data than the original value of @size.
>   */
>  struct v4l2_subdev_video_ops {
>  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
> @@ -327,6 +331,8 @@ struct v4l2_subdev_video_ops {
>  			     struct v4l2_mbus_config *cfg);
>  	int (*s_mbus_config)(struct v4l2_subdev *sd,
>  			     const struct v4l2_mbus_config *cfg);
> +	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
> +			   unsigned int *size);
>  };
> 
>  /*

How about useing a separate video buffer queue for the purpose? That would
provide a nice way to pass it to the user space where it's needed. It'd also
play nicely together with the frame layout descriptors.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

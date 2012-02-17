Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56925 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab2BQXZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 18:25:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 3/6] V4L: Add g_embedded_data subdev callback
Date: Sat, 18 Feb 2012 00:23:23 +0100
Message-ID: <6366737.ZEMB1VQOcD@avalon>
In-Reply-To: <1329416639-19454-4-git-send-email-s.nawrocki@samsung.com>
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com> <1329416639-19454-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

On Thursday 16 February 2012 19:23:56 Sylwester Nawrocki wrote:
> The g_embedded_data callback allows the host to retrieve frame embedded
> (meta) data from a certain subdev. This callback can be implemented by
> an image sensor or a MIPI-CSI receiver, allowing to read embedded frame
> data from a subdev or just query it for the data size.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/media/v4l2-subdev.h |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index f0f3358..be74061 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -274,6 +274,14 @@ struct v4l2_subdev_audio_ops {
>     s_mbus_config: set a certain mediabus configuration. This operation is
> added for compatibility with soc-camera drivers and should not be used by
> new software.
> +
> +   g_embedded_data: retrieve the frame embedded data (frame header or
> footer). +	After a full frame has been transmitted the host can query a
> subdev +	for frame meta data using this operation. Metadata size is
> returned +	in @size, and the actual metadata in memory pointed by @data.
> When +	@buf is NULL the subdev will return only the metadata size. The
> +	subdevs can adjust @size to a lower value but must not write more
> +	data than the @size's original value.
>   */
>  struct v4l2_subdev_video_ops {
>  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32
> config); @@ -321,6 +329,8 @@ struct v4l2_subdev_video_ops {
>  			     struct v4l2_mbus_config *cfg);
>  	int (*s_mbus_config)(struct v4l2_subdev *sd,
>  			     const struct v4l2_mbus_config *cfg);
> +	int (*g_embedded_data)(struct v4l2_subdev *sd, unsigned int *size,
> +			       void **buf);
>  };

How is the embedded data transferred from the sensor to the host in your case 
? Over I2C ?

-- 
Regards,

Laurent Pinchart

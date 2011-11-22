Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1863 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab1KVKtJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 05:49:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH v1 1/3] v4l: Add new framesamples field to struct v4l2_mbus_framefmt
Date: Tue, 22 Nov 2011 11:48:57 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1321955740-24452-1-git-send-email-s.nawrocki@samsung.com> <1321955740-24452-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1321955740-24452-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111221148.57445.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, November 22, 2011 10:55:38 Sylwester Nawrocki wrote:
> The purpose of the new field is to allow the video pipeline elements to
> negotiate memory buffer size for compressed data frames, where the buffer
> size cannot be derived from pixel width and height and the pixel code.
> 
> For VIDIOC_SUBDEV_S_FMT and VIDIOC_SUBDEV_G_FMT ioctls, the framesamples
> parameter should be calculated by the driver from pixel width, height,
> color format and other parameters if required and returned to the caller.
> This applies to compressed data formats only.
> 
> The application should propagate the framesamples value, whatever returned
> at the first sub-device within a data pipeline, i.e. at the pipeline's data
> source.
> 
> For compressed data formats the host drivers should internally validate
> the framesamples parameter values before streaming is enabled, to make sure
> the memory buffer size requirements are satisfied along the pipeline.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml |    7 ++++++-
>  include/linux/v4l2-mediabus.h                      |    4 +++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 49c532e..d0827b4 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -35,7 +35,12 @@
>  	</row>
>  	<row>
>  	  <entry>__u32</entry>
> -	  <entry><structfield>reserved</structfield>[7]</entry>
> +	  <entry><structfield>framesamples</structfield></entry>
> +	  <entry>Number of data samples on media bus per frame.</entry>

Is this the *maximum* number of data samples, or is this the *required* number
of data samples?

I think you mean 'maximum', but the documentation does not actually state that.

It should also clearly state that this field is used only for compressed
formats (right?). Should drivers be required to set this to 0 for uncompressed
formats?

Regards,

	Hans

> +	</row>
> +	<row>
> +	  <entry>__u32</entry>
> +	  <entry><structfield>reserved</structfield>[6]</entry>
>  	  <entry>Reserved for future extensions. Applications and drivers must
>  	  set the array to zero.</entry>
>  	</row>
> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 5ea7f75..ce776e8 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -101,6 +101,7 @@ enum v4l2_mbus_pixelcode {
>   * @code:	data format code (from enum v4l2_mbus_pixelcode)
>   * @field:	used interlacing type (from enum v4l2_field)
>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> + * @framesamples: number of data samples per frame
>   */
>  struct v4l2_mbus_framefmt {
>  	__u32			width;
> @@ -108,7 +109,8 @@ struct v4l2_mbus_framefmt {
>  	__u32			code;
>  	__u32			field;
>  	__u32			colorspace;
> -	__u32			reserved[7];
> +	__u32			framesamples;
> +	__u32			reserved[6];
>  };
>  
>  #endif
> 

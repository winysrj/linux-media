Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39560 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab2AFK0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 05:26:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 07/17] v4l: Add pixelrate to struct v4l2_mbus_framefmt
Date: Fri, 6 Jan 2012 11:26:40 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1324412889-17961-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201061126.40692.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tuesday 20 December 2011 21:27:59 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Pixelrate is an essential part of the image data parameters. Add this.
> Together, the current parameters also define the frame rate.
> 
> Sensors do not have a concept of frame rate; pixelrate is much more
> meaningful in this context. Also, it is best to combine the pixelrate with
> the other format parameters since there are dependencies between them.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml |   10 +++++++++-
>  include/linux/v4l2-mediabus.h                      |    4 +++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
> b/Documentation/DocBook/media/v4l/subdev-formats.xml index
> 49c532e..a6a6630 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -35,7 +35,15 @@
>  	</row>
>  	<row>
>  	  <entry>__u32</entry>
> -	  <entry><structfield>reserved</structfield>[7]</entry>
> +	  <entry><structfield>pixelrate</structfield></entry>
> +	  <entry>Pixel rate in kp/s.

kPix/s or kPixel/s ?

> This clock is the maximum rate at

Is it really a clock ?

> +	  which pixels are transferred on the bus. The
> +	  <structfield>pixelrate</structfield> field is
> +	  read-only.</entry>

Does that mean that userspace isn't required to propagate the value down the 
pipeline when configuring it ? I'm fine with that, but it should probably be 
documented explictly somewhere to make sure that drivers don't rely on it.

> +	</row>
> +	<row>
> +	  <entry>__u32</entry>
> +	  <entry><structfield>reserved</structfield>[6]</entry>
>  	  <entry>Reserved for future extensions. Applications and drivers must
>  	  set the array to zero.</entry>
>  	</row>
> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 5ea7f75..35c6b96 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -101,6 +101,7 @@ enum v4l2_mbus_pixelcode {
>   * @code:	data format code (from enum v4l2_mbus_pixelcode)
>   * @field:	used interlacing type (from enum v4l2_field)
>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> + * @pixel_clock: pixel clock, in kHz

I think you forgot to update the comment.

>   */
>  struct v4l2_mbus_framefmt {
>  	__u32			width;
> @@ -108,7 +109,8 @@ struct v4l2_mbus_framefmt {
>  	__u32			code;
>  	__u32			field;
>  	__u32			colorspace;
> -	__u32			reserved[7];
> +	__u32			pixelrate;
> +	__u32			reserved[6];
>  };
> 
>  #endif

-- 
Regards,

Laurent Pinchart

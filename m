Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36670 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1HaRIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 13:08:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: [PATCH 1/2 v2] media: Add support for arbitrary resolution for the ov5642 camera driver
Date: Wed, 31 Aug 2011 19:08:30 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <alpine.DEB.2.02.1108311420540.2154@ipanema>
In-Reply-To: <alpine.DEB.2.02.1108311420540.2154@ipanema>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311908.30820.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastian,

A second comment.

On Wednesday 31 August 2011 17:05:52 Bastian Hecht wrote:
> This patch adds the ability to get arbitrary resolutions with a width
> up to 2592 and a height up to 720 pixels instead of the standard 1280x720
> only.
> 
> Signed-off-by: Bastian Hecht <hechtb@gmail.com>
> ---
> diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
> index 6410bda..87b432e 100644
> --- a/drivers/media/video/ov5642.c
> +++ b/drivers/media/video/ov5642.c

[snip]

> @@ -578,9 +605,20 @@ struct ov5642_datafmt {
>  	enum v4l2_colorspace		colorspace;
>  };
> 
> +/* the output resolution and blanking information */
> +struct ov5642_out_size {
> +	int width;
> +	int height;
> +	int total_width;
> +	int total_height;
> +};
> +
>  struct ov5642 {
>  	struct v4l2_subdev		subdev;
> +
>  	const struct ov5642_datafmt	*fmt;
> +	struct v4l2_rect                crop_rect;
> +	struct ov5642_out_size		out_size;
>  };

If I'm not mistaken you store the exact same width/height in crop_rect and 
out_size. If that's right, you should remove width/height from struct 
ov5642_out_size (or maybe better move the total_width and total_height 
directly to the ov5642 structure).

-- 
Regards,

Laurent Pinchart

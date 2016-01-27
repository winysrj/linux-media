Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54585 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbcA0Jib (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 04:38:31 -0500
Date: Wed, 27 Jan 2016 07:38:18 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/2] [media] tvp5150: Add pad-level subdev operations
Message-ID: <20160127073818.0bfda497@recife.lan>
In-Reply-To: <1453812384-15512-3-git-send-email-javier@osg.samsung.com>
References: <1453812384-15512-1-git-send-email-javier@osg.samsung.com>
	<1453812384-15512-3-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Jan 2016 09:46:24 -0300
Javier Martinez Canillas <javier@osg.samsung.com> escreveu:

> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> This patch enables the tvp5150 decoder driver to be used with the media
> controller framework by adding pad-level subdev operations and init the
> media entity pad.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
> Changes in v3:
> - Split the format fix and the MC support in different patches.
>   Suggested by Mauro Carvalho Chehab.
> 
> Changes in v2:
> - Embed mbus_type into struct tvp5150. Suggested by Laurent Pinchart.
> - Remove platform data support. Suggested by Laurent Pinchart.
> - Check if the hsync, vsync and field even active properties are correct.
>   Suggested by Laurent Pinchart.
> 
>  drivers/media/i2c/tvp5150.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 37853bc3f0b3..e48b529c53b4 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -37,6 +37,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
>  
>  struct tvp5150 {
>  	struct v4l2_subdev sd;
> +	struct media_pad pad;
>  	struct v4l2_ctrl_handler hdl;
>  	struct v4l2_rect rect;
>  
> @@ -826,17 +827,6 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
>  	}
>  }
>  
> -static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
> -		struct v4l2_subdev_pad_config *cfg,
> -		struct v4l2_subdev_mbus_code_enum *code)
> -{
> -	if (code->pad || code->index)
> -		return -EINVAL;
> -
> -	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
> -	return 0;
> -}
> -

Huh! Why are you removing this? It is causing compilation breakages!

>  static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
>  		struct v4l2_subdev_pad_config *cfg,
>  		struct v4l2_subdev_format *format)
> @@ -1165,6 +1155,7 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
>  
>  static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
>  	.enum_mbus_code = tvp5150_enum_mbus_code,
> +	.enum_frame_size = tvp5150_enum_frame_size,

Also, you forgot to add tvp5150_enum_frame_size here!

drivers/media/i2c/tvp5150.c:1124:20: error: 'tvp5150_enum_mbus_code' undeclared here (not in a function)
  .enum_mbus_code = tvp5150_enum_mbus_code,
                    ^
drivers/media/i2c/tvp5150.c:1125:21: error: 'tvp5150_enum_frame_size' undeclared here (not in a function)
  .enum_frame_size = tvp5150_enum_frame_size,
                     ^
Regards,
Mauro

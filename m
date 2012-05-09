Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:47101 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855Ab2EIHn3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 May 2012 03:43:29 -0400
From: Qing Xu <qingx@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jiaquan Su <jqsu@marvell.com>, Angela Wan <jwan@marvell.com>,
	Bin Zhou <zhoub@marvell.com>
Date: Wed, 9 May 2012 00:41:39 -0700
Subject: RE: [PATCH 2/2] V4L: remove unused .enum_mbus_fsizes() subdev video
 operation
Message-ID: <7BAC95F5A7E67643AAFB2C31BEE662D015E3B3AD63@SC-VEXCH2.marvell.com>
References: <Pine.LNX.4.64.1205082259390.7085@axis700.grange>
 <Pine.LNX.4.64.1205082300510.7085@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1205082300510.7085@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch! I am ok with it.

> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de] 
> Sent: Wednesday, May 09, 2012 5:01 AM
> To: Linux Media Mailing List
> Cc: Qing Xu
> Subject: [PATCH 2/2] V4L: remove unused .enum_mbus_fsizes() subdev video operation
> 
> .enum_mbus_fsizes() subdev video operation is a duplicate of
> .enum_framesizes() and is unused. Remove it.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Qing Xu <qingx@marvell.com>
> ---
>  include/media/v4l2-subdev.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index f0f3358..9e68464 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -309,8 +309,6 @@ struct v4l2_subdev_video_ops {
>  			struct v4l2_dv_timings *timings);
>  	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
>  			     enum v4l2_mbus_pixelcode *code);
> -	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
> -			     struct v4l2_frmsizeenum *fsize);
>  	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
>  			  struct v4l2_mbus_framefmt *fmt);
>  	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
> -- 
> 1.7.2.5

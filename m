Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40078 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab2AFJmU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 04:42:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 09/17] v4l: Add pad op for pipeline validation
Date: Fri, 6 Jan 2012 10:42:37 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-9-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1324412889-17961-9-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201061042.38152.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tuesday 20 December 2011 21:28:01 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> smiapp_pad_ops.validate_pipeline is intended to validate the full pipeline
> which is implemented by the driver to which the subdev implementing this op
> belongs to.

Should this be documented in Documentation/video4linux/v4l2-framework.txt ?

> The validate_pipeline op must also call validate_pipeline on any external
> entity which is linked to its sink pads.

I'm uncertain about this. Subdev drivers would then have to implement the 
pipeline walk logic, resulting in duplicate code. Our current situation isn't 
optimal either: walking the pipeline should be implemented in the media code. 
Would it suit your needs if the validate_pipeline operation was replaced by a 
validate_link operation, with a media_pipeline_validate() function in the 
media core to walk the pipeline and call validate_link in each pad (or maybe 
each sink pad) ?

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  include/media/v4l2-subdev.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 26eeaa4..a5ebe86 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -470,6 +470,7 @@ struct v4l2_subdev_pad_ops {
>  			     struct v4l2_subdev_selection *sel);
>  	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>  			     struct v4l2_subdev_selection *sel);
> +	int (*validate_pipeline)(struct v4l2_subdev *sd);
>  };
> 
>  struct v4l2_subdev_ops {

-- 
Regards,

Laurent Pinchart

Return-path: <mchehab@pedra>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:19805 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101Ab1FIIJV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 04:09:21 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 2/3] v4l: add g_tvnorms callback to V4L2 subdev
Date: Thu, 9 Jun 2011 10:08:27 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, mchehab@redhat.com
References: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com> <1307534611-32283-3-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1307534611-32283-3-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106091008.27593.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 08, 2011 14:03:30 Tomasz Stanislawski wrote:
> Callback is used to acquire TV norms supported by a subdev.
> It is used to avoid having standards in top-level driver.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/media/v4l2-subdev.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 1562c4f..4206e97 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -261,6 +261,7 @@ struct v4l2_subdev_video_ops {
>  	int (*s_crystal_freq)(struct v4l2_subdev *sd, u32 freq, u32 flags);
>  	int (*s_std_output)(struct v4l2_subdev *sd, v4l2_std_id std);
>  	int (*querystd)(struct v4l2_subdev *sd, v4l2_std_id *std);
> +	int (*g_tvnorms)(struct v4l2_subdev *sd, v4l2_std_id *std);

I would rename this to g_tvnorms_output to clarify that this is for video 
output, not input.

It is likely that a g_tvnorms for video input will be added in the future
since this is actually a good idea.

Regards,

	Hans

>  	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
>  	int (*s_stream)(struct v4l2_subdev *sd, int enable);
>  	int (*cropcap)(struct v4l2_subdev *sd, struct v4l2_cropcap *cc);
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

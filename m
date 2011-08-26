Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40761 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1HZPIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 11:08:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 4/5] [media] v4l: fix copying ioctl results on failure
Date: Fri, 26 Aug 2011 17:09:02 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
References: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com> <1314363967-6448-5-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1314363967-6448-5-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261709.02567.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Friday 26 August 2011 15:06:06 Tomasz Stanislawski wrote:
> This patch fix the handling of data passed to V4L2 ioctls.  The content of
> the structures is not copied if the ioctl fails.  It blocks ability to
> obtain any information about occurred error other then errno code. This
> patch fix this issue.

Does the V4L2 spec say anything on this topic ? We might have applications 
that rely on the ioctl argument structure not being touched when a failure 
occurs.

> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c
> b/drivers/media/video/v4l2-ioctl.c index 543405b..9f54114 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -2490,8 +2490,6 @@ video_usercopy(struct file *file, unsigned int cmd,
> unsigned long arg, err = -EFAULT;
>  		goto out_array_args;
>  	}
> -	if (err < 0)
> -		goto out;
> 
>  out_array_args:
>  	/*  Copy results into user buffer  */

-- 
Regards,

Laurent Pinchart

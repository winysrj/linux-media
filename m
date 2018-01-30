Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45395 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752267AbeA3OcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 09:32:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
Subject: Re: [PATCHv2 12/13] v4l2-compat-ioctl32.c: don't copy back the result for certain errors
Date: Tue, 30 Jan 2018 16:32:22 +0200
Message-ID: <5974400.0qDhsOljgk@avalon>
In-Reply-To: <20180130102701.13664-13-hverkuil@xs4all.nl>
References: <20180130102701.13664-1-hverkuil@xs4all.nl> <20180130102701.13664-13-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday, 30 January 2018 12:27:00 EET Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Some ioctls need to copy back the result even if the ioctl returned
> an error. However, don't do this for the error code -ENOTTY.
> It makes no sense in that cases.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: <stable@vger.kernel.org>      # for v4.15 and up
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index
> 7ee3777cbe9c..3a1fca1440ac 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -968,6 +968,9 @@ static long do_video_ioctl(struct file *file, unsigned
> int cmd, unsigned long ar set_fs(old_fs);
>  	}
> 
> +	if (err == -ENOTTY)

Should we also handle -ENOIOCTLCMD as in video_usercopy() ?

> +		return err;
> +
>  	/* Special case: even after an error we need to put the
>  	   results back for these ioctls since the error_idx will
>  	   contain information on which control failed. */


-- 
Regards,

Laurent Pinchart

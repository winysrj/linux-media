Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36314 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750913AbeA2J4L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 04:56:11 -0500
Date: Mon, 29 Jan 2018 11:56:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 11/12] v4l2-compat-ioctl32.c: don't copy back the result
 for certain errors
Message-ID: <20180129095608.d3opjq5zkp72u43e@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
 <20180126124327.16653-12-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126124327.16653-12-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jan 26, 2018 at 01:43:26PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Some ioctls need to copy back the result even if the ioctl returned
> an error. However, don't do this for the error codes -ENOTTY, -EFAULT
> and -ENOIOCTLCMD. It makes no sense in those cases.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Shouldn't such a change be made to video_usercopy() as well? Doesn't need
to be in this set though.

> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 790473b45a21..2aa9b43daf60 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -966,6 +966,9 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		set_fs(old_fs);
>  	}
>  
> +	if (err == -ENOTTY || err == -EFAULT || err == -ENOIOCTLCMD)
> +		return err;
> +
>  	/* Special case: even after an error we need to put the
>  	   results back for these ioctls since the error_idx will
>  	   contain information on which control failed. */

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

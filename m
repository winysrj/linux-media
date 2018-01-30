Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50666 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751579AbeA3Lv7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 06:51:59 -0500
Date: Tue, 30 Jan 2018 13:51:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
Subject: Re: [PATCHv2 03/13] v4l2-ioctl.c: don't copy back the result for
 -ENOTTY
Message-ID: <20180130115156.impfksxh2f7jzdps@valkosipuli.retiisi.org.uk>
References: <20180130102701.13664-1-hverkuil@xs4all.nl>
 <20180130102701.13664-4-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180130102701.13664-4-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 30, 2018 at 11:26:51AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If the ioctl returned -ENOTTY, then don't bother copying
> back the result as there is no point.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: <stable@vger.kernel.org>      # for v4.15 and up

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index c7f6b65d3ad7..260288ca4f55 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2900,8 +2900,11 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  
>  	/* Handles IOCTL */
>  	err = func(file, cmd, parg);
> -	if (err == -ENOIOCTLCMD)
> +	if (err == -ENOTTY || err == -ENOIOCTLCMD) {
>  		err = -ENOTTY;
> +		goto out;
> +	}
> +
>  	if (err == 0) {
>  		if (cmd == VIDIOC_DQBUF)
>  			trace_v4l2_dqbuf(video_devdata(file)->minor, parg);
> -- 
> 2.15.1
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4900 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaGRAED (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 20:04:03 -0400
Message-ID: <53C8646C.4060809@xs4all.nl>
Date: Fri, 18 Jul 2014 02:03:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Rafael van Horn <rafael.vanhorn@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: media_build wrong patch
References: <53C8606C.4000907@gmail.com>
In-Reply-To: <53C8606C.4000907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2014 01:46 AM, Rafael van Horn wrote:
> Hi,
> 
> I'd like to file a bug in the latest commit: 
> b6f4c524e0fe8f2d50b0a2f849e022adef76c6cc
> 
> The file backports/api_version.patch rejects to patch the 
> linux/drivers/media/v4l2-core/v4l2-ioctl.c because of wrong line numbers 
> and because the code doesn't match.

You are probably using the build script which downloads the code. That's
build once a day and yours is old. Try again tomorrow, it should be fine
again (or not, we're merging a lot of code, so breakages may happen for
the next few days).

Regards,

	Hans

> 
> 
> This is your code:
> -----------------------------------------------------------------------
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1009,7 +1009,7 @@ static int v4l_querycap(const struct 
> v4l2_ioctl_ops *ops,
>   	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
>   	int ret;
> 
> -	cap->version = LINUX_VERSION_CODE;
> +	cap->version = V4L2_VERSION;
> 
>   	ret = ops->vidioc_querycap(file, fh, cap);
> 
> -----------------------------------------------------------------------
> 
> This should be there:
> -----------------------------------------------------------------------
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -964,7 +964,7 @@ static int v4l_querycap(const struct v4l2_ioctl_ops 
> *ops,
>   {
>   	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
> 
> -	cap->version = LINUX_VERSION_CODE;
> +	cap->version = V4L2_VERSION;
>   	return ops->vidioc_querycap(file, fh, cap);
>   }
> 
> -----------------------------------------------------------------------
> 
> In the C file there's no ret variable and all the code is moved 
> somewhere else, but it's not @@ line 1009.
> 
> The diff file is attached.
> 
> When I hacked the patch file, I built everything.
> 
> Regards.
> Rafael van Horn
> 
> 
> 
> 
> 
> -----------------------------------------------------------------------
> 
> Debian 7.6
> gcc Version: 4:4.7.2-1
> make Version: 3.81-8.2
> perl Version: 5.14.2-21+deb7u1
> linux-headers-amd64 Version: 3.2+46
> patch Version: 2.6.1-3
> 


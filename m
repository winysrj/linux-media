Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:40337 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751860AbeEGMmi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 08:42:38 -0400
Subject: Re: [PATCH v9 14/15] v4l: Add V4L2_CAP_FENCES to drivers
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
 <20180504200612.8763-15-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1aafc4ae-2c43-a67f-e060-e3afc06c8716@xs4all.nl>
Date: Mon, 7 May 2018 14:42:35 +0200
MIME-Version: 1.0
In-Reply-To: <20180504200612.8763-15-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/05/18 22:06, Ezequiel Garcia wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Drivers that use videobuf2 are capable of using fences and
> should report that to userspace.
> 
> v9: Add in the core.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++++++
>  include/media/v4l2-fh.h              | 2 --
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index f75ad954a6f2..2ae527ef0bc7 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1002,12 +1002,20 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
>  {
>  	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
>  	struct video_device *vfd = video_devdata(file);
> +	struct v4l2_fh *vfh =
> +		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
>  	int ret;
>  
>  	cap->version = LINUX_VERSION_CODE;
>  	cap->device_caps = vfd->device_caps;
>  	cap->capabilities = vfd->device_caps | V4L2_CAP_DEVICE_CAPS;
>  
> +	/* If it has a queue or a m2m context, then the
> +	 * device supports fence synchronization.
> +	 */
> +	if (vfd->queue || (vfh && vfh->m2m_ctx))
> +		cap->device_caps |= V4L2_CAP_FENCES;

This should also be set in cap->capabilities. I would actually do this
after the ops->vidioc_querycap call to avoid drivers overwriting this
capability flag. It also should only be set if device_caps has V4L2_CAP_STREAMING
set (not all drivers do!).

Note that not all m2m drivers use m2m_ctx, so some of them might have to
set the capability manually in the driver.

> +
>  	ret = ops->vidioc_querycap(file, fh, cap);
>  
>  	cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> index ea73fef8bdc0..e993ddc06991 100644
> --- a/include/media/v4l2-fh.h
> +++ b/include/media/v4l2-fh.h
> @@ -57,9 +57,7 @@ struct v4l2_fh {
>  	unsigned int		navailable;
>  	u32			sequence;
>  
> -#if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)

I prefer is this #if was kept (so it needs to be added to v4l_querycap as well).

>  	struct v4l2_m2m_ctx	*m2m_ctx;
> -#endif
>  };
>  
>  /**
> 

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38795 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425AbcFQHMn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 03:12:43 -0400
Subject: Re: [PATCH 3/6] [media] s5p-jpeg: set capablity bus_info as required
 by VIDIOC_QUERYCAP
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
References: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
 <1466113235-25909-4-git-send-email-javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5763A2E5.5080805@xs4all.nl>
Date: Fri, 17 Jun 2016 09:12:37 +0200
MIME-Version: 1.0
In-Reply-To: <1466113235-25909-4-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 11:40 PM, Javier Martinez Canillas wrote:
> The driver doesn't set the struct v4l2_capability cap_info field so the
> v4l2-compliance tool reports the following errors for VIDIOC_QUERYCAP:
> 
> Required ioctls:
>                 VIDIOC_QUERYCAP returned 0 (Success)
>                 fail: v4l2-compliance.cpp(304): string empty
>                 fail: v4l2-compliance.cpp(528): check_ustring(vcap.bus_info, sizeof(vcap.bus_info))
>         test VIDIOC_QUERYCAP: FAIL
> 
> This patch fixes by setting the field in VIDIOC_QUERYCAP ioctl handler:
> 
> Required ioctls:
>                 VIDIOC_QUERYCAP returned 0 (Success)
>         test VIDIOC_QUERYCAP: OK
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

Hans

> ---
> 
>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 17bc94092864..e3ff3d4bd72e 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1256,7 +1256,8 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
>  		strlcpy(cap->card, S5P_JPEG_M2M_NAME " decoder",
>  			sizeof(cap->card));
>  	}
> -	cap->bus_info[0] = 0;
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(ctx->jpeg->dev));
>  	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
>  	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>  	return 0;
> 

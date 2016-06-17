Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33064 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbcFQGp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 02:45:58 -0400
Message-id: <57639CA3.5010105@samsung.com>
Date: Fri, 17 Jun 2016 08:45:55 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] [media] s5p-jpeg: set capablity bus_info as required
 by VIDIOC_QUERYCAP
References: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
 <1466113235-25909-4-git-send-email-javier@osg.samsung.com>
In-reply-to: <1466113235-25909-4-git-send-email-javier@osg.samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On 06/16/2016 11:40 PM, Javier Martinez Canillas wrote:
> The driver doesn't set the struct v4l2_capability cap_info field so the
> v4l2-compliance tool reports the following errors for VIDIOC_QUERYCAP:
>
> Required ioctls:
>                  VIDIOC_QUERYCAP returned 0 (Success)
>                  fail: v4l2-compliance.cpp(304): string empty
>                  fail: v4l2-compliance.cpp(528): check_ustring(vcap.bus_info, sizeof(vcap.bus_info))
>          test VIDIOC_QUERYCAP: FAIL
>
> This patch fixes by setting the field in VIDIOC_QUERYCAP ioctl handler:
>
> Required ioctls:
>                  VIDIOC_QUERYCAP returned 0 (Success)
>          test VIDIOC_QUERYCAP: OK
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
>
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 17bc94092864..e3ff3d4bd72e 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1256,7 +1256,8 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
>   		strlcpy(cap->card, S5P_JPEG_M2M_NAME " decoder",
>   			sizeof(cap->card));
>   	}
> -	cap->bus_info[0] = 0;
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(ctx->jpeg->dev));
>   	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
>   	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>   	return 0;
>

Acked-by: Jacek Anaszewski <j.anaszewski@samsung.com>

-- 
Best regards,
Jacek Anaszewski

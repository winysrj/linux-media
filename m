Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61915 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab2KSUG4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 15:06:56 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so2115455bkw.19
        for <linux-media@vger.kernel.org>; Mon, 19 Nov 2012 12:06:55 -0800 (PST)
Message-ID: <50AA915D.5020304@gmail.com>
Date: Mon, 19 Nov 2012 21:06:53 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, sw0312.kim@samsung.com
Subject: Re: [PATCH] exynos-gsc: Add missing video device vfl_dir flag initialization
References: <1352588276-16260-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1352588276-16260-1-git-send-email-sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

Could you let us know if the driver is working fine with this patch
applied ? I have no exynos5 based board to test it. And this patch
qualifies as an important fix that should be applied for v3.7, where
the driver's first appeared.

Thanks,
Sylwester

On 11/10/2012 11:57 PM, Sylwester Nawrocki wrote:
> vfl_dir should be set to VFL_DIR_M2M so valid ioctls for this
> mem-to-mem device can be properly determined in the v4l2 core.
>
> Cc: Shaik Ameer Basha<shaik.ameer@samsung.com>
> Signed-off-by: Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
> ---
> I didn't run-time test this patch.
>
>   drivers/media/platform/exynos-gsc/gsc-m2m.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> index 3c7f005..88642a8 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> @@ -732,6 +732,7 @@ int gsc_register_m2m_device(struct gsc_dev *gsc)
>   	gsc->vdev.ioctl_ops	=&gsc_m2m_ioctl_ops;
>   	gsc->vdev.release	= video_device_release_empty;
>   	gsc->vdev.lock		=&gsc->lock;
> +	gsc->vdev.vfl_dir	= VFL_DIR_M2M;
>   	snprintf(gsc->vdev.name, sizeof(gsc->vdev.name), "%s.%d:m2m",
>   					GSC_MODULE_NAME, gsc->id);
>
> --
> 1.7.4.1
>

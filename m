Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab1GNQCv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 12:02:51 -0400
Message-ID: <4E1F1323.1010007@redhat.com>
Date: Thu, 14 Jul 2011 13:02:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 5/8] v4l: fix v4l_fill_dv_preset_info function
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com> <1309351877-32444-6-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1309351877-32444-6-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-06-2011 09:51, Tomasz Stanislawski escreveu:
> The function fills struct v4l2_dv_enum_preset with appropriate
> preset parameters but it forgets to zero field named reserved.
> This patch fixes this bug.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  drivers/media/video/v4l2-common.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
> index 003e648..e7c02e9 100644
> --- a/drivers/media/video/v4l2-common.c
> +++ b/drivers/media/video/v4l2-common.c
> @@ -592,6 +592,8 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
>  	info->width = dv_presets[preset].width;
>  	info->height = dv_presets[preset].height;
>  	strlcpy(info->name, dv_presets[preset].name, sizeof(info->name));
> +	/* assure that reserved fields are zeroed */
> +	memset(info->reserved, 0, sizeof(info->reserved));
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);

This patch is not needed, except if you're doing a different logic.
v4l2-ioctl makes sure of cleaning the reserved and write fields from
the structs before passing the syscall to the drivers.

So, if you're filling data from an userspace call, you don't need to
use. If you're instead allocating data, use *zalloc calls.

Cheers,
Mauro

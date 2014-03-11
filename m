Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1810 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbaCKMDp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 08:03:45 -0400
Message-ID: <531EFB6E.9060700@xs4all.nl>
Date: Tue, 11 Mar 2014 13:02:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: k.debski@samsung.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 03/14] v4l: ti-vpe: Use video_device_release_empty
References: <1393922965-15967-1-git-send-email-archit@ti.com> <1394526833-24805-1-git-send-email-archit@ti.com> <1394526833-24805-4-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-4-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/14 09:33, Archit Taneja wrote:
> The video_device struct is currently embedded in the driver data struct vpe_dev.
> A vpe_dev instance is allocated by the driver, and the memory for the vfd is a
> part of this struct.
> 
> The v4l2 core, however, manages the removal of the vfd region, through the
> video_device's .release() op, which currently is the helper
> video_device_release. This causes memory corruption, and leads to issues when
> we try to re-insert the vpe module.
> 
> Use the video_device_release_empty helper function instead
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/platform/ti-vpe/vpe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index f1eae67..0363df6 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -2000,7 +2000,7 @@ static struct video_device vpe_videodev = {
>  	.fops		= &vpe_fops,
>  	.ioctl_ops	= &vpe_ioctl_ops,
>  	.minor		= -1,
> -	.release	= video_device_release,
> +	.release	= video_device_release_empty,
>  	.vfl_dir	= VFL_DIR_M2M,
>  };
>  
> 


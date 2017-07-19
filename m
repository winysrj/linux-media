Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34159 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753761AbdGSJgM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 05:36:12 -0400
Subject: Re: [PATCH v2 1/2] media: platform: davinci: prepare for removal of
 VPFE_CMD_S_CCDC_RAW_PARAMS ioctl
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>
References: <1500452494-15879-1-git-send-email-prabhakar.csengg@gmail.com>
 <1500452494-15879-2-git-send-email-prabhakar.csengg@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Sekhar Nori <nsekhar@ti.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b36c5f5d-afda-b140-1760-c684be512fe0@xs4all.nl>
Date: Wed, 19 Jul 2017 11:36:09 +0200
MIME-Version: 1.0
In-Reply-To: <1500452494-15879-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/07/17 10:21, Lad, Prabhakar wrote:
> preparing for removal of VPFE_CMD_S_CCDC_RAW_PARAMS ioctl having
> minimalistic code changes so as it can be applied for backports.

The code is good (and can be applied from 3.7 onwards), but the commit
log needs work.

Since this patch is going to be backported this log needs to say why this
is done and make a note that this ioctl was never in the public api and was
only defined in a kernel-space header.

That last item needs to be in the commit log of patch 2/2 as well.

Also note in both patches that this ioctl is no longer in use anyway.

Regards,

	Hans

> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpfe_capture.c | 22 ++--------------------
>  1 file changed, 2 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index e3fe3e0..1831bf5 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -1719,27 +1719,9 @@ static long vpfe_param_handler(struct file *file, void *priv,
>  
>  	switch (cmd) {
>  	case VPFE_CMD_S_CCDC_RAW_PARAMS:
> +		ret = -EINVAL;
>  		v4l2_warn(&vpfe_dev->v4l2_dev,
> -			  "VPFE_CMD_S_CCDC_RAW_PARAMS: experimental ioctl\n");
> -		if (ccdc_dev->hw_ops.set_params) {
> -			ret = ccdc_dev->hw_ops.set_params(param);
> -			if (ret) {
> -				v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> -					"Error setting parameters in CCDC\n");
> -				goto unlock_out;
> -			}
> -			ret = vpfe_get_ccdc_image_format(vpfe_dev,
> -							 &vpfe_dev->fmt);
> -			if (ret < 0) {
> -				v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> -					"Invalid image format at CCDC\n");
> -				goto unlock_out;
> -			}
> -		} else {
> -			ret = -EINVAL;
> -			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> -				"VPFE_CMD_S_CCDC_RAW_PARAMS not supported\n");
> -		}
> +			"VPFE_CMD_S_CCDC_RAW_PARAMS not supported\n");
>  		break;
>  	default:
>  		ret = -ENOTTY;
> 

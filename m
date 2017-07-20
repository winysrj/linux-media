Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52489 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936035AbdGTLbb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 07:31:31 -0400
Subject: Re: [v3 1/2] media: platform: davinci: prepare for removal of
 VPFE_CMD_S_CCDC_RAW_PARAMS ioctl
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>
References: <1500540991-27430-1-git-send-email-prabhakar.csengg@gmail.com>
 <1500540991-27430-2-git-send-email-prabhakar.csengg@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Sekhar Nori <nsekhar@ti.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2f4d77fb-cddd-9f8c-02c6-09f40213ec1c@xs4all.nl>
Date: Thu, 20 Jul 2017 13:31:28 +0200
MIME-Version: 1.0
In-Reply-To: <1500540991-27430-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/07/17 10:56, Lad, Prabhakar wrote:
> preparing for removal of VPFE_CMD_S_CCDC_RAW_PARAMS ioctl from

You don't really prepare for removal. You make sure VPFE_CMD_S_CCDC_RAW_PARAMS
no longer works with a minimal patch suitable for backporting.

> davicni vpfe_capture driver because of following reasons:

davicni -> davinci

> 
> - This ioctl was never in public api and was only defined in kernel header.
> - The function set_params constantly mixes up pointers and phys_addr_t
>   numbers.
> - This is part of a 'VPFE_CMD_S_CCDC_RAW_PARAMS' ioctl command that is
>   described as an 'experimental ioctl that will change in future kernels'.
> - The code to allocate the table never gets called after we copy_from_user
>   the user input over the kernel settings, and then compare them
>   for inequality.
> - We then go on to use an address provided by user space as both the
>   __user pointer for input and pass it through phys_to_virt to come up
>   with a kernel pointer to copy the data to. This looks like a trivially
>   exploitable root hole.

Add something like:

"Due to these reasons we make sure this ioctl now returns -EINVAL and backport
this patch as far as possible."

Regards,

	Hans

> 
> Fixes: 5f15fbb68fd7 ("V4L/DVB (12251): v4l: dm644x ccdc module for vpfe capture driver")
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

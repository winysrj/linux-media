Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36061 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbaJHKYe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 06:24:34 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND400K8SFPMIC70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 11:27:22 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Kiran AVND' <avnd.kiran@samsung.com>, linux-media@vger.kernel.org
Cc: wuchengli@chromium.org, posciak@chromium.org, arun.m@samsung.com,
	ihf@chromium.org, prathyush.k@samsung.com, arun.kk@samsung.com,
	kiran@chromium.org, Andrzej Hajda <a.hajda@samsung.com>
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
 <1411707142-4881-15-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1411707142-4881-15-git-send-email-avnd.kiran@samsung.com>
Subject: RE: [PATCH v2 14/14] [media] s5p-mfc: Don't change the image size to
 smaller than the request.
Date: Wed, 08 Oct 2014 12:24:30 +0200
Message-id: <11f301cfe2e2$0cacc810$26065830$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patch seems complicated and I do not understand your motives.

Could you explain what is the problem with the current aligning of the
values?
Is this a hardware problem? Which MFC version does it affect?
Is it a software problem? If so, maybe the user space application should
take extra care on what value it passes/receives to try_fmt?

> From: Kiran AVND [mailto:avnd.kiran@samsung.com]
> Sent: Friday, September 26, 2014 6:52 AM
> To: linux-media@vger.kernel.org
> Cc: k.debski@samsung.com; wuchengli@chromium.org; posciak@chromium.org;
> arun.m@samsung.com; ihf@chromium.org; prathyush.k@samsung.com;
> arun.kk@samsung.com; kiran@chromium.org
> Subject: [PATCH v2 14/14] [media] s5p-mfc: Don't change the image size
> to smaller than the request.
> 
> From: Wu-Cheng Li <wuchengli@chromium.org>
> 
> Use the requested size as the minimum bound, unless it's less than the
> required hardware minimum. The bound align function will align to the
> closest value but we do not want to adjust below the requested size.

This patch does also change the alignment. This is not mentioned in the
commit
message (!). It was 2, now it enforces 16. Could you justify this?
If I remember correctly having even number was enough for MFC v5 encoder
to work properly.

> Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 407dc63..7b48180 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -1056,6 +1056,7 @@ static int vidioc_try_fmt(struct file *file, void
> *priv, struct v4l2_format *f)
>  	struct s5p_mfc_dev *dev = video_drvdata(file);
>  	struct s5p_mfc_fmt *fmt;
>  	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> +	u32 min_w, min_h;
> 
>  	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>  		fmt = find_format(f, MFC_FMT_ENC);
> @@ -1090,8 +1091,16 @@ static int vidioc_try_fmt(struct file *file,
> void *priv, struct v4l2_format *f)
>  			return -EINVAL;
>  		}
> 
> -		v4l_bound_align_image(&pix_fmt_mp->width, 8, 1920, 1,
> -			&pix_fmt_mp->height, 4, 1080, 1, 0);
> +		/*
> +		 * Use the requested size as the minimum bound, unless it's
> less
> +		 * than the required hardware minimum. The bound align
> function
> +		 * will align to the closest value but we do not want to
> adjust
> +		 * below the requested size.

Other drivers use v4l2_bound_align and user space apps can cope with
the driver returning a value that is below the requested value.

> +		 */
> +		min_w = min(max(16u, pix_fmt_mp->width), 1920u);
> +		min_h = min(max(16u, pix_fmt_mp->height), 1088u);
> +		v4l_bound_align_image(&pix_fmt_mp->width, min_w, 1920, 4,
> +			&pix_fmt_mp->height, min_h, 1088, 4, 0);
>  	} else {
>  		mfc_err("invalid buf type\n");
>  		return -EINVAL;
> --
> 1.7.9.5


Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


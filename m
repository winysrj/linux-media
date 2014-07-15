Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47461 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107AbaGOKwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 06:52:19 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8R005H826KXE00@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 Jul 2014 11:51:57 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'panpan liu' <panpan1.liu@samsung.com>, kyungmin.park@samsung.com,
	jtp.park@samsung.com, mchehab@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1405393670-2808-1-git-send-email-panpan1.liu@samsung.com>
In-reply-to: <1405393670-2808-1-git-send-email-panpan1.liu@samsung.com>
Subject: RE: [PATCH] s5p-mfc: limit the size of the CPB
Date: Tue, 15 Jul 2014 12:51:16 +0200
Message-id: <000001cfa01a$bb569040$3203b0c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please also rebase the patches onto the master branch of the media tree.

http://git.linuxtv.org/cgit.cgi/media_tree.git/

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: panpan liu [mailto:panpan1.liu@samsung.com]
> Sent: Tuesday, July 15, 2014 5:08 AM
> To: kyungmin.park@samsung.com; k.debski@samsung.com;
> jtp.park@samsung.com; mchehab@redhat.com
> Cc: linux-arm-kernel@lists.infradead.org; linux-media@vger.kernel.org
> Subject: [PATCH] s5p-mfc: limit the size of the CPB
> 
> The CPB size is limited by the hardware. Add this limit to the s_fmt.
> 
> Signed-off-by: panpan liu <panpan1.liu@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)  mode change 100644 =>
> 100755 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> old mode 100644
> new mode 100755
> index 0bae907..70b9458
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -413,7 +413,8 @@ static int vidioc_s_fmt(struct file *file, void
> *priv, struct v4l2_format *f)
>  	int ret = 0;
>  	struct s5p_mfc_fmt *fmt;
>  	struct v4l2_pix_format_mplane *pix_mp;
> -
> +	struct s5p_mfc_buf_size *buf_size = dev->variant->buf_size;
> +
>  	mfc_debug_enter();
>  	ret = vidioc_try_fmt(file, priv, f);
>  	pix_mp = &f->fmt.pix_mp;
> @@ -466,11 +467,13 @@ static int vidioc_s_fmt(struct file *file, void
> *priv, struct v4l2_format *f)
>  	mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
>  	pix_mp->height = 0;
>  	pix_mp->width = 0;
> -	if (pix_mp->plane_fmt[0].sizeimage)
> -		ctx->dec_src_buf_size = pix_mp->plane_fmt[0].sizeimage;
> -	else
> +	if (pix_mp->plane_fmt[0].sizeimage == 0)
>  		pix_mp->plane_fmt[0].sizeimage = ctx->dec_src_buf_size =
>
DEF_CPB_SIZE;
> +	else if(pix_mp->plane_fmt[0].sizeimage > buf_size->cpb)
> +		ctx->dec_src_buf_size = buf_size->cpb;
> +	else
> +		ctx->dec_src_buf_size = pix_mp->plane_fmt[0].sizeimage;
>  	pix_mp->plane_fmt[0].bytesperline = 0;
>  	ctx->state = MFCINST_INIT;
>  out:
> --
> 1.7.9.5


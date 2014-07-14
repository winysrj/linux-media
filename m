Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36096 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaGNJ3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 05:29:20 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8P00CO03OSSC20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Jul 2014 10:29:16 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'panpan liu' <panpan1.liu@samsung.com>, kyungmin.park@samsung.com,
	jtp.park@samsung.com, mchehab@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1405322547-3216-1-git-send-email-panpan1.liu@samsung.com>
In-reply-to: <1405322547-3216-1-git-send-email-panpan1.liu@samsung.com>
Subject: RE: [PATCH] s5p-mfc: limit the size of the CPB
Date: Mon, 14 Jul 2014 11:29:16 +0200
Message-id: <122f01cf9f46$15d03f10$4170bd30$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi panpan,

Thank you for your patch, please find my comments inline.

> From: panpan liu [mailto:panpan1.liu@samsung.com]
> Sent: Monday, July 14, 2014 9:22 AM
> 
> The register of the CPB limits the size. The max size is 4M, so it is
> more reasonable.
> 
> Signed-off-by: panpan liu <panpan1.liu@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)  mode change 100644 =>
> 100755 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> old mode 100644
> new mode 100755
> index 0bae907..889cb06
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -466,7 +466,8 @@ static int vidioc_s_fmt(struct file *file, void
> *priv, struct v4l2_format *f)
>  	mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
>  	pix_mp->height = 0;
>  	pix_mp->width = 0;
> -	if (pix_mp->plane_fmt[0].sizeimage)
> +	if (pix_mp->plane_fmt[0].sizeimage &&
> +			pix_mp->plane_fmt[0].sizeimage <= MAX_CPB_SIZE)

The MAX_CPB_SIZE applies only to the v5 version of the MFC. To have this
dependent on the actual variant used please use:
...
struct s5p_mfc_buf_size *buf_size = dev->variant->buf_size;
...
if (pix_mp->plane_fmt[0].sizeimage &&
	pix_mp->plane_fmt[0].sizeimage <= buf_size->cpb)
...

>  		ctx->dec_src_buf_size = pix_mp->plane_fmt[0].sizeimage;
>  	else
>  		pix_mp->plane_fmt[0].sizeimage = ctx->dec_src_buf_size =

Also, in case the desired buffer size is too large the driver should set
the maximum size allowed and not the default size which is fairly small.

So you should cover three cases:
- no size set -> set default size
- size set < max - set the desired size
- size set > max - set the maximum size allowed

Best wishes, 
-- 
Kamil Debski
Samsung R&D Institute Poland


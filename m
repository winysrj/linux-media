Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B54BC64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 22:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DB1820989
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 22:39:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DB1820989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=collabora.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbeLFWjy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 17:39:54 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55872 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbeLFWjy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 17:39:54 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id E1D40260B79
Message-ID: <80e6ccf201a0e956997651ae8cf698c0b7a9621f.camel@collabora.com>
Subject: Re: [PATCH v2] media: rockchip vpu: remove some unused vars
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Date:   Thu, 06 Dec 2018 19:39:44 -0300
In-Reply-To: <10b532d7f12ef0718028a3ecb4f00974ebd80c4c.1544054436.git.mchehab+samsung@kernel.org>
References: <10b532d7f12ef0718028a3ecb4f00974ebd80c4c.1544054436.git.mchehab+samsung@kernel.org>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 2018-12-05 at 19:01 -0500, Mauro Carvalho Chehab wrote:
> As complained by gcc:
> 
> 	drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c: In function 'rk3288_vpu_jpeg_enc_set_qtable':
> 	drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c:70:10: warning: variable 'chroma_qtable_p' set but not used [-Wunused-but-set-
> variable]
> 	  __be32 *chroma_qtable_p;
> 	          ^~~~~~~~~~~~~~~
> 	drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c:69:10: warning: variable 'luma_qtable_p' set but not used [-Wunused-but-set-
> variable]
> 	  __be32 *luma_qtable_p;
> 	          ^~~~~~~~~~~~~
> 	drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c: In function 'rk3399_vpu_jpeg_enc_set_qtable':
> 	drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c:101:10: warning: variable 'chroma_qtable_p' set but not used [-Wunused-but-set-
> variable]
> 	  __be32 *chroma_qtable_p;
> 	          ^~~~~~~~~~~~~~~
> 	drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c:100:10: warning: variable 'luma_qtable_p' set but not used [-Wunused-but-set-
> variable]
> 	  __be32 *luma_qtable_p;
> 	          ^~~~~~~~~~~~~
> 	drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c: In function 'rockchip_vpu_queue_setup':
> 	drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c:522:33: warning: variable 'vpu_fmt' set but not used [-Wunused-but-set-variable]
> 	  const struct rockchip_vpu_fmt *vpu_fmt;
> 	                                 ^~~~~~~
> 	drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c: In function 'rockchip_vpu_buf_prepare':
> 	drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c:560:33: warning: variable 'vpu_fmt' set but not used [-Wunused-but-set-variable]
> 	  const struct rockchip_vpu_fmt *vpu_fmt;
> 	                                 ^~~~~~~
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Ezequiel Garcia <ezequiel@collabora.com>

Thanks!


> ---
>  drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c | 5 -----
>  drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c | 5 -----
>  drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c       | 6 ------
>  3 files changed, 16 deletions(-)
> 
> diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> index e27c10855de5..5282236d1bb1 100644
> --- a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> +++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> @@ -66,13 +66,8 @@ rk3288_vpu_jpeg_enc_set_qtable(struct rockchip_vpu_dev *vpu,
>  			       unsigned char *luma_qtable,
>  			       unsigned char *chroma_qtable)
>  {
> -	__be32 *luma_qtable_p;
> -	__be32 *chroma_qtable_p;
>  	u32 reg, i;
>  
> -	luma_qtable_p = (__be32 *)luma_qtable;
> -	chroma_qtable_p = (__be32 *)chroma_qtable;
> -
>  	for (i = 0; i < VEPU_JPEG_QUANT_TABLE_COUNT; i++) {
>  		reg = get_unaligned_be32(&luma_qtable[i]);
>  		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_LUMA_QUAT(i));
> diff --git a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> index 5f75e4d11d76..dbc86d95fe3b 100644
> --- a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> +++ b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> @@ -97,13 +97,8 @@ rk3399_vpu_jpeg_enc_set_qtable(struct rockchip_vpu_dev *vpu,
>  			       unsigned char *luma_qtable,
>  			       unsigned char *chroma_qtable)
>  {
> -	__be32 *luma_qtable_p;
> -	__be32 *chroma_qtable_p;
>  	u32 reg, i;
>  
> -	luma_qtable_p = (__be32 *)luma_qtable;
> -	chroma_qtable_p = (__be32 *)chroma_qtable;
> -
>  	for (i = 0; i < VEPU_JPEG_QUANT_TABLE_COUNT; i++) {
>  		reg = get_unaligned_be32(&luma_qtable[i]);
>  		vepu_write_relaxed(vpu, reg, VEPU_REG_JPEG_LUMA_QUAT(i));
> diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
> index 038a7136d5d1..ab0fb2053620 100644
> --- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
> +++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
> @@ -519,17 +519,14 @@ rockchip_vpu_queue_setup(struct vb2_queue *vq,
>  			 struct device *alloc_devs[])
>  {
>  	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
> -	const struct rockchip_vpu_fmt *vpu_fmt;
>  	struct v4l2_pix_format_mplane *pixfmt;
>  	int i;
>  
>  	switch (vq->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> -		vpu_fmt = ctx->vpu_dst_fmt;
>  		pixfmt = &ctx->dst_fmt;
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> -		vpu_fmt = ctx->vpu_src_fmt;
>  		pixfmt = &ctx->src_fmt;
>  		break;
>  	default:
> @@ -557,7 +554,6 @@ static int rockchip_vpu_buf_prepare(struct vb2_buffer *vb)
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct vb2_queue *vq = vb->vb2_queue;
>  	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
> -	const struct rockchip_vpu_fmt *vpu_fmt;
>  	struct v4l2_pix_format_mplane *pixfmt;
>  	unsigned int sz;
>  	int ret = 0;
> @@ -565,11 +561,9 @@ static int rockchip_vpu_buf_prepare(struct vb2_buffer *vb)
>  
>  	switch (vq->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> -		vpu_fmt = ctx->vpu_dst_fmt;
>  		pixfmt = &ctx->dst_fmt;
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> -		vpu_fmt = ctx->vpu_src_fmt;
>  		pixfmt = &ctx->src_fmt;
>  
>  		if (vbuf->field == V4L2_FIELD_ANY)



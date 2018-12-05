Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA75C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02CA8208E7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02CA8208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbeLESsh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 13:48:37 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:56428 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727349AbeLESsh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 13:48:37 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id UcDigS9JXO44XUcDlgRD5L; Wed, 05 Dec 2018 19:48:35 +0100
Subject: Re: [PATCH] media: rockchip/vpu: fix a few alignments
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
References: <bcebf81255a71b34541bc00bcb505e815193f0be.1544035391.git.mchehab+samsung@kernel.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <45972676-265a-51ce-c9eb-ff49f8eab5bb@xs4all.nl>
Date:   Wed, 5 Dec 2018 19:48:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <bcebf81255a71b34541bc00bcb505e815193f0be.1544035391.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEG44pmZ0sP0oQ4vQyIuoULKsD44URqjxKVgka6KtJxoiVXzEUZ564GoMFfzTLmCzzCQsOa3v72rlK97CLq5Mh6z2f+hZoQ2bsuXFgjHSLGknyRdO6pT
 KIUEkBoAPwrLzCqiCIwT9o0l+jQPH4pbOG969gR6lE3fzUfyRpPVBLW6uyd+Yacf0SA0H3daP+8XZOOPizSmqvAkfuBx5FgAeEAUmlPDOaE8tgL2CKShU/cb
 7lSEXSlL4loEPMupCgcdxjfm2D0H6Fx1GH9BKjhCE2UOQp1tskkMcvi+hD9Dda/3jyOLGWdmul3pGZ8OQg1tsVsr3NA8R/IiEavGWwi321kuHDnwawAuarHv
 JtM7UzRJPcTHK/luSl4RP2z6gV+RmhksW9iW4OguPi4/siMbWfFymQ5cUKelN/AGg0DBE84PDvanB1CQhH0obiZ35nR/QOfvf3dJKRE3gclQBWW7sZlIesBO
 PagHXBXx+3hfBl7mrHD+G9PuDfDhZGYwKYmm7g==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/05/2018 07:43 PM, Mauro Carvalho Chehab wrote:
> As reported by checkpatch.pl, some function calls have a wrong
> alignment.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c | 4 ++--
>  drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> index 8919151e1631..e27c10855de5 100644
> --- a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> +++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> @@ -106,8 +106,8 @@ void rk3288_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
>  	rk3288_vpu_set_src_img_ctrl(vpu, ctx);
>  	rk3288_vpu_jpeg_enc_set_buffers(vpu, ctx, src_buf);
>  	rk3288_vpu_jpeg_enc_set_qtable(vpu,
> -		rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> -		rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
> +				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> +				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));

But now you get warnings because this is > 80 columns.

I think the 'cure' is worse than the disease.

I see this is already merged, but I don't think this patch improves readability,
which is more important than a checkpatch warning IMHO.

Regards,

	Hans

>  
>  	reg = VEPU_REG_AXI_CTRL_OUTPUT_SWAP16
>  		| VEPU_REG_AXI_CTRL_INPUT_SWAP16
> diff --git a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> index 8afa2162bf9f..5f75e4d11d76 100644
> --- a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> +++ b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> @@ -137,8 +137,8 @@ void rk3399_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
>  	rk3399_vpu_set_src_img_ctrl(vpu, ctx);
>  	rk3399_vpu_jpeg_enc_set_buffers(vpu, ctx, src_buf);
>  	rk3399_vpu_jpeg_enc_set_qtable(vpu,
> -			rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> -			rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
> +				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> +				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
>  
>  	reg = VEPU_REG_OUTPUT_SWAP32
>  		| VEPU_REG_OUTPUT_SWAP16
> 


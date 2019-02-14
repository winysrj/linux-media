Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5DBC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 09:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5213222A4
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 09:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394905AbfBNJAE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 04:00:04 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:45644 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728448AbfBNJAD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 04:00:03 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id uCsAgJ75nLMwIuCsDgOnS0; Thu, 14 Feb 2019 10:00:01 +0100
Subject: Re: [PATCH] media: cedrus: Forbid setting new formats on busy queues
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20190214083731.16230-1-paul.kocialkowski@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3b24ac73-f891-533f-8563-fe38ba4a83ca@xs4all.nl>
Date:   Thu, 14 Feb 2019 09:59:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190214083731.16230-1-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOsf53XHYJRoioOKRCLVSF4nXeOBGx7bZjwrFrcoYA6HjM6UjeAluv/3n9Wz55fjd0dyOVIXH8JlgiPqvS6iPRazSpO6Qv7WYC2XYwnwIlg4pugjq1UW
 ihPWW4QXWOyPdkNrYqOhWvryWE0EfqtS1hsbEwEqtBMm4CdIoK41aQIOtYHlzf0PLJfZZ8DxWVzW5qMA3c+21UicJ9UljHt77ROTsmG1Pc6vCRN9TLjsntWJ
 ch+WKQUcN27ykfm7ve+g/Q5SUHW5yu2eosE4oPE8LSUz4mdiBqu4tNdqSqk1ZEklhlgA8SLsYbAU/4zQl9rGCTmoZxl524/3IeUwPma42s5GkYcTb/zMzznH
 H72Yo0PoLVGm6n9UTOoMWvzqWztCxTnsCCb9ZuRSJwqmXJbHIlTraNnfwV9cCiy55o5KJEmGxoGzvbGkQ4i6e4Tsf3vq/otaB/KthZ5GZIpBScHaYH1icZxk
 pJSkZX4iNPQrwugD
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/14/19 9:37 AM, Paul Kocialkowski wrote:
> Check that our queues are not busy before setting the format or return
> EBUSY if that's the case. This ensures that our format can't change
> once buffers are allocated for the queue.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  drivers/staging/media/sunxi/cedrus/cedrus_video.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> index b5cc79389d67..3420a938a613 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> @@ -282,8 +282,15 @@ static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
>  {
>  	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
>  	struct cedrus_dev *dev = ctx->dev;
> +	struct vb2_queue *vq;
>  	int ret;
>  
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;

Can this ever happen?

Regards,

	Hans

> +	else if (vb2_is_busy(vq))
> +		return -EBUSY;
> +
>  	ret = cedrus_try_fmt_vid_cap(file, priv, f);
>  	if (ret)
>  		return ret;
> @@ -299,8 +306,15 @@ static int cedrus_s_fmt_vid_out(struct file *file, void *priv,
>  				struct v4l2_format *f)
>  {
>  	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
> +	struct vb2_queue *vq;
>  	int ret;
>  
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +	else if (vb2_is_busy(vq))
> +		return -EBUSY;
> +
>  	ret = cedrus_try_fmt_vid_out(file, priv, f);
>  	if (ret)
>  		return ret;
> 


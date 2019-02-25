Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931E9C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 09:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AA2020842
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 09:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfBYJOR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 04:14:17 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:45066 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbfBYJOR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 04:14:17 -0500
Received: from [IPv6:2001:983:e9a7:1:187c:1a74:db21:99] ([IPv6:2001:983:e9a7:1:187c:1a74:db21:99])
        by smtp-cloud8.xs4all.net with ESMTPA
        id yCKzgK5qq4HFnyCL1gJUjH; Mon, 25 Feb 2019 10:14:15 +0100
Subject: Re: [PATCH v3 04/18] media: vicodec: selection api should only check
 signal buffer types
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190224090234.19723-1-dafna3@gmail.com>
 <20190224090234.19723-5-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d0a2f503-622c-b4c3-ea65-c3aa307f1672@xs4all.nl>
Date:   Mon, 25 Feb 2019 10:14:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190224090234.19723-5-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfACx0wt/zcW48sD4xMZaYokQF5q0LOCS9a53e6njYtXTWKb3L8gUvwGWAZ+n++0iyX672gSRXWJbm9t7RjlU0yKE/51Wn8c2af9sBEyKR2nxFYOjqsMm
 C6rzlm4QBIolip8TH643zC8GJGlX5M7P0CusIKctHVd+ywL9fPemP+3YIzS8PpOF4BeXbu04BhHCg4OMzwLv1k33HcBcZ5hvOD4eBps8XAjjAo+hGlGzpfFd
 JXEu05pUj9pa+Cn5JHt5UpfvUzCpSaAG1EWjTQXXIlM6imo2+McyvuEeW5mzJ1bszDaZRXLTqDtaycZ+9HKWV7QBJffeRFvie7kGEeCCdk0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/24/19 10:02 AM, Dafna Hirschfeld wrote:
> The selection api should check only signal buffer types
> because multiplanar types are converted to
> signal in drivers/media/v4l2-core/v4l2-ioctl.c

signal -> single (also in the subject of this patch)

Regards,

	Hans

> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 20 +++----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index d7636fe9e174..b92a91e06e18 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -945,16 +945,6 @@ static int vidioc_g_selection(struct file *file, void *priv,
>  {
>  	struct vicodec_ctx *ctx = file2ctx(file);
>  	struct vicodec_q_data *q_data;
> -	enum v4l2_buf_type valid_cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	enum v4l2_buf_type valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> -
> -	if (multiplanar) {
> -		valid_cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> -		valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> -	}
> -
> -	if (s->type != valid_cap_type && s->type != valid_out_type)
> -		return -EINVAL;
>  
>  	q_data = get_q_data(ctx, s->type);
>  	if (!q_data)
> @@ -963,8 +953,8 @@ static int vidioc_g_selection(struct file *file, void *priv,
>  	 * encoder supports only cropping on the OUTPUT buffer
>  	 * decoder supports only composing on the CAPTURE buffer
>  	 */
> -	if ((ctx->is_enc && s->type == valid_out_type) ||
> -	    (!ctx->is_enc && s->type == valid_cap_type)) {
> +	if ((ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ||
> +	    (!ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
>  		switch (s->target) {
>  		case V4L2_SEL_TGT_COMPOSE:
>  		case V4L2_SEL_TGT_CROP:
> @@ -992,12 +982,8 @@ static int vidioc_s_selection(struct file *file, void *priv,
>  {
>  	struct vicodec_ctx *ctx = file2ctx(file);
>  	struct vicodec_q_data *q_data;
> -	enum v4l2_buf_type out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> -
> -	if (multiplanar)
> -		out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>  
> -	if (s->type != out_type)
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  		return -EINVAL;
>  
>  	q_data = get_q_data(ctx, s->type);
> 


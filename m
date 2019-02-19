Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55969C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 09:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B3902146E
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 09:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfBSJvG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:51:06 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:45224 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbfBSJvG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 04:51:06 -0500
Received: from [IPv6:2001:420:44c1:2579:b8fa:fb10:b19b:d205] ([IPv6:2001:420:44c1:2579:b8fa:fb10:b19b:d205])
        by smtp-cloud9.xs4all.net with ESMTPA
        id w23IgYSG1I8AWw23MgF2St; Tue, 19 Feb 2019 10:51:04 +0100
Subject: Re: [PATCH] media: vicodec: selection api should not care about
 signal/multiplanar
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190219094300.7471-1-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c721dbc2-41f1-034a-3202-b836ed080d49@xs4all.nl>
Date:   Tue, 19 Feb 2019 10:51:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190219094300.7471-1-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCq8a4G7A7XIGxhk4PKi1pHSXI6rqCIVSOj2lO6uKGyN5UbQtp4rxM3PtUatjOx1LBV/SlEjn/imYBOzp/3TLNgE49zQ1pKWcr92EbB3AmUqQr6aFxB1
 wedZOVKSpxpXMm7ecss30FljHvJ6cO0f7msnaTkV5YkvreZ6Bk5xbLLZ7zHZouoxV6YlAPvGL6Pbn1BeFaaDjsj69YBTrPXHI8d2SCjCYRbwydgWnoPCdzZD
 Xl/Rd7Y6kmyo671jIs3pfPoCWGDMBJE5jSvfdF0TNXdP5pYcaJMu9e8WEKCYDXLJPSZIL42aAiYrFh2L8vQ27GmLqUowbONkuPUTWRRqwFgNTsCWA2G9j7Rd
 Td7+9+/9
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/19/19 10:43 AM, Dafna Hirschfeld wrote:
> Change the selection api to always accept both signal and
> multiplanar buffer types.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 25 +++++++------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index d7636fe9e174..12692aa101fe 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -945,16 +945,12 @@ static int vidioc_g_selection(struct file *file, void *priv,
>  {
>  	struct vicodec_ctx *ctx = file2ctx(file);
>  	struct vicodec_q_data *q_data;
> -	enum v4l2_buf_type valid_cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	enum v4l2_buf_type valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	v4l2_buf_type sec_type = s->type;
>  
> -	if (multiplanar) {
> -		valid_cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> -		valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> -	}
> -
> -	if (s->type != valid_cap_type && s->type != valid_out_type)
> -		return -EINVAL;
> +	if (sec_type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		sec_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	if (sec_type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		sec_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;

I don't think you'll ever get an _MPLANE type. See v4l_g_selection
in drivers/media/v4l2-core/v4l2-ioctl.c.

So these four lines can be removed.

>  
>  	q_data = get_q_data(ctx, s->type);
>  	if (!q_data)
> @@ -963,8 +959,8 @@ static int vidioc_g_selection(struct file *file, void *priv,
>  	 * encoder supports only cropping on the OUTPUT buffer
>  	 * decoder supports only composing on the CAPTURE buffer
>  	 */
> -	if ((ctx->is_enc && s->type == valid_out_type) ||
> -	    (!ctx->is_enc && s->type == valid_cap_type)) {
> +	if ((ctx->is_enc && sec_type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ||
> +	    (!ctx->is_enc && sec_type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
>  		switch (s->target) {
>  		case V4L2_SEL_TGT_COMPOSE:
>  		case V4L2_SEL_TGT_CROP:
> @@ -992,12 +988,9 @@ static int vidioc_s_selection(struct file *file, void *priv,
>  {
>  	struct vicodec_ctx *ctx = file2ctx(file);
>  	struct vicodec_q_data *q_data;
> -	enum v4l2_buf_type out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> -
> -	if (multiplanar)
> -		out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>  
> -	if (s->type != out_type)
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> +	    s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)

Same here, MPLANE is never used.

>  		return -EINVAL;
>  
>  	q_data = get_q_data(ctx, s->type);
> 

Regards,

	Hans

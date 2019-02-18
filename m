Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61F1C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE20920C01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387796AbfBRPxP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:53:15 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:60734 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbfBRPxO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 10:53:14 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id vlEDgbsOm4HFnvlEGg0Rb0; Mon, 18 Feb 2019 16:53:13 +0100
Subject: Re: [PATCH v2] media: vim2m: fix build breakage due to a merge
 conflict
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kees Cook <keescook@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Anton Leontiev <scileont@gmail.com>
References: <c450df23a26ea90c58791fba2092ef48c6f32d2b.1550505119.git.mchehab+samsung@kernel.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <a4dfcbaf-87b4-0d14-b7c9-9bb99d3b9cbb@xs4all.nl>
Date:   Mon, 18 Feb 2019 16:53:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <c450df23a26ea90c58791fba2092ef48c6f32d2b.1550505119.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfK2vQGtyAzqqguPUuz2TFYGt0jh+doIDXdzH4Ti1UKqXIsTEgqx/s25aapU4JJn1LhhLXoywvnq0TevUAwkjG+6nqPqx2xlWNHTOmRwNtyxb8+fSJosE
 HrqQjj4jzJySnED3ExphmDd7M/JdeB3dSxBQuB7RjyB/QWNBjB1ocOX9X0QUQKnSdk3wboDyz4z9Yx87CUBTXZ+E/hLxI9AUQI+rR0kNnFvyiQs51tlBiNIq
 uYXG0FVu5+3w/nAe6IlIT4mhjEDZ26nyufu84UlaUPabJlyGArI4hEUU7EFwRu9znO5D1Lml3X3C+Mw8CDVuiE6WjgN2HLDP31hn9SodVCKWModJP7x/Q9uS
 NLYdBqQfH7JSVRf2bGZQNroeq5QE3kInQyD4eSFLnXq/fc9dioA=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/18/19 4:52 PM, Mauro Carvalho Chehab wrote:
> A merge conflict rised when merging from -rc7. Fix it.
> 
> In this specific case, we don't need the if anymore, as the
> work_run was moved to its rightful place (struct vim2m_ctx).
> 
> Fixes: b3e64e5b0778 ("media: vim2m: use per-file handler work queue")
> Fixes: 240809ef6630 ("media: vim2m: only cancel work if it is for right context")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

> ---
>  drivers/media/platform/vim2m.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index 04250adf58e0..a27d3052bb62 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -905,8 +905,7 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
>  	struct vb2_v4l2_buffer *vbuf;
>  	unsigned long flags;
>  
> -	if (v4l2_m2m_get_curr_priv(dev->m2m_dev) == ctx)
> -		cancel_delayed_work_sync(&dev->work_run);
> +	cancel_delayed_work_sync(&ctx->work_run);
>  
>  	for (;;) {
>  		if (V4L2_TYPE_IS_OUTPUT(q->type))
> 


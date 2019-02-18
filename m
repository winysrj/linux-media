Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BBBC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74D9C2184A
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732997AbfBRPpU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:45:20 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:42072 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730713AbfBRPpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 10:45:19 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id vl6Tgbp3k4HFnvl6Xg0PcW; Mon, 18 Feb 2019 16:45:18 +0100
Subject: Re: [PATCH] media: vim2m: fix build breakage due to a merge conflict
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Anton Leontiev <scileont@gmail.com>
References: <c81314716b420ffcbd34f156af86a8f7d77368e1.1550504042.git.mchehab+samsung@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <725c6a90-d0aa-0edb-bac3-583f25f3e0f1@xs4all.nl>
Date:   Mon, 18 Feb 2019 16:45:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <c81314716b420ffcbd34f156af86a8f7d77368e1.1550504042.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJbiC9ef5vp7jalmnKGfBfTb0SQnH5HkDjZBaeBMFzPNAv0eCDvUn9bHn0VBTtOXTyEFIk6+Ek6ddL2xnwYan0hg1Du8KuKFTZvqQhPZEXUa1V2B3k8B
 eHzm7mOBTZFW2W+sy3oZ318CtqZlZTxUYR6GOMEqpEFkitMAFvBnoG5LxSpFI+u5WgnQsJl2U8iKuX6jRjm7tOA2d6DEzXri/G2L3KOaB6lkpBeqqXHwrEJe
 Qk5You0xs0I1fwGHGOdAEO/AIVwV2Y62u+DZBB4PUzayWoHI12I81HC9WBsHRvbEM0o1gVsGTAjqEd/sN2Z+3WVv8d+3kSZyh5eir1G0/ban6210ndkuU4H6
 bCnfj10yfxMjv8nAWMeQny8aeTCpW1mOEUpa/pT0YEdUDnyQ5p3KRDo55j6/J+r+6aemNjY16f6IYHkxvzG3CUDoDKNxQg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/18/19 4:34 PM, Mauro Carvalho Chehab wrote:
> A merge conflict rised when merging from -rc7. Fix it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/platform/vim2m.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index 04250adf58e0..3e4cda2db0bf 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -902,11 +902,12 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
>  static void vim2m_stop_streaming(struct vb2_queue *q)
>  {
>  	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
> +	struct vim2m_dev *dev = ctx->dev;
>  	struct vb2_v4l2_buffer *vbuf;
>  	unsigned long flags;
>  
>  	if (v4l2_m2m_get_curr_priv(dev->m2m_dev) == ctx)

I don't think this test is needed anymore since the work queue is
now per context.

So the 'if' can be dropped, and instead just cancel ctx->work_run.

Nasty little conflict, for once not that easy to analyze.

Regards,

	Hans

> -		cancel_delayed_work_sync(&dev->work_run);
> +		cancel_delayed_work_sync(&ctx->work_run);
>  
>  	for (;;) {
>  		if (V4L2_TYPE_IS_OUTPUT(q->type))
> 


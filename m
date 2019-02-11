Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF867C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A330220863
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfBKKLd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:11:33 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:41884 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725931AbfBKKLd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:11:33 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id t8Yigs7V1RO5Zt8Ylg3Fz3; Mon, 11 Feb 2019 11:11:31 +0100
Subject: Re: [PATCH 7/9] media: vb2: Add func that return buffer by timestamp
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190209135427.20630-1-dafna3@gmail.com>
 <20190209135427.20630-8-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1cc0ceb0-bb5b-b2c5-68a2-0e31e6da7fe5@xs4all.nl>
Date:   Mon, 11 Feb 2019 11:11:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190209135427.20630-8-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOluw9ew9RddRCAsglElEitnYWOw9F36/e6p/XQfLhBAiZGFU5V3zQ3eCKgSDN/5u8M28KNJCWRuJi6wMIAb19NhCNjTFegJTmTVsZdq9E+To31CuG+b
 GKQRPLJssN/nqcrqJADLXPdsaJcz/vBPinz4XakV/fz1a9s8BPeFGzdvhpplDThIYDcyIo1+2yyqmzLzOFu1K5o0PJDbks7fLYPUyP5SiVXd0C3r/c9VPmqG
 ObDHZHBe6GojRWSIx93yGw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/9/19 2:54 PM, Dafna Hirschfeld wrote:
> Add the function 'vb2_find_timestamp_buf' that returns
> the vb2 buffer that matches the given timestamp
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 14 ++++++++++++++
>  include/media/videobuf2-v4l2.h                  |  3 +++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 3aeaea3af42a..47c245a76561 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -598,6 +598,20 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
>  	.copy_timestamp		= __copy_timestamp,
>  };
>  
> +struct vb2_buffer *vb2_find_timestamp_buf(const struct vb2_queue *q,
> +					  u64 timestamp,
> +					  unsigned int start_idx)
> +{
> +	unsigned int i;
> +
> +	for (i = start_idx; i < q->num_buffers; i++) {
> +		if (q->bufs[i]->timestamp == timestamp)
> +			return q->bufs[i];
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(vb2_find_timestamp_buf);

There is no need for this function, I don't think it adds anything useful IMHO.

Regards,

	Hans

> +
>  int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>  		       unsigned int start_idx)
>  {
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index 8a10889dc2fd..7fc2a235064e 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -71,6 +71,9 @@ struct vb2_v4l2_buffer {
>  int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>  		       unsigned int start_idx);
>  
> +struct vb2_buffer *vb2_find_timestamp_buf(const struct vb2_queue *q,
> +					  u64 timestamp,
> +					  unsigned int start_idx);
>  int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
>  
>  /**
> 


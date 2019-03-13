Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA19AC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83BC32147C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfCMOhm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:37:42 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:40518 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726349AbfCMOhm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 10:37:42 -0400
Received: from [IPv6:2001:420:44c1:2579:e8a7:494:d652:7065] ([IPv6:2001:420:44c1:2579:e8a7:494:d652:7065])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 450ihlJSE4HFn450mhPkfv; Wed, 13 Mar 2019 15:37:41 +0100
Subject: Re: [PATCH v5 22/23] media: vicodec: Add support for stateless
 decoder.
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190306211343.15302-1-dafna3@gmail.com>
 <20190306211343.15302-23-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c001c8b3-7d03-2573-6300-fbbebb899c0a@xs4all.nl>
Date:   Wed, 13 Mar 2019 15:37:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190306211343.15302-23-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMjm+MFXMo48rKYLZSFyeoY1QG8B8y+BESE3Z46BHIzPtmLJPnR+3issRpE8rfvZtVFPZNLL0UgZ8M6lVVK/MdaHVrtjyrc/YIBCQXJfYNegFnBSGyp+
 rp935TMlu5TsYqhgTTKJF0rTTHbqA0inN0/lMhvbNyk8xXjkJrzf8PixjFOZ7DEzyrTm+cG/0LXtrXPOQ6kHx3XTeGHga53vX1skvycYxYtVupwod66WFW4L
 iQMQVvSWgUiGiSi9cPIUOKgPf/dtagnV8bZmDJY/FLbvAsEzNCigDay/RRW33pogAnYzfbQtEZiPqxNnMTGfpBQFMaJtnlPiUnjlnBXtX3F8/wunhe/maHDN
 I+eQRdYQ
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/6/19 10:13 PM, Dafna Hirschfeld wrote:
> Implement a stateless decoder for the new node.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---

<snip>

> +static int vicodec_try_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct vicodec_ctx *ctx = container_of(ctrl->handler,
> +			struct vicodec_ctx, hdl);
> +	const struct v4l2_ctrl_fwht_params *params;
> +	struct vicodec_q_data *q_dst = get_q_data(ctx,
> +			V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MPEG_VIDEO_FWHT_PARAMS:
> +		if (!q_dst->info)
> +			return -EINVAL;
> +		params = ctrl->p_new.p_fwht_params;
> +		if (params->width > q_dst->coded_width ||
> +		    params->width < MIN_WIDTH ||
> +		    params->height > q_dst->coded_height ||
> +		    params->height < MIN_HEIGHT)
> +			return -EINVAL;
> +		if (!validate_by_version(params->flags, params->version))
> +			return -EINVAL;
> +		if (!validate_stateless_params_flags(params, q_dst->info))
> +			return -EINVAL;

There should be a return 0; statement here rather than fall through.

I'll make this trivial change when I prepare the pull request for this
patch series, so you don't need to do anything Dafna.

Regards,

	Hans

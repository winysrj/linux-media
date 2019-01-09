Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D42C43444
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55C5E21738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzqRMQcL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfAIIF5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 03:05:57 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43144 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729799AbfAIIFz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 03:05:55 -0500
Received: by mail-wr1-f68.google.com with SMTP id r10so6623029wrs.10
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 00:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XkiZgg0aDT7g4yOLOwWjijVvL4JIQi+qG9ry6Tfup5s=;
        b=NzqRMQcLIVUV+OZCoCc8Vv6flCJZSLA42PQy9jsIbkOF9US30p0Aq7jL6zm/gqJs16
         qd48bEHKdljVOqA+6Z4dmfVR3cerK0zM1IoqnDBr6bjFZE0u7xfc99Ad33TqfFXBM2yj
         /OTaUHdQWaJ/eBF9tXsH46NwWK/nxvS7NJf4B7ywrM4uGSJ7LxBxc9uearIUNWzGjtOh
         C38voS1uz5awutnRnank16fnUBNgNbkLG8f5NR+PIwwkJ2OXF0zkLy8FHskoPSqKweDf
         j/+AYJYGzDHBcv8eUk3DN2S8sLbE4HZ8MYGLfcrJgwRgXvHMPMXiR7ZjNJUDk/POpQA9
         SXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XkiZgg0aDT7g4yOLOwWjijVvL4JIQi+qG9ry6Tfup5s=;
        b=aZEka66DW8W0wggST25lHX7VApzELxy6ZQZyAFVnFOghpeSwCbxrzjdYnonjTFDSpC
         QDXfDUbf5FEtNkknDfmswHjyTSSwxd8s3IweHg54A7emV4HHNLKHkw18cxmfvadXLKVk
         +aS00rv10yCqeHThtypLH7h+Q1OQ6nq8I4tJbq29TObLsovipl9n6AsKMVgtpdnHlXp1
         V7uWnxukbR8pTGbpajktc7bQiT7fpCmR4sqM0gux6HiKzhfDSzvCt8ruPjTfYr5z9DgT
         40ujbSE9VZBH7W8r1t7YUnbZKEWuuC9EBbS5hRgUyz3j3XokL+SaiWK3wfidywX37GJ/
         7H8A==
X-Gm-Message-State: AJcUukcn+7V9DEJ6lnqt4W8bIVGLeEqmsaPFpII3OrDMbU4cRzswwg5u
        /zj2ilsRvyub5K6vhH7Ar48=
X-Google-Smtp-Source: ALg8bN4gT4mMKHxzCc0XuJoHqWNxeyZZSNmTNeTBtYXX2F/Zk1dBKn1QgLEZX7mFBtmICPz/3k71BQ==
X-Received: by 2002:a5d:63c3:: with SMTP id c3mr3961622wrw.215.1547021152897;
        Wed, 09 Jan 2019 00:05:52 -0800 (PST)
Received: from [192.168.19.12] (host86-135-79-138.range86-135.btcentralplus.com. [86.135.79.138])
        by smtp.googlemail.com with ESMTPSA id k128sm15188596wmd.37.2019.01.09.00.05.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 00:05:52 -0800 (PST)
Subject: Re: [PATCH 3/4] media: coda: Add control for h.264 constrained intra
 prediction
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20190108171313.1750-1-p.zabel@pengutronix.de>
 <20190108171313.1750-3-p.zabel@pengutronix.de>
From:   Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <1ea1143a-f681-b58d-737d-dc4775d39680@gmail.com>
Date:   Wed, 9 Jan 2019 08:05:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190108171313.1750-3-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Philipp

On 08/01/2019 17:13, Philipp Zabel wrote:
> Allow to enable constrained intra prediction in the h.264 encoder.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>   drivers/media/platform/coda/coda-bit.c    | 4 +++-
>   drivers/media/platform/coda/coda-common.c | 6 ++++++
>   drivers/media/platform/coda/coda.h        | 1 +
>   3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
> index 8e0194993a52..5e5accc3ae62 100644
> --- a/drivers/media/platform/coda/coda-bit.c
> +++ b/drivers/media/platform/coda/coda-bit.c
> @@ -1010,7 +1010,9 @@ static int coda_start_encoding(struct coda_ctx *ctx)
>   			 CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET) |
>   			((ctx->params.h264_slice_beta_offset_div2 &
>   			  CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK) <<
> -			 CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET);
> +			 CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET) |
> +			(!!ctx->params.h264_constrained_intra_pred_flag <<

Shouldn't need !! as it's already a bool.

Regards,
Ian
> +			 CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET);
>   		coda_write(dev, value, CODA_CMD_ENC_SEQ_264_PARA);
>   		break;
>   	case V4L2_PIX_FMT_JPEG:
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 7518f01c48f7..f6c9273805bb 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1839,6 +1839,9 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
>   	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
>   		ctx->params.h264_disable_deblocking_filter_idc = ctrl->val;
>   		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION:
> +		ctx->params.h264_constrained_intra_pred_flag = ctrl->val;
> +		break;
>   	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>   		/* TODO: switch between baseline and constrained baseline */
>   		if (ctx->inst_type == CODA_INST_ENCODER)
> @@ -1925,6 +1928,9 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
>   		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE,
>   		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY,
>   		0x0, V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION, 0, 1, 1,
> +		0);
>   	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
>   		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
>   		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 31cea72f5b2a..f3d0cff4ef3a 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -118,6 +118,7 @@ struct coda_params {
>   	u8			h264_disable_deblocking_filter_idc;
>   	s8			h264_slice_alpha_c0_offset_div2;
>   	s8			h264_slice_beta_offset_div2;
> +	bool			h264_constrained_intra_pred_flag;
>   	u8			h264_profile_idc;
>   	u8			h264_level_idc;
>   	u8			mpeg4_intra_qp;
> 

Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B77C282C4
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 01:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F98320823
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 01:55:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fp76mjI1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbfBEBze (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 20:55:34 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34793 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfBEBzd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 20:55:33 -0500
Received: by mail-pl1-f194.google.com with SMTP id w4so815972plz.1;
        Mon, 04 Feb 2019 17:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=St2JpHyVsDt8rLJOcK9kRpXYAQ/AguTopm1EobWdamQ=;
        b=Fp76mjI1BiwwuElFwuop9HXwsdtEsH6OYzAG3NGO3S7AZnY46RfVBh+hUNmpAr3Jyt
         NepCdNHaFZcFZl8GMSwc++OOwZflQhlyDJsLNsQB6bAoOXusLVmIcMR+SeKFXkIDo5Nv
         D52dZoOZT4W73SqwBg99eNdYQompqpJrcawtclif/QlgF8I60D8jUasDtWRW+7mh6Eqe
         GTaUuhs3hy8EGyCuz/3L/Nh568lzv4TqCZuxsE7NMTQak9j0Z6VkLIx9Wi7qu8FZRCc/
         nKHffsy5jlCtWSzBFadSMD1PiZ6S0ax1kmY8+zZfs9mKkKPxGvr84Gj7xztH4ylK8c81
         7qGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=St2JpHyVsDt8rLJOcK9kRpXYAQ/AguTopm1EobWdamQ=;
        b=pggwVyYt0hfTv9V7KCfaYV5Y51T7KtwP56GW52OX+WWWxZEaNNwZwgkZbr5COJ2GE/
         /qi1Y18NaCIqC4z4EX6ywNLyNAf5lOq2DBB8KSor0jlUHMPGXTFNA1/2Ucu8/vp93wbU
         oYR7mXgCz6vZA0wcC7/qN+qky7dMmkXV+Re4rLjL2QRtJDG1hDi1/k6gAN1SbZbE4S2n
         IgmEnJUX0Gf/KQBisrboCGH1fxoHleJM1aYCufUQTGp7l/IxvN9FsA64Zgg0YyRt1g09
         PtBJmPOd+YCC/ofLaOadsT5p0rX1HV8QnHCm/7iAVadfWVIHjq7jSQgoVUYm8Z7oiR/m
         jm4A==
X-Gm-Message-State: AHQUAuZ0u+HbA0qLB0E3+T56jMhlhMgDb+Z0zH8eK3mjr+JF12kCm2gt
        ccYLkG1Ayg70YRpCrj2dp/yFbg4Z2uk=
X-Google-Smtp-Source: AHgI3IZ4XOJ9m44F1Ttu77gsdOGm2yMvOu+nOAClZ6axb50qeqlqmwU97DL+P9c7QNmLQnMPg51zgw==
X-Received: by 2002:a17:902:3383:: with SMTP id b3mr2468458plc.170.1549331732413;
        Mon, 04 Feb 2019 17:55:32 -0800 (PST)
Received: from [192.168.1.102] (71-80-218-122.dhcp.crcy.nv.charter.com. [71.80.218.122])
        by smtp.gmail.com with ESMTPSA id w10sm1557277pgr.42.2019.02.04.17.55.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 17:55:31 -0800 (PST)
Subject: Re: [PATCH 3/3] media: imx: Allow BT.709 encoding for IC routes
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190203194744.11546-1-slongerbeam@gmail.com>
 <20190203194744.11546-4-slongerbeam@gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b550f0f5-369b-3af8-14c2-c7e92bdc9ffe@gmail.com>
Date:   Mon, 4 Feb 2019 17:55:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190203194744.11546-4-slongerbeam@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sorry this patch isn't working, it's not possible to set BT.709 
encoding, working on a fix for v2.

Steve


On 2/3/19 11:47 AM, Steve Longerbeam wrote:
> The IC now supports BT.709 Y'CbCr encoding, in addition to existing BT.601
> encoding, so allow both, for pipelines that route through the IC.
>
> Reported-by: Tim Harvey <tharvey@gateworks.com>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
>   drivers/staging/media/imx/imx-media-utils.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
> index 5f110d90a4ef..3512f09fb226 100644
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -571,7 +571,9 @@ void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
>   		tryfmt->quantization = is_rgb ?
>   			V4L2_QUANTIZATION_FULL_RANGE :
>   			V4L2_QUANTIZATION_LIM_RANGE;
> -		tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
> +		if (tryfmt->ycbcr_enc != V4L2_YCBCR_ENC_601 &&
> +		    tryfmt->ycbcr_enc != V4L2_YCBCR_ENC_709)
> +			tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
>   	}
>   }
>   EXPORT_SYMBOL_GPL(imx_media_fill_default_mbus_fields);


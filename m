Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C39C65BAF
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 09:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 537EC20838
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 09:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="iL1iHONf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 537EC20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbeLGJfF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 04:35:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39573 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbeLGJfD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 04:35:03 -0500
Received: by mail-wr1-f66.google.com with SMTP id t27so3126009wra.6
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 01:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CQn+D+KNDMZo3Ek7ADV5OyC5o/lxyzw7EMMeXAI3fUE=;
        b=iL1iHONfhQpxSdik9FY4+hB2UZOs/cAGD5DshIKkppDTmt+LaVo4zFBBnfqgZsBDTV
         zYF5Mv3xaS/lIhASaezrPdzbrFUEHfwo1OXEZ2yCm256ZYKHIG998P0z6N/GNs7ePFgJ
         2uOC706QPW650zfokTbNt3ZwoCA3r4rU92KtQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CQn+D+KNDMZo3Ek7ADV5OyC5o/lxyzw7EMMeXAI3fUE=;
        b=cjhSWp5V1FjelSU1L44VtzD8CzRjCKaT2boQBDhgg89LP3ZhR5EnaUPLGTYb7ulk6B
         AAdJCzcGZxmk1c2nx3+XWxfBN3MOtLpdoUamj9GVAKLGzw1uGRmKUivXPnW5xrVPo2w1
         1+EA1ojJ32FG9Le2idhI5EgUe3R/Js33r8F2mQ5Ot4MYrhlvjQ/1pvDMBu6X5O9zPFGK
         aTK8pGb/LiN1dsCxFmpTdHvz6jIDSsq9DGsNggBdai/OFknAdJciP/YCulB7/9flzw9S
         jY7Dyff/Lpr3f2DYaH522MnpB/twTXo9Ir83oni0ipz/E0dKUfqrfCR7os2dRn5SubEj
         6iCQ==
X-Gm-Message-State: AA+aEWb6g7q/Br1jkwvR+lNRx+q8jLoeQIeNIWpVwl5yddXctLIP3q7G
        5hhM9QcQwL8UwPCVkRc0FXXe8zPGSDA=
X-Google-Smtp-Source: AFSGD/VfVaV6iRplvod5DOCW+7I8Jv1VXlbkua/qO6bFCu/kKl2dfO2bFK7nVoL4RiH1dxLx5WLrbQ==
X-Received: by 2002:adf:ee06:: with SMTP id y6mr1210202wrn.261.1544175301257;
        Fri, 07 Dec 2018 01:35:01 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id o17sm5224363wmg.35.2018.12.07.01.34.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 01:35:00 -0800 (PST)
Subject: Re: [PATCH v2] media: venus: Support V4L2 QP parameters in Venus
 encoder
To:     Kelvin Lawson <klawson@lisden.com>, linux-media@vger.kernel.org
References: <96b0d248-8719-e637-63f7-3468948f1c78@linaro.org>
 <1543536448-16442-1-git-send-email-klawson@lisden.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <65526cda-79af-92ee-f673-11a448f97d71@linaro.org>
Date:   Fri, 7 Dec 2018 11:34:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1543536448-16442-1-git-send-email-klawson@lisden.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kelvin,

Thanks for the patch!

On 11/30/18 2:07 AM, Kelvin Lawson wrote:
> Support V4L2 QP parameters in Venus encoder:
>  * V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP
>  * V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP
>  * V4L2_CID_MPEG_VIDEO_H264_MIN_QP
>  * V4L2_CID_MPEG_VIDEO_H264_MAX_QP
> 
> Signed-off-by: Kelvin Lawson <klawson@lisden.com>
> ---
>  drivers/media/platform/qcom/venus/venc.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan

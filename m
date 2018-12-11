Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52235C07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 268192084A
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:26:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 268192084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbeLKJ0U (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 04:26:20 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:50471 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726164AbeLKJ0R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 04:26:17 -0500
Received: from [IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a] ([IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id WeIwgFDbAQMWUWeIxg6ScI; Tue, 11 Dec 2018 10:26:15 +0100
Subject: Re: [PATCH 1/2] media: tegra-cec: Support Tegra186 and Tegra194
To:     Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
References: <20181210160038.16122-1-thierry.reding@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <13d8fdb8-fc0e-9ad5-6405-110dd37ca5d5@xs4all.nl>
Date:   Tue, 11 Dec 2018 10:26:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181210160038.16122-1-thierry.reding@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAiTtWnHtaTCaef0GsMbPgrOq1Jay0kD3MVVoGyFLsw0qo3rgtyorVWRQAHQSF2Ao3la+8XeLIHGtMdxCxPZl+Ea4Gn4+itDbaJzCZn4sRKicCUVwvfj
 a/HyNcNUK2rtdhXWiNu9RQxEXqDOPFKgdWxGUByduQ9TRZcG+mzyJ9e1Vbil5H3niBPZHOzb1dOlaY15fpmwySsKTw9da5t5HAy13md/ZWfW+Y9T/zh6eB/W
 tlwSR6HPhCkf9a7dedorbMQvs1waoaruWuBJdJyY1nIgoRHmpXj9I9fh/kmPvYhwbs+reCf6mC5B4ih0Hw9Oy++20G8aP6KBpMXOo9GZOT4HpanpqeK9w3hW
 owxikrg5p2b7k4m8zT6sg/l9SwAKXFg/0gOp0C2LmSFO7/iKI40Xn8WZ2k0+/3AeKEzH/Rogqrf09mc1Wnvtt4EuwKSbPRZER1zs66BvgmXDgWRYjcU=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/10/18 5:00 PM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The CEC controller found on Tegra186 and Tegra194 is the same as on
> earlier generations.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/media/platform/tegra-cec/tegra_cec.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
> index aba488cd0e64..8a1e10d008d0 100644
> --- a/drivers/media/platform/tegra-cec/tegra_cec.c
> +++ b/drivers/media/platform/tegra-cec/tegra_cec.c
> @@ -472,6 +472,8 @@ static const struct of_device_id tegra_cec_of_match[] = {
>  	{ .compatible = "nvidia,tegra114-cec", },
>  	{ .compatible = "nvidia,tegra124-cec", },
>  	{ .compatible = "nvidia,tegra210-cec", },
> +	{ .compatible = "nvidia,tegra186-cec", },
> +	{ .compatible = "nvidia,tegra194-cec", },
>  	{},
>  };
>  
> 

Applying: media: tegra-cec: Support Tegra186 and Tegra194
WARNING: DT compatible string "nvidia,tegra186-cec" appears un-documented -- check ./Documentation/devicetree/bindings/
#9: FILE: drivers/media/platform/tegra-cec/tegra_cec.c:475:
+       { .compatible = "nvidia,tegra186-cec", },

WARNING: DT compatible string "nvidia,tegra194-cec" appears un-documented -- check ./Documentation/devicetree/bindings/
#10: FILE: drivers/media/platform/tegra-cec/tegra_cec.c:476:
+       { .compatible = "nvidia,tegra194-cec", },

I need an additional patch adding the new bindings to
Documentation/devicetree/bindings/media/tegra-cec.txt.

Regards,

	Hans

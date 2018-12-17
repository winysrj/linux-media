Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D69C43612
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 14:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E45E9206A2
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 14:48:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="p03OkzZW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbeLQOsj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 09:48:39 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39684 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732626AbeLQOsj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 09:48:39 -0500
Received: by mail-lf1-f67.google.com with SMTP id n18so9641135lfh.6
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2018 06:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=3g/fsF0Ac7fJftbcfBihqbk+RLYMzWHjD7fXaDdPjRE=;
        b=p03OkzZW7r3Myy/Xs6jnBtIFIdyVsFwqM+7rH0grPnIo3yt1L6HB31fMWEDOLS1oe0
         IbMq3HPisWHsmiW25cAs1pzS2pZtrHUsDJKy2U2WNTI6PRLmJgIZFKuNaqYLoGH05Sbc
         z0bwB32vZ0V77Q6kalZ73DROS5+b7jBNvIahhSsjlGgb1WDAXLnHKCLuLLMYRax/8HFv
         kBl4wfBCUO17q8EgkazbqhigG8e/RCarPt6kzgg6gT+7yIrzRQmrieNwNV/nJtdO/a6F
         GSFI/0PrAHmdzzDZUkd4Zjyol2WLK0GA6QzcfDbmdDfx65l4+8YiCtbbScM3Z5LWBMri
         zOvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=3g/fsF0Ac7fJftbcfBihqbk+RLYMzWHjD7fXaDdPjRE=;
        b=JU19mMl6GghoTOySAAWawA7rq9qDYZLzX1/muEoP9MdlfI40d6c5SlNqUhNcYFNq0b
         yQhzbk4WsNER2cJpjjWPx8fhEg8kEcnlyv+ep6IZHPpsXeApv5Q4tQ8uWwPBa2R7Dl/+
         B/AaZDDjgvPba/wtboHBSPIqp1SedBeUQtcwicLmGD4lKcW6J2/wO93LKjlrxth2CN66
         41xRtxQlV/feCtlRZLJTRMXC6jc1QC9wRvdPzl1+1LA8/CmTJuztzVxUmh+SVeXGRE8R
         f/I7YEg/39WCZdO06AVrfKwiWm5p9jYRDQEvE1zSt6MDXtWd9BCA/M/lMpusHg5AxX44
         YFhA==
X-Gm-Message-State: AA+aEWZ14zC3IHz13/5SqCIK0YHSS2LNi+LlpmFSHrM01BZDYBHHMlj9
        ETaMsXieN16aWb8na0fCqiSiqA==
X-Google-Smtp-Source: AFSGD/W7QMkKZUYgJPkGZ8uyrf3wr0p6/rpqiGfZJ5IlfubHqZrn8LM22o2IJdTp+Pd5fcJFaEWElg==
X-Received: by 2002:a19:f204:: with SMTP id q4mr7971963lfh.133.1545058116944;
        Mon, 17 Dec 2018 06:48:36 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id c2-v6sm2568485ljj.41.2018.12.17.06.48.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Dec 2018 06:48:36 -0800 (PST)
Date:   Mon, 17 Dec 2018 15:48:35 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH] media: rcar-csi2: Add support for RZ/G2E
Message-ID: <20181217144835.GT17972@bigcity.dyn.berto.se>
References: <1544732652-7459-1-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1544732652-7459-1-git-send-email-fabrizio.castro@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Fabrizio,

Thanks.

On 2018-12-13 20:24:12 +0000, Fabrizio Castro wrote:
> According to the RZ/G2 User's manual, RZ/G2E and R-Car E3 CSI-2
> blocks are identical, therefore use R-Car E3 definitions to add
> RZ/G2E support.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index 80ad906..be7508b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -979,6 +979,10 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a77990 = {
>  
>  static const struct of_device_id rcar_csi2_of_table[] = {
>  	{
> +		.compatible = "renesas,r8a774c0-csi2",
> +		.data = &rcar_csi2_info_r8a77990,
> +	},
> +	{
>  		.compatible = "renesas,r8a7795-csi2",
>  		.data = &rcar_csi2_info_r8a7795,
>  	},
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund

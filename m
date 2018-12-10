Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B7EC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 15:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD9A62082F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 15:24:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="uc8kH7dH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD9A62082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ragnatech.se
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbeLJPYy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 10:24:54 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39352 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeLJPYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 10:24:54 -0500
Received: by mail-lf1-f65.google.com with SMTP id n18so8270117lfh.6
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 07:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=IYHmS0d0ofWDx/0OhaNa2ehNFdbSNiXpOjTTvB3WPTY=;
        b=uc8kH7dH5/um3zmYKBZLweSld5ufOeK29VK52ti3+zD9I9zHI1EtlXuti3FyOLW39Y
         hTkuDzkiROfls29Xdk7WIuN6gtVTa7rn7q2H1U72/PMCZE/R6yJfTC0reIxey41YojgJ
         7GFgSghcm4PgBky+00j8ZKMjxnEGaPt2/VtYWYvJNIUM29nYtLEK6EjHPQWIuA8KHdMj
         0eBlen/MgVuB3ip9vszdiy+0a0GLje9IA2AsogOifR8ry5k4AmtkHgHhvKAprnTDppsB
         EtOIQQkwoRcmSC2f/ikAQpPm4D0d5/xHRBvGCctR1o1u8jNic2d365u5i3jvlL0wzSoK
         HSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=IYHmS0d0ofWDx/0OhaNa2ehNFdbSNiXpOjTTvB3WPTY=;
        b=cH38PesjEKN1HhkJAV/X9kgoIDnt6RdLOYBJiZRDliNfDeVs5bwDmRHf7rUPValUQ6
         ifp0tUZXaLjQ9BGNMxRYI3G1ovK27NaDivVFYyyMbYHEwr1q2eS/3leoxBFQhOxHXTxz
         SXBcMGGxMdcmCK+Iu/P7w+SOaK0GnhxRZLFPhaFmkGsWmChjValG0Dmglp96nACH5uEP
         pFpFZlcUmcMf215+BYsru+yOm3w88wIjrRpa+ozKO4BHkrsxu+FG/eGG0ICaspK/6jaU
         2LTQDY5ocANqB6wM+JuliFNCYtZ6oHVuqHK3xf1ykG9HKaksMI0DpsXgSLijLuQ2AZxm
         nIKQ==
X-Gm-Message-State: AA+aEWZuW01Ulv4yw1trGoOQUUvessr1F0OESdTq72X4fYYvaMY/tF1G
        93F/mx7RE8TzEqvyVmAy+JFEBw==
X-Google-Smtp-Source: AFSGD/XFJR/DZsWVsI8jLetxPvCkV1O8s+1X8YdcLhhcrKKLgeUnlotbSKfZkOq/NBP5itywMyIdaQ==
X-Received: by 2002:a19:5ad0:: with SMTP id y77mr4834985lfk.109.1544455492131;
        Mon, 10 Dec 2018 07:24:52 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id 67-v6sm2208835ljc.26.2018.12.10.07.24.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Dec 2018 07:24:51 -0800 (PST)
Date:   Mon, 10 Dec 2018 16:24:50 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: rcar-csi2: Fix PHTW table values for E3/V3M
Message-ID: <20181210152450.GJ17972@bigcity.dyn.berto.se>
References: <1544453635-16359-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1544453635-16359-1-git-send-email-jacopo+renesas@jmondi.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thanks for fixing this.

On 2018-12-10 15:53:55 +0100, Jacopo Mondi wrote:
> The PHTW selection algorithm implemented in rcsi2_phtw_write_mbps() checks for
> lower bound of the interval used to match the desired bandwidth. Use that
> in place of the currently used upport bound.
> 
> Fixes: 10c08812fe60 ("media: rcar: rcar-csi2: Update V3M/E3 PHTW tables")
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 62 ++++++++++++++---------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index 80ad906d1136..7e9cb8bcfe70 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -152,37 +152,37 @@ static const struct rcsi2_mbps_reg phtw_mbps_h3_v3h_m3n[] = {
>  };
> 
>  static const struct rcsi2_mbps_reg phtw_mbps_v3m_e3[] = {
> -	{ .mbps =   89, .reg = 0x00 },
> -	{ .mbps =   99, .reg = 0x20 },
> -	{ .mbps =  109, .reg = 0x40 },
> -	{ .mbps =  129, .reg = 0x02 },
> -	{ .mbps =  139, .reg = 0x22 },
> -	{ .mbps =  149, .reg = 0x42 },
> -	{ .mbps =  169, .reg = 0x04 },
> -	{ .mbps =  179, .reg = 0x24 },
> -	{ .mbps =  199, .reg = 0x44 },
> -	{ .mbps =  219, .reg = 0x06 },
> -	{ .mbps =  239, .reg = 0x26 },
> -	{ .mbps =  249, .reg = 0x46 },
> -	{ .mbps =  269, .reg = 0x08 },
> -	{ .mbps =  299, .reg = 0x28 },
> -	{ .mbps =  329, .reg = 0x0a },
> -	{ .mbps =  359, .reg = 0x2a },
> -	{ .mbps =  399, .reg = 0x4a },
> -	{ .mbps =  449, .reg = 0x0c },
> -	{ .mbps =  499, .reg = 0x2c },
> -	{ .mbps =  549, .reg = 0x0e },
> -	{ .mbps =  599, .reg = 0x2e },
> -	{ .mbps =  649, .reg = 0x10 },
> -	{ .mbps =  699, .reg = 0x30 },
> -	{ .mbps =  749, .reg = 0x12 },
> -	{ .mbps =  799, .reg = 0x32 },
> -	{ .mbps =  849, .reg = 0x52 },
> -	{ .mbps =  899, .reg = 0x72 },
> -	{ .mbps =  949, .reg = 0x14 },
> -	{ .mbps =  999, .reg = 0x34 },
> -	{ .mbps = 1049, .reg = 0x54 },
> -	{ .mbps = 1099, .reg = 0x74 },
> +	{ .mbps =   80, .reg = 0x00 },
> +	{ .mbps =   90, .reg = 0x20 },
> +	{ .mbps =  100, .reg = 0x40 },
> +	{ .mbps =  110, .reg = 0x02 },
> +	{ .mbps =  130, .reg = 0x22 },
> +	{ .mbps =  140, .reg = 0x42 },
> +	{ .mbps =  150, .reg = 0x04 },
> +	{ .mbps =  170, .reg = 0x24 },
> +	{ .mbps =  180, .reg = 0x44 },
> +	{ .mbps =  200, .reg = 0x06 },
> +	{ .mbps =  220, .reg = 0x26 },
> +	{ .mbps =  240, .reg = 0x46 },
> +	{ .mbps =  250, .reg = 0x08 },
> +	{ .mbps =  270, .reg = 0x28 },
> +	{ .mbps =  300, .reg = 0x0a },
> +	{ .mbps =  330, .reg = 0x2a },
> +	{ .mbps =  360, .reg = 0x4a },
> +	{ .mbps =  400, .reg = 0x0c },
> +	{ .mbps =  450, .reg = 0x2c },
> +	{ .mbps =  500, .reg = 0x0e },
> +	{ .mbps =  550, .reg = 0x2e },
> +	{ .mbps =  600, .reg = 0x10 },
> +	{ .mbps =  650, .reg = 0x30 },
> +	{ .mbps =  700, .reg = 0x12 },
> +	{ .mbps =  750, .reg = 0x32 },
> +	{ .mbps =  800, .reg = 0x52 },
> +	{ .mbps =  850, .reg = 0x72 },
> +	{ .mbps =  900, .reg = 0x14 },
> +	{ .mbps =  950, .reg = 0x34 },
> +	{ .mbps = 1000, .reg = 0x54 },
> +	{ .mbps = 1050, .reg = 0x74 },
>  	{ .mbps = 1125, .reg = 0x16 },
>  	{ /* sentinel */ },
>  };
> --
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund

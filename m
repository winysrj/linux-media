Return-Path: <SRS0=8CHB=RF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D3BC00319
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 10:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 639A02085A
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 10:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="YZwUFT18"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfCBKJt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Mar 2019 05:09:49 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37963 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfCBKJs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2019 05:09:48 -0500
Received: by mail-lj1-f195.google.com with SMTP id 199so268984ljj.5
        for <linux-media@vger.kernel.org>; Sat, 02 Mar 2019 02:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=+iBatvjaf4sg/oaZIbHUcz990bNVnRaiH6QKXbxAb6k=;
        b=YZwUFT18EJT2egd5emM7BDgsR+Yw8Ow3Z7LfJl1zpZiuaT5yEiaNYYW3Jxc/6uVV+X
         QMJzONCatlOpSr0lPeJbKRqaVwnC54AyN3mWRYV+58uZ57ySryFUoC4nXEjqQ2cIKmsh
         +YluNfYg4x/g158FBKBMPzuinGCyFWBVm9sDJ1fNsF//mKuN3Cm5i39j54YSswqV7HLE
         Jc8jONZ5DgQANawI+3Ct7bOP2pZh5t7l8g09XUHkx/AHCgtW+r0KODGcxrEZTJgJwPDC
         sCmGtxcvoB1vbA2g9hnWKqG6c6pXv6OLM7e6MwbXX2PVMHVSVT3eH/SJwYWQdiumgL56
         lEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+iBatvjaf4sg/oaZIbHUcz990bNVnRaiH6QKXbxAb6k=;
        b=meakP7/ue+G5ZbH5UQOVtplXD34br1SKtoT2ZXo11ggeKnlNfk8YapRkzkvQPvBScR
         KEc/a+H+EYqtegfOIPhwLSAPVixIVnWqYTdj+mpCEt0RU8S48gdxU5fTCR/lKLdKf48b
         ZTWTGC+y0vo2A+LKDT0LogJBw46rkTyzJuLC+6kJ9DGuiaB/+RXmj2gRHmkz1n7d3QA7
         I3IPBbqyFxylYFI9IxT3OUIs50ohs9kn8dPZIp34YT1m8KzpQn84S8Tf1mZXyptUIvJG
         nl5rAjuyHChpVC5RQ9FckCFmcyachInY2uNHpqLhbpx3eiBQ4/jH8j1dzZtqYIaS3q0A
         8XWg==
X-Gm-Message-State: APjAAAXT9wwGzk915pfFxGpk8M5rBf3Zwo7Kisa0SAiOJJVSNoeJBYKX
        bLILPPgyjTcQCV+/bxDRQTCXXg==
X-Google-Smtp-Source: APXvYqxiWcU613zIKPpdD6Lf40WvKzfN4lc2bs5poD+yDbEVzkQyVLDMa8hpzR1KXUe5rnPWEy8Raw==
X-Received: by 2002:a2e:6a18:: with SMTP id f24mr5572628ljc.97.1551521386423;
        Sat, 02 Mar 2019 02:09:46 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id a18sm111457lfj.35.2019.03.02.02.09.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 Mar 2019 02:09:45 -0800 (PST)
Date:   Sat, 2 Mar 2019 11:09:44 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] media: rcar_drif: Remove devm_ioremap_resource()
 error printing
Message-ID: <20190302100944.GA22550@bigcity.dyn.berto.se>
References: <20190301093831.11106-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190301093831.11106-1-geert+renesas@glider.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Geert,

Thanks for your patch.

On 2019-03-01 10:38:31 +0100, Geert Uytterhoeven wrote:
> devm_ioremap_resource() already prints an error message on failure, so
> there is no need to repeat that.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
> v2:
>   - Drop assignment to ret.
> ---
>  drivers/media/platform/rcar_drif.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
> index c417ff8f6fe548f3..608e5217ccd50a1b 100644
> --- a/drivers/media/platform/rcar_drif.c
> +++ b/drivers/media/platform/rcar_drif.c
> @@ -1405,11 +1405,9 @@ static int rcar_drif_probe(struct platform_device *pdev)
>  	/* Register map */
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	ch->base = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(ch->base)) {
> -		ret = PTR_ERR(ch->base);
> -		dev_err(&pdev->dev, "ioremap failed (%d)\n", ret);
> -		return ret;
> -	}
> +	if (IS_ERR(ch->base))
> +		return PTR_ERR(ch->base);
> +
>  	ch->start = res->start;
>  	platform_set_drvdata(pdev, ch);
>  
> -- 
> 2.17.1
> 

-- 
Regards,
Niklas Söderlund

Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A54C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 16:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 563512190A
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 16:01:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rXf/vf2Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbfCVQBp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 12:01:45 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34817 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbfCVQBp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 12:01:45 -0400
Received: by mail-ed1-f67.google.com with SMTP id d6so2117133eds.2;
        Fri, 22 Mar 2019 09:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TVpZK9oqN4aOz9IbGRm1R5kpN8v8uEcDMs7ZZlag+co=;
        b=rXf/vf2ZMHNY44j+rv5o390yyvdUxVpOIKdJFVxIBT8u+2j3yRTo/YG54JY6z+6LaD
         LdHPKNdNM3DJw9Cj5cdhfmuU31ziaze8F4erhW5eUtLZXbpK5OCA4FYxyjsAP0zeWrDA
         7RDQgVGjdFbUdYFLAergFmJVfAf3+UvUoAJ/ElgFn5yNysp34v7uFHhYNAFZmwIAqbdR
         E+S137E8fI385/M9OOfpvV4VM3kDJOO96darPbQnglI2lH2ldCh+ZLQElCI7HxGuLwO6
         G5Ic1Pbcl29w4iLKAMDyRG3CH1yxQW76F532WfSYT7J3IWUgdVvtCosl9eLJZl2QhcVX
         gYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TVpZK9oqN4aOz9IbGRm1R5kpN8v8uEcDMs7ZZlag+co=;
        b=U8qx8mwUyQaC7tDIXS6jTrouMknHlYKw9QPqt4UX+xAL/EmESf1KLh1h4BmS+PTaQs
         +7Z8Kkhxs4eiXGWInTDp1817yPq+EwxZzxD/nUwEQ40C7mpErnLUCePNWHsxorWFZhmK
         DcCD4AMYyiqzwkCHZzWa7v7hV2YzO/XFRy6ybUpI5I5OfjGTQiKZ/mhY9ZAmUaThNUpj
         qEHRgQaje6HRjslCX0vz866UgZOU4bLvOdF85A/g5/18uhqcWTk9oFooo379LI8kHnAY
         RII0FckLIiCGPaXznrzVYwcfNh1hbilTzWea35loe/gE25dW/Ffx9qPWsMCPiOgOSQGI
         TY6g==
X-Gm-Message-State: APjAAAWV2jsBxS1dMt8d53Knfl7o43eZah5YSl5IhEUnv7NuEypODEmW
        xffxE+LRR8mtaCn8em06MfE=
X-Google-Smtp-Source: APXvYqxYJKQaI1A/hxRqR8CvYj43GN48PgOy25YOnYeGGhaWKHpTJLJBfiJkP49xYftD397VrDLKQg==
X-Received: by 2002:a50:ba02:: with SMTP id g2mr7016908edc.16.1553270503251;
        Fri, 22 Mar 2019 09:01:43 -0700 (PDT)
Received: from archlinux-ryzen ([2a01:4f9:2a:1fae::2])
        by smtp.gmail.com with ESMTPSA id k13sm2749234edl.59.2019.03.22.09.01.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 22 Mar 2019 09:01:42 -0700 (PDT)
Date:   Fri, 22 Mar 2019 09:01:40 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Wenwen Wang <wang6495@umn.edu>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: davinci-isif: avoid uninitialized variable use
Message-ID: <20190322160140.GD21978@archlinux-ryzen>
References: <20190322143431.1235295-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322143431.1235295-1-arnd@arndb.de>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Mar 22, 2019 at 03:34:22PM +0100, Arnd Bergmann wrote:
> clang warns about a possible variable use that gcc never
> complained about:
> 
> drivers/media/platform/davinci/isif.c:982:32: error: variable 'frame_size' is uninitialized when used here
>       [-Werror,-Wuninitialized]
>                 dm365_vpss_set_pg_frame_size(frame_size);
>                                              ^~~~~~~~~~
> drivers/media/platform/davinci/isif.c:887:2: note: variable 'frame_size' is declared here
>         struct vpss_pg_frame_size frame_size;
>         ^
> 1 error generated.
> 
> There is no initialization for this variable at all, and there
> has never been one in the mainline kernel, so we really should
> not put that stack data into an mmio register.
> 
> On the other hand, I suspect that gcc checks the condition
> more closely and notices that the global
> isif_cfg.bayer.config_params.test_pat_gen flag is initialized
> to zero and never written to from any code path, so anything
> depending on it can be eliminated.
> 
> To shut up the clang warning, just remove the dead code manually,
> it has probably never been used because any attempt to do so
> would have resulted in undefined behavior.
> 
> Fixes: 63e3ab142fa3 ("V4L/DVB: V4L - vpfe capture - source for ISIF driver on DM365")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/media/platform/davinci/isif.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
> index 47cecd10eb9f..2dee9af6d413 100644
> --- a/drivers/media/platform/davinci/isif.c
> +++ b/drivers/media/platform/davinci/isif.c
> @@ -884,9 +884,7 @@ static int isif_set_hw_if_params(struct vpfe_hw_if_param *params)
>  static int isif_config_ycbcr(void)
>  {
>  	struct isif_ycbcr_config *params = &isif_cfg.ycbcr;
> -	struct vpss_pg_frame_size frame_size;
>  	u32 modeset = 0, ccdcfg = 0;
> -	struct vpss_sync_pol sync;
>  
>  	dev_dbg(isif_cfg.dev, "\nStarting isif_config_ycbcr...");
>  
> @@ -974,13 +972,6 @@ static int isif_config_ycbcr(void)
>  		/* two fields are interleaved in memory */
>  		regw(0x00000249, SDOFST);
>  
> -	/* Setup test pattern if enabled */
> -	if (isif_cfg.bayer.config_params.test_pat_gen) {
> -		sync.ccdpg_hdpol = params->hd_pol;
> -		sync.ccdpg_vdpol = params->vd_pol;
> -		dm365_vpss_set_sync_pol(sync);
> -		dm365_vpss_set_pg_frame_size(frame_size);
> -	}
>  	return 0;
>  }
>  
> -- 
> 2.20.0
> 

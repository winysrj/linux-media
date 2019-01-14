Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EBFC43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7553120657
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:47:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="SWJVUoDw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfANOri (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:47:38 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40809 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfANOrh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 09:47:37 -0500
Received: by mail-lf1-f65.google.com with SMTP id v5so15786274lfe.7
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 06:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=p2JTozOyIoMKsYsWjtsQXRvVw8bTMWZm1i6E76LSiy8=;
        b=SWJVUoDwBFSGNeKQcp1By+hVkbofmaF11K/yLG81ymTnj548PQ6W0+mmCkTwWqoNkN
         FkjiYcQEFn9lnOMHbzYLHJkNry9odBStH0OecwLsaqNsizXs7K1gmZF5l90nYI4sFlob
         fqp3q6VC8UCXn99iRLkeEZlwRPt1Z6MYOuVrTyfwvu3yZwcDoF+w+/8gZU9i0p9SDdAN
         SC86eqC2Q2iVJqqCejcr2WgAy9uEbtDvdW5UMtX+X5Xcms8trUXaiXIwZyU8TWaZB3jd
         9riZfDK+Kc2oTIm19/wIUwpvaBuTpv/AZM04BTtHNOAzjYkV4+71P/gH4qzmNmsMk/ZL
         qbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=p2JTozOyIoMKsYsWjtsQXRvVw8bTMWZm1i6E76LSiy8=;
        b=WNt6/S/b8h0tibG9BHXH9S7jsfMW3TzFexeh3veoW9T5buOFCfXdSsACXyGwjvEyjV
         s7D9eBBWVLlmzsQqoTEi2FHPSRggGIlr7V5d4AU/FrM6R41aXnOBgGSqGSlca4UptLtK
         d05tpEIDRYM8uuosUjlR8gPqgS7DM7uw3k4Qmqu2358PVvRmn9iL7CnK7idTJv1EScEg
         xJptBGhpj/iXZj4yzQyY26jl9esVu//14NiQaIyeW9269/ty3tqR+reehdg8lgeal78m
         5J3gEsCcmWyLDcA5jioI46h5R2S1Hzynl7z4HsM9xwlFyig2SrmWEVVncVHmMPPSNYXm
         lSLg==
X-Gm-Message-State: AJcUukehC4tHkkiicDLqxNcTSlHMkOP0MB5Z9+jQmwlK7B7JU9Hxmya+
        0RgkDELHnkT6452AGEZ8s6OwMmvKT5o=
X-Google-Smtp-Source: ALg8bN6sJOVivpd3mD+L41osiCaZK/n01yAzFLCXoxnnvM5obKmJSLJ0d9dXukq04pRkgYcEAaCwlQ==
X-Received: by 2002:a19:c801:: with SMTP id y1mr13118452lff.53.1547477255650;
        Mon, 14 Jan 2019 06:47:35 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id f8sm121775lfe.72.2019.01.14.06.47.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Jan 2019 06:47:35 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Mon, 14 Jan 2019 15:47:34 +0100
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 1/6] media: adv748x: Add is_txb()
Message-ID: <20190114144734.GI30160@bigcity.dyn.berto.se>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
 <20190110140213.5198-2-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190110140213.5198-2-jacopo+renesas@jmondi.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thanks for your patch.

On 2019-01-10 15:02:08 +0100, Jacopo Mondi wrote:
> Add small is_txb() macro to the existing is_txa() and use it where
> appropriate.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 2 +-
>  drivers/media/i2c/adv748x/adv748x.h      | 3 +++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 6ce21542ed48..b6b5d8c7ea7c 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -82,7 +82,7 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
>  		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
>  						  &state->hdmi.sd,
>  						  ADV748X_HDMI_SOURCE);
> -	if (!is_txa(tx) && is_afe_enabled(state))
> +	if (is_txb(tx) && is_afe_enabled(state))
>  		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
>  						  &state->afe.sd,
>  						  ADV748X_AFE_SOURCE);
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index b482c7fe6957..ab0c84adbea9 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -89,8 +89,11 @@ struct adv748x_csi2 {
>  
>  #define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)
>  #define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)
> +
>  #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
>  #define is_txa(_tx) ((_tx) == &(_tx)->state->txa)
> +#define is_txb(_tx) ((_tx) == &(_tx)->state->txb)
> +
>  #define is_afe_enabled(_state)					\
>  	((_state)->endpoints[ADV748X_PORT_AIN0] != NULL ||	\
>  	 (_state)->endpoints[ADV748X_PORT_AIN1] != NULL ||	\
> -- 
> 2.20.1
> 

-- 
Regards,
Niklas Söderlund

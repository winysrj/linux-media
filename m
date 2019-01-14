Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C518DC43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 835EF20657
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:44:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="fILeBQjR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfANOou (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:44:50 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37034 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfANOot (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 09:44:49 -0500
Received: by mail-lf1-f65.google.com with SMTP id y11so15786446lfj.4
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 06:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=7u/LtLG4xXiRck2kcwHfI1Xvp/3OjjIYUFQPxEIo9fQ=;
        b=fILeBQjRrForbqFfFKIhXeICrUBox2JSkfxdupU2aMb2Pxrd18n7WIIh+H1tkq6NCZ
         9malKJb+L3c/l7/BH1Yfi73uN+ZKr6x+R1fC6OJan92FszvrZd1a6GJlfogmyvu4zexi
         F7KoJ+x+gFNh+Jc8wIsMhZxWVqqJMAqok9dH5OI9KE/xPOSsBXYwwZdmwyjqetU6hNf8
         fP+htxz6GmrSyum0q5VDc8T3prVIYUe6BfZzB5GMrx1eNVY037eDpRJT+z1arbRx/EST
         xGWkIB60Z/8AkeqqYk+zSiQpdWQeMudNud7rnOgBpoxPC4dZxMl7ppg0VsBSPnEpnepw
         Vekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=7u/LtLG4xXiRck2kcwHfI1Xvp/3OjjIYUFQPxEIo9fQ=;
        b=CR44dOoLogy1YT4Kfmc16vJf44QkgzMos+stIaJgIUdBHJQtMLDhb7dDpGFU1Y6ZE0
         +UGGwx3ele0/aIN3Pp6QLYc32M2Ld9LGjlXGhQqm2kxVzUMEoVoAYSGWp7oLm7F+qqvm
         LrCEq5xzSQgnfB3vbdtiJ4OpJZwZYa49O32xmwShMb5GUPaD4GPli2e5oqqJ0AW0B4fs
         BvhKxlI07/BUTMkz1jCFWZasPqnv6/p4N5NnlatoM9QnyE/2LPYET1sEeVBU6ubohsmj
         K9uKSmg5oTv6pZUWKiw2ZR4I8yap4nuCRxqYBZswxDPCfNm2KaQLZ8Q9s7yLLN8nKek/
         d4YA==
X-Gm-Message-State: AJcUukeE22tB5+rukX3KEgyoy3TKtoAhcuS5vvHQwyzCFP6bFvFBWMn6
        LSgqoEfo9eyEr3UP2wzpi+x2CA==
X-Google-Smtp-Source: ALg8bN4NOcWNjt5auyFbt7Gl1sTchzPXnE37SKWTMHpkYEEQ68vzdMqPd0MPVF7t+/p0UrvBmPkMkw==
X-Received: by 2002:a19:d04d:: with SMTP id h74mr13144988lfg.52.1547477087761;
        Mon, 14 Jan 2019 06:44:47 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id j197sm114409lfe.24.2019.01.14.06.44.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Jan 2019 06:44:47 -0800 (PST)
Date:   Mon, 14 Jan 2019 15:44:46 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] media: i2c: adv748x: Remove PAGE_WAIT
Message-ID: <20190114144446.GH30160@bigcity.dyn.berto.se>
References: <20190111174141.12594-1-kieran.bingham+renesas@ideasonboard.com>
 <20190111174141.12594-3-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190111174141.12594-3-kieran.bingham+renesas@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

Thanks for your patch.

On 2019-01-11 17:41:41 +0000, Kieran Bingham wrote:
> The ADV748X_PAGE_WAIT is a fake page to insert arbitrary delays in the
> register tables.
> 
> Its only usage was removed, so we can remove the handling and simplify
> the code.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

With the change Laurent points out,

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 17 ++++++-----------
>  drivers/media/i2c/adv748x/adv748x.h      |  1 -
>  2 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 252bdb28b18b..8199e0b20790 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -219,18 +219,13 @@ static int adv748x_write_regs(struct adv748x_state *state,
>  	int ret;
>  
>  	while (regs->page != ADV748X_PAGE_EOR) {
> -		if (regs->page == ADV748X_PAGE_WAIT) {
> -			msleep(regs->value);
> -		} else {
> -			ret = adv748x_write(state, regs->page, regs->reg,
> -				      regs->value);
> -			if (ret < 0) {
> -				adv_err(state,
> -					"Error regs page: 0x%02x reg: 0x%02x\n",
> -					regs->page, regs->reg);
> -				return ret;
> -			}
> +		ret = adv748x_write(state, regs->page, regs->reg, regs->value);
> +		if (ret < 0) {
> +			adv_err(state, "Error regs page: 0x%02x reg: 0x%02x\n",
> +				regs->page, regs->reg);
> +			return ret;
>  		}
> +
>  		regs++;
>  	}
>  
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index 2f8d751cfbb0..5042f9e94aee 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -39,7 +39,6 @@ enum adv748x_page {
>  	ADV748X_PAGE_MAX,
>  
>  	/* Fake pages for register sequences */
> -	ADV748X_PAGE_WAIT,		/* Wait x msec */
>  	ADV748X_PAGE_EOR,		/* End Mark */
>  };
>  
> -- 
> 2.17.1
> 

-- 
Regards,
Niklas Söderlund

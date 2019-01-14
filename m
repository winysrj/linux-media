Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4B9C43444
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 032F720657
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:49:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="tk1KVXlf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfANOtP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:49:15 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40461 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfANOtP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 09:49:15 -0500
Received: by mail-lj1-f193.google.com with SMTP id n18-v6so19245670lji.7
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 06:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ViVuMjiaIKMQDQWtXKSWQSYTHONNBY4H8mC+Mt+mldg=;
        b=tk1KVXlfTAq1qRAWH7DSPFFlVpBvhsqOE8mWQNtKXXBTHMsxdiuE1sIyO1N5vjUisF
         eMgmylt7i37NNzMH2azjKvxBj+AExPq8r8jEck9UaS0utDh48kpIXmFmFpElWRWRgYE6
         D06iIqYnXMDRgKFN1MInHgqf6gkCpPhLDfe28ysFG+HlxjpR8qx2Xc1EagSP46HMpt/U
         s7UhAxKWcTQrK7efX6r8V4D0TlZ3lnx7scXy2rGvVbit8eYer2qUelkfp5Nu/kPyBkVF
         8c9Mf41HPDH668L4jwusCP4i66rnh7v/K9pgC5nO6ZuQvMNJ4w8EwrbDFVUsr0ALU13e
         ZtRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ViVuMjiaIKMQDQWtXKSWQSYTHONNBY4H8mC+Mt+mldg=;
        b=Fyfc93qXMOXvzmmuGw/mYl/526vSFqbxojRILae3XC9AVdUxUh3fcGOfcldocFNj86
         xZGNlXv6McSn07aS7nR6Rrenb2EjLc2u7Rt9gVfrvSYhz/F25asiLdJQokMKOIBMGh26
         pQ8MEKaUeWgYovgCvcBcqkbnwzH1wTkIuWR55PnHqEKvtqqgztMjpHP+eqNxfPVPfrQT
         EIFqyiwCDoCBh2USVZ4SoSxbx5pWydZwzoACjiz7dh2qIMlPgnE3K4mGilDkYNJPM9Bd
         dPmxYkMNHtkIBr4m6JqNRm8p0mlOvXfcu/p8GiBVnV/z1cxpSKtJdWlYvW56SEF6Brww
         oskw==
X-Gm-Message-State: AJcUukcWlGT24FN6VPV2wuZJW1z79h6WQ3z9EHpuFIxbRG2P3DqHYKPV
        cc8gXRpwKxedPq+XsK7vHiKIoQ==
X-Google-Smtp-Source: ALg8bN4WNprLkOb9bFZ4L34k5hB2G2yg7OE6i+GmXDYzox5Wz7p2IJlHeU6od21BK4x9jznvfrNGqw==
X-Received: by 2002:a2e:9c7:: with SMTP id 190-v6mr13041523ljj.120.1547477352580;
        Mon, 14 Jan 2019 06:49:12 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id h12-v6sm103837ljb.80.2019.01.14.06.49.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Jan 2019 06:49:11 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Mon, 14 Jan 2019 15:49:11 +0100
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 2/6] media: adv748x: Rename reset procedures
Message-ID: <20190114144911.GJ30160@bigcity.dyn.berto.se>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
 <20190110140213.5198-3-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190110140213.5198-3-jacopo+renesas@jmondi.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thanks for your work.

On 2019-01-10 15:02:09 +0100, Jacopo Mondi wrote:
> Rename the chip reset procedure as they configure the CP (HDMI) and SD
> (AFE) cores.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index d94c63cb6a2e..ad4e6424753a 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -353,9 +353,8 @@ static const struct adv748x_reg_value adv748x_sw_reset[] = {
>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>  };
>  
> -/* Supported Formats For Script Below */
> -/* - 01-29 HDMI to MIPI TxA CSI 4-Lane - RGB888: */
> -static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
> +/* Initialize CP Core with RGB888 format. */
> +static const struct adv748x_reg_value adv748x_init_hdmi[] = {
>  	/* Disable chip powerdown & Enable HDMI Rx block */
>  	{ADV748X_PAGE_IO, 0x00, 0x40},
>  
> @@ -399,10 +398,8 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>  };
>  
> -/* 02-01 Analog CVBS to MIPI TX-B CSI 1-Lane - */
> -/* Autodetect CVBS Single Ended In Ain 1 - MIPI Out */
> -static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
> -
> +/* Initialize AFE core with YUV8 format. */
> +static const struct adv748x_reg_value adv748x_init_afe[] = {
>  	{ADV748X_PAGE_IO, 0x00, 0x30},	/* Disable chip powerdown Rx */
>  	{ADV748X_PAGE_IO, 0xf2, 0x01},	/* Enable I2C Read Auto-Increment */
>  
> @@ -445,19 +442,18 @@ static int adv748x_reset(struct adv748x_state *state)
>  	if (ret < 0)
>  		return ret;
>  
> -	/* Init and power down TXA */
> -	ret = adv748x_write_regs(state, adv748x_init_txa_4lane);
> +	/* Initialize CP and AFE cores. */
> +	ret = adv748x_write_regs(state, adv748x_init_hdmi);
>  	if (ret)
>  		return ret;
>  
> -	adv748x_tx_power(&state->txa, 1);
> -	adv748x_tx_power(&state->txa, 0);
> -
> -	/* Init and power down TXB */
> -	ret = adv748x_write_regs(state, adv748x_init_txb_1lane);
> +	ret = adv748x_write_regs(state, adv748x_init_afe);
>  	if (ret)
>  		return ret;
>  
> +	/* Reset TXA and TXB */
> +	adv748x_tx_power(&state->txa, 1);
> +	adv748x_tx_power(&state->txa, 0);
>  	adv748x_tx_power(&state->txb, 1);
>  	adv748x_tx_power(&state->txb, 0);
>  
> -- 
> 2.20.1
> 

-- 
Regards,
Niklas Söderlund

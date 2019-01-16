Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D41EC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 13:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37FF82082F
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 13:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="kZjTLeWR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390831AbfAPNqi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:46:38 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35249 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393457AbfAPNqh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 08:46:37 -0500
Received: by mail-lj1-f194.google.com with SMTP id x85-v6so5505019ljb.2
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 05:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=SQOC3bLsNi6F9SrazSWdS2PkTfEaTrUZ3xABYY3scu0=;
        b=kZjTLeWREwoJ+KwkgDzQrn65N1iqmYVlrRW6RCtGcf+AL62CZ8yja5tHbtKNqJQlcD
         /dGtjdhsCS75anxTSR+T0KzynkQA0p9/Z+uodjv07Ed1ZWxwiCOrF6EKMIKZvyLikz9s
         BYvnpjvJMAU50SA+qDIgl342Sj3OGjOBbZTBOMqekZEPHlazI4d46Z8b+58B02fDYjye
         HuMgkj09eR4/yyCxorGODVPgbPi9V3tsSr/KtdhjxUThL0XU7hgd2emt9c5lpqrId47I
         Z5cYl6nMymBTxVbWsqnleXLj9EloGBsIxfC7ZdSrcpqjYTbJPCKSvq1/cPFN6WC2wSJh
         /t7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=SQOC3bLsNi6F9SrazSWdS2PkTfEaTrUZ3xABYY3scu0=;
        b=mqAUfiuIXxWEU96VLvIAVIV+Agqn5YIvlRGQkHQQiReQBkUSdLNw1xgwOIG9qC9DAK
         Sn+pzesWIm+Maf13MoTSJa9HmOA0Kch0U2TBVV3/ZCMPNw4qyPjOq+CNt3z79we/SIxo
         hOhqyFaBTKAD+fQdB4ZQhh7AJc6Y526YFJAJqIf++842EK4qFqak2DGGLzPl+8TuyqKz
         I58v/zFJBDgbUkxM2beAMrYjJf7hldGWqzt7PzgWVedl5rZlrKqOSVcJ7q2cPUbSDN0l
         mD4ztEJyLW0Mts/jSB7B+yICCarFmuxprf1g22MAWgMckfXPUr3o7NavVkX0/vwMwRJr
         HAGw==
X-Gm-Message-State: AJcUukenu/Xn7aNtXcqybov88YbgiqoKTajjC8gfC5+MDffk9wLcsW3x
        JX3dGOvUw21UYyoA8NU7w1Z5Mw==
X-Google-Smtp-Source: ALg8bN5wxxPci4ACxaYRiHk3HBySmud57ZwvNBROp2cegu06uvtzWur2XLPGN2R6ubvkE8NKTuyXHQ==
X-Received: by 2002:a2e:8605:: with SMTP id a5-v6mr6514414lji.145.1547646394749;
        Wed, 16 Jan 2019 05:46:34 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id q128-v6sm1059395ljq.14.2019.01.16.05.46.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 05:46:33 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Wed, 16 Jan 2019 14:46:33 +0100
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 6/6] media: adv748x: Implement TX link_setup callback
Message-ID: <20190116134633.GR7393@bigcity.dyn.berto.se>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
 <20190110140213.5198-7-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190110140213.5198-7-jacopo+renesas@jmondi.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thanks for your effort.

On 2019-01-10 15:02:13 +0100, Jacopo Mondi wrote:
> When the adv748x driver is informed about a link being created from HDMI or
> AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
> sure to implement proper routing management at link setup time, to route
> the selected video stream to the desired TX output.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 48 +++++++++++++++++++++++-
>  drivers/media/i2c/adv748x/adv748x.h      |  2 +
>  2 files changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 200e00f93546..ea7e5ca48f1a 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -335,6 +335,51 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
>  /* -----------------------------------------------------------------------------
>   * Media Operations
>   */
> +static int adv748x_link_setup(struct media_entity *entity,
> +			      const struct media_pad *local,
> +			      const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *rsd = media_entity_to_v4l2_subdev(remote->entity);
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct adv748x_state *state = v4l2_get_subdevdata(sd);
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +	bool enable = flags & MEDIA_LNK_FL_ENABLED;
> +	u8 io10_mask = ADV748X_IO_10_CSI1_EN |
> +		       ADV748X_IO_10_CSI4_EN |
> +		       ADV748X_IO_10_CSI4_IN_SEL_AFE;
> +	u8 io10 = 0;
> +
> +	/* Refuse to enable multiple links to the same TX at the same time. */
> +	if (enable && tx->src)
> +		return -EINVAL;
> +
> +	/* Set or clear the source (HDMI or AFE) and the current TX. */
> +	if (rsd == &state->afe.sd)
> +		state->afe.tx = enable ? tx : NULL;
> +	else
> +		state->hdmi.tx = enable ? tx : NULL;
> +
> +	tx->src = enable ? rsd : NULL;
> +
> +	if (state->afe.tx) {
> +		/* AFE Requires TXA enabled, even when output to TXB */
> +		io10 |= ADV748X_IO_10_CSI4_EN;
> +		if (is_txa(tx))
> +			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
> +		else
> +			io10 |= ADV748X_IO_10_CSI1_EN;
> +	}
> +
> +	if (state->hdmi.tx)
> +		io10 |= ADV748X_IO_10_CSI4_EN;
> +
> +	return io_clrset(state, ADV748X_IO_10, io10_mask, io10);
> +}
> +
> +static const struct media_entity_operations adv748x_tx_media_ops = {
> +	.link_setup	= adv748x_link_setup,
> +	.link_validate	= v4l2_subdev_link_validate,
> +};
>  
>  static const struct media_entity_operations adv748x_media_ops = {
>  	.link_validate = v4l2_subdev_link_validate,
> @@ -516,7 +561,8 @@ void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
>  		state->client->addr, ident);
>  
>  	sd->entity.function = function;
> -	sd->entity.ops = &adv748x_media_ops;
> +	sd->entity.ops = is_tx(adv748x_sd_to_csi2(sd)) ?
> +			 &adv748x_tx_media_ops : &adv748x_media_ops;
>  }
>  
>  static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index 934a9d9a75c8..b00c1995efb0 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -94,6 +94,7 @@ struct adv748x_csi2 {
>  #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
>  #define is_txa(_tx) ((_tx) == &(_tx)->state->txa)
>  #define is_txb(_tx) ((_tx) == &(_tx)->state->txb)
> +#define is_tx(_tx) (is_txa(_tx) || is_txb(_tx))
>  
>  #define is_afe_enabled(_state)					\
>  	((_state)->endpoints[ADV748X_PORT_AIN0] != NULL ||	\
> @@ -223,6 +224,7 @@ struct adv748x_state {
>  #define ADV748X_IO_10_CSI4_EN		BIT(7)
>  #define ADV748X_IO_10_CSI1_EN		BIT(6)
>  #define ADV748X_IO_10_PIX_OUT_EN	BIT(5)
> +#define ADV748X_IO_10_CSI4_IN_SEL_AFE	BIT(3)
>  
>  #define ADV748X_IO_CHIP_REV_ID_1	0xdf
>  #define ADV748X_IO_CHIP_REV_ID_2	0xe0
> -- 
> 2.20.1
> 

-- 
Regards,
Niklas Söderlund

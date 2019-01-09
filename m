Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E51C43444
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABAD320821
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:10:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="mq94oXys"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbfAIAKl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:10:41 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:41634 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbfAIAKl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:10:41 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 540DF586;
        Wed,  9 Jan 2019 01:10:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1546992638;
        bh=iQ3RjDvG+m0GBSOasB9i+iihKrFTusa86JEGXH/J5/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mq94oXyscXIXXj64Dah90ftc/FSOOnL0QcK6dLLQBdH45aOfJ+ccikJX0tIb3aJ97
         aJW5lCNcBryZyjoa43r0sh5siqo+x1hswlJ0Qwe+cflMDKP8ek9JmwZG2vNkfhJlg6
         Eu5HS2SbYUkqiMfnjQYYI3MFGios2YNGF2qewNEI=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 3/6] media: adv748x: csi2: Link AFE with TXA and TXB
Date:   Wed, 09 Jan 2019 02:11:47 +0200
Message-ID: <2046845.fJaF8tx5Pb@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20190106155413.30666-4-jacopo+renesas@jmondi.org>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org> <20190106155413.30666-4-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thank you for the patch.

On Sunday, 6 January 2019 17:54:10 EET Jacopo Mondi wrote:
> The ADV748x chip supports routing AFE output to either TXA or TXB.
> In order to support run-time configuration of video stream path, create an
> additional (not enabled) "AFE:8->TXA:0" link, and remove the IMMUTABLE flag
> from existing ones.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 44 +++++++++++++-----------
>  1 file changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c
> b/drivers/media/i2c/adv748x/adv748x-csi2.c index b6b5d8c7ea7c..9d391d6f752e
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -27,6 +27,7 @@ static int adv748x_csi2_set_virtual_channel(struct
> adv748x_csi2 *tx, * @v4l2_dev: Video registration device
>   * @src: Source subdevice to establish link
>   * @src_pad: Pad number of source to link to this @tx
> + * @enable: Link enabled flag
>   *
>   * Ensure that the subdevice is registered against the v4l2_device, and
> link the * source pad to the sink pad of the CSI2 bus entity.
> @@ -34,17 +35,11 @@ static int adv748x_csi2_set_virtual_channel(struct
> adv748x_csi2 *tx, static int adv748x_csi2_register_link(struct adv748x_csi2
> *tx,
>  				      struct v4l2_device *v4l2_dev,
>  				      struct v4l2_subdev *src,
> -				      unsigned int src_pad)
> +				      unsigned int src_pad,
> +				      bool enable)
>  {
> -	int enabled = MEDIA_LNK_FL_ENABLED;
>  	int ret;
> 
> -	/*
> -	 * Dynamic linking of the AFE is not supported.
> -	 * Register the links as immutable.
> -	 */
> -	enabled |= MEDIA_LNK_FL_IMMUTABLE;
> -
>  	if (!src->v4l2_dev) {
>  		ret = v4l2_device_register_subdev(v4l2_dev, src);
>  		if (ret)
> @@ -53,7 +48,7 @@ static int adv748x_csi2_register_link(struct adv748x_csi2
> *tx,
> 
>  	return media_create_pad_link(&src->entity, src_pad,
>  				     &tx->sd.entity, ADV748X_CSI2_SINK,
> -				     enabled);
> +				     enable ? MEDIA_LNK_FL_ENABLED : 0);
>  }
> 
>  /* ------------------------------------------------------------------------
> @@ -68,25 +63,32 @@ static int adv748x_csi2_registered(struct v4l2_subdev
> *sd) {
>  	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
>  	struct adv748x_state *state = tx->state;
> +	int ret;
> 
>  	adv_dbg(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
>  			sd->name);
> 
>  	/*
> -	 * The adv748x hardware allows the AFE to route through the TXA, however
> -	 * this is not currently supported in this driver.
> +	 * Link TXA to AFE and HDMI, and TXB to AFE only as TXB cannot output
> +	 * HDMI.
>  	 *
> -	 * Link HDMI->TXA, and AFE->TXB directly.
> +	 * The HDMI->TXA link is enabled by default, as the AFE->TXB is.
>  	 */
> -	if (is_txa(tx) && is_hdmi_enabled(state))
> -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> -						  &state->hdmi.sd,
> -						  ADV748X_HDMI_SOURCE);
> -	if (is_txb(tx) && is_afe_enabled(state))
> -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> -						  &state->afe.sd,
> -						  ADV748X_AFE_SOURCE);
> -	return 0;
> +	if (is_afe_enabled(state)) {
> +		ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
> +						 &state->afe.sd,
> +						 ADV748X_AFE_SOURCE,
> +						 is_txb(tx));
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Register link to HDMI for TXA only. */

I would have written "Create link", but then realized that the function is 
named adv748x_csi2_register_link(). Looking at its definition, I now see this 
means "register and link". That seems a bit of a hack, especially seeing how 
double registration is skipped in the function by checking src->v4l2_dev. 
Kieran, could this be fixed ?

> +	if (is_txb(tx) || !is_hdmi_enabled(state))
> +		return 0;
> +
> +	return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
> +					  ADV748X_HDMI_SOURCE, true);
>  }
> 
>  static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {

-- 
Regards,

Laurent Pinchart




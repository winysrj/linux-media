Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12591C43612
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D68B22177B
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="lpRZWg38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbfAJOgj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 09:36:39 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:50050 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbfAJOgj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 09:36:39 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id DFDE556D;
        Thu, 10 Jan 2019 15:36:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547130996;
        bh=EdhzNrS9kqvXBjh4u2WtYmigJIEP+vhbSp8z6LQ+fVo=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lpRZWg38VNEA5ErmC71B1s5ZX25ZSWzw52XjnPmcQ3MXwqi+wQiJ6EuIHgPJPBT3i
         Flcvvk1z/v61+MXUivxwBcSJNA6rfW9nTtnbQzb2mHWLUy8WE9Jr3jTGl09tMq3nnS
         njNPuxK2tqH2FEnbjnTpyNpxVfo9TsGS8tBq5EaQ=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3 6/6] media: adv748x: Implement TX link_setup callback
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
 <20190110140213.5198-7-jacopo+renesas@jmondi.org>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <ce01bf45-edda-beb2-70df-8c5a237ef515@ideasonboard.com>
Date:   Thu, 10 Jan 2019 14:36:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190110140213.5198-7-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thank you for the update,

On 10/01/2019 14:02, Jacopo Mondi wrote:
> When the adv748x driver is informed about a link being created from HDMI or
> AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
> sure to implement proper routing management at link setup time, to route
> the selected video stream to the desired TX output.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
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
> 

-- 
Regards
--
Kieran

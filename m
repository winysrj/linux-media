Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F06CC67872
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 028782080F
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="nHEK6tp9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 028782080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbeLMJjQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:39:16 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:43830 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbeLMJjQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:39:16 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D5890549;
        Thu, 13 Dec 2018 10:39:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544693954;
        bh=MJZGAT3Yp1odyeLeYRCTwTvHz2T7nV6dh0niHis6Y8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHEK6tp9/jU0emqlihAq5ZoMo2ts1jI195XRu23gXjitxpVpaEp6g4gZ6mAZ2vu+d
         gCepjIuOZtuA1/P5wtd2AYN69+DigXl9JIoKrAig225cywXEL7VUySv0XANYnGJ8C8
         jdggkJjASRiNduTHb2yeNEdXl2lFdxlZVrcU4OVA=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/5] media: adv748x: Implement link_setup callback
Date:   Thu, 13 Dec 2018 11:40:00 +0200
Message-ID: <2229088.MKf6aupnv1@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <1544541373-30044-6-git-send-email-jacopo+renesas@jmondi.org>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org> <1544541373-30044-6-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thank you for the patch.

On Tuesday, 11 December 2018 17:16:13 EET Jacopo Mondi wrote:
> When the adv748x driver is informed about a link being created from HDMI or
> AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
> sure to implement proper routing management at link setup time, to route
> the selected video stream to the desired TX output.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 63 ++++++++++++++++++++++++++++-
>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> b/drivers/media/i2c/adv748x/adv748x-core.c index f3aabbccdfb5..08dc0e89b053
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -335,9 +335,70 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
>  /* ------------------------------------------------------------------------
>   * Media Operations
>   */
> +static int adv748x_link_setup(struct media_entity *entity,
> +			      const struct media_pad *local,
> +			      const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *rsd = media_entity_to_v4l2_subdev(remote->entity);
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct adv748x_state *state = v4l2_get_subdevdata(sd);
> +	struct adv748x_csi2 *tx;
> +	struct media_link *link;
> +	u8 io10;
> +
> +	/*
> +	 * For each link setup from [HDMI|AFE] to TX we receive two
> +	 * notifications: "[HDMI|AFE]->TX" and "TX<-[HDMI|AFE]".
> +	 *
> +	 * Use the second notification form to make sure we're linking
> +	 * to a TX and find out from where, to set up routing properly.
> +	 */

Why don't you implement the link handler just for the TX entities then ?

> +	if ((sd != &state->txa.sd && sd != &state->txb.sd) ||
> +	    !(flags & MEDIA_LNK_FL_ENABLED))

When disabling the link you should reset the ->source and ->tx pointers.

> +		return 0;
> +	tx = adv748x_sd_to_csi2(sd);
> +
> +	/*
> +	 * Now that we're sure we're operating on one of the two TXs,
> +	 * make sure there are no enabled links ending there from
> +	 * either HDMI or AFE (this can only happens for TXA though).
> +	 */
> +	if (is_txa(tx))
> +		list_for_each_entry(link, &entity->links, list)
> +			if (link->sink->entity == entity &&
> +			    link->flags & MEDIA_LNK_FL_ENABLED)
> +				return -EINVAL;

You can simplify this by checking if tx->source == NULL (after resetting tx-
>source when disabling the link of course).

> +	/* Change video stream routing, according to the newly created link. */
> +	io10 = io_read(state, ADV748X_IO_10);
> +	if (rsd == &state->afe.sd) {
> +		state->afe.tx = tx;
> +
> +		/*
> +		 * If AFE is routed to TXA, make sure TXB is off;
> +		 * If AFE goes to TXB, we need TXA powered on.
> +		 */
> +		if (is_txa(tx)) {
> +			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
> +			io10 &= ~ADV748X_IO_10_CSI1_EN;
> +		} else {
> +			io10 |= ADV748X_IO_10_CSI4_EN |
> +				ADV748X_IO_10_CSI1_EN;
> +		}
> +	} else {
> +		state->hdmi.tx = tx;
> +		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
> +	}
> +	io_write(state, ADV748X_IO_10, io10);

Is it guaranteed that the chip will be powered on at this point ? How about 
writing the register at stream on time instead ?

> +	tx->rsd = rsd;
> +
> +	return 0;
> +}
> 
>  static const struct media_entity_operations adv748x_media_ops = {
> -	.link_validate = v4l2_subdev_link_validate,
> +	.link_setup	= adv748x_link_setup,
> +	.link_validate	= v4l2_subdev_link_validate,
>  };
> 
>  /* ------------------------------------------------------------------------
> -- diff --git a/drivers/media/i2c/adv748x/adv748x.h
> b/drivers/media/i2c/adv748x/adv748x.h index 0ee3b8d5c795..63a17c31c169
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -220,6 +220,7 @@ struct adv748x_state {
>  #define ADV748X_IO_10_CSI4_EN		BIT(7)
>  #define ADV748X_IO_10_CSI1_EN		BIT(6)
>  #define ADV748X_IO_10_PIX_OUT_EN	BIT(5)
> +#define ADV748X_IO_10_CSI4_IN_SEL_AFE	0x08
> 
>  #define ADV748X_IO_CHIP_REV_ID_1	0xdf
>  #define ADV748X_IO_CHIP_REV_ID_2	0xe0

-- 
Regards,

Laurent Pinchart




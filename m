Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59C2C6783C
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 23:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CA742084E
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 23:43:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="HaBKa/RF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CA742084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbeLKXnP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 18:43:15 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33264 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbeLKXnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 18:43:14 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D99A855A;
        Wed, 12 Dec 2018 00:43:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544571791;
        bh=mOCPYQ/Ikr8G1CpyBBQBomjFtJhgBeQPriVs3MIi0lg=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HaBKa/RFEAAKOrz2kksJuHKO2VD0L5hGH0jFHByKXrc/qo17/dQGE8olNXVVX2vkl
         ubqTpeUaJC4j+1YiCWTQfP4FSgnyr/Tx0DmBptvy+4COi7xIN34DACQBVOocKdfrcN
         4MSltNFVfyEOrLwYL8N/qeroVIry8MNqJG8OqLt0=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 5/5] media: adv748x: Implement link_setup callback
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
 <1544541373-30044-6-git-send-email-jacopo+renesas@jmondi.org>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <b4a718b4-ff9b-020e-d64e-09cf40747f6e@ideasonboard.com>
Date:   Tue, 11 Dec 2018 23:43:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1544541373-30044-6-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On 11/12/2018 15:16, Jacopo Mondi wrote:
> When the adv748x driver is informed about a link being created from HDMI or
> AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
> sure to implement proper routing management at link setup time, to route
> the selected video stream to the desired TX output.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 63 +++++++++++++++++++++++++++++++-
>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index f3aabbccdfb5..08dc0e89b053 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -335,9 +335,70 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
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


> +	if ((sd != &state->txa.sd && sd != &state->txb.sd) ||

I'm starting to think an 'is_txb(tx)' would help clean up some code ...
Then we could do the assignment of tx above, and then this line would read

  if ( (!(is_txa(tx) && !(is_txb(tx)))
     || !(flags & MEDIA_LNK_FL_ENABLED) )


It shouldn't matter that the adv748x_sd_to_csi2(sd) could be called on
non-TX SD's as they will then simply fail to match the above is_txa/is_txb.



> +	    !(flags & MEDIA_LNK_FL_ENABLED))
> +		return 0;

Don't we need to clear some local references when disabling links?

(or actually perhaps it doesn't matter if we keep stale references in a
disabled object, because it's disabled)

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
> +

What does this protect?

Doesn't this code read as:

  if (is TXA)
	for each entity
		Check all links - and if any are enabled, -EINVAL

Don't we ever want a link to be enabled on TXA?

(I must surely be mis-reading this - and it's nearly mid-night - so I'm
going to say I'm confused and it's time for me to stop and go to bed :D)


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
> +
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
>  /* -----------------------------------------------------------------------------
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index 0ee3b8d5c795..63a17c31c169 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -220,6 +220,7 @@ struct adv748x_state {
>  #define ADV748X_IO_10_CSI4_EN		BIT(7)
>  #define ADV748X_IO_10_CSI1_EN		BIT(6)
>  #define ADV748X_IO_10_PIX_OUT_EN	BIT(5)
> +#define ADV748X_IO_10_CSI4_IN_SEL_AFE	0x08

Should this be BIT(3)?

>  
>  #define ADV748X_IO_CHIP_REV_ID_1	0xdf
>  #define ADV748X_IO_CHIP_REV_ID_2	0xe0
> 

-- 
Regards
--
Kieran

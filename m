Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244B6C67839
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 23:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B05D32084C
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 23:07:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="BSDUrscC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B05D32084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbeLKXHQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 18:07:16 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:60332 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeLKXHQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 18:07:16 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A10C555A;
        Wed, 12 Dec 2018 00:07:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544569632;
        bh=WbqSL3M7wfTjsp1bche6D/ok1lWRv1ltwazSVq4HqEE=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BSDUrscCHU13pyEH561N86ffDkfyV6XOblxZlhYHdhMCmDVjkTgYMfFiZQ8XmZEMN
         4LKynRI2AvN2WXmlUqHyZsWqrYY4287JfJXABcuwkX4hF+fBrQbpNE/glPDTRbBs55
         2YUlDnL6Llh9hDGZuaE6o33wrR7tNmyHcm9rgQBQ=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 2/5] media: adv748x: csi2: Link AFE with TXA and TXB
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
 <1544541373-30044-3-git-send-email-jacopo+renesas@jmondi.org>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <fa3b9980-2a19-2e5a-2e37-e76f1ad04daa@ideasonboard.com>
Date:   Tue, 11 Dec 2018 23:07:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1544541373-30044-3-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thank you for the patch,

On 11/12/2018 15:16, Jacopo Mondi wrote:
> The ADV748x chip supports routing AFE output to either TXA or TXB.
> In order to support run-time configuration of video stream path, create an
> additional (not enabled) "AFE:8->TXA:0" link, and remove the IMMUTABLE flag
> from existing ones.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 48 ++++++++++++++++++++------------
>  1 file changed, 30 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 6ce21542ed48..4d1aefc2c8d0 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -27,6 +27,7 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
>   * @v4l2_dev: Video registration device
>   * @src: Source subdevice to establish link
>   * @src_pad: Pad number of source to link to this @tx
> + * @flags: Flags for the newly created link
>   *
>   * Ensure that the subdevice is registered against the v4l2_device, and link the
>   * source pad to the sink pad of the CSI2 bus entity.
> @@ -34,17 +35,11 @@ static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
>  static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
>  				      struct v4l2_device *v4l2_dev,
>  				      struct v4l2_subdev *src,
> -				      unsigned int src_pad)
> +				      unsigned int src_pad,
> +				      unsigned int flags)
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

Yup - that part certainly needs to go ...

>  	if (!src->v4l2_dev) {
>  		ret = v4l2_device_register_subdev(v4l2_dev, src);
>  		if (ret)
> @@ -53,7 +48,7 @@ static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
> 
>  	return media_create_pad_link(&src->entity, src_pad,
>  				     &tx->sd.entity, ADV748X_CSI2_SINK,
> -				     enabled);
> +				     flags);
>  }
> 
>  /* -----------------------------------------------------------------------------
> @@ -68,24 +63,41 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
>  {
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
> +	 * Link TXA to HDMI and AFE, and TXB to AFE only as TXB cannot output
> +	 * HDMI.
>  	 *
> -	 * Link HDMI->TXA, and AFE->TXB directly.
> +	 * The HDMI->TXA link is enabled by default, as the AFE->TXB is.
>  	 */
> -	if (is_txa(tx) && is_hdmi_enabled(state))
> -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> -						  &state->hdmi.sd,
> -						  ADV748X_HDMI_SOURCE);
> -	if (!is_txa(tx) && is_afe_enabled(state))
> +	if (is_txa(tx)) {
> +		if (is_hdmi_enabled(state)) {
> +			ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
> +							 &state->hdmi.sd,
> +							 ADV748X_HDMI_SOURCE,
> +							 MEDIA_LNK_FL_ENABLED);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		if (is_afe_enabled(state)) {
> +			ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
> +							 &state->afe.sd,
> +							 ADV748X_AFE_SOURCE,
> +							 0);
> +			if (ret)
> +				return ret;
> +		}


> +	} else if (is_afe_enabled(state))

I believe when adding braces to one side of an if statement, we are
supposed to add to the else clauses too ?

>  		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
>  						  &state->afe.sd,
> -						  ADV748X_AFE_SOURCE);
> +						  ADV748X_AFE_SOURCE,
> +						  MEDIA_LNK_FL_ENABLED);

Won't this enable the AFE link for both TXA and TXB ?
Which one will win? Just the last one ? the first one ?
Does it error?

(It might not be a problem ... I can't recall what the behaviour is)


> +

There are a lot of nested if's above, and I think we can simplify
greatly if we move the logic for the flags inside
adv748x_csi2_register_link(), and adjust the checks on is_xxx_enabled()

What do you think about the following pseudo code?:


int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
  				      struct v4l2_device *v4l2_dev,
  				      struct v4l2_subdev *src,
				      unsigned int src_pad,
				      bool enable)
{

  int flags = 0;
  int ret;

  if (!src->v4l2_dev) {
	ret = v4l2_device_register_subdev(v4l2_dev, src)
	if (ret) return ret;
  }

  if (enable)
	flags = MEDIA_LNK_FL_ENABLED;

   return media_create_pad_link(&src->entity, src_pad,
 			        &tx->sd.entity, ADV748X_CSI2_SINK,
 			        flags);
}

int adv748x_csi2_registered(struct v4l2_subdev *sd)
{
  int ret;

  if (is_afe_enabled(state) {
      ret = adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->afe.sd,
				   ADV748X_AFE_SOURCE, !is_txa(tx));
      if (ret)
	  return ret;
  }

  /* TX-B only supports AFE */
  if (!is_txa(tx) || !(is_hdmi_enabled(state))
	return 0;

  return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
				    ADV748X_HDMI_SOURCE, true);
}


The above will for TXA:
	register_link(..., AFE_SOURCE, enable = false );
	register_link(..., HDMI_SOURCE, enable = true );

then TXB:
	register_link(..., AFE_SOURCE, enable = true );

Does that meet our needs?




>  	return 0;
>  }
> 
> --
> 2.7.4
> 

-- 
Regards
--
Kieran

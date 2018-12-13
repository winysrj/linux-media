Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274EAC67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E02962080F
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="vdWDdZPW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E02962080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbeLMJdU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:33:20 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:43754 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbeLMJdU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:33:20 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 65F67549;
        Thu, 13 Dec 2018 10:33:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544693597;
        bh=CCZ9+iK2Ur/qtbyJRyv6wmaQ8C6tEa0ibKJiqH4zU9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdWDdZPW9G8euxok0qSU/obTcqEMuTWChPnm5oViemanEepMu3M0KTylP7ZPgd4x6
         FbmtC+/h02ob8tfqRlcR5xUpnXPRoIWjNxT+HWpHr5xEAi9ogctxys/20Nj7Ev6Dk6
         MUl7eZLJYWVH8b6kGu4YzXTvjjN498KYFmHdoBgE=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/5] media: adv748x: Store the TX sink in HDMI/AFE
Date:   Thu, 13 Dec 2018 11:34:03 +0200
Message-ID: <1922179.BUMsX2vHZM@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <1544541373-30044-5-git-send-email-jacopo+renesas@jmondi.org>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org> <1544541373-30044-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thank you for the patch.

On Tuesday, 11 December 2018 17:16:12 EET Jacopo Mondi wrote:
> Both the AFE and HDMI s_stream routines (adv748x_afe_s_stream() and
> adv748x_hdmi_s_stream()) have to enable the CSI-2 TX they are streaming
> video data to.
> 
> With the introduction of dynamic routing between HDMI and AFE entities to
> TXA, the video stream sink needs to be set at run time, and not statically
> selected as the s_stream functions are currently doing.
> 
> To fix this, store a reference to the active CSI-2 TX sink for both HDMI and
> AFE sources, and operate on it when starting/stopping the stream.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 19 ++++++++++++++-----
>  drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
>  drivers/media/i2c/adv748x/adv748x.h      |  4 ++++
>  4 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c
> b/drivers/media/i2c/adv748x/adv748x-afe.c index 71714634efb0..dbbb1e4d6363
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -282,7 +282,7 @@ static int adv748x_afe_s_stream(struct v4l2_subdev *sd,
> int enable) goto unlock;
>  	}
> 
> -	ret = adv748x_tx_power(&state->txb, enable);
> +	ret = adv748x_tx_power(afe->tx, enable);
>  	if (ret)
>  		goto unlock;
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c
> b/drivers/media/i2c/adv748x/adv748x-csi2.c index 307966f4c736..0d6344a51795
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -85,6 +85,9 @@ static int adv748x_csi2_registered(struct v4l2_subdev *sd)
> MEDIA_LNK_FL_ENABLED);
>  			if (ret)
>  				return ret;
> +
> +			/* The default HDMI output is TXA. */
> +			state->hdmi.tx = tx;
>  		}
> 
>  		if (is_afe_enabled(state)) {
> @@ -95,11 +98,17 @@ static int adv748x_csi2_registered(struct v4l2_subdev
> *sd) if (ret)
>  				return ret;
>  		}
> -	} else if (is_afe_enabled(state))
> -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> -						  &state->afe.sd,
> -						  ADV748X_AFE_SOURCE,
> -						  MEDIA_LNK_FL_ENABLED);
> +	} else if (is_afe_enabled(state)) {
> +		ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
> +						 &state->afe.sd,
> +						 ADV748X_AFE_SOURCE,
> +						 MEDIA_LNK_FL_ENABLED);
> +		if (ret)
> +			return ret;
> +
> +		/* The default AFE output is TXB. */
> +		state->afe.tx = tx;
> +	}
> 
>  	return 0;
>  }
> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> b/drivers/media/i2c/adv748x/adv748x-hdmi.c index 35d027941482..c557f8fdf11a
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> @@ -358,7 +358,7 @@ static int adv748x_hdmi_s_stream(struct v4l2_subdev *sd,
> int enable)
> 
>  	mutex_lock(&state->mutex);
> 
> -	ret = adv748x_tx_power(&state->txa, enable);
> +	ret = adv748x_tx_power(hdmi->tx, enable);
>  	if (ret)
>  		goto done;
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x.h
> b/drivers/media/i2c/adv748x/adv748x.h index 387002d6da65..0ee3b8d5c795
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -118,6 +118,8 @@ struct adv748x_hdmi {
>  	struct v4l2_dv_timings timings;
>  	struct v4l2_fract aspect_ratio;
> 
> +	struct adv748x_csi2 *tx;
> +
>  	struct {
>  		u8 edid[512];
>  		u32 present;
> @@ -148,6 +150,8 @@ struct adv748x_afe {
>  	struct v4l2_subdev sd;
>  	struct v4l2_mbus_framefmt format;
> 
> +	struct adv748x_csi2 *tx;
> +
>  	bool streaming;
>  	v4l2_std_id curr_norm;
>  	unsigned int input;

This may call for defining a common structure to store the common fields of 
adv748x_hdmi and adv748x_afe. Out of scope for this patch, but please keep it 
in mind.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart




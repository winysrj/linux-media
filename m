Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533B1C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A1FA20849
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="vR+KoMXM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A1FA20849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbeLMJ2l (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:28:41 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:43702 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbeLMJ2k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:28:40 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8D320549;
        Thu, 13 Dec 2018 10:28:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544693317;
        bh=DGAxDZflpC8lzriPUAkQg28jTU+pKWNl58DR9czCoRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vR+KoMXMvKDTy6G0FRAXC6Ijcsxu04+jP6nLpQJyhWturGwWW5kBXjAo+ClHvFMND
         l6qATHs5WW6fvmVGeklHoOEp1iCyXHm/H9e3XuI3QON2lVa/wADkewRdZk9JMXVzhN
         Qu4mgeRCCOzHPjwROHsU0hKaXF8X9AGdsfhrQYBE=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/5] media: adv748x: Store the source subdevice in TX
Date:   Thu, 13 Dec 2018 11:29:24 +0200
Message-ID: <3458994.7daZaNYgSu@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <1544541373-30044-4-git-send-email-jacopo+renesas@jmondi.org>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org> <1544541373-30044-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thank you for the patch.

On Tuesday, 11 December 2018 17:16:11 EET Jacopo Mondi wrote:
> The power_up_tx() procedure needs to set a few registers conditionally to
> the selected video source, but it currently checks for the provided tx to
> be either TXA or TXB.
> 
> With the introduction of dynamic routing between HDMI and AFE entities to
> TXA, checking which TX the function is operating on is not meaningful
> anymore.
> 
> To fix this, store the subdevice of the source providing video data to the
> CSI-2 TX in the 'struct adv748x_csi2' representing the TX and check on it.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 2 +-
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 3 +++
>  drivers/media/i2c/adv748x/adv748x.h      | 1 +
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> b/drivers/media/i2c/adv748x/adv748x-core.c index 5495dc7891e8..f3aabbccdfb5
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -254,7 +254,7 @@ static int adv748x_power_up_tx(struct adv748x_csi2 *tx)
>  	adv748x_write_check(state, page, 0x00, 0xa0 | tx->num_lanes, &ret);
> 
>  	/* ADI Required Write */
> -	if (is_txa(tx)) {
> +	if (tx->rsd == &state->hdmi.sd) {
>  		adv748x_write_check(state, page, 0xdb, 0x10, &ret);
>  		adv748x_write_check(state, page, 0xd6, 0x07, &ret);
>  	} else {
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c
> b/drivers/media/i2c/adv748x/adv748x-csi2.c index 4d1aefc2c8d0..307966f4c736
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -46,6 +46,9 @@ static int adv748x_csi2_register_link(struct adv748x_csi2
> *tx, return ret;
>  	}
> 
> +	if (flags & MEDIA_LNK_FL_ENABLED)
> +		tx->rsd = src;
> +
>  	return media_create_pad_link(&src->entity, src_pad,
>  				     &tx->sd.entity, ADV748X_CSI2_SINK,
>  				     flags);
> diff --git a/drivers/media/i2c/adv748x/adv748x.h
> b/drivers/media/i2c/adv748x/adv748x.h index b482c7fe6957..387002d6da65
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -85,6 +85,7 @@ struct adv748x_csi2 {
>  	struct v4l2_ctrl_handler ctrl_hdl;
>  	struct v4l2_ctrl *pixel_rate;
>  	struct v4l2_subdev sd;
> +	struct v4l2_subdev *rsd;

How about naming this source instead of rsd ? rsd is a bit cryptic.

With that change,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  };
> 
>  #define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)

-- 
Regards,

Laurent Pinchart




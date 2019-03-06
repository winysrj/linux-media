Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19519C10F00
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 19:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E352120661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 19:15:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="uoOMiBHt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfCFTPa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 14:15:30 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:41022 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfCFTP3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 14:15:29 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 05EFF242;
        Wed,  6 Mar 2019 20:15:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551899728;
        bh=EYX97lC0nyQAK/XNAW7yCh9+61BXDQa/bGN9hQNsFlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uoOMiBHtshP3WNa9RUHYaOJaI2ahBWp1E9V6KGQO3zHP+S6fVGpL2By1n7xG7LGWj
         t5cF2cuNCp1MILrmdRWwi7+siAfi29thuRPEiObNCPk9ERErkWkX8FBn1dnhUQtM8r
         oJYMh9l5PnLivu4lRWMMWcK/JmzzGi49BoaMYWjc=
Date:   Wed, 6 Mar 2019 21:15:21 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: adv748x: Don't disable CSI-2 on link_setup
Message-ID: <20190306191521.GE4791@pendragon.ideasonboard.com>
References: <20190306112659.8310-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190306112659.8310-1-jacopo+renesas@jmondi.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Wed, Mar 06, 2019 at 12:26:59PM +0100, Jacopo Mondi wrote:
> When both the media links between AFE and HDMI and the two TX CSI-2 outputs
> gets disabled, the routing register ADV748X_IO_10 gets zeroed causing both
> TXA and TXB output to get disabled.
> 
> This causes some HDMI transmitters to stop working after both AFE and
> HDMI links are disabled.

Could you elaborate on why this would be the case ? By HDMI transmitter,
I assume you mean the device connected to the HDMI input of the ADV748x.
Why makes it fail (and how ?) when the TXA and TXB are both disabled ?

> Fix this by preventing writing 0 to
> ADV748X_IO_10 register, which gets only updated when links are enabled
> again.
> 
> Fixes: 9423ca350df7 ("media: adv748x: Implement TX link_setup callback")
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
> The issue presents itself only on some HDMI transmitters, and went unnoticed
> during the development of:
> "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
> 
> Patch intended to be applied on top of latest media-master, where the
> "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
> series is applied.
> 
> The patch reports a "Fixes" tag, but should actually be merged with the above
> mentioned series.
> 
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index f57cd77a32fa..0e5a75eb6d75 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -354,6 +354,9 @@ static int adv748x_link_setup(struct media_entity *entity,
> 
>  	tx->src = enable ? rsd : NULL;
> 
> +	if (!enable)
> +		return 0;
> +
>  	if (state->afe.tx) {
>  		/* AFE Requires TXA enabled, even when output to TXB */
>  		io10 |= ADV748X_IO_10_CSI4_EN;

-- 
Regards,

Laurent Pinchart

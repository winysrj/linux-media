Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 289E8C10F0C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9F472086A
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:27:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="uK6h+qpR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfCKJ1f (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 05:27:35 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51180 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfCKJ1e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 05:27:34 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 04176304;
        Mon, 11 Mar 2019 10:27:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552296452;
        bh=jHXXRXfsT2OA0BFA6I7XyrPhfYHrJoWByVXv/scKvrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uK6h+qpRmXJWAeFOLSNRxEC02DYEnYCFwFQ2VAxCYewn3SzLndakwCIIYxvuBJlMF
         wr80vRk5U8MvmL1OODIA1DK73vWF8yPDEughacvhfJX9qd5TQE+dmIms6FR/gFB5L1
         sLFGJs0O7KD4c0txsGYaxviivzR/JZPdUDeQcVK4=
Date:   Mon, 11 Mar 2019 11:27:25 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v2 2/3] rcar-csi2: Update start procedure for H3 ES2
Message-ID: <20190311092725.GI4775@pendragon.ideasonboard.com>
References: <20190308235702.27057-1-niklas.soderlund+renesas@ragnatech.se>
 <20190308235702.27057-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190308235702.27057-3-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Sat, Mar 09, 2019 at 12:57:01AM +0100, Niklas Söderlund wrote:
> Latest information from hardware engineers reveals that H3 ES2 and ES3
> behave differently when working with link speeds bellow 250 Mpbs.
> Add a SoC match for H3 ES2.* and use the correct startup sequence.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 39 ++++++++++++++++++---
>  1 file changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index 6be81d4839f35a0e..07d5c8c66b7cd382 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -914,6 +914,25 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned int mbps)
>  	return rcsi2_phtw_write_array(priv, step2);
>  }
>  
> +static int rcsi2_init_phtw_h3es2(struct rcar_csi2 *priv, unsigned int mbps)
> +{
> +	static const struct phtw_value step1[] = {
> +		{ .data = 0xcc, .code = 0xe2 },
> +		{ .data = 0x01, .code = 0xe3 },
> +		{ .data = 0x11, .code = 0xe4 },
> +		{ .data = 0x01, .code = 0xe5 },
> +		{ .data = 0x10, .code = 0x04 },
> +		{ .data = 0x38, .code = 0x08 },
> +		{ .data = 0x01, .code = 0x00 },
> +		{ .data = 0x4b, .code = 0xac },
> +		{ .data = 0x03, .code = 0x00 },
> +		{ .data = 0x80, .code = 0x07 },
> +		{ /* sentinel */ },
> +	};
> +
> +	return rcsi2_phtw_write_array(priv, step1);

Another option would have been to condition the mbps check in
rcsi2_init_phtw_h3_v3h_m3n() to the ES version, which would save a bit
of memory as we could remove the above table, but we would need to add a
field to the rcar_csi2_info structure so we may not save much in the
end.

I wonder, however, if you could move the step1 and step2 tables out of
rcsi2_init_phtw_h3_v3h_m3n() and reuse them here, or possibly create a
__rcsi2_init_phtw_h3_v3h_m3n() with two rcsi2_init_phtw_h3_v3h_m3n() and
wrappers rcsi2_init_phtw_h3es2() wrappers.

> +}
> +
>  static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
>  {
>  	return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> @@ -976,6 +995,14 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a7795es1 = {
>  	.num_channels = 4,
>  };
>  
> +static const struct rcar_csi2_info rcar_csi2_info_r8a7795es2 = {
> +	.init_phtw = rcsi2_init_phtw_h3es2,
> +	.hsfreqrange = hsfreqrange_h3_v3h_m3n,
> +	.csi0clkfreqrange = 0x20,
> +	.num_channels = 4,
> +	.clear_ulps = true,
> +};
> +
>  static const struct rcar_csi2_info rcar_csi2_info_r8a7796 = {
>  	.hsfreqrange = hsfreqrange_m3w_h3es1,
>  	.num_channels = 4,
> @@ -1041,11 +1068,15 @@ static const struct of_device_id rcar_csi2_of_table[] = {
>  };
>  MODULE_DEVICE_TABLE(of, rcar_csi2_of_table);
>  
> -static const struct soc_device_attribute r8a7795es1[] = {
> +static const struct soc_device_attribute r8a7795[] = {
>  	{
>  		.soc_id = "r8a7795", .revision = "ES1.*",
>  		.data = &rcar_csi2_info_r8a7795es1,
>  	},
> +	{
> +		.soc_id = "r8a7795", .revision = "ES2.*",
> +		.data = &rcar_csi2_info_r8a7795es2,
> +	},
>  	{ /* sentinel */ },
>  };
>  
> @@ -1063,10 +1094,10 @@ static int rcsi2_probe(struct platform_device *pdev)
>  	priv->info = of_device_get_match_data(&pdev->dev);
>  
>  	/*
> -	 * r8a7795 ES1.x behaves differently than the ES2.0+ but doesn't
> -	 * have it's own compatible string.
> +	 * The different ES versions of r8a7795 (H3) behave differently but
> +	 * share the same compatible string.
>  	 */
> -	attr = soc_device_match(r8a7795es1);
> +	attr = soc_device_match(r8a7795);
>  	if (attr)
>  		priv->info = attr->data;
>  

-- 
Regards,

Laurent Pinchart

Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4553BC4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 141362173C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:16:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="EVcKj0zS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfCMAQ3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:16:29 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42414 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfCMAQ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:16:29 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0A2AD49;
        Wed, 13 Mar 2019 01:16:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552436187;
        bh=8Ge3JC4BlOo5XeZoDqS/Awd+WHSWtMBnuEjY0QS7p6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EVcKj0zSydrgeiZV4EjFHhfukupDueCsXbIbBoEoYDHZWtQSPIYww095CPEFTCpF2
         PbpSOi06e0F6/DckqWs5jUPshgjnc6fMjcQa+Tglsiss1m6s+AAXNHv7oyenNJ46MC
         x7gNW6YoNYN08zpvdGwe2AqFxtXA02Gxqis3OSIY=
Date:   Wed, 13 Mar 2019 02:16:20 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 2/3] rcar-csi2: Update start procedure for H3 ES2
Message-ID: <20190313001620.GG891@pendragon.ideasonboard.com>
References: <20190312235019.23420-1-niklas.soderlund+renesas@ragnatech.se>
 <20190312235019.23420-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190312235019.23420-3-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Wed, Mar 13, 2019 at 12:50:18AM +0100, Niklas Söderlund wrote:
> Latest information from hardware engineers reveals that H3 ES2 and ES3
> behave differently when working with link speeds bellow 250 Mpbs.
> Add a SoC match for H3 ES2.* and use the correct startup sequence.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 35 +++++++++++++++++----
>  1 file changed, 29 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index aaf35afc6c87b3c0..0a4a71be60bee89b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -875,7 +875,8 @@ static int rcsi2_phtw_write_mbps(struct rcar_csi2 *priv, unsigned int mbps,
>  	return rcsi2_phtw_write(priv, value->reg, code);
>  }
>  
> -static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned int mbps)
> +static int __rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv,
> +					unsigned int mbps)
>  {
>  	static const struct phtw_value step1[] = {
>  		{ .data = 0xcc, .code = 0xe2 },
> @@ -901,7 +902,7 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned int mbps)
>  	if (ret)
>  		return ret;
>  
> -	if (mbps <= 250) {
> +	if (mbps != 0 && mbps <= 250) {

I would have gone for a third argument, but this works too, and is
probably a tad more efficient. If we later need mbps here for other
reasons on ES2.0 we can always change the code, so

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  		ret = rcsi2_phtw_write(priv, 0x39, 0x05);
>  		if (ret)
>  			return ret;
> @@ -915,6 +916,16 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned int mbps)
>  	return rcsi2_phtw_write_array(priv, step2);
>  }
>  
> +static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned int mbps)
> +{
> +	return __rcsi2_init_phtw_h3_v3h_m3n(priv, mbps);
> +}
> +
> +static int rcsi2_init_phtw_h3es2(struct rcar_csi2 *priv, unsigned int mbps)
> +{
> +	return __rcsi2_init_phtw_h3_v3h_m3n(priv, 0);
> +}
> +
>  static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
>  {
>  	return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> @@ -977,6 +988,14 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a7795es1 = {
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
> @@ -1042,11 +1061,15 @@ static const struct of_device_id rcar_csi2_of_table[] = {
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
> @@ -1064,10 +1087,10 @@ static int rcsi2_probe(struct platform_device *pdev)
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

Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00B2C10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 11:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E420217D9
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 11:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="sPUXuKJ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbfBRLB4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 06:01:56 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:40160 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbfBRLB4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 06:01:56 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B40E449;
        Mon, 18 Feb 2019 12:01:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550487714;
        bh=1SU4dnQM3xjqNPQ4jw13hOFG8zQe8bBUdlFW29/6foo=;
        h=Subject:To:Cc:References:Reply-To:From:Date:In-Reply-To:From;
        b=sPUXuKJ4Kr4kkOdx5VyXv9VDLIq1dRNMrScNGU58eKrlxIeyGzxqrsanwsvwXx8Ta
         wVK4gEtO5S6NLJ20U/43tSCmn6sYhSaiXZ5aK8GXSDiPBYkhjL1XiBlIdoozhJbygv
         B0IamwSsa/5h5lQWqdS9KnhRZEm+6slSciIdEtI4=
Subject: Re: [PATCH 2/3] rcar-csi2: Update start procedure for H3 ES2
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org
References: <20190218100313.14529-1-niklas.soderlund+renesas@ragnatech.se>
 <20190218100313.14529-3-niklas.soderlund+renesas@ragnatech.se>
Reply-To: kieran.bingham@ideasonboard.com
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <e00ba393-0c42-36ff-e491-e24d83913385@ideasonboard.com>
Date:   Mon, 18 Feb 2019 11:01:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190218100313.14529-3-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

On 18/02/2019 10:03, Niklas Söderlund wrote:
> Latest information from hardware engineers reveals that H3 ES2 and ES3
> of behaves differently when working with link speeds bellow 250 Mpbs.

of? "of the rcar-csi2?"

> Add a SoC match for H3 ES2.* and use the correct startup sequence.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Assuming the step1 table is accurate, which I have not yet been able to
validate:

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 39 ++++++++++++++++++---
>  1 file changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index fbbe86a7a0fe14ab..50486301c21b4bae 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -932,6 +932,25 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned int mbps)
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

This looks reasonable - but I can't identify a table to verify these values.

Is this generated from the flow charts in section 25.3.9?


> +	return rcsi2_phtw_write_array(priv, step1);
> +}
> +
>  static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
>  {
>  	return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> @@ -994,6 +1013,14 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a7795es1 = {
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
> @@ -1059,11 +1086,15 @@ static const struct of_device_id rcar_csi2_of_table[] = {
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
> @@ -1081,10 +1112,10 @@ static int rcsi2_probe(struct platform_device *pdev)
>  	priv->info = of_device_get_match_data(&pdev->dev);
>  
>  	/*
> -	 * r8a7795 ES1.x behaves differently than the ES2.0+ but doesn't
> -	 * have it's own compatible string.
> +	 * The different ES versions of r8a7795 (H3) behaves differently but

s/behaves/behave/

> +	 * shares the same compatible string.

s/shares/share/

>  	 */
> -	attr = soc_device_match(r8a7795es1);
> +	attr = soc_device_match(r8a7795);
>  	if (attr)
>  		priv->info = attr->data;
>  
> 


-- 
Regards
--
Kieran

Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5A4C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09D482075C
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:45:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="KBlR6Dct"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfCNOpV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:45:21 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:50137 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726914AbfCNOpV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 10:45:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=egcEANuDr6b7DVEgL+kjKkBINA4M++PlfprPG6r6tXA=; b=KBlR6Dctq3VB/DvLN+3m9saIiq
        kd3i+wfrrJesheHUH6z/or7UrrTqFqcYqDO4pP7A2PILPryhiveLYTnF4JgCf9kbS45FEl8kBFHEV
        rrH9WKiiqXe8KEcS/OiHDp03+PYpN93F7SnGRbOlzAuLSYPiwY9CdOEfw/4Hd2aU47RQ=;
Received: from [109.168.11.45] (port=50896 helo=[192.168.101.76])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1h4Rbj-00HHDE-0H; Thu, 14 Mar 2019 15:45:19 +0100
Subject: Re: [PATCH v3 28/31] adv748x: afe: Implement has_route()
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-29-jacopo+renesas@jmondi.org>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <62dc5251-01d7-4d6c-7bc8-83e29cb710f0@lucaceresoli.net>
Date:   Thu, 14 Mar 2019 15:45:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190305185150.20776-29-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On 05/03/19 19:51, Jacopo Mondi wrote:
> Now that the adv748x subdevice supports internal routing, add an
> has_route() operation used during media graph traversal.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c | 26 +++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> index 3f770f71413f..39ac55f0adbb 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -463,6 +463,30 @@ static const struct v4l2_subdev_ops adv748x_afe_ops = {
>  	.pad = &adv748x_afe_pad_ops,
>  };
>  
> +/* -----------------------------------------------------------------------------
> + * media_entity_operations
> + */
> +
> +static bool adv748x_afe_has_route(struct media_entity *entity,
> +				  unsigned int pad0, unsigned int pad1)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
> +
> +	/* Only consider direct sink->source routes. */
> +	if (pad0 > ADV748X_AFE_SINK_AIN7 ||
> +	    pad1 != ADV748X_AFE_SOURCE)
> +		return false;
> +
> +	if (pad0 != afe->input)
> +		return false;
> +
> +	return true;
> +}
> +
> +static const struct media_entity_operations adv748x_afe_entity_ops = {
> +	.has_route = adv748x_afe_has_route,
> +};

Missing empty line.

>  /* -----------------------------------------------------------------------------
>   * Controls
>   */

-- 
Luca

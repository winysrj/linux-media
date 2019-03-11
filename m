Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274BCC4360F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB1FC2084F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:29:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Jm5hr6FQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfCKJ3K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 05:29:10 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51450 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbfCKJ3J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 05:29:09 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 33EA5255;
        Mon, 11 Mar 2019 10:29:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552296548;
        bh=lhgOhp5SSrzRDM5MonDKTSPmKJg85AIj3lRDZqI5pPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jm5hr6FQq5gUWkrdkcWCb7lRbntxTFUkYHCTLPgstgxfPmWc1iq5PYwaWXHrwqYqO
         jv98tu0kgVYpJ3iQYFi4cSrU4IJmR69iSUFHdm++wfQRE6siXMqCON8PD4AmCKxDzn
         dfM+PL3DbHZmuzZqTamS2aGyIIkbZ/NIRn22/1sk=
Date:   Mon, 11 Mar 2019 11:29:02 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: Re: [PATCH v2 1/3] rcar-csi2: Update V3M and E3 start procedure
Message-ID: <20190311092902.GJ4775@pendragon.ideasonboard.com>
References: <20190308235702.27057-1-niklas.soderlund+renesas@ragnatech.se>
 <20190308235702.27057-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190308235702.27057-2-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Sat, Mar 09, 2019 at 12:57:00AM +0100, Niklas Söderlund wrote:
> The latest datasheet (rev 1.50) updates the start procedure for V3M and
> E3. Update the driver to match these changes.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>

This matches the datasheet, so

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index d9b29dbbcc2949de..6be81d4839f35a0e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -922,11 +922,11 @@ static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
>  static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
>  {
>  	static const struct phtw_value step1[] = {
> -		{ .data = 0xed, .code = 0x34 },
> -		{ .data = 0xed, .code = 0x44 },
> -		{ .data = 0xed, .code = 0x54 },
> -		{ .data = 0xed, .code = 0x84 },
> -		{ .data = 0xed, .code = 0x94 },
> +		{ .data = 0xee, .code = 0x34 },
> +		{ .data = 0xee, .code = 0x44 },
> +		{ .data = 0xee, .code = 0x54 },
> +		{ .data = 0xee, .code = 0x84 },
> +		{ .data = 0xee, .code = 0x94 },
>  		{ /* sentinel */ },
>  	};
>  

-- 
Regards,

Laurent Pinchart

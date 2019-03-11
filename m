Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1784C10F0C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C602084D
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="SktBlG+E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfCKJjS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 05:39:18 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:52544 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbfCKJjS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 05:39:18 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 12159304;
        Mon, 11 Mar 2019 10:39:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552297156;
        bh=MSovuMsMWqVwIXKVodAnJrIZAie8ACFBUjYrR8bOHYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SktBlG+EX1qNCJVCpC/o+cuayEJq2L0w/jL0eYEz6S6wZ41AH8EecaOJxIHHkik2T
         Hn1QTzen9Fx/uU9TPe3AQRs+kLA3rwUi0lgYXk5KnRijCJjoQZlZybXasHV5aBfrth
         7SG+oKbNPZA1tc61SUZv5nhXLdUn8CLy1tH2qf7Q=
Date:   Mon, 11 Mar 2019 11:39:10 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v2 3/3] rcar-csi2: Move setting of Field Detection
 Control Register
Message-ID: <20190311093910.GK4775@pendragon.ideasonboard.com>
References: <20190308235702.27057-1-niklas.soderlund+renesas@ragnatech.se>
 <20190308235702.27057-4-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190308235702.27057-4-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Sat, Mar 09, 2019 at 12:57:02AM +0100, Niklas Söderlund wrote:
> Latest datasheet (rev 1.50) clarifies that the FLD register should be
> set after LINKCNT.

Wasn't this already the case in rev 1.00 ?

> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index 07d5c8c66b7cd382..077e0d344b395b54 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -529,7 +529,6 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  	rcsi2_write(priv, PHTC_REG, 0);
>  
>  	/* Configure */
> -	rcsi2_write(priv, FLD_REG, fld);
>  	rcsi2_write(priv, VCDT_REG, vcdt);
>  	if (vcdt2)
>  		rcsi2_write(priv, VCDT2_REG, vcdt2);
> @@ -560,6 +559,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  	rcsi2_write(priv, PHYCNT_REG, phycnt);
>  	rcsi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
>  		    LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
> +	rcsi2_write(priv, FLD_REG, fld);
>  	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
>  	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ | PHYCNT_RSTZ);
>  

The change looks reasonable, so after updating the commit message,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

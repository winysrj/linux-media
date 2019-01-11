Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C00C43612
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 20:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D362D2177B
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 20:22:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="qfScmMOF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389063AbfAKUWC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 15:22:02 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:38382 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389005AbfAKUWB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 15:22:01 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7ACAB53E;
        Fri, 11 Jan 2019 21:21:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547238119;
        bh=zvcCm5BqMPxeO69VOOzS8f9okfCq3m/VWzkhcdut/kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfScmMOFCF+0sQvbaeFo2D+WHbsBIrPJwvu83RQ8AMJdY/3mhbg7/rIK2/059gMfc
         +RPBzblMHxGMxgYFV+AjiVjutGlJ8Sz7LLsjwUbuVq6R0mKZ3oBTdAiC7xRDgmKi+m
         ZP/rOX41IEEL2/3LOb8ZhZ9esiQCEP5bAaKpWbvM=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] media: i2c: adv748x: Remove PAGE_WAIT
Date:   Fri, 11 Jan 2019 22:23:11 +0200
Message-ID: <38687704.IXnQZ8UTlm@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20190111174141.12594-3-kieran.bingham+renesas@ideasonboard.com>
References: <20190111174141.12594-1-kieran.bingham+renesas@ideasonboard.com> <20190111174141.12594-3-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

Thank you for the patch.

On Friday, 11 January 2019 19:41:41 EET Kieran Bingham wrote:
> The ADV748X_PAGE_WAIT is a fake page to insert arbitrary delays in the
> register tables.
> 
> Its only usage was removed, so we can remove the handling and simplify
> the code.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 17 ++++++-----------
>  drivers/media/i2c/adv748x/adv748x.h      |  1 -
>  2 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> b/drivers/media/i2c/adv748x/adv748x-core.c index 252bdb28b18b..8199e0b20790
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -219,18 +219,13 @@ static int adv748x_write_regs(struct adv748x_state
> *state, int ret;
> 
>  	while (regs->page != ADV748X_PAGE_EOR) {

While at it you could write this as

	for (; regs->page != ADV748X_PAGE_EOR; ++regs)

and remove the regs++ below.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> -		if (regs->page == ADV748X_PAGE_WAIT) {
> -			msleep(regs->value);
> -		} else {
> -			ret = adv748x_write(state, regs->page, regs->reg,
> -				      regs->value);
> -			if (ret < 0) {
> -				adv_err(state,
> -					"Error regs page: 0x%02x reg: 0x%02x\n",
> -					regs->page, regs->reg);
> -				return ret;
> -			}
> +		ret = adv748x_write(state, regs->page, regs->reg, regs->value);
> +		if (ret < 0) {
> +			adv_err(state, "Error regs page: 0x%02x reg: 0x%02x\n",
> +				regs->page, regs->reg);
> +			return ret;
>  		}
> +
>  		regs++;
>  	}
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x.h
> b/drivers/media/i2c/adv748x/adv748x.h index 2f8d751cfbb0..5042f9e94aee
> 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -39,7 +39,6 @@ enum adv748x_page {
>  	ADV748X_PAGE_MAX,
> 
>  	/* Fake pages for register sequences */
> -	ADV748X_PAGE_WAIT,		/* Wait x msec */
>  	ADV748X_PAGE_EOR,		/* End Mark */
>  };

-- 
Regards,

Laurent Pinchart




Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1195C67872
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1B4F20811
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:14:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="f7jYTyp7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1B4F20811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbeLMJO6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:14:58 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:43604 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbeLMJO5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:14:57 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3E250549;
        Thu, 13 Dec 2018 10:14:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544692494;
        bh=8srUil1UsNFguekm2ZhpiwxCwMX7LFTDBcjd1Z/SuaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7jYTyp7606p5WCtS8fgBcVTWukdSTFrAdF6K0jATdq6/B3Uf0o0cjNI9E9G14v9h
         cWZYNBKRAMZGdWu5AeK9q9IQln9OEFdHyO0FOqc+EAhobA7nwntSO5wgMvbVAfxvru
         2hX057yVY/8hyYn1KCHfjZfPX9/yq1MI3BdQfQWU=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     jacopo mondi <jacopo@jmondi.org>
Cc:     kieran.bingham@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/5] media: adv748x: Rework reset procedure
Date:   Thu, 13 Dec 2018 11:15:41 +0200
Message-ID: <1822730.9J2ZtiCzbZ@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <d54c10d8-0096-2846-bc3d-402b1ded973b@ideasonboard.com>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org> <20181212081626.GJ5597@w540> <d54c10d8-0096-2846-bc3d-402b1ded973b@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thank you for the patch.

On Wednesday, 12 December 2018 12:13:44 EET Kieran Bingham wrote:
> On 12/12/2018 08:16, jacopo mondi wrote:
> > On Tue, Dec 11, 2018 at 11:52:03PM +0000, Kieran Bingham wrote:
> >> On 11/12/2018 15:16, Jacopo Mondi wrote:
> >>> Re-work the chip reset procedure to configure the CP (HDMI) and SD (AFE)
> >>> cores before resetting the MIPI CSI-2 TXs.
> >>> 
> >>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >>> ---
> >>> 
> >>>  drivers/media/i2c/adv748x/adv748x-core.c | 24 ++++++++++--------------
> >>>  1 file changed, 10 insertions(+), 14 deletions(-)
> >>> 
> >>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> >>> b/drivers/media/i2c/adv748x/adv748x-core.c index
> >>> d94c63cb6a2e..5495dc7891e8 100644
> >>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> >>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> >>> @@ -353,9 +353,8 @@ static const struct adv748x_reg_value
> >>> adv748x_sw_reset[] = {>>> 
> >>>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> >>>  
> >>>  };
> >>> 
> >>> -/* Supported Formats For Script Below */
> >>> -/* - 01-29 HDMI to MIPI TxA CSI 4-Lane - RGB888: */
> >> 
> >> Is this information redundant ? (CSI-4Lane, RGB888 configuration?)
> > 
> > The CSI-2 data lane configuration has been break out from this table
> > by Niklas' patches. I've tried also moving the format configuration
> > out of this, but I haven't sent that change. The HDMI video direction
> > is now handled at link setup time, so I guess the only relevant
> > information is about the RGB888 format configured on the CP backend.
> > I'll keep that.
> 
> Thanks for the clarification.

Sounds good to me. With this change,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> >>> -static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
> >>> +/* Initialize CP Core. */
> >>> +static const struct adv748x_reg_value adv748x_init_hdmi[] = {
> >> 
> >> While we're here - is there much scope - or value in changing these
> >> tables to functions with parameters using Niklas' adv748x_write_check() ?
> >> 
> >> The suggestion only has value if there are parameters that we would need
> >> to configure. So it might be reasonable to leave these tables.
> > 
> > Right now I don't see much value in that. I would prefer breaking out
> > the format configuration from this static tables, but that's for
> > later.
> 
> Perfect - I agree - doesn't need to happen in this patch.
> 
> If the format configuration can be broken out from the table later then
> that's great news.

I think it will make sense to do so, yes.

> >> A general Ack on renaming to the function instead of the
> >> TX/configuration though - as that makes the purpose clearer.
> >> 
> >>>  	/* Disable chip powerdown & Enable HDMI Rx block */
> >>>  	{ADV748X_PAGE_IO, 0x00, 0x40},
> >>> 
> >>> @@ -399,10 +398,8 @@ static const struct adv748x_reg_value
> >>> adv748x_init_txa_4lane[] = {>>> 
> >>>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> >>>  
> >>>  };
> >>> 
> >>> -/* 02-01 Analog CVBS to MIPI TX-B CSI 1-Lane - */
> >>> -/* Autodetect CVBS Single Ended In Ain 1 - MIPI Out */
> >>> -static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
> >>> -
> >> 
> >> Same comments as above really :)
> > 
> > I'll see what I can keep.
> > 
> > Thanks
> > 
> >   j
> >   
> >>> +/* Initialize AFE core. */
> >>> +static const struct adv748x_reg_value adv748x_init_afe[] = {
> >>> 
> >>>  	{ADV748X_PAGE_IO, 0x00, 0x30},	/* Disable chip powerdown Rx */
> >>>  	{ADV748X_PAGE_IO, 0xf2, 0x01},	/* Enable I2C Read Auto-Increment */
> >>> 
> >>> @@ -445,19 +442,18 @@ static int adv748x_reset(struct adv748x_state
> >>> *state)
> >>> 
> >>>  	if (ret < 0)
> >>>  	
> >>>  		return ret;
> >>> 
> >>> -	/* Init and power down TXA */
> >>> -	ret = adv748x_write_regs(state, adv748x_init_txa_4lane);
> >>> +	/* Initialize CP and AFE cores. */
> >>> +	ret = adv748x_write_regs(state, adv748x_init_hdmi);
> >>> 
> >>>  	if (ret)
> >>>  	
> >>>  		return ret;
> >>> 
> >>> -	adv748x_tx_power(&state->txa, 1);
> >>> -	adv748x_tx_power(&state->txa, 0);
> >>> -
> >>> -	/* Init and power down TXB */
> >>> -	ret = adv748x_write_regs(state, adv748x_init_txb_1lane);
> >>> +	ret = adv748x_write_regs(state, adv748x_init_afe);
> >>> 
> >>>  	if (ret)
> >>>  	
> >>>  		return ret;
> >>> 
> >>> +	/* Reset TXA and TXB */
> >>> +	adv748x_tx_power(&state->txa, 1);
> >>> +	adv748x_tx_power(&state->txa, 0);
> >>> 
> >>>  	adv748x_tx_power(&state->txb, 1);
> >>>  	adv748x_tx_power(&state->txb, 0);
> >>> 
> >>> --
> >>> 2.7.4
> >> 
> >> --
> >> Regards
> >> --
> >> Kieran


-- 
Regards,

Laurent Pinchart




Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA9DC43444
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 09:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF50A21773
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 09:26:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="HK9gFHiO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfAJJ0v (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 04:26:51 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45258 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfAJJ0v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 04:26:51 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 64FA3568;
        Thu, 10 Jan 2019 10:26:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547112408;
        bh=PBjFGgNLJg81mUtcdxniOB9hHblX7EcoEJeWiwmnsmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HK9gFHiOAsMmIFRleTOLsAC98rIt+WUl9idiIbwpP5EJR2v/EX5qzo2dzVWshauo3
         TUQ8XNzZejGt4fg7Ex2/DhCH7z1z/4rP1GsuIVk0Hv8pShImTq+XPb3RlIeZcoD+aT
         blvsEf85fZBkClGw2sKuWz9zDF6PyzQefATFpxXc=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     kieran.bingham@ideasonboard.com,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 6/6] media: adv748x: Implement TX link_setup callback
Date:   Thu, 10 Jan 2019 11:27:57 +0200
Message-ID: <1672065.jg9h0FcvVr@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20190110085100.l4dwjxdkx23jfhfg@uno.localdomain>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org> <1722143.vWDHCLa8RZ@avalon> <20190110085100.l4dwjxdkx23jfhfg@uno.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Thursday, 10 January 2019 10:51:00 EET Jacopo Mondi wrote:
> On Wed, Jan 09, 2019 at 02:15:04AM +0200, Laurent Pinchart wrote:
> > On Monday, 7 January 2019 14:36:28 EET Kieran Bingham wrote:
> >> On 06/01/2019 15:54, Jacopo Mondi wrote:
> >>> When the adv748x driver is informed about a link being created from
> >>> HDMI or AFE to a CSI-2 TX output, the 'link_setup()' callback is
> >>> invoked. Make sure to implement proper routing management at link setup
> >>> time, to route the selected video stream to the desired TX output.
> >> 
> >> Overall this looks like the right approach - but I feel like the
> >> handling of the io10 register might need some consideration, because
> >> it's value depends on the condition of both CSI2 transmitters, not just
> >> the currently parsed link.
> >> 
> >> I had a go at some pseudo - uncompiled/untested code inline as a
> >> suggestion.
> >> 
> >> If you think it's better - feel free to rework it in ... or not as you
> >> see fit.
> >> 
> >>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >>> ---
> >>> 
> >>>  drivers/media/i2c/adv748x/adv748x-core.c | 57 +++++++++++++++++++++++-
> >>>  drivers/media/i2c/adv748x/adv748x.h      |  2 +
> >>>  2 files changed, 58 insertions(+), 1 deletion(-)
> >>> 
> >>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> >>> b/drivers/media/i2c/adv748x/adv748x-core.c index
> >>> 200e00f93546..a586bf393558 100644
> >>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> >>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c

[snip]

> >>> +static const struct media_entity_operations adv748x_tx_media_ops = {
> >>> +	.link_setup	= adv748x_link_setup,
> >>> +	.link_validate	= v4l2_subdev_link_validate,
> >>> +};
> >>> 
> >>>  static const struct media_entity_operations adv748x_media_ops = {
> >>>  	.link_validate = v4l2_subdev_link_validate,
> >>> @@ -516,7 +570,8 @@ void adv748x_subdev_init(struct v4l2_subdev *sd,
> >>> struct adv748x_state *state,
> >>>  		state->client->addr, ident);
> >>>  	
> >>>  	sd->entity.function = function;
> >>> -	sd->entity.ops = &adv748x_media_ops;
> >>> +	sd->entity.ops = is_tx(adv748x_sd_to_csi2(sd)) ?
> >>> +			 &adv748x_tx_media_ops : &adv748x_media_ops;
> >> 
> >> Aha - yes that's a neat solution to ensure that only the TX links
> >> generate link_setup calls :)
> > 
> > Another option would be to bail out from adv748x_link_setup() if the
> > entity is not a TX*.
> 
> If I'm not wrong you suggested me to register a set of operations with
> the .link_setup callback only for TX entities, and I agree it is much
> better, so I'm leaning to leave it as it is in this series.

Sorry, I should have made it clear that this wasn't a request for a change, 
just pointing out another potential option. Your implementation is fine with 
me.

> >>>  }
> > 
> > [snip]

-- 
Regards,

Laurent Pinchart




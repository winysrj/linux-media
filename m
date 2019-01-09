Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F4EC43612
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2093720883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="qeWwZJ4S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbfAIAN6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:13:58 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:41670 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfAIAN6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:13:58 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5EDDA586;
        Wed,  9 Jan 2019 01:13:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1546992835;
        bh=AkbaQOxZMi9tm3sFg5IQOR9ZFyELl2xqpYQHngZEugM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qeWwZJ4Sbo4rROc5VWCNZZ7KENPvaRbpOEqDuV0a5Zx6ZlkcaLCXUkeLDyq8mQ+Hn
         XHfoxNy5O2F8MxgsOzoBTBqSzderoi2qKqomr60fGRsaFial41h74HVfdphcvZXpaC
         HmChPIyF3/YS8gNI8CUzutWqK4PTjqY3l2zU3QIw=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 6/6] media: adv748x: Implement TX link_setup callback
Date:   Wed, 09 Jan 2019 02:15:04 +0200
Message-ID: <1722143.vWDHCLa8RZ@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <9f156850-14b6-3ca2-47c1-e03e1bc2c0f8@ideasonboard.com>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org> <20190106155413.30666-7-jacopo+renesas@jmondi.org> <9f156850-14b6-3ca2-47c1-e03e1bc2c0f8@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

On Monday, 7 January 2019 14:36:28 EET Kieran Bingham wrote:
> On 06/01/2019 15:54, Jacopo Mondi wrote:
> > When the adv748x driver is informed about a link being created from HDMI
> > or AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
> > sure to implement proper routing management at link setup time, to route
> > the selected video stream to the desired TX output.
> 
> Overall this looks like the right approach - but I feel like the
> handling of the io10 register might need some consideration, because
> it's value depends on the condition of both CSI2 transmitters, not just
> the currently parsed link.
> 
> I had a go at some pseudo - uncompiled/untested code inline as a suggestion.
> 
> If you think it's better - feel free to rework it in ... or not as you
> see fit.
> 
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> > 
> >  drivers/media/i2c/adv748x/adv748x-core.c | 57 +++++++++++++++++++++++-
> >  drivers/media/i2c/adv748x/adv748x.h      |  2 +
> >  2 files changed, 58 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> > b/drivers/media/i2c/adv748x/adv748x-core.c index
> > 200e00f93546..a586bf393558 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -335,6 +335,60 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool
> > on)
> >  /* ----------------------------------------------------------------------
> >   * Media Operations
> >   */
> > +static int adv748x_link_setup(struct media_entity *entity,
> > +			      const struct media_pad *local,
> > +			      const struct media_pad *remote, u32 flags)
> > +{
> > +	struct v4l2_subdev *rsd = media_entity_to_v4l2_subdev(remote->entity);
> > +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> > +	struct adv748x_state *state = v4l2_get_subdevdata(sd);
> > +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> > +	bool enable = flags & MEDIA_LNK_FL_ENABLED;
> > +	u8 io10;
> > +
> > +	/* Refuse to enable multiple links to the same TX at the same time. */
> > +	if (enable && tx->src)
> > +		return -EINVAL;
> > +
> > +	/* Set or clear the source (HDMI or AFE) and the current TX. */
> > +	if (rsd == &state->afe.sd)
> > +		state->afe.tx = enable ? tx : NULL;
> > +	else
> > +		state->hdmi.tx = enable ? tx : NULL;
> > +
> > +	tx->src = enable ? rsd : NULL;
> > +
> > +	if (!enable)
> > +		return 0;
> 
> Don't we potentially want to take any action on disable to power down
> links below ?
> 
> > +
> > +	/* Change video stream routing, according to the newly enabled link. */
> > +	io10 = io_read(state, ADV748X_IO_10);
> > +	if (rsd == &state->afe.sd) {
> > +		/*
> > +		 * Set AFE->TXA routing and power off TXB if AFE goes to TXA.
> > +		 * if AFE goes to TXB, we need both TXA and TXB powered on.
> > +		 */
> > +		io10 &= ~ADV748X_IO_10_CSI1_EN;
> > +		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
> > +		if (is_txa(tx))
> > +			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
> 
> Shouldn't the CSI4 be enabled here too? or are we assuming it's already
> (/always) enabled?
> 		io10 |= ADV748X_IO_10_CSI4_EN;
> 
> > +		else
> > +			io10 |= ADV748X_IO_10_CSI4_EN |
> > +				ADV748X_IO_10_CSI1_EN;
> > +	} else {
> > +		/* Clear AFE->TXA routing and power up TXA. */
> > +		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
> > +		io10 |= ADV748X_IO_10_CSI4_EN;
> 
> But if we assume it's already enabled ... do we need this?
> Perhaps it might be better to be explicit on this?
> 
> > +	}
> > +	io_write(state, ADV748X_IO_10, io10);
> 
> Would it be any cleaner to use io_clrset() here?
> 
> Hrm ... also it feels like this register really should be set depending
> upon the complete state of ... &state->...
> 
> So perhaps it deserves it's own function which should be called after
> csi_registered() callback and any link change.
> 
> /me has a quick go at some psuedo codeishness...:
> 
> int adv74x_io_10(struct adv748x_state *state);
> 	u8 bits = 0;
> 	u8 mask = ADV748X_IO_10_CSI1_EN
> 
> 		| ADV748X_IO_10_CSI4_EN
> 		| ADV748X_IO_10_CSI4_IN_SEL_AFE;
> 
> 	if (state->afe.tx) {
> 		/* AFE Requires TXA enabled, even when output to TXB */
> 		bits |= ADV748X_IO_10_CSI4_EN;
> 
> 		if (is_txa(state->afe.tx))
> 			bits |= ADV748X_IO_10_CSI4_IN_SEL_AFE
> 		else
> 			bits |= ADV748X_IO_10_CSI1_EN;
> 	}
> 
> 	if (state->hdmi.tx) {
> 		bits |= ADV748X_IO_10_CSI4_EN;
> 	}
> 
> 	return io_clrset(state, ADV748X_IO_10, mask, bits);
> }
> 
> How does that look ? (is it even correct first?)
> 
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct media_entity_operations adv748x_tx_media_ops = {
> > +	.link_setup	= adv748x_link_setup,
> > +	.link_validate	= v4l2_subdev_link_validate,
> > +};
> > 
> >  static const struct media_entity_operations adv748x_media_ops = {
> >  	.link_validate = v4l2_subdev_link_validate,
> > @@ -516,7 +570,8 @@ void adv748x_subdev_init(struct v4l2_subdev *sd,
> > struct adv748x_state *state,
> >  		state->client->addr, ident);
> >  	
> >  	sd->entity.function = function;
> > -	sd->entity.ops = &adv748x_media_ops;
> > +	sd->entity.ops = is_tx(adv748x_sd_to_csi2(sd)) ?
> > +			 &adv748x_tx_media_ops : &adv748x_media_ops;
> 
> Aha - yes that's a neat solution to ensure that only the TX links
> generate link_setup calls :)

Another option would be to bail out from adv748x_link_setup() if the entity is 
not a TX*.

> >  }

[snip]

-- 
Regards,

Laurent Pinchart




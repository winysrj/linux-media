Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E56C67872
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31B0C20849
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="lNMIFIlz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31B0C20849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbeLMJZH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:25:07 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:43658 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbeLMJZH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:25:07 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3664F549;
        Thu, 13 Dec 2018 10:25:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544693104;
        bh=lSm8ukqpJrZAOgSNrBxhl3qxqbb5NI+liE8eO44lEos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNMIFIlzyYHJQ/9zvL0pUWqEbM/jDN72PDb2mq3BoOlOmGhODjNk+jQ7nY1muaFN+
         xVD+DEYrR4T3WvNEKQl7sOWbd+K10KpIx86jwETWL3L+wa3jGQVSNS3ZU+kmmEvmLF
         phk0WP2kcBui63RZkR+tWOtMZvDE5DixkZr6b4eg=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     jacopo mondi <jacopo@jmondi.org>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/5] media: adv748x: csi2: Link AFE with TXA and TXB
Date:   Thu, 13 Dec 2018 11:25:51 +0200
Message-ID: <1934171.RyS2CS3gDq@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181212082101.GK5597@w540>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org> <fa3b9980-2a19-2e5a-2e37-e76f1ad04daa@ideasonboard.com> <20181212082101.GK5597@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thank you for the patch.

On Wednesday, 12 December 2018 10:21:01 EET jacopo mondi wrote:
> On Tue, Dec 11, 2018 at 11:07:09PM +0000, Kieran Bingham wrote:
> > On 11/12/2018 15:16, Jacopo Mondi wrote:
> >> The ADV748x chip supports routing AFE output to either TXA or TXB.
> >> In order to support run-time configuration of video stream path, create
> >> an additional (not enabled) "AFE:8->TXA:0" link, and remove the
> >> IMMUTABLE flag from existing ones.
> >> 
> >> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> ---
> >> 
> >>  drivers/media/i2c/adv748x/adv748x-csi2.c | 48 ++++++++++++++++---------
> >>  1 file changed, 30 insertions(+), 18 deletions(-)
> >> 
> >> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c
> >> b/drivers/media/i2c/adv748x/adv748x-csi2.c index
> >> 6ce21542ed48..4d1aefc2c8d0 100644
> >> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> >> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> >> @@ -27,6 +27,7 @@ static int adv748x_csi2_set_virtual_channel(struct
> >> adv748x_csi2 *tx,> > 
> >>   * @v4l2_dev: Video registration device
> >>   * @src: Source subdevice to establish link
> >>   * @src_pad: Pad number of source to link to this @tx
> >> + * @flags: Flags for the newly created link

You may want to name this link_flags, up to you.

> >>   *
> >>   * Ensure that the subdevice is registered against the v4l2_device, and
> >>   link the
> >>   * source pad to the sink pad of the CSI2 bus entity.

[snip]

> >> @@ -68,24 +63,41 @@ static int adv748x_csi2_registered(struct
> >> v4l2_subdev *sd)
> >>  {
> >>  	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> >>  	struct adv748x_state *state = tx->state;
> >> +	int ret;
> >> 
> >>  	adv_dbg(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
> >>  			sd->name);
> >>  	
> >>  	/*
> >> -	 * The adv748x hardware allows the AFE to route through the TXA,
> >> however
> >> -	 * this is not currently supported in this driver.
> >> +	 * Link TXA to HDMI and AFE, and TXB to AFE only as TXB cannot output
> >> +	 * HDMI.
> >>  	 *
> >> -	 * Link HDMI->TXA, and AFE->TXB directly.
> >> +	 * The HDMI->TXA link is enabled by default, as the AFE->TXB is.
> >>  	 */
> >> -	if (is_txa(tx) && is_hdmi_enabled(state))
> >> -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> >> -						  &state->hdmi.sd,
> >> -						  ADV748X_HDMI_SOURCE);
> >> -	if (!is_txa(tx) && is_afe_enabled(state))
> >> +	if (is_txa(tx)) {
> >> +		if (is_hdmi_enabled(state)) {
> >> +			ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
> >> +							 &state->hdmi.sd,
> >> +							 ADV748X_HDMI_SOURCE,
> >> +							 MEDIA_LNK_FL_ENABLED);
> >> +			if (ret)
> >> +				return ret;
> >> +		}
> >> +
> >> +		if (is_afe_enabled(state)) {
> >> +			ret = adv748x_csi2_register_link(tx, sd->v4l2_dev,
> >> +							 &state->afe.sd,
> >> +							 ADV748X_AFE_SOURCE,
> >> +							 0);
> >> +			if (ret)
> >> +				return ret;
> >> +		}

I wonder whether in the case where both HDMI and TXB are disabled we shouldn't 
create this link as immutable and enabled ? This would require a big 
refactoring, possibly including deep changes in the v4l2-async and MC code, so 
it's likely out of scope for this patch (unless you see an easy way to do so).

> >> +	} else if (is_afe_enabled(state))
> > 
> > I believe when adding braces to one side of an if statement, we are
> > supposed to add to the else clauses too ?
> 
> Correct

And I would write this

	} else {
		if (is_afe_enabled(state))
			...
	}

To more clearly visualize the TXA and TXB code.

> >>  		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> >>  						  &state->afe.sd,
> >> -						  ADV748X_AFE_SOURCE);
> >> +						  ADV748X_AFE_SOURCE,
> >> +						  MEDIA_LNK_FL_ENABLED);
> > 
> > Won't this enable the AFE link for both TXA and TXB ?
> > Which one will win? Just the last one ? the first one ?
> > Does it error?
> > 
> > (It might not be a problem ... I can't recall what the behaviour is)
> 
> The AFE->TXA link is created as not enabled (see the 0 as last
> argument in the adv748x_csi2_register_link() call above here, in the
> 'is_txa(tx)' case
> 
> >> +
> > 
> > There are a lot of nested if's above, and I think we can simplify
> > greatly if we move the logic for the flags inside
> > adv748x_csi2_register_link(), and adjust the checks on is_xxx_enabled()
> > 
> > What do you think about the following pseudo code?:
> > 
> > int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
> >   				      struct v4l2_device *v4l2_dev,
> >   				      struct v4l2_subdev *src,
> > 				      unsigned int src_pad,
> > 				      bool enable)
> > {
> >   int flags = 0;
> >   int ret;
> >   
> >   if (!src->v4l2_dev) {
> > 	ret = v4l2_device_register_subdev(v4l2_dev, src)
> > 	if (ret) return ret;
> >   }
> >   
> >   if (enable)
> > 	flags = MEDIA_LNK_FL_ENABLED;
> > 	
> >    return media_create_pad_link(&src->entity, src_pad,
> >  			        &tx->sd.entity, ADV748X_CSI2_SINK,
> >  			        flags);
> > }
> > 
> > int adv748x_csi2_registered(struct v4l2_subdev *sd)
> > {
> >   int ret;
> >   

I would add

	/* The AFE can be routed to both TXA and TXB. */

> >   if (is_afe_enabled(state) {
> >       ret = adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->afe.sd,
> > 				   ADV748X_AFE_SOURCE, !is_txa(tx));
> >       if (ret)
> > 	  return ret;
> >   }
> >   
> >   /* TX-B only supports AFE */
> >   if (!is_txa(tx) || !(is_hdmi_enabled(state))
> > 	return 0;
> > 	
> >   return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
> > 				    ADV748X_HDMI_SOURCE, true);
> > }

Looks better than my above proposal :-)

> > The above will for TXA:
> > 	register_link(..., AFE_SOURCE, enable = false );
> > 	register_link(..., HDMI_SOURCE, enable = true );
> > 
> > then TXB:
> > 	register_link(..., AFE_SOURCE, enable = true );
> > 
> > Does that meet our needs?
> 
> Yes it does, and it looks better. Thanks!
> 
> >>  	return 0;
> >>  }

With Kieran's proposed change,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart




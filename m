Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7872EC4360F
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 11:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47BFD20854
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 11:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="MmhlKK25"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfCHL3q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 06:29:46 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:53150 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfCHL3q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 06:29:46 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A6C78309;
        Fri,  8 Mar 2019 12:29:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552044584;
        bh=b7cfgF4m93vSIHz+NYNeX5bfcXjY5LjUwf+Eosr+L/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MmhlKK25ARLLy/9wkAfDMd0etnVt/h2oHWiyZ8YwejNIqs4xjRvzzT2rp+OweQJJM
         Oc/dHwfYdtDTc/Eh+5x1kAdOo5CZ+Xf2+r/h9+a0fsU/J+Dto+OahSljXJbNd0cAYD
         OXO51S6Run8hUDwtAEI+ukHz9P83hs8WfEJX+sGw=
Date:   Fri, 8 Mar 2019 13:29:38 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: adv748x: Don't disable CSI-2 on link_setup
Message-ID: <20190308112938.GE4802@pendragon.ideasonboard.com>
References: <20190306112659.8310-1-jacopo+renesas@jmondi.org>
 <20190306191521.GE4791@pendragon.ideasonboard.com>
 <20190307103511.wtx2c7jecyx4nmms@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190307103511.wtx2c7jecyx4nmms@uno.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Thu, Mar 07, 2019 at 11:35:11AM +0100, Jacopo Mondi wrote:
> On Wed, Mar 06, 2019 at 09:15:21PM +0200, Laurent Pinchart wrote:
> > On Wed, Mar 06, 2019 at 12:26:59PM +0100, Jacopo Mondi wrote:
> >> When both the media links between AFE and HDMI and the two TX CSI-2 outputs
> >> gets disabled, the routing register ADV748X_IO_10 gets zeroed causing both
> >> TXA and TXB output to get disabled.
> >>
> >> This causes some HDMI transmitters to stop working after both AFE and
> >> HDMI links are disabled.
> >
> > Could you elaborate on why this would be the case ? By HDMI transmitter,
> > I assume you mean the device connected to the HDMI input of the ADV748x.
> > Why makes it fail (and how ?) when the TXA and TXB are both disabled ?
> 
> I know, it's weird, the HDMI transmitter is connected to the HDMI
> input of adv748x and should not be bothered by CSI-2 outputs
> enablement/disablement.
> 
> BUT, when I developed the initial adv748x AFE->TXA patches I was
> testing HDMI capture using a laptop, and things were smooth.
> 
> I recently started using a chrome cast device I found in some drawer
> to test HDMI, as with it I don't need to go through xrandr as I had to
> do when using a laptop for testing, but it seems the two behaves differently.
> 
> Failures are of different types: from detecting a non-realisting
> resolution from the HDMI subdevice, and then messing up the pipeline
> configuration, to capture operations apparently completing properly
> but resulting in mangled images.
> 
> Do not deactivate the CSI-2 ouputs seems to fix the issue for the
> Chromecast, and still work when capturing from laptop. There might be
> something I am missing about HDMI maybe, but the patch not just fixes
> the issue for me, but it might make sense on its own as disabling the
> TXes might trigger some internal power saving state, or simply mess up
> the HDMI link.

I think this needs more investigation. It feels to me that you're
working around an issue by chance, and it will come back to bite us
later :-(

> As disabling both TXes usually happens at media link reset time, just
> before enabling one of them (or both), going through a full disable
> makes little sense, even more if it triggers any sort of malfunctioning.
> 
> Does this make sense to you?

It also doesn't make too much sense to keep them both enabled when they
don't need to be :-) You'll end up consuming more power.

> >> Fix this by preventing writing 0 to
> >> ADV748X_IO_10 register, which gets only updated when links are enabled
> >> again.
> >>
> >> Fixes: 9423ca350df7 ("media: adv748x: Implement TX link_setup callback")
> >> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> ---
> >> The issue presents itself only on some HDMI transmitters, and went unnoticed
> >> during the development of:
> >> "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
> >>
> >> Patch intended to be applied on top of latest media-master, where the
> >> "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
> >> series is applied.
> >>
> >> The patch reports a "Fixes" tag, but should actually be merged with the above
> >> mentioned series.
> >>
> >> ---
> >>  drivers/media/i2c/adv748x/adv748x-core.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> >> index f57cd77a32fa..0e5a75eb6d75 100644
> >> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> >> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> >> @@ -354,6 +354,9 @@ static int adv748x_link_setup(struct media_entity *entity,
> >>
> >>  	tx->src = enable ? rsd : NULL;
> >>
> >> +	if (!enable)
> >> +		return 0;
> >> +
> >>  	if (state->afe.tx) {
> >>  		/* AFE Requires TXA enabled, even when output to TXB */
> >>  		io10 |= ADV748X_IO_10_CSI4_EN;

-- 
Regards,

Laurent Pinchart

Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC0AC43612
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 08:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6433F21773
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 08:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfAJI6k (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:58:40 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45921 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfAJI6k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 03:58:40 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 5E5BE1C0016;
        Thu, 10 Jan 2019 08:58:36 +0000 (UTC)
Date:   Thu, 10 Jan 2019 09:58:43 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 6/6] media: adv748x: Implement TX link_setup callback
Message-ID: <20190110085843.cju2gjrr4vm3acby@uno.localdomain>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
 <20190106155413.30666-7-jacopo+renesas@jmondi.org>
 <9f156850-14b6-3ca2-47c1-e03e1bc2c0f8@ideasonboard.com>
 <1722143.vWDHCLa8RZ@avalon>
 <221dd6e0-bf90-5215-eaad-004eac59838d@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dg3je4gkrw3n6bxt"
Content-Disposition: inline
In-Reply-To: <221dd6e0-bf90-5215-eaad-004eac59838d@ideasonboard.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--dg3je4gkrw3n6bxt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Jan 09, 2019 at 02:15:33PM +0000, Kieran Bingham wrote:
> On 09/01/2019 00:15, Laurent Pinchart wrote:
> > Hello,
> >
> > On Monday, 7 January 2019 14:36:28 EET Kieran Bingham wrote:
> >> On 06/01/2019 15:54, Jacopo Mondi wrote:
> >>> When the adv748x driver is informed about a link being created from HDMI
> >>> or AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
> >>> sure to implement proper routing management at link setup time, to route
> >>> the selected video stream to the desired TX output.
> >>
> >> Overall this looks like the right approach - but I feel like the
> >> handling of the io10 register might need some consideration, because
> >> it's value depends on the condition of both CSI2 transmitters, not just
> >> the currently parsed link.
> >>
> >> I had a go at some pseudo - uncompiled/untested code inline as a suggestion.
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
> >>> @@ -335,6 +335,60 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool
> >>> on)
> >>>  /* ----------------------------------------------------------------------
> >>>   * Media Operations
> >>>   */
> >>> +static int adv748x_link_setup(struct media_entity *entity,
> >>> +			      const struct media_pad *local,
> >>> +			      const struct media_pad *remote, u32 flags)
> >>> +{
> >>> +	struct v4l2_subdev *rsd = media_entity_to_v4l2_subdev(remote->entity);
> >>> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> >>> +	struct adv748x_state *state = v4l2_get_subdevdata(sd);
> >>> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> >>> +	bool enable = flags & MEDIA_LNK_FL_ENABLED;
> >>> +	u8 io10;
> >>> +
> >>> +	/* Refuse to enable multiple links to the same TX at the same time. */
> >>> +	if (enable && tx->src)
> >>> +		return -EINVAL;
> >>> +
> >>> +	/* Set or clear the source (HDMI or AFE) and the current TX. */
> >>> +	if (rsd == &state->afe.sd)
> >>> +		state->afe.tx = enable ? tx : NULL;
> >>> +	else
> >>> +		state->hdmi.tx = enable ? tx : NULL;
> >>> +
> >>> +	tx->src = enable ? rsd : NULL;
> >>> +
> >>> +	if (!enable)
> >>> +		return 0;
> >>
> >> Don't we potentially want to take any action on disable to power down
> >> links below ?
> >>
> >>> +
> >>> +	/* Change video stream routing, according to the newly enabled link. */
> >>> +	io10 = io_read(state, ADV748X_IO_10);
> >>> +	if (rsd == &state->afe.sd) {
> >>> +		/*
> >>> +		 * Set AFE->TXA routing and power off TXB if AFE goes to TXA.
> >>> +		 * if AFE goes to TXB, we need both TXA and TXB powered on.
> >>> +		 */
> >>> +		io10 &= ~ADV748X_IO_10_CSI1_EN;
> >>> +		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
> >>> +		if (is_txa(tx))
> >>> +			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
> >>
> >> Shouldn't the CSI4 be enabled here too? or are we assuming it's already
> >> (/always) enabled?
> >> 		io10 |= ADV748X_IO_10_CSI4_EN;
> >>
> >>> +		else
> >>> +			io10 |= ADV748X_IO_10_CSI4_EN |
> >>> +				ADV748X_IO_10_CSI1_EN;
> >>> +	} else {
> >>> +		/* Clear AFE->TXA routing and power up TXA. */
> >>> +		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
> >>> +		io10 |= ADV748X_IO_10_CSI4_EN;
> >>
> >> But if we assume it's already enabled ... do we need this?
> >> Perhaps it might be better to be explicit on this?
> >>
> >>> +	}
> >>> +	io_write(state, ADV748X_IO_10, io10);
> >>
> >> Would it be any cleaner to use io_clrset() here?
> >>
> >> Hrm ... also it feels like this register really should be set depending
> >> upon the complete state of ... &state->...
> >>
> >> So perhaps it deserves it's own function which should be called after
> >> csi_registered() callback and any link change.
> >>
> >> /me has a quick go at some psuedo codeishness...:
> >>
> >> int adv74x_io_10(struct adv748x_state *state);
> >> 	u8 bits = 0;
> >> 	u8 mask = ADV748X_IO_10_CSI1_EN
> >>
> >> 		| ADV748X_IO_10_CSI4_EN
> >> 		| ADV748X_IO_10_CSI4_IN_SEL_AFE;
> >>
> >> 	if (state->afe.tx) {
> >> 		/* AFE Requires TXA enabled, even when output to TXB */
> >> 		bits |= ADV748X_IO_10_CSI4_EN;
> >>
> >> 		if (is_txa(state->afe.tx))
> >> 			bits |= ADV748X_IO_10_CSI4_IN_SEL_AFE
> >> 		else
> >> 			bits |= ADV748X_IO_10_CSI1_EN;
> >> 	}
> >>
> >> 	if (state->hdmi.tx) {
> >> 		bits |= ADV748X_IO_10_CSI4_EN;
> >> 	}
> >>
> >> 	return io_clrset(state, ADV748X_IO_10, mask, bits);
> >> }
> >>
> >> How does that look ? (is it even correct first?)
> >>
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
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
> > Another option would be to bail out from adv748x_link_setup() if the entity is
> > not a TX*.
> >
>
> I suggested this in v1 - but Jacopo objected with the following:
>
> > Checking for is_txa() and is_txb() would require to call
> > 'adv_sd_to_csi2(sd)' before having made sure the 'sd' actually
> > represent a csi2_tx. I would keep it as it is.
>

That was at the time where the .link_setup() callback was called for
TXs and non-TXs. What you proposed was to call:

#define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)

on variables that we don't have any guarantee that are of type 'struct
adv748x_csi2'. I still think it is dangerous and should be avoided and
I worked it around in v1 as:

+	if ((sd != &state->txa.sd && sd != &state->txb.sd) ||

> Now I look at the implementation here, I see this is precisely what it
> is doing anyway .... still converting through adv748x_sd_to_csi2(sd) on
> an unknown pointer type
>  (which I still believe is a valid thing to do in this instance)

It's not unknown, .link_setup() is only registered for TXs. If it gets
called, we know we're dealing with a TX.

>
> So yes, I think this would be simpler having the check at the top of the
> adv748x_link_setup() call, and thus then there is no need to add a
> second adv_media_ops structure.

That was what I did in v1, didn't I ?

The current implementation looks better imho, but if the both of you
prefer something similar to v1 I will consider that.

Thanks
   j
>
>
> >>>  }
> >
> > [snip]
> >
>
> --
> Regards
> --
> Kieran

--dg3je4gkrw3n6bxt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlw3CUMACgkQcjQGjxah
VjwWRw//Q9NofhuOjk9T3AlvtSoWzn1SkXx4PLGy+V1csRudUSjdwFkyW6UcJrag
uscQr4Y3XJmReYhRDHLTHlSF2AhtIVxKcDuDLXYcj0DvFxFN/7BnvyjR77+7eteT
sMm0uxUrr8SdhZyCMfDZhhhYUeLXOkYIntWDBlkIolamM3o7xWRDbxs4XAseLiJF
uhUPGB6s9IZc0MyAmvZ+Y8qZIhHZCOkKFdRcgpOnTVc20mb+EPlnvljz6yfhIpdL
ojiniEKiBpbpd3rsHpMH9FKUo7g/7LtVnAgBbjLX6fjLPCW37xMbT1vAv1FPy6mP
bK/XVvwlgPux0Zn04G1Q+USWw7B0J9HGQtnJ1LM42zZDVov51kJoKoJg8J17eUxm
Na9Rn5yI0TV//8CPGK86ixXKgH7IQ2sfHzWoOjZtW0ChNFNEQwMGsAVD9RJI+w1w
ibaKQdbpRa5KOniPsaO90XRBUCZQEm2YtJfEed3zar9HpVdg+VFBhNc1W3MHGQYr
O/6wHbtcsYnbDELZnlGpliHIeRPhjAHaccWrIYpGaixZ59CJ+Y4KLRQSvAFiyQQV
EK6I39UA1g3zJSkc9gCBPfKqlaL9aE8lj5qcC4WJAOqQWCjurBExP/gC+HhQAO07
eID5W2da3HhtWoRjpOL1ZYaAA4UooaM3p1ASbfQbkErpwkVDuRs=
=dABw
-----END PGP SIGNATURE-----

--dg3je4gkrw3n6bxt--

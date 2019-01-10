Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB12C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 13:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DF002173B
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 13:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfAJNkN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 08:40:13 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:42119 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbfAJNkM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 08:40:12 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D070E200007;
        Thu, 10 Jan 2019 13:40:08 +0000 (UTC)
Date:   Thu, 10 Jan 2019 14:40:15 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 6/6] media: adv748x: Implement TX link_setup callback
Message-ID: <20190110134015.ssd24hnl7fbw4ct7@uno.localdomain>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
 <20190106155413.30666-7-jacopo+renesas@jmondi.org>
 <9f156850-14b6-3ca2-47c1-e03e1bc2c0f8@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="othasjxbznoz37lu"
Content-Disposition: inline
In-Reply-To: <9f156850-14b6-3ca2-47c1-e03e1bc2c0f8@ideasonboard.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--othasjxbznoz37lu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Kieran,
On Mon, Jan 07, 2019 at 12:36:28PM +0000, Kieran Bingham wrote:
> Hi Jacopo,
>
> On 06/01/2019 15:54, Jacopo Mondi wrote:
> > When the adv748x driver is informed about a link being created from HDMI or
> > AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
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
> Regards
>
> Kieran
>
>
>
>
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-core.c | 57 +++++++++++++++++++++++-
> >  drivers/media/i2c/adv748x/adv748x.h      |  2 +
> >  2 files changed, 58 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> > index 200e00f93546..a586bf393558 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -335,6 +335,60 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
> >  /* -----------------------------------------------------------------------------
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

Thanks, I've now updated the implementation to use something very
similar to what you proposed here!

Thanks
  j

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
> > @@ -516,7 +570,8 @@ void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
> >  		state->client->addr, ident);
> >
> >  	sd->entity.function = function;
> > -	sd->entity.ops = &adv748x_media_ops;
> > +	sd->entity.ops = is_tx(adv748x_sd_to_csi2(sd)) ?
> > +			 &adv748x_tx_media_ops : &adv748x_media_ops;
>
> Aha - yes that's a neat solution to ensure that only the TX links
> generate link_setup calls :)
>
>
>
> >  }
> >
> >  static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
> > diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> > index 6eb2e4a95eed..eb19c6cbbb4e 100644
> > --- a/drivers/media/i2c/adv748x/adv748x.h
> > +++ b/drivers/media/i2c/adv748x/adv748x.h
> > @@ -93,6 +93,7 @@ struct adv748x_csi2 {
> >
> >  #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
> >  #define __is_tx(_tx, _ab) ((_tx) == &(_tx)->state->tx##_ab)
> > +#define is_tx(_tx) (is_txa(_tx) || is_txb(_tx))
> >  #define is_txa(_tx) __is_tx(_tx, a)
> >  #define is_txb(_tx) __is_tx(_tx, b)
> >
> > @@ -224,6 +225,7 @@ struct adv748x_state {
> >  #define ADV748X_IO_10_CSI4_EN		BIT(7)
> >  #define ADV748X_IO_10_CSI1_EN		BIT(6)
> >  #define ADV748X_IO_10_PIX_OUT_EN	BIT(5)
> > +#define ADV748X_IO_10_CSI4_IN_SEL_AFE	BIT(3)
>
>
>
> >
> >  #define ADV748X_IO_CHIP_REV_ID_1	0xdf
> >  #define ADV748X_IO_CHIP_REV_ID_2	0xe0
> >
>
> --
> Regards
> --
> Kieran

--othasjxbznoz37lu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlw3Sz8ACgkQcjQGjxah
VjyO2RAAtzhaK9LzpyfOcKVPH0wdwOf/Z26a2YlMkaHvxqFb8MuIJ1YlOxbhiauE
WYw1tbXsmT06W1VrsRr5sVkrgkJA12WALueD/cM3uII2IDr5e2ikwd6IjiB8YV/F
zZkjJQBxTNuxvHriUblzpxxgEck3RdiNeHI78IDd7FCxh1h88WCjoQLRonCP9B0E
oud6HndcIjB0vRgSmkup573M+VzgiAYm7nlVxDctlaaZjQYJ0/bwmQYi2TrI4ST4
pdffA0dsaroz+FjRnrKCtAy6v1MUTUiSwTxZFUetycgw5OnXGrgP2Omx4/7FAQe7
t9LYTi8tMJ1YvHOVUfbDsVh6RNos89pFveul1mUd1KX7oSbkSDu0VtFDqW7JBC8f
NrZC0YUJQmcSgM37pw98CJfnoAWAC0uvOpJunOmWfMkTYH34y0UDl3Vx6BDQ5eKn
8MCgooRRJm6UJmECTV+zI5qQXmF9ad/E2cBqTwo3lBBEhOsSFw4V2Wk5MYiWvDWr
Qgm1+LdvY0SkAG+hhuSEsKk3tqha6unc7M3Bo/IkkYHzRRi5ROKUuU44Pzj8mlCb
Ep/IkEQd/ffK5y2X4gicP1znyO8hwMeViaRmRPwLqhSGU8dnzePxHl1nNqsyxbxt
Utkmk4bYaa7UOzi4aeBaWeORejYcUbfVJxskcWGiRJHUyNVCNqs=
=mHte
-----END PGP SIGNATURE-----

--othasjxbznoz37lu--

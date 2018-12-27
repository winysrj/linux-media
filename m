Return-Path: <SRS0=HJwa=PE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43092C43612
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 20:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BEB2218FE
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 20:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbeL0UjG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 27 Dec 2018 15:39:06 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:47327 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbeL0UjG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Dec 2018 15:39:06 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 323F7240006;
        Thu, 27 Dec 2018 20:39:01 +0000 (UTC)
Date:   Thu, 27 Dec 2018 21:38:57 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/5] media: adv748x: Implement link_setup callback
Message-ID: <20181227203846.GA909@uno.localdomain>
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
 <1544541373-30044-6-git-send-email-jacopo+renesas@jmondi.org>
 <2229088.MKf6aupnv1@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <2229088.MKf6aupnv1@avalon>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Laurent, Kieran,
  thanks for the review

On Thu, Dec 13, 2018 at 11:40:00AM +0200, Laurent Pinchart wrote:
> Hi Jacopo,
>
> Thank you for the patch.
>
> On Tuesday, 11 December 2018 17:16:13 EET Jacopo Mondi wrote:
> > When the adv748x driver is informed about a link being created from HDMI or
> > AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
> > sure to implement proper routing management at link setup time, to route
> > the selected video stream to the desired TX output.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-core.c | 63 ++++++++++++++++++++++++++++-
> >  drivers/media/i2c/adv748x/adv748x.h      |  1 +
> >  2 files changed, 63 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> > b/drivers/media/i2c/adv748x/adv748x-core.c index f3aabbccdfb5..08dc0e89b053
> > 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -335,9 +335,70 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
> >  /* ------------------------------------------------------------------------
> >   * Media Operations
> >   */
> > +static int adv748x_link_setup(struct media_entity *entity,
> > +			      const struct media_pad *local,
> > +			      const struct media_pad *remote, u32 flags)
> > +{
> > +	struct v4l2_subdev *rsd = media_entity_to_v4l2_subdev(remote->entity);
> > +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> > +	struct adv748x_state *state = v4l2_get_subdevdata(sd);
> > +	struct adv748x_csi2 *tx;
> > +	struct media_link *link;
> > +	u8 io10;
> > +
> > +	/*
> > +	 * For each link setup from [HDMI|AFE] to TX we receive two
> > +	 * notifications: "[HDMI|AFE]->TX" and "TX<-[HDMI|AFE]".
> > +	 *
> > +	 * Use the second notification form to make sure we're linking
> > +	 * to a TX and find out from where, to set up routing properly.
> > +	 */
>
> Why don't you implement the link handler just for the TX entities then ?
>

Done. Much better

> > +	if ((sd != &state->txa.sd && sd != &state->txb.sd) ||
> > +	    !(flags & MEDIA_LNK_FL_ENABLED))
>
> When disabling the link you should reset the ->source and ->tx pointers.
>

right

> > +		return 0;
> > +	tx = adv748x_sd_to_csi2(sd);
> > +
> > +	/*
> > +	 * Now that we're sure we're operating on one of the two TXs,
> > +	 * make sure there are no enabled links ending there from
> > +	 * either HDMI or AFE (this can only happens for TXA though).
> > +	 */
> > +	if (is_txa(tx))
> > +		list_for_each_entry(link, &entity->links, list)
> > +			if (link->sink->entity == entity &&
> > +			    link->flags & MEDIA_LNK_FL_ENABLED)
> > +				return -EINVAL;
>
> You can simplify this by checking if tx->source == NULL (after resetting tx-
> >source when disabling the link of course).
>
> > +	/* Change video stream routing, according to the newly created link. */
> > +	io10 = io_read(state, ADV748X_IO_10);
> > +	if (rsd == &state->afe.sd) {
> > +		state->afe.tx = tx;
> > +
> > +		/*
> > +		 * If AFE is routed to TXA, make sure TXB is off;
> > +		 * If AFE goes to TXB, we need TXA powered on.
> > +		 */
> > +		if (is_txa(tx)) {
> > +			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
> > +			io10 &= ~ADV748X_IO_10_CSI1_EN;
> > +		} else {
> > +			io10 |= ADV748X_IO_10_CSI4_EN |
> > +				ADV748X_IO_10_CSI1_EN;
> > +		}
> > +	} else {
> > +		state->hdmi.tx = tx;
> > +		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
> > +	}
> > +	io_write(state, ADV748X_IO_10, io10);
>
> Is it guaranteed that the chip will be powered on at this point ? How about
> writing the register at stream on time instead ?

You know, I struggle to find a better place where to do so...
- Right now the register gets written at reset time only
- s_stream: Each subdev (afe, hdmi, txa and txb) has its own s_stream
  so it's hard to find a centralized place where to write this
  register that impacts both TXes
- afe/hdmi s_stream() ops call tx_power_up, but again this is per-TX
- There doesn't seems to be much concern in the driver in
  synchronizing register writes with power states already actually. Not
  that's an excuse, but when I played around and tried to power off
  the chip's PLLs for real I got into LP-11 state detection issues
  (again :) I would leave it here if that's fine with you :)

Thanks
   j

>
> > +	tx->rsd = rsd;
> > +
> > +	return 0;
> > +}
> >
> >  static const struct media_entity_operations adv748x_media_ops = {
> > -	.link_validate = v4l2_subdev_link_validate,
> > +	.link_setup	= adv748x_link_setup,
> > +	.link_validate	= v4l2_subdev_link_validate,
> >  };
> >
> >  /* ------------------------------------------------------------------------
> > -- diff --git a/drivers/media/i2c/adv748x/adv748x.h
> > b/drivers/media/i2c/adv748x/adv748x.h index 0ee3b8d5c795..63a17c31c169
> > 100644
> > --- a/drivers/media/i2c/adv748x/adv748x.h
> > +++ b/drivers/media/i2c/adv748x/adv748x.h
> > @@ -220,6 +220,7 @@ struct adv748x_state {
> >  #define ADV748X_IO_10_CSI4_EN		BIT(7)
> >  #define ADV748X_IO_10_CSI1_EN		BIT(6)
> >  #define ADV748X_IO_10_PIX_OUT_EN	BIT(5)
> > +#define ADV748X_IO_10_CSI4_IN_SEL_AFE	0x08
> >
> >  #define ADV748X_IO_CHIP_REV_ID_1	0xdf
> >  #define ADV748X_IO_CHIP_REV_ID_2	0xe0
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlwlOGEACgkQcjQGjxah
Vjx5nA//dExzkszHRikLIJJDmdvhddZsTsErDBTdePkM8vX2c3fRLPgPS0xZ0BPO
Pm5LiomngUaBb6vPkrocb8Zfe5hLU0xX/6CCMYf8wCeBsvhAlrfSCzIOnAPZ3pCp
63JSv+PV+mjcAW66Pm3qv8TFeNifC3rJ54i9RwKqb8sPLgd+f+gnHlucqix+sGX8
Tskml3HxPlaS4TN1mjAQ3i5tV0Wg8Y1rpDqofGChEJo18WvZRkVz3GaDQxkoMgrb
KKpYaw0NEtEB5DAtIMI7kZU8c9j/IgPZHQh5jzbNshIECsa8LUWXJ3W2KUF8laBS
a7zwn881lNKqCF03A2OEpdvCiK1JWl26fllZRVOGEVyflJiK7ejssYkcANG6bAWp
eyD+/3C+xdiqPNT3bah9qwBNKNU00B2hgPe+spXCpiUa8RAldFJcuGEs6efZTkzj
GYDLzuS+pz2cog9FswYViFl8GS5eOzKITqPOmBTBwRT8/p73bPhKaqlYUS6P6xv4
H0EkGVkXZ+o5914eaGLuoZQPp7Nz7XwGvJPQty81gEDUW1zN8csYpJ20Aqk3Urjd
EfrB94J/FHBxdvMaSOnoSqs5XK+mXJGupbfb17pgwwtYl8tgCaWB0IqEAgRJr/jN
OWQuAQXs80GoYWHLPM5nYxrHav0HIuUjsTcObQP4NqquzXdkTbs=
=FHVC
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--

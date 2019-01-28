Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5021C282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 14:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86A612147A
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 14:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfA1OrZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 09:47:25 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:37593 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfA1OrZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 09:47:25 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 8A8514000B;
        Mon, 28 Jan 2019 14:47:21 +0000 (UTC)
Date:   Mon, 28 Jan 2019 15:47:37 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 3/6] media: adv748x: csi2: Link AFE with TXA and TXB
Message-ID: <20190128144736.7hulivpepab2mp7z@uno.localdomain>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
 <20190110140213.5198-4-jacopo+renesas@jmondi.org>
 <20190114145533.GK30160@bigcity.dyn.berto.se>
 <20190116134424.GP7393@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6lqm5xioql4su6x6"
Content-Disposition: inline
In-Reply-To: <20190116134424.GP7393@bigcity.dyn.berto.se>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--6lqm5xioql4su6x6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,
   sorry for replying late

On Wed, Jan 16, 2019 at 02:44:25PM +0100, Niklas S=C3=B6derlund wrote:
> Hi (again) Jacopo,
>
> I found something else in this patch unfortunately :-(
>
> On 2019-01-14 15:55:33 +0100, Niklas S=C3=B6derlund wrote:
> > Hi Jacopo,
> >
> > Thanks for your patch.
> >
> > On 2019-01-10 15:02:10 +0100, Jacopo Mondi wrote:
> > > The ADV748x chip supports routing AFE output to either TXA or TXB.
> > > In order to support run-time configuration of video stream path, crea=
te an
> > > additional (not enabled) "AFE:8->TXA:0" link, and remove the IMMUTABL=
E flag
> > > from existing ones.
> > >
> > > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > >  drivers/media/i2c/adv748x/adv748x-csi2.c | 44 +++++++++++++---------=
--
> > >  1 file changed, 23 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media=
/i2c/adv748x/adv748x-csi2.c
> > > index b6b5d8c7ea7c..8c3714495e11 100644
> > > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > > @@ -27,6 +27,7 @@ static int adv748x_csi2_set_virtual_channel(struct =
adv748x_csi2 *tx,
> > >   * @v4l2_dev: Video registration device
> > >   * @src: Source subdevice to establish link
> > >   * @src_pad: Pad number of source to link to this @tx
> > > + * @enable: Link enabled flag
> > >   *
> > >   * Ensure that the subdevice is registered against the v4l2_device, =
and link the
> > >   * source pad to the sink pad of the CSI2 bus entity.
> > > @@ -34,17 +35,11 @@ static int adv748x_csi2_set_virtual_channel(struc=
t adv748x_csi2 *tx,
> > >  static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
> > >  				      struct v4l2_device *v4l2_dev,
> > >  				      struct v4l2_subdev *src,
> > > -				      unsigned int src_pad)
> > > +				      unsigned int src_pad,
> > > +				      bool enable)
> > >  {
> > > -	int enabled =3D MEDIA_LNK_FL_ENABLED;
> > >  	int ret;
> > >
> > > -	/*
> > > -	 * Dynamic linking of the AFE is not supported.
> > > -	 * Register the links as immutable.
> > > -	 */
> > > -	enabled |=3D MEDIA_LNK_FL_IMMUTABLE;
> > > -
> > >  	if (!src->v4l2_dev) {
> > >  		ret =3D v4l2_device_register_subdev(v4l2_dev, src);
> > >  		if (ret)
> > > @@ -53,7 +48,7 @@ static int adv748x_csi2_register_link(struct adv748=
x_csi2 *tx,
> > >
> > >  	return media_create_pad_link(&src->entity, src_pad,
> > >  				     &tx->sd.entity, ADV748X_CSI2_SINK,
> > > -				     enabled);
> > > +				     enable ? MEDIA_LNK_FL_ENABLED : 0);
> > >  }
> > >
> > >  /* -----------------------------------------------------------------=
------------
> > > @@ -68,25 +63,32 @@ static int adv748x_csi2_registered(struct v4l2_su=
bdev *sd)
> > >  {
> > >  	struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
> > >  	struct adv748x_state *state =3D tx->state;
> > > +	int ret;
> > >
> > >  	adv_dbg(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
> > >  			sd->name);
> > >
> > >  	/*
> > > -	 * The adv748x hardware allows the AFE to route through the TXA, ho=
wever
> > > -	 * this is not currently supported in this driver.
> > > +	 * Link TXA to AFE and HDMI, and TXB to AFE only as TXB cannot outp=
ut
> > > +	 * HDMI.
> > >  	 *
> > > -	 * Link HDMI->TXA, and AFE->TXB directly.
> > > +	 * The HDMI->TXA link is enabled by default, as is the AFE->TXB one.
> > >  	 */
> > > -	if (is_txa(tx) && is_hdmi_enabled(state))
> > > -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > > -						  &state->hdmi.sd,
> > > -						  ADV748X_HDMI_SOURCE);
> > > -	if (is_txb(tx) && is_afe_enabled(state))
> > > -		return adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > > -						  &state->afe.sd,
> > > -						  ADV748X_AFE_SOURCE);
> > > -	return 0;
> > > +	if (is_afe_enabled(state)) {
> > > +		ret =3D adv748x_csi2_register_link(tx, sd->v4l2_dev,
> > > +						 &state->afe.sd,
> > > +						 ADV748X_AFE_SOURCE,
> > > +						 is_txb(tx));
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > > +	/* Register link to HDMI for TXA only. */
> > > +	if (is_txb(tx) || !is_hdmi_enabled(state))
> >
> > Small nit, I would s/is_txb(tx)/!is_txa(tx)/ here as to me it becomes
> > easier to read. With or without this change,
> >
> > Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> >
> > > +		return 0;
> > > +
> > > +	return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
> > > +					  ADV748X_HDMI_SOURCE, true);
>
> If the call to adv748x_csi2_register_link() fails should not the
> (possible) link to the AFE be removed?
>

The .register() callback is called from v4l2-device.c in
v4l2_device_register_subdev(). If the callback returns an error, the
subdev gets not registered at all and the media entity cleaned up, so it
won't appear in the media graph.

I think we're safe and the patch series is good to go. What's your
opinion?

Thanks
  j


> > >  }
> > >
> > >  static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_o=
ps =3D {
> > > --
> > > 2.20.1
> > >
> >
> > --
> > Regards,
> > Niklas S=C3=B6derlund
>
> --
> Regards,
> Niklas S=C3=B6derlund

--6lqm5xioql4su6x6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxPFggACgkQcjQGjxah
Vjw0hhAAuA225cOHJG+bQfMduR9zUdwA7eUpv/ForkJdC+ZiTsS/PFU7+fMKjGb4
aCURAcR/98qX3a16Pun92fwg3HqaRNkrX711FDuoARAkge/sO/pus8vU534zNJRT
W+MZCpRp2CgAusYkSUEOi8eOQM9ogbN8CGmlA5hcDLnjRWoRqYjoYHDy4GWMWN/2
2QAHkpDFymv8Zbe7G6q3axzld7XyOvafsz98s9DirbNO1vn6saHQke8kG16GUXkb
85OHO3bQap3HEZfCG12w4M/BZS7grPj/phZFSsDyAozs5cQ+4BImN+qEu3sGOcjB
b2h5LRIOioPLj4JVqZ8DdejZpK3jASWB6iRCYGNZZYs0xLVzg5Xbx07oQ+UeooGC
/ARqfyJKs4kPXaQ/Lm6id31+a9A7uqWYtXU84uKwYOwGTiCjQ2/sMOTNFBRIpnuX
YdzNizG3oDFOIf2PzuJl9khh0MACh/fdMtz/iPQOjAVvP/L6ZZ4MBZXzyMgnxI69
jc+XtM7xmJok/Kudu0bg6JlMVAGrQWBYjUqygWbjGXsc5rS6ppmAZpTZ4DK+8guw
FuhmjKVlFkH2GApLlKeurUp0JSQAebNJlRfLuRc9u+QFNYguzeoupElhxp6nUKQC
e8JiBMixfhbx85jrJAspSbLJI3qZ50z4fbeW/jcUTsGZb3MW99E=
=lARp
-----END PGP SIGNATURE-----

--6lqm5xioql4su6x6--

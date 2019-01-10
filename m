Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC245C43612
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 08:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93E042173B
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 08:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfAJIu5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:50:57 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52495 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfAJIu4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 03:50:56 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 97288E0008;
        Thu, 10 Jan 2019 08:50:53 +0000 (UTC)
Date:   Thu, 10 Jan 2019 09:51:00 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     kieran.bingham@ideasonboard.com,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 6/6] media: adv748x: Implement TX link_setup callback
Message-ID: <20190110085100.l4dwjxdkx23jfhfg@uno.localdomain>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
 <20190106155413.30666-7-jacopo+renesas@jmondi.org>
 <9f156850-14b6-3ca2-47c1-e03e1bc2c0f8@ideasonboard.com>
 <1722143.vWDHCLa8RZ@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yfdohzsps4vq5rh7"
Content-Disposition: inline
In-Reply-To: <1722143.vWDHCLa8RZ@avalon>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--yfdohzsps4vq5rh7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Laurent,

On Wed, Jan 09, 2019 at 02:15:04AM +0200, Laurent Pinchart wrote:
> Hello,
>
> On Monday, 7 January 2019 14:36:28 EET Kieran Bingham wrote:
> > On 06/01/2019 15:54, Jacopo Mondi wrote:
> > > When the adv748x driver is informed about a link being created from HDMI
> > > or AFE to a CSI-2 TX output, the 'link_setup()' callback is invoked. Make
> > > sure to implement proper routing management at link setup time, to route
> > > the selected video stream to the desired TX output.
> >
> > Overall this looks like the right approach - but I feel like the
> > handling of the io10 register might need some consideration, because
> > it's value depends on the condition of both CSI2 transmitters, not just
> > the currently parsed link.
> >
> > I had a go at some pseudo - uncompiled/untested code inline as a suggestion.
> >
> > If you think it's better - feel free to rework it in ... or not as you
> > see fit.
> >
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > >
> > >  drivers/media/i2c/adv748x/adv748x-core.c | 57 +++++++++++++++++++++++-
> > >  drivers/media/i2c/adv748x/adv748x.h      |  2 +
> > >  2 files changed, 58 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> > > b/drivers/media/i2c/adv748x/adv748x-core.c index
> > > 200e00f93546..a586bf393558 100644
> > > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > > @@ -335,6 +335,60 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool
> > > on)
> > >  /* ----------------------------------------------------------------------
> > >   * Media Operations
> > >   */
> > > +static int adv748x_link_setup(struct media_entity *entity,
> > > +			      const struct media_pad *local,
> > > +			      const struct media_pad *remote, u32 flags)
> > > +{
> > > +	struct v4l2_subdev *rsd = media_entity_to_v4l2_subdev(remote->entity);
> > > +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> > > +	struct adv748x_state *state = v4l2_get_subdevdata(sd);
> > > +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> > > +	bool enable = flags & MEDIA_LNK_FL_ENABLED;
> > > +	u8 io10;
> > > +
> > > +	/* Refuse to enable multiple links to the same TX at the same time. */
> > > +	if (enable && tx->src)
> > > +		return -EINVAL;
> > > +
> > > +	/* Set or clear the source (HDMI or AFE) and the current TX. */
> > > +	if (rsd == &state->afe.sd)
> > > +		state->afe.tx = enable ? tx : NULL;
> > > +	else
> > > +		state->hdmi.tx = enable ? tx : NULL;
> > > +
> > > +	tx->src = enable ? rsd : NULL;
> > > +
> > > +	if (!enable)
> > > +		return 0;
> >
> > Don't we potentially want to take any action on disable to power down
> > links below ?
> >
> > > +
> > > +	/* Change video stream routing, according to the newly enabled link. */
> > > +	io10 = io_read(state, ADV748X_IO_10);
> > > +	if (rsd == &state->afe.sd) {
> > > +		/*
> > > +		 * Set AFE->TXA routing and power off TXB if AFE goes to TXA.
> > > +		 * if AFE goes to TXB, we need both TXA and TXB powered on.
> > > +		 */
> > > +		io10 &= ~ADV748X_IO_10_CSI1_EN;
> > > +		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
> > > +		if (is_txa(tx))
> > > +			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
> >
> > Shouldn't the CSI4 be enabled here too? or are we assuming it's already
> > (/always) enabled?
> > 		io10 |= ADV748X_IO_10_CSI4_EN;
> >
> > > +		else
> > > +			io10 |= ADV748X_IO_10_CSI4_EN |
> > > +				ADV748X_IO_10_CSI1_EN;
> > > +	} else {
> > > +		/* Clear AFE->TXA routing and power up TXA. */
> > > +		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
> > > +		io10 |= ADV748X_IO_10_CSI4_EN;
> >
> > But if we assume it's already enabled ... do we need this?
> > Perhaps it might be better to be explicit on this?
> >
> > > +	}
> > > +	io_write(state, ADV748X_IO_10, io10);
> >
> > Would it be any cleaner to use io_clrset() here?
> >
> > Hrm ... also it feels like this register really should be set depending
> > upon the complete state of ... &state->...
> >
> > So perhaps it deserves it's own function which should be called after
> > csi_registered() callback and any link change.
> >
> > /me has a quick go at some psuedo codeishness...:
> >
> > int adv74x_io_10(struct adv748x_state *state);
> > 	u8 bits = 0;
> > 	u8 mask = ADV748X_IO_10_CSI1_EN
> >
> > 		| ADV748X_IO_10_CSI4_EN
> > 		| ADV748X_IO_10_CSI4_IN_SEL_AFE;
> >
> > 	if (state->afe.tx) {
> > 		/* AFE Requires TXA enabled, even when output to TXB */
> > 		bits |= ADV748X_IO_10_CSI4_EN;
> >
> > 		if (is_txa(state->afe.tx))
> > 			bits |= ADV748X_IO_10_CSI4_IN_SEL_AFE
> > 		else
> > 			bits |= ADV748X_IO_10_CSI1_EN;
> > 	}
> >
> > 	if (state->hdmi.tx) {
> > 		bits |= ADV748X_IO_10_CSI4_EN;
> > 	}
> >
> > 	return io_clrset(state, ADV748X_IO_10, mask, bits);
> > }
> >
> > How does that look ? (is it even correct first?)
> >
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static const struct media_entity_operations adv748x_tx_media_ops = {
> > > +	.link_setup	= adv748x_link_setup,
> > > +	.link_validate	= v4l2_subdev_link_validate,
> > > +};
> > >
> > >  static const struct media_entity_operations adv748x_media_ops = {
> > >  	.link_validate = v4l2_subdev_link_validate,
> > > @@ -516,7 +570,8 @@ void adv748x_subdev_init(struct v4l2_subdev *sd,
> > > struct adv748x_state *state,
> > >  		state->client->addr, ident);
> > >
> > >  	sd->entity.function = function;
> > > -	sd->entity.ops = &adv748x_media_ops;
> > > +	sd->entity.ops = is_tx(adv748x_sd_to_csi2(sd)) ?
> > > +			 &adv748x_tx_media_ops : &adv748x_media_ops;
> >
> > Aha - yes that's a neat solution to ensure that only the TX links
> > generate link_setup calls :)
>
> Another option would be to bail out from adv748x_link_setup() if the entity is
> not a TX*.
>

If I'm not wrong you suggested me to register a set of operations with
the .link_setup callback only for TX entities, and I agree it is much
better, so I'm leaning to leave it as it is in this series.

Thanks
  j

> > >  }
>
> [snip]
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>

--yfdohzsps4vq5rh7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlw3B3QACgkQcjQGjxah
VjwGYQ//R2Czox++jVHky3E3eBn9ct7Z/PeY2pXin3G8beBfLjetP9kbOPF/yhTl
ttUh65kWkonhhxA5ljGE+nACrs0fEHdkW+/xL+3fFSsJva1xh39oklXRVNx+p8FJ
36vGts/NNlyP7pXmHwyLAndAyX8cCi5tAydN9ZP55DD13hzLTw68DAAB93lLDPzX
hsvv+d+FQEVcCgtM73hYUnMJLapqkQRUpfkg+oMtkQ0NeZGXDMKKhRmMT0q2Hpv9
0zYwPvT7NESTpz+EqsUHt2tZeI2EjgALHzlDjxDpfwKALjogejMUEjB2J5T0DnNe
meyMG+YIEdwenhgGCWZIB4qLJhcISWMoF/oUsw3of7xHqJg14sCyQapQR84juLYB
vvJPL2QW9ViYR6jFMVN12VjFCUvOuRynt+oaQfvVmSIHaYkw+EJlLboMcgEXF4Bu
O5GFSzRT3VUGcoz8CsfuiBTgMDPR/0ifu2qTfk35glJdUcdJUx2xTVqDwSVFmVl+
9Yw7CtBwiyrBj+ns5gfXYR3JCD2QGL4Vv9G15II3WZ1Y/VfhiFMkWrpCMJnyg9Vw
+1GaPcpceTZ1D+TcU8/8WDUURBEDkjmywo96h3P7BNe+kir/aM/B8LvdYdBT/1BC
d7l19/CnTPRCK1Mf4SIpzx7NPxVa3mjTlUifx+p+gIZHjTcRWFk=
=ehpP
-----END PGP SIGNATURE-----

--yfdohzsps4vq5rh7--

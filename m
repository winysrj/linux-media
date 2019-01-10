Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0ABCC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 10:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88D9F206B6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 10:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfAJKBw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 05:01:52 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:42543 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbfAJKBv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 05:01:51 -0500
X-Greylist: delayed 56485 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2019 05:01:50 EST
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id AFE5520019;
        Thu, 10 Jan 2019 10:01:47 +0000 (UTC)
Date:   Thu, 10 Jan 2019 11:01:49 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 6/6] media: adv748x: Implement TX link_setup callback
Message-ID: <20190110100149.sk7w5fjuiai476r3@uno.localdomain>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org>
 <20190106155413.30666-7-jacopo+renesas@jmondi.org>
 <9f156850-14b6-3ca2-47c1-e03e1bc2c0f8@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dul32lhnxg47xnxw"
Content-Disposition: inline
In-Reply-To: <9f156850-14b6-3ca2-47c1-e03e1bc2c0f8@ideasonboard.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--dul32lhnxg47xnxw
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

You know, I had a thought about it, and I was not sure it was worth
it. The chip stays powered, and even if a TX stays active when it is
not linked, this is not worse than what it was before, and
considering...


> > +
> > +	/* Change video stream routing, according to the newly enabled link. */
> > +	io10 = io_read(state, ADV748X_IO_10);
> > +	if (rsd == &state->afe.sd) {
> > +		/*
> > +		 * Set AFE->TXA routing and power off TXB if AFE goes to TXA.
> > +		 * if AFE goes to TXB, we need both TXA and TXB powered on.
> > +		 */

... this
I should not simply disable, say TXA, because the HDMI->TXA link has
been disabled, but I should inspect the global state everytime.

> > +		io10 &= ~ADV748X_IO_10_CSI1_EN;
> > +		io10 &= ~ADV748X_IO_10_CSI4_IN_SEL_AFE;
> > +		if (is_txa(tx))
> > +			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
>
> Shouldn't the CSI4 be enabled here too? or are we assuming it's already
> (/always) enabled?
> 		io10 |= ADV748X_IO_10_CSI4_EN;

Correct, I wrongly assumed it stayed on, but it could be not.

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

Not sure if it is cleaner, but I checked if it was safe to write the
whole IO_10 register, and the only fields not touched by this are the
ones controlling output redirection to the TTL port, which should stay
zeros. Bits [1:0] are not documented though..
>
> Hrm ... also it feels like this register really should be set depending
> upon the complete state of ... &state->...
>

Possibly, that would help catching cases where a TX (or both TXs) could be
shut down, if we consider it worthy.

> So perhaps it deserves it's own function which should be called after
> csi_registered() callback and any link change.
>

Not sure if it makes sense to touch this register when a subdevice
gets registered... we create links at that time, but they're not
enabled, so the only place where this configuration changes is
actually this function. I'm not sure it is worth breaking this out,
but I agree the full state should probably be inspected, and not just
the last changed route.

I'll run some tests and see how it works.
Thanks for the comments
   j


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

--dul32lhnxg47xnxw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlw3GA0ACgkQcjQGjxah
Vjw51g/9EFSGF9OU58XYtv0Vf+9AdXhYx0NeOLIZ1ymvN8T3CLzCAiNnkIKp9GQT
tbF8rL1Y8C00liZ2CzpnCvj/AscyX5GmWdeDgdHV6R7WsouvUBaGBsNB5bqrM5XC
j1meuatgz11O9Lv8KVSTsbaB8rLk/7VXwNkxkOcxv/KaNW4oihTaVxYOWLJg2+zX
Y/02ox5cnh5jnEbXVVsu7zw2lDZ57fAC4ca/lRvkMnctqZoHoeMmzrUqB1GlUQFF
cq/hvr+GAi3kkcuB8puTym4GDifXCh708MKMGUtah5o8kTAqWfbAcKIxcfM4q9bi
EIZ+fycc7oI3NgUrVM5nLV0ZHd0huDumwS4GzpPVTNT880T7eCT7hHaYYtr6I6mX
zRDX/BGQww4Xzy/oNupvChjfWYEY8WASsXLpljHepMBbK86tPb/EKf78D5eMzAst
8Zq/APvhcQjVbp5QBVd1tk8ZMJuMurVvMh1EbTQs8QS9G1cRFI3vCtFlBeU6gow0
WSxqFDcaDM38Il4rAPRYu0dUtgbPjXydJBZ8B1Cq9mMYN4whY3LJ3bJsoMv7xk8r
FFOfLfyjDcCMrlhrsY2454Rh0hBi01UPSOkhMRSedTWBVzyjyECIW+Wm7b4nA0UV
thrpwTeqJ9UaYd/BLK2FctvFxmCXa5PfuvHemnuTWJHi2ogT9ao=
=ZLAU
-----END PGP SIGNATURE-----

--dul32lhnxg47xnxw--

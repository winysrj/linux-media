Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40623 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752192AbeDSO7d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 10:59:33 -0400
Message-ID: <d2df04bd29b040001577d3bb905c81b3aff8f594.camel@bootlin.com>
Subject: Re: [PATCH 5/9] media: platform: Add Sunxi Cedrus decoder driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Icenowy Zheng <icenowy@aosc.xyz>,
        Florent Revest <revestflo@gmail.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas van Kleef <thomas@vitsch.nl>,
        "Signed-off-by : Bob Ham" <rah@settrans.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Date: Thu, 19 Apr 2018 16:58:18 +0200
In-Reply-To: <20180309135702.pk4webt7xnj7lrza@flea>
References: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
         <20180309101445.16190-3-paul.kocialkowski@bootlin.com>
         <20180309135702.pk4webt7xnj7lrza@flea>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-lYPRh0T5wzpLHC3is229"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-lYPRh0T5wzpLHC3is229
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi and thanks for the review,

On Fri, 2018-03-09 at 14:57 +0100, Maxime Ripard wrote:
> On Fri, Mar 09, 2018 at 11:14:41AM +0100, Paul Kocialkowski wrote:
> > +/*
> > + * mem2mem callbacks
> > + */
> > +
> > +void job_abort(void *priv)
> > +{}
>=20
> Is that still needed?

v2 contains a proper implementation of job abortion, so yes :)

> > +/*
> > + * device_run() - prepares and starts processing
> > + */
> > +void device_run(void *priv)
> > +{
>=20
> This function (and the one above) should probably made static. Or at
> least if you can't, they should have a much more specific name in
> order not to conflict with anything from the core.

Agreed, will fix in v2.

> > +	/*
> > +	 * The VPU is only able to handle bus addresses so we have
> > to subtract
> > +	 * the RAM offset to the physcal addresses
> > +	 */
> > +	in_buf     -=3D PHYS_OFFSET;
> > +	out_luma   -=3D PHYS_OFFSET;
> > +	out_chroma -=3D PHYS_OFFSET;
>=20
> You should take care of that by putting it in the dma_pfn_offset field
> of the struct device (at least before we come up with something
> better).
>=20
> You'll then be able to use the dma_addr_t directly without modifying
> it.

Ditto.

> > +	vpu->syscon =3D syscon_regmap_lookup_by_phandle(vpu->dev-
> > >of_node,
> > +						      "syscon");
> > +	if (IS_ERR(vpu->syscon)) {
> > +		vpu->syscon =3D NULL;
> > +	} else {
> > +		regmap_write_bits(vpu->syscon,
> > SYSCON_SRAM_CTRL_REG0,
> > +				  SYSCON_SRAM_C1_MAP_VE,
> > +				  SYSCON_SRAM_C1_MAP_VE);
> > +	}
>=20
> This should be using our SRAM controller driver (and API), see
> Documentation/devicetree/bindings/sram/sunxi-sram.txt
> include/linux/soc/sunxi/sunxi_sram.h

This will require adding support for the VE (and the A33 along the way)
in the SRAM driver, so a dedicated patch series will be sent in this
direction eventually.

> > +	ret =3D clk_prepare_enable(vpu->ahb_clk);
> > +	if (ret) {
> > +		dev_err(vpu->dev, "could not enable ahb clock\n");
> > +		return -EFAULT;
> > +	}
> > +	ret =3D clk_prepare_enable(vpu->mod_clk);
> > +	if (ret) {
> > +		clk_disable_unprepare(vpu->ahb_clk);
> > +		dev_err(vpu->dev, "could not enable mod clock\n");
> > +		return -EFAULT;
> > +	}
> > +	ret =3D clk_prepare_enable(vpu->ram_clk);
> > +	if (ret) {
> > +		clk_disable_unprepare(vpu->mod_clk);
> > +		clk_disable_unprepare(vpu->ahb_clk);
> > +		dev_err(vpu->dev, "could not enable ram clock\n");
> > +		return -EFAULT;
> > +	}
>=20
> Ideally, this should be using runtime_pm to manage the device power
> state, and disable it when not used.
>=20
> > +	reset_control_assert(vpu->rstc);
> > +	reset_control_deassert(vpu->rstc);
>=20
> You can use reset_control_reset here

Will do in v2.

> > +	return 0;
> > +}
> > +
> > +void sunxi_cedrus_hw_remove(struct sunxi_cedrus_dev *vpu)
> > +{
> > +	clk_disable_unprepare(vpu->ram_clk);
> > +	clk_disable_unprepare(vpu->mod_clk);
> > +	clk_disable_unprepare(vpu->ahb_clk);
>=20
> The device is not put back into reset here

Good catch!

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-lYPRh0T5wzpLHC3is229
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrYrooACgkQ3cLmz3+f
v9GPlwf5ATGUchrf3ZZN5vIYJiuJ+FEu4zhjGo33RJhpVGFWjQSf4Cag0M4O1S84
AjWbFRdTrLglMRlxkqwybucQtLYMSXnm5AdMvXtkecKwCgmV6KzvSCVqUlxMIm/l
R+dPM84HSzoB43q2M6OY7cfr4TGvofsd272AFW9c9F/FIicHGwFHie45g/6bX6zK
dvw65KJY6vnpfI7OJ3d1xnleDfykU/IQfAt7qxtdHhEN8ZvG1QPsuDY9Jf7YXDB+
0kDEjraPqG8w2j3rrj51vQj48Bqp0KqBv8SHGdCMch5vFMIlbfQTZkoW4Bz9Cqlo
PxORRTZKwHG1/c2G76/2aAePKQYKzQ==
=xvrY
-----END PGP SIGNATURE-----

--=-lYPRh0T5wzpLHC3is229--

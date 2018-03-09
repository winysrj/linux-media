Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57269 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbeCIO0l (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 09:26:41 -0500
Message-ID: <1520605522.15946.14.camel@bootlin.com>
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
Date: Fri, 09 Mar 2018 15:25:22 +0100
In-Reply-To: <20180309135702.pk4webt7xnj7lrza@flea>
References: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
         <20180309101445.16190-3-paul.kocialkowski@bootlin.com>
         <20180309135702.pk4webt7xnj7lrza@flea>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pZHdMQqkI16B0Hm/jNZ1"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-pZHdMQqkI16B0Hm/jNZ1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2018-03-09 at 14:57 +0100, Maxime Ripard wrote:
> Hi,
>=20
> On Fri, Mar 09, 2018 at 11:14:41AM +0100, Paul Kocialkowski wrote:
> > +/*
> > + * mem2mem callbacks
> > + */
> > +
> > +void job_abort(void *priv)
> > +{}
>=20
> Is that still needed?

It looks like we need a dummy callback here, the v4l2_m2m_init function
puts a hard requirement on it.

The feature is definitely not used for now, but maybe this could be
hooked to aborting the matching request? It was probably designed for
the case where the driver handles a queue of jobs on its own (that's how
it's used in vim2m) and such an internal queue is perhaps irrelevant
when using the request API (and fences later).

> > +/*
> > + * device_run() - prepares and starts processing
> > + */
> > +void device_run(void *priv)
> > +{
>=20
> This function (and the one above) should probably made static. Or at
> least if you can't, they should have a much more specific name in
> order not to conflict with anything from the core.

Good point, let's go for static. Since these are passed as function
pointers, it shouldn't be a problem.

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

Definitely!

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

I'll look into that.

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

I'll add that to my tasks list. I suppose we shouldn't make this a
priority for now, but this is definitely good to have.

> > +	reset_control_assert(vpu->rstc);
> > +	reset_control_deassert(vpu->rstc);
>=20
> You can use reset_control_reset here

Noted!

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

Good catch, thanks!

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-pZHdMQqkI16B0Hm/jNZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlqimVIACgkQ3cLmz3+f
v9FiKgf/UE8Ui3Gq1AIlGByqBTacl4xT8gXFdGs2y6Ko+YXNAJE50p8MSDzax7h2
AThhNOY3Skg/dUZcHht40LLs0WaXjbqt69bFacEG1XA9ByS5atGMuHo92NNeloyZ
ljg7ErPz108P0r1hYWSpXfp0Bzd+/9t2gKthSkMh/PDfGfReZhAiRjtgki958u7j
l0tyb9jdMTlnpjM+9U45kJJcqKicGhJJcXopsFhBcNqbaOCCtCUCa/H62k0PpGtU
lJzMI9GLIosmP0gMQxsSQx0PDn2uut5xHFMsC1dog7J+CpXcWj48fwvi50AuHD44
dbbotmx6UuXhCaiIbtFzPA9E81UlUw==
=uGjD
-----END PGP SIGNATURE-----

--=-pZHdMQqkI16B0Hm/jNZ1--

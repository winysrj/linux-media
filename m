Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:56368 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbeCIN5Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 08:57:16 -0500
Date: Fri, 9 Mar 2018 14:57:02 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
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
Subject: Re: [PATCH 5/9] media: platform: Add Sunxi Cedrus decoder driver
Message-ID: <20180309135702.pk4webt7xnj7lrza@flea>
References: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
 <20180309101445.16190-3-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k4r33uam73c6qikk"
Content-Disposition: inline
In-Reply-To: <20180309101445.16190-3-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--k4r33uam73c6qikk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 09, 2018 at 11:14:41AM +0100, Paul Kocialkowski wrote:
> +/*
> + * mem2mem callbacks
> + */
> +
> +void job_abort(void *priv)
> +{}

Is that still needed?

> +/*
> + * device_run() - prepares and starts processing
> + */
> +void device_run(void *priv)
> +{

This function (and the one above) should probably made static. Or at
least if you can't, they should have a much more specific name in
order not to conflict with anything from the core.


> +	/*
> +	 * The VPU is only able to handle bus addresses so we have to subtract
> +	 * the RAM offset to the physcal addresses
> +	 */
> +	in_buf     -=3D PHYS_OFFSET;
> +	out_luma   -=3D PHYS_OFFSET;
> +	out_chroma -=3D PHYS_OFFSET;

You should take care of that by putting it in the dma_pfn_offset field
of the struct device (at least before we come up with something
better).

You'll then be able to use the dma_addr_t directly without modifying it.

> +	vpu->syscon =3D syscon_regmap_lookup_by_phandle(vpu->dev->of_node,
> +						      "syscon");
> +	if (IS_ERR(vpu->syscon)) {
> +		vpu->syscon =3D NULL;
> +	} else {
> +		regmap_write_bits(vpu->syscon, SYSCON_SRAM_CTRL_REG0,
> +				  SYSCON_SRAM_C1_MAP_VE,
> +				  SYSCON_SRAM_C1_MAP_VE);
> +	}

This should be using our SRAM controller driver (and API), see
Documentation/devicetree/bindings/sram/sunxi-sram.txt
include/linux/soc/sunxi/sunxi_sram.h

> +	ret =3D clk_prepare_enable(vpu->ahb_clk);
> +	if (ret) {
> +		dev_err(vpu->dev, "could not enable ahb clock\n");
> +		return -EFAULT;
> +	}
> +	ret =3D clk_prepare_enable(vpu->mod_clk);
> +	if (ret) {
> +		clk_disable_unprepare(vpu->ahb_clk);
> +		dev_err(vpu->dev, "could not enable mod clock\n");
> +		return -EFAULT;
> +	}
> +	ret =3D clk_prepare_enable(vpu->ram_clk);
> +	if (ret) {
> +		clk_disable_unprepare(vpu->mod_clk);
> +		clk_disable_unprepare(vpu->ahb_clk);
> +		dev_err(vpu->dev, "could not enable ram clock\n");
> +		return -EFAULT;
> +	}

Ideally, this should be using runtime_pm to manage the device power
state, and disable it when not used.

> +	reset_control_assert(vpu->rstc);
> +	reset_control_deassert(vpu->rstc);

You can use reset_control_reset here

> +	return 0;
> +}
> +
> +void sunxi_cedrus_hw_remove(struct sunxi_cedrus_dev *vpu)
> +{
> +	clk_disable_unprepare(vpu->ram_clk);
> +	clk_disable_unprepare(vpu->mod_clk);
> +	clk_disable_unprepare(vpu->ahb_clk);

The device is not put back into reset here

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--k4r33uam73c6qikk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqikq0ACgkQ0rTAlCFN
r3QY/g//d+U9VlBGVJv8nFwjXL9Y7IaUfQYPSWlycsFTAp+aEexL1qKM2oFbZa4q
hV6qWtOT8IJOfLN4poDlZ2+IV8XW2z7t5JDBjx0quTgjbwzQFnRRZ4JstvtRBmxX
KDVwXnrin1YaACfyZ5Kz4t4IxOwFbnZ1S9MyYB7LRPBDKrvW0iLiMgGFauuKYpOR
mvP+3Z5iiW6ThHrkt/2YDT4SQRYDWf9QU/UPY8vMc6uUOVcc9eZGIJVCE7hyQ4Ee
nUbDwLgANobZypCjrrQkj7Ti+GTh2W9WDwor6VtAHQ7VGseQYhooL4tnLCRcQFee
RW6+cHM7IhCBk59Nii40N6ahJu4AN7s3f1m/jFDJv/Akwhq1NzM9Y0MCcrsAwbmR
ux0gEUfC9wvNDBLp0snB1wL+P7y0ucRJ7oOQLmw6vEog6pD55ziR/HRLkqvtF4wW
0zXobRIdMHdyebdMSCgfkobdmpXqO9AhrtAhumCHA0+aN5FPOt29YSmjdnNgMilh
9DFc8IXUf9aEMEf2YcbFWXQuKYOyIFbqF/WHKH22Dy0QM351JocI6qjf25WF7D88
hF1oDJLRHjR/WwvqhpExwDVDucgBKZoEvu52RMzuf9Pvg1mHsQX6XxaymNsW/PQF
H257YObf3rAaJV5bSLFitmcH5DwyiYNxh34x8RWA12po5QzdnQg=
=lOlZ
-----END PGP SIGNATURE-----

--k4r33uam73c6qikk--

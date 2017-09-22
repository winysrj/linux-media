Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:39359 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbdIVPai (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 11:30:38 -0400
Date: Fri, 22 Sep 2017 17:30:36 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com
Subject: Re: [PATCH 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20170922153036.u7k3wmuldphkk6w3@flea.lan>
References: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
 <20170922114703.30511-3-maxime.ripard@free-electrons.com>
 <20170922123849.hcm76tlplnvd44mt@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="j4nwboesqc6za5ms"
Content-Disposition: inline
In-Reply-To: <20170922123849.hcm76tlplnvd44mt@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--j4nwboesqc6za5ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

I'll address the minor comments you had and that I stripped.

On Fri, Sep 22, 2017 at 12:38:49PM +0000, Sakari Ailus wrote:
> > +	/*
> > +	 * Create a static mapping between the CSI virtual channels
> > +	 * and the input streams.
>=20
> Which virtual channel is used here?

Like I was trying to explain in the cover letter, the virtual channel
is not under that block's control. The input video interfaces have an
additional signal that comes from the upstream device which sets the
virtual channel.

It's transparent to the CSI2-TX block, even though it's
there. Depending on the implementation, it can be either fixed or can
change, it's up to the other block's designer. The only restriction is
that it cannot change while a streaming is occuring.

> > +
> > +		/*
> > +		 * If no-one set a format, we consider this pad
> > +		 * disabled and just skip it.
> > +		 */
> > +		if (!fmt)
>=20
> The pad should have a valid format even if the user didn't configure
> it.

Which format should be by default then?

> Instead you should use the link state to determine whether the link is
> active or not.

Ok, will do.

> > +			continue;
> > +
> > +		/*
> > +		 * We use the stream ID there, but it's wrong.
> > +		 *
> > +		 * A stream could very well send a data type that is
> > +		 * not equal to its stream ID. We need to find a
> > +		 * proper way to address it.
>=20
> Stream IDs will presumably be used in V4L2 for a different purpose. Does
> the hardware documentation call them such?

Input video interfaces are called streams, yes, and then they are
numbered. If it's just confusing because of a collision with one of
v4l2's nomenclature, I'm totally fine to change it to some other name.

> > +		 */
> > +		writel(CSI2TX_DT_CFG_DT(fmt->dt),
> > +		       csi2tx->base + CSI2TX_DT_CFG_REG(stream));
> > +
> > +		writel(CSI2TX_DT_FORMAT_BYTES_PER_LINE(mfmt->width * fmt->bpp) |
> > +		       CSI2TX_DT_FORMAT_MAX_LINE_NUM(mfmt->height + 1),
> > +		       csi2tx->base + CSI2TX_DT_FORMAT_REG(stream));
> > +
> > +		/*
> > +		 * TODO: This needs to be calculated based on the
> > +		 * clock rate.
>=20
> Clock rate of what? Input?

Of the CSI2 link, so output. I guess I should make that clearer.

>=20
> > +		 */
> > +		writel(CSI2TX_STREAM_IF_CFG_FILL_LEVEL(4),
> > +		       csi2tx->base + CSI2TX_STREAM_IF_CFG_REG(stream));
> > +	}
> > +
> > +	/* Disable the configuration mode */
> > +	writel(0, csi2tx->base + CSI2TX_CONFIG_REG);
>=20
> Shouldn't you start streaming on the downstream sub-device as well?

I appreciate it's a pretty weak argument, but the current setup we
have is in the FPGA is:

capture <- CSI2-RX <- CSI2-TX <- pattern generator

So far, the CSI2-RX block is calling its remote sub-device, which is
CSI2-TX. If CSI2-RX is calling its remote sub-device (CSI2-RX), we
just found ourselves in an endless loop.

I guess it should be easier, and fixable, when we'll have an actual
device without such a loopback.

> > +
> > +	return 0;
> > +}
> > +
> > +static int csi2tx_stop(struct csi2tx_priv *csi2tx)
> > +{
> > +	/*
> > +	 * Let the last user turn off the lights
> > +	 */
> > +	if (!atomic_dec_and_test(&csi2tx->count))
> > +		return 0;
> > +
> > +	/* FIXME: Disable the IP here */
>=20
> Shouldn't this be addressed?

Yes, but it's still unclear how at the moment. It will of course
eventually be implemented.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--j4nwboesqc6za5ms
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZxSycAAoJEBx+YmzsjxAgOuQQAJ+HiKCfbcJW0MqJTTWaloFQ
pkysA81rSEvnPkeAPp5DuxqNbbyF7y3BVV2ahqkmZKcpqsh0f0L3k/LMA2G9PttF
HGuPz3HHCGmub1Y1VRTZG4DjAPZihqcO5Lap0LM30YXFr/gIDt9dc/jCXMWtHWxA
i56V2pfYAY89XYzIcCFFVJ3QNW59N/PmC3NF7qYY4xFci3I784Bh2fo0rQn6R4t8
GjVlhfC9+sBshCkM4aU9DHPu8E+E3vaUf7yiwNVzLemnv86sfnqRAuWsnsdtWqp9
uTiSNpy3eFaiQMCz703/yEADfIYB/4x9nQeHt9poNqjlIAxOE90SJvwNA6LfN9da
X+kDAYMcKfT0LvbDhRmSfV6uJIcFoVUTFIUvzntHUKOxAueYdet3KZtOWbV+Bymx
1c9Hw8Bvf7yJ1udoTjclgA/uHPqVq8GAIj2nGaA3KdOeoWW3Hh+nJss5nbKpmAbQ
tpjlBNp46udfFi0sGgHtQablc7fHt9TOcTaHRv8JtCSB39QKPDxA2Zlw//tsz/0/
7kfLvclQfiY/cpcjvA/vDRlENF5LbH+kFSIsecuVcNZW+g1AqwXrK+rym18WHFJA
8hcFpVgink355To3pKFl696bY5nRAjaozimB8PF44aGkWCgnk5rdluk0RNARNnh4
y31H5cQzoxAk6Wzdtfv/
=xvqG
-----END PGP SIGNATURE-----

--j4nwboesqc6za5ms--

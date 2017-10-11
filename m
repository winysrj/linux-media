Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52955 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbdJKJrf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 05:47:35 -0400
Date: Wed, 11 Oct 2017 11:47:21 +0200
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
Message-ID: <20171011094721.hwbsk736ncx5wstt@flea.lan>
References: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
 <20170922114703.30511-3-maxime.ripard@free-electrons.com>
 <20170922123849.hcm76tlplnvd44mt@valkosipuli.retiisi.org.uk>
 <20170922153036.u7k3wmuldphkk6w3@flea.lan>
 <20170926080014.7a3lbe23rvzpcmkq@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="br4mtgjntl4dx72l"
Content-Disposition: inline
In-Reply-To: <20170926080014.7a3lbe23rvzpcmkq@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--br4mtgjntl4dx72l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

Sorry for the belated answer.

On Tue, Sep 26, 2017 at 08:00:14AM +0000, Sakari Ailus wrote:
> > On Fri, Sep 22, 2017 at 12:38:49PM +0000, Sakari Ailus wrote:
> > > > +	/*
> > > > +	 * Create a static mapping between the CSI virtual channels
> > > > +	 * and the input streams.
> > >=20
> > > Which virtual channel is used here?
> >=20
> > Like I was trying to explain in the cover letter, the virtual channel
> > is not under that block's control. The input video interfaces have an
> > additional signal that comes from the upstream device which sets the
> > virtual channel.
>=20
> Oh, I missed while reviewing the set.
>=20
> Presumably either driver would be in control of that then (this one or the
> upstream sub-device).

I don't really see how this driver could be under such control. I
guess it would depend on the integreation, but the upstream (sub-)
device is very likely to be under control of that signal, so I guess
it should be its role to change that. But we should also have that
information available so that the mixing in the CSI link is reported
properly in the media API (looking at Niklas' initial implementation).

> > >=20
> > > > +		 */
> > > > +		writel(CSI2TX_STREAM_IF_CFG_FILL_LEVEL(4),
> > > > +		       csi2tx->base + CSI2TX_STREAM_IF_CFG_REG(stream));
> > > > +	}
> > > > +
> > > > +	/* Disable the configuration mode */
> > > > +	writel(0, csi2tx->base + CSI2TX_CONFIG_REG);
> > >=20
> > > Shouldn't you start streaming on the downstream sub-device as well?
> >=20
> > I appreciate it's a pretty weak argument, but the current setup we
> > have is in the FPGA is:
> >=20
> > capture <- CSI2-RX <- CSI2-TX <- pattern generator
> >=20
> > So far, the CSI2-RX block is calling its remote sub-device, which is
> > CSI2-TX. If CSI2-RX is calling its remote sub-device (CSI2-RX), we
> > just found ourselves in an endless loop.
> >=20
> > I guess it should be easier, and fixable, when we'll have an actual
> > device without such a loopback.
>=20
> What's the intended use case of the device, capture or output?

By device, you mean the CSI2-TX block, or something else?

If CSI2-TX, I guess it's more likely to be for output, but that might
be used for capture as well.

> How do you currently start the pipeline?

The capture device is the v4l2 device, and when the capture starts, it
enables the CSI2-RX which in turn enables CSI2-TX. The pattern
generator is enabled all the time.

> We have a few corner cases in V4L2 for such devices in graph parsing and
> stream control. The parsing of the device's fwnode graph endpoints are wh=
at
> the device can do, but it doesn't know where the parsing should continue
> and which part of the graph is already parsed.
>=20
> That will be addressed but right now a driver just needs to know.

I'm not quite sure I got what you wanted me to fix or change.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--br4mtgjntl4dx72l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZ3eipAAoJEBx+YmzsjxAgvwIP/RTouIM3Qsirj66axjyQevkG
NWcKcYRNgOBHyztFd/0zAcs7eGYtQapollKJo3Bd6+shsfHYIBZcma4zP0K9N+LG
5efgI4/7UjAf4cTXEw1Az4S+dN7UDEULFlhUik+ffNmXbOG1fuhgeWhvMLRyln72
hpOv/FMQMXE5JPUFQB9EYxxVzjNoVqLPZeqfsSTAUYCWz3wm/tRvTvk3kX9tquL9
sf4lZrbDtQf8gvOE75A5+zY61a2+mVXVJdaNuxVAALK+Hr43CLfxXAJglZUQIO41
wc5kofJahhJpVpzuqfI3uV4gkegusYu1jwFLePzHKJCTAwMWzMWMibLCejbd2Q17
sMCRewbuhLmmAPl58bUPyfbML2jD1x9JHpQzowkSh1F+MMkOTvXWKyjvPdyCBHoV
Wbn5AUaem1t/Ti+rm9jxE5nHqZ527n7KdFoBr2yJ1oDnK6TCL3EkyW0vK2bP9iN1
hyDWH/TRoeyFDlIgf8zYSfSCzDiNXyktbGAncFaHoKFwbs3oeVcNlD1QxyZyu4BC
gcLV2JJsGcdL0dNamr8BRCxYRL0JIKM6lUWvd5EhkxXAetK/nm1GNN5KYo0D/kzZ
tC221s66xtMDQKSGZWA9uKe+hJ5khn2GVGtGLvFYwlKRAGn39NxRbo74TvSHvY81
Q5xudEVE4YyXPX5PL1hC
=lJDC
-----END PGP SIGNATURE-----

--br4mtgjntl4dx72l--

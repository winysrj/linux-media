Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:51719 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932205AbdHVIxc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 04:53:32 -0400
Date: Tue, 22 Aug 2017 10:53:20 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 RX
 Device Tree bindings
Message-ID: <20170822085320.pdxbxfv53rb75btu@flea.lan>
References: <20170720092302.2982-1-maxime.ripard@free-electrons.com>
 <20170720092302.2982-2-maxime.ripard@free-electrons.com>
 <2362756.VjbdGaYBzu@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yymmjalaldlbgipk"
Content-Disposition: inline
In-Reply-To: <2362756.VjbdGaYBzu@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yymmjalaldlbgipk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

Thanks a lot for reviewing those patches.

On Mon, Aug 07, 2017 at 11:18:03PM +0300, Laurent Pinchart wrote:
> Hi Maxime,
>=20
> Thank you for the patch.
>=20
> On Thursday 20 Jul 2017 11:23:01 Maxime Ripard wrote:
> > The Cadence MIPI-CSI2 RX controller is a CSI2RX bridge that supports up=
 to
> > 4 CSI-2 lanes, and can route the frames to up to 4 streams, depending on
> > the hardware implementation.
> >=20
> > It can operate with an external D-PHY, an internal one or no D-PHY at a=
ll
> > in some configurations.
>=20
> Without any PHY ? I'm curious, how does that work ?

We're currently working on an FPGA exactly with that configuration. So
I guess the answer would be "it doesn't on an ASIC" :)

> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  .../devicetree/bindings/media/cdns-csi2rx.txt      | 87 ++++++++++++++=
++++
> >  1 file changed, 87 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/cdns-csi2rx=
=2Etxt
> >=20
> > diff --git a/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> > b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt new file mode
> > 100644
> > index 000000000000..e08547abe885
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> > @@ -0,0 +1,87 @@
> > +Cadence MIPI-CSI2 RX controller
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +The Cadence MIPI-CSI2 RX controller is a CSI-2 bridge supporting up to=
 4
> > CSI
> > +lanes in input, and 4 different pixel streams in output.
> > +
> > +Required properties:
> > +  - compatible: must be set to "cdns,csi2rx" and an SoC-specific compa=
tible
> > +  - reg: base address and size of the memory mapped region
> > +  - clocks: phandles to the clocks driving the controller
> > +  - clock-names: must contain:
> > +    * sys_clk: main clock
> > +    * p_clk: register bank clock
> > +    * p_free_clk: free running register bank clock
> > +    * pixel_ifX_clk: pixel stream output clock, one for each stream
> > +                     implemented in hardware, between 0 and 3
>=20
> Nitpicking, I would write the name is pixel_if[0-3]_clk, it took me a few=
=20
> seconds to see that the X was a placeholder.

Ok.

> > +    * dphy_rx_clk: D-PHY byte clock, if implemented in hardware
> > +  - phys: phandle to the external D-PHY
> > +  - phy-names: must contain dphy, if the implementation uses an
> > +               external D-PHY
>=20
> I would move the last two properties in an optional category as they're=
=20
> effectively optional. I think you should also explain a bit more clearly =
that=20
> the phys property must not be present if the phy-names property is not=20
> present.

It's not really optional. The IP has a configuration register that
allows you to see if it's been synthesized with or without a PHY. If
the right bit is set, that property will be mandatory, if not, it's
useless.

Maybe it's just semantics, but to me, optional means that it can
operate with or without it under any circumstances. It's not really
the case here.

> > +
> > +Required subnodes:
> > +  - ports: A ports node with endpoint definitions as defined in
> > +           Documentation/devicetree/bindings/media/video-interfaces.tx=
t.
> > The
> > +           first port subnode should be the input endpoint, the second=
 one
> > the
> > +           outputs
> > +
> > +  The output port should have as many endpoints as stream supported by
> > +  the hardware implementation, between 1 and 4, their ID being the
> > +  stream output number used in the implementation.
>=20
> I don't think that's correct. The IP has four independent outputs, it sho=
uld=20
> have 4 output ports for a total for 5 ports. Multiple endpoints per port =
would=20
> describe multiple connections from the same output to different sinks.

Ok.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--yymmjalaldlbgipk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZm/EAAAoJEBx+YmzsjxAgvyoQAJhMPrD85aLsJAru7hOpMjGd
DRG6UUK6EJ0vkZQlKa654MmvD+hAgi1J4triTaF6y6vGCLkfkJM51JkNgYys0ZL4
3rxiJPLgoCLx9LT+lrxtjrZBSRVrIVd+2NtLIes+OtO9icP3Vfp3p4/T6aVBUw7g
PsN8n23q44+FMRpq1eRanspXMiSQT1LVntabsdQFGYwsnreU0myI3Dz0tFiDvLYN
KuFIMxzTJngQOSIxC8Vmi2R+PfxyqnKhfVBqTG/r9jMCoqkEcB82EuEf+kBPqrT2
ZEM1bcUq5X0V8n1X00Jbih6FeMWjB8RZxI7mkP7H+u0Qzt2MIX8ob4uSwZPJu1RG
4F1RY6/uI7Yat76iDLQnXscMIWlBUcYMwrlhslDmKnL40IFn+Z9mRYRu6wulb2Mj
iVQqc/BVwzx1sObM/A7rAX7omEMLCErkejz/ka3Wu80dxeuK7FQT50jNqv6BNc3i
Eo+Znpl8cUd2INmJK1vUO/2ktE2U6zIKhlOX+uTuQx6uFITOcoB5IDLRgF/LaqmV
vKbvJKJHAJKbdSs0c0fttLczkVE47neq4dNq8seGfqrnCDy5u9868EB2mCr0X6Xi
1Y2+0kEqZSVKqYeVhEGqoj31M5PMEt3dt0SNk/zqJ6Jtv+lZzSmXZq2XyZq6AbyJ
oGD+IxHxsEgmuNE8X9Qt
=4SLW
-----END PGP SIGNATURE-----

--yymmjalaldlbgipk--

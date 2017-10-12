Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:49678 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751932AbdJLNZr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 09:25:47 -0400
Date: Thu, 12 Oct 2017 15:25:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ARM: dts: tegra20: Add video decoder node
Message-ID: <20171012132543.GB4453@ulmo>
References: <cover.1507752381.git.digetx@gmail.com>
 <f58be69f6004393711c9ff3cb4b52aed33e2611a.1507752381.git.digetx@gmail.com>
 <0b6150a7-5b2b-ca4d-eb34-b6614e4833df@mentor.com>
 <81f39096-dc66-c98b-50f6-fc81ee1804ec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <81f39096-dc66-c98b-50f6-fc81ee1804ec@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 12, 2017 at 03:06:17PM +0300, Dmitry Osipenko wrote:
> Hello Vladimir,
>=20
> On 12.10.2017 10:43, Vladimir Zapolskiy wrote:
> > Hello Dmitry,
> >=20
> > On 10/11/2017 11:08 PM, Dmitry Osipenko wrote:
> >> Add a device node for the video decoder engine found on Tegra20.
> >>
> >> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> >> ---
> >>  arch/arm/boot/dts/tegra20.dtsi | 17 +++++++++++++++++
> >>  1 file changed, 17 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra2=
0.dtsi
> >> index 7c85f97f72ea..1b5d54b6c0cb 100644
> >> --- a/arch/arm/boot/dts/tegra20.dtsi
> >> +++ b/arch/arm/boot/dts/tegra20.dtsi
> >> @@ -249,6 +249,23 @@
> >>  		*/
> >>  	};
> >> =20
> >> +	vde@6001a000 {
> >> +		compatible =3D "nvidia,tegra20-vde";
> >> +		reg =3D <0x6001a000 0x3D00    /* VDE registers */
> >> +		       0x40000400 0x3FC00>; /* IRAM region */
> >=20
> > this notation of a used region in IRAM is non-standard and potentially =
it
> > may lead to conflicts for IRAM resource between users.
> >=20
> > My proposal is to add a valid device tree node to describe an IRAM regi=
on
> > firstly, then reserve a subregion in it by using a new "iram" property.
> >=20
>=20
> The defined in DT IRAM region used by VDE isn't exactly correct, actually=
 it
> should be much smaller. I don't know exactly what parts of IRAM VDE uses,=
 for
> now it is just safer to assign the rest of the IRAM region to VDE.
>=20
> I'm not sure whether it really worthy to use a dynamic allocator for a si=
ngle
> static allocation, but maybe it would come handy later.. Stephen / Jon /
> Thierry, what do you think?

This sounds like a good idea. I agree that this currently doesn't seem
to be warranted, but consider what would happen if at some point we have
more devices requiring access to the IRAM. Spreading individual reg
properties all across the DT will make it very difficult to ensure they
don't overlap.

Presumably the mmio-sram driver will check that pool don't overlap. Or
even if it doesn't it will make it a lot easier to verify because it's
all in the same DT node and then consumers only reference it.

I like Vladimir's proposal. I also suspect that Rob may want us to stick
to a standardized way referencing such external memory.

Thierry

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlnfbVQACgkQ3SOs138+
s6FmFw//eCUI+ej3kBZD7m/m/3cwRQX4TiDocDMffTFJGiZU6zpL0cY2g7aMQmrv
9nRYO8rwx9oJ8iWd+XxO73xS8DR/RPWzhGdyOgi3fN9rFSR7BxMW8lFmBoNfeYH1
BKLeBj4Trp41uaI0x8mtvEnRi2D5ibjuu242eidL41hclHBdPkNyTu0K+tMgQ+C2
nFR9Ekyw7w8xTA78pR/1d3q8FM/xIv1EhgMRBIzxeT9gtcwUdHsWI54p6U1v9gPK
fzDDa/g9PrA8lLZrkKzoDMfo4gErUSaJQCgnyMyrBr+CAk5D/AkLh0Gch4qpVbkC
1ihjIXddoxVq1Y+I5Pxt9hvUc1ZgCxzRs8xnN5Sv8TNybi4/ef7sbw65qKclIw86
HBHfV8gZMppaWnoZhdy+JJ5pMjh9JuS6dCiZ34/FNwT9ZST+ZRvqovSlXw75ykmh
pA5wv0EMlPAitO90IFujcpVAzWhxwZz/59STtp9AdZxWms1yDJIGcLNbGOH2G3Uo
hl7EOtj4Jk9llGQ/MDxJr8RkdLxO6XZUVQBhUUlPhMPb5erh83GdDzNRRbKGcx9o
WbM2octIDEI1HD4qGjo+2aqyNxFH5rsYieGEe5LRPfvXBExnI5fFC5+CM/gafg68
Djuk0EOryL9YsMKBXpnEjjelsTGX8Stwb+XikXhaEZEvt4XMzxk=
=4ebh
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--

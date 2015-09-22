Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16525 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747AbbIVMRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 08:17:43 -0400
Date: Tue, 22 Sep 2015 14:17:32 +0200
From: Thierry Reding <treding@nvidia.com>
To: Bryan Wu <pengw@nvidia.com>
CC: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <bmurthyv@nvidia.com>
Subject: Re: [PATCH 2/3] ARM64: add tegra-vi support in T210 device-tree
Message-ID: <20150922121730.GC1417@ulmo.nvidia.com>
References: <1442861755-22743-1-git-send-email-pengw@nvidia.com>
 <1442861755-22743-3-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1442861755-22743-3-git-send-email-pengw@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bryan,

This patchset really needs to be Cc'ed to linux-tegra@vger.kernel.org,
it's becoming impossible to track it otherwise.

On Mon, Sep 21, 2015 at 11:55:54AM -0700, Bryan Wu wrote:
[...]
> diff --git a/arch/arm64/boot/dts/nvidia/tegra210.dtsi b/arch/arm64/boot/d=
ts/nvidia/tegra210.dtsi
> index 1168bcd..3f6501f 100644
> --- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
> +++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
> @@ -109,9 +109,181 @@
> =20
>  		vi@0,54080000 {
>  			compatible =3D "nvidia,tegra210-vi";
> -			reg =3D <0x0 0x54080000 0x0 0x00040000>;
> +			reg =3D <0x0 0x54080000 0x0 0x800>;

This now no longer matches the address map in the TRM.

>  			interrupts =3D <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
>  			status =3D "disabled";
> +			clocks =3D <&tegra_car TEGRA210_CLK_VI>,
> +				 <&tegra_car TEGRA210_CLK_CSI>,
> +				 <&tegra_car TEGRA210_CLK_PLL_C>;
> +			clock-names =3D "vi", "csi", "parent";
> +			resets =3D <&tegra_car 20>;
> +			reset-names =3D "vi";
> +
> +			power-domains =3D <&pmc TEGRA_POWERGATE_VENC>;

As an aside, this will currently prevent the driver from probing because
the generic power domain code will return -EPROBE_DEFER if this property
is encountered but the corresponding driver (for the PMC) hasn't
registered any power domains yet. So until the PMC driver changes have
been merged we can't add these power-domains properties.

That's not something for you to worry about, though. I'll make sure to
strip this out if it happens to get merged before the PMC driver changes
and add it back it afterwards.

> +
> +			iommus =3D <&mc TEGRA_SWGROUP_VI>;
> +
> +			ports {
> +				#address-cells =3D <1>;
> +				#size-cells =3D <0>;
> +
> +				port@0 {
> +					reg =3D <0>;
> +
> +					vi_in0: endpoint {
> +						remote-endpoint =3D <&csi_out0>;
> +					};
> +				};
> +				port@1 {
> +					reg =3D <1>;
> +
> +					vi_in1: endpoint {
> +						remote-endpoint =3D <&csi_out1>;
> +					};
> +				};
> +				port@2 {
> +					reg =3D <2>;
> +
> +					vi_in2: endpoint {
> +						remote-endpoint =3D <&csi_out2>;
> +					};
> +				};
> +				port@3 {
> +					reg =3D <3>;
> +
> +					vi_in3: endpoint {
> +						remote-endpoint =3D <&csi_out3>;
> +					};
> +				};
> +				port@4 {
> +					reg =3D <4>;
> +
> +					vi_in4: endpoint {
> +						remote-endpoint =3D <&csi_out4>;
> +					};
> +				};
> +				port@5 {
> +					reg =3D <5>;
> +
> +					vi_in5: endpoint {
> +						remote-endpoint =3D <&csi_out5>;
> +					};
> +				};
> +
> +			};
> +		};
> +
> +		csi@0,54080838 {

I think this and its siblings should be children of the vi node. They
are within the same memory aperture according to the TRM and the fact
that the VI needs to reference the "CSI" clock indicates that the
coupling is tighter than this current DT layout makes it out to be.

> +			compatible =3D "nvidia,tegra210-csi";
> +			reg =3D <0x0 0x54080838 0x0 0x700>;

Some of the internal register documentation indicates that the register
range actually starts at an offset of 0x800, it just so happens that we
don't use any of the registers from 0x800 to 0x837. So I think this
needs to be adapted.

> +			clocks =3D <&tegra_car TEGRA210_CLK_CILAB>;
> +			clock-names =3D "cil";
> +
> +			ports {
> +				#address-cells =3D <1>;
> +				#size-cells =3D <0>;
> +
> +				port@0 {
> +					reg =3D <0>;
> +					#address-cells =3D <1>;
> +					#size-cells =3D <0>;
> +					csi_in0: endpoint@0 {
> +						reg =3D <0x0>;
> +					};
> +					csi_out0: endpoint@1 {
> +						reg =3D <0x1>;
> +						remote-endpoint =3D <&vi_in0>;
> +					};
> +				};
> +				port@1 {
> +					reg =3D <1>;
> +					#address-cells =3D <1>;
> +					#size-cells =3D <0>;
> +					csi_in1: endpoint@0 {
> +						reg =3D <0>;
> +					};
> +					csi_out1: endpoint@1 {
> +						reg =3D <1>;
> +						remote-endpoint =3D <&vi_in1>;
> +					};
> +				};
> +			};

This, and the ports subnode of the vi node, is *a lot* of lines to
describe what's effectively a hard-coded association. Nothing in here
can be configured, so I doubt that it is necessary to describe the VI
to this extent in DT.

It's quite difficult to judge because we don't have an actual use-case
yet where real sensors need to be hooked up. Do we have some internal
boards that we can use to prototype this from a DT point of view? What
we'd need is just something that has any sensor connected to one of the
CSI ports so we can see what we really need to fully describe such a
setup.

I'm reluctant to apply something like this, or the corresponding
binding, without at least having attempted to describe a real user.

Thierry

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWAUbYAAoJEN0jrNd/PrOhy5kQAJ+/o6D/FPHWxzZAqUFrdQAz
UL3+DF3Q8YBOJCl7w68Re3tv7A428WvGWPWKHSCo30/7/itzDrxAllEpWCJEdSgE
c9fiSxCgdCc7GX1T5UvNFgyqpEFjCMDMb/zgr118s4sNH58AeaosJu/QtBNEfIS3
kFzWsQW75/3ks2qilrm5MgAv7b07l78fU6cuZxVdzF2zxllT8jF7Ihpd1bsIyTm8
i8LTKxTX/VzkZ7w2DA0Q/egSDQiEpCKea3zbxNd5cUv1jy8v/+ZgYgR4c031jEh7
WBz+GMb8BK3eAX5DpMu3Jf0eLT5hgS4xDdJRImUwj0bxfb84jC+hwTQLl+CaFUUE
lEhW0v4+tFro/tk4pRXPuUH1BnBmIKmLRzqbdgwaksqgPY0GDpR1x7dddc7czwOx
S6sPZAoRtBzR7MpjbNyCe4wVwV1tO9BRM7oZ0yEFvN8AtRN5TRjuEA+Qu/+rFku/
P+DIt4pQNqdTsCj7ra6l7KGU05rcHp7topf12skW+tG4lbzJPPHf2HTYyfT7cqR+
rInMsqSapoCIPXujbY1ixs118aQBKpVtondz1hSdOkoq4KpzW3HVk7SwI9UIEvQ9
WVueZfT9Pv81js5eqaIA6Pj8OypzUKWPiRaWlIA7XMPowiUVIjQXffZwQu+bV6Up
lLzq6H7HI1q14nTz3LQ9
=dNdf
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--

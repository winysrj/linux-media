Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4246 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbbHYOZi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 10:25:38 -0400
Date: Tue, 25 Aug 2015 16:24:12 +0200
From: Thierry Reding <treding@nvidia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Bryan Wu <pengw@nvidia.com>, <hansverk@cisco.com>,
	<linux-media@vger.kernel.org>, <ebrower@nvidia.com>,
	<jbang@nvidia.com>, <swarren@nvidia.com>, <wenjiaz@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] v4l: tegra: Add NVIDIA Tegra VI driver
Message-ID: <20150825142411.GC3820@ulmo.nvidia.com>
References: <1440118300-32491-1-git-send-email-pengw@nvidia.com>
 <1440118300-32491-5-git-send-email-pengw@nvidia.com>
 <20150821130339.GB22118@ulmo.nvidia.com>
 <55DBB62C.4020606@nvidia.com>
 <20150825134444.GH14034@ulmo.nvidia.com>
 <55DC789E.8060300@xs4all.nl>
MIME-Version: 1.0
In-Reply-To: <55DC789E.8060300@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2015 at 04:15:58PM +0200, Hans Verkuil wrote:
> On 08/25/15 15:44, Thierry Reding wrote:
> > On Mon, Aug 24, 2015 at 05:26:20PM -0700, Bryan Wu wrote:
[...]
> > > For CMA we need increase the default memory size.
> >=20
> > I'd rather not rely on CMA at all, especially since we do have a way
> > around it.
>=20
> For the record, I have no problem with it if we start out with contiguous
> DMA now and enhance it later. I get the impression that getting the IOMMU
> to work is non-trivial, and I don't think it should block merging of this
> driver.
>=20
> This is all internal to the driver, so changing it later will not affect
> userspace.

Fair enough.

Thierry

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJV3HqLAAoJEN0jrNd/PrOhiqsQAIhhwBr8ew/LBF9al4LCzHRl
d6YnBmGc/UXYfUMLbuJUitwfQK5n9luWjh88ypMoRHo6Gz1mSHOr7cs2Zz0gwUFo
yTsmXW22lkAKUOHugZZmqSzBzeN4jmPUJtDvhNiHJQxfwmJdmKwcz0eHScdqKwZt
EUyyVctjfU3sewl4NSbx0/ou95LkZPFZppEi7tbbrOYwgX+qjqlXuj4H5BZut91L
uaDQylbmvPlFO0s4JW1uVXskQLA38dQwXEtmeJhTrt6AS2YAYlZazdsGRQaO/s7M
sV7E7iS/KNphTfyH+rZUrEhwD1CQehDs74FcTcojRUsRyq+O02Fwxj3iDzpAnqEf
A6O3PVRHXy0Ek75nmF25pDqNBbWwQNDeDUfg6C6rOiNX4m0M1dwGxXzBmyJExtEJ
qlD0ybaxfCvaZZwslNQ+ySnaPpuUlA0MRfeUkDD2xIMDYZ0kDk9DmqnjlpRlzE9Y
AbudEyaIsdlt1OB3/0MdGhmC3ZKLEdq6Kh7ARE6sqBV25e3zGQ+Oe8KprF0+qi61
zKYFtUN9eenqODurgP9SxtVxpRol+enrSd3Bw+TIrJSgfxOeEBc+F5HxL/grXFu/
n2pz4XW2v5U0XjAcgtFiPnETM08iDNvP5rQm5LTnOldi7HtXNbQoOlnE7KnUl5wV
qjXiZjEdOte9Q386Pucc
=xv2t
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([91.143.88.219]:41654 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbaAIVbH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jan 2014 16:31:07 -0500
Date: Thu, 9 Jan 2014 22:30:59 +0100
From: Sebastian Reichel <sre@debian.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: florian.vaussard@epfl.ch, Enrico <ebutera@users.berlios.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp device tree support
Message-ID: <20140109213058.GA9820@earth.universe>
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
 <5728278.SyrhtX3J9t@avalon>
 <52CF0612.2020303@epfl.ch>
 <4572159.CqBuj6p70x@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <4572159.CqBuj6p70x@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 09, 2014 at 09:49:09PM +0100, Laurent Pinchart wrote:
> > > You can find my work-in-progress branch at
> > >=20
> > > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3i=
sp/dt
> > >=20
> > > (the last three patches are definitely not complete yet).
> >=20
> > Great news! A while ago, Sebastian Reichel (in CC) posted an RFC for the
> > binding [2]. Are you working with him on this?
>=20
> No, I've replied to Sebastian's patch but haven't received any answer. My=
 main=20
> concern is that the proposal didn't use the V4L2 DT bindings to describe =
the=20
> pipeline.

ah sorry I thought I replied to this mail. I acknowledge all
concerns, which I received in the reply. I have not yet found
time to continue on DT for omap3isp.

P.S.: I will continue this when I find time, but I definitely don't
feel offended if somebody else wants to continue ;)

-- Sebastian

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSzxUSAAoJENju1/PIO/qaRoMP+gPRY6ievLfrHUdC0ri4aFlE
VvT4oAQ5JBTj6Mi4PBCmzf8H0iWXvf+WDDmfK0s5emv0s0Iz/G/RD9ecHoNmyk/Z
CFiulgnDBsqOssHWwvKOS9tSuHYYOQsj5dh/8B09LvGPlG8lAij1M3prTS1odInt
DSSZ9hn646ldp8Gij6lx3FYqdLF60x1ZtG8I4frblfBDKvzFTWzHVhaEMr1Ldovn
H1OibgJ0kX+l9KAwB4VRIG18DsUsOADQHANd+wpvTHKzRt7vn2r3vUjvFEyyZRXp
FgE7W8FhYHlxE2atHaHXLYEu95hIWtWluHSS8cfc8z8IJvbl0B2aY98m5npinNtB
EbixM1orbiXKjUUfaT8uj1IpDAo2f8Tmwg5A9N9NI05t7Hm3876Ds3ViDL4JK4rd
BfjAg8Xsec27zlKpzvV8fh1PvinhTiqPTz1g/bj6epGJmEK/HijoQ9QS7bsuyxu/
DcM6NNx5qfHZuY/UMNjwqEdMhsIDLkqQFi/SJiiawRq2vxNt72pqMVfrHWDZsVbT
zskYglTEIIrZyh+Z+ZI9FGatkv/vz+O555nbIOh35MHfMjj0lyTYTbEDl2vonjz3
QbuZI2tcIRcSP/wSF7HRvFB/hjf3sgw+j42ECtdyz/E0t/xxVFezdVgj6mR45n+p
Gydh70DOVcmuwF/qkX93
=tpQe
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--

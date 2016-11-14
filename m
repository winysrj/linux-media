Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60216 "EHLO
        mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbcKNNqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 08:46:50 -0500
Date: Mon, 14 Nov 2016 13:46:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Todor Tomov <todor.tomov@linaro.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
Message-ID: <20161114134633.5liin7u5wjy4kdpy@sirena.org.uk>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
 <5810931B.4070101@linaro.org>
 <20161026115149.GD17252@sirena.org.uk>
 <7012441.uVkdQjEznh@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zlkdxsyvo62rmu7r"
Content-Disposition: inline
In-Reply-To: <7012441.uVkdQjEznh@avalon>
Subject: Re: [PATCH v6 2/2] media: Add a driver for the ov5645 camera sensor.
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zlkdxsyvo62rmu7r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2016 at 02:18:49PM +0200, Laurent Pinchart wrote:
> On Wednesday 26 Oct 2016 12:51:49 Mark Brown wrote:

> > Why would this be guaranteed by the API given that it's not documented
> > and why would many drivers break?  It's fairly rare for devices other
> > than SoCs to have strict power on sequencing requirements as it is hard
> > to achieve in practical systems.

> Is there a reason why the API shouldn't guarantee that regulators are pow=
ered=20
> on in the order listed, and powered off in the reverse order ? Looking at=
 the=20

If it ever even did that through implementation it's not been true for a
very long time - it does the regulator enables in parallel in order to
reduce the overall time to power things up.  I keep wanting to come up
with code to figure out if we're using multiple enable bits in a single
register and hit them all at once though it's likely to be more trouble
than it's worth.

> implementation that's already the case for regulator_bulk_disable(), but=
=20
> regulator_bulk_enable() uses async scheduling so doesn't guarantee orderi=
ng. I=20
> wonder whether a synchronous version of regulator_bulk_enable() would be=
=20
> useful.

*Possibly* but I'd be surprised to learn that there's a substantial
amount of hardware out there that cares given that a power on reset
circuit isn't exactly complex to implement.  You do sometimes see a
global rail that should come up first (especially if there is an
integrated regulator) but I've not seen many cases where the hardware
cared outside of SoCs.

--zlkdxsyvo62rmu7r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAABCAAGBQJYKcA4AAoJECTWi3JdVIfQHR8H/2FMgt8AV685eNXIbMLOUxFl
7Bo6pQie6rEkf1fJYk6jTjJRrv2zt91DH/W8tL/eA0HpVWbLDDe/vBo+kRcv8xLc
MDnyEvCVhyQQsCGOOVw+tGBUNLJuMxzooe38cLC/FNS4q+ZxIt7ho00+JuZnJ4Ar
gdYdFgyLg9seFoykSQ2u6fVc1s7k69h+YRQhH0ue/+lXfAXjM2JFOZardmF60+5D
3lIecw4OssquN0Th/8AkZcBkT3mFyFlyRVjyMt4ux1PL8O5yTP1tUb+r832z7436
dd73I/vN0peGYXxzBJmmouqs/k8dFFZ4uw/xB4oiWOH+W7J1zPiRxv6afQBNbFw=
=MXvV
-----END PGP SIGNATURE-----

--zlkdxsyvo62rmu7r--

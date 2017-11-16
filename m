Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:41017 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934802AbdKPMxN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 07:53:13 -0500
Date: Thu, 16 Nov 2017 13:53:10 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Giulio Benetti <giulio.benetti@micronovasrl.com>
Cc: Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        thomas@vitsch.nl, linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171116125310.yavjs7352nw2sm7r@flea>
References: <1510059543-7064-1-git-send-email-giulio.benetti@micronovasrl.com>
 <1b12fa21-bfe6-9ba7-ae1d-8131ac6f4668@micronovasrl.com>
 <6fcdc0d9-d0f8-785a-bb00-b1b41c684e59@imkreisrum.de>
 <693e8786-af83-9d77-0fd4-50fa1f6a135f@micronovasrl.com>
 <20171116110204.poakahqjz4sj7pmu@flea>
 <5fcf64db-c654-37d0-5863-20379c04f99c@micronovasrl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tf5l7i4srtoaupbd"
Content-Disposition: inline
In-Reply-To: <5fcf64db-c654-37d0-5863-20379c04f99c@micronovasrl.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tf5l7i4srtoaupbd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 16, 2017 at 01:30:52PM +0100, Giulio Benetti wrote:
> > On Thu, Nov 16, 2017 at 11:37:30AM +0100, Giulio Benetti wrote:
> > > Il 16/11/2017 11:31, Andreas Baierl ha scritto:
> > > > Am 16.11.2017 um 11:13 schrieb Giulio Benetti:
> > > > > Hello,
> > > > >=20
> > > > Hello,
> > > > > I'm wondering why cedrus
> > > > > https://github.com/FlorentRevest/linux-sunxi-cedrus has never been
> > > > > merged with linux-sunxi sunxi-next.
> > > > >=20
> > > > Because it is not ready to be merged. It depends on the v4l2 request
> > > > API, which was not merged and which is re-worked atm.
> > > > Also, sunxi-cedrus itself is not in a finished state and is not as
> > > > feature-complete to be merged. Anyway it might be something for
> > > > staging... Has there been a [RFC] on the mailing list at all?
> > >=20
> > > Where can I find a list of TODOs to get it ready to be merged?
> >=20
> > Assuming that the request API is in, we'd need to:
> >    - Finish the MPEG4 support
> >    - Work on more useful codecs (H264 comes to my mind)
> >    - Implement the DRM planes support for the custom frame format
> >    - Implement the DRM planes support for scaling
> >    - Test it on more SoCs
> >=20
> > Or something along those lines.
>=20
> Lot of work to do

Well... If it was fast and easy it would have been done already :)

> > > > > I see it seems to be dead, no commit in 1 year.
> > > >=20
> > > > Yes, because the author did this during an internship, which ended =
=2E..
> > > > Afaik nobody picked up his work yet.
> >=20
> > That's not entirely true. Some work has been done by Thomas (in CC),
> > especially on the display engine side, but last time we talked his
> > work was not really upstreamable.
> >=20
> > We will also resume that effort starting next march.
>=20
> Is it possible a preview on a separate Reporitory to start working on now?
> Expecially to start porting everything done by FlorentRevest to mainline,
> admitted you've not already done.

I'm not sure what you're asking for. Florent's work *was* on mainline.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--tf5l7i4srtoaupbd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJaDYo2AAoJEBx+YmzsjxAgTusQAJWuy3WmddWpDU14I2f2He8z
Lk1aYzZZP1/yupDqWm7rCwwQZfokFOuK/Z/NY9qzU+4ucCbO36XeTYL6D27V0Xy8
v/Ww+hsk3F6iRPZV88CAvfKhSAa44Ns+9KFyFgGlLrADHgxf5eFK4aTsbwFoL+1B
gOOmv+PqHftfRyS6up1quzvAlhlCzhk4KTTgvVsDXXlITrwQQYLpQSQ+iPJe6n2p
5th9IrZ+ivy//mWNcldq4MGHlgxvj+d3i5GgLjayqspSqZp7g+ISTSprQpH8j/xf
zg9ZsKlJkY0PYMiYkpwPveOVjf6gREQNRFOKDXpq+byCyxm1xO6qzm72yW0edyVm
ShGuTY5qzvdcR/Irc5xwIhywXrh4pDG5d8/WtavAvzCf960aboCiwMMUNuRNGwq0
wdtWUUuf+3NFpYJsmuDiqQrC87H6x7oCeMI+Qapxn0k6mUDw0AGDVcOdemVJrrXt
bICRDq7VGJlaMvk0Q0CXkMi/13LTECWYkll78GdrmWE/+2Z9t82o+ZzOs3PFGcrj
E3fOR1Q8x5nyDpt8/iHCcxXsYLeQ0WutpHW/EmKWYkagw81ai/Lofu8+N8AGm418
wJOqIfVK258P1EpCo0JlluMVbLTTDOggg38LjeygHKI1caAL30i3dVBGkhfdBF3l
JtsIkBtiymC0dfkiJy9T
=jDRX
-----END PGP SIGNATURE-----

--tf5l7i4srtoaupbd--

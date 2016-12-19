Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44247 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbcLSWXy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 17:23:54 -0500
Date: Mon, 19 Dec 2016 23:23:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Tony Lindgren <tony@atomide.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Message-ID: <20161219201015.GB4974@amd>
References: <20160521054336.GA27123@amd>
 <20160808080955.GA3182@valkosipuli.retiisi.org.uk>
 <20160808214132.GB2946@xo-6d-61-c0.localdomain>
 <201612141438.16603@pali>
 <20161214150819.GW4920@atomide.com>
 <20161215065022.GC16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <20161215065022.GC16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Hi Pali and Tony,
> On Wed, Dec 14, 2016 at 07:08:19AM -0800, Tony Lindgren wrote:
> > * Pali Roh=E1r <pali.rohar@gmail.com> [161214 05:38]:
> > > On Monday 08 August 2016 23:41:32 Pavel Machek wrote:
> > > > On Mon 2016-08-08 11:09:56, Sakari Ailus wrote:
> > > > > On Fri, Aug 05, 2016 at 12:26:11PM +0200, Pavel Machek wrote:
> > > > > > This adds support for AD5820 autofocus coil, found for example =
in
> > > > > > Nokia N900 smartphone.
> > > > >=20
> > > > > Thanks, Pavel!
> > > > >=20
> > > > > Let's use V4L2_CID_FOCUS_ABSOLUTE, as is in the patch. If we get
> > > > > something better in the future, we'll switch to that then.
> > > > >=20
> > > > > I've applied this to ad5820 branch in my tree.
> > > >=20
> > > > Thanks. If I understands things correctly, both DTS patch and this
> > > > patch are waiting in your tree, so we should be good to go for 4.9
> > > > (unless some unexpected problems surface)?
> > > >=20
> > > > Best regards,
> > > > 									Pavel
> > >=20
> > > Was DTS patch merged into 4.9? At least I do not see updated that dts=
=20
> > > file omap3-n900.dts in linus tree...
> >=20
> > If it's not in current mainline or next, it's off my radar so sounds
> > like I've somehow missed it and needs resending..
>=20
> Where's this patch? I remember seeing the driver patch and the DT
> documentation but no actual DT source patch for the N900.

The patch was not yet submitted. Autofocus coil is not too useful
withou camera support, and we don't yet have support for v4l subdevs
for omap3. I have it in the camera tree, but there are still pieces to
be done before this is useful.

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhYXfYACgkQMOfwapXb+vLADQCfein6AqiDmRvoFpBDk1TlLiZp
d6cAn2EiP64csq+pU1S0esCmqpMokMkk
=O+TD
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--

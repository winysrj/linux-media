Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55772 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbdCDTpC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 14:45:02 -0500
Date: Sat, 4 Mar 2017 20:44:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [media] omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for
 CCP2 mode
Message-ID: <20170304194458.GC31766@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170301114545.GA19201@amd>
 <20170304151533.GY3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <20170304151533.GY3220@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2017-03-04 17:15:34, Sakari Ailus wrote:
> On Wed, Mar 01, 2017 at 12:45:46PM +0100, Pavel Machek wrote:
> > ISP CSI1 module needs all the bits correctly set to work.
> >=20
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >=20
>=20
> How are you sending the patches?

manually using mutt, for series I do something with git. Hmm. And
script I was using for that disappeared :-(.

> I've applied this to the ccp2 branch.

Thanks,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli7GToACgkQMOfwapXb+vITngCfZeiOMl4x3fVIEMKwQkF17plM
wigAn1/5EwntuxM3pv3MA+1CF1jxU160
=WkF5
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--

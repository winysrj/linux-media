Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:33687 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755947AbcLNNiU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 08:38:20 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Date: Wed, 14 Dec 2016 14:38:16 +0100
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com
References: <20160521054336.GA27123@amd> <20160808080955.GA3182@valkosipuli.retiisi.org.uk> <20160808214132.GB2946@xo-6d-61-c0.localdomain>
In-Reply-To: <20160808214132.GB2946@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10515048.Sx2z73bDR8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201612141438.16603@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart10515048.Sx2z73bDR8
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 08 August 2016 23:41:32 Pavel Machek wrote:
> On Mon 2016-08-08 11:09:56, Sakari Ailus wrote:
> > On Fri, Aug 05, 2016 at 12:26:11PM +0200, Pavel Machek wrote:
> > > This adds support for AD5820 autofocus coil, found for example in
> > > Nokia N900 smartphone.
> >=20
> > Thanks, Pavel!
> >=20
> > Let's use V4L2_CID_FOCUS_ABSOLUTE, as is in the patch. If we get
> > something better in the future, we'll switch to that then.
> >=20
> > I've applied this to ad5820 branch in my tree.
>=20
> Thanks. If I understands things correctly, both DTS patch and this
> patch are waiting in your tree, so we should be good to go for 4.9
> (unless some unexpected problems surface)?
>=20
> Best regards,
> 									Pavel

Was DTS patch merged into 4.9? At least I do not see updated that dts=20
file omap3-n900.dts in linus tree...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart10515048.Sx2z73bDR8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlhRS0gACgkQi/DJPQPkQ1JOtQCdGXAdWUqISBq7Q0e1gxvqlon6
YEsAniEM+sTNeHnA7ZzMnYfr2LPCBqQk
=Igeg
-----END PGP SIGNATURE-----

--nextPart10515048.Sx2z73bDR8--

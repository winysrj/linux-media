Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753138AbdBDBEP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Feb 2017 20:04:15 -0500
Date: Sat, 4 Feb 2017 02:04:06 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, ivo.g.dimitrov.75@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170204010406.piycm675bm7r6vv6@earth>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170203133219.GD26759@pali>
 <20170203210728.GB18379@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wwo6u4ofpcf75nb4"
Content-Disposition: inline
In-Reply-To: <20170203210728.GB18379@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wwo6u4ofpcf75nb4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 03, 2017 at 10:07:28PM +0100, Pavel Machek wrote:
> On Fri 2017-02-03 14:32:19, Pali Roh=E1r wrote:
> > On Friday 03 February 2017 13:35:08 Pavel Machek wrote:
> > > N900 contains front and back camera, with a switch between the
> > > two. This adds support for the switch component, and it is now
> > > possible to select between front and back cameras during runtime.
> >=20
> > IIRC for controlling cameras on N900 there are two GPIOs. Should
> > not you have both in switch driver?
>
> I guess you recall wrongly :-). Switch seems to work. The issue was
> with switch GPIO also serving as reset GPIO for one sensor, or
> something like that, if _I_ recall correctly ;-).

I have a schematic in my master thesis, which shows how the camera
sensors are connected to the SoC. The PDF is available here:

https://www.uni-oldenburg.de/fileadmin/user_upload/informatik/ag/svs/downlo=
ad/thesis/Reichel_Sebastian.pdf

The schematic is on page 37 (or 45 if your PDF reader does not
use different numbers for the preamble stuff).

--Sebastian

--wwo6u4ofpcf75nb4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAliVKIMACgkQ2O7X88g7
+pqQhA/+MvS+RlBq5lSlWktwYMY6QAuIMzNUgR+1iWcPQPuvnTBIV5Aq4RmKGxQ4
PlK1ToFJcF942ZTAKh+LV9JzMi199diZq+m59s07cVXDshKajLU0/UImDbZkDm2+
/t1Bw+r3jKnInzgWzFEusJXUoRZ47TDw8HBY9t1CkplGf5pNl+s0jJ96wR72ddmN
K0EGvamtelyzr9iYqQpolCp39TVyr5+ewCF2jipP5dBS8rOiQks4QIRpHQ6TjoaK
2q15y4/WCdRHyY0Jc22d38TzeKSbFLsDbnRDEN/s3ll2kyYyU2X9kAfm/V2WGOaW
xs0qWPrpPsisjlJWAQ7k85ocbep7FABt+m/LdBkoy2s/b+LdQ2DvuR/2VHc0brNq
MXOgqwPixU4QTHFmlriBtfBcqTXXtJRYJxMNh89AmjNOIstjPvDQubs6IJ3RMbyD
iss3CRWOLHusUsHmSWRVXql8OaTB6Wuvw/pLLEfDNYtBs4VFBGWd0Kmp0OChmU28
l+SlALxtXpDmbtW4+ku2pRZHrim904mxgAm3R9YqDrdc1/Fu/Eztp3CbbC6hRGV1
xMNjT3kE4MUakFS5w6Up4cZwzr+Fws4piaf8f7Npm92LTqFyl1O9oV7fnPU3ol5w
Rk9bciU3EJP3yltb6ff4V25l63lS4evfVXYvZ3Zcm+xkqYx/75I=
=Z4E1
-----END PGP SIGNATURE-----

--wwo6u4ofpcf75nb4--

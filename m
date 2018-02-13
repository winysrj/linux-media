Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43608 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965676AbeBMU7G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 15:59:06 -0500
Date: Tue, 13 Feb 2018 21:59:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH v2 8/8] platform: vivid-cec: use 64-bit arithmetic
 instead of 32-bit
Message-ID: <20180213205900.GB6185@amd>
References: <cover.1517856716.git.gustavo@embeddedor.com>
 <cca3c728f123d714dc8e4ed87510aeb2e2d63db6.1517856716.git.gustavo@embeddedor.com>
 <dc931d9d-8cbd-bbd2-0199-b1846e41f274@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <dc931d9d-8cbd-bbd2-0199-b1846e41f274@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2018-02-05 22:29:41, Hans Verkuil wrote:
> On 02/05/2018 09:36 PM, Gustavo A. R. Silva wrote:
> > Add suffix ULL to constant 10 in order to give the compiler complete
> > information about the proper arithmetic to use. Notice that this
> > constant is used in a context that expects an expression of type
> > u64 (64 bits, unsigned).
> >=20
> > The expression len * 10 * CEC_TIM_DATA_BIT_TOTAL is currently being
> > evaluated using 32-bit arithmetic.
> >=20
> > Also, remove unnecessary parentheses and add a code comment to make it
> > clear what is the reason of the code change.
> >=20
> > Addresses-Coverity-ID: 1454996
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > ---
> > Changes in v2:
> >  - Update subject and changelog to better reflect the proposed code cha=
nges.
> >  - Add suffix ULL to constant instead of casting a variable.
> >  - Remove unncessary parentheses.
>=20
> unncessary -> unnecessary
>=20
> >  - Add code comment.
> >=20
> >  drivers/media/platform/vivid/vivid-cec.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/p=
latform/vivid/vivid-cec.c
> > index b55d278..614787b 100644
> > --- a/drivers/media/platform/vivid/vivid-cec.c
> > +++ b/drivers/media/platform/vivid/vivid-cec.c
> > @@ -82,8 +82,15 @@ static void vivid_cec_pin_adap_events(struct cec_ada=
pter *adap, ktime_t ts,
> > =20
> >  	if (adap =3D=3D NULL)
> >  		return;
> > -	ts =3D ktime_sub_us(ts, (CEC_TIM_START_BIT_TOTAL +
> > -			       len * 10 * CEC_TIM_DATA_BIT_TOTAL));
> > +
> > +	/*
> > +	 * Suffix ULL on constant 10 makes the expression
> > +	 * CEC_TIM_START_BIT_TOTAL + 10ULL * len * CEC_TIM_DATA_BIT_TOTAL
> > +	 * be evaluated using 64-bit unsigned arithmetic (u64), which
> > +	 * is what ktime_sub_us expects as second argument.
> > +	 */
>=20
> That's not really the comment that I was looking for. It still doesn't
> explain *why* this is needed at all. How about something like this:
>=20
> /*
>  * Add the ULL suffix to the constant 10 to work around a false Coverity
>  * "Unintentional integer overflow" warning. Coverity isn't smart enough
>  * to understand that len is always <=3D 16, so there is no chance of an
>  * integer overflow.
>  */

Or maybe it would be better to add comment about Coverity having
false-positive and not to modify the code?

Hmm. Could we do something like BUG_ON(len > 16) to make Coverity
understand the ranges?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqDUZQACgkQMOfwapXb+vJPCACffW74HBAdGlWkCS5bplte9NVo
e1wAn3KhUE81CDM5QDwzULA1mkqj9/Wf
=aAcH
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--

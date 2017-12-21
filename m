Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:43404 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754397AbdLUTbx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 14:31:53 -0500
Date: Thu, 21 Dec 2017 19:31:48 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v4 1/3] media: atomisp: convert default struct values to
 use compound-literals with designated initializers.
Message-ID: <20171221193148.GF30316@azazel.net>
References: <20171202213443.GC32301@azazel.net>
 <20171202221201.6063-1-jeremy@azazel.net>
 <20171202221201.6063-2-jeremy@azazel.net>
 <20171219120749.6zqhgfcjqndgbwcp@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0z5c7mBtSy1wdr4F"
Content-Disposition: inline
In-Reply-To: <20171219120749.6zqhgfcjqndgbwcp@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0z5c7mBtSy1wdr4F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2017-12-19, at 14:07:49 +0200, Sakari Ailus wrote:
> On Sat, Dec 02, 2017 at 10:11:59PM +0000, Jeremy Sowden wrote:
> > The CSS API uses a lot of nested anonymous structs defined in object
> > macros to assign default values to its data-structures.  These have
> > been changed to use compound-literals and designated initializers to
> > make them more comprehensible and less fragile.
> >
> > The compound-literals can also be used in assignment, which means we
> > can get rid of some temporary variables whose only purpose is to be
> > initialized by one of these anonymous structs and then serve as the
> > rvalue in an assignment expression.
> >
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
>
> I don't think it's useful to change the struct definition macros only
> to remove a large number of assigned fields in the next patch. How
> about merging the two patches?

I squashed all three, as you suggested.

> Please also start a new thread when re-posting a set.

Done.

J.

--0z5c7mBtSy1wdr4F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEVbDTMOAK4SXP2yyD0czNNmRE1J0FAlo8DCQACgkQ0czNNmRE
1J02eBAAnbAoqvX/k1KQ9AvVQGywnDMoXfFXFilUMvErlzTMHuv+T1S+yltrEmbi
xTkE9VKQIw2fnqW3b3pFC1KAYORrwUyPfCvuoX0BSDUN4uu6QXFnxotXPk8bLd2B
50w2jwrmaTy9YKjy3MdZaiM17nQ3QZ5BIexXF09yBe8mOKoFhGM0jRlJJsYAvPdn
p+By6D5lgWlroSBJZ13PI7xqwhiyx8znDd7Spa8NAbKn3mVDgcTpyNI8YZ7o6zh1
xztshh+lxSOoMjImJJHMVENOgykc03adoWyTy8M8eBZq2Glo8SllI7UnJSFQRU9J
oPA0/e6SO7435sXjTz3QE/MC1mgiq7TJXo/IGiN4sgGltX4JkF50x+FKYUWNIRdb
ByKfUJpXCS9E/hGfDu5u7yZ/eUNcbpMAuqhfBXBs8q3w9OIxf14ohq17qRXFnycy
vykshmoqwiqK4opXEFbMIfYpmYI36Y1vjgtrEb1cbjp54OTiGyZ/39CJ4xYxTf62
TNJa84pnOd4daWyabcPUC8UxFJYr0ODvcqmle8xI7McLNLuoSKxsZmM7H76Jrzm3
sd3hzsa70CCWL2DuQ8B2jNCv8yAcE/WfSFQwYk7ISHa6PXT/hIsnSxVdC4uqAUzz
YZF5pHR3tORI64Yhe5dZDYgrzzejZqiZAOTBgfqR2A3JBnHPtHs=
=yeQX
-----END PGP SIGNATURE-----

--0z5c7mBtSy1wdr4F--

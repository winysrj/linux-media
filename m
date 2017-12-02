Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:48970 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbdLBPAs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 10:00:48 -0500
Date: Sat, 2 Dec 2017 15:00:44 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 2/3] media: atomisp: delete zero-valued struct members.
Message-ID: <20171202150044.GA32301@azazel.net>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
 <20171201171939.3432-1-jeremy@azazel.net>
 <20171201171939.3432-3-jeremy@azazel.net>
 <20171201174150.57f12e5f@alans-desktop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20171201174150.57f12e5f@alans-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2017-12-01, at 17:41:50 +0000, Alan Cox wrote:
> > --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
> > +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
> > @@ -152,14 +152,6 @@ struct ia_css_pipe_config {
> >  };
> >
>
>
> Thani you that's a really good cleanup.

Thanks. :)

J.

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEVbDTMOAK4SXP2yyD0czNNmRE1J0FAloiwBsACgkQ0czNNmRE
1J1pww/+IFIDUSMwzajC3GdfhbyR28nAeZ87jRa7ywF5ORDnkL/fSrMDLX9zJ9HM
4c0guufn3VOKULeJ1uXpKMMdpCL1ikkgdR3Ai7M5JodOYLs2BlCZ3Aa2eB+eCdWb
QyDx5dXjcAxbyqRwheyJ2naY6/4oPCQVAO2EXPMakwadW9ASuC+PFyfF9+MvU/UJ
5qykLXX0zPzSH8pAS+X4YkncvWaUzSr/cwz6N3zbMdusX85018r8Pxd1RdpuVd8x
9unkMrXQS5jMpl3p4QNzEHd4u18ToCapUGLx4Olml686F6ifTFrDbsRojK6i6Qrj
r7/gsDjwun/4xo7SEUtkY8vLWyTJ+tAI7oX+cOKTJ0t1b2GAxh1046JmoEU/s0ua
O0oK5CZ09mSiy2Nmgf8ePKmneeR0mn47B0v4u+ASotf5VS68eYapY4Tc3E7Mt1L6
Ovh7PgYtOlXb4Zo7BvmEa8yJyjsrkZmTGyXN8giTKkC43acblhxrI+8nMY2kG7j8
uOuTCGBDTI6z26Vr5xKZYhmNv9Cm1VAc0R91tsVDvYf6ak14/fxauLV53exVeTcH
auVk2EuLWcJ1Ok0vqAJq35GqsAX3RAY4u6C4ZvEBkYv53ga2kN1Xfp1qhzAh0ANN
mqhDYX3Btyy2rDbh9K144NQkvJdFz+H0Ow3Hpr8WHnf9NWESaMg=
=U6HL
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--

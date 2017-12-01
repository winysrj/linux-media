Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:36094 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdLAPbF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 10:31:05 -0500
Date: Fri, 1 Dec 2017 15:31:00 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/3] media: atomisp: convert default struct values to use
 compound-literals with designated initializers.
Message-ID: <20171201153100.ox4wib36snezydm4@azazel.net>
References: <20171129083835.tam3avqz5vishwqw@azazel.net>
 <20171130214014.31412-1-jeremy@azazel.net>
 <20171130214014.31412-2-jeremy@azazel.net>
 <20171201150725.cfcp6b4bs2ncqsip@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o6f3rgpp2px3mhxo"
Content-Disposition: inline
In-Reply-To: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--o6f3rgpp2px3mhxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2017-12-01, at 18:07:25 +0300, Dan Carpenter wrote:
> I can't apply this (to today's linux-next) but does this really work:
>
> > +(struct ia_css_3a_grid_info) { \
> > +	.ae_enable		= 0, \
> > +	.ae_grd_info		= (struct ae_public_config_grid_config) { \
> > +					width = 0, \
> > +					height = 0, \
> > +					b_width = 0, \
> > +					b_height = 0, \
> > +					x_start = 0, \
> > +					y_start = 0, \
> > +					x_end = 0, \
> > +					y_end = 0 \
>
> I'm pretty sure those lines should start with a period.
>
> - 					width = 0, \
> +					.width = 0, \

Indeed they should.  A second version is in the pipeline.

J.

--o6f3rgpp2px3mhxo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEVbDTMOAK4SXP2yyD0czNNmRE1J0FAlohdawACgkQ0czNNmRE
1J00yw/9EiGin52SfZPWrsk8jOGn2CcguTK+j6m4R6QfAbA+B1UbKrN4bfVeZLjE
Nd4eqOhnsJXxz8SrzbMhNqnzNR7xJvcb2JbzrSxWhPJKF/TXtGsT01w1TYUSgqur
KHa8xkTtm041HgoHE+/ncdX+V2PEwKOtoObGG90f26MmjYvrpCl/3iBNPiryrIf6
DRvT7+6D45TCYfI2UnWnDiyEzzre8MAwWzWugZLTnLWdLYBnR8uEJXwCkIKilwdK
Rma6wyBjDra+cfRa9z+XBAyU4h3VrCHAKak90eRIpRBjJu/sIlkArFUy0HjDQ57D
Op20IcWMPT4zAPJDoSkb7EQz4SFwreHuYhnZU5JdlNZmrPPh95NvvNWf5OfC7kuO
pHRurvJHjwvtFRs+rUyYRwBUHTHkRw53O12ncZUi1irqE9I7hfZrCe74+sPsRWTM
nJJXZ0bYBMxCKG9WRnoW3A0RSmOOWQlX4GwhDCISNqvHLqFoIaMRTbA0Lntu/VRo
8uKtm8lSJ4OecW0FyGdXirgGEC1HAemCLN5p/D+4AnOscRPVGw/cdd15xmDZu/fC
r1Bimryi2dUx5j4PNuCif7xpZrrmZigSSNws0ZJmJEEk6w1Ta12fRP5qzkhCpjiG
4s1Q/y8LJ4CEvjq/vYTvL5NQsj7tzvr3JjUS5OlG1n1YMrBkoFA=
=7j04
-----END PGP SIGNATURE-----

--o6f3rgpp2px3mhxo--

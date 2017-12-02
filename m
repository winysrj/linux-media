Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:60776 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752319AbdLBVer (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 16:34:47 -0500
Date: Sat, 2 Dec 2017 21:34:43 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 1/3] media: atomisp: convert default struct values to
 use compound-literals with designated initializers.
Message-ID: <20171202213443.GC32301@azazel.net>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
 <20171201171939.3432-1-jeremy@azazel.net>
 <20171201171939.3432-2-jeremy@azazel.net>
 <20171202102009.pdly5urlxkt4rdcx@mwanda>
 <20171202103506.4ffadm3qkxtv3rge@azazel.net>
 <20171202204147.GB32301@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <20171202204147.GB32301@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2017-12-02, at 20:41:48 +0000, Jeremy Sowden wrote:
> On 2017-12-02, at 10:35:06 +0000, Jeremy Sowden wrote:
> > On 2017-12-02, at 13:20:09 +0300, Dan Carpenter wrote:
> > > On Fri, Dec 01, 2017 at 05:19:37PM +0000, Jeremy Sowden wrote:
> > > > -#define DEFAULT_PIPE_INFO \
> > > > -{ \
> > > > -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
> > > > -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
> > > > -	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* raw_output_info */ \
> > > > -	{ 0, 0},				/* output system in res */ \
> > > > -	DEFAULT_SHADING_INFO,			/* shading_info */ \
> > > > -	DEFAULT_GRID_INFO,			/* grid_info */ \
> > > > -	0					/* num_invalid_frames */ \
> > > > -}
> > > > +#define DEFAULT_PIPE_INFO ( \
> > >
> > > Why does this have a ( now?  That can't compile can it??
> > >
> > > > +	(struct ia_css_pipe_info) { \
> > > > +		.output_info			=3D {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
> > > > +		.vf_output_info			=3D {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
> > > > +		.raw_output_info		=3D IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
> > > > +		.output_system_in_res_info	=3D { 0, 0 }, \
> > > > +		.shading_info			=3D DEFAULT_SHADING_INFO, \
> > > > +		.grid_info			=3D DEFAULT_GRID_INFO, \
> > > > +		.num_invalid_frames		=3D 0 \
> > > > +	} \
> > > > +)
> >
> > Checkpatch got quite shouty, e.g.:
> >
> >   ERROR: Macros with complex values should be enclosed in parentheses
> >   #826: FILE: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/ke=
rnels/sdis/common/ia_css_sdis_common_types.h:215:
> >   +#define DEFAULT_DVS_STAT_PUBLIC_DVS_GLOBAL_CFG \
> >   +(struct dvs_stat_public_dvs_global_cfg) { \
> >   +       .kappa          =3D 0, \
> >   +       .match_shift    =3D 0, \
> >   +       .ybin_mode      =3D 0, \
> >   +}
> >
> > so I just wrapped all of them.
>
> I've run checkpatch.pl against the unparenthesized patches, and it
> only objects to some of the macros.  I've also taken a look at the
> source of checkpatch.pl itself, and at first glance it appears that it
> should accept them.  I'll see if I can work out why it's complaining.

I think I've found a bug in checkpatch.pl.  I'll remove the parentheses
=66rom my patches 'cause the error-reportd appear to be bogus, and pass on
my findings.

J.

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEVbDTMOAK4SXP2yyD0czNNmRE1J0FAlojHHMACgkQ0czNNmRE
1J1Fog/+PnAxC9h0ckxEm2i4pszf+hNt9zXRacATqRfAfWUKLzftlgfNH1ekiiEa
nKLUfYv7Glu0SkhQGcNNgVgRCD7TqXwOGPN6XOeSwMBRmylxVbaiPUfSvBYPGQtZ
TcpV8DVbJdLqlfbPt7uwlAnGY4LEcb1yRHYCIRGlSWX9Ih+QBeTIpb/OkBrtvSkx
+64iQ8W+aEocvOQ7q9nFgdnf2I4/uRqgW9Qb6e5+a1Lj5KUbZS25n6e/G06SnSma
pajv76XeV0I4VJnl/Zm8eTAiz2Rh/T0nkrZCTRPTwOzoD0YtEDTExP7x8+dTDACg
HQe0btk4Ie7UU0AIKAvZ+iTaMeIJhgXgYr2o4nAXADTPKafbcDOSrCz+RzpglDkN
c7jXPE9AtQsqAC0GfT99gtnu+8XxAhNUbqejR3mUJ6IMt5E3u9Q6Rxhkf2KrCgCT
eXCQHucSYZmHUu6mnPrusuglJuH1ArI3aal84ur0K6lq6xDFTWZ0uMKyukwf/nbi
fkp70slDXkgasxolvg+6Xpr6LYOnx6zbjQ/MlYlKTGNF/37Grj9h1MqSpvcCs5/z
Sqtz2aDuww8kX52mhecB7+lPMMUolK3qy/MpOTpaNJQb6pZcBEImBlTe4b7m4pz6
WdWxoWC52vbCDxNnFROig9+ZVn2LQLX3TRfRDuZ3z6f+PCHfzuM=
=xBMY
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--

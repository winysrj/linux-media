Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:59140 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbdLBUlw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 15:41:52 -0500
Date: Sat, 2 Dec 2017 20:41:48 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 1/3] media: atomisp: convert default struct values to
 use compound-literals with designated initializers.
Message-ID: <20171202204147.GB32301@azazel.net>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
 <20171201171939.3432-1-jeremy@azazel.net>
 <20171201171939.3432-2-jeremy@azazel.net>
 <20171202102009.pdly5urlxkt4rdcx@mwanda>
 <20171202103506.4ffadm3qkxtv3rge@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <20171202103506.4ffadm3qkxtv3rge@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2017-12-02, at 10:35:06 +0000, Jeremy Sowden wrote:
> On 2017-12-02, at 13:20:09 +0300, Dan Carpenter wrote:
> > On Fri, Dec 01, 2017 at 05:19:37PM +0000, Jeremy Sowden wrote:
> > > -#define DEFAULT_PIPE_INFO \
> > > -{ \
> > > -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
> > > -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
> > > -	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* raw_output_info */ \
> > > -	{ 0, 0},				/* output system in res */ \
> > > -	DEFAULT_SHADING_INFO,			/* shading_info */ \
> > > -	DEFAULT_GRID_INFO,			/* grid_info */ \
> > > -	0					/* num_invalid_frames */ \
> > > -}
> > > +#define DEFAULT_PIPE_INFO ( \
> >
> > Why does this have a ( now?  That can't compile can it??
>
> It does.

That was a bit terse: the macros expand to compound-literals, so
putting parens around them is no different from:

  #define THREE (3)

It's also superfluous, of course.

> > > +	(struct ia_css_pipe_info) { \
> > > +		.output_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
> > > +		.vf_output_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
> > > +		.raw_output_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
> > > +		.output_system_in_res_info	= { 0, 0 }, \
> > > +		.shading_info			= DEFAULT_SHADING_INFO, \
> > > +		.grid_info			= DEFAULT_GRID_INFO, \
> > > +		.num_invalid_frames		= 0 \
> > > +	} \
> > > +)
>
> Checkpatch got quite shouty, e.g.:
>
>   ERROR: Macros with complex values should be enclosed in parentheses
>   #826: FILE: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h:215:
>   +#define DEFAULT_DVS_STAT_PUBLIC_DVS_GLOBAL_CFG \
>   +(struct dvs_stat_public_dvs_global_cfg) { \
>   +       .kappa          = 0, \
>   +       .match_shift    = 0, \
>   +       .ybin_mode      = 0, \
>   +}
>
> so I just wrapped all of them.

I've run checkpatch.pl against the unparenthesized patches, and it only
objects to some of the macros.  I've also taken a look at the source of
checkpatch.pl itself, and at first glance it appears that it should
accept them.  I'll see if I can work out why it's complaining.

J.

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEVbDTMOAK4SXP2yyD0czNNmRE1J0FAlojEAQACgkQ0czNNmRE
1J0+dA/+M89jF4BNt+bpGD46KgmJSNOHVmPCTUUA66RdoPocr2L6Pi1YxCoKGQne
H2cZLpGBVFNclExxvTTx83gkP3OPd5PXwq9mV3CGHYijJ2VaLaC/LdnP2y2soJmA
FNjU0ZArwl6gZgKAk6s3mZ2gwSuPlpupB70ZrDYkSnf2Ok7phDqLsv4uPEKIcW2Q
M1XxyvRlmgcMnii3TI6KYVjDlyPzoYy9ulRaMzG1OUOO65GLJ+lwq7oLwU7MGBuV
/yw1UerW67cVUu72M3yWvh7WQOlg6PG3svPRgQGMC01m5Ba8e1W3nx9nfHoXUdfO
V9lLh1NJqiQ3boUOzIIwxwX0VmeiE7bOvpj8OQNzhsPbac5evlqtluvitKXlR2jd
P0frIsClyNe6Wg/z/bLmME6Fg/flGyeUBxZ6t+CQOVhASFzB5AceKpzQ+ivIcQ5Z
5z/4Yd/qwrM6IX2EY9XaLv3mVvG0Asl3RJbhVEJDl9XobhpAWUayRjLRCQ22FCiI
CT2FmF3F6F2KpzkwGXvjTbvPUnPO8IkWw4F0OEAyiGaKdUPyPc0d3c0JHOtS1Ti4
h/2uD1LyVDyEd/oujtEkskSwpU6PLst5An4lv64eUQLYgykTAlEOenI7P6sNoOcB
IoYZv5J4jUECY5m8oUfRcSNheF8VHwnL/WhuXAg0jZjh0VEKjBg=
=TSvz
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--

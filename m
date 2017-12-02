Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:41064 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbdLBKfR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 05:35:17 -0500
Date: Sat, 2 Dec 2017 10:35:06 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 1/3] media: atomisp: convert default struct values to
 use compound-literals with designated initializers.
Message-ID: <20171202103506.4ffadm3qkxtv3rge@azazel.net>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
 <20171201171939.3432-1-jeremy@azazel.net>
 <20171201171939.3432-2-jeremy@azazel.net>
 <20171202102009.pdly5urlxkt4rdcx@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="audag6s7qkczdwdc"
Content-Disposition: inline
In-Reply-To: <20171202102009.pdly5urlxkt4rdcx@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--audag6s7qkczdwdc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2017-12-02, at 13:20:09 +0300, Dan Carpenter wrote:
> On Fri, Dec 01, 2017 at 05:19:37PM +0000, Jeremy Sowden wrote:
> > -#define DEFAULT_PIPE_INFO \
> > -{ \
> > -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
> > -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
> > -	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* raw_output_info */ \
> > -	{ 0, 0},				/* output system in res */ \
> > -	DEFAULT_SHADING_INFO,			/* shading_info */ \
> > -	DEFAULT_GRID_INFO,			/* grid_info */ \
> > -	0					/* num_invalid_frames */ \
> > -}
> > +#define DEFAULT_PIPE_INFO ( \
>
> Why does this have a ( now?  That can't compile can it??

It does.

> > +	(struct ia_css_pipe_info) { \
> > +		.output_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
> > +		.vf_output_info			= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
> > +		.raw_output_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
> > +		.output_system_in_res_info	= { 0, 0 }, \
> > +		.shading_info			= DEFAULT_SHADING_INFO, \
> > +		.grid_info			= DEFAULT_GRID_INFO, \
> > +		.num_invalid_frames		= 0 \
> > +	} \
> > +)

Checkpatch got quite shouty, e.g.:

  ERROR: Macros with complex values should be enclosed in parentheses
  #826: FILE: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_common_types.h:215:
  +#define DEFAULT_DVS_STAT_PUBLIC_DVS_GLOBAL_CFG \
  +(struct dvs_stat_public_dvs_global_cfg) { \
  +       .kappa          = 0, \
  +       .match_shift    = 0, \
  +       .ybin_mode      = 0, \
  +}

so I just wrapped all of them.

> We need to get better compile test coverage on this...  :/  There are
> some others as well.

I have run a test-compilation.  Some of the code doesn't get built
because it's #ifdeffed off.  I did try adding -DISP2401 (which enables
most of it), that that just causes unrelated compilation failures.

J.

--audag6s7qkczdwdc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEVbDTMOAK4SXP2yyD0czNNmRE1J0FAloigc4ACgkQ0czNNmRE
1J1lMg//YsIAy9VrIJ2aKw9vd11Lkl3ee7yatNEKKjXVBTSyDSb6GbkDfab2fpJm
jYfR+bZU7zGWUkivTzkBgjkCnR/cZaDyb8scMIl8JJkScoopDm+mGqaDwsIA+qfD
ucslKQpycoVZ+ZNVUv1ZKk9AzJzlDkJjhYhXXf7YOqI/AKp1yR6GcO3pdnPXd1L/
gMuQhyfi+4R75YUFYkP7NYDNpMgbnjAWCKYbvt2MY4QR/6n7SZTNO8InnJho2ZkL
1pvkNKpnJMHN5UlwVy8n2CJLpJOqCSdNnfe31Tl93VDRtyw68YC6mYRDF3KEj8WQ
t+Lmw3GqVuicQ1zY3KzPxhToeNvO9223bwI9xr5CDdIhscGd3C8hHt+7Ht1IRvPv
sVVTdsAx34FY4JZZyJb0wwHnmIIgwYnudsqsPrr+LuH88uqqWVPG8pqw3ldhOwA9
NfPdy6NyrWXstUeiVf+tCvZTfx8gm0SMRkkclZlKBhR74y7e0kM85/Lhdnh9pGHI
dfVwH9Y7XsNMQLG5+GakxttJ8cVlOcdD2Di0thEWIqDKogvi3Onbm8Z7waB83O/i
pWOzNJnymu5x41kXActbRSdwy8El2D9a5agpnC42/F7Wp5h5RPXtS1uZRq19A/pU
K+YeUIa55A4jo8l8nYjELEtXO99lq62mIhxi9hxOv7EzTI9CedY=
=fbDJ
-----END PGP SIGNATURE-----

--audag6s7qkczdwdc--

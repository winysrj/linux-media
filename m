Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:55998 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdLCKy3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 05:54:29 -0500
Date: Sun, 3 Dec 2017 10:54:23 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/3] media: atomisp: convert default struct values to
 use compound-literals with designated initializers.
Message-ID: <20171203105423.GE32301@azazel.net>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
 <20171201171939.3432-1-jeremy@azazel.net>
 <20171201171939.3432-2-jeremy@azazel.net>
 <20171202102009.pdly5urlxkt4rdcx@mwanda>
 <20171202103506.4ffadm3qkxtv3rge@azazel.net>
 <20171202204147.GB32301@azazel.net>
 <20171203053921.tvvvttx63zi2p725@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <20171203053921.tvvvttx63zi2p725@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2017-12-03, at 08:39:21 +0300, Dan Carpenter wrote:
> On Sat, Dec 02, 2017 at 08:41:48PM +0000, Jeremy Sowden wrote:
> > On 2017-12-02, at 10:35:06 +0000, Jeremy Sowden wrote:
> > > On 2017-12-02, at 13:20:09 +0300, Dan Carpenter wrote:
> > > > On Fri, Dec 01, 2017 at 05:19:37PM +0000, Jeremy Sowden wrote:
> > > > > -#define DEFAULT_PIPE_INFO \
> > > > > -{ \
> > > > > -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
> > > > > -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
> > > > > -	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* raw_output_info */ \
> > > > > -	{ 0, 0},				/* output system in res */ \
> > > > > -	DEFAULT_SHADING_INFO,			/* shading_info */ \
> > > > > -	DEFAULT_GRID_INFO,			/* grid_info */ \
> > > > > -	0					/* num_invalid_frames */ \
> > > > > -}
> > > > > +#define DEFAULT_PIPE_INFO ( \
> > > >
> > > > Why does this have a ( now?  That can't compile can it??
> > >
> > > It does.
> >
> > That was a bit terse: the macros expand to compound-literals, so
> > putting parens around them is no different from:
> >
> >   #define THREE (3)
>
> Yeah.  Thanks.  I figured it out despite the terseness...  I try
> review as fast as I can, so it means you get the stream of
> conciousness output that often has mistakes.  Sorry about that.

No worries.  The feedback has been very helpful.

J.

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEVbDTMOAK4SXP2yyD0czNNmRE1J0FAloj19cACgkQ0czNNmRE
1J2QqQ/8DqlHy+7UgJp5efppCmiu0jaqoFwK7Gf1q5zMDWNNlScnS6vxVa73v+9V
B7zdj84h/rAQ0hSyUCWIux+9iI7dWS+7D5Q7VbnFGWT8oobVliaDruNAKCGKSQnq
XenSfh9fEbScyQCLLiu5LuYBXEaaJ6QJM6RYSA3c5HIqquxbOBrFJFnQFrCGeEmC
3lrERvfNHLf4xD8s0ltXoYYCTesfql30h2XzzlTdqdUsu6pkSrFXwsvjfUxgKtsT
sNKWNQDC48cRUdB5I06pZojo5LL76LAkp2DwzR9HUFjIJUF9XAGT/75/pya/wqxc
2yCIST7dAfWVQhfn2acLtWqRQ8qLHG4ganVEhHoODAXp1HgT311YiQgZ5ujApkKu
FpnA2fXlMUiWYkUdv2SMZltzuClVLFSdeADVnJuL7PTwo5V+LN1/84mFmD7zcWlF
WjKVigOSz0f0gyaD2YS/6r5nXOtF0/kGJjMCgWVDvc7gnH3w4Y3aSlGfBLgpjZHV
vPfzyZCvCdYxXRxd0sLUv8g7GwvVtb5EOLcsYMJaN3yzeJpyhcNLOiIifZTX4Mqh
fUSd3QwIm7U5WZwr4VorVyjBZ8eXeTsZJZ2LiC4Cm7m+AnUYPB+I/ReVash34m22
dXmbWkYqaiCOOPA2M+3jmIUjTq8eQJ44MPceeeqOwd8kDgG+bWI=
=1646
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--

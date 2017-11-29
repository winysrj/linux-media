Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:53618 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdK2Iin (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 03:38:43 -0500
Date: Wed, 29 Nov 2017 08:38:36 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/3] media: staging: atomisp: fix for sparse "using
 plain integer as NULL pointer" warnings.
Message-ID: <20171129083835.tam3avqz5vishwqw@azazel.net>
References: <20171127122125.GB8561@kroah.com>
 <20171127124450.28799-1-jeremy@azazel.net>
 <20171127124450.28799-2-jeremy@azazel.net>
 <20171128141524.kpvqbowgmpkzwfuz@mwanda>
 <20171128233337.nwelcxvgaqtpgv5o@azazel.net>
 <20171129000452.5mcbijzedww34ojc@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="w4szkskqno5govmh"
Content-Disposition: inline
In-Reply-To: <20171129000452.5mcbijzedww34ojc@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--w4szkskqno5govmh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2017-11-29, at 03:04:53 +0300, Dan Carpenter wrote:
> On Tue, Nov 28, 2017 at 11:33:37PM +0000, Jeremy Sowden wrote:
> > On 2017-11-28, at 17:15:24 +0300, Dan Carpenter wrote:
> > > On Mon, Nov 27, 2017 at 12:44:48PM +0000, Jeremy Sowden wrote:
> > > > The "address" member of struct ia_css_host_data is a
> > > > pointer-to-char, so define default as NULL.
> > > >
> > > > --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> > > > +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> > > > @@ -95,7 +95,7 @@ union ia_css_all_memory_offsets {
> > > >  };
> > > >
> > > >  #define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
> > > > -		{ { { { 0, 0 } } } }
> > > > +		{ { { { NULL, 0 } } } }
> > >
> > > This define is way ugly and instead of making superficial changes, you
> > > should try to eliminate it.
> > >
> > > People look at warnings as a bad thing but they are actually a
> > > valuable resource which call attention to bad code.  By making this
> > > change you're kind of wasting the warning.  The bad code is still
> > > there, it's just swept under the rug but like a dead mouse carcass
> > > it's still stinking up the living room.  We should leave the warning
> > > there until it irritates someone enough to fix it properly.
> >
> > Tracking down the offending initializer was definitely a pain.
> >
> > Compound literals with designated initializers would make this macro
> > (and a number of others) easier to understand and more type-safe:
> >
> >    #define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
> >   -		{ { { { 0, 0 } } } }
> >   +	(struct ia_css_isp_param_host_segments) { \
> >   +		.params = { { \
> >   +			(struct ia_css_host_data) { \
> >   +				.address = NULL, \
> >   +				.size = 0 \
> >   +			} \
> >   +		} } \
> >   +	}
>
> Using designated initializers is good, yes.  Can't we just use an
> empty initializer since this is all zeroed memory anyway?
>
> 	(struct ia_css_isp_param_host_segments) { }
>
> I haven't tried it.

There are 35 defaults defined by macros like this, most of them much
more complicated that IA_CSS_DEFAULT_ISP_MEM_PARAMS, and a few members
are initialized to non-zero values.  My plan, therefore, is to convert
everything to use designated initializers, and then start removing the
zeroes afterwards.

> >
> > Unfortunately this default value is one end of a chain of default values
>
> Yeah.  A really long chain...
>
> > used to initialize members of default values of enclosing structs where
> > the outermost values are used to initialize some static variables:
> >
> >   static enum ia_css_err
> >   init_pipe_defaults(enum ia_css_pipe_mode mode,
> > 		     struct ia_css_pipe *pipe,
> > 		     bool copy_pipe)
> >   {
> >     static struct ia_css_pipe default_pipe = IA_CSS_DEFAULT_PIPE;
> >     static struct ia_css_preview_settings prev  = IA_CSS_DEFAULT_PREVIEW_SETTINGS;
> >     static struct ia_css_capture_settings capt  = IA_CSS_DEFAULT_CAPTURE_SETTINGS;
> >     static struct ia_css_video_settings   video = IA_CSS_DEFAULT_VIDEO_SETTINGS;
> >     static struct ia_css_yuvpp_settings   yuvpp = IA_CSS_DEFAULT_YUVPP_SETTINGS;
> >
> >     if (pipe == NULL) {
> >       IA_CSS_ERROR("NULL pipe parameter");
> >       return IA_CSS_ERR_INVALID_ARGUMENTS;
> >     }
> >
> >     /* Initialize pipe to pre-defined defaults */
> >     *pipe = default_pipe;
> >
> >     [...]
> >
> > I'm not convinced, however, that those variables actually achieve very
> > much.  If I change the code to assign the defaults directly, the problem
> > goes away:
> >
> >     [...]
> >
> > Does this seem reasonable or am I barking up the wrong tree?
>
> Yes.  Chopping the chain down and deleting as much of this code as
> possible seems a good thing.

I'll get chopping.

J.

--w4szkskqno5govmh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEVbDTMOAK4SXP2yyD0czNNmRE1J0FAloecgEACgkQ0czNNmRE
1J1eLw//Q2fVEN82YruRqeNk6XOwUpSvvjKP9tIY0JZO+c2U5jeTduC+4zM9zEtB
ms5a2pG1HIgJJUgppXbVmbfXW1us93bxEWKaq+Y9O2xVkWDqS3MfNVC0DaEzNina
TVBvepPwGJ0cFPX0SAMEsCk97t5LUzhT63uEfwXI72PkFdiAaRj9avyNLynqIk1a
Rzm8Sk0CHdIdtIdPHf9veUZOj9LVTS5Y6T0GsCV40HihpB21RKvrsszfUEDkxJEw
SItKImOZFGLgiWfMc4ZG0/MRgPKeLOrXJN9h1rM1tlSXv8uRxBmtUzaUE53kgtMj
d5vQj+XKeIuRCZxNipgzjl1cqXdkOyAFjaImGfNu4PmL5ry1fZTlUuPmV8ZUC7Dn
DEPm358mD1wy0cuxcc4YLf3ywfGQXNPQjdWw/CHT9DmgpldQrbiFTsrn71Zcmapg
o50DqNzAhZnYzqWNgD7rKN+Y39UVhZfToF/if1+/0jQid6wUJHJVndavE2Wwh/cE
no3cIsVJm1Hu/Po1Be0chwZZly0ZD2Fv4mEv1rU4OP78SBrNGe4IfUBkHwSvxskq
FuLXwhNmU0nYk9RE4KiyuIflbe8Y5exTAulBW9o/jAoRCiO7RH9hPGOF7rjS/bZe
0ydPWyaD2Btice3erUgv8F8hxic/5X34CuGVdp5mFHWtVX9jH4k=
=MUBD
-----END PGP SIGNATURE-----

--w4szkskqno5govmh--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:38658 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752404AbdK1Xdm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 18:33:42 -0500
Date: Tue, 28 Nov 2017 23:33:37 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 1/3] media: staging: atomisp: fix for sparse "using
 plain integer as NULL pointer" warnings.
Message-ID: <20171128233337.nwelcxvgaqtpgv5o@azazel.net>
References: <20171127122125.GB8561@kroah.com>
 <20171127124450.28799-1-jeremy@azazel.net>
 <20171127124450.28799-2-jeremy@azazel.net>
 <20171128141524.kpvqbowgmpkzwfuz@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fykskowyew2vynlh"
Content-Disposition: inline
In-Reply-To: <20171128141524.kpvqbowgmpkzwfuz@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fykskowyew2vynlh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2017-11-28, at 17:15:24 +0300, Dan Carpenter wrote:
> On Mon, Nov 27, 2017 at 12:44:48PM +0000, Jeremy Sowden wrote:
> > The "address" member of struct ia_css_host_data is a
> > pointer-to-char, so define default as NULL.
> >
> > --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> > +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> > @@ -95,7 +95,7 @@ union ia_css_all_memory_offsets {
> >  };
> >
> >  #define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
> > -		{ { { { 0, 0 } } } }
> > +		{ { { { NULL, 0 } } } }
>
> This define is way ugly and instead of making superficial changes, you
> should try to eliminate it.
>
> People look at warnings as a bad thing but they are actually a
> valuable resource which call attention to bad code.  By making this
> change you're kind of wasting the warning.  The bad code is still
> there, it's just swept under the rug but like a dead mouse carcass
> it's still stinking up the living room.  We should leave the warning
> there until it irritates someone enough to fix it properly.

Tracking down the offending initializer was definitely a pain.

Compound literals with designated initializers would make this macro
(and a number of others) easier to understand and more type-safe:

   #define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
  -		{ { { { 0, 0 } } } }
  +	(struct ia_css_isp_param_host_segments) { \
  +		.params = { { \
  +			(struct ia_css_host_data) { \
  +				.address = NULL, \
  +				.size = 0 \
  +			} \
  +		} } \
  +	}

Unfortunately this default value is one end of a chain of default values
used to initialize members of default values of enclosing structs where
the outermost values are used to initialize some static variables:

  static enum ia_css_err
  init_pipe_defaults(enum ia_css_pipe_mode mode,
		     struct ia_css_pipe *pipe,
		     bool copy_pipe)
  {
    static struct ia_css_pipe default_pipe = IA_CSS_DEFAULT_PIPE;
    static struct ia_css_preview_settings prev  = IA_CSS_DEFAULT_PREVIEW_SETTINGS;
    static struct ia_css_capture_settings capt  = IA_CSS_DEFAULT_CAPTURE_SETTINGS;
    static struct ia_css_video_settings   video = IA_CSS_DEFAULT_VIDEO_SETTINGS;
    static struct ia_css_yuvpp_settings   yuvpp = IA_CSS_DEFAULT_YUVPP_SETTINGS;

    if (pipe == NULL) {
      IA_CSS_ERROR("NULL pipe parameter");
      return IA_CSS_ERR_INVALID_ARGUMENTS;
    }

    /* Initialize pipe to pre-defined defaults */
    *pipe = default_pipe;

    /* TODO: JB should not be needed, but temporary backward reference */
    switch (mode) {
    case IA_CSS_PIPE_MODE_PREVIEW:
      pipe->mode = IA_CSS_PIPE_ID_PREVIEW;
      pipe->pipe_settings.preview = prev;
      break;
    case IA_CSS_PIPE_MODE_CAPTURE:
      if (copy_pipe) {
	pipe->mode = IA_CSS_PIPE_ID_COPY;
      } else {
	pipe->mode = IA_CSS_PIPE_ID_CAPTURE;
      }
      pipe->pipe_settings.capture = capt;
      break;
    case IA_CSS_PIPE_MODE_VIDEO:
      pipe->mode = IA_CSS_PIPE_ID_VIDEO;
      pipe->pipe_settings.video = video;
      break;
    case IA_CSS_PIPE_MODE_ACC:
      pipe->mode = IA_CSS_PIPE_ID_ACC;
      break;
    case IA_CSS_PIPE_MODE_COPY:
      pipe->mode = IA_CSS_PIPE_ID_CAPTURE;
      break;
    case IA_CSS_PIPE_MODE_YUVPP:
      pipe->mode = IA_CSS_PIPE_ID_YUVPP;
      pipe->pipe_settings.yuvpp = yuvpp;
      break;
    default:
      return IA_CSS_ERR_INVALID_ARGUMENTS;
    }

    return IA_CSS_SUCCESS;
  }

and GCC's limited support for using compound literals to initialize
static variables doesn't stretch this far.

I'm not convinced, however, that those variables actually achieve very
much.  If I change the code to assign the defaults directly, the problem
goes away:

  diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
  index f92b6a9f77eb..671b2c732a46 100644
  --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
  +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
  @@ -2291,25 +2291,19 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
		 struct ia_css_pipe *pipe,
		 bool copy_pipe)
   {
  -       static struct ia_css_pipe default_pipe = IA_CSS_DEFAULT_PIPE;
  -       static struct ia_css_preview_settings prev  = IA_CSS_DEFAULT_PREVIEW_SETTINGS;
  -       static struct ia_css_capture_settings capt  = IA_CSS_DEFAULT_CAPTURE_SETTINGS;
  -       static struct ia_css_video_settings   video = IA_CSS_DEFAULT_VIDEO_SETTINGS;
  -       static struct ia_css_yuvpp_settings   yuvpp = IA_CSS_DEFAULT_YUVPP_SETTINGS;
  -
	  if (pipe == NULL) {
		  IA_CSS_ERROR("NULL pipe parameter");
		  return IA_CSS_ERR_INVALID_ARGUMENTS;
	  }

	  /* Initialize pipe to pre-defined defaults */
  -       *pipe = default_pipe;
  +       *pipe = IA_CSS_DEFAULT_PIPE;

	  /* TODO: JB should not be needed, but temporary backward reference */
	  switch (mode) {
	  case IA_CSS_PIPE_MODE_PREVIEW:
		  pipe->mode = IA_CSS_PIPE_ID_PREVIEW;
  -               pipe->pipe_settings.preview = prev;
  +               pipe->pipe_settings.preview = IA_CSS_DEFAULT_PREVIEW_SETTINGS;
		  break;
	  case IA_CSS_PIPE_MODE_CAPTURE:
		  if (copy_pipe) {
  @@ -2317,11 +2311,11 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
		  } else {
			  pipe->mode = IA_CSS_PIPE_ID_CAPTURE;
		  }
  -               pipe->pipe_settings.capture = capt;
  +               pipe->pipe_settings.capture = IA_CSS_DEFAULT_CAPTURE_SETTINGS;
		  break;
	  case IA_CSS_PIPE_MODE_VIDEO:
		  pipe->mode = IA_CSS_PIPE_ID_VIDEO;
  -               pipe->pipe_settings.video = video;
  +               pipe->pipe_settings.video = IA_CSS_DEFAULT_VIDEO_SETTINGS;
		  break;
	  case IA_CSS_PIPE_MODE_ACC:
		  pipe->mode = IA_CSS_PIPE_ID_ACC;
  @@ -2331,7 +2325,7 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
		  break;
	  case IA_CSS_PIPE_MODE_YUVPP:
		  pipe->mode = IA_CSS_PIPE_ID_YUVPP;
  -               pipe->pipe_settings.yuvpp = yuvpp;
  +               pipe->pipe_settings.yuvpp = IA_CSS_DEFAULT_YUVPP_SETTINGS;
		  break;
	  default:
		  return IA_CSS_ERR_INVALID_ARGUMENTS;

Does this seem reasonable or am I barking up the wrong tree?

J.

--fykskowyew2vynlh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEVbDTMOAK4SXP2yyD0czNNmRE1J0FAlod8kgACgkQ0czNNmRE
1J1WjhAAoRf/WUqXMLdGscUoRWh9bvW6bUf7mnxODA+uV+sQZtC7I+xXsDS45OzW
H1JKGqJK06QlU/8CWrvY07eN/DagW5H9XQAhC4FeNaW3/XEXKPw5meHc3Nb604k6
2IhCAUgPwsFRhBdjCgpzc73hrVQBKTC33yvlApSOF6Q/yfo1tNRSMIR7tEU+zMc4
FuoSBSf3xE0lqdMZ3S3Oq5/7OL0c+qjz2iwUU20ZO/McWBwRQSJAy71SGarXFNT7
JvwU89woR2xjWBMzKs8wn2uUm1XrQDVp+cmOTMnwWiZSQIFDpD070eFeP0q5W7hW
W76huzcpGpDU/S1OiMjsDHwepTdGuJAlgj3xkWMMCn6y3lV+anevDKqsRPDMlpQu
YQFzjHgwPo1FIyOP//yCZSyTnEX5WYfMapuORnwB1ZRw22Q708KsiNGyvEcff/QR
ItAq0pz7q94NOiZbrLJGugPQ/IAGmQEaUHbrzF4Bh/gyq3x048IfImM4yoPsnuBW
n4X5I1i6tZZ83WnEESM3UI1ltLjYG8h9c0arWFxIc58hdTBpNH5/bAAHYZWdx/3v
D1b5Mpheu89sxjzYELBxtJZXw9jcm8dmn4hwy5DiYfNhsj5daRB8aEmTkGvnYRnT
HuosraLAWEdbhW7fV0b43NzHfcNoMHDLAl4mZyPP/pL2WbVwu98=
=ORF1
-----END PGP SIGNATURE-----

--fykskowyew2vynlh--

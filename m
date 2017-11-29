Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33754 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbdK2AFI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 19:05:08 -0500
Date: Wed, 29 Nov 2017 03:04:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/3] media: staging: atomisp: fix for sparse "using
 plain integer as NULL pointer" warnings.
Message-ID: <20171129000452.5mcbijzedww34ojc@mwanda>
References: <20171127122125.GB8561@kroah.com>
 <20171127124450.28799-1-jeremy@azazel.net>
 <20171127124450.28799-2-jeremy@azazel.net>
 <20171128141524.kpvqbowgmpkzwfuz@mwanda>
 <20171128233337.nwelcxvgaqtpgv5o@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128233337.nwelcxvgaqtpgv5o@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 28, 2017 at 11:33:37PM +0000, Jeremy Sowden wrote:
> On 2017-11-28, at 17:15:24 +0300, Dan Carpenter wrote:
> > On Mon, Nov 27, 2017 at 12:44:48PM +0000, Jeremy Sowden wrote:
> > > The "address" member of struct ia_css_host_data is a
> > > pointer-to-char, so define default as NULL.
> > >
> > > --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> > > +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/interface/ia_css_isp_param_types.h
> > > @@ -95,7 +95,7 @@ union ia_css_all_memory_offsets {
> > >  };
> > >
> > >  #define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
> > > -		{ { { { 0, 0 } } } }
> > > +		{ { { { NULL, 0 } } } }
> >
> > This define is way ugly and instead of making superficial changes, you
> > should try to eliminate it.
> >
> > People look at warnings as a bad thing but they are actually a
> > valuable resource which call attention to bad code.  By making this
> > change you're kind of wasting the warning.  The bad code is still
> > there, it's just swept under the rug but like a dead mouse carcass
> > it's still stinking up the living room.  We should leave the warning
> > there until it irritates someone enough to fix it properly.
> 
> Tracking down the offending initializer was definitely a pain.
> 
> Compound literals with designated initializers would make this macro
> (and a number of others) easier to understand and more type-safe:
> 
>    #define IA_CSS_DEFAULT_ISP_MEM_PARAMS \
>   -		{ { { { 0, 0 } } } }
>   +	(struct ia_css_isp_param_host_segments) { \
>   +		.params = { { \
>   +			(struct ia_css_host_data) { \
>   +				.address = NULL, \
>   +				.size = 0 \
>   +			} \
>   +		} } \
>   +	}

Using designated initializers is good, yes.  Can't we just use an
empty initializer since this is all zeroed memory anyway?

	(struct ia_css_isp_param_host_segments) { }

I haven't tried it.

> 
> Unfortunately this default value is one end of a chain of default values


Yeah.  A really long chain...


> used to initialize members of default values of enclosing structs where
> the outermost values are used to initialize some static variables:
> 
>   static enum ia_css_err
>   init_pipe_defaults(enum ia_css_pipe_mode mode,
> 		     struct ia_css_pipe *pipe,
> 		     bool copy_pipe)
>   {
>     static struct ia_css_pipe default_pipe = IA_CSS_DEFAULT_PIPE;
>     static struct ia_css_preview_settings prev  = IA_CSS_DEFAULT_PREVIEW_SETTINGS;
>     static struct ia_css_capture_settings capt  = IA_CSS_DEFAULT_CAPTURE_SETTINGS;
>     static struct ia_css_video_settings   video = IA_CSS_DEFAULT_VIDEO_SETTINGS;
>     static struct ia_css_yuvpp_settings   yuvpp = IA_CSS_DEFAULT_YUVPP_SETTINGS;
> 
>     if (pipe == NULL) {
>       IA_CSS_ERROR("NULL pipe parameter");
>       return IA_CSS_ERR_INVALID_ARGUMENTS;
>     }
> 
>     /* Initialize pipe to pre-defined defaults */
>     *pipe = default_pipe;
> 
>     /* TODO: JB should not be needed, but temporary backward reference */
>     switch (mode) {
>     case IA_CSS_PIPE_MODE_PREVIEW:
>       pipe->mode = IA_CSS_PIPE_ID_PREVIEW;
>       pipe->pipe_settings.preview = prev;
>       break;
>     case IA_CSS_PIPE_MODE_CAPTURE:
>       if (copy_pipe) {
> 	pipe->mode = IA_CSS_PIPE_ID_COPY;
>       } else {
> 	pipe->mode = IA_CSS_PIPE_ID_CAPTURE;
>       }
>       pipe->pipe_settings.capture = capt;
>       break;
>     case IA_CSS_PIPE_MODE_VIDEO:
>       pipe->mode = IA_CSS_PIPE_ID_VIDEO;
>       pipe->pipe_settings.video = video;
>       break;
>     case IA_CSS_PIPE_MODE_ACC:
>       pipe->mode = IA_CSS_PIPE_ID_ACC;
>       break;
>     case IA_CSS_PIPE_MODE_COPY:
>       pipe->mode = IA_CSS_PIPE_ID_CAPTURE;
>       break;
>     case IA_CSS_PIPE_MODE_YUVPP:
>       pipe->mode = IA_CSS_PIPE_ID_YUVPP;
>       pipe->pipe_settings.yuvpp = yuvpp;
>       break;
>     default:
>       return IA_CSS_ERR_INVALID_ARGUMENTS;
>     }
> 
>     return IA_CSS_SUCCESS;
>   }
> 
> and GCC's limited support for using compound literals to initialize
> static variables doesn't stretch this far.
> 
> I'm not convinced, however, that those variables actually achieve very
> much.  If I change the code to assign the defaults directly, the problem
> goes away:
> 
>   diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
>   index f92b6a9f77eb..671b2c732a46 100644
>   --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
>   +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
>   @@ -2291,25 +2291,19 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
> 		 struct ia_css_pipe *pipe,
> 		 bool copy_pipe)
>    {
>   -       static struct ia_css_pipe default_pipe = IA_CSS_DEFAULT_PIPE;
>   -       static struct ia_css_preview_settings prev  = IA_CSS_DEFAULT_PREVIEW_SETTINGS;
>   -       static struct ia_css_capture_settings capt  = IA_CSS_DEFAULT_CAPTURE_SETTINGS;
>   -       static struct ia_css_video_settings   video = IA_CSS_DEFAULT_VIDEO_SETTINGS;
>   -       static struct ia_css_yuvpp_settings   yuvpp = IA_CSS_DEFAULT_YUVPP_SETTINGS;
>   -
> 	  if (pipe == NULL) {
> 		  IA_CSS_ERROR("NULL pipe parameter");
> 		  return IA_CSS_ERR_INVALID_ARGUMENTS;
> 	  }
> 
> 	  /* Initialize pipe to pre-defined defaults */
>   -       *pipe = default_pipe;
>   +       *pipe = IA_CSS_DEFAULT_PIPE;
> 
> 	  /* TODO: JB should not be needed, but temporary backward reference */
> 	  switch (mode) {
> 	  case IA_CSS_PIPE_MODE_PREVIEW:
> 		  pipe->mode = IA_CSS_PIPE_ID_PREVIEW;
>   -               pipe->pipe_settings.preview = prev;
>   +               pipe->pipe_settings.preview = IA_CSS_DEFAULT_PREVIEW_SETTINGS;
> 		  break;
> 	  case IA_CSS_PIPE_MODE_CAPTURE:
> 		  if (copy_pipe) {
>   @@ -2317,11 +2311,11 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
> 		  } else {
> 			  pipe->mode = IA_CSS_PIPE_ID_CAPTURE;
> 		  }
>   -               pipe->pipe_settings.capture = capt;
>   +               pipe->pipe_settings.capture = IA_CSS_DEFAULT_CAPTURE_SETTINGS;
> 		  break;
> 	  case IA_CSS_PIPE_MODE_VIDEO:
> 		  pipe->mode = IA_CSS_PIPE_ID_VIDEO;
>   -               pipe->pipe_settings.video = video;
>   +               pipe->pipe_settings.video = IA_CSS_DEFAULT_VIDEO_SETTINGS;
> 		  break;
> 	  case IA_CSS_PIPE_MODE_ACC:
> 		  pipe->mode = IA_CSS_PIPE_ID_ACC;
>   @@ -2331,7 +2325,7 @@ init_pipe_defaults(enum ia_css_pipe_mode mode,
> 		  break;
> 	  case IA_CSS_PIPE_MODE_YUVPP:
> 		  pipe->mode = IA_CSS_PIPE_ID_YUVPP;
>   -               pipe->pipe_settings.yuvpp = yuvpp;
>   +               pipe->pipe_settings.yuvpp = IA_CSS_DEFAULT_YUVPP_SETTINGS;
> 		  break;
> 	  default:
> 		  return IA_CSS_ERR_INVALID_ARGUMENTS;
> 
> Does this seem reasonable or am I barking up the wrong tree?

Yes.  Chopping the chain down and deleting as much of this code as
possible seems a good thing.

regards,
dan carpenter

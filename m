Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47982 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933129AbeBPKMX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 05:12:23 -0500
Date: Fri, 16 Feb 2018 12:12:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 4/9] staging: atomisp: i2c: Disable non-preview
 configurations
Message-ID: <20180216101220.ncl7gda4xq2vzcqw@valkosipuli.retiisi.org.uk>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
 <20180122123125.24709-5-hverkuil@xs4all.nl>
 <20180214142050.2ef515ee@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180214142050.2ef515ee@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Feb 14, 2018 at 02:20:50PM -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 22 Jan 2018 13:31:20 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Disable configurations for non-preview modes until configuration selection
> > is improved.
> 
> Again, a poor description. It just repeats the subject.
> A good subject/description should answer 3 questions:
> 
> 	what?
> 	why?
> 	how?
> 
> Anyway, looking at this patch's contents, it partially answers my
> questions:
> 
> the previous patch do cause regressions at the code.
> 
> Ok, this is staging. So, we don't have very strict rules here,
> but still causing regressions without providing a very good
> reason why sucks.
> 
> I would also merge this with the previous one, in order to place all
> regressions on a single patch.

It's trivial to bring back the configurations disabled here by just
reverting this patch. The other patch does not disable any. That's why
they're separate.

> 
> 
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/staging/media/atomisp/i2c/gc2235.h        | 2 ++
> >  drivers/staging/media/atomisp/i2c/ov2722.h        | 2 ++
> >  drivers/staging/media/atomisp/i2c/ov5693/ov5693.h | 2 ++
> >  3 files changed, 6 insertions(+)
> > 
> > diff --git a/drivers/staging/media/atomisp/i2c/gc2235.h b/drivers/staging/media/atomisp/i2c/gc2235.h
> > index 45a54fea5466..817c0068c1d3 100644
> > --- a/drivers/staging/media/atomisp/i2c/gc2235.h
> > +++ b/drivers/staging/media/atomisp/i2c/gc2235.h
> > @@ -574,6 +574,7 @@ static struct gc2235_resolution gc2235_res_preview[] = {
> >  };
> >  #define N_RES_PREVIEW (ARRAY_SIZE(gc2235_res_preview))
> >  
> > +#if 0 /* Disable non-previes configurations for now */
> 
> typo (here and other cut-and-paste paces)
> 	non-previes -> non-previews
> 
> also, please add a FIXME: or HACK: and describe the need for a fix
> on atomisp TODO file.
> 
> >  static struct gc2235_resolution gc2235_res_still[] = {
> >  	{
> >  		.desc = "gc2235_1600_900_30fps",
> > @@ -658,6 +659,7 @@ static struct gc2235_resolution gc2235_res_video[] = {
> >  
> >  };
> >  #define N_RES_VIDEO (ARRAY_SIZE(gc2235_res_video))
> > +#endif
> >  
> >  static struct gc2235_resolution *gc2235_res = gc2235_res_preview;
> >  static unsigned long N_RES = N_RES_PREVIEW;
> > diff --git a/drivers/staging/media/atomisp/i2c/ov2722.h b/drivers/staging/media/atomisp/i2c/ov2722.h
> > index d8a973d71699..f133439adfd5 100644
> > --- a/drivers/staging/media/atomisp/i2c/ov2722.h
> > +++ b/drivers/staging/media/atomisp/i2c/ov2722.h
> > @@ -1148,6 +1148,7 @@ struct ov2722_resolution ov2722_res_preview[] = {
> >  };
> >  #define N_RES_PREVIEW (ARRAY_SIZE(ov2722_res_preview))
> >  
> > +#if 0 /* Disable non-previes configurations for now */
> >  struct ov2722_resolution ov2722_res_still[] = {
> >  	{
> >  		.desc = "ov2722_480P_30fps",
> > @@ -1250,6 +1251,7 @@ struct ov2722_resolution ov2722_res_video[] = {
> >  	},
> >  };
> >  #define N_RES_VIDEO (ARRAY_SIZE(ov2722_res_video))
> > +#endif
> >  
> >  static struct ov2722_resolution *ov2722_res = ov2722_res_preview;
> >  static unsigned long N_RES = N_RES_PREVIEW;
> > diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
> > index 68cfcb4a6c3c..15a33dcd2d59 100644
> > --- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
> > +++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
> > @@ -1147,6 +1147,7 @@ struct ov5693_resolution ov5693_res_preview[] = {
> >  };
> >  #define N_RES_PREVIEW (ARRAY_SIZE(ov5693_res_preview))
> >  
> > +#if 0 /* Disable non-previes configurations for now */
> >  struct ov5693_resolution ov5693_res_still[] = {
> >  	{
> >  		.desc = "ov5693_736x496_30fps",
> > @@ -1364,6 +1365,7 @@ struct ov5693_resolution ov5693_res_video[] = {
> >  	},
> >  };
> >  #define N_RES_VIDEO (ARRAY_SIZE(ov5693_res_video))
> > +#endif
> >  
> >  static struct ov5693_resolution *ov5693_res = ov5693_res_preview;
> >  static unsigned long N_RES = N_RES_PREVIEW;
> 
> 
> 
> Thanks,
> Mauro

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

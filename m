Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:1246 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751400AbeCWPb4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 11:31:56 -0400
Date: Fri, 23 Mar 2018 17:31:53 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: Bring back array_size parameter to
 v4l2_find_nearest_size
Message-ID: <20180323153152.377whg5qyolvsuxq@kekkonen.localdomain>
References: <20180323134841.21408-1-sakari.ailus@linux.intel.com>
 <20180323110742.4d055035@vento.lan>
 <20180323110855.51989894@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180323110855.51989894@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 23, 2018 at 11:08:55AM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 23 Mar 2018 11:07:42 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> 
> > Em Fri, 23 Mar 2018 15:48:41 +0200
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > 
> > > An older version of the driver patches were merged accidentally which
> > > resulted in missing the array_size parameter that tells the length of the
> > > array that contains the different supported sizes.
> > > 
> > > Bring it back to v4l2_find_nearest size and make the corresponding change
> > > for the drivers using it as well.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > > Hi Mauro,
> > > 
> > > Here's the patch I mentioned. It restores the intended state of the
> > > v4l2_find_nearest_size() API as it was reviewed and acked (by Hans).
> > > 
> > > This time the exact patch is tested for vivid.
> > > 
> > >  drivers/media/i2c/ov13858.c                  | 5 +++--
> > >  drivers/media/i2c/ov5670.c                   | 5 +++--
> > >  drivers/media/platform/vivid/vivid-vid-cap.c | 5 +++--
> > >  include/media/v4l2-common.h                  | 5 +++--
> > >  4 files changed, 12 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
> > > index 30ee9f71bf0d..420af1e32d4e 100644
> > > --- a/drivers/media/i2c/ov13858.c
> > > +++ b/drivers/media/i2c/ov13858.c
> > > @@ -1375,8 +1375,9 @@ ov13858_set_pad_format(struct v4l2_subdev *sd,
> > >  	if (fmt->format.code != MEDIA_BUS_FMT_SGRBG10_1X10)
> > >  		fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
> > >  
> > > -	mode = v4l2_find_nearest_size(supported_modes, width, height,
> > > -				      fmt->format.width, fmt->format.height);
> > > +	mode = v4l2_find_nearest_size(
> > > +		supported_modes, ARRAY_SIZE(supported_modes), width, height,
> > > +		fmt->format.width, fmt->format.height);  
> > 
> > 
> > Nitpick... I find ugly and arder to mentally parse things like the above,

Ok, I'll send v2.

> 
> 	"arder" -> "harder"
> 
> My keyboard sometimes is losing keystrokes. It seems it is approaching
> the time to replace it again.

Perhaps an IBM model M? I once tried one but my fingers started to ache.
:-9 So I'm still using my Keytronic keyboard from 1994. :-D

-- 
Cheers,

Sakari Ailus
sakari.ailus@linux.intel.com

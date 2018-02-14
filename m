Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35014 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032907AbeBNRCQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 12:02:16 -0500
Date: Wed, 14 Feb 2018 15:02:10 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 2/9] media: convert g/s_parm to g/s_frame_interval in
 subdevs
Message-ID: <20180214150210.1011f331@vento.lan>
In-Reply-To: <959ca281-d231-0202-a0dc-89605a8270bb@xs4all.nl>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
        <20180122123125.24709-3-hverkuil@xs4all.nl>
        <20180214140257.1bfd266f@vento.lan>
        <959ca281-d231-0202-a0dc-89605a8270bb@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 14 Feb 2018 17:34:17 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 14/02/18 17:03, Mauro Carvalho Chehab wrote:
> > Em Mon, 22 Jan 2018 13:31:18 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Convert all g/s_parm calls to g/s_frame_interval. This allows us
> >> to remove the g/s_parm ops since those are a duplicate of
> >> g/s_frame_interval.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/i2c/mt9v011.c                     | 31 +++++++-------------
> >>  drivers/media/i2c/ov6650.c                      | 35 +++++++++-------------
> >>  drivers/media/i2c/ov7670.c                      | 24 +++++++--------
> >>  drivers/media/i2c/ov7740.c                      | 31 +++++++-------------
> >>  drivers/media/i2c/tvp514x.c                     | 39 +++++++++----------------
> >>  drivers/media/i2c/vs6624.c                      | 29 +++++++-----------
> >>  drivers/media/platform/atmel/atmel-isc.c        | 10 ++-----
> >>  drivers/media/platform/atmel/atmel-isi.c        | 12 ++------
> >>  drivers/media/platform/blackfin/bfin_capture.c  | 14 +++------
> >>  drivers/media/platform/marvell-ccic/mcam-core.c | 12 ++++----
> >>  drivers/media/platform/soc_camera/soc_camera.c  | 10 ++++---
> >>  drivers/media/platform/via-camera.c             |  4 +--
> >>  drivers/media/usb/em28xx/em28xx-video.c         | 36 +++++++++++++++++++----
> >>  13 files changed, 122 insertions(+), 165 deletions(-)
> >>
> >> diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
> >> index 5e29064fae91..3e23c5b0de1f 100644
> >> --- a/drivers/media/i2c/mt9v011.c
> >> +++ b/drivers/media/i2c/mt9v011.c
> >> @@ -364,33 +364,24 @@ static int mt9v011_set_fmt(struct v4l2_subdev *sd,
> >>  	return 0;
> >>  }
> >>  
> >> -static int mt9v011_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
> >> +static int mt9v011_g_frame_interval(struct v4l2_subdev *sd,
> >> +				    struct v4l2_subdev_frame_interval *ival)
> >>  {
> >> -	struct v4l2_captureparm *cp = &parms->parm.capture;
> >> -
> >> -	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >> -		return -EINVAL;
> >> -
> >> -	memset(cp, 0, sizeof(struct v4l2_captureparm));
> >> -	cp->capability = V4L2_CAP_TIMEPERFRAME;
> >> +	memset(ival->reserved, 0, sizeof(ival->reserved));  
> > 
> > Hmm.. why to repeat memset everywhere? If the hole idea is to stop abusing,
> > the best would be to do, instead:  
> 
> g_frame_interval is called by bridge drivers through the subdev ops. So that
> path doesn't go through subdev_do_ioctl(). So it doesn't help putting it in
> v4l2-subdev.c.

True, but you could also do the same for v4l2 ioctl() handling logic.

That would mean just two places with memset() instead of repeating the same
pattern everywhere.

> That doesn't mean it shouldn't be there as well. I believe my MC patch series
> actually adds the memset in subdev_do_ioctl.
> 
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> > index c5639817db34..b18b418c080f 100644
> > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > @@ -350,6 +350,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
> >  		if (fi->pad >= sd->entity.num_pads)
> >  			return -EINVAL;
> >  
> > +		memset(fi->reserved, 0, sizeof(ival->reserved));
> >  		return v4l2_subdev_call(sd, video, g_frame_interval, arg);
> >  	}
> >  
> > (same applies to s_frame_interval).
> > 
> >   
> >>  	calc_fps(sd,
> >> -		 &cp->timeperframe.numerator,
> >> -		 &cp->timeperframe.denominator);
> >> +		 &ival->interval.numerator,
> >> +		 &ival->interval.denominator);
> >>  
> >>  	return 0;
> >>  }
> >>  
> >> -static int mt9v011_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
> >> +static int mt9v011_s_frame_interval(struct v4l2_subdev *sd,
> >> +				    struct v4l2_subdev_frame_interval *ival)
> >>  {
> >> -	struct v4l2_captureparm *cp = &parms->parm.capture;
> >> -	struct v4l2_fract *tpf = &cp->timeperframe;
> >> +	struct v4l2_fract *tpf = &ival->interval;
> >>  	u16 speed;
> >>  
> >> -	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >> -		return -EINVAL;
> >> -	if (cp->extendedmode != 0)
> >> -		return -EINVAL;
> >> -  
> > 
> > Hmm... why are you removing those sanity checks everywhere?
> > The core doesn't do it.
> > 
> > All the above comments also apply to the other files modified by
> > this patch.  
> 
> struct v4l2_subdev_frame_interval has neither type nor extendedmode.
> 
> The check for type is done in the v4l2_g/s_parm_cap helpers instead.

Well, the subdev handler at v4l2-subdev.c doesn't seem to be checking it.


> And extendedmode is always set to 0.
> 
> >   
> >> +	memset(ival->reserved, 0, sizeof(ival->reserved));
> >>  	speed = calc_speed(sd, tpf->numerator, tpf->denominator);
> >>  
> >>  	mt9v011_write(sd, R0A_MT9V011_CLK_SPEED, speed);
> >> @@ -469,8 +460,8 @@ static const struct v4l2_subdev_core_ops mt9v011_core_ops = {
> >>  };
> >>  
> >>  static const struct v4l2_subdev_video_ops mt9v011_video_ops = {
> >> -	.g_parm = mt9v011_g_parm,
> >> -	.s_parm = mt9v011_s_parm,
> >> +	.g_frame_interval = mt9v011_g_frame_interval,
> >> +	.s_frame_interval = mt9v011_s_frame_interval,
> >>  };
> >>  
> >>  static const struct v4l2_subdev_pad_ops mt9v011_pad_ops = {
> >> diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
> >> index 8975d16b2b24..3f962dae7534 100644
> >> --- a/drivers/media/i2c/ov6650.c
> >> +++ b/drivers/media/i2c/ov6650.c
> >> @@ -201,7 +201,7 @@ struct ov6650 {
> >>  	struct v4l2_rect	rect;		/* sensor cropping window */
> >>  	unsigned long		pclk_limit;	/* from host */
> >>  	unsigned long		pclk_max;	/* from resolution and format */
> >> -	struct v4l2_fract	tpf;		/* as requested with s_parm */
> >> +	struct v4l2_fract	tpf;		/* as requested with s_frame_interval */
> >>  	u32 code;
> >>  	enum v4l2_colorspace	colorspace;
> >>  };
> >> @@ -723,42 +723,33 @@ static int ov6650_enum_mbus_code(struct v4l2_subdev *sd,
> >>  	return 0;
> >>  }
> >>  
> >> -static int ov6650_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
> >> +static int ov6650_g_frame_interval(struct v4l2_subdev *sd,
> >> +				   struct v4l2_subdev_frame_interval *ival)
> >>  {
> >>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >>  	struct ov6650 *priv = to_ov6650(client);
> >> -	struct v4l2_captureparm *cp = &parms->parm.capture;
> >>  
> >> -	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >> -		return -EINVAL;
> >> -
> >> -	memset(cp, 0, sizeof(*cp));
> >> -	cp->capability = V4L2_CAP_TIMEPERFRAME;
> >> -	cp->timeperframe.numerator = GET_CLKRC_DIV(to_clkrc(&priv->tpf,
> >> +	memset(ival->reserved, 0, sizeof(ival->reserved));
> >> +	ival->interval.numerator = GET_CLKRC_DIV(to_clkrc(&priv->tpf,
> >>  			priv->pclk_limit, priv->pclk_max));
> >> -	cp->timeperframe.denominator = FRAME_RATE_MAX;
> >> +	ival->interval.denominator = FRAME_RATE_MAX;
> >>  
> >>  	dev_dbg(&client->dev, "Frame interval: %u/%u s\n",
> >> -		cp->timeperframe.numerator, cp->timeperframe.denominator);
> >> +		ival->interval.numerator, ival->interval.denominator);  
> > 
> > Hmm... not sure if a debug is needed here. Yet, if this is needed, 
> > IMHO, it would make mroe sense to move it to the core.  
> 
> The core doesn't see this if this subdev op is called from a bridge driver.

True, but, when calling via a bridge driver, there's already a way to
enable such kind debug.


Thanks,
Mauro

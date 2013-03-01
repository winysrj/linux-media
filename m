Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2837 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3CALZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 06:25:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC PATCH 10/18] s5p-tv: add dv_timings support for hdmiphy.
Date: Fri, 1 Mar 2013 12:25:16 +0100
Cc: linux-media@vger.kernel.org,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl> <c1ace44350055629138909c9a16a566f36add130.1361006882.git.hans.verkuil@cisco.com> <51308AB6.3090309@samsung.com>
In-Reply-To: <51308AB6.3090309@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303011225.16786.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 1 2013 12:02:14 Tomasz Stanislawski wrote:
> Hi Hans,
> Please refer to the comments below.
> 
> On 02/16/2013 10:28 AM, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This just adds dv_timings support without modifying existing dv_preset
> > support, although I had to refactor a little bit in order to share
> > hdmiphy_find_conf() between the preset and timings code.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/platform/s5p-tv/hdmiphy_drv.c |   48 ++++++++++++++++++++++-----
> >  1 file changed, 39 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
> > index 80717ce..85b4211 100644
> > --- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
> > +++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
> > @@ -197,14 +197,9 @@ static unsigned long hdmiphy_preset_to_pixclk(u32 preset)
> >  		return 0;
> >  }
> >  
> > -static const u8 *hdmiphy_find_conf(u32 preset, const struct hdmiphy_conf *conf)
> > +static const u8 *hdmiphy_find_conf(unsigned long pixclk,
> > +		const struct hdmiphy_conf *conf)
> >  {
> > -	unsigned long pixclk;
> > -
> > -	pixclk = hdmiphy_preset_to_pixclk(preset);
> > -	if (!pixclk)
> > -		return NULL;
> > -
> >  	for (; conf->pixclk; ++conf)
> >  		if (conf->pixclk == pixclk)
> >  			return conf->data;
> > @@ -220,15 +215,49 @@ static int hdmiphy_s_power(struct v4l2_subdev *sd, int on)
> >  static int hdmiphy_s_dv_preset(struct v4l2_subdev *sd,
> >  	struct v4l2_dv_preset *preset)
> >  {
> > -	const u8 *data;
> > +	const u8 *data = NULL;
> >  	u8 buffer[32];
> >  	int ret;
> >  	struct hdmiphy_ctx *ctx = sd_to_ctx(sd);
> >  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +	unsigned long pixclk;
> >  	struct device *dev = &client->dev;
> >  
> >  	dev_info(dev, "s_dv_preset(preset = %d)\n", preset->preset);
> > -	data = hdmiphy_find_conf(preset->preset, ctx->conf_tab);
> > +
> > +	pixclk = hdmiphy_preset_to_pixclk(preset->preset);
> 
> Just nitpicking.
> The pixclk might be 0 is the preset is not supported hdmiphy.
> For some platforms not all frequencies are supported.
> Anyway, if pixclk is 0 then hdmiphy_find_conf will detect it.

I'll add a comment clarifying this. I actually was relying on find_conf
to handle the 0 case.

> > +	data = hdmiphy_find_conf(pixclk, ctx->conf_tab);
> > +	if (!data) {
> > +		dev_err(dev, "format not supported\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* storing configuration to the device */
> > +	memcpy(buffer, data, 32);
> > +	ret = i2c_master_send(client, buffer, 32);
> > +	if (ret != 32) {
> > +		dev_err(dev, "failed to configure HDMIPHY via I2C\n");
> > +		return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int hdmiphy_s_dv_timings(struct v4l2_subdev *sd,
> > +	struct v4l2_dv_timings *timings)
> > +{
> > +	const u8 *data;
> > +	u8 buffer[32];
> > +	int ret;
> > +	struct hdmiphy_ctx *ctx = sd_to_ctx(sd);
> > +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +	struct device *dev = &client->dev;
> > +	unsigned long pixclk = timings->bt.pixelclock;
> > +
> > +	dev_info(dev, "s_dv_timings\n");
> 
> Using test against V4L2_DV_FL_REDUCED_FPS and 74250000 looks little hacky to me.
> Why there is no such a check for 148500000 and 27000000 (REDUCED -> INCREASED?).

Because that was not supported by the original code. I have no idea whether 1080p59.94
is supported or not, or what pixelclock should be used in that case. So I faithfully
reproduced the original functionality.

BTW, it is 'reduced': 74.25 MHz is for 30 fps, 74.176 is for 29.97 fps. Also, REDUCED_FPS
doesn't apply to the 27 MHz case which is always 29.97 fps in the NTSC resolution
case.

> Maybe it will be better to past both timings->bt.pixelclock and timings->bt.flags
> as parameters for hdmiphy_find_conf function. The hdmiphy_find_conf could
> perform pixclk adjustment or some fallback policy based on the flags.

I really prefer to keep the same functionality. I don't want to make changes
to the existing functionality, partially to make it easier to prevent
regressions, partially because I don't have the setup anyway to test this if
I add functionality.

But feel free to provide an additional patch doing this :-)

Regards,

	Hans

> 
> > +	if ((timings->bt.flags & V4L2_DV_FL_REDUCED_FPS) && pixclk == 74250000)
> > +		pixclk = 74176000;
> > +	data = hdmiphy_find_conf(pixclk, ctx->conf_tab);
> >  	if (!data) {
> >  		dev_err(dev, "format not supported\n");
> >  		return -EINVAL;
> > @@ -271,6 +300,7 @@ static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
> >  
> >  static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
> >  	.s_dv_preset = hdmiphy_s_dv_preset,
> > +	.s_dv_timings = hdmiphy_s_dv_timings,
> >  	.s_stream =  hdmiphy_s_stream,
> >  };
> >  
> > 
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45929 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab2CPMbL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 08:31:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] mt9v032: Provide pixel rate control
Date: Fri, 16 Mar 2012 13:31:39 +0100
Message-ID: <2818545.mNbT3MTFRm@avalon>
In-Reply-To: <20120316121211.GB5412@valkosipuli.localdomain>
References: <1331845299-6147-1-git-send-email-sakari.ailus@iki.fi> <1834735.kIipVBG3Dt@avalon> <20120316121211.GB5412@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 16 March 2012 14:12:11 Sakari Ailus wrote:
> On Fri, Mar 16, 2012 at 12:58:30PM +0100, Laurent Pinchart wrote:
> > On Thursday 15 March 2012 23:01:39 Sakari Ailus wrote:
> > > Provide pixel rate control calculated from external clock and horizontal
> > > binning factor.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > > 
> > >  drivers/media/video/mt9v032.c |   35  ++++++++++++++++++++++++++++++++-
> > >  1 files changed, 34 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/mt9v032.c
> > > b/drivers/media/video/mt9v032.c
> > > index 75e253a..e530e8d 100644
> > > --- a/drivers/media/video/mt9v032.c
> > > +++ b/drivers/media/video/mt9v032.c

[snip]

> > > +static void mt9v032_configure_pixel_rate(struct v4l2_subdev *subdev,
> > > +					 unsigned int hratio)
> > > +{
> > > +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> > > +	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
> > > +	struct v4l2_ext_controls ctrls;
> > > +	struct v4l2_ext_control ctrl;
> > > +
> > > +	memset(&ctrls, 0, sizeof(ctrls));
> > > +	memset(&ctrl, 0, sizeof(ctrl));
> > > +
> > > +	ctrls.count = 1;
> > > +	ctrls.controls = &ctrl;
> > > +
> > > +	ctrl.id = V4L2_CID_PIXEL_RATE;
> > > +	ctrl.value64 = EXT_CLK / hratio;
> > > +
> > > +	if (v4l2_s_ext_ctrls(mt9v032->pixel_rate->ctrl_handler, &ctrls) < 0)
> > > +		dev_warn(&client->dev, "bug: failed to set pixel rate\n");
> > 
> > What about just calling v4l2_ctrl_s_ctrl() ?
> 
> It's a 64-bit integer control, so it has to be set using v4l2_s_ext_ctrls().

What about extending v4l2_ctrl_s_ctrl() to support 64-bit integer controls 
then ?

> > > +}

[snip]

> > > @@ -695,6 +723,9 @@ static int mt9v032_probe(struct i2c_client *client,
> > > 
> > >  			  V4L2_CID_EXPOSURE, MT9V032_TOTAL_SHUTTER_WIDTH_MIN,
> > >  			  MT9V032_TOTAL_SHUTTER_WIDTH_MAX, 1,
> > >  			  MT9V032_TOTAL_SHUTTER_WIDTH_DEF);
> > > 
> > > +	mt9v032->pixel_rate =
> > > +		v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
> > > +				  V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
> > 
> > Shouldn't you set the bounds to [EXT_CLK/4..EXT_CLK] ? Otherwise the set
> > control call will likely fail. We probably need a new control framework
> > function to modify the bounds.
> 
> Same here. 64-bit controls don't have min/max.

Right, my bad.

> > >  	for (i = 0; i < ARRAY_SIZE(mt9v032_ctrls); ++i)
> > >  	
> > >  		v4l2_ctrl_new_custom(&mt9v032->ctrls, &mt9v032_ctrls[i], NULL);
> > > 

-- 
Regards,

Laurent Pinchart


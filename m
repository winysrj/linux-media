Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48065 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2CPNH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 09:07:26 -0400
Date: Fri, 16 Mar 2012 15:07:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] mt9v032: Provide pixel rate control
Message-ID: <20120316130718.GD5412@valkosipuli.localdomain>
References: <1331845299-6147-1-git-send-email-sakari.ailus@iki.fi>
 <2818545.mNbT3MTFRm@avalon>
 <20120316123653.GC5412@valkosipuli.localdomain>
 <1762135.yeoBRAyros@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1762135.yeoBRAyros@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 16, 2012 at 01:55:13PM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Friday 16 March 2012 14:36:53 Sakari Ailus wrote:
> > On Fri, Mar 16, 2012 at 01:31:39PM +0100, Laurent Pinchart wrote:
> > > On Friday 16 March 2012 14:12:11 Sakari Ailus wrote:
> > > > On Fri, Mar 16, 2012 at 12:58:30PM +0100, Laurent Pinchart wrote:
> > > > > On Thursday 15 March 2012 23:01:39 Sakari Ailus wrote:
> > > > > > Provide pixel rate control calculated from external clock and
> > > > > > horizontal
> > > > > > binning factor.
> > > > > > 
> > > > > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > > > > ---
> > > > > > 
> > > > > >  drivers/media/video/mt9v032.c |   35 
> > > > > >  ++++++++++++++++++++++++++++++++-
> > > > > >  1 files changed, 34 insertions(+), 1 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/media/video/mt9v032.c
> > > > > > b/drivers/media/video/mt9v032.c
> > > > > > index 75e253a..e530e8d 100644
> > > > > > --- a/drivers/media/video/mt9v032.c
> > > > > > +++ b/drivers/media/video/mt9v032.c
> > > 
> > > [snip]
> > > 
> > > > > > +static void mt9v032_configure_pixel_rate(struct v4l2_subdev
> > > > > > *subdev,
> > > > > > +					 unsigned int hratio)
> > > > > > +{
> > > > > > +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> > > > > > +	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
> > > > > > +	struct v4l2_ext_controls ctrls;
> > > > > > +	struct v4l2_ext_control ctrl;
> > > > > > +
> > > > > > +	memset(&ctrls, 0, sizeof(ctrls));
> > > > > > +	memset(&ctrl, 0, sizeof(ctrl));
> > > > > > +
> > > > > > +	ctrls.count = 1;
> > > > > > +	ctrls.controls = &ctrl;
> > > > > > +
> > > > > > +	ctrl.id = V4L2_CID_PIXEL_RATE;
> > > > > > +	ctrl.value64 = EXT_CLK / hratio;
> > > > > > +
> > > > > > +	if (v4l2_s_ext_ctrls(mt9v032->pixel_rate->ctrl_handler, &ctrls) 
> <
> > > > > > 0)
> > > > > > +		dev_warn(&client->dev, "bug: failed to set pixel rate\n");
> > > > > 
> > > > > What about just calling v4l2_ctrl_s_ctrl() ?
> > > > 
> > > > It's a 64-bit integer control, so it has to be set using
> > > > v4l2_s_ext_ctrls().> 
> > > What about extending v4l2_ctrl_s_ctrl() to support 64-bit integer controls
> > > then ?
> > 
> > The second argument to that function is struct v4l2_control:
> > 
> > struct v4l2_control {
> >         __u32                id;
> >         __s32                value;
> > };
> > 
> > So there's no chance to extend it. This must also be the reason why 64-bit
> > controls require using extended controls.
> > 
> > What we could do is to introduce v4l2_s_ext_ctrl without the "s" in the end
> > to just set one extended control. I think that would be a reasonable
> > approach, as it seems we need the functionality in multiple places.
> 
> We're talking about different functions.

Oh, I noticed that now. :-)

> int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
> 
> Extending that one wouldn't break the userspace API. We could use s64 instead 
> of s32, or add a new function such as v4l2_ctrl_s_ctrl64().

I think I'd go for another function.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

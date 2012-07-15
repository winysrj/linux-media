Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59242 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2GONbl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 09:31:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 9/9] soc-camera: Push probe-time power management to drivers
Date: Sun, 15 Jul 2012 15:31:44 +0200
Message-ID: <2300956.kEgUObWrfG@avalon>
In-Reply-To: <Pine.LNX.4.64.1207101329450.29825@axis700.grange>
References: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com> <1341520728-2707-10-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1207101329450.29825@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 10 July 2012 14:06:51 Guennadi Liakhovetski wrote:
> On Thu, 5 Jul 2012, Laurent Pinchart wrote:
> > Several client drivers access the hardware at probe time, for instance
> > to read the probe chip ID. Such chips need to be powered up when being
> > probed.
> > 
> > soc-camera handles this by powering chips up in the soc-camera probe
> > implementation. However, this will break with non soc-camera hosts that
> > don't perform the same operations.
> > 
> > Fix the problem by pushing the power up/down from the soc-camera core
> > down to individual drivers on a needs basis.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/imx074.c     |   21 ++++++++--
> >  drivers/media/video/mt9m001.c    |   17 +++++++-
> >  drivers/media/video/mt9m111.c    |   80  ++++++++++++++++++--------------
> >  drivers/media/video/mt9t031.c    |   37 +++++++----------
> >  drivers/media/video/mt9t112.c    |   12 +++++-
> >  drivers/media/video/mt9v022.c    |    5 ++
> >  drivers/media/video/ov2640.c     |   11 ++++-
> >  drivers/media/video/ov5642.c     |   21 ++++++++--
> >  drivers/media/video/ov6650.c     |   19 ++++++---
> >  drivers/media/video/ov772x.c     |   14 ++++++-
> >  drivers/media/video/ov9640.c     |   17 ++++++--
> >  drivers/media/video/ov9740.c     |   23 +++++++----
> >  drivers/media/video/rj54n1cb0c.c |   18 ++++++--
> >  drivers/media/video/soc_camera.c |   20 ---------
> >  drivers/media/video/tw9910.c     |   12 +++++-
> >  15 files changed, 204 insertions(+), 123 deletions(-)
> 
> [snip]
> 
> > diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> > index 9666e20..4f12177 100644
> > --- a/drivers/media/video/mt9t031.c
> > +++ b/drivers/media/video/mt9t031.c
> > @@ -161,14 +161,6 @@ static int mt9t031_idle(struct i2c_client *client)
> > 
> >  	return ret >= 0 ? 0 : -EIO;
> >  
> >  }
> > 
> > -static int mt9t031_disable(struct i2c_client *client)
> > -{
> > -	/* Disable the chip */
> > -	reg_clear(client, MT9T031_OUTPUT_CONTROL, 2);
> > -
> > -	return 0;
> > -}
> > -
> > 
> >  static int mt9t031_s_stream(struct v4l2_subdev *sd, int enable)
> >  {
> >  
> >  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > 
> > @@ -643,9 +635,15 @@ static int mt9t031_video_probe(struct i2c_client
> > *client)> 
> >  	s32 data;
> >  	int ret;
> > 
> > -	/* Enable the chip */
> > -	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
> > -	dev_dbg(&client->dev, "write: %d\n", data);
> > +	ret = mt9t031_s_power(&mt9t031->subdev, 1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = mt9t031_idle(client);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "Failed to initialise the camera\n");
> > +		return ret;
> 
> grm... don't you have to "goto done" here instead to disable the power
> again?

Sorry about that one. Will fix.

> > +	}
> > 
> >  	/* Read out the chip version register */
> >  	data = reg_read(client, MT9T031_CHIP_VERSION);
> > 
> > @@ -657,16 +655,16 @@ static int mt9t031_video_probe(struct i2c_client
> > *client)> 
> >  	default:
> >  		dev_err(&client->dev,
> >  		
> >  			"No MT9T031 chip detected, register read %x\n", data);
> > 
> > -		return -ENODEV;
> > +		ret = -ENODEV;
> > +		goto done;
> > 
> >  	}
> >  	
> >  	dev_info(&client->dev, "Detected a MT9T031 chip ID %x\n", data);
> > 
> > -	ret = mt9t031_idle(client);
> > -	if (ret < 0)
> > -		dev_err(&client->dev, "Failed to initialise the camera\n");
> > -	else
> > -		v4l2_ctrl_handler_setup(&mt9t031->hdl);
> > +	ret = v4l2_ctrl_handler_setup(&mt9t031->hdl);
> > +
> > +done:
> > +	mt9t031_s_power(&mt9t031->subdev, 0);
> > 
> >  	return ret;
> >  
> >  }
> > 

-- 
Regards,

Laurent Pinchart


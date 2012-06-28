Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45615 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2F1J0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 05:26:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 8/8] soc-camera: Push probe-time power management to drivers
Date: Thu, 28 Jun 2012 11:26:15 +0200
Message-ID: <1618156.AEBvp8RseM@avalon>
In-Reply-To: <Pine.LNX.4.64.1206212319470.3513@axis700.grange>
References: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com> <1337786855-28759-9-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1206212319470.3513@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the review.

On Friday 22 June 2012 13:23:23 Guennadi Liakhovetski wrote:
> On Wed, 23 May 2012, Laurent Pinchart wrote:
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
> >  drivers/media/video/mt9t031.c    |   18 ++++++---
> >  drivers/media/video/mt9t112.c    |   12 +++++-
> >  drivers/media/video/mt9v022.c    |    5 ++
> >  drivers/media/video/ov2640.c     |   11 ++++-
> >  drivers/media/video/ov5642.c     |   21 ++++++++--
> >  drivers/media/video/ov6650.c     |   19 ++++++---
> >  drivers/media/video/ov772x.c     |   14 ++++++-
> >  drivers/media/video/ov9640.c     |   17 ++++++--
> >  drivers/media/video/ov9740.c     |   23 +++++++----
> >  drivers/media/video/rj54n1cb0c.c |   18 ++++++--
> >  drivers/media/video/soc_camera.c |   14 -------
> >  drivers/media/video/tw9910.c     |   12 +++++-
> >  15 files changed, 201 insertions(+), 101 deletions(-)
> > 
> > diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
> > index 1166c89..fc86e68 100644
> > --- a/drivers/media/video/imx074.c
> > +++ b/drivers/media/video/imx074.c

[snip]

> > @@ -414,7 +421,11 @@ static int imx074_video_probe(struct i2c_client
> > *client)
> >  	reg_write(client, GROUPED_PARAMETER_HOLD, 0x00);	/* off */
> 
> Looking at this and other soc-camera sensor drivers, most of them do some
> initialisation during probe(), that is not automatically re-applied at any
> point during operation. This means, the current power switching in
> soc-camera core, turning clients off directly after probe() and after each
> last close() only works with "soft" power off variants, e.g., where the
> board only switches off analog parts of a camera sensor and preserves
> register contents. There are indeed multiple boards currently in the
> mainline, implementing the soc_camera_link::power() callback. This means,
> they all either only do the soft power-off, or have been lucky to not need
> any of the lost register contents.
> 
> The v4l2_subdev_core_ops::s_power() operation is documented as
> 
>    s_power: puts subdevice in power saving mode (on == 0) or normal
> operation mode (on == 1).
> 
> "power saving mode" means pretty much the same to me - switch off power
> consuming parts, but keep register contents. So, I think, we're fine here
> just "mechanically" bringing over the power switching functionality into
> client drivers, we might only want to improve struct soc_camera_link
> documentation :-)

That should be doable :-)

> > -	return 0;
> > +	ret = 0;
> > +
> > +done:
> > +	imx074_s_power(subdev, 0);
> > +	return ret;

[snip]

> > +/*
> > + * Interface active, can use i2c. If it fails, it can indeed mean, that
> > + * this wasn't our capture interface, so, we wait for the right one
> > + */
> > +static int mt9m111_video_probe(struct i2c_client *client)
> > +{
> > +	struct mt9m111 *mt9m111 = to_mt9m111(client);
> > +	s32 data;
> > +	int ret;
> > +
> > +	ret = mt9m111_s_power(&mt9m111->subdev, 1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	data = reg_read(CHIP_VERSION);
> > +
> > +	switch (data) {
> > +	case 0x143a: /* MT9M111 or MT9M131 */
> > +		mt9m111->model = V4L2_IDENT_MT9M111;
> > +		dev_info(&client->dev,
> > +			"Detected a MT9M111/MT9M131 chip ID %x\n", data);
> > +		break;
> > +	case 0x148c: /* MT9M112 */
> > +		mt9m111->model = V4L2_IDENT_MT9M112;
> > +		dev_info(&client->dev, "Detected a MT9M112 chip ID %x\n", data);
> > +		break;
> > +	default:
> > +		dev_err(&client->dev,
> > +			"No MT9M111/MT9M112/MT9M131 chip detected register read 
%x\n",
> > +			data);
> > +		ret = -ENODEV;
> > +		goto done;
> > +	}
> > +
> > +	ret = mt9m111_init(mt9m111);
> > +	if (ret)
> > +		goto done;
> > +
> > +	ret = v4l2_ctrl_handler_setup(&mt9m111->hdl);
> 
> You're losing this return code...
> 
> > +
> > +done:
> > +	ret = mt9m111_s_power(&mt9m111->subdev, 0);
> > +	return ret;
> 
> 	return mt9m111_s_power(&mt9m111->subdev, 0);
> 
> But in mt9m001 you discard return code from *_s_power(0) and return the
> error from v4l2_ctrl_handler_setup(). Better be consistent, IMHO.

My bad, I'll fix that.

> > +}
> > +
> > 
> >  static int mt9m111_probe(struct i2c_client *client,
> >  			 const struct i2c_device_id *did)
> >  {
> > diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> > index 9666e20..56dd31c 100644
> > --- a/drivers/media/video/mt9t031.c
> > +++ b/drivers/media/video/mt9t031.c
> > @@ -643,6 +643,12 @@ static int mt9t031_video_probe(struct i2c_client
> > *client)> 
> >  	s32 data;
> >  	int ret;
> > 
> > +	ret = mt9t031_s_power(&mt9t031->subdev, 1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	mt9t031_idle(client);
> > +
> 
> There's one more call to mt9t031_idle() a couple of lines down in
> mt9t031_video_probe()... I think, the latter one can be dropped
> together with...
> 
> >  	/* Enable the chip */
> >  	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
> 
> the one above - it starts the read-out, which we don't necessarily want
> immediately after probe(), and it is anyway disabled again a few lines
> further down in mt9t031_disable().

I'll remove the chip enable, the second call to mt9t031_idle(), and the call 
to mt9t031_disable() as the first mt9t031_idle() has already disabled the 
chip.

-- 
Regards,

Laurent Pinchart


Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52983 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab2F0XB4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 19:01:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8] soc-camera: Add and use soc_camera_power_[on|off]() helper functions
Date: Thu, 28 Jun 2012 01:01:59 +0200
Message-ID: <1392195.aTfbvqOaS8@avalon>
In-Reply-To: <Pine.LNX.4.64.1206211645430.3513@axis700.grange>
References: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com> <1337786855-28759-8-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1206211645430.3513@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the review.

On Thursday 21 June 2012 23:15:14 Guennadi Liakhovetski wrote:
> On Wed, 23 May 2012, Laurent Pinchart wrote:
> > Instead of forcing all soc-camera drivers to go through the mid-layer to
> > handle power management, create soc_camera_power_[on|off]() functions
> > that can be called from the subdev .s_power() operation to manage
> > regulators and platform-specific power handling. This allows non
> > soc-camera hosts to use soc-camera-aware clients.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[snip]

> > diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
> > index 351e9ba..1166c89 100644
> > --- a/drivers/media/video/imx074.c
> > +++ b/drivers/media/video/imx074.c
> > @@ -268,6 +268,17 @@ static int imx074_g_chip_ident(struct v4l2_subdev

[snip]

> > +static int imx074_s_power(struct v4l2_subdev *sd, int on)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
> > +
> > +	if (on)
> > +		return soc_camera_power_on(&client->dev, icl);
> > +	else
> > +		return soc_camera_power_off(&client->dev, icl);
> 
> I think an inline function would be nice for these to just write in most
> of your converted drivers
> 
> 	return soc_camera_s_power(&client->dev, icl, on);

OK.

> > +}

[snip]

> > diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> > index b0c5299..b9bfb4f 100644
> > --- a/drivers/media/video/mt9m111.c
> > +++ b/drivers/media/video/mt9m111.c
> > @@ -832,10 +832,35 @@ static int mt9m111_video_probe(struct i2c_client
> > *client)> 
> >  	return v4l2_ctrl_handler_setup(&mt9m111->hdl);
> >  
> >  }
> > 
> > +static int mt9m111_power_on(struct mt9m111 *mt9m111)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
> > +	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
> > +	int ret;
> > +
> > +	ret = soc_camera_power_on(&client->dev, icl);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = mt9m111_resume(mt9m111);
> > +	if (ret < 0)
> > +		dev_err(&client->dev, "Failed to resume the sensor: %d\n", ret);
> 
> What do you think, don't we have to soc_camera_power_off() if the above
> resume fails? At least I was doing that in the original
> soc_camera_power_on() and you also preserve it that way.

I agree. I'll fix that.

> > +
> > +	return ret;
> > +}

[snip]

> > diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
> > index 0bc9331..98de102 100644
> > --- a/drivers/media/video/ov5642.c
> > +++ b/drivers/media/video/ov5642.c
> > @@ -933,13 +933,20 @@ static int ov5642_g_mbus_config(struct v4l2_subdev
> > *sd,> 
> >  static int ov5642_s_power(struct v4l2_subdev *sd, int on)
> >  {
> > -	struct i2c_client *client;
> > +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
> >  	int ret;
> > 
> > +	if (on)
> > +		ret = soc_camera_power_on(&client->dev, icl);
> > +	else
> > +		ret = soc_camera_power_off(&client->dev, icl);
> > +	if (ret < 0)
> > +		return ret;
> > +
> >  	if (!on)
> >  		return 0;
> 
> How about
> 
> 	if (!on)
> 		return soc_camera_power_off(&client->dev, icl);
> 
> 	ret = soc_camera_power_on(&client->dev, icl);
> 	if (ret < 0)
> 		...

That looks good to me.

> > -	client = v4l2_get_subdevdata(sd);
> > 
> >  	ret = ov5642_write_array(client, ov5642_default_regs_init);
> >  	if (!ret)
> >  		ret = ov5642_set_resolution(sd);
> > 

[snip]

> > diff --git a/drivers/media/video/sh_mobile_csi2.c
> > b/drivers/media/video/sh_mobile_csi2.c index 0528650..88c6911 100644
> > --- a/drivers/media/video/sh_mobile_csi2.c
> > +++ b/drivers/media/video/sh_mobile_csi2.c
> > @@ -276,12 +276,20 @@ static void sh_csi2_client_disconnect(struct sh_csi2
> > *priv)> 
> >  static int sh_csi2_s_power(struct v4l2_subdev *sd, int on)
> >  {
> > +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
> >  	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
> > +	int ret;
> > 
> > -	if (on)
> > +	if (on) {
> > +		ret = soc_camera_power_on(&client->dev, icl);
> > +		if (ret < 0)
> > +			return ret;
> > 
> >  		return sh_csi2_client_connect(priv);
> > +	}
> > 
> >  	sh_csi2_client_disconnect(priv);
> > 
> > +	soc_camera_power_off(&client->dev, icl);
> > 
> >  	return 0;
> 
> Actually, I might have confused you on this one, sorry. This is not an
> external device, and as such it cannot have platform .s_power() callbacks
> or regulators to switch its power. So, maybe we don't have to patch this
> one at all?

Good, I'll skip it :-)

> >  }
> > 
> > diff --git a/drivers/media/video/soc_camera.c
> > b/drivers/media/video/soc_camera.c index 55b981f..6c50032 100644
> > --- a/drivers/media/video/soc_camera.c
> > +++ b/drivers/media/video/soc_camera.c

[snip]

> > -static int soc_camera_power_on(struct soc_camera_device *icd,
> > -			       struct soc_camera_link *icl)
> > +int soc_camera_power_on(struct device *dev, struct soc_camera_link *icl)
> > 
> >  {
> > 
> > -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > -	int ret = regulator_bulk_enable(icl->num_regulators,
> > -					icl->regulators);
> > +	int ret;
> > +
> > +	ret = regulator_bulk_enable(icl->num_regulators,
> > +				    icl->regulators);
> 
> Let's avoid purely stylistic changes ;-)

Next time I'll try to hide them better ;-)

[snip]

> > -static int soc_camera_power_off(struct soc_camera_device *icd,
> > -				struct soc_camera_link *icl)
> > +int soc_camera_power_off(struct device *dev, struct soc_camera_link *icl)
> >  {
> > -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > -	int ret = v4l2_subdev_call(sd, core, s_power, 0);
> > -
> > -	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> > -		return ret;
> > +	int ret;
> > 
> >  	if (icl->power) {
> > -		ret = icl->power(icd->control, 0);
> > -		if (ret < 0) {
> > -			dev_err(icd->pdev,
> > +		ret = icl->power(dev, 0);
> > +		if (ret < 0)
> > +			dev_err(dev,
> >  				"Platform failed to power-off the camera.\n");
> > -			return ret;
> > -		}
> >  	}
> >  	
> >  	ret = regulator_bulk_disable(icl->num_regulators,
> >  				     icl->regulators);
> 
> This is also a change in behaviour: currently if any of power-off stages
> fails we bail out. With this patch you change it to continue with the next
> stage. I'm not sure which one is more correct, but at least I wouldn't
> silently change it under the counter ;-)

During power off I think it's better to continue to the next stage. Would you 
like me to split this to another patch, or to mention it in the commit message 
?

> >  	if (ret < 0)
> > -		dev_err(icd->pdev, "Cannot disable regulators\n");
> > +		dev_err(dev, "Cannot disable regulators\n");
> > 
> >  	return ret;
> >  }

[snip]

> > @@ -1070,7 +1076,7 @@ static int soc_camera_probe(struct soc_camera_device
> > *icd)> 
> >  	 * again after initialisation, even though it shouldn't be needed, we
> >  	 * don't do any IO here.
> >  	 */
> > 
> > -	ret = soc_camera_power_on(icd, icl);
> > +	ret = soc_camera_power_on(NULL, icl);
> 
> Oops, no good... I think, at least dev_err() et al. don't like being
> called with NULL dev... But even without that, I think, this looks so bad,
> that it defeats the whole conversion... IIRC, you didn't like keeping the
> original soc-camera platform device pointer for icl->power(), because non
> soc-camera hosts and platforms don't have that device and would have to
> either pass NULL or some other device pointer. Now, we're switching all
> icl->power() calls to point to the physical device, which is largely
> useless also for soc-camera platforms (they'd have to go back to the
> original platform device if they wish to use that pointer at all), all -
> except one - in which we pass NULL... So, what's the point? :) I really
> would keep the soc-camera platform device pointer for icl->power().
> 
> There would be a slight difficulty to get to that pointer in
> soc_camera_power_*(). Just passing a subdevice pointer to it and using
> v4l2_get_subdev_hostdata(sd) isn't sufficient, because that would only
> work in the soc-camera environment. If the same client driver is running
> outside of it, v4l2_get_subdev_hostdata(sd) might well point to something
> completely different. So, we need a way to distinguish, whether this
> client is running on an soc-camera host or not. It is possible to have a
> system with two cameras - one connected to the SoC interface and another
> one to USB with both sensors using soc-camera services. Only one of them
> is associated with an soc-camera device, and another one is not. One way
> to distinguish this would be to scan the devices list in soc_camera.c to
> see, whether any icd->link == icl. If the client is found - we pass its
> platform device pointer to icl->power(). If not - pass NULL. The wrapper
> inline function would then become
> 
> 	return soc_camera_s_power(icl, on);
> 
> Do you see any problems with this approach?

If I had proposed such a hack I would have sworn you would have rejected it 
;-)

My first idea was to get rid of the device pointer completely. None of the 
platform callbacks use it. You didn't really like that, as it would make 
implementation of a future platform that would require the device pointer more 
complex. I've thus decided to switch to pass the physical struct device 
associated with the device to the power functions, down to the board code. I 
don't think board code would need to go back to the original platform device 
to discriminate between devices, checking the physical device properties (such 
as the I2C address or bus number for instance) should be enough.

With your approach we would pass a different device pointer to platform code 
depending on whether we use a soc-camera host or not. With non soc-camera 
hosts the device pointer would always be NULL, which wouldn't let board code 
discrimate between devices. That's not a good situation either.

I'm really beginning to wonder whether we're not trying to fix a problem that 
will go away in the future, as we'll need to find a way to remove the platform 
callbacks when switching to the device tree anyway. Wouldn't it be better to 
remove the device pointer completely ?

(As for the dev_* macros, we could pass the platform device pointer here, and 
the physical device pointer when the power functions are called from devices).

And now I've just remembered that patch 8/8 removes this soc_camera_power_on() 
completely, so the above argument just got pointless, hasn't it ? :-/

[snip]

> > diff --git a/drivers/media/video/soc_camera_platform.c
> > b/drivers/media/video/soc_camera_platform.c index f59ccad..efd85e7 100644
> > --- a/drivers/media/video/soc_camera_platform.c
> > +++ b/drivers/media/video/soc_camera_platform.c
> > @@ -50,7 +50,20 @@ static int soc_camera_platform_fill_fmt(struct
> > v4l2_subdev *sd,> 
> >  	return 0;
> >  
> >  }
> > 
> > -static struct v4l2_subdev_core_ops platform_subdev_core_ops;
> > +static int soc_camera_platform_s_power(struct v4l2_subdev *sd, int on)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> 
> Nnnnoo... soc_camera_platform is special - it doesn't (have to) have an
> i2c device associated with it.

Oops. You're right. This might be the result of copy and paste late at night.

> You're only guaranteed to have a subdevice and an struct
> soc_camera_platform_priv instance (the latter actually contains the former
> as its only member). But you have the advantage, that this driver always
> only runs under soc-camera. At least I hope noone ever comes up with an idea
> to use it outside of soc-camera ;-) So, if we accept my above proposal to
> use the platform device for soc_camera_power_*(), then you can use something
> like
> 
> 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
> 	soc_camera_s_power(p->icd->link, on);

A pointer to the physical device is stored at probe time in p->icd->control. 
What about

        struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);

        return soc_camera_set_power(p->icd->control, p->icd->link, on);

> > +	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
> > +
> > +	if (on)
> > +		return soc_camera_power_on(&client->dev, icl);
> > +	else
> > +		return soc_camera_power_off(&client->dev, icl);
> > +}

[snip]

> Let me know if you find any loose ends in my proposals.

-- 
Regards,

Laurent Pinchart


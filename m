Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2F2JGO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 05:06:14 -0400
Date: Fri, 29 Jun 2012 11:06:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8] soc-camera: Add and use soc_camera_power_[on|off]()
 helper functions
In-Reply-To: <1392195.aTfbvqOaS8@avalon>
Message-ID: <Pine.LNX.4.64.1206291014490.3929@axis700.grange>
References: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1337786855-28759-8-git-send-email-laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1206211645430.3513@axis700.grange> <1392195.aTfbvqOaS8@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 Jun 2012, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thanks for the review.
> 
> On Thursday 21 June 2012 23:15:14 Guennadi Liakhovetski wrote:
> > On Wed, 23 May 2012, Laurent Pinchart wrote:

> > > -static int soc_camera_power_off(struct soc_camera_device *icd,
> > > -				struct soc_camera_link *icl)
> > > +int soc_camera_power_off(struct device *dev, struct soc_camera_link *icl)
> > >  {
> > > -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > > -	int ret = v4l2_subdev_call(sd, core, s_power, 0);
> > > -
> > > -	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> > > -		return ret;
> > > +	int ret;
> > > 
> > >  	if (icl->power) {
> > > -		ret = icl->power(icd->control, 0);
> > > -		if (ret < 0) {
> > > -			dev_err(icd->pdev,
> > > +		ret = icl->power(dev, 0);
> > > +		if (ret < 0)
> > > +			dev_err(dev,
> > >  				"Platform failed to power-off the camera.\n");
> > > -			return ret;
> > > -		}
> > >  	}
> > >  	
> > >  	ret = regulator_bulk_disable(icl->num_regulators,
> > >  				     icl->regulators);
> > 
> > This is also a change in behaviour: currently if any of power-off stages
> > fails we bail out. With this patch you change it to continue with the next
> > stage. I'm not sure which one is more correct, but at least I wouldn't
> > silently change it under the counter ;-)
> 
> During power off I think it's better to continue to the next stage. Would you 
> like me to split this to another patch, or to mention it in the commit message 
> ?

Ok, since this patch is so big and touches so mane other drivers, I think 
it'd be cleaner splitting this into a separate patch, preferably - before 
this one.

> > > @@ -1070,7 +1076,7 @@ static int soc_camera_probe(struct soc_camera_device
> > > *icd)> 
> > >  	 * again after initialisation, even though it shouldn't be needed, we
> > >  	 * don't do any IO here.
> > >  	 */
> > > 
> > > -	ret = soc_camera_power_on(icd, icl);
> > > +	ret = soc_camera_power_on(NULL, icl);
> > 
> > Oops, no good... I think, at least dev_err() et al. don't like being
> > called with NULL dev... But even without that, I think, this looks so bad,
> > that it defeats the whole conversion... IIRC, you didn't like keeping the
> > original soc-camera platform device pointer for icl->power(), because non
> > soc-camera hosts and platforms don't have that device and would have to
> > either pass NULL or some other device pointer. Now, we're switching all
> > icl->power() calls to point to the physical device, which is largely
> > useless also for soc-camera platforms (they'd have to go back to the
> > original platform device if they wish to use that pointer at all), all -
> > except one - in which we pass NULL... So, what's the point? :) I really
> > would keep the soc-camera platform device pointer for icl->power().
> > 
> > There would be a slight difficulty to get to that pointer in
> > soc_camera_power_*(). Just passing a subdevice pointer to it and using
> > v4l2_get_subdev_hostdata(sd) isn't sufficient, because that would only
> > work in the soc-camera environment. If the same client driver is running
> > outside of it, v4l2_get_subdev_hostdata(sd) might well point to something
> > completely different. So, we need a way to distinguish, whether this
> > client is running on an soc-camera host or not. It is possible to have a
> > system with two cameras - one connected to the SoC interface and another
> > one to USB with both sensors using soc-camera services. Only one of them
> > is associated with an soc-camera device, and another one is not. One way
> > to distinguish this would be to scan the devices list in soc_camera.c to
> > see, whether any icd->link == icl. If the client is found - we pass its
> > platform device pointer to icl->power(). If not - pass NULL. The wrapper
> > inline function would then become
> > 
> > 	return soc_camera_s_power(icl, on);
> > 
> > Do you see any problems with this approach?
> 
> If I had proposed such a hack I would have sworn you would have rejected it 
> ;-)

Of course, what did you expect? ;-)

> My first idea was to get rid of the device pointer completely. None of the 
> platform callbacks use it. You didn't really like that, as it would make 
> implementation of a future platform that would require the device pointer more 
> complex.

Not only this. Pushing a patch that touches drivers, arch/sh and arch/arm 
is something, that doesn't seem to be favoured very highly these days. 
You'd need something as ugly as - (1) add a new callback without the 
device pointer and convert soc-camera to check-and-call both, (2) port all 
platforms to the new one, (3) remove the old one. All this for no 
practical gain, especially since they'll be gone soon with DT:-)

> I've thus decided to switch to pass the physical struct device 
> associated with the device to the power functions, down to the board code. I 
> don't think board code would need to go back to the original platform device 
> to discriminate between devices, checking the physical device properties (such 
> as the I2C address or bus number for instance) should be enough.
> 
> With your approach we would pass a different device pointer to platform code 
> depending on whether we use a soc-camera host or not. With non soc-camera 
> hosts the device pointer would always be NULL, which wouldn't let board code 
> discrimate between devices. That's not a good situation either.

Remember that those would normally be different platforms, you won't need 
to distinguish between valid-pointer / NULL-pointer in one function. 
Those, that know they'll be getting NULL will just ignore it. A case, like 
in my example, with a USB camera and an SoC camera and both using the same 
.power() function is rather unlikely, I think.

> I'm really beginning to wonder whether we're not trying to fix a problem that 
> will go away in the future, as we'll need to find a way to remove the platform 
> callbacks when switching to the device tree anyway. Wouldn't it be better to 
> remove the device pointer completely ?

See above :)

> (As for the dev_* macros, we could pass the platform device pointer here, and 
> the physical device pointer when the power functions are called from devices).
> 
> And now I've just remembered that patch 8/8 removes this soc_camera_power_on() 
> completely, so the above argument just got pointless, hasn't it ? :-/

Almost. Ok, you can choose any of the following 3 options (or propose 
more, of course:-)): (1) follow my idea with list scanning, (2) swap 
patches 8/9 and 9/9 to first remove power managing in probe(), then you 
don't have the NULL problem, (3) keep everything as is, only use the 
platform device pointer in this single call instead of NULL and put a 
comment, saying like - yes, this is a dirty hack, will go with the next 
commit.

> [snip]
> 
> > > diff --git a/drivers/media/video/soc_camera_platform.c
> > > b/drivers/media/video/soc_camera_platform.c index f59ccad..efd85e7 100644
> > > --- a/drivers/media/video/soc_camera_platform.c
> > > +++ b/drivers/media/video/soc_camera_platform.c
> > > @@ -50,7 +50,20 @@ static int soc_camera_platform_fill_fmt(struct
> > > v4l2_subdev *sd,> 
> > >  	return 0;
> > >  
> > >  }
> > > 
> > > -static struct v4l2_subdev_core_ops platform_subdev_core_ops;
> > > +static int soc_camera_platform_s_power(struct v4l2_subdev *sd, int on)
> > > +{
> > > +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > 
> > Nnnnoo... soc_camera_platform is special - it doesn't (have to) have an
> > i2c device associated with it.
> 
> Oops. You're right. This might be the result of copy and paste late at night.
> 
> > You're only guaranteed to have a subdevice and an struct
> > soc_camera_platform_priv instance (the latter actually contains the former
> > as its only member). But you have the advantage, that this driver always
> > only runs under soc-camera. At least I hope noone ever comes up with an idea
> > to use it outside of soc-camera ;-) So, if we accept my above proposal to
> > use the platform device for soc_camera_power_*(), then you can use something
> > like
> > 
> > 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
> > 	soc_camera_s_power(p->icd->link, on);
> 
> A pointer to the physical device is stored at probe time in p->icd->control. 
> What about
> 
>         struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
> 
>         return soc_camera_set_power(p->icd->control, p->icd->link, on);

Yep, seems ok.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

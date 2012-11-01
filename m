Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab2KAQPW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 12:15:22 -0400
Date: Thu, 1 Nov 2012 17:15:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] media: V4L2: support asynchronous subdevice registration
In-Reply-To: <1710313.9IGrY1RFHv@avalon>
Message-ID: <Pine.LNX.4.64.1211011637400.19489@axis700.grange>
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange>
 <Pine.LNX.4.64.1210221421020.26216@axis700.grange> <201210221536.03112.hverkuil@xs4all.nl>
 <1710313.9IGrY1RFHv@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Nov 2012, Laurent Pinchart wrote:

> Hi,
> 
> On Monday 22 October 2012 15:36:03 Hans Verkuil wrote:
> > On Mon October 22 2012 14:50:14 Guennadi Liakhovetski wrote:
> > > On Mon, 22 Oct 2012, Hans Verkuil wrote:
> > > > On Mon October 22 2012 13:08:12 Guennadi Liakhovetski wrote:

[snip]

> > > > > The issue is simple: subdevice drivers have to recognise, when it's
> > > > > still too early to probe and return -EPROBE_DEFER. If you have a
> > > > > sensor, whose master clock is supplied from an external oscillator.
> > > > > You load its driver, it will happily get a clock reference and find no
> > > > > reason to fail probe(). It will initialise its subdevice and return
> > > > > from probing. Then, when your bridge driver probes, it will have no
> > > > > way to find that subdevice.
> 
> This is where I fundamentally disagree. You're right that the subdev driver 
> would have no reason to fail probe(). So why would it ? If the subdev driver 
> can succeed probe(), it should. -EPROBE_DEFER should only be returned if one 
> of the resources required by the subdev isn't available, such as a GPIO, clock 
> or regulator for instance. When all resources required to make the subdev 
> usable are present, probe() should simply succeed.
> 
> This implies that you can pass the subdev platform data directly to the 
> subdev, either through the platform data pointer or through DT. Passing subdev 
> platform data through the host/bridge is a hack. Removing it should, in my 
> opinion, be one of the goals of this patch.
> 
> This will leave us with the problem of locating the subdev from the host in 
> the notification callback. I had envision a different approach than yours to 
> fix the problem: similarly to your v4l2-clk service, I propose to make subdev 
> drivers registering themselves to the V4L2 core.

It's interesting to see, how we come back to where we started;-) In early 
soc-camera versions both hosts (bridge drivers) and clients (subdevices) 
used to register with the soc-camera core, which then did the matching... 
As we all know, this has been then dropped in favour of our present 
synchronous subdevice instantiation... oh, well:-)

> Instead of using I2C and 
> platform bus notifiers you would then have a single internal notifier 
> (possibly based on a subdev bus notifier if that makes sense) that would 
> support both hot-plug notification (notify drivers when a new subdev is 
> registered with the core) and cold-plug notification (go through the 
> registered subdevs list when a new async group (or whatever replaces the async 
> groups if we get rid of multiple groups) is registered.

So, do I understand it right, that you're proposing something like the 
following:

=================
file bridge_drv.c
=================
static int __devinit bridge_probe(struct platform_device *pdev)
{
	...
	v4l2_device_register(&pdev->dev, v4l2_dev);
	v4l2_clk_register();
	v4l2_async_register_notifier(v4l2_dev, notifier_desc);
	...
}

=================
file subdev_drv.c
=================
static int __devinit subdev_probe(struct i2c_client *client,
				const struct i2c_device_id *did)
{
	...
	priv->clk = v4l2_clk_get();
	if (IS_ERR(priv->clk))
		return -EPROBE_DEFER;
	v4l2_i2c_subdev_init(subdev, client, &subdev_ops);
	v4l2_async_register_subdev(subdev);
}

=================
file v4l2_async.c
=================
static void v4l2_async_test_notify(v4l2_dev, subdev, notifier_desc)
{
	if (v4l2_async_belongs(subdev, notifier_desc)) {
		notifier_desc->subdev_notify(v4l2_dev, subdev, notifier_desc);
		if (v4l2_async_group_complete(notifier_desc, subdev))
			notifier_desc->group_notify(v4l2_dev, group, notifier_desc);
	}
}

int v4l2_async_register_notifier(v4l2_dev, notifier_desc)
{
	notifier_desc->v4l2_dev = v4l2_dev;
	v4l2_async_for_each_subdev(subdev)
		v4l2_async_test_notify(v4l2_dev, subdev, notifier_desc);
}

int v4l2_async_register_subdev(subdev)
{
	v4l2_async_for_each_notifier(notifier_desc)
		v4l2_async_test_notify(notifier_desc->v4l2_dev, subdev, notifier_desc);
}

> > > > This problem is specific to platform subdev drivers, right? Since for
> > > > i2c subdevs you can use i2c_get_clientdata().
> > > 
> > > But how do you get the client? With DT you can follow our "remote"
> > > phandle, and without DT?
> > 
> > You would need a i2c_find_client() function for that. I would like to see
> > some more opinions about this.
> > 
> > > > I wonder whether it isn't a better idea to have platform_data embed a
> > > > standard struct containing a v4l2_subdev pointer. Subdevs can use
> > > > container_of to get from the address of that struct to the full
> > > > platform_data, and you don't have that extra dereference (i.e. a
> > > > pointer to the new struct which has a pointer to the actual
> > > > platform_data). The impact of that change is much smaller for existing
> > > > subdevs.
> > > 
> > > This standard platform data object is allocated by the bridge driver, so,
> > > it will not know where it is embedded in the subdevice specific platform
> > > data.
> > 
> > It should. The platform_data is specific to the subdev, so whoever is
> > allocating the platform_data has to know the size and contents of the
> > struct. Normally this structure is part of the board code for embedded
> > systems.
> > 
> > That soc-camera doesn't do this is a major soc-camera design flaw.
> > Soc-camera should not force the platform_data contents for subdev drivers.
> 
> That's something I tried to fix some time ago. Part of my cleanup patches went 
> to mainline but I haven't had time to finish the implementation. Guennadi and 
> I were planning to work on this topic together at ELC-E, if time permits.
> 
> This being said, part of the information supplied through platform data, such 
> as lists of regulators, could be extracted to a standard V4L2 platform data 
> structure embedded in the driver-specific platform data. That could be useful 
> to provide helper functions, such as handling power on/off sequences.
> 
> > > > And if it isn't necessary for i2c subdev drivers, then I think we should
> > > > do this only for platform drivers.
> > > 
> > > See above, and I don't think we should implement 2 different methods.
> > > Besides, the change is very small. You anyway have to adapt sensor drivers
> > > to return -EPROBE_DEFER. This takes 2 lines of code:
> > > 
> > > +	if (!client->dev.platform_data)
> > > +		return -EPROBE_DEFER;
> > > 
> > > If the driver isn't using platform data, that's it. If it is, you add two
> > > more lines:
> > > 
> > > -	struct my_platform_data *pdata = client->dev.platform_data;
> > > +	struct v4l2_subdev_platform_data *sdpd = client->dev.platform_data;
> > > +	struct my_platform_data *pdata = sdpd->platform_data;
> > > 
> > > That's it. Of course, you have to do this everywhere, where the driver
> > > dereferences client->dev.platform_data, but even that shouldn't be too
> > > difficult.
> > 
> > I'd like to see other people's opinions on this as well. I do think I prefer
> > embedding it (in most if not all cases such a standard struct would be at
> > the beginning of the platform_data).
> 
> As explained above, embedding a standard V4L2 platform data structure (if we 
> decide to create one) in the driver-specific platform data has my preference 
> as well.
> 
> > > > That said, how does this new framework take care of timeouts if one of
> > > > the subdevs is never bound?
> > > 
> > > It doesn't.
> > > 
> > > > You don't want to have this wait indefinitely, I think.
> > > 
> > > There's no waiting:-) The bridge and other subdev drivers just remain
> > > loaded and inactive.
> > 
> > Is that what we want? I definitely would like to get other people's opinions
> > on this.
> > 
> > For the record: while it is waiting, can you safely rmmod the module?
> > Looking at the code I think you can, but I'm not 100% certain.
> 
> I'd like to propose a two layers approach. The lower layer would provide 
> direct notifications of subdev availability to host/bridge drivers. It could 
> be used directly, or an upper helper layer could handle the notifications and 
> provide a single complete callback when all requested subdevs are available.

Not sure you need 2 layers for this. You can just decide which callbacks 
to provide - per-subdev or per-group / global.

> Implementing a timeout-based instead of completetion callback-based upper 
> layer shouldn't be difficult, but I'm not sure whether it's a good approach. I 
> think the host/bridge driver should complete its probe(), registering all the 
> resources it provides (such as clocks that can be used by sensors), even if 
> not all connected subdevs are available. The device nodes would only be 
> created later when all required subdevs are available (depending on the driver 
> some device nodes could be created right-away, to allow mem-to-mem operation 
> for instance).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4156 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab2JVNgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 09:36:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/2] media: V4L2: support asynchronous subdevice registration
Date: Mon, 22 Oct 2012 15:36:03 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange> <201210221354.44944.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210221421020.26216@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210221421020.26216@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210221536.03112.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 22 2012 14:50:14 Guennadi Liakhovetski wrote:
> On Mon, 22 Oct 2012, Hans Verkuil wrote:
> 
> > On Mon October 22 2012 13:08:12 Guennadi Liakhovetski wrote:
> > > Hi Hans
> > > 
> > > Thanks for reviewing the patch.
> > > 
> > > On Mon, 22 Oct 2012, Hans Verkuil wrote:
> > > 
> > > > Hi Guennadi,
> > > > 
> > > > I've reviewed this patch and I have a few questions:
> > > > 
> > > > On Sat October 20 2012 00:20:24 Guennadi Liakhovetski wrote:
> > > > > Currently bridge device drivers register devices for all subdevices
> > > > > synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
> > > > > is attached to a video bridge device, the bridge driver will create an I2C
> > > > > device and wait for the respective I2C driver to probe. This makes linking
> > > > > of devices straight forward, but this approach cannot be used with
> > > > > intrinsically asynchronous and unordered device registration systems like
> > > > > the Flattened Device Tree. To support such systems this patch adds an
> > > > > asynchronous subdevice registration framework to V4L2. To use it respective
> > > > > (e.g. I2C) subdevice drivers must request deferred probing as long as their
> > > > > bridge driver hasn't probed. The bridge driver during its probing submits a
> > > > > an arbitrary number of subdevice descriptor groups to the framework to
> > > > > manage. After that it can add callbacks to each of those groups to be
> > > > > called at various stages during subdevice probing, e.g. after completion.
> > > > > Then the bridge driver can request single groups to be probed, finish its
> > > > > own probing and continue its video subsystem configuration from its
> > > > > callbacks.
> > > > 
> > > > What is the purpose of allowing multiple groups?
> > > 
> > > To support, e.g. multiple sensors connected to a single bridge.
> > 
> > So, isn't that one group with two sensor subdevs?
> 
> No, one group consists of all subdevices, necessary to operate a single 
> video pipeline. A simple group only contains a sensor. More complex groups 
> can contain a CSI-2 interface, a line shifter, or anything else.

Why? Why would you want to wait for completion of multiple groups? You need all
subdevs to be registered. If you split them up in multiple groups, then you
have to wait until all those groups have completed, which only makes the bridge
driver more complex. It adds nothing to the problem that we're trying to solve.

> > A bridge driver has a list of subdevs. There is no concept of 'groups'. Perhaps
> > I misunderstand?
> 
> Well, we have a group ID, which can be used for what I'm proposing groups 
> for. At least on soc-camera we use the group ID exactly for this purpose. 
> We attach all subdevices to a V4L2 device, but assign group IDs according 
> to pipelines. Then subdevice operations only act on members of one 
> pipeline. I know that we currently don't specify precisely what that group 
> ID should be used for in general. So, this my group concept is an 
> extension of what we currently have in V4L2.

How the grp_id field is used is entirely up to the bridge driver. It may not
be used at all, it may uniquely identify each subdev, it may put each subdev
in a particular group and perhaps a single subdev might belong to multiple
groups. There is no standard concept of a group. It's just a simple method
(actually, more of a hack) of allowing bridge drivers to call ops for some
subset of the sub-devices.

Frankly, I wonder if most of the drivers that use grp_id actually need it at
all.

Just drop the group concept, things can be simplified quite a bit without it.

> 
> > > > I can't think of any reason
> > > > why you would want to have more than one group. If you have just one group
> > > > you can simplify this code quite a bit: most of the v4l2_async_group fields
> > > > can just become part of struct v4l2_device, you don't need the 'list' and
> > > > 'v4l2_dev' fields anymore and the 'bind' and 'complete' callbacks can be
> > > > implemented using the v4l2_device notify callback which we already have.
> > > > 
> > > > > 
> > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > > ---
> > > > > 
> > > > > One more thing to note about this patch. Subdevice drivers, supporting 
> > > > > asynchronous probing, and using this framework, need a unified way to 
> > > > > detect, whether their probing should succeed or they should request 
> > > > > deferred probing. I implement this using device platform data. This means, 
> > > > > that all subdevice drivers, wishing to use this API will have to use the 
> > > > > same platform data struct. I don't think this is a major inconvenience, 
> > > > > but if we decide against this, we'll have to add a V4L2 function to verify 
> > > > > "are you ready for me or not." The latter would be inconvenient, because 
> > > > > then we would have to look through all registered subdevice descriptor 
> > > > > groups for this specific subdevice.
> > > > 
> > > > I have to admit that I don't quite follow this. I guess I would need to see
> > > > this being used in an actual driver.
> > > 
> > > The issue is simple: subdevice drivers have to recognise, when it's still 
> > > too early to probe and return -EPROBE_DEFER. If you have a sensor, whose 
> > > master clock is supplied from an external oscillator. You load its driver, 
> > > it will happily get a clock reference and find no reason to fail probe(). 
> > > It will initialise its subdevice and return from probing. Then, when your 
> > > bridge driver probes, it will have no way to find that subdevice.
> > 
> > This problem is specific to platform subdev drivers, right? Since for i2c
> > subdevs you can use i2c_get_clientdata().
> 
> But how do you get the client? With DT you can follow our "remote" 
> phandle, and without DT?

You would need a i2c_find_client() function for that. I would like to see some
more opinions about this.

> > I wonder whether it isn't a better idea to have platform_data embed a standard
> > struct containing a v4l2_subdev pointer. Subdevs can use container_of to get
> > from the address of that struct to the full platform_data, and you don't have
> > that extra dereference (i.e. a pointer to the new struct which has a pointer
> > to the actual platform_data). The impact of that change is much smaller for
> > existing subdevs.
> 
> This standard platform data object is allocated by the bridge driver, so, 
> it will not know where it is embedded in the subdevice specific platform 
> data.

It should. The platform_data is specific to the subdev, so whoever is allocating
the platform_data has to know the size and contents of the struct. Normally this
structure is part of the board code for embedded systems.

That soc-camera doesn't do this is a major soc-camera design flaw. Soc-camera
should not force the platform_data contents for subdev drivers.

> > And if it isn't necessary for i2c subdev drivers, then I think we should do
> > this only for platform drivers.
> 
> See above, and I don't think we should implement 2 different methods. 
> Besides, the change is very small. You anyway have to adapt sensor drivers 
> to return -EPROBE_DEFER. This takes 2 lines of code:
> 
> +	if (!client->dev.platform_data)
> +		return -EPROBE_DEFER;
> 
> If the driver isn't using platform data, that's it. If it is, you add two 
> more lines:
> 
> -	struct my_platform_data *pdata = client->dev.platform_data;
> +	struct v4l2_subdev_platform_data *sdpd = client->dev.platform_data;
> +	struct my_platform_data *pdata = sdpd->platform_data;
> 
> That's it. Of course, you have to do this everywhere, where the driver 
> dereferences client->dev.platform_data, but even that shouldn't be too 
> difficult.

I'd like to see other people's opinions on this as well. I do think I prefer
embedding it (in most if not all cases such a standard struct would be at the
beginning of the platform_data).

> > That said, how does this new framework take care of timeouts if one of the
> > subdevs is never bound?
> 
> It doesn't.
> 
> > You don't want to have this wait indefinitely, I think.
> 
> There's no waiting:-) The bridge and other subdev drivers just remain 
> loaded and inactive.

Is that what we want? I definitely would like to get other people's opinions
on this.

For the record: while it is waiting, can you safely rmmod the module?
Looking at the code I think you can, but I'm not 100% certain.

Regards,

	Hans

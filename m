Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3882 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2JVPWz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 11:22:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/2] media: V4L2: support asynchronous subdevice registration
Date: Mon, 22 Oct 2012 17:22:16 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange> <201210221536.03112.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210221553390.26216@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210221553390.26216@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210221722.16382.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 22 2012 16:48:05 Guennadi Liakhovetski wrote:
> On Mon, 22 Oct 2012, Hans Verkuil wrote:
> 
> > On Mon October 22 2012 14:50:14 Guennadi Liakhovetski wrote:
> > > On Mon, 22 Oct 2012, Hans Verkuil wrote:
> > > 
> > > > On Mon October 22 2012 13:08:12 Guennadi Liakhovetski wrote:
> > > > > Hi Hans
> > > > > 
> > > > > Thanks for reviewing the patch.
> > > > > 
> > > > > On Mon, 22 Oct 2012, Hans Verkuil wrote:
> > > > > 
> > > > > > Hi Guennadi,
> > > > > > 
> > > > > > I've reviewed this patch and I have a few questions:
> > > > > > 
> > > > > > On Sat October 20 2012 00:20:24 Guennadi Liakhovetski wrote:
> > > > > > > Currently bridge device drivers register devices for all subdevices
> > > > > > > synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
> > > > > > > is attached to a video bridge device, the bridge driver will create an I2C
> > > > > > > device and wait for the respective I2C driver to probe. This makes linking
> > > > > > > of devices straight forward, but this approach cannot be used with
> > > > > > > intrinsically asynchronous and unordered device registration systems like
> > > > > > > the Flattened Device Tree. To support such systems this patch adds an
> > > > > > > asynchronous subdevice registration framework to V4L2. To use it respective
> > > > > > > (e.g. I2C) subdevice drivers must request deferred probing as long as their
> > > > > > > bridge driver hasn't probed. The bridge driver during its probing submits a
> > > > > > > an arbitrary number of subdevice descriptor groups to the framework to
> > > > > > > manage. After that it can add callbacks to each of those groups to be
> > > > > > > called at various stages during subdevice probing, e.g. after completion.
> > > > > > > Then the bridge driver can request single groups to be probed, finish its
> > > > > > > own probing and continue its video subsystem configuration from its
> > > > > > > callbacks.
> > > > > > 
> > > > > > What is the purpose of allowing multiple groups?
> > > > > 
> > > > > To support, e.g. multiple sensors connected to a single bridge.
> > > > 
> > > > So, isn't that one group with two sensor subdevs?
> > > 
> > > No, one group consists of all subdevices, necessary to operate a single 
> > > video pipeline. A simple group only contains a sensor. More complex groups 
> > > can contain a CSI-2 interface, a line shifter, or anything else.
> > 
> > Why? Why would you want to wait for completion of multiple groups? You need all
> > subdevs to be registered. If you split them up in multiple groups, then you
> > have to wait until all those groups have completed, which only makes the bridge
> > driver more complex. It adds nothing to the problem that we're trying to solve.
> 
> I see it differently. Firstly, there's no waiting.

If they are independent, then that's true. But in almost all cases you need them
all. Even in cases where theoretically you can 'activate' groups independently,
it doesn't add anything. It's overengineering, trying to solve a problem that
doesn't exist.

Just keep it simple, that's hard enough.

> Secondly, you don't 
> need all of them. With groups as soon as one group is complete you can 
> start using it. If you require all your subdevices to complete their 
> probing before you can use anything. In fact, some subdevices might never 
> probe, but groups, that don't need them can be used regardless.
> 
> > > > A bridge driver has a list of subdevs. There is no concept of 'groups'. Perhaps
> > > > I misunderstand?
> > > 
> > > Well, we have a group ID, which can be used for what I'm proposing groups 
> > > for. At least on soc-camera we use the group ID exactly for this purpose. 
> > > We attach all subdevices to a V4L2 device, but assign group IDs according 
> > > to pipelines. Then subdevice operations only act on members of one 
> > > pipeline. I know that we currently don't specify precisely what that group 
> > > ID should be used for in general. So, this my group concept is an 
> > > extension of what we currently have in V4L2.
> > 
> > How the grp_id field is used is entirely up to the bridge driver. It may not
> > be used at all, it may uniquely identify each subdev, it may put each subdev
> > in a particular group and perhaps a single subdev might belong to multiple
> > groups. There is no standard concept of a group. It's just a simple method
> > (actually, more of a hack) of allowing bridge drivers to call ops for some
> > subset of the sub-devices.
> 
> Yes, I know, at least it's something that loosely indicates a group 
> concept in the current code:-)
> 
> > Frankly, I wonder if most of the drivers that use grp_id actually need it at
> > all.
> > 
> > Just drop the group concept, things can be simplified quite a bit without it.
> 
> So far I think we should keep it. Also think about our DT layout. A bridge 
> can have several ports each with multiple links (maybe it has already been 
> decided to change names, don't remember by heart, sorry). Each of them 
> would then start a group.

So? What does that gain you?

I don't have time today to go over the remainder of your reply, I'll try to
answer that later in the week.

Regards,

	Hans

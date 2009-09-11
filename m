Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830AbZIKV3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 17:29:18 -0400
Date: Fri, 11 Sep 2009 18:28:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090911182847.6458de96@caramujo.chehab.org>
In-Reply-To: <200909112229.41357.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<200909112108.14033.hverkuil@xs4all.nl>
	<20090911165403.0d1b872d@caramujo.chehab.org>
	<200909112229.41357.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Sep 2009 22:29:41 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Friday 11 September 2009 21:54:03 Mauro Carvalho Chehab wrote:
> > Em Fri, 11 Sep 2009 21:08:13 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> <snip>
> 
> > > OK, so instead we require an application to construct a file containing a new
> > > topology, write something to a sysfs file, require code in the v4l core to load
> > > and parse that file, then find out which links have changed (since you really
> > > don't want to set all the links: there can be many, many links, believe me on
> > > that), and finally call the driver to tell it to change those links.
> > 
> > As I said before, the design should take into account how frequent are those
> > changes. If they are very infrequent, this approach works, and offers one
> > advantage: the topology will survive to application crashes and warm/cold
> > reboots. If the changes are frequent, an approach like the audio
> > user_pin_configs work better (see my previous email - note that this approach
> > can be used for atomic operations if needed). You add at a sysfs node just the
> > dynamic changes you need. We may even have both ways, as alsa seems to have
> > (init_pin_configs and user_pin_configs).
> 
> How frequent those changes are will depend entirely on the application.
> Never underestimate the creativity of the end-users :-)
> 
> I think that a good worst case guideline would be 60 times per second.
> Say for a surveillance type application that switches between video decoders
> for each frame.

The video input switch control, is already used by surveillance applications
for a long time. There's no need to add any API for it.

> Or some 3D type application that switches between two sensors for each frame.

Also, another case of video input selection.

We shouldn't design any new device for it.

I may be wrong, but from Vaibhav and your last comments, I'm starting to think
that you're wanting to replace V4L2 by a new "media controller" based new API.

So, let's go one step back and better understand what's expected by the media
controller.

>From my previous understanding, those are the needs:

1) V4L2 API will keep being used to control the devices and to do streaming,
working under the already well defined devices;

2) One Kernel object is needed to represent the entire board as a hole, to
enumerate its sub-devices and to change their topology;

3) For some very specific cases, it should be possible to "tweak" some
sub-devices to act on a non-usual way;

4) Some new ioctls are needed to control some parts of the devices that aren't
currently covered by V4L2 API.

Right?

If so:

(1) already exists;

(2) is the "topology manager" of the media controller, that should use
sysfs, due to its nature.

For (3), there are a few alternatives. IMO, the better is to use also sysfs,
since we'll have all subdevs already represented there. So, to change
something, it is just a matter to write something to a sysfs node. Another
alternative would be to create separate subdevs at /dev, but this will end on
creating much more complex drivers than probably needed.

(4) is implemented by some new ioctl additions at V4L2 API.

Cheers,
Mauro

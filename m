Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4815 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbZIKWj4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 18:39:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFCv2: Media controller proposal
Date: Sat, 12 Sep 2009 00:39:50 +0200
Cc: linux-media@vger.kernel.org
References: <200909100913.09065.hverkuil@xs4all.nl> <200909112229.41357.hverkuil@xs4all.nl> <20090911182847.6458de96@caramujo.chehab.org>
In-Reply-To: <20090911182847.6458de96@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909120039.50343.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 11 September 2009 23:28:47 Mauro Carvalho Chehab wrote:
> Em Fri, 11 Sep 2009 22:29:41 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Friday 11 September 2009 21:54:03 Mauro Carvalho Chehab wrote:
> > > Em Fri, 11 Sep 2009 21:08:13 +0200
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> > <snip>
> > 
> > > > OK, so instead we require an application to construct a file containing a new
> > > > topology, write something to a sysfs file, require code in the v4l core to load
> > > > and parse that file, then find out which links have changed (since you really
> > > > don't want to set all the links: there can be many, many links, believe me on
> > > > that), and finally call the driver to tell it to change those links.
> > > 
> > > As I said before, the design should take into account how frequent are those
> > > changes. If they are very infrequent, this approach works, and offers one
> > > advantage: the topology will survive to application crashes and warm/cold
> > > reboots. If the changes are frequent, an approach like the audio
> > > user_pin_configs work better (see my previous email - note that this approach
> > > can be used for atomic operations if needed). You add at a sysfs node just the
> > > dynamic changes you need. We may even have both ways, as alsa seems to have
> > > (init_pin_configs and user_pin_configs).
> > 
> > How frequent those changes are will depend entirely on the application.
> > Never underestimate the creativity of the end-users :-)
> > 
> > I think that a good worst case guideline would be 60 times per second.
> > Say for a surveillance type application that switches between video decoders
> > for each frame.
> 
> The video input switch control, is already used by surveillance applications
> for a long time. There's no need to add any API for it.
> 
> > Or some 3D type application that switches between two sensors for each frame.
> 
> Also, another case of video input selection.

True, bad example. Given enough time I can no doubt come up with some example :-)

> We shouldn't design any new device for it.
> 
> I may be wrong, but from Vaibhav and your last comments, I'm starting to think
> that you're wanting to replace V4L2 by a new "media controller" based new API.
> 
> So, let's go one step back and better understand what's expected by the media
> controller.
> 
> From my previous understanding, those are the needs:
> 
> 1) V4L2 API will keep being used to control the devices and to do streaming,
> working under the already well defined devices;

Yes.
 
> 2) One Kernel object is needed to represent the entire board as a hole, to
> enumerate its sub-devices and to change their topology;

Yes.

> 3) For some very specific cases, it should be possible to "tweak" some
> sub-devices to act on a non-usual way;

This will not be for 'some very specific cases'. This will become an essential
feature on embedded platforms. It's probably the most important part of the
media controller proposal.

> 4) Some new ioctls are needed to control some parts of the devices that aren't
> currently covered by V4L2 API.

No, that is not part of the proposal. Of course, as drivers for the more
advanced devices are submitted there may be some functionality that is general
enough to warrant inclusion in the V4L2 API, but that's business as usual.

> 
> Right?
> 
> If so:
> 
> (1) already exists;

Obviously.
 
> (2) is the "topology manager" of the media controller, that should use
> sysfs, due to its nature.

See the separate thread I started on sysfs vs ioctl.

> For (3), there are a few alternatives. IMO, the better is to use also sysfs,
> since we'll have all subdevs already represented there. So, to change
> something, it is just a matter to write something to a sysfs node.

See that same thread why that is a really bad idea.

> Another 
> alternative would be to create separate subdevs at /dev, but this will end on
> creating much more complex drivers than probably needed.

I agree with this.

> (4) is implemented by some new ioctl additions at V4L2 API.

Not an issue as stated above.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

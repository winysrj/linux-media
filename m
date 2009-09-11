Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4378 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbZIKTIV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 15:08:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFCv2: Media controller proposal
Date: Fri, 11 Sep 2009 21:08:13 +0200
Cc: linux-media@vger.kernel.org
References: <200909100913.09065.hverkuil@xs4all.nl> <200909102335.52770.hverkuil@xs4all.nl> <20090911121342.08dd1939@caramujo.chehab.org>
In-Reply-To: <20090911121342.08dd1939@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909112108.14033.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I am going to move the ioctl vs sysfs discussion to a separate thread. I'll
post an analysis of that later today or tomorrow.

See below for my comments on some misunderstandings for non-sysfs issues.

On Friday 11 September 2009 17:13:42 Mauro Carvalho Chehab wrote:

<snip>

> > > > All this requires that there has to be a way to connect and disconnect parts
> > > > of the internal topology of a video board at will.
> > > 
> > > We should design this with care, since each change at the internal topology may
> > > create/delete devices.
> > 
> > No, devices aren't created or deleted. Only links between devices.
> 
> I think that there are some cases where devices are created/deleted. For
> example, on some hardware, you have some blocks that allow you to have either 4 SD
> video inputs or 1 HD video input. So, if you change the type of input, you'll
> end by creating or deleting devices.

Normally you will create four device nodes, but if you switch to HD mode,
then only one is active and attempting to use the others will return EBUSY
or something. That's what the davinci driver does.

Creating and deleting device nodes depending on the mode makes a driver very
complex and the application as well. Say you are in SD mode and you have nodes
video[0-3], now you switch to HD mode and you have only node video0. You go
back to SD mode and you may end up with nodes video0 and video[2-4] if in the
meantime the user connected a USB webcam which took up video1.

Just create them upfront. You know beforehand what the maximum number of video
nodes is since that is determined by the hardware. Let's keep things simple.
Media boards are getting very, very complex and we should keep away from adding
unnecessary further complications.

And yes, I too can generate hypothetical situations where this might be needed.
But that's something we can tackle when it arrives.

> 
> > > If you do such changes at topology, udev will need to 
> > > delete the old devices and create the new ones. 
> > 
> > udev is not involved at all. Exception: open issue #2 suggests that we
> > dynamically register device nodes when they are first linked to some source
> > or sink. That would involve udev.
> > 
> > All devices are setup when the board is configured. But the links between
> > them can be changed. This is nothing more than bringing the board's block
> > diagram to life: each square of the diagram (video device node, resizer, video
> > encoder or decoder) is a v4l2-subdev with inputs and outputs. And in some cases
> > you can change links dynamically (in effect this will change a mutex register).
> 
> See above. If you're grouping 4 A/D blocks into one A/D for handling HD, you're
> doing more than just changing links, since the HD device will be just one
> device: one STD, one video input mux, one audio input mux, etc.

So? You will just deactivate three SD device nodes. I don't see a problem with
that, and that concept has already been proven to work in the davinci driver.
 
> > > This will happen on separate 
> > > threads and may cause locking issues at the device, especially since you can be
> > > modifying several components at the same time (being even possible to do it on
> > > separate threads).
> > 
> > This is definitely not something that should be allowed while streaming. I
> > would like to hear from e.g. TI whether this could be a problem or not. I
> > suspect that it isn't a problem unless streaming is in progress.
> 
> Even when streaming, providing that you don't touch at the used IC blocks, it
> should be possible to reconfigure the unused parts. It is just a matter of
> having the right resource locks at the driver.

As you say, this will depend on the driver. Some may be able to do this,
others may just return -EBUSY. I would do the latter, personally, since
allowing this would just make the driver more complicated for IMHO little
gain.
 
> > > I've seen some high-end core network routers that implements topology changes
> > > on an interesting way: any changes done are not immediately applied at the
> > > node, but are stored into a file, where the configuration that can be changed
> > > anytime. However, the topology changes only happen after giving a commit
> > > command. After commit, it validates the new config and apply them atomically
> > > (e. g. or all changes are applied or none), to avoid bad effects that
> > > intermediate changes could cause.
> > > 
> > > As we are at kernelspace, we need to take care to not create a very complex
> > > interface. Yet, the idea of applying the new topology atomically seems
> > > interesting. 
> > 
> > I see no need for it. At least, not for any of the current or forthcoming
> > devices that I am aware of. Should it ever be needed, then we can introduce a
> > 'shadow topology' in the future. You can change the shadow links and when done
> > commit it. That wouldn't be too difficult and we can easily prepare for that
> > eventuality (e.g. have some 'flags' field available where you can set a SHADOW
> > flag in the future).
> 
> > > Alsa is facing a similar problem with pinup quirks needed with HD-audio boards.
> > > They are proposing a firmware like interface:
> > > 	http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-09/msg03198.html
> > > 
> > > On their case, they are just using request_firmware() for it, at board probing
> > > time.
> > 
> > That seems to be a one-time setup. We need this while the system is up and
> > running.
> 
> It would be easy to implement something like:
> 
> 	echo 1 >/sys/class/media/mc0/config_reload
> 
> to call request_firmware() and load the new topology. This is enough to have an
> atomic operation, and we don't need to implement a shadow config.

OK, so instead we require an application to construct a file containing a new
topology, write something to a sysfs file, require code in the v4l core to load
and parse that file, then find out which links have changed (since you really
don't want to set all the links: there can be many, many links, believe me on
that), and finally call the driver to tell it to change those links.

I don't think so. Just call ioctl(mc, VIDIOC_S_LINK, &link). Should we ever
need to do this atomically, then that can be done through a simple double
buffering technique at minimal cost.

The media controller as I see it is something that can be implemented with
very little effort. Drivers provide a bunch of mostly static const structs
that define the topology (the only non-static things are which links are active
and device node specifications). The core uses that info to provide the
enumeration services and any non-media controller ioctl calls are passed
straight to the target subdev.

No parsers, no complex locking schemes (although drivers are free to implement
that if they need it), no complex sysfs attributes.

Keep things as simple as possible. Complexity is the greatest danger to v4l2
development.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

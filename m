Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZIKTya (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 15:54:30 -0400
Date: Fri, 11 Sep 2009 16:54:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090911165403.0d1b872d@caramujo.chehab.org>
In-Reply-To: <200909112108.14033.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<200909102335.52770.hverkuil@xs4all.nl>
	<20090911121342.08dd1939@caramujo.chehab.org>
	<200909112108.14033.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Sep 2009 21:08:13 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > > No, devices aren't created or deleted. Only links between devices.
> > 
> > I think that there are some cases where devices are created/deleted. For
> > example, on some hardware, you have some blocks that allow you to have either 4 SD
> > video inputs or 1 HD video input. So, if you change the type of input, you'll
> > end by creating or deleting devices.
> 
> Normally you will create four device nodes, but if you switch to HD mode,
> then only one is active and attempting to use the others will return EBUSY
> or something. That's what the davinci driver does.
> 
> Creating and deleting device nodes depending on the mode makes a driver very
> complex and the application as well. Say you are in SD mode and you have nodes
> video[0-3], now you switch to HD mode and you have only node video0. You go
> back to SD mode and you may end up with nodes video0 and video[2-4] if in the
> meantime the user connected a USB webcam which took up video1.
> 
> Just create them upfront. You know beforehand what the maximum number of video
> nodes is since that is determined by the hardware. Let's keep things simple.
> Media boards are getting very, very complex and we should keep away from adding
> unnecessary further complications.

Ok, we may start with this approach, and move to a more complex one only if
needed. This should be properly documented to avoid miss-understandings.

> > See above. If you're grouping 4 A/D blocks into one A/D for handling HD, you're
> > doing more than just changing links, since the HD device will be just one
> > device: one STD, one video input mux, one audio input mux, etc.
> 
> So? You will just deactivate three SD device nodes. I don't see a problem with
> that, and that concept has already been proven to work in the davinci driver.

If just disabling applies to all cases, I agree stick with this idea. The
issue with enabling/disabling devices is that some complex hardware may need to
register a large amount of devices to expose all the different possibilities,
but only a very few of them being possible to be enabled. Let's see as time
goes by.

To work like you said, this means that we'll need an enable attribute at
the corresponding sysfs entry.

It should be noticed that, even not deleting a hardware, udev can still be
called. For example, an userspace application (like lirc) may need to be
started/stopped if you enable/disable IR (or restarted on some topology
changes, like using a different IR protocol).

> > Even when streaming, providing that you don't touch at the used IC blocks, it
> > should be possible to reconfigure the unused parts. It is just a matter of
> > having the right resource locks at the driver.
> 
> As you say, this will depend on the driver.

Yes.

> Some may be able to do this,
> others may just return -EBUSY. I would do the latter, personally, since
> allowing this would just make the driver more complicated for IMHO little
> gain.

Ok. Both approaches are valid. So the API should be able to support both ways,
providing a thread safe interface to userspace.

> > It would be easy to implement something like:
> > 
> > 	echo 1 >/sys/class/media/mc0/config_reload
> > 
> > to call request_firmware() and load the new topology. This is enough to have an
> > atomic operation, and we don't need to implement a shadow config.
> 
> OK, so instead we require an application to construct a file containing a new
> topology, write something to a sysfs file, require code in the v4l core to load
> and parse that file, then find out which links have changed (since you really
> don't want to set all the links: there can be many, many links, believe me on
> that), and finally call the driver to tell it to change those links.

As I said before, the design should take into account how frequent are those
changes. If they are very infrequent, this approach works, and offers one
advantage: the topology will survive to application crashes and warm/cold
reboots. If the changes are frequent, an approach like the audio
user_pin_configs work better (see my previous email - note that this approach
can be used for atomic operations if needed). You add at a sysfs node just the
dynamic changes you need. We may even have both ways, as alsa seems to have
(init_pin_configs and user_pin_configs).



Cheers,
Mauro

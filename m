Return-path: <mchehab@localhost.localdomain>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1681 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0IMJOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 05:14:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: RFC: Replacing the 'Device Naming' section in the V4L spec
Date: Mon, 13 Sep 2010 11:14:12 +0200
Cc: linux-media@vger.kernel.org
References: <201009111549.53435.hverkuil@xs4all.nl> <1284214252.2053.72.camel@morgan.silverblock.net>
In-Reply-To: <1284214252.2053.72.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131114.12523.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Saturday, September 11, 2010 16:10:52 Andy Walls wrote:
> On Sat, 2010-09-11 at 15:49 +0200, Hans Verkuil wrote:
> > I'm working on the V4L2 DocBook spec and when reading through the "Device Naming"
> > subsection of the "Opening and Closing Devices" section in the first chapter I
> > realized that it is really out of date. The text is in this file:
> > 
> > Documentation/DocBook/v4l/common.xml
> > 
> > With udev pretty much everything in that section is useless (and probably confusing
> > for first-time readers).
> > 
> > I propose that we replace it with something short like this:
> > 
> > -----------------------------------------------------
> > Device Naming
> > 
> > V4L2 drivers create one or more device nodes with major number 81 and a minor number
> > between 0 and 255. Three types of devices can be created:
> > 
> > /dev/videoX	Used for video capture/output/overlay.
> 
> PCM audio capture

I don't really dare mention this :-) This really should have been an alsa
device.

PCM audio capture is really a big hack. This is a topic for a v4l summit to
decide what to do with this. And I guess it depends on whether alsa can be
extended with proper time stamping.

> MPEG index (metadata)

I think is a bit too detailed for an overview section.

> 
> > /dev/radioX	Used for radio and RDS tuning/modulating.
> > /dev/vbiX	Used for VBI capture and output.
> > -----------------------------------------------------
> > 
> > Is there anything else that should be in here?
> 
> You may want to mention, without fully specifying, that V4L2 drivers can
> present ALSA device nodes as well.

This is covered in the 'Related Devices' section.

> I don't think the V4L2 drivers have a really uniform convention for
> their "card" name exported to ALSA nor the ALSA mixer control names.
> 
> To document the Media Controller, the document will eventually have to
> mention ALSA, framebuffer, LED, etc. APIs anyway.

Of course.

Regards,

	Hans

>  
> 
> > BTW, I'm working on editing the 'Related Devices', 'Multiple Opens' and 
> > 'Shared Data Streams' as well.
> > 
> > Regards,
> > 
> > 	Hans
> 
> Regards,
> Andy
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

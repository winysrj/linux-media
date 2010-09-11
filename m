Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57928 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074Ab0IKOK4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 10:10:56 -0400
Subject: Re: RFC: Replacing the 'Device Naming' section in the V4L spec
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201009111549.53435.hverkuil@xs4all.nl>
References: <201009111549.53435.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Sep 2010 10:10:52 -0400
Message-ID: <1284214252.2053.72.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Sat, 2010-09-11 at 15:49 +0200, Hans Verkuil wrote:
> I'm working on the V4L2 DocBook spec and when reading through the "Device Naming"
> subsection of the "Opening and Closing Devices" section in the first chapter I
> realized that it is really out of date. The text is in this file:
> 
> Documentation/DocBook/v4l/common.xml
> 
> With udev pretty much everything in that section is useless (and probably confusing
> for first-time readers).
> 
> I propose that we replace it with something short like this:
> 
> -----------------------------------------------------
> Device Naming
> 
> V4L2 drivers create one or more device nodes with major number 81 and a minor number
> between 0 and 255. Three types of devices can be created:
> 
> /dev/videoX	Used for video capture/output/overlay.

PCM audio capture
MPEG index (metadata)

> /dev/radioX	Used for radio and RDS tuning/modulating.
> /dev/vbiX	Used for VBI capture and output.
> -----------------------------------------------------
> 
> Is there anything else that should be in here?

You may want to mention, without fully specifying, that V4L2 drivers can
present ALSA device nodes as well.

I don't think the V4L2 drivers have a really uniform convention for
their "card" name exported to ALSA nor the ALSA mixer control names.

To document the Media Controller, the document will eventually have to
mention ALSA, framebuffer, LED, etc. APIs anyway.
 

> BTW, I'm working on editing the 'Related Devices', 'Multiple Opens' and 
> 'Shared Data Streams' as well.
> 
> Regards,
> 
> 	Hans

Regards,
Andy



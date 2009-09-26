Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2199 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZIZGZS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 02:25:18 -0400
Received: from pao.localnet (72-254-83-76.client.stsn.net [72.254.83.76])
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id n8Q6PIJT086772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 26 Sep 2009 08:25:20 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: V4L-DVB Summit Day 3
Date: Fri, 25 Sep 2009 23:22:26 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909252322.26427.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Well, that was another very successful day here in Portland.

I started off presenting the work we did in the past year and our plans for 
the next year during the BoF this morning. It was quite a big crowd and the 
talk was well received.

The presentation is available from my website:

http://www.xs4all.nl/~hverkuil/lpc/bof.odp

The nice thing was that this presentation was hot off the press as it 
presented all the things we discussed in the two preceding days of the summit. 

Two additional presentations from Samsung regarding their SoCs and their 
implementation of a memory pool-like API are also available from my website:

http://www.xs4all.nl/~hverkuil/lpc/Samsung_SoCs.ppt
http://www.xs4all.nl/~hverkuil/lpc/Unified_media_buffers.pdf

Unfortunately I couldn't attend the presentation from Hans de Goede and 
Brandon Philips, so I can't comment on that. It would be great if someone can 
post a report of that presentation (and links to the presentation itself, if 
possible).

During the afternoon we worked on assigning people to the various tasks that 
need to be done.

I made the following list:

- We created a new mc mailinglist: linux-mc@googlegroups.com

This is a temporary mailinglist where we can post and review patches during 
prototyping of the mc API. We don't want to flood the linux-media list with 
those patches since that is already quite high-volume.

The mailinglist should be active, although I couldn't find it yet from 
www.googlegroups.com. I'm not sure if it hasn't shown up yet, or if I did 
something wrong.

- implement sensor v4l2_subdev support (Laurent). We are still missing some 
v4l2_subdev sensor ops for setting up the bus config and data format. Laurent 
will look into implementing those. An RFC for the bus config already exists 
and will function as the basis of this.

- when done, remove the v4l2-int-device API (Nokia, target 2.6.33). It's 
important to finally remove this non-standard API. When we can setup sensors 
properly using subdevs, then Nokia can convert the final two users of this API 
to v4l2_subdev.

- subdev migration omap3:
        - ISP (Laurent)  
        - video decoder (Vaibhav)
        - display (Vaibhav)

These are the initial test implementations for the media controller: 
converting the various parts of the omap3 driver to subdevs and see how these 
can be controller via the mc.

- subdev migration Moorestown (Intel):
        - sensors
        - LED driver
        - video decoder/encoder
        - more...

Intel will do something similar for their Moorestown platform.

- Samsung: investigate V4L2 API and mc concept.

Samsung needs to investigate the V4L2 API and the mc proposal first before 
they can commit to anything.

- HDTV timings API (Murali, 2.6.33). This is an important API that we should 
be able to get into 2.6.33.

- Event handling API (RFC: Laurent, code: Guru Raj, 2.6.33). Ditto. Laurent 
will update the RFC, Guru Raj from Intel will write the code for it (Laurent 
already has a lot on his plate).

- Memory pool API (Laurent, Vaibhav). Laurent and Vaibhav will do the research 
needed for this API.

- Control framework (Hans). In November I hope to finish the control 
framework.

- Media Controller testbed: create device nodes for subdevs and cleanup (Hans)
  (http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-mc). My tree needs updating to 
reflect the discussions during this summit. I hope to do this in two weeks 
from now. It will create a decent starting point for the various mc 
prototyping efforts.

- Associating alsa and video (esp. USB) (Devin). Devin will do more research 
on how to associate alsa and video nodes. In particular for USB webcam 
devices.

- Research a new ioctl that just enums device nodes to get audio/video 
association solved quickly. Will be subset of v4l2_mc_entity struct. (Devin).
Devin raised the valid concern that it will probably take many months before 
the mc and all related ioctls will be implemented. But there is a very urgent 
need for applications to be able to find related alsa/video nodes. A possible 
approach is to create an ioctl for the mc that basically will just enumerate 
device nodes and will give a subset of what the final entity enumeration ioctl 
will return. Just enough to let applications use it to figure out these 
alsa/vbi/video relationships. Devin will do more research into this.

- Userspace libraries for the SoCs (TBD). Not discussed yet is how to create 
the userspace libraries that contain the SoC specific code: should they 
conform to certain requirements? Or is it free-for-all? Should we have a 
central repository for these libraries? It is to early to tell.

We also listed the criteria when to decide that the mc API is ready for 
submission to the v4l-dvb repository:

- Implemented in UVC
- Implemented in ivtv
- Without modifying bttv the code framework should setup workable entities by 
default.
- Implemented in omap3 together with a test userspace library.

These three days clearly showed that there is a lot of interest from SoC 
companies into the mc concept. The interest in these sessions was frankly 
overwhelming.

I would like to thank the Linux Foundation for organizing the LPC and 
arranging for a room for all three days where we could hold our summit 
meetings.

I would also like to thank (in no particular order) Mike Krufky, Steven Toth, 
Andy Walls, Brandon Philips, Hans de Goede and Devin Heitmueller as 
independent v4l-dvb developers. Also Sakari Ailus and Laurent Pinchart 
representing Nokia and Vaibhav Hiremath, Sergio Alberto Aguirre Rodriguez, 
Murali Karicheri and Lajos Molnar from Texas Instruments. And also Marek 
Szyprowski, Tomasz Fujak and Jin-Sung Yang from Samsung. And finally from 
Intel I would like to thank Guru Raj and Xiaolin Zhang.

My apologies if I missed someone, but I think I got all the main players 
participating in these discussions listed.

I hope that in August 2010 during the next LPC in Boston I can proudly present 
the results of this summit. It will be great if we can get all this stuff in 
by that time.

Starting tomorrow I'm off on a one-week vacation in Canada, and I'll try to 
make at least part of that week internet-free, so don't expect to hear much 
from me until I'm back in Oslo 10 days from now.

Oh, and if you're ever in Portland then I can really recommend restaurant 
'Veritable Quandary'. The name may be a bit weird, but the food was great!

Regards,

	Hans

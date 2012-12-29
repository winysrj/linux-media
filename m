Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1330 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2L2NBE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 08:01:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [media-workshop] Barcelona Media Summit Report
Date: Sat, 29 Dec 2012 14:00:33 +0100
Cc: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	"linux-media" <linux-media@vger.kernel.org>
References: <201211161358.54938.hverkuil@xs4all.nl> <20121229100813.6057011b@redhat.com> <20121229105338.55b87473@redhat.com>
In-Reply-To: <20121229105338.55b87473@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212291400.33315.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat December 29 2012 13:53:38 Mauro Carvalho Chehab wrote:
> Em Sat, 29 Dec 2012 10:08:13 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> 
> > Hi Hans & others,
> > 
> > Sorry, only today I had time to dig into the Barcelona's media summit report.
> > 
> > I have a few comments for it below.
> > 
> > Regards,
> > Mauro
> > 
> > Em Fri, 16 Nov 2012 13:58:54 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> ...
> 
> Ok, as I'm about to add this at linuxtv website, I'm re-posting the final
> text after my review.
> 
> There's a small format change, as I paste it on Libreoffice, in order to
> make easier to convert to html, but the content should be the one written
> by Hans, with my reviews.

It might be useful to add a pointer to my second draft of the guidelines
for submitting patches:

http://lwn.net/Articles/529490/

Just a suggestion...

Regards,

	Hans

> 
> Regards,
> Mauro
> 
> -
> 
> Barcelona Media Summit Report
> 
> 1 Merging Process
> =================
> The morning was spent discussing the merging process. Basically the number of
>  patch submissions increased from 200 a month two years ago to 700 a month this
>  year. Mauro is unable to keep up with that flood and a solution needed to be
>  found.
> 
> Mauro explained the current merge process, and after that the floor was opened
>  for discussions.
> 
> One of the problems is that it can be difficult to categorize patches since
>  often they are just prefixed with [PATCH]. Depending on who mailed it that
>  might mean an urgent regression fix, a patch that's ready to be merged or a
>  patch that needs review. There is no reliable way of knowing that without
>  actually looking at the mail.
> 
> One thing that we want to improve is to make sure that the regular contributors
>  at least use well defined patch prefixes. That means that we need a standard
>  prefix for regression fixes that need to go into the current rcX kernel asap.
>  This will make it easy to recognize them. We also need a prefix for patches that
>  we want to have reviewed before a final git pull request is posted. Laurent will
>  work into extending patchwork to delegate patches to sub-maintainers when they
>  arrive there.
> 
> There is a distinction between RFC patches and patches you consider final (i.e.
>  ready for merging), but want people to look at. RFC patches will typically need
>  more work, but you want people to check it out and make sure you are going in
>  the right direction. Review patches are what you consider the final version, but
>  you want to give people a final chance to comment on them before posting the pull
>  request.
> 
> We also want to improve the MAINTAINERS file: it must be complete (with the
>  exception of RC keymaps and RC/V4L2/DVB core, where that doesn't make sense). 
> 
> A patch reviewed-by/acked-by from the actual person mentioned in the
>  MAINTAINERS file and that follows the submission rules can be considered
>  with enough review for its merge. Obviously, if someone
>  not responsible for the driver in question has good technical arguments why
>  it's wrong, then that should be taken into account.
> 
> In addition, the current list of media driver maintainers in that file needs
>  to be validated: are all emails still current, and is everyone still willing
>  to maintain their driver?
> 
> New drivers also must come with a MAINTAINERS entry.
> 
> In other words, the MAINTAINERS file will become more important.
> 
> The final decision we made was to appoint submaintainers of parts of the media
>  subsystem. Those submaintainers will take over Mauro's job for those parts
>  that they are responsible for, and make periodic pull requests to Mauro to
>  pull in the patches they have collected.
>  Mauro will still be doing a second review on such patches.
> 
> The submaintainers will be:
> 
> Mike Krufky: frontends/tuners/demodulators
> . In addition he'll be a reviewer for DVB core patches.
> Hans Verkuil: V4L2 drivers and video A/D and D/A subdev drivers (aka video
>  receivers and transmitters). In addition he'll be a reviewer for
>  V4L2 core patches.
> Laurent Pinchart: sensor subdev drivers
> Kamil Debski: codec (aka memory-to-memory) drivers
> Hans de Goede: non-UVC USB webcam drivers
> Guennadi Liakhovetski: soc-camera drivers
> 
> In addition, certain SoC vendors will remain responsible for their own drivers
>  (Samsung, TI) and will keep sending them straight to Mauro.
> 
> The first step is to get the MAINTAINERS file into shape and to improve
>  patchwork, after that we need to clearly document the new structure.
> 
> 2 Requirements for New V4L2 Drivers
> ===================================
> The next topic was to document the requirements for new drivers.
> 
> For the staging tree we want drivers to compile cleanly at the time of submission.
>  Typically, that is all it should take to be accepted into staging.
> It should be noticed though that a driver submitted for staging is a driver that are meant to be
>  promoted one day as a main driver, and someone will actively work on
>  them. So, drivers that can't be promoted to a main driver won't be
>  merged at staging (e. g. drivers for already supported hardware,
>  utterly bogus drivers, ...).
> 
> For inclusion of pure V4L2 drivers into the mainline kernel we require the following:
> 
> Use struct v4l2_device for bridge drivers, use struct v4l2_subdev for
>    sub-device drivers.
> Use the control framework for control handling.
> Use struct v4l2_fh if the driver supports events (implied by the use of
>  controls) or priority handling.
> Use videobuf2 for buffer handling. Mike Krufky will look into extending
>   vb2 to support DVB buffers.
> Must pass the v4l2-compliance tests.
> 
> The criteria for DVB and hybrid V4L2 and DVB drivers should be discussed
>   further at the ML
> 
> Those will be documented likely in Documentation/video4linux/SubmittingDrivers.txt.
> 3 V4L2 Ambiguities
> ==================
> 
> In San Diego we discussed a lot of V4L2 ambiguities and how to resolve them,
>  but we didn't have time to go through all of them. We finished it in Barcelona.
> 
> - What to do if the colorspace is unknown? This happens with UVC webcams that
>   do not report this. The decision was to make a V4L2_COLORSPACE_UNKNOWN. If
>  that is reported, then no colorspace conversion should be attempted by the
>  application.
> 
> - Pixel Aspect Ratio: currently this is only available from VIDIOC_CROPCAP,
>  which conflicts with the new selection API, and it doesn't really belong
>  there anyway.
> 
>   The decision was to implement the pixel aspect ratio as a control, which
>  implies adding a control type for fractions. This needs good documentation
>  and a code example.
> 
> - Should we add a QUERYCAP ioctl for subdevice nodes? The conclusion was that
>  we should add a VIDIOC_SUBDEV_QUERYCAP ioctl. Initially that just needs a
>  version field and some reserved fields and it can be handled in v4l2-subdev.c.
> 
> - Tuner ownership: how should the tuner ownership be handled? The proposal
>  I wrote for this was accepted, with the addition that the code to handle
>  tuner ownership should be shared between DVB and V4L2. I have my name
>  and Hans de Goede's name next to this topic, but I've forgotten what we
>    were supposed to do :-)
> 4 Transport Stream Muxer
> ========================
> 
> ST discussed how to design a driver for a hardware Transport Stream Muxer:
>  this hardware contains a number of DMA engines allowing many transport streams
>  (up to 8192, which is the theoretical maximum) to be muxed into a single big
>  transport stream.
> 
> Due to the large number of possible transport streams one cannot make a video
>  node for each of them. So the solution is to have one memory-to-memory device.
> Every time it is opened you make a new context (filehandle specific) and after
>  setting up the PID (and possibly other (meta) data) you can write the TS to it.
>  There is only one output stream, though. Perhaps we need a new /dev/tsmuxX
>  device node for this, that's still to be decided.
> 
> ST will make an RFC for this idea to discuss this further on the mailinglist.
> 5 DMABUF Testing
> ================
> 
> Progress had been made on this: Laurent showed UVC using DMABUF passing the buffer
> directly to the i915 GPU.
> 6 Asynchronous Loading for Device Tree
> The device tree patches posted by Guennadi were well received, but the part
>  dealing with async loading of devices led to a lot of discussion on the
>  mailinglist so we tried to come to a conclusion during the summit meeting.
> 
> The current patch uses a field in the platform_data of a subdevice to detect
>  whether the bridge driver was present. A better solution is to check for the
>  presence of required resources (e.g. a clock) instead: if not present, then
>  defer probing.
> 
> It was noted that the asynchronous behavior of the device tree will lead to
>  subdevices that are loaded in a random order. This might cause subtle problems
>  in the future if the order of device initialization matters for certain boards.
> It shouldn't matter, but theory and reality are different things. There is
>  nothing that can be done about it at the moment. Should this become a problem,
>  then that should be discussed with the DT developers since this is a DT problem
>  and is not specific to V4L2.
> 
> The 'group' idea in the async loading patches wasn't liked. Instead the suggestion
>  was to provide two different notification methods: a notification when the last
>  required subdev is loaded, and a notification for each loaded subdev. The latter
>  can be used when not all subdevs might be present. In that case the bridge driver
>  needs to be able to decide when sufficient subdevs were found in order to start up.
> 
> 
> 7 Conclusion
> ============
> We managed to get through all topics during this one-day summit, so it was very
>  productive. I'd like to thank all who were there, it's always a pleasure to meet
>  you all!
> 

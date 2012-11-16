Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1336 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2KPM7N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 07:59:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	"linux-media" <linux-media@vger.kernel.org>
Subject: Barcelona Media Summit Report
Date: Fri, 16 Nov 2012 13:58:54 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161358.54938.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the report of the Barcelona Media Summit on November 8. For those who
were in attendence: please correct any mistakes I may have made.

My presentation for the 'Minimum Requirements for New Drivers' and the 'V4L2
Ambiguities' can be found here:

http://hverkuil.home.xs4all.nl/presentations/ambiguities2.odp

I'd appreciate it if other presentations shown during the meeting can be made
available as well.

Enjoy!

	Hans

Merging Process
===============

The morning was spent discussing the merging process. Basically the number of
patch submissions increased from 200 a month two years ago to 700 a month this
year. Mauro is unable to keep up with that flood and a solution needed to be
found.

Mauro explained the current merge process, and after that the floor was opened
for discussions.

One of the problems is that it can be difficult to categorize patches since
often they are just prefixed with [PATCH]. Depending on who mailed it that
might mean an urgent regression fix, a patch that's ready to be merged or a
patch that needs review. There is no reliable way of knowing that without
actually looking at the mail.

One thing that we want to improve is to make sure that the regular contributors
at least use well defined patch prefixes. That means that we need a standard
prefix for regression fixes that need to go into the current rcX kernel asap.
This will make it easy to recognize them. We also need a prefix for patches that
we want to have reviewed before a final git pull request is posted. Laurent will
look into extending patchwork to have such patches be marked as 'Under Review'
automatically.

There is a distinction between RFC patches and patches you consider final (i.e.
ready for merging), but want people to look at. RFC patches will typically need
more work, but you want people to check it out and make sure you are going in
the right direction. Review patches are what you consider the final version, but
you want to give people a final chance to comment on them before posting the pull
request.

We also want to improve the MAINTAINERS file: it must be complete (with the
exception of RC keymaps, where that doesn't make sense). When posting review
patches the reviewed-by/acked-by from the actual person mentioned in the
MAINTAINERS file is sufficient to get the patch merged. Obviously, if someone
not responsible for the driver in question has good technical arguments why
it's wrong, then that should be taken into account.

In addition, the current list of media driver maintainers in that file needs
to be validated: are all emails still current, and is everyone still willing
to maintain their driver?

New drivers also must come with a MAINTAINERS entry.

In other words, the MAINTAINERS file will become more important.

The final decision we made was to appoint submaintainers of parts of the media
subsystem. Those submaintainers will take over Mauro's job for those parts
that they are responsible for, and make periodic pull requests to Mauro to
pull in the patches they have collected.

The submaintainers will be:

- Mike Krufky: frontends/tuners/demodulators
	In addition he'll be the reviewer for DVB core patches.
- Hans Verkuil: V4L2 drivers and video A/D and D/A subdev drivers (aka video
	receivers and transmitters). In addition he'll be the reviewer for
	V4L2 core patches.
- Laurent Pinchart: sensor subdev drivers
- Kamil Debski: codec (aka memory-to-memory) drivers
- Hans de Goede: non-UVC USB webcam drivers
- Guennadi Liakhovetski: soc-camera drivers

In addition, certain SoC vendors will remain responsible for their own drivers
(Samsung, TI) and will keep sending them straight to Mauro.

The first step is to get the MAINTAINERS file into shape and to improve
patchwork, after that we need to clearly document the new structure. Only
when that is done do the new submaintainers start their work.


Requirements for New V4L2 Drivers
=================================

The next topic was to document the requirements for new drivers.

For the staging tree we want drivers to compile at the time of submission.
That is all it should take to be accepted into staging.

For inclusion into the mainline kernel we require the following:

- Use struct v4l2_device for bridge drivers, use struct v4l2_subdev for
  sub-device drivers.
- Use the control framework for control handling.
- Use struct v4l2_fh if the driver supports events (implied by the use of
  controls) or priority handling.
- Use videobuf2 for buffer handling. Mike Krufky will look into extending
  vb2 to support DVB buffers.
- Must pass the v4l2-compliance tests.

This will be documented as well in Documentation/video4linux/SubmittingDrivers.txt.


V4L2 Ambiguities
================

In San Diego we discussed a lot of V4L2 ambiguities and how to resolve them,
but we didn't have time to go through all of them. We finished it in Barcelona.

- What to do if the colorspace is unknown? This happens with UVC webcams that
  do not report this. The decision was to make a V4L2_COLORSPACE_UNKNOWN. If
  that is reported, then no colorspace conversion should be attempted by the
  application.

- Pixel Aspect Ratio: currently this is only available from VIDIOC_CROPCAP,
  which conflicts with the new selection API, and it doesn't really belong
  there anyway.

  The decision was to implement the pixel aspect ratio as a control, which
  implies adding a control type for fractions. This needs good documentation
  and a code example.

- Should we add a QUERYCAP ioctl for subdevice nodes? The conclusion was that
  we should add a VIDIOC_SUBDEV_QUERYCAP ioctl. Initially that just needs a
  version field and some reserved fields and it can be handled in v4l2-subdev.c.

- Tuner ownership: how should the tuner ownership be handled? The proposal
  I wrote for this was accepted, with the addition that the code to handle
  tuner ownership should be shared between DVB and V4L2. I have my name
  and Hans de Goede's name next to this topic, but I've forgotten what we
  were supposed to do :-)


Transport Stream Muxer
======================

ST discussed how to design a driver for a hardware Transport Stream Muxer:
this hardware contains a number of DMA engines allowing many transport streams
(up to 8192, which is the theoretical maximum) to be muxed into a single big
transport stream.

Due to the large number of possible transport streams one cannot make a video
node for each of them. So the solution is to have one memory-to-memory device.
Every time it is opened you make a new context (filehandle specific) and after
setting up the PID (and possibly other (meta) data) you can write the TS to it.
There is only one output stream, though. Perhaps we need a new /dev/tsmuxX
device node for this, that's still to be decided.

ST will make an RFC for this idea to discuss this further on the mailinglist.


DMABUF Testing
==============

Progress had been made on this: Laurent showed UVC using DMABUF passing the buffer
directly to the i915 GPU.


Asynchronous Loading for Device Tree
====================================

The device tree patches posted by Guennadi were well received, but the part
dealing with async loading of devices led to a lot of discussion on the
mailinglist so we tried to come to a conclusion during the summit meeting.

The current patch uses a field in the platform_data of a subdevice to detect
whether the bridge driver was present. A better solution is to check for the
presence of required resources (e.g. a clock) instead: if not present, then
defer probing.

It was noted that the asynchronous behavior of the device tree will lead to
subdevices that are loaded in a random order. This might cause subtle problems
in the future if the order of device initialization matters for certain boards.
It shouldn't matter, but theory and reality are different things. There is
nothing that can be done about it at the moment. Should this become a problem,
then that should be discussed with the DT developers since this is a DT problem
and is not specific to V4L2.

The 'group' idea in the async loading patches wasn't liked. Instead the suggestion
was to provide two different notification methods: a notification when the last
required subdev is loaded, and a notification for each loaded subdev. The latter
can be used when not all subdevs might be present. In that case the bridge driver
needs to be able to decide when sufficient subdevs were found in order to start up.


Conclusion
==========

We managed to get through all topics during this one-day summit, so it was very
productive. I'd like to thank all who were there, it's always a pleasure to meet
you all!

Regards,

	Hans Verkuil

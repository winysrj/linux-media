Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55273 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750908AbeAPJM1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 04:12:27 -0500
Date: Tue, 16 Jan 2018 11:11:54 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: media-workshop@linuxtv.org
Subject: [ANN] Prague Media summit report October 2017
Message-ID: <20180116091154.tcn2rlhcan5bnioe@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

Here's the Prague Media summit report from 26th and 27th October 2017. It
took long but finally it's here!

If you feel something important is missing or incorrect, feel free to
reply.


First day
*********

The first day was mostly concentrated on discussing the media development
process. No notes were done at the time of the meeting, so any report here
is based on my own recollection may be unrepresentative of the entire
meeting. 

Attendees

	Sakari Ailus                                                                  - Mauro Carvalho Chehab                                                         
	Shuah Khan                                                                    
	Mike Krufky                                                                   
	Gustavo Padovan                                                               
	Laurent Pinchart                                                              
	Niklas Söderlund                                                              
	Hans Verkuil                                                                  


Media development statistics
============================

Mauro gave a presentation on media tree development statistics he's been
collecting. The slides can be found here:

<URL:https://linuxtv.org/downloads/presentations/media_summit_2017/media_summit_process.pdf>


Media device sharing
====================

Media device sharing was discussed during the first day as well. The use
case is related to a USB device that in Linux has several interfaces (?)
which in Linux are devices. The purpose of this would be to show entities
backed by different devices from the same USB device, without either of the
drivers being necessarily aware of each other. The USB device is also hot
unpluggable, meaning that the devices backing the media entities in the
media graph may disappear, and do so in any order as they could appear.

Media device sharing requires improvements to the Media controller
framework. Especially:

- The Media controller framework assumes the media device is backed by a
  single struct device. There's also an ops struct, also related to a
  single driver. There may no longer be 1:1 relation between these two and
  the media device.

- Object lifetime management. Object lifetime management has been found to
  be not designed well enough in Media controller in general. The original
  use case was non-hotpluggable devices and the early efforts address the
  problem were focussed in preventing unbinding of drivers from devices in
  various ways. This need to be properly addressed, with refcounts, so that
  the necessary memory objects for various operations will stay where
  needed as long as needed. (I'm not going to details here. Work has been
  done to this end but it is not complete yet.)


Second day
**********

The report on the second day is based on the notes written during the
meeting. The raw notes can be found here:

<URL:http://www.retiisi.org.uk/v4l2/notes/media-summit-2017.html>

Attendees

	Jacopo Mondi
	Mauro Chehab
	Niklas Söderlund
	Benoit Parrot
	Pavel Machek
	Ricardo Ribalda
	Dimitrios Katasaros
	Laurent Pinchart
	Hans Verkuil
	Gustavo Padovan
	Alexandre Courbot
	Sakari Ailus
	Mike Krufky
	Brad Love
	Tomas Dratva


CEC status
==========

Hans gave a presentation on CEC status. The slides are available here:

<URL:https://linuxtv.org/downloads/presentations/media_summit_2017/cec-status.pdf>

Latest CEC status is always available here:

<URL:https://hverkuil.home.xs4all.nl/cec-status.txt>

Side note: should we use the new serial bus (serdev) for the RC serial
driver?


Explicit synchronization in V4L2
================================

Gustavo gave a presentation on explicit synchronisation in V4L2. It's
available here:

<URL:https://linuxtv.org/downloads/presentations/media_summit_2017/2017-MediaSummit-Fences.pdf>

In-fences are easy, there is no large issue in the RFC.

Out-fences, however, are subject to buffer reordering issues. A new event
has been created to report buffer order to userspace. Fences are created at
QBUF time, but can't be used by userspace until an event reports which
buffer will be available next.

Not all drivers perform reordering. As an optimization a capability flag
could tell userspace that buffers are always ordered and that events are
not needed. The capability flag should likely happen at/after setting
format, as out-of-order depends on the video format

Reordering is mostly useful for codecs, and can also occur from buffer
recycling internally in drivers when capture errors happen. While recycling
is allowed by V4L2, we could forbid it when fences are used. In that case
all buffers would be returned to userspace in order, and errors be reported
with the error flag set.

We may need to make capture queues not reorder buffers as well, so
basically if we are using in-fences we don't let the bufffers reorder.

So when there is no reorder we can return the buffer's fence at the QBUF
time and not need the OUT_FENCE event for these cases.

If the user doesn't pickup the outstanding OUT_FENCE event before DQBUF
just set the fence to -1 at DQBUF time.

Discussion if timestamps are enough for audio/video synchronization... and
what kind of timestamps to use. Wall clock timestamps are not usable for
synchronisation, monotonic is the way to go. Converting device timestmaps
to monotonic in the kernel can be troublesome. Time stamping with fences
--- time stamps related to buffers are only available at dqbuf time (unless
SoF events are being used, and they're supported by only some hardware).
This is too late in some use cases, if the timestamp is used to determine
when the frame should be displayed.

Capture to networking (a.k.a. partial fences) - We need to move from a
frame-based API to a slice-based API. The problem isn't limited to fences,
the whole V4L2 API is based on frames. Latency could be lowered in this
way, but it isn't clear whether frame-based handling is the main source of
latency in any use case. To support very low latency (mostly for
professional video use cases) we would need to redesign all buffer handling
in V4L2. We'll postpone this for now until someone comes with a convincing
use case and enough resources to implement it.


Media Subsystem Maintainance
============================

Some years ago V4L2 sub-maintainers were introduced to address recognised
bottlenecks (there's only one Mauro, for instance). Today we have more
contributors but the number of V4L2 and Media core developers who actively
review patches submitted to the list remains small. The current model
appears to have its limits as well, which is also why we're looking how
others are doing their work.

Gustavo explained how the DRM subsystem is maintained. The DRM subsystem
consists of the core of the subsystem and individual drivers, a large part
of which are maintained in the drm-misc tree. The drm-misc tree is also the
target for small core changes and DRM-wide changes.

The drm-misc tree has a number of committers (37 at the time of the
presentation was given) who also review each others patches. The model
switch was done as there were many contributors and bottlenecks due to
that.

Each drm-misc committer has the ability to push patches to the same, common
branch, naturally requiring the patches to be reviewed on the mailing list.
Once a consensus is eached among the drm-misc developers reviewing the
patch, a patch may be merged.

A pull request is sent, by one or the drm-misc maintainers (of which there
are three), to David Arlie from the common branch weekly. Dave merges this
pull request to his tree.

Committers of the drm-misc tree take great care in ensuring the quality of
their code base. This has lead to improved developer skills among the
existing developers due to more challenging and responsible work. This, in
turn, makes it harder for patches to fall through the cracks as there are
many reviewers and committers capable of doing the required work to get the
code merged.

Such model has attracted more contributors and solved process bottlenecks.
There is a policy that would lead on removing committer rights if abused.
However, there wasn't any incident so far that justified the removal of
committer right.

Bad patches getting merged will be reverted, or hopefully, not getting
merged in the first place.

Could media subsystem switch to this model?
-------------------------------------------

The DRM guys have a set of tools that support their work flow. These tools
are nor DRM specific as such but they currently do contain DRM specific
configuration that would need to be moved to a configuration file before
the tools were usable for media tree development.

Right now, the media subsystem is rather complex, containing multiple
different kernel APIs and frameworks (e.g. V4L2, DVB, Media controller) and
a large number of drivers using them. Mauro, the media tree maintainer,
does have checks in place to catch patches that could potentially cause
havoc if merged to Linus's tree in form of breaking the user space API. If
the media tree would be maintained by a group of committers instead,
similar checks would have to be in place in order to avoid breakages that
are visible outside the subsystem.

Developers often test the patches and may perform compile tests (e.g.
through 01.org's kbuild test robot) but they may be missed just after the
final, trivial changes that sometimes end up breaking things. For instance,
before pushing new patches to the master branch, the following checks
should be automatically performed so that developers don't end up pushing
stuff that's not good to go there:

	- Perform checkpatch.pl checks, ensures the branch has the correct
	  baseline and does check for many errors

	- Compile the new patches.

	- Destructive push to the master branch need to be prevented.

	- Question to Mauro: what kind of checks are you actually
	  performing on the patches you apply or pull requests you pick the
	  patches from?

Could Jenkins or 0day be helpful here? Jenkins would require more infra on
our side whereas 0day already exists. 0day requires explicit instructions
to check a kernel git tree periodically, this is managed by Fengguang Wu
(fengguang.wu at intel.com).

Security
--------

Having more committers places more strict requirements on developer machine
security. This is because many more people have push access to the master
branch, essentially there are many more points where development tree
integrity may be compromised. (Note: nothing will tell you this has
happened; push done by an attacker on a developer's machine looks exactly
like a developer would have done that.)

Konstantin Ryabitsev gave an excellent presentation on securing developer
workstations (outside Media summit); I couldn't find a video (I guess there
was no camera) but the slides are online:

<URL:https://mricon.com/talks/osseu17.pdf>

Patchwork
---------

- No information in patchwork e-mails on who acted on a patch. This would
  be important to add.

- patchwork.linuxtv.org is using 1.x version of Patchwork. Switch to 2.x
  should be done, but there are database incompatibilities between the two.
  Is there a migration script?

- The alternative is to use kernel.org patchwork. This has been troublesome
  in the past and it is not known it'd be less so now. (Why so escaped me.)


Media subsystem documentation
=============================

Mauro made a presentation on the state of the documentation of the media
subsystem. It is available here:

<URL:https://linuxtv.org/downloads/presentations/media_summit_2017/media_summit_documentation.pdf>

In the following discussion it was pointed out that videobuf2 has been
mostly undocumented but this hasn't been a problem in practice: the API is
sensible, and the drivers using videobuf2 are mostly doing the right thing.
This does not excuse the lack of documentation however.

There's a push to split kAPI and uAPI documentation in the kernel. V4L2 now
has them combined in a single document. The reason for the push is that the
audiences to the two APIs are largely different.

Related to the above Mauro gave this presentation in the KS documentation
session:

<URL:https://linuxtv.org/downloads/presentations/media_summit_2017/ks_documentation_session.pdf>

While the V4L2 reference documentation is in a very good shape, how-to-type
documentation is not available for application developers who have little
idea of how to use the API. The reference documentation does not help here.

Where should KernelDoc function documentation go to?
----------------------------------------------------

It was discussed whether KernelDoc documentation should be placed in
headers vs. in .c files. The points raised were (the list may be
inconclusive):

- Keeping the documentation in headers may result in changing the
  function but missing changing the documentation. This could happen as the
  developer misses the documentation in header file, which is entirely
  plausible if the function prototype is not changed.
  
- Some prefer to have the documentation with the interface
  definition, on the grounds it is easier to browse it that way. Tools such
  as C-scope do find definitions of functions based on the function
  definition itself, not the prototype in the header.

- Some saw extensive documentation fitting better to the header.
  The .c files could grow significantly due to documentation, making it
  more difficult to work with the code in them.

It was decided to keep KernelDoc function documentation in the header
files.

SoC camera removal
------------------

There are not many drivers left using the SoC camera framework.

sh-ceu is being converted by Jacopo to a proper V4L2 driver. This work is
ongoing.

V4L2 clock used by SoC camera, pxa_camera and two i2c sensor drivers only.
One option for the two sensor drivers could be to just remove them; they
can be brought back if needed.

Videobuf1 removal
-----------------

atomisp staging driver and more than 10 non-staging drivers still use
videobuf1. One of the most notable ones are bttv. Work would be needed to
convert these drivers to videobuf2.


Request API
===========

Alexandre Courbot gave a presentation on the V4L2 jobs API, which is
effectively intended to address the same problem area than the Media
request API.

There is interest in getting request API to upstream. Several classes of
hardware need it, including cameras supporting Android camera HAL v3 and
stateless video codecs, the two main use cases at hand at the moment. The
request API involves, in principle, all API elements and aspects of the
V4L2 and Media controller APIs. This requires forward-looking approach in
the implementation which will unlikely to be a complete one in the
beginning.

The Request API approach uses the media controller to create request
objects. Note that this does not work if there are multiple media
controllers involved that need to coordinate. As a consequence, devices
managed by different drivers cannot be part of the same request.

The MC approach requires that stateless codec drivers implement a media
graph which is just a video node with two pads and a codec subdev with two
pads.

An old version of the Request API is in use by ChromeOS for several HW
codecs for several years now. Support for this should be done first to
prevent the risk that vendors will drop V4L2 support and find other
solutions. The API should be extensible to the complex video pipeline
use-case, though.

In order to support stateless codecs we add support for the request API to
the V4L2 ioctls that need this (ioctls operating on struct v4l2_buffer and
v4l2_ext_controls). Creating, cloning, applying and deleting request
objects is done through the media controller.

In the long run we want to be able to set the request data for all bridge
and subdev drivers with a single MC ioctl. As part of this we could make
the control framework more generic: i.e. no longer V4L2 specific but a
generic media framework. This would be similar to the DRM atomic framework.

Note that Media device complexes may have devices that are out of scope of
requests such as slow i2c devices where you still have to hit the frame
related to the request. So what do you do if you miss? This would require
additional complex cross-driver mechanisms in kernel. At least for now make
user space responsible for applying configurations to such devices.

A request object is essentially created empty from the point of view of the
user. Only values that are changed in the request are part of the request,
other values remain unchanged (unless those values change due to a
side-effect of setting a request value). When a request completes, make a
copy of the volatile controls (since that's the value at that point in
time). This is needed for auto-<whatever> functions that need to know such
volatile values.

It should be possible to poll on the request's file handle and be woken up
when the request is done.

When dequeuing a buffer the kernel will set the request field to a request
filehandle if the buffer is associated with a request. The kernel knows
this information, so userspace doesn't have to set this field.

Todo: Implement polling for request file handles. This allows polling for
specific requests, e.g. as get woken up when the last request in a set of
requests is done.


Actions
-------
    
    Laurent: check the suitability of DRM tooling for V4L2

    Mauro: check if kernel.org improved patchwork support.

    Hans: tentative (not this year) convert old videobuf documentation to
	  videobuf2.

    Alexandre: MC Request API (REQUEST_CMD), with request components
	       through V4L2 devices, request creation and queueing through
	       MC

    Hans: control framework API: sync with Alexandre by 2nd week of
	  November at the latest.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com

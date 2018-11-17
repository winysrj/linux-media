Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41612 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725743AbeKRJDT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Nov 2018 04:03:19 -0500
Date: Sun, 18 Nov 2018 00:45:02 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, media-workshop@linuxtv.org
Subject: [ANN] Edinburgh Media Summit 2018 meeting report
Message-ID: <20181117224502.63hz6sh5qd6heolu@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,


Here's the report on the Media Summit held on 25th October in Edinburgh.
The report is followed by the stateless codec discussion two days earlier.

Note: this is bcc'd to the meeting attendees plus a few others. I didn't
use cc as the list servers tend to reject messages with too many
recipients in cc / to headers.

Most presenters used slides some of which are already available here
(expect more in the near future):

<URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/>

The original announcement for the meeting is here:

<URL:https://www.spinics.net/lists/linux-media/msg141095.html>

The raw notes can be found here:

<URL:http://www.retiisi.org.uk/~sailus/v4l2/notes/osseu18-media.html>


Attendees
---------

	Brad Love
	Ezequiel Garcia
	Gustavo Padovan
	Hans Verkuil
	Helen Koike
	Hidenori Yamaji
	Ivan Kalinin
	Jacopo Mondi
	Kieran Bingham
	Laurent Pinchart
	Mauro Chebab
	Maxime Ripard
	Michael Grzeschik
	Michael Ira Krufky
	Niklas Söderlund
	Patrick Lai
	Paul Elder
	Peter Griffin
	Ralph Clark
	Ricardo Ribalda
	Sakari Ailus
	Sean Young
	Seung-Woo Kim
	Stefan Klug
	Vinod Koul


CEC status - Hans Verkuil
-------------------------

Hans prensented an update on CEC status. Besides the slides, noteworthy
information is maintained here:

<URL:https://hverkuil.home.xs4all.nl/cec-status.txt>

Slides:
<URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/media-cec-status.pdf>

rc-core status report - Sean Young
----------------------------------

(Contributed by Sean Young)

In the last year all staging lirc drivers have been either removed
or ported to rc-core. Decoding of the more obscure IR protocols and
protocol variants can now be done with BPF, with support in both the
kernel and ir-keytable (which is in v4l-utils). Generally we're in a good
situation wrt IR support.

There is some more ancient hardware (serial or usb-serial) that does not
have support but not sure if anyone cares. kernel-doc is a little sparse
and does not cover BPF IR decoding, so that needs improving. There was a
discussion on enabling builds with CONFIG_RC_CORE=n. Sean suggested we
could have rc_allocate_driver() return NULL and have the drivers deal
with this gracefully, i.e. their probe functions should continue without
IR. Mauro said there should be a per-driver config option (as is done
for saa7134 for example).

No conclusion was reached on this.


Persistent storage of controls - Ricardo Ribalda
------------------------------------------------

Ricardo gave a presentation on a proposed solution for using the V4L2
control framework as an interface for updating control value defaults on
sensor EEPROM.

Sensors commonly come with device specific tuning information that's
embedded in the device EEPROM. Whereas this is also very common for raw
cameras on mobile devices, the discussion this time was concentrated on
industrial cameras.

The EEPROM contents may be written by the sensor vendor but occasionally
may need to be updated by customers. Setting the control default value was
suggested as the exact mechanism to do this.

The proposal was to use controls as the interface to update sensor tuning
information in the EEPROM.

There were arguments for and against the approach:

+ Drivers usually get these things right: relying on an user space program
  to do this is an additional dependency.
+ Re-use of an existing interface (root priviledge check may be added).

- Partial solution only: EEPROM contents may need to be updated for other
  reasons as well, and a "spotty" implementation for updating certain
  EEPROM locations seems very use case specific.
- Changes required to the control framework for this --- defaults are not
  settable at the moment.
- The need is very use case specific, and adding support for that in a
  generic framework does not seem to fit very well.

The general consensus appears to be not to change the control framework
this way, but to continue to update the EEPROM using a specific user space
program.


Tooling for sub-system tree maintenance - Laurent Pinchart
----------------------------------------------------------

Laurent talked about the DRM tree maintenance model.

The DRM tree has switched to co-maintainer model. This has made it possible
to share the burden of tree maintenance, removing bottlenecks they've had.

The larger number of people having (and using) their commit rights has
created the need for a more strict rules for the tree maintenance, and
subsequently a tool to implement it. It's called "DIM", the DRM Inglorious
Maintenance tool. This is a command line tool that works as a front-end to
execute the workflow.

<URL:https://01.org/linuxgraphics/gfx-docs/maintainer-tools/dim.html>

In particular what's worth noting:

- The conflicts are resolved by the committer, not by the tree maintainer.

- DIM stores conflict resolutions (as resolved by developers) to a shared
  cache.

- DIM makes doing common mistakes harder by using sanity checks.

There are about 50 people who currently have commit rights to the DRM tree.
There are no reports of commit rights having been forcibly removed as of
yet. This strongly suggests that the model is workable.

The use of the tool puts additional responsibilities as well as some burden
to the committers. Before the patches may be pushed, they are first
compiled on developer's machine. That requires time, and without special
arrangements such as having a second local workspace, and that time is away
from productive work.

The discussion that followed was concentrated on the possibility of using a
similar model for the media tree. While the suggestion was initially met by
mostly favourable reception, there were concerns as well.

V4L2 *was* maintained generally according to the suggested model --- albeit
without the proposed tools or process that needed to be strictly followed.
There was once an incident which involved merging around 9000 lines of
unreviewed code in a lot of places. What followed was not pretty, and this
eventually lead to loss of multiple developers.
  
Could this happen again? The DRM tree has not suffered such incidents, and
generally it understood such incident could be addressed by simply
reverting such a patch and removing commit rights if necessary. (Editor
note: we have reverted the media tree master state to an earlier commit
many times for various reasons. Could it be one of the reasons the 9000
line patch was not reverted was that the version control wasn't based on
git??)

Some opined that we do not have a bottleneck in reviewing patches and
getting them merged whilst others thought this was not the case. It is
certainly true that a very large number of patches (around 500 in the last
kernel release) went in through the media tree. It still appears that there
would be more patches and more drivers to get in if the throughput was
higher.


Current status of testing on the media tree - Sakari
----------------------------------------------------

The common practice in media subsystem development is that developers do
test their patches before submitting them. This is an unwritten rule:
sometimes patches end up not being tested after making slight changes to
them, or they have been tested on a different kernel version. The developer
may also simply forget to test the patch.

Besides this, it is not uncommon that changing the kernel configuration or
switching to a different architecture will cause a compilation warning or
an error.

The 0-day bot will catch some of these errors before the patches are
merged, but that testing does not fully cover all the possible cases. There
are some common pain points in V4L2-related Kconfig options (plain V4L2, MC
or MC + subdev uAPI); newly submitted drivers may in fact require one of
these, but the developer may not have realised that and so this ends up not
being taken into account in Kconfig.

Once the review is done, and after being applied to the sub-maintainer
tree, a patch is applied to Mauro's local tree and Mauro performs
additional tests on it. These tests currently prevent a fair number of
problems reaching a wider audience than the media developers.

On the other hand, whenever an issue is found, the patch will have to be
fixed by the sub-maintainer or the developer. This is hardly ideal, as the
problem has existed usually for a month or two before being spotted --- by
a program. These checks should be instead performed on the patch when it's
submitted.


Automated testing - Ezequiel Garcia
-----------------------------------

Ideal Continuous Integration process consists of the following steps:

	1. patch submission
	2. review and approval
	3. merge

The core question is "what level of quality standards do we want to
enforce". The maintenance process should be modelled around this question,
and not the other way around. Automated testing can be a part of enforcing
the quality standards.

There are three steps:

	1. Define the quality standard
	2. Define how to quantify quality in respect to the standard
	3. Define how to enforce the standards

On the tooling side, an uAPI test tool exists. It's called v4l2-compliance,
and new drivers are required to pass the v4l2-compliance test.
It has quite a few favourable properties:

- Complete in terms of the uAPI coverage
- Quick and easy to run
- Nice output format for humans & scripts

There are some issues as well:

- No codec support (stateful or stateless)
- No SDR or touch support
- Frequently updated (distribution shipped v4l2-compliance useless)
- Only one contributor

Ezequiel noted that some people think that v4l2-compliance is changing too
often but Hans responded that this is a necessity. The API gets amended
occasionally and the existing API gets new tests. Mauro proposed moving
v4l2-compliance to the kernel source tree but Hans preferred keeping it
separate. That way it's easier to develop it.

To address the problem of only a single contributor, it was suggested that
people implementing new APIs would need to provide the tests for
v4l2-compliance as well. To achieve this, the v4l2-compliance codebase
needs some cleanup to make it easier to contribute. The codebase is larger
and there is no documentation.

V4l2-compliance also covers MC, V4L2 and V4L2 sub-device uAPIs.

DVB will require its own test tooling; it is not covered by
v4l2-compliance. In order to facilitate automated testing, a virtual DVB
driver would be useful as well. The task was added to the list of projects
needing volunteers:

<URL:https://linuxtv.org/wiki/index.php/Media_Open_Source_Projects:_Looking_for_Volunteers>

There are some other test tools that could cover V4L2 but at the moment it
seems somewhat far-fetched any of them would be used to test V4L2 in the
near future:

	- kselftest
	- kunit
	- gst-validate
	- ktf (https://github.com/oracle/ktf, http://heim.ifi.uio.no/~knuto/ktf/)

KernelCI is a test automation system that supports automated compile and
boot testing. As a newly added feature, additional tests may be
implemented. This is what Collabora has implemented, effectively the
current demo system runs v4l2-compliance on virtual drivers in a virtual
machines (LAVA slaves).

A sample of the current test report is here:

<URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg135787.html>

The established way to run KernelCI tests is off the head of the branches of
the stable and development kernel trees, including linux-next. This is not
useful as such to support automated testing of patches for the media tree:
the patches need to be tested before they are merged, not after merging.

In the discusion that followed among a slightly smaller group of people, it
was suggested that tests could be run from select developer kernel trees,
from any branch. If a developer needs long-term storage, (s)he could have
another tree which would not be subject automated test builds.
Alternatively, the branch name could be used as a basis for triggering
an automated build, but this could end up being too restrictive.

Merging the next rc1 by the maintainer would be no special case: the branch
would be tested in similar way than the developer branches containing
patches, and tests should need to pass before pushing the content to the
media tree master branch.

Ezequiel wished that people would reply to his e-mail to express their
wishes on the testing needs (see sample report above).


Stateless codecs - Hans Verkuil
-------------------------------

Support for stateless codecs will be merged for v4.20 with an Allwinner
staging codec driver.

The earlier stateless codec discussion ended up concluding that the
bitstream parsing is application specific, so there will be no need for a
generic implementation that was previously foreseen. The question that
remains is: should there be a simple parser for compliance testing?

All main applications support libva which was developed as the codec API to
be used with Intel GPUs. A libVA frontend was written to support the
Cedrus stateless V4L2 decoder driver. It remains to be seen whether the
same implementation could be used as such for the other stateless codec
drivers or whether changes, or in the worst case a parallel implementation,
would be needed.

Slides:
<URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/media-codec-userspace.pdf>


New versions of the old IOCTLs - Hans Verkuil
---------------------------------------------

V4L2 is an old API with shifting focus in terms of functionality and
hardware supported. While there has been lots of changes to the two during
the existence of V4L2, some of the API is unchanged since the old
times. While the API is usable for the purpose, it is needlessly clunky: it
is often not obvious how an IOCTL is related to the task at hand (such as
using S_PARM to set the frame interval) or the API does not use year
2038-safe timestamps (struct v4l2_buffer). These APIs deserve to be
updated.

* VIDIOC_*_PARM

In the case of VIDIOC_G_PARM and VIDIOC_S_PARM, the IOCTLs are only used to
set and get the frame interval. In this case, what can be done, is to add a
new IOCTL definition, with the same IOCTL number and with binary-equivalent
IOCTL argument struct that only contains the field for the frame rate
itself. This is binary-compatible with the existing code and no
compatibility code will be needed. The new IOCTLs will be called
VIDIOC_G_FRAME_INTERVAL and VIDIOC_S_FRAME_INTERVAL.

* VIDIOC_ENUM_FRAME_INTERVALS

Besides discrete set of supported frame intervals,
VIDIOC_ENUM_FRAME_INTERVALS has stepwise frame interval as well. Stepwise
could be removed as the Qualcomm venus codec and uvc (100 ns units) are the
only users. Additionally, the buffer type should be added to struct
v4l2_frmivalenum.

There was also a discussion related to enumerating frame intervals in units
of ns vs. fractional seconds. The reasoning using a fraction is that this
way the frame interval on many standards can be conveyed precisely.
Somebody recalled "flick", that is is the common denominator of the frame
rates on all TV standards. Drivers could simply move to use the flick as
the denominator, to make frame interval reporting uniform across the
drivers.

* struct v4l2_buffer

struct v4l2_buffer is an age-old struct. There are a few issues in it:

- The timestamp is not 2038-safe.
- The multi-plane implementation is a mess.
- Differing implementation for the end single-plane and multi-plane APIs is
  confusing for both applications and drivers.

The proposal is to create a new v4l2_buffer struct. The differences to the
old one would be:

- __u64 timestamps. These are 2038-safe. The timestamp source is
  maintained, i.e. the type remains CLOCK_MONOTONIC apart from certain
  drivers (e.g. UVC) that lets the user choose the timestamp.
- Put the planes right to struct v4l2_buffer. The plane struct would also
  be changed; the new plane struct would be called v4l2_ext_plane.
- While at it, the plane description can be improved:
	- The start of data from the beginning of the plane memory.
	- Add width and height to the buffer? This would make image size
	  changes easier for the codec. (Ed. note: pixel format as well.
	  But this approach could only partially support what the request
	  API is for.)
- Unify single- and multi-planar APIs.

The new struct could be called v4l2_ext_buffer.

As the new IOCTL argument struct will have has different syntax as well as
semantics, it deserves to be named differently. Compatibility code will be
needed to convert the users of the old IOCTLs to the new struct used
internally by the kernel and drivers, and then back to the user.

* struct v4l2_create_buffers

Of the format, only the pix.fmt.sizeimage field is effectively used by the
drivers supporting VIDIOC_CREATE_BUFS. This could be simplified, by just
providing the desired buffer size instead of the entire v4l2_format struct.
The user would be instructed to use TRY_FMT to obtain that buffer size.

The need to delete buffers seems to have eventually surfaced. That was
expected, but it wasn't known when this would happen. As the buffer index
range would become non-contiguous, it should be possible to create buffers
one by one only, as otherwise the indices of the additional buffers would
no longer be communicated to the user unambiguously.

So there would be new IOCTLs:

- VIDIOC_CREATE_BUF - Create a single buffer of given size (plus other
		      non-format related aspects)
- VIDIOC_DELETE_BUF - Delete a single buffer
- VIDIOC_DELETE_ALL_BUFS - Delete all buffers

The naming still requires some work. The opposite of create is "destroy",
not "delete".

* struct v4l2_pix_format vs. struct v4l2_pix_format_mplane

Working with the two structs depending on whether the format is
multi-planar or not is painful. While we're doing changes in the area, the
two could be unified as well. (Editor note: this could be still orthogonal
to the buffers, so it could be done separately as well. We'll see.)

Slides:
<URL:https://www.linuxtv.org/downloads/presentations/media_summit_2018/media-new-ioctls.pdf>


Fault tolerant V4L2 - Kieran Bingham
------------------------------------

Kieran presented a system where the media hardware complex consisted of
eight more or less independent camera sensors that naturally end up being
within a single media device.

The current implementation, as well as the API, necessitates that all
devices in a media device probe successfully before the entire media device
is exposed to the user. Otherwise the user would see with a partial
view of the device, without the knowledge it is such.

To address the problem, additional information need to be provided to the
user space. In particular:

- Events on the media device to tell the graph has changed.

- Graph version number is incremented at graph change (already
  implemented).

- The property API could be applicable --- placeholders for entities that
  have not yet appeared?

	- Alternative: known entities that have failed to probe created in
	  the media graph and marked "disable" or "failed".

- Query the state of media graph completeness.

That way, even when the devices in a media controller device appear one by
one, the user space will be able to have all the necessary information on
the registration state of the device.


Complex cameras - Mauro Chehab
------------------------------

Some new laptops integrate a raw Bayer camera + ISP instead of a USB
webcam. This is expected to increase, as the solution is generally cheaper
and results in better quality images --- as long as all the pieces of the
puzzle are in place, including the proprietary 3A library.

Still, such devices need to be supported.

(Ed. note: there were two talks related to this topic given in the ELc-E.)

<URL:https://www.youtube.com/watch?v=KpaNNJr92CY&index=31&list=PLbzoR-pLrL6qThA7SAbhVfuMbjZsJX1CY>
<URL:https://www.youtube.com/watch?v=GIhV7tiUji0&index=60&list=PLbzoR-pLrL6qThA7SAbhVfuMbjZsJX1CY>


Development process - All
-------------------------

Topic-wise this is continuation of the "Tooling for sub-system tree
maintenance", "Current status of testing on the media tree" and "Automated
testing" topics above.

The question here is whether there's something that could be improved in
the media development process and if so, how could that be done.

What came up was a suggestion to have multi-committer tree in a similar
manner as the DRM developers do. This was seen to be more interesting for
developers than simply being asked to review patches.

It certainly does raise the need for more precise rules for what may be
committed to the multi-committer tree, when etc.

It was also requested that experienced driver maintainers would send pull
requests on patches to their drivers instead of going through a
sub-maintainer (pre-agreed with the relevant (sub)maintainer). This would
take some work away from sub-maintainers, but not the maintainer.

No firm decisions were reached in this topic. Perhaps this could be tried
out?

There was also a request to document the sub-maintainer names in the wiki
so that it'd be easier for people to figure out who to ping if their
patches do not get merged.


linuxtv.org hosting - All
-------------------------

Mauro noted that linuxtv.org is currently hosted in a virtual machine
somewhere in a German university. The administrator of the virtual machine
has not been involved with Video4Linux for some time but has been kind to
provide us the hosting over the years.

It has been recognised that there is a need to find a new hosting location
for the virtual machine. There is also a question of the domain name
linuxtv.org. Discussion followed.

What could be agreed on rather immediately was that the domain name should
be owned by "us". "Us" is not a legal entity at the moment, and a practical
arrangement to achieve that could be to find a new association to own the
domain name.

The hosting of the virtual machine could possibly be handled by the same
association. In practice this would likely mean a virtual machine on a
hosting provider. Ideally this would be paid for by a company or a group of
companies.

No decisions were reached on the topic.


Tuesday's stateless codec discussion
------------------------------------

Hans presented a summary of this in his stateless codec status
presentation, here are a bit more details.

We had a discussion (first in the Microsoft sponsor suite, then at the bar)
on how to support user space for the stateless codecs better. The expected
outcome of that would be a rough understanding how a stateless codec user
space library would look like.

The raw notes are available here:

<URL:http://www.retiisi.org.uk/~sailus/v4l2/notes/osseu18-codecs.html>

* Attendees

    Alexandre Courbot
    Chris Healy
    Ezequiel Garcia
    Hans Verkuil
    Kieran Bingham
    Laurent Pinchart
    Maxime Ripard
    Mauro Carvalho Chehab
    Nicolas Dufresne
    Niklas Söderlund
    Philip Zabell
    Sakari Ailus
    Tomasz Figa
    Victor Jáquez

* Buffer management

Nicolas reported an issue in V4L2 buffer management. The V4L2 decouples the
buffers from the format, and assumes all queued buffers (at a given point
of time) have the same format. (Ed. note: the request API could be used to
address this, but that particular features is not yet supported.)

* User space library

The existing projects generally integrate their own bitstream parsers for
codecs. There are subtle reasons why that tends to be the case, instead of
using more generic parsers. There are differences in error handling, for
instance, or other matters of policy, the variation which could be
difficult to fully offer using a generic API.

Maxime noted that VLC recently released a new parser meant to be used as a
library, and that could be useful. Nicolas believes that we'd need a parser
library independent of any other code base to avoid pulling in extra
libraries and this parser would need to be maintained. It could be
difficult to find the volunteers to do that.

Does ChromeOS have its own parser? Alexandre believes it does, but little
was known beyond that.

There's also the language problem: ffmpeg and gstreamer are written in C,
the ChomeOS parser in C++, VLC is moving to Rust. What do we pick, how do
we ensure interoperability?

* libVA re-use

As a short-term solution, implementing a generic wrapper using the V4L2
stateless codec API to offer libVA API would enable generic applications to
use the V4L2 stateless codec drivers as most applications already support
libVA.

70 % of the applications use FFMPEG, which has a software codec API that is
nearly identical to the V4L2 statless codec API. It would be trivial for
applications to switch to V4L2 natively.

Mauro would like us to explain our plans to Intel to avoid surprises later
on.

* Source code hosting

libva is hosted on freedesktop. Should we host the libva-v4l2-codec backend
there, or host it on linuxtv.org? Hans would prefer linuxtv.org as it's
"closer to our kernel implementation".

* Backend support in libva

libva loads backends in order, and picks the first one that reports it can
support the platform. There is also an environment variable that can
specify a backend. Ezequiel enquired how to support platforms that would
have multiple hardware codecs. libva doesn't seem to support this at the
moment. Nicolas reported that there's an Intel SoC that have both an Intel
graphics core and a Vega64 graphics core that both have a codec.

Hans said that a platform that expose multiple codecs will likely be used
for specialized applications, and requiring those to implement codec
support directly is acceptable. Our main focus should be to support the
common case.

* Vendor support

NVidia is following our progress and is interested in using the V4L2
stateless API. On the userspace side, vdpau is pretty much dead, they have
moved to nvdec. OMX is being phasing out, in particular that is taking
place for RaspberryPi now.

* Tooling

bootlin has developed a debugging tool called v4l2-request-test
(https://github.com/bootlin/v4l2-request-test) that has been very useful to
debug the codec driver without going through the full userspace stack. This
is worth mentioning and integrating.

* API discussions

Using buffer indices as handles to reference frames

This has been proposed by Tomasz, and Hans has serious concerns, he
believes that having userspace predict what buffer indices will be used in
the future is very fragile and would prefer using a separate 64-bit cookie
associated with v4l2_buffers.

Using capture buffer indices as reference frame handles requires predicting
the buffer index on the capture queue which the output queue frames will be
decoded into. We could use the output queue buffer index instead, but that
wouldn't work with multi-slice decoding (multiple output buffers for a
single capture buffer). Using a cookie set by userspace on the output side,
then copied to the capture queue by the driver, solves that problem. All
slices queued on the output queue for the same decoded picture will have
the same cookie value (userspace will have to ensure that).

Tomasz would prefer a buffer index-based solution, to avoid keeping a
cookie-index map in userspace. Due to how V4L2 works, enqueuing a new
dmabuf handle on the capture side for a V4L2 buffer with a given index will
effectively delete the corresponding cookie, so userspace would need to
ensure it doesn't overwrite buffers; (Tomasz: To clarify, I don't see the
significant benefit of using cookies over indices. It makes it easier for
user space, because it doesn't have to predict the CAPTURE buffers, but
still is error prone because of the buffer requeuing problem. For now it
would be good to see how it translates into real code, though. In the
meantime I can try to find a better idea.)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

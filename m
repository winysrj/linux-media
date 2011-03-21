Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4395 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1CURzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 13:55:55 -0400
Received: from tschai.localnet (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id p2LHtaqf075219
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 18:55:54 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Report of the Warsaw Brainstorming Meeting
Date: Mon, 21 Mar 2011 18:55:30 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103211855.30833.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is my report of the three day brainstorming meeting in Warsaw, Poland,
March 16-18.

Attendees:

Samsung Poland R&D Center:
  Kamil Debski <k.debski@samsung.com>
  Sylwester Nawrocki <s.nawrocki@samsung.com>
  Tomasz Stanislawski <t.stanislaws@samsung.com>
  Marek Szyprowski (Organizer) <m.szyprowski@samsung.com>

Cisco Systems Norway:
  Martin Bugge <marbugge@cisco.com> 
  Hans Verkuil (Chair) <hverkuil@xs4all.nl>

Nokia:
  Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
 
Ideas On Board:
  Laurent Pinchart <laurent.pinchart@ideasonboard.com>

ST-Ericsson:
  Willy Poisson <willy.poisson@stericsson.com>

Samsung System.LSI Korea
  Jonghun Han <jonghun.han@samsung.com>
  Jaeryul Oh <jaeryul.oh@samsung.com>

Samsung DMC Korea:
   Seung-Woo Kim <sw0312.kim@samsung.com>

Freelance:
  Guennadi Liakhovetski <g.liakhovetski@gmx.de>

All presentations, photos and notes are available here:

http://www.retiisi.org.uk/v4l2/v4l2-brainstorming-warsaw-2011-03

This report is based on the etherpad notes. See the URL above for the raw
notes.

I hope I haven't forgotten anything, but I believe I've covered pretty much
everything relevant.


1) Compressed format API for MPEG, H.264, etc.

The current API was developed for multiplexed MPEG transport and program streams
and it was not entirely clear how new formats like H.264 should be incorporated.

Right now V4L2_PIX_FMT_MPEG can be used for any multiplexed stream and the
STREAM_TYPE/AUDIO_ENCODER/VIDEO_ENCODER controls are used to discover the precise
format of the multiplexed stream and the used audio and video encoders.

This scheme breaks down for elementary streams. After discussing this we came to
the conclusion that the current scheme should be used for multiplexed streams,
while elementary streams should get their own pixel format. In that case the
controls mentioned above would not exist.

We would need new pixel formats for elementary streams:

V4L2_PIX_FMT_MPEG1
V4L2_PIX_FMT_MPEG2
V4L2_PIX_FMT_MPEG4
V4L2_PIX_FMT_H264 (H.264 using start codes for the 'Network Abstraction Layer Units (NALU)')
V4L2_PIX_FMT_AVC1 (H.264 without start codes for the NALUs)

DivX formats also need FourCCs. The DivX specification is proprietary, we don't
know how the different DivX formats differ ('DIV3', 'DIV4, 'DIVX', 'DX50',
'XVID', ...). More information is needed there.

VC1 comes in two flavors, VC1 (containerless) and VC1 RCV (VC-1 inside and RCV
container). More information is needed on the VC1 RCV format: should we consider
this as a multiplexed stream or as an elementary stream? Could be similiar to H264
and AVC1 as described above.

ACTION: Kamil will propose new fourcc's.

The V4L2 spec already includes a codec class, but it's mostly an unused stub.
The V4L2 codec definition is very similar to V4L2 M2M devices. V4L2 also defines
an effect device interface. The codec and effect device interfaces should be
merged in the spec and be replaced by a M2M interface section.

ACTION: Kamil will make a small RFC for this.

M2M devices currently have both capture and output V4L2 capabilities set, so they
show up as capture devices in applications. This could be fixed by skipping (at the
application level) devices that have both capabilities sets. But this doesn't work
for devices that can do both memory-to-memory processing and live capture (such as
the OMAP3 ISP) depending on the link configuration.

We probably need a new capability flag for M2M devices.

ACTION: Hans will look into this as this is also needed to suppress the core
handling of VIDIOC_G/S_PRIORITY for M2M devices.

For the newer codecs new controls will be needed to set the various parameters.

Besides the Samsung hardware it might also be useful to look at the SuperH / sh-mobile
compressed video processing library to get an idea about video processing parameters,
available on different types of hardware:

https://oss.renesas.com/modules/document/?libshcodecs

A V4L2_CTRL_CLASS_CODEC class was  proposed. But the existing MPEG class should be
used instead even though the name is misleading. We should consider creating aliases
that replace MPEG with CODEC.

Vendor-specific controls will be defined as vendor controls and can later be
standardized if needed. Whether the vendor control can then be removed is a gray area.

Some controls shared by different codecs can have different min/max values. For instance,
the QP range is 0..51 for H.264 and 1..31 for MPEG4/H.263. Should we use two different
controls, or a single one? When switching between codecs, min/max changes can be reported
to userspace through a V4L2 control event, so a single control can work. Hans would rather
see separate controls if there's only a couple of such controls.

ACTION: Kamil will make a list of controls and send it to linux-media.

A special case is UVC and the 'H.264 inside MJPEG' format. See:

http://www.quickcamteam.net/uvc-h264/USB_Video_Payload_H.264_0.87.pdf

Introduced to overcome hardware limitation (lack of 5th usb endpoint in the chip),
additional markers are introduced to carry H.264 data. UVC extension units can
probably be used to detect whether the "feature" is available, otherwise the driver
can hardcode USB VID:PIDs. We need a new pix_fmt for such streams and let applications
demultiplex. The driver will report 2 FourCCs: MJPEG (for compatibility, will disable
all embedded streams) and logitech MJPEG. Which embedded streams are enabled will be
selected through private controls.

ACTION: Laurent will check if the format (width/height) of the embedded streams are
identical to the main stream.



2) Small architecture enhancements.

- Acquiring subdevs from other devices using subdev pool

Subdev registration is handled by bus-specific methods (I2C, SPI, ...). Host drivers
thus need to handle bus-specific configuration themselves. This should be improved.
            
Tomasz proposes to allow:

   * accessing subdevs by name (and optionally by a numerical ID)
   * creating several subdevs for a single physical device

Everyone agrees that improved support for registration of subdevs on multiple busses
is desired. One suggestion is to provide helper functions to simplify subdev
registration across different physical busses (for instance a function to register
a subdev in a bus-agnostic fashion, using a union that provides bus-specific
information for all supported bus types).

Whether a subdev pool should be used for this led to a lot of discussion. The
observation was made that the v4l2_device struct already contains a list of subdevs,
so why add another?

No conclusion was reached and this remains unresolved.

- Introducing subdev hierarchy.

Sub-subdevs might be useful to model certain sensors that supports additional
operations like scaling. Sub-subdevices can be used to model such scalers and
export the possibility to set format on the scaler input and output and the capture
ccd.

On stream start all formats on pads are verified. To support a hierarchy a new
callback like verify_link should be added to subdev's ops.

The media controller also needs to be made aware of such parent-child relationships.
Overall the idea was received favorably.

ACTION: Tomasz can proceed with this.

- Allow per-filehandle control handlers.

The spec requirement about parameter consistency across open-close calls has to
be relaxed to cover cases, where different file-handles *have* to implement different
parameter sets. No comments otherwise.

ACTION: Hans will implement this as part of the control events implementation.

- Subdev for exporting Write-back interface from Display Controller
   
The framebuffer device must allow other drivers to access its writeback subdevice.
This was resolved on Friday with some fancy container_of use.

- Exynos mixer interface, V4L2 or FB ?
 
Implement a FB driver on top of a V4L2 driver. An option is to extend vb2 to make
this easier and perhaps come to a generic solution.

ACTION: Marek will investigate whether it is possible to make a generic 'FB on top
of V4L2' solution using vb2.

- Entity information ioctl

Applications need more information than what is provided by the media controller
entity information ioctl to identify identities correctly. For instance, a UVC
entity is identified by a 16-bytes GUID, which is not reported by entity enumeration.
Another issue arises when subdev type needs to be reported: the current types are
mutually exclusive, and can't handle an entity that is both a sensor and a lens
controller for instance.

To solve those problems, an entity information ioctl should be added to report static
information to userspace. That ioctl should report a list of properties (standardized
by the media controller framework) in an easily extensible way.

ACTION: Laurent will make an RFC with a proposed solution. The idea is to provide a
list of read-only 'properties' or 'attributes' for an entity.



3) Cropping and composing

For video device nodes, the VIDIOC_[GS]_CROP ioctls are too limited. We need two ioctls
for crop/compose operations. VIDIOC_[GS]_EXTCROP is proposed for cropping, and
VIDIOC_[GS]_COMPOSE for composing.

ACTION: RFC from Samsung suggesting a VIDIOC_S_EXTCROP and VIDIOC_S_COMPOSE.



4) Pipeline configuration

There was much discussion on this topic and unfortunately without resolution. There
were some sub-problems that did come to a conclusion:

- Pads also need the total width and height (i.e. width/height + blanking) in order
to get the bus timings right.

- Some hardware can do cropping after scaling (aka 'clipping'). This means that the
format of the output pad can no longer be used as the target size of the scaler.
The solution is to add a new operation to explicitly set the scaler output size. The
crop operation can then be used on the output pad to clip the result.

- Right now the width and height for an output pad are set explicitly by the
controlling driver. It might be better to let the subdev return the currently
configured resolution instead for output pads.

- Some sensors have more complicated sensor array layouts (cross-shapes). We also
need the default active pixel array. A SENSORCAP ioctl was suggested.

- Binning/Skipping can be set through controls.

Unresolved issues are how to calculate the optimal crop rectangle for a particular
scaler output. Should you set the scaler output size and then let the crop operation
modify the crop rectangle? Or should there be an ioctl (or even userspace library)
that calculates this?

Also unresolved is how to configure a complex subdev with multiple inputs and outputs
with dependencies on one another. Should we introduce a transaction-like model? We
ran out of time so this will have to be continued on the mailinglist.



5) HDMI/CEC

The API will be reworked since it should be a subdev-level API.

The HDMI control names should clearly indicate when it represents a status.
 
DV_TX_DVI_HDMI_MODE: make it DV_TX_MODE to select between different transmit modes
(HDMI, DVI, perhaps displayport specific modes also).

DV_RX_5V: too specific. RX_TX_POWER? RX_TXSENSE? 

HDMI receivers can have multiple input ports. Each is active on the level of hotplug,
EDID and HDCP. But only one will stream (determined by a mux).

One way of implementing this is to create connectors in the MC (needed anyway for ALSA)
and to connect those to input pads. A VIDIOC_S_MUX or something similar is needed to
control internal muxes.

A new control type for bitmasks is needed to support detecting the e.g. hotplug status
of multiple input pads at once (UVC also has bitmask controls).

ACTION: Martin/Hans: update the APIs to the subdev pad API, incorporate the comments
made and make a new RFC. Colorspace HDMI handling needs to be discussed further on the
list.



6) Sensor/Flash/Snapshot functionality

- Metadata. Usually histogram/statistics information. Often out-of-band data that needs
to be passed to userspace as soon as possible (before the actual image arrives). Because
of this it is not a good fit for planes containing metadata.

Usually done through read/ioctl. But it was suggested to make a new 'video' node for
this to allow a DMA engine to be used.

Where possible the source of the metadata should parse it (since only the source knows
how to handle the contents).

ACTION: RFC from Nokia (tentative)

- Flash. While common flash settings (flash, torch mode, privacy light, detection of
LED hardware errors such as short circuit, overtemperature, timeout, overvoltage) can
be set through common controls, the specifics of how flash works is highly hardware
dependent. Therefore this is left to the driver.

ACTION: RFC for common flash API from Sakari.

- 'Bracketing' in SMIA++: it is possible to set parameters for X frames before
streaming. When streaming starts, the settings will be applied for each frame. The
streaming stops after the last frame data is provided for. This should be implemented
as a SMIA++ specific ioctl temporariliy overriding the e.g. exposure control.

ACTION: RFC from Nokia (tentative)



7) Multiple buffer queues

Typically sensors can have a 'viewer' and 'snapshot' mode. However, some also have
a 'monitor' mode where previously taken pictures can be viewed. So any solution should
not limit itself to just two modes.

We need to be able to switch between modes efficiently. So buffers need to be prepared
to avoid time-consuming cache invalidate operations.

There are two core problems: we need to be able to create buffers of a different size
than the current format and we need to be able to prepare buffers without using them
yet.

The proposal is to add three new ioctls:

VIDIOC_CREATE_BUFS(bufcnt, size or fmt)
VIDIOC_DESTROY_BUFS(start_index, bufcnt)

These add additional buffers of the given size (or format) and destroy previously
created buffers. This also makes it possible to vary the number of buffers used
for e.g. capture on the fly (something that has been requested in the past).

PREPARE_BUF(v4l2_buffer)

This prepares a buffer but will not otherwise queue it.

The first two are just a more flexible version of doing REQBUFS.

With these ioctls userspace can preallocate the buffers of the required sizes
and prepare them. After a STREAMOFF userspace can set up the new format and
queue buffers with the corresponding size that are already prepared and start
streaming again. It seems like a simple, flexible and practical solution. Too
good to be true, really.

We also need a per-plane flag to skip cache invalidation/flush if not necessary.

ACTION: Guennadi: RFC and a guesstimate of the impact it has for vb2 and drivers.



8) Buffer pools (related to Linaro activities)

There are 3 building blocks:

- contiguous memory allocator
- iommu memory allocator
- user and kernel interface for allocating and passing buffers

We need:

- requirements
- evaluate existing solutions

ACTION: All: make a list of requirements by March 30th. Post on the linux-media
mailinglist. When done, discuss various solutions in view of the requirements.



This concludes this report of the meeting. Any mistakes are of course mine.
I think such meetings are very productive and I hope we can repeat this more often.
There is still so much that needs to be done...

I'd like to thank all participants for their input. Special thanks go to Samsung
Poland R&D Center for hosting this event and to Marek Szyprowski in particular for
organizing this!

Regards,

	Hans Verkuil

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

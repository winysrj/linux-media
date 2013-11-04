Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1373 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3KDR1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 12:27:23 -0500
Message-ID: <5277D8EC.4000706@xs4all.nl>
Date: Mon, 04 Nov 2013 18:27:08 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: LMML <linux-media@vger.kernel.org>, media-workshop@linuxtv.org
Subject: Re: [media-workshop] [ANNOUNCE] Notes on the Media summit 2013-10-23
References: <20131031092727.51f75527@samsung.com>
In-Reply-To: <20131031092727.51f75527@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have collected presentations from this media summit here:

http://hverkuil.home.xs4all.nl/presentations/summit-2013/

Please contact me if a presentation you gave is missing so I can add it.

Regards,

	Hans

On 10/31/2013 12:27 PM, Mauro Carvalho Chehab wrote:
> Notes on the Media summit 2013-10-23
> 
> List of Participants:
> 
> Ricardo Ribalda - Qtechnology
> Hans Verkuil - Cisco
> Sakari Ailus - Intel
> Mauro Carvalho Chehab - Samsung
> Kieran Kunhya - Open Broadcast Systems
> Sylwester Nawrocki - Samsung
> Guennadi Liakhovetski
> Benjamin Gaignard - ST Microelectronics
> Hugues Fruchet - ST Microelectronics
> Andrzej Hajda - Samsung
> Peter Senna Tschudin - Coccinelle?
> Hans de Goede - Red Hat
> Michael Krufky - Samsung
> Paul Walmsley - Nvidia
> Laurent Pinchart - Ideas on board
> 
> 1. Mauro Chehab: is the submaintainer arrangement working?
> 
> General consensus is that it is working.
> 
> Hans pointed that the commits ML is not working. Mauro will check what's
> happening at LinuxTV website after returning back.
> 
> Hans also pointed that patches for the rcX kernel aren't always picked
> up quickly enough. Mauro says this is due to his move to Samsung which
> took a lot of his time. This should improve.
> 
> 2. Ricardo Ribalda Delgado: Multiple selections
> 
> For a more flexible cropping selection a new extended rectangle struct has
> to be added with possibly negative top and left offsets. This would allow to
> explore capabilities of industry grade sensors, that can be configured to crop
> multiple rectangles from the input area.
> 
> Sylwester: an alternative approach would be to use indexed windows. The issue
> of atomicity should also be addressed.
> 
> Ricardo is proposing to add the capability of adding more than one selection areas
> 
> - No objections so far.
> - Helper functions to detect if rectangles overlap or are contained on other rectangles
>   are needed.
> - Documentation changes for V4L2 subdev selection API. Special care needs to be taken
>   for too few or too many rectangles. In both cases the rectangles field should be
>   set to the actual number of allowed rectangles. In the too few case an error should
>   be returned, in the too many case the extra rects should just be ignored.
> 
> Mauro thinks that it will be useful to see if the width/height fields in v4l2_rect
> can be changes to u32 instead of s32: will require code review of drivers.
> 
> 3. Hans Verkuil: colorspaces
> 
> - Colorspace: limited/full range
> 
> Draft presentation for all these topics: http://hverkuil.home.xs4all.nl/presentations/summit2013.odp
> 
> Proposal accepted, although the "_SRGB_LIM" name might need to be improved, although
> no alternatives were given.
> 
> ALso mention in the docs that S_FMT can overwrite the colorspace for output devices
> if the selected one isn't supported.
> 
> 4. Kieran Kunhya: SDI
> 
> The biggest problem is separate audio and video file descriptors. Audio data is
> transfered in the video blanking areas, where should they be separated - in the
> kernel, using multiple planes, or in the user-space? One possibility is to consider
> this data as similar to an "uncompressed MPEG" datastream. It might be possible to
> use hardware-specific time-stamps to synchronise the data.
> 
> Separate ALSA and V4L2 nodes are inherently problematic since they do not keep the
> audio and video together. Another possibility is to offer two APIs: for professional
> applications, where data is perfectly synchronised, and separate audio and video
> for "human consumption."
> 
> A format for professional applications were VBI/HBI/Video is all captured in one
> big frame is OK (provided an open source lib is created to parse it).
> 
> The proposal for using a multiplanar API where the audio is in a separate plane
> ran into opposition: the alsa devs should be asked whether it is possible to
> return the audio data in such a way that it can be exactly associated with the
> corresponding video buffer. This also requires that the audio can be variable
> length since for NTSC the size of the audio data will alternate between frames.
> If this is possible, then the alsa API can be used and things can still remain
> in sync.
> 
> UPDATE: Mauro and Hans had some discussions with Takashi (ALSA Maintainer),
> in order to have some shed about the possibilities. We're planning to discuss
> more on this Friday's lunch.
> 
> 5. Paul Walmsley on behalf of Bryan Wu: LED / flash API integration
> 
> Currently functionality is accessible from two APIs: LED and flash. A proposal
> is presented to put V4L2 flash subdev on top of LED core. It would be better
> not to go via the LED trigger layer.
> 
> - One to one mapping between LED chips and V4L2 sub-devices. This probably means
>   the LED flash driver needs to register the sub-device.
> - Two interfaces: should the sysfs interface be disabled if an application chose
>   the flash mode on V4L2 API? The flash driver has no knowledge of streaming state
>   or capturing frames.
> - Same requirements as for the LED API as the V4L2 flash API needs (LED flashes only).
> - Currently there's no V4L2 API to put a sensor into a flash mode to automatically
>   trigger a flash pin. This would have to be handled. It is also possible, that
>   a V4L2 application uses a sensor, but only puts it into a "flash mode" (single-shot
>   mode) for several frames. The LED might therefore have to be made busy always when
>   the sensor is used. Situations, where an LED is busy should already happen, e.g.
>   if one application wants to use it for a torch and another one for notifications.
> 
> Results:
> 
> a. There seemed to be broad consensus that there's no need to use the
> ledtrig-camera.c layer.  Instead it's probably better for the v4l2
> flash subdev code to call directly into the LED framework core.
> 
> b. How to register LED devices initially?  How to associate LED chips to
> v4l2?  In particular, how should this be modeled in DT data?  There needs
> to be some link to connect sensors to flash chips in the DT data. The
> media controller API has the notion of groups; perhaps that can be
> expressed in DT with phandles.
> 
> c. How should hardware triggers be implemented?  Some sensor hardware has
> the ability to automatically fire the flash when the sensor activates,
> without the involvement of any Linux-side software (beyond the initial
> configuration of the feature).  There needs to be some knowledge in the
> LED core that can enable this.
> 
> d. Several concerns over races and multiple users: should the sysfs LED
> interface always be exposed, or not?  For example, if a sysfs request
> comes in to the LED core while a hardware capture is occurring, should it
> return -EBUSY?  Sakari felt that it was better to arbitrate this in
> userspace, since it was a matter of policy, while some others wanted it to
> be handled in the kernel.  There was a debate and divergence of opinion on
> this.  If the kernel will be responsible for this mutal exclusion, then it
> should also be possible to disable the use of other LED triggers once v4l2
> is using it.
> 
> 6. Mauro Chehab: DVB / V4L2 / MC integration
> 
> Mauro wants to extend Media Controller/Subdevice functionality to DVB, in order
> to allow setting a complete pipeline that would cover V4L2/ALSA/DVB/DRM as a
> hole. This is needed by Consumers Electronics producs like digital TV and STB.
> 
> Problem: multiple subsystems might be using the MC API with or without connections
> between them. How to set such a topology up?
> 
> Possibilities:
> 
> a. To have just one global media controller device, not all graphs inside it
> would need to be connectable.
> 
> b. The first user creates an MC device.  Any further users detect that their MC
>   device is already present and will reuse it
> 
> c. a separate driver creates an MC device instance, e.g. a driver for links
>   between subsystems
> 
> One problem to be discussed with DT people is how to express the hardware
> connections between the different subsystems. This information should be provided
> by the open firmware, in order for the media controller to create the proper bus
> links internally on their graphs.
> 
> 7. Hans Verkuil: try_fmt compliance
> 
> Problem: VIDIOC_TRY_FMT shouldn't return -EINVAL when an unsupported pixelformat is provided,
> but, in practice, video capture board tend to do that, while webcam drivers tend to map
> it silently to a valid pixelformat.
> 
> Also, some applications rely on the -EINVAL error code, with is wrong, as not all drivers
> currently returns it: some just return 0, and fills the pixelformat data with a supported
> format.
> 
> Resolution: fix applications, schedule driver change to comply with the spec and not
> return -EINVAL for an unsupported pixel format. New drivers should never return -EINVAL
> and should comply to the spec instead.
> 
> 8. Hans Verkuil: V4L2 support libraries
> 
> - libv4l2util library does not offer a public API and has a funny name. To be renamed as libv4l2misc.
> - create a new libv4l2misc (a libv4l2util already exists) where all the various useful
>   bits of functionality can be placed. Posted publicly to properly discuss the API.
> - Doxygen to be used to document the library API.
> 
> 9. Hans Verkuil: Interaction between selection API, ENUM_FRAMESIZES and S_FMT
> 
> - Hans proposed to add G/S_FRAMESIZE ioctls in order to make clearer about
>   what size is being changed, on scenarios that have both scaling and cropping.
> - E.g. UVC webcams have an interface to specify the image size. The camera
>   achieves that using cropping and scaling, but the driver does not have
>   information on which one.
> - sn9c102 does some weird non-standard things. This driver were obsoleted by
>   gspca (except for a few really old devices that gspca developers were unable
>   to use). This driver were removed on Fedora several versions ago, and nobody ever
>   complained about it. So, it should be moved to staging and removed in a
>   few kernel cycles' time.
> - Most of the developers didn't buy the idea of creating a new pair of ioctls.
> - Hans will write a new proposal on the topic that, instead of adding new ioctls
>   (G/S_FRAMESIZE),it will add a new selection target and try to avoid the use of
>   flags (in opposite to the current proposal).
> 
> 10. Laurent Pinchart: ALSA and Media controller
> 
> - ALSA folks thought of using Media controller for pipeline control but miss features:
>     - dynamic creation/removal of MC entities;
>     - lack of a way to store value pairs.
> 
> - ALSA entities would need to be added and removed at runtime: DSP firmware
>   decides what kind of entities exist
> 
>     - E.g. equalisers could be created as needed
> 
>     - ALSA already has APIs for that
> 
> - Detailed sub-system specific data is needed:
> 
>     - ALSA: what kind of features the entity has
> 
>     - Proposal: binary blob specific to entity that contains key: value pairs --- this
>       could be used in V4L2 as well
> 
> 11. Laurent Pinchart: sharing I2C sub-device drivers between V4L2 and KMS
> 
> - Dynamic assignment of devices between display and capture pipelines
> - The DT won't contain information on which driver should be used
> - Two separate drivers are currently facing such issue, but it seems that lot
>   more will be added;
> - Something similar to the V4L2 sub-device is required on KMS. Without this
>   feature, sharing sub-devices will be hard if not impossible.
> - We need something similar for DVB/V4L tuners, but it's much easier to push
>   that upstream, as the media subsystem already uses MC subdevs.
> 
> 12. Sakari Ailus: Multi format streams / metadata
> 
> - metadata has to be separated from the image, but kept in sync with frames
> - some hardware is able to separate metadata automatically
> - Frame format descriptors to be extended
>     - Set operation should be removed and replaced with a different solution
>       on existing drivers
> 
> - Format index to be added to struct v4l2_mbus_framefmt
> - No conclusion reached on how other streams are captured in the user space,
>   requires further discussion and time
>     - Multiple video nodes or multiplexing by the type field?
>     - The upper 16 bits in the type field could be used to index the buffer queue
>     - No need to split the field; macros can be used to access different parts of it
>     - Stealing bytes from struct v4l2_format may have issues: the struct is not
>       packed, and at least the alignment would need to be verified on supported archs
>     - Multiple buffer types are not supported by videobuf2 currently with the
>       exception of memory-to-memory devices and capture/overlay
>     - Changes could be required in videobuf2
>     - Events could be used to pass the metadata to the user space
>     - Extended events required
>     - Does not help with sensors that produce multiple images of the same frame
>     - Causes two copies of the data: one to the event buffer, the other to the user
>       space when the event is dequeued
>     - Unwanted especially on embedded systems where copying costs: there's a
>       measurable effect from e.g. copying 4 kiB 60 times per second from two sensors
>     - DQBUF takes the buffer type as an argument, and the user would need to
>       try different queues once select(2) returns
> 
> - Multi-format buffers are not an answer for metadata since metadata must be in
>   the user space as fast as possible
> - Multi-format buffers could be implemented by extending v4l2_format
>     - The name of the IOCTLs taking that as an argument will stay the same, as well
>       as the IOCTL number
>     - The old definition is still kept around for binary compatibility
> 
> - The UVC 1.5 might be a use case for multi format streams, too
> - The SDI has multiple streams, too, but could work on multi-format buffers
> - The user shouldn't have to choose whether to use multi-format buffers or multiple
>   video nodes
>     - Painful for drivers to handle, duplicate code in drivers
>     - Drivers must only implement one
> 
> - No consensus was reached. Sakari has to update the RFC to include all three topics
> 
> 13: Hugues Fruchet: Video codecs
> 
> - There's a need to parse bitstream fields for those codecs, but that requires
>   complex code (10K lines). Moving it to kernel could make it unstable, as
>   it is harsh to write those parsers without any risk of causing crashes.
> - It seems to be better to put those parsers inside libv4l, using an open source
>   license.
> 
> Results:
> - Drivers that require proprietary user space components should stay out of mainline
> - Multi-format buffers could be useful here
> - The hardware/firmware needs a lot of data extracted from the bitstream next
>   to the bitstream itself. This is a custom format, so it is OK to add a new
>   pixelformat for each of those formats. Such complex parsing should be done in
>   userspace in libv4l2.
> - If very little parsing is required (MPEG), then that can be done in the kernel
>   instead.
> - Recommendation is to start simple with e.g. just an MPEG implementation.
> 
> 


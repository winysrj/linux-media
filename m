Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4532 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbaJUPgn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 11:36:43 -0400
Message-ID: <54467D79.7030101@xs4all.nl>
Date: Tue, 21 Oct 2014 17:36:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Linux Media Workshop ML <media-workshop@linuxtv.org>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: =?windows-1252?Q?Re=3A_=5Bmedia-workshop=5D_=5BANNOUNCE=5D_?=
 =?windows-1252?Q?Media_summit_Report_-_October=2C_17-18_2014?=
 =?windows-1252?Q?_-_D=FCsseldorf?=
References: <20141021125316.4cf68cb3@recife.lan> <20141021132602.33bd6b88@recife.lan>
In-Reply-To: <20141021132602.33bd6b88@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/21/2014 05:26 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 21 Oct 2014 12:53:16 -0200
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
>
>> This report is also available in html at:
>> 	http://linuxtv.org/news.php?entry=2014-10-21.mchehab
>>
>> In the name of the organizing committee, I'd like to thank you all for
>> being there with us during those two days.
>>
>> There were several good discussions that happened during the meeting,
>> aimed to improve even more the Linux media subsystem.
>>
>> Also, it was agreed during the meeting that we'll try to reach an even
>> broader audience on the next events. So we're counting with all you
>> on our next year's event(s).
>>
>> Thanks!
>> Mauro
>>
>> -
>>
>> Attendees, in alphabetical order:
>>
>> NAME			- EMAIL					- ORGANIZATION
>> Brad Love		- blove@hauppauge.com			- Hauppauge
>> Chris Kohn		- christian.kohn@xilinx.com		- Xilinx
>> Friedrich Schwittay 	- FSchwittay@pctvsystems.com		- PCTV
>> Guennaddi Liakhovetski	- g.liakhovetski@gmx.de			- Intel
>> Hans de Goede		- hdegoede@redhat.com			- Red hat
>> Hans Verkuil		- hverkuil@xs4all.nl			- Cisco
>> Henning Garbers		- hgarbers@pctvsystems.com		- PCTV
>> Johannes Stezenbach	- js@linuxtv.org			- LinuxTV
>> Julien Beraud		- julien.beraud@parrot.com		- Parrot (www.parrot.com)
>> Kamil Debski		- k.debski@samsung.com			- Samsung
>> Laurent Pinchart	- laurent.pinchart@ideasonboard.com	- Ideas on board
>> Lucas Stach		- l.stach@pengutronix.de		- Pengutronix
>> Mauro Carvalho Chehab	- mchehab@osg.samsung.com		- Samsung
>> Mike Krufky		- mkrufky@linuxtv.org			- Samsung
>> Nicolas Dufresne	- nicolas.dufresne@collabora.com	- Collabora
>> Pawel Osciak		- pawel@osciak.com			- Google
>> Peter Griffin		- peter.griffin@linaro.org		- Linaro/ST
>> Philipp Zabel		- p.zabel@pengutronix.de		- Pengutronix
>> Ralph Metzler		- rjkm@metzlerbros.de			- Meltzler Brothers
>> Ricardo Ribalda Delgado	- ricardo@qtec.com			- Qtechnolgy A/S
>> Sakari Ailus		- sakari.ailus@linux.intel.com		- Intel
>>
>> Thursday:
>> ========
>>
>> 1) Configuration stores - Hans Verkuil
>>     ===================================
>>
>> - Need to report which settings/controls were applied
>>
>> - Drivers needs to be able to report full/limited Android CameraHAL v3 support
>> (full means full synchronization support)
>>
>> - We probably need a mechanism to be able to remove (free) config stores
>>
>> - Can we use APPLY(0) instead of CLOSE?
>>
>> - Per buffer or per frame configuration? Note: there is no notion of frame IDs
>> yet in V4L2.
>>
>> - Would be nice to be able to disable APPLY, perhaps a flag for the core similar
>> to HAS STORE
>>
>> 2) Android camera HAL v3 - Sakari Ailus
>>     ====================================
>>
>> http://www.retiisi.org.uk/v4l2/foil/android-camera-hal-v3-v4l2.pdf
>> - Capture requests queued lead to returned buffers in order, best effort to make
>> per-buffer configuration apply correctly needed
>>
>> - Capture requests/returned buffers do not map directly to QBUF/DQBUF because
>> multiple buffers in different formats may be produced from a single request.
>> Some outputs could be implemented in software, e.g. multiple YUV outputs when
>> hardware simply does not contain as many.
>>
>> - Should statistical data be returned in a separate video buffer queue? Might be
>> associated via sequence number, probably separate frame ID better
>>
>> - 3A library input: frame metadata, depends on sensor, might be in-frame or
>> out-of band. If possible, separate buffer queue prepared to get to it early.
>>
>> - HAL v3 needs Start Of Frame and End Of Frame events
>>
>> - If there is no hardware mechanism for synchronization, apply sensor settings
>> as soon as possible after SOF and hope for the best. It is possible to verify
>> the timing has been successful in the user space.
>>
>> - Sensor settings and ISP settings applied at different points in time, as
>> sensor settings usally take effect on the following frame
>>
>> - Sensors may implement all or parts of the ISP themselves. It may not be
>> feasible to implement hal v3 full profile for such sensors.
>>
>> - Start of Exposure events not to be implemented in the kernel. HAL must
>> calculate the event time based on other available information, such as end of
>> frame (or start of frame event) and other frame timing parameters.
>>
>> - Some metadata tags could be mapped to V4L2 (compound) controls, they are
>> associated with a single capture request. Some metadata tags (statistics) are
>> produced from video buffer queues. Other metadata tags originate from HAL.
>>
>> - Needs a guarantee that a single capture request will produce all buffers
>> requested by it with the request's parameters, needs per-buffer configuration,
>> associating buffers with a certain frame.
>>
>> - A working halv3 implementation for UVC (limited profile) would be nice to have
>>
>> - A working halv3 implementation on top of some hardware (full profile) is
>> needed to test assumptions
>>
>> - ISP configuration may be implemented by controls or via an output video buffer
>> queue
>>
>> - V4L2: independent queues (possibly multiple video device nodes), frame
>> synchronization needed when queueing the buffers, drivers are expected to always
>> return those buffers, possibly with an error flag, HALv3: multiple streams are
>> synchronized via capture requests
>>
>> - Requests may contain buffers for every queue or only some queues.
>>
>> - All buffers captured as part of a request must originate from the same sensor
>> frame. Other behaviour is not allowed.
>>
>> - All buffers have start of exposure timestamps (approximated by start of frame
>> timestamp - exposure time)
>>
>> - Frames from different capture queues can be associated using sequence numbers.
>>
>> - ISPs are typically connected to a fast bus, and mostly it's possible to
>> synchronise changing the configuration per frame reliably. Should this be
>> extended to sensors? In that case, the sensor driver would need timing
>> information from the ISP. Sensors are typically connected over a slow bus such
>> as i2c so error handling would also be needed. The alternative is to leave
>> sensor synchronisation up to the user space.
>>
>> - Further discussion
>>
>>    - How are buffers and controls from different device nodes associated as a
>> single request by the driver?
>>
>>    - Applying parameters from sub-device nodes
>>
>> 3) DVB API improvements - Mauro Carvalho Chehab
>>     ============================================
>>
>> - New ioctl needed for retrieving the available PLP (physical layer pipe)that
>> can be read back from frontend's detection. Eventually get_property might be
>> used, but it could be too big for that.
>>
>> - How to support devices with multiple demodulators that could have a common
>> PES/SEC filter block dynamically shared between them? Currently, the API assumes
>> that each demod has a fixed number of filters.
>>
>> - It is desired to add mmap() and DMABUF support. The best seems to use
>> videobuf2 for buffer delivery, but how to avoid V4L2 dependencies? It seems it
>> should reuse memops but not videobuf2-core, reimplement queue/dequeue, state
>> handling, see what should be shared.
>>
>> - TBD: How to improve integration of DVB frontends, demuxes and CAM drivers with
>> other media components via the media controller.
>>
>> Work plan:
>>
>> - Make a more detailed list of requirements for DVB - to be done by the DVB
>> developers;
>>
>> - Send patches for PLP table retrival by userspace - Hauppauge/PCTV;
>>
>> - Send a proposal for DVB-C2 - Ralph Meltzler;
>>
>> - After the above steps is completed, we should discuss between the DVB
>> developers about who will be doing what.
>>
>> 4) Media development process - Hans Verkuil
>>     ========================================
>>
>> - Fixes are written for an upcoming release typically based on findings from rc1
>>
>> - Fixes should get higher priority
>>
>> - Fixes must be upstreamed by rc3
>>
>> - Patches that go to the fixes tree are not applied to master. This is because
>> the fixes sent to Linus will reappear from upstream, eventually to master branch
>> as well.
>>
>> - Use 'GIT FIXES' for urgent bug fixes (Hans will send V4L2 submitting patches
>> text (after updating) to Pawel for wiki inclusion)
>>
>> - Consider github as git repo for better failover.
>>
>> - Co-locating with other conferences creates schedule conflicts
>>
>> - Too costly to move before/after conferences (bosses will only pay for the
>> meeting, not for the conference)
>>
>> - Making the mini-summit open for all would be an interesting experiment.
>>
>> - But we shouldn't charge for the mini-summit.
>>
>> - Next year: kernel summit in South Korea, so the media mini-summit will be in
>> Korea as well.
>>
>> 5) V4L2 raw codec API - Pawel Osciak
>>     =================================
>>
>> - The current codec API is suitable for codecs which perform all the stages of
>> encoding or decoding.
>>
>> - Newer codec hardware implementations expect the CPU to perform less computing
>> intensive parts of the codec.
>>
>> - VA-API like model: codec split between user and kernel spaces
>>
>> - Some vendors provide closed user space codec libraries. Yuck.
>>
>> - Bit stream formats are vendor independent, so the parsing of the bit stream
>> should be as well.
>>
>> - Processing must be performed per-slice. This allows lower latency.
>>
>> - Decoding to be implemented in libv4l. Multiple hardware devices may benefit
>> from the stream parsing functionality this way.
>>
>> - GStreamer plugins already implements stream parsing. License?
>>
>> 6) Multiple timestamps - Ricardo Ribalda
>>     =====================================
>>
>> - Some Industrial Machines require metadata about the state of the machine when
>> the image is taken
>>
>> - When this data is small enough (~32 bits) and it is similar to a timestamp (ex.
>> encoder data) we might use the timecode struct, already part of vb2_buffer
>>
>> - Sometimes the metadata can be much bigger. An example has been shown regarding
>> an optical grader of potatoes. In this sytem, the spinoflex (conveyor belt with
>> fingers) has a state of around 1000bits
>>
>> - This information does not fit the event data structure and share the same
>> problems as the camera statistics,  therefore common solutions should be used.
>>
>> - The proposal of creating a new ioctl  for this (GET_META) has been generally
>> rejected.
>> Instead two options have been propossed depending of the size:
>>
>> - A) Configuration stores are an option as well. A single array control could be
>> used for this.
>>
>> - B)Video buffers could be used. This is very much analogous to sensor metadata
>> after all.
>>
>> - Laurent pointed out that  A single interface to pass statistics to the user
>> space is preferred, independently of the size of the statistics.
>> The common consensous seems to be that:
>>
>> - If the data is transferred to the memory, video buffers are probably the right
>> solution.
>>
>> - For 1000 bits, compound controls are very likely the best option.
>>
>> - Image statistics of tens or hundreds of kilobytes should use a video buffer
>> queue.
>>
>> Work plan:
>>
>> - Hans will make sure that  the configuration store can support this usercase
>>
>> - We will define a generic fourcc for statistics
>>
>> - Libv4l will be in charge of converting the vendor specific statistics into
>> this generic format
>>
>> Friday:
>> ======
>>
>> 7) Runtime reconfiguration of pipelines - Chris & Laurent
>>     ======================================================
>>
>> - Xilinx need to support adding any type of daughterboard to their FPGA
>> pipeline: userspace needs to load a DT overlay dynamically for that
>> daughterboard. Note that the Xilinx driver won't know which devices are on that
>> daughterboard since it is the customer/thirdparty that makes it.
>>
>> - Partial reconfiguration: ideally only the IP blocks that will be replaced need
>> to be removed in the MC: this is complex.
>>
>> - Can we make an initial implementation to just tear down everything and rebuild
>> it with the new IP instead of the old? Less flexible, but much easier to do
>> until we can change the MC on the fly.
>>
>> - Option: perhaps just disable entities instead of deleting them. But it's a bit
>> of a hack, and we should just bite the bullet and add proper support.
>>
>> - Result: implement everything tear down first. Later work on how to delete
>> entities on the fly.
>>
>> - Create a virtual MC device driver: what should be there? - Hans Verkuil
>>
>> - sensor, at least two DMA engines giving two different formats
>>
>> - Bayer support?
>>
>> - different input ports (csi/parallel), cropping/scaler block
>>
>> - configurable pipeline (including m2m device)
>>
>> - flash, lens
>>
>> 8) Hierarchical media devices - Philipp Zabel
>>     ==========================================
>>
>> - Philipp gave a presentation about complex media devices that could be better
>> represented via hierarchical trees. The discussions about that happened
>> together with the next topic.
>>
>> 9) Highly reconfigurable hardware - Julien Beraud
>>     ==============================================
>>
>> - 44 sub-devices connected with an interconnect.
>>
>> - As long as formats match, any sub-device could be connected to any other
>> sub-device through a link.
>>
>> - The result is 44 * 44 links at worst.
>>
>> - A switch sub-device proposed as the solution to model the interconnect. The
>> sub-devices are connected to the switch sub-devices through the hardware links
>> that connect to the interconnect.
>>
>> - The switch would be controlled through new IOCTLs S_ROUTING and G_ROUTING.
>>
>> - Patches available:
>> http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/log/?h=xilinx-wip
>>
>> 10) libdvbv5 - Mauro Carvalho Chehab
>>      ================================
>>
>> - Part of libv4l v1.6.0
>>
>> - Most applications still use DVBv3 API.
>>
>> - Contains MPEG-TS decoders for program information.
>>
>> - Compilation options to choose different parts of the library to be built. Not
>> everyone needs everything.
>>
>> - The user may want to use custom replacements for parts of the library,
>> especially for parsing tables like EPG.
>>
>> - The library still needs the MPEG-TS parsers for channel parsing. If the
>> MPEG-TS parser isn't part of the library, the functionality would need to be
>> available elsewhere using the same interface.
>>
>> - libdvbv5 license right now GPL, agreement on license change to LGPL exists
>> from all contributors.
>>
>> 11) DVB tuners - Mauro Carvalho Chehab
>>      ==================================
>>
>> - Explained the old hybrid model and the new model used by the tuners and the
>> odds with the current approach
>>
>> - It was also explained that I2C MUX is a need, in order to help fixing the
>> problems with suspend/resume inside the subsystem
>>
>> - Some concerns arrised if the new model actually works or not for analog TV, as
>> currently there's no tuner using it for analog
>>
>> - It was agreed that the new model is the way to go, but it requires a carefully
>> review, and changes should not be done on all tuners at once, but, instead, in
>> steps
>>
>> 12) Other DVB issues - Mauro Carvalho Chehab
>>      ========================================
>>
>> - Better information on device capabilities is needed in the user space, as,
>> currently, there are very few bits available for DVB caps at fe_caps enum, used
>> by FE_GET_INFO. Also, some standards can have lots of options (ISDB-T has 28),
>> and reporting there to userspace using bits is actually not a good option.
>>
>> - The main issue with fe_caps is that, currently, there are only two bits left,
>> and this is not enough to represent the current capabilities of
>> modern delivery system's frontends.
>> a a few examples of missing things that we want to be able to report, we have:
>>
>> - Ralph reminded that there are DVB-C/C2 devices that only support automatic
>> bitrate detection, and he is even unsure if it is possible to retrieve the
>> detected bitrate from such frontends. So, we need a way to allow
>> "CAN_AUTO_SYMBOL_RATE". That's bad, as applications like w_scan may run several
>> times over the same symbol rates, and may actually be detecting the same
>> transponder several times.
>>
>> - Complex delivery systems like ISDB-T have some combinations that aren't
>> very common, and some chipset providers decided to not implement (Mauro). For
>> example, mb86a20s frontend doesn't support guard interval equal to 1/32.
>>
>> - The agreeded strategy is to write a new ioctl that, once the delivery system
>> is set, it will return what are the valid values/ranges that a given frontend
>> property can support. In order to optimize the drivers, the core could pre-fill
>> it with all that it is supported by a given delivery system, letting the driver
>> to override it, disabling the features that aren't supported.
>>
>> - Mkruky proposed to add a new ioctl (FE_GET_PROPS_INFO - or something  like
>> that) that would return all the valid values for a given property  for the
>> current delivery system.
>>
>> - Old DVBv3 APIs that weren't used anymore should be clearly documented as
>> deprecated
>>
>> 13) Dead pixels: Ricardo Ribalda
>>      ============================
>>
>> - Position of dead pixels + classification of dead pixels (dead/lazy/others)
>>
>> - Store this on a flash: common format?
>>
>> - No problem with the dead pixel proposal, but it needs to be used upstream
>> somewhere before it can be used. Ricardo's driver is unlikely to be upstreamed.
>> Not sure if adding it to vivid is sufficent.
>>
>> - Suggestion: omap3 should have it, try getting a beagleboard/bone + sensor and
>> implementing it there.
>>
>> - sensor/module metadata: needs an RFC first.
>>
>> 14) Multiple selections - Ricardo Ribalda
>>      =====================================
>>
>> - Hans's patch "videodev2.h: add v4l2_ctrl_selection compound control type"
>> implements selection controls. This replaces the selection interface, and
>> existing drivers should be converted.
>>
>> - Pad information missing from the RFC patchset.
>>
>> - Multiple selections will not be available on selections interface.
>>
>> - Hans stopped working on this, but welcomes someone else continuing with it.
>
> People were so thrilled with the Hans' Colorspaces presentation that
> they forgot to add it to the Etherpad notes:
>
> Hans, I added the small test below to the report:
>
> 	15) Colorspaces - Hans Verkuil
>
> 	- Hans gave a presentation explaining colorspaces.

Just one addition:

- The V4L2_QUANTIZATION_ALT_RANGE should be replaced by two separate
   values: FULL_RANGE and LIM_RANGE. That is more explicit.

Regards,

	Hans

>
> Feel free to fill in the blanks if needed. I'll then update the html
> version of the report.
>
> Btw, I uploaded all presentations people made available so far at:
> 	http://linuxtv.org/downloads/presentations/media_summit_2014_DE/
>
> I also added hyperlinks at for each presentation at the html report.
>
> For those that did a presentation there and want to make the slides
> available, please send me the notes.
>
> Ricardo,
>
> It would also be nice to add there a link to that amazing potato handling
> machines using Video4Linux, if this is something that could be shared ;)
>
> Regards,
> Mauro
>

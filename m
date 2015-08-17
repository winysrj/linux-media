Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58109 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbbHQQ4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2015 12:56:22 -0400
Received: from recife.lan (201.47.149.208.dynamic.adsl.gvt.net.br [201.47.149.208])
	by lists.s-osg.org (Postfix) with ESMTPSA id 623F1462CB
	for <linux-media@vger.kernel.org>; Mon, 17 Aug 2015 09:56:20 -0700 (PDT)
Date: Mon, 17 Aug 2015 13:56:16 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>
Subject: [ANNOUNCE] Report for the Media Controller Workshop - Espoo - Aug,
 17 2015
Message-ID: <20150817135616.43840b4d@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

============================================================================
Report of the Media Controller workshop in Espoo, Finland – July, 29-31 2015
============================================================================

	PS.: For those that prefer, a web version is at: http://linuxtv.org/news.php?entry=2015-08-17.mchehab

This is the first workshop dedicated to the Linux Media Controller. We had a v4l summit back in 2010, also in Finland, that established the current foundation for the media controller, andto properly satisfy the needs of properly reporting the pipelines on the smartphone System on a Chip (SoC). The focus of this year's workshop was to clarify the kernel→userspace interfaces and extend the Media Controller to be used on other subsystems that need to represent graphs, like Digital Video Broadcasting (DVB), Advanced Linux Sound Architecture (ALSA), and Industrial I/O (IIO).

Main event attendees:

Antti Laakso <antti.laakso@intel.com>
Hans Verkuil<hansverk@cisco.com>
Lars-Peter Clausen <lars@metafoo.de>
Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Mauro Chehab <mchehab@osg.samsung.com>
Sakari Ailus <sakari.ailus@iki.fi>
Shuah Khan <shuahkh@osg.samsung.com>
Tuukka Toivonen <tuukka.toivonen@intel.com>

MC videoconf attendees:

Dong-Joo Kim <dj98.kim@samsung.com>
Geunyoung Kim <nenggun.kim@samsung.com>
In-Ki Dae <inki.dae@samsung.com>
Junghak Sung <jh1009.sung@samsung.com>
Minsong Kim <ms17.kim@samsung.com>
Ohin Kwon <rany.kwon@samsung.com>
Seung-Woo Kim <sw0312.kim@samsung.com>

EDITOR'S NOTE: Usually, we produce the summit reports using a cronologic approach. This time, I opted to move the content of the second day to the beginning of the report, as they're basically several presentations we had covering the Media Controller needs. I opted to put the presentations first, and then put the discussions we had on July 29 and 31 together.

============================================================================

1) Presentations made on July, 30

1.1. Videobuf2 redesign to allow it to support DVB

Representatives from Samsung offered a presentation via video conference about the scheduled changes that are planned in order to split the videobuf2 core from the V4L2 specific part. This will allow the videobuf2 core to also be for DVB.

1.2. DVB pipelines

Samsung representatives via video conference presented about the pipelines. Essencially, the pipelines on real use-cases for embedded devices would look like:

   tuner 1 ->          -> demux    -> Video
   tuner 2 ->   cam 1  -> demux    -> Audio
   tuner 3 ->   cam 2  -> demux    -> Data
           -> V4L2
           -> ALSA    

1.3. ASoC

http://linuxtv.org/downloads/presentations/mc_ws_2015/sound_media_controller.pdf

This presentation covered the following topics:
    Generic DT machine driver can support around half of DT based devices
    Not all required is data available in ACPI, meaning ACPI based devices typically have their own drivers.
    DAPM handles power management in ASoC much like the current omap3isp driver implementation does.
    Walks the graph
    ALSA supports large numbers of entities and cyclical graphs
    ALSA contains ASoC dependencies, but the core of the algorithm is generic
    A stack based, iterative version is in the works
    MC has generic graph walking code as well
    Iterative
    Less concerned with performance
    omap3isp driver has PM code, which could be more generic
    Ideally we should have single implementation for graph walking and for power management

1.4 Updates to ALSA and au0828 to share resources:

http://linuxtv.org/downloads/presentations/mc_ws_2015/alsa_media_controller.pdf

1. The au8522 pad that sends data to the ALSA entity is currently represented as state->pads[AU8522_PAD_AUDIO_OUT].flags = MEDIA_PAD_FL_SINK. It should be, instead MEDIA_PAD_FL_SOURCE, as it provides data to the ALSA PCM capture device node.
2. ALSA PCM operates in atomic context by default holding a spinlock. This atomic locking conflicts with graph_mutex hold from Media Controller API from ALSA and au0828 drivers.
   However, there are concerns about I2C drivers breaking if graph_mutex is changed to a spinlock.
   Lars suggested, instead, to use ALSA in non-atomic context:
      Not a good idea to change graph_mutex to spinlock at MC as this will badly impact calls from I2C drivers, causing them to break.
      Using ALSA in non-atomic is simple: just initialize pcm->substream->nonatomic = 1
      IRQ safe start/stop pipeline will not be necessary anymore.
   This will reduce the work and patch series v6 becomes smaller.
3. An enable_source() function is necessary at media_device level, but find a better name
4. A Write helper function to hide decoder and tuner details from ALSA should be written
5. Support for remove links are needed - Shuah can do that as part of ALSA work, after adding support for it at the core
6. Managed Media Controller API uses devres - change it to get reference and put reference (kref), as it isn't safe to delete media_device device resource.
   Shuah will create a media_device_get() and media_device_put() set of functions.
   In addition, deleting media device Managed or otherwise is a problem. This problem isn't just a Managed Media Device issue.

1.5 IIO - Industrial I/O

http://linuxtv.org/downloads/presentations/mc_ws_2015/iio_media_controller.pdf

- ADC, DAC, accelerometer, gyro, light sensor, pressure, manometer
- typically: low speed < 10kbaud, I2C/SPI
- changes: up to 5Gbaud, separate control and data bus (LVDS, JESD204b)
- can be used by multi-channel SDR
- Complex processing pipelines
  - Inside a converter (built-in filters, digital modulator/demodulator)
  - Inside the FPGA (processing, DMA, HW loopback)
  - On the PCB, multiple (synchronous converters)
- Topology information needs to be available => media controller

2) Keysign party at the afternoon of July, 30

We did a Keysign party, where the gpg keys got cross-signed among the participants.

3) Discussions about the Media Controller API and the needs to extend it to support the requirements for DVB, ALSA and IIO

3.1) Discussions took at July, 29

Basic requirements:
	- Properly represent kernel→userspace API interfaces;
	- Allow dynamic pipeline changes;
	- Define the namespace for interfaces and entities;
	- Support additional properties;
	- Better represent entities that belong to more than one type

It was proposed to use the concept of planes, as defined by ITU and IEEE to represent different layers of a data or media network (ITU-T G.800). So, we would have control and data planes.

http://linuxtv.org/downloads/presentations/mc_ws_2015/media_controller_summit_needs.pdf

This is a concept largely used on networks, as show at: http://etherealmind.com/controller-based-networks-for-data-centres/

Multiple options to express association between device nodes and entities:
    - Same IOCTL API as for data links, difference made between data and control links
    - Different IOCTL API to enumerate interfaces, with associated entities
    - Properties

The decision was, instead, to add a new graph element type (Interface) to represent the elements that controls the entities.

It was agreed with the following terminology:
    - Entity: Functional unit, typically a hardware component or subunit in a hardware component
    - Pad: Data Input/Output of an entity
    - Interface: Control point implementing a userspace API
    - Link: Connection between a source pad and a sink pad

It was also proposed to use the name “association” for the links between interface and entity, but there was no consensus about that idea.

EDITOR'S NOTE: On July, 31 we started using the name “links” also for the connection between an entity and an interface. We used the term “interface links” for such links when we need to distinguish them from “data links” (e. g. pad to pad links).

Mauro's concern is that there will be lots of code duplication in the Kernel if we use a different graph type for the interface links.

The relationship between Interfaces and entities are n-n:
    -  One interface can control multiple entities
    -  One entity can be controlled by multiple interfaces

Media interfaces
    - A concept of user space facing interfaces
    - An object of its own right (such as media entities)
    - At the same level than entities, e. g. they'll be at the same graph, and not on separate planes

Working proposal (as proposed on July, 29)

    - Introduce struct media_interface as an object type alongside with entities in the Kernel and in the user space
    - See how the patches will look like; start with V4L2 and proceed with DVB
    - How much will there be code duplication?
    - Target 4.3 at earliest, more likely 4.4

The current API does a crap job on properly defining entities that are coupled to interfaces, and prevented the enablement of the MC DVB support, submitted in December, 2014. That needs to be fixed as soon as possible, as it is causing bad impact on using MC even for other V4L2 device types, like radio. So, Mauro stated that, as the MC API is currently on a broken state, no patches, drivers or framework changes related to the Media Controller will be merged upstream until this is fixed. Fixup patches may be merged, though.

    - Hans would try to do the work (of proposing the userspace API) at the week after the MC workshop.

Userspace API Requirements:
    - Enumerate Entities + pads/links (exists today)
    - Enumerate Interfaces + entity associations (and define which interface is the default one)
    - For entities: enumerate associated interfaces
    - Should support two application models: Entity-centric and Interface-centric
    
Additional API requirements that should be addressed in the future:
    - MC: 'versioning number' so apps are informed if the topology has changed.
    - MC: Notification events for topology changes
    
Points to solve:
     - entity.type - should be renamed to reflect what's there;
     - How to represent DVB entities/interfaces?
     - How to represent DVB network interfaces?
     - How to represent ALSA entities?
     - What fields are needed for media interfaces at the public API?
     - Changes at media-ctl userspace application

Some notes to help with network interface definitions:
    - man 7 netdevice
    - man 7 rtnetlink
    - Network interface index is constant for a network device
    - Network interface index can be converted to name etc. by an IOCTL

DRM subsystem uses u64 instead of pointers at the public API:
    - IOCTL design: http://blog.ffwll.ch/2013/11/botching-up-ioctls.html
    - Not widely used outside DRM
    - Most sub-systems have their own conventions

TODO:
    - Add graph topology version to the enumeration (and possibly other) ioctls

Question: should we redesign everything in order to support topology changes?

3.2) Discussions took at the afternoon of July30 and on July, 31st

It was discussed if we should add a generic graph framework in the kernel. This would require review on linux-kernel and such review may take a long time, as different requirements could pop up. So, perhaps not this time.

It was presented some topology for simple hybrid TV hardware (PC-customer hardware), at:
http://linuxtv.org/downloads/presentations/mc_ws_2015/media_controller_summit_TV_pipelines.pdf

An agreement was arrived for the UAPI interface.

What was agreed:
    media interfaces will be a separate graph element;
    links will be used to connect both entities (pads to pads) and media interfaces;
    PADs will use unique IDs
    preliminary header changes: http://linuxtv.org/downloads/presentations/mc_ws_2015/media.h


V4L2 applications need to know if they can capture from an input/tuner. To make that easy for them, it was proposed to add a new flag to VIDIOC_ENUMINPUT and whether the tuner is in use (and/or the tuner state) through VIDIOC_G_TUNER. This can't be done at the DVB side, however, as there are no reserved fields there.
It should be noticed that, on DVB API, userspace doesn't query anything before setting the frontend. The first thing it does after open() is to set the frontend. So, there's no way to add it and being backward compatible.
Also, hybrid TV devices typically have other bottlenecks that prevent both analog and digital part of the chipset to be used at the same time. So, it is not physically possible to stream from an S-Video connector while DVB is tuned. So, adding a flag at V4L2 saying tha the tuner is in usage or not won't help.
Such bottleneck could be at DMA transfers or at the USB bridge or can simply be the lack of support on the internal firmware of the device. As a general rule, we don't know exactly where the constraint is, as vendors don't document the exact hardware architecture on their datasheets. So, the only alternative left is to decouple the interface links on the digital side when analog is in usage and vice-versa.

It was discussed about the need to allow bidirectional pads (needed for connectors like a coax that are bidirectional using time or frequency multiplexing)

TODO: Connector entities

It was proposed the following possible types of entities:
    Connector, DMA engine, processing block and controller block

Whather an entity is a connector needs to be told, as this can't be discovered

All others can be derived from other information already in the graph?

Entity functional properties

    Most of the properties at entity level would be used to signal capabilities that can be figured out using sub-system specific interfaces the application already uses


Interfaces

    Agreement: interfaces do have a type
    Types include V4L2, ALSA, DVB etc.
    Sub-types are used to tell between different interface types inside the sub-system

    An interface can be a device node, network interface or a sysfs directory

It was proposed two new ioctls:
    G_TOPOLOGY IOCTL should not be used to convey arbitrary sysfs paths. It was agreed, instead, that sysfs paths will be passed via MC properties.
    G_INTERFACE to pass information on single interface; there, a single pointer set by the user would be feasible. The struct can be the same.


Finding entities - current situation
    Especially device specific applications often need to find an exact entity the application requires
    This may be a certain scaler in the graph, for instance
    Configuration may involve e.g. private IOCTLs only a certain sub-device implements
    Name is only 32 bytes at the moment
    In practice, external entities have used i2c bus number and i2c address as part of the name
    This does not scale for DT based devices where the device is uniquely identified by a string that can be very long
    Blocks that are a part of an ISP there's been just a name of the block without any device specific information
    This causes that if one has multiple such devices in the system, the name is no longer unique
    The entity name is not enough to uniquely find an entity in a general case
    In a general case it is not possible to recognise an entity
    Hot pluggable buses and entities that have no serial numbers or something equivalent
    In order to best help the user space, all the information that matters should be provided to the user

So, it ended by having device names such as "omap3isp resizer"

Other data could be used to enhance the device name, like:
    Bus
    Serial number
    Sysfs name - Unfortunately, in practice, this is not as stable as it would be expected, despite sysfs being documented at Documentation/ABI/. Yet, it may still be better than bus in some cases

This should enable most of the use cases where entities need to be found


Properties

Array of properties as an IOCTL argument has the problem that the user would have to allocate enough memory for each key-value pair in the array. This is unfeasible.

The original proposal used a text-based format for the purpose of discussing what properties should be, and left the question of the binary format for the ABI open. So, one question remains if the API should use either a text-based onr a binary-based format. Using a text based format requires parsing by the user, albeit the kernel interface would remain simple

The new proposal at the new media.h file (http://linuxtv.org/downloads/presentations/mc_ws_2015/media.h) combines the best of both: a single memory area amended with an array of properties that refer to the memory area

For the media properties, using strings the key type has benefits, as hierarchy is possible, with is not possible using an u32 integer for instance.

Should values be always strings or should other types be accepted? Probably having other types is a good idea.

Different options for arrays. For example:
    As part of the key: entity.0/name
    As part of the property: add a length field. This is convenient except for strings, where it works as well --- just count the nul characters.

The better representation for arrays should be discussed on a RFC for the properties.

Properties could be seen as re-implementing sysfs on the discussions with linux-api people. However they're much more light-weight. Also, there's no atomic access of all sysfs properties and sysfs is limited to page size
Properties can be queried by media object, in which case the media object id would be provided
The entire tree of properties can be obtained using object id 0

Another option for the kernel interface: key/length/value
    E.g.  type (u32) | length (u32) | value (string) | key (string)


Media objects
    Media objects have an unique ID in the system
    Objects can be entities, pads or interfaces, for instance
    A few bits can be reserved for object types, e.g. entity == 0; interface == 1, pad == 2

Action Items:

- media_interface/media_topology: RFC for userspace API: Hans
- RFC patch series: internal implementation for interface/topology: Mauro
- Migration: add v4l-subdev media_interface: Laurent
- Migration: add explicit DMA Engine entity: Laurent
- media_properties: RFC userspace API: Sakari
- MC core support for dynamically adding/removing from the media graph: Samsung
- Clarify/implement DVB network interface: Mauro
- MC support for Alsa: Lars: Need RFC before Alsa summit during ELCE
- MC support for DVB: Mauro
- MC default core support for interface-centric V4L2: Hans (?)
- MC support for IIO: Lars
- VIDIOC_ENUMINPUTS/G_TUNER: tell if the tuner/input is busy: RFC Hans, Shuah has a backend for this.
- Fix media_device broken alloc/remove (devres): Shuah


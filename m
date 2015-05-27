Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55016 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbbE0PPX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 11:15:23 -0400
Date: Wed, 27 May 2015 12:15:13 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Media controller entity information property API
Message-ID: <20150527121513.18dca204@recife.lan>
In-Reply-To: <20150527133933.GB25595@valkosipuli.retiisi.org.uk>
References: <20150527133933.GB25595@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 May 2015 16:39:33 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi folks,
> 
> It has been discussed in several occasions that the current
> MEDIA_IOC_ENTITY_INFO IOCTL does not address various needs that have arisen
> since the API was merged to the mainline kernel. It also has been recognised
> that the current interface is not meaningfully extensible in a future-proof
> fashion; something drastically different is needed.
> 
> The name "Property API" or "Property based API" has been mentioned every
> time in those discussions as a fix to the issues. By that term, different
> people probably have meant slightly different things at different points of
> time.
> 
> This RFC intends to address the issues (see below) and define what a
> Media entity information property API should be like.
> 
> 
> Current interface
> =================
> 
> #define MEDIA_IOC_ENUM_ENTITIES         _IOWR('|', 0x01, struct media_entity_desc)
> 
> struct media_entity_desc {
>         __u32 id;
>         char name[32];
>         __u32 type;
>         __u32 revision;
>         __u32 flags;   
>         __u32 group_id;
>         __u16 pads; 
>         __u16 links;
> 
>         __u32 reserved[4];
> 
>         union {
>                 /* Node specifications */
>                 struct {
>                         __u32 major;
>                         __u32 minor;
>                 } dev;
> 
> #if 1
>                 /*
>                  * TODO: this shouldn't have been added without
>                  * actual drivers that use this. When the first real driver
>                  * appears that sets this information, special attention
>                  * should be given whether this information is 1) enough, and  
>                  * 2) can deal with udev rules that rename devices. The struct 
>                  * dev would not be sufficient for this since that does not    
>                  * contain the subdevice information. In addition, struct dev  
>                  * can only refer to a single device, and not to multiple (e.g.
>                  * pcm and mixer devices).
>                  *
>                  * So for now mark this as a to do.
>                  */
>                 struct {
>                         __u32 card;     
>                         __u32 device;   
>                         __u32 subdevice;
>                 } alsa;
> #endif
> 
> #if 1
>                 /*
>                  * DEPRECATED: previous node specifications. Kept just to  
>                  * avoid breaking compilation, but media_entity_desc.dev   
>                  * should be used instead. In particular, alsa and dvb     
>                  * fields below are wrong: for all devnodes, there should  
>                  * be just major/minor inside the struct, as this is enough
>                  * to represent any devnode, no matter what type.
>                  */
>                 struct {
>                         __u32 major;
>                         __u32 minor;
>                 } v4l;  
>                 struct {
>                         __u32 major;
>                         __u32 minor;
>                 } fb;   
>                 int dvb;
> #endif
> 
>                 /* Sub-device specifications */
>                 /* Nothing needed yet */
>                 __u8 raw[184];
>         };
> };
> 
> The interface has been recently amended by Mauro's patch
> "[media] media: Fix DVB devnode representation at media controller", commit
> id e31a0ba7df6ce21ac4ed58c4182ec12ca8fd78fb in media-tree currently.
> 
> 
> Use cases that don't fit to the current interface
> =================================================
> 
> 
> DVB and Media controller
> ------------------------
> 
> Some of the entities in the DVB Media controller graph need to expose three
> device nodes --- the reason is that the DVB subsystem provides choices to
> the user in terms of which interface to use. The union in struct
> media_entity_desc only provides a single struct for device minor and major.
> Adding more device nodes would not scale; the user would have to know
> additional information on the nodes, i.e. which one is which and so forth.
> 
> 
> Identifying entities
> --------------------
> 
> Some years ago when the Media controller interface was first accepted to the
> mainline kernel, naming entities uniquely in a media device was no issue.
> There were ISP or bridge drivers that created the media entity, accompanied
> by drivers for external entities most of which were I2C devices directly
> connected to the ISP device.
> 
> Things aren't quite that simple anymore. Creating a cross device (e.g. two
> otherwise independent IP cores) or a system wide media device would greatly
> ease creation of cross-device pipelines as there is no single master driver
> anymore. As a side effect entity names have to be unique across such devices
> (or the entire system), not only within a media device.
> 
> Constructing unique names that are human readable, stable, unique and fit to
> 31 characters reserved for the purpose is not thought to be possible: device
> bus string that would be in some cases enough to uniquely identify a device
> any be longer than that. On hot-pluggable busses e.g. a serial number is
> needed.
> 
> In a general case there is no definitive answer for finding an entity in
> this case, nor all information needed to find an entity will fit to 31
> characters reserved for the purpose.
> 
> The interface should thus concentrate in providing all the information
> required for recognising an entity to the user. In most cases a shorthand
> name could be used but the uniqueness of that may not be guaranteed. Long
> names would need to be used if the short names are not unique.
> 
> 
> Design considerations
> =====================
> 
> The idea behind the property API is to provide information in a less
> inflexible form than a C struct which defines the memory layout of the data
> precisely. For instance --- alsa and fb structs in struct media_entity_desc
> were never used for their original purpose; we'd rather like to get rid of
> them instead. (The original idea was that an entity could expose different
> user space APIs and not be restricted to a single one.)
> 
> As the fields are there, an application might be using them and removing
> them is a no-go since that would likely break such an application. Not all
> fields would also be valid for every type of hardware --- for example, some
> devices have serial numbers whereas others do not.
> 
> This is why the properties API should provide key / value pairs instead. The
> length of the data required to pass all the information related to an entity
> should also not be fixed, thus a single struct alone is not suitable for the
> task.
> 
> 
> Traditional C structs vs. a tree of properties
> ----------------------------------------------
> 
> Unlike in traditional C structs as IOCTL arguments, in the case of key /
> value pairs the essence of the interface is no longer the struct definition,
> but what kind of information is presented in the tree structure and what is
> the meaning of the information. Instead of paying attention to struct
> fields, attention needs to be drawn to the documentation of keys (and
> possible values).
> 
> 
> Tree vs. flat
> -------------
> 
> A flat structure is easier to generate and parse than a tree but it may be
> too limited to address the problem at hand. A tree based structure will
> suffer less name clashes since the path from root to the branch defines the
> property rather than the property name string alone.
> 
> For the expressiveness I choose to propose a tree structure for properties.
> 
> 
> Text vs. binary
> ---------------
> 
> The structure of the properties tree can be non-trivial. This RFC defines a
> text representation format of the tree to facilitate discussing and
> documenting the tree structure separately from its binary representation
> used in IOCTL calls. The terms are used elsewhere in the document.
> 
> A binary format is needed to pass the properties tree between kernel space
> and user space. This RFC proposes a straightforward solution to this issue
> that consists of using the text-based representation as-is as the binary
> format. Other proposals are welcome and can be discussed. As the binary
> format is decoupled from the tree structure the two issues can be debated
> separately.
> 
> 
> Text based syntax
> -----------------
> 
> Considering previous work, there are two to mention: Device tree and JSON.
> Both would apparently be fit for the task: they define a syntax by which a
> tree representation can be conveyed in text format.
> 
> The text based format will most probably need to be produced from a data
> structure based representation in a program (kernel or user, for displaying
> purposes at least) and possibly parsed (or compiled if you wish). (The text
> based format may also used by the IOCTL interface, but that is of secondary
> importance right now.)
> 
> JSON has some advantage over device tree, such as more compact format when
> dealing with arrays of objects; also phandles are not needed. There's also a
> variety of existing libraries to choose from, many are licensed under free
> software licenses suitable for libraries such as MIT or the modified BSD
> licenses. One example of those is Jansson [1].
> 
> On the other hand, DT is already used in the kernel albeit only a binary
> representation is accessed by the kernel. That representation would need
> still to be turned to the representation chosen for the IOCTL interface.
> 
> 
> Accessing properties
> --------------------
> 
> As accessing the information present in the properties will be more complex
> than just accessing a field in a struct, a library must be provided to ease
> accessing properties. Applications must not be expected to parse a
> text-based format, but a convenience function is needed for the purpose.
> This shall be part of the libmediactl library.
> 
> The binary representation must be produced by the Media controller framework
> and not by individual drivers; this is extra work for the driver and
> completely unnecessary. Instead, a common implementation can be written that
> will manage the tree representation using kernel specific data structures.
> 
> 
> Data types
> ----------
> 
> I first thought that explicit typing should not be required and everything
> could be represented as text the user could parse as needed. Integers would
> still need to be told from strings though. However, most languages (such as
> C) require strong typing and thus applications end up using a type for a
> purpose, whether it was right or wrong one. For that reason explicit types
> are still needed, at least in property documentation. Probably 32-bit
> unsigned integers and UTF-8 encoded strigs will go a long way.
> 
> 
> The proposal
> ============
> 
> There are three aspects in the proposal that are relatively independent of
> each other, so that each can be changed of even replaced without affecting
> others.
> 
> 1. the IOCTL interface to obtain the information,
> 
> 2. the syntax of the text based representation and
> 
> 3. the semantics, i.e. what does it all actually mean.

Let me discuss first the syntax and semantics of RFC. The ioctl
changes, if needed, can be discussed latter, but whatever way we model,
it should be properly mapping the device.

> 
> 
> IOCTL interface
> ===============
> 
> There's a reserved field of four-long u32 array in struct media_entity_desc.
> Two of them could be used to add an array pointer to the memory of the
> text-based tree. The length of the memory area would also be needed,
> requiring the third item in the array.
> 
> However, as the interface will be quite different from the old one, putting
> it behind the same IOCTL might not make sense; the only common factor in the
> two is the entity ID. A new IOCTL is thus considered as a better option.
> 
> /*
>  * struct media_entity_ext_desc - Describe a media entity
>  * @tree: The pointer to the property tree structure. Always nul terminated.
>  * @len: Length of the property tree structure in bytes, including trailing
>  *	 nul.
>  *	 write: memory reserved for tree.
>  *	 read: length of the tree structure.
>  * @reserved: Must be zeroed for now.
>  *
> struct media_entity_ext_desc {
> 	media_entity_tree_t *tree;
> 	uint32_t len;
> 	uint32_t reserved[6];
> };
> 
> #define MEDIA_IOC_EXT_ENUM_ENTITIES         _IOWR('|', 0x04, struct media_entity_ext_desc)
> 
> The IOCTL will return the ENOSPC error if len bytes is not enough to contain
> the entire property tree. In this case the user will be able to obtain the
> length of the tree structure from the len field, allocate more memory and
> issue the IOCTL again.


> 
> 
> Examples
> ========
> 
> Here are three examples in JSON syntax: a tuner, a demodulator and a camera
> sensor.
> 
> "entity": {
> 	"name": "foo tuner",
> 	"function": [ "dvb-tuner", "fm-tuner" ],

That doesn't sound quite right. The tuner itself is not "FM-tuner". 

A "FM tuner" is actually a tuner that may support the frequency range used
by FM, plus a FM demodulator. Some devices are built that way (like tea5767),
while others (analog tuners, like FM1216) are just the tuner. The FM 
demodulator is on a separate component. For example, several chipsets
(bt878, cx88, saa7134...) have FM demodulators inside them. Depending if
they're connected to a simple analog tuner like FM1216 or to a "radio tuner"
like tea5767, the "FM demodulator" function will be either at the bridge
or at the tuner.

Calling a tuner as "dvb-tuner" also sounds wrong. An analog tuner like
the ones mapped at tuner-simple.c or at dvb-pll.c are just the tuners
without anything special for DVB usage. Other devices may have special
functions to optimize to cable, terrestrial and/or satellital usage,
optimized to filter spurious interference on that specific media.

> 	"id": 3,
> 	"devnode": [
> 		{
> 			"major": 81,
> 			"minor": 0,
> 			"type": "V4L2 sub-device"
> 		}, {
> 			"major": 212,
> 			"minor": 3,
> 			"type": "DVB frontend"
> 		}

This is wrong. A tuner is never a DVB frontend, as the frontend consists
on more hardware than just the tuner.

> 	],
> 	"device": {
> 		"bus": "i2c:1-0025"

This also sounds somewhat limiting, as some devices may use the same
I2C bus for two completely different functions. For example, au8522 is
both a V4L2 demod and a DVB demod. Despite the name "demod" on both, 
they're different and appear on separate parts of the data graph.

> 	}
> }
> 
> "entity": {
> 	"name": "bar demux",
> 	"function": [ "dvb-demod" ],
> 	"id": 2,
> 	"devnode": [
> 		{
> 			"major": 81,
> 			"minor": 0,
> 			"type": "V4L2 sub-device"

Huh? V4L2 subdevice for a dvb-demod? That doesn't make any sense.

> 		}, {
> 			"major": 212,
> 			"minor": 3,
> 			"type": "DVB frontend"

Again, this is wrong, as a demux is not a frontend.

> 		}
> 	],
> 	"device": {
> 		"bus": "i2c:1-0023"
> 	}
> }
> 
> "entity": {
> 	"name": "jt8ev1 0-0010 pixel array",
> 	"function": [ "camera-sensor" ],
> 	"id": 4,
> 	"devnode": {
> 		"major": 81,
> 		"minor": 3,
> 		"type": "V4L2 sub-device"
> 	},
> 	"device": {
> 		"bus": "i2c:0-0010"
> 	}
> }
> 
> 
> Semantics
> =========
> 
> This is the part that's probably the most difficult one and where most of
> the attention should be. What is defined in the tree structure will be there
> as much as a field in the struct media_entity_desc.
> 
> The properties below contain the information that can be conveyed using
> MEDIA_IOC_ENUM_ENTIITIES and more.
> 
> 
> entity branch
> -------------
> 
> Information related to an entity. We might also drop this and move
> everything under this to root.
> 
> entity.name (string)
> 
> 	Human-readable name of the entity. May not be the same as struct
> 	media_entity_desc.name if e.g. the I2C address was a part of the
> 	entity name. This name may no longer be unique in a system, i.e.
> 	this is the short name.
> 
> entity.function (array of strings)
> 
> 	Functions of the entity. An entity may have several functions. The
> 	possible functions must be documented; functions may not be chosen
> 	by drivers arbitrarily.
> 
> entity.id (int)
> 
> 	An numeric identifier of the entity (as in struct
> 	media_entity_desc.id).
> 
> 
> entity.devnode branch
> ---------------------
> 
> The entity.devnode branch describes device nodes related to an entity. This
> may be an array.
> 
> entity.devnode.major (int)
> 
> 	Major number of a device node implemented by the driver for the
> 	entity.
> 
> entity.devnode.minor (int)
> 
> 	Minor number of a device node implemented by the driver for the
> 	entity.

The above definition are not OK. Only V4L2 implements device nodes on
the drivers. The radio/video/vbi devnodes, on V4L2, and all device nodes,
on DVB, are implemented by the core.

On DVB side, the device nodes are associated with a set of functions
that are controlled, and not to a direct hardware component. On most
cases, they control more than one hardware components, and there are
cases where the same hardware component have part of its functions
controlled by one device driver and other parts controlled by another.

That's the case, for example, of the DVB demux, as a network interface
creation involves not only the network hardware but also setting a
PID filter.
> 
> entity.devnode.type (string)
> 
> 	Type of a device node implemented by the driver for the entity.
> 	Valid type strings need to be documented in the API documentation.
> 
> 
> entity.device branch
> --------------------
> 
> The entity.device branch contains information on the device the entity
> describes. The device may be a physical hardware device, an IP block in an
> integrated circuit or a set of functionality logically belonging together,
> for instance.
> 
> entity.device.bus (string)
> 
> 	Entity bus information. The entity may be uniquely identified by the
> 	entity.device.bus string. Hot-pluggable devices may have unstable
> 	entity.device.bus however.
> 
> 	Rules for constructing bus strings must be defined in the
> 	documentation.

As I said before, an uniquely identifier here wont work, in the cases
where the same I2C adapter controls multiple entities.

> 
> entity.device.serial (string)
> 
> 	Serial number of the device.

That sounds hard to map, as sub-devices don't have serial numbers.

> 
> 
> Compatibility
> =============
> 
> As a number of existing applications use the old interface, and newer
> applications might run on an older kernel, maintaining interface
> compatibility to the extent meaningfully possible is needed. What's in
> struct media_entity_desc should always be available through the property API
> (when relevant) but no new fields should be added to struct
> media_entity_desc to support features in the media entity information
> property IOCTL.
> 
> 
> References
> ==========
> 
> [1] Jansson. <URL:http://www.digip.org/jansson/>

There is one fundamental part missing on your proposal: how to
properly represent the way userspace is supposed to control a given
device?

As pointed above, mapping a set of device nodes to an entity is
wrong.

Assuming that an entity is controlled by more than one device node,
typically each device node controls a subset of functions, and
the control can either be direct or indirect.

For example, the control graphs of a tuner can be:

V4L2 subdevice ======== full tuner control =============> [tuner]
V4L2 video devnode ==== analog TV tuner ================> [tuner]
V4L2 vbi devnode ==== (no control?) ====================> [tuner]
SDR radio devnode ===== full tuner control =============> [tuner]
radio devnode ========= radio and AM/FM demod control ==> [tuner]
dvb frontend ==> [demod] === digital TV tuner control ==> [tuner]

Also, while the V4L2 subdevice access can be done anytime, the
video|swradio|radio|dvb/frontend devnode access is exclusive:
only one can be active on a given time.

The vbi devnode is an special case: it can only be active if
the tuner is providing video. In principle, it should not be
controlling the tuner (except if the device that implements the
tuning function may also implement analog TV decoding), but
it should be doing DMA transfers for the Vertical Blank Interval
data.

So, while the properties API you're proposing may solve other
use cases, I don't see it even close to solve the needs for
DVB or even V4L2 radio.

Regards,
Mauro

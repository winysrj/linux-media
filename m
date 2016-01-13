Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35222 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbcAMCqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2016 21:46:23 -0500
Date: Wed, 13 Jan 2016 00:46:16 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.5-rc1] media controller next gen patch series
Message-ID: <20160113004616.7702c5ef@recife.lan>
In-Reply-To: <1552679.HPiC5NBMqB@avalon>
References: <20160112084328.2194ec49@recife.lan>
	<1552679.HPiC5NBMqB@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 13 Jan 2016 00:29:35 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hello Mauro and Linus,
> 
> On Tuesday 12 January 2016 08:43:28 Mauro Carvalho Chehab wrote:
> > Hi Linus,
> > 
> > That's the second part of the media patches. It contains the media
> > controller next generation patches, with is the result of one year of
> > discussions and development. It also contains patches to enable media
> > controller support at the DVB subsystem.
> > 
> > The goal is to improve the media controller to allow proper support for
> > other types of Video4Linux devices (radio and TV ones) and to extend the
> > media controller functionality to allow it to be used by other subsystems
> > like DVB, ALSA and IIO.
> > 
> > In order to use the new functionality, a new ioctl is needed
> > (MEDIA_IOC_G_TOPOLOGY). As we're still discussing how to pack the struct
> > fields of this ioctl in order to avoid compat32 issues, I decided to add
> > a patch at the end of this series commenting out the new ioctl, in order
> > to postpone the addition of the new ioctl to the next Kernel version (4.6).
> > With that, no userspace visible changes should happen at the media
> > controller API, as the existing ioctls are untouched. Yet, it helps
> > DVB, ALSA and IIO developers to develop and test the patches adding media
> > controller support there, as the core will contain all required internal
> > changes to allow adding support for devices that belong to those
> > subsystems.  
> 
> This should already be known to anyone who has followed the discussions 
> regarding the media controller rework, but, hopefully without the full drama 
> that "speak now or forever hold your peace" implies, I'd like to express my 
> concern about this patch series to a wider audience.
> 
> First of all I agree, as I believe do all the Linux media developers involved 
> in this work, that a rework of the media controller framework is needed. The 
> effort was started by Mauro about a year ago and didn't get the attention it 
> deserved for around the first six months. I certainly have my share of 
> responsibility there for not taking enough time to review patches and actively 
> work on the series.
> 
> We met twice face to face with core developers during the last six months to 
> discuss the rework, both from an in-kernel framework point of view and from a 
> userspace API point of view. The process was painful but significant 
> agreements were reached and Mauro went back to the drawing board to rework his 
> patches.
> 
> As Stephen pointed out the series is large, and I believe it hasn't reached 
> the quality level it deserves. I have reviewed a large part of the initial 
> patches, and at least part of my comments have been addressed. Unfortunately 
> the way they were addressed was to pile fixes or rework commits on top of the 
> series, instead of reworking the original in-development commits. The same 
> strategy was used to fix build breakages or runtime bugs.

No. All known build breakage fixes were folded to the patch that caused 
compilation breakages. That's basically the reason for the rebase that
Stephen noticed. Are you aware of anything else? If so, please pinpoint
to the patch that need to be fixed.

On such rebase, I compiled the Kernel for every single patch in this series on
both x86 and x86_64, with allmodconfig. I also tested compiling them without
CONFIG_MEDIA_CONTROLLER on the relevant patches to be sure that build 
breakages wouldn't happen. 

I also did a runtime test on a NUC i7-core with an au0828, for every patch
I wrote in order to check against runtime bugs. Everything looks ok.

> I understand that this strategy comes from a fear of introduces breakages when 
> rebasing the code and folding fixes in the right locations. However, the end 
> result is a very large series that (at least last time I checked) breaks 
> bisection. That alone is a serious issue, as such a large series is bound to 
> introduce bugs, and making it unbisectable will hurt. Furthermore adding 
> patches on top of the branch has resulted in a very difficult to review 
> series. Patches can't be reviewed independently anymore as the base patches 
> are known to be broken and are fixed later. The only possible strategy to 
> review such a patch series is to read the overall diff. 

Other developers reviewed and acked those patches, sending their
reviews timely, but your reviews happened several months after the
other reviews. Granted, it is fine if you want to do a late review 
on a patch series, but you should not expect people redo their
entire work every time you decide to do this.

If I changed the patches due to your late review, I would need to strip the
already existing reviewed-by tags on several core patches. People would also
need to re-test the entire patch series in order to check against compilation
and runtime breakages. Also, to send a very large patch series like that to
the mailing list is painful for other developers and users that aren't working
with the media controller.

In addition, the extra patches due to your review are self contained, and
don't actually fix bugs, but do some cleanups, like, for example:
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=media-controller-rc6&id=07d4151c3bba40db4c594f4ec8a8c676b3bffa99
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=media-controller-rc6&id=8bd2c8a9cb60a2e67de49c0e86cafe99ca3cbacd
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=media-controller-rc6&id=7e6c8ba21bcb0402b5dadabe422fd10a7d0367e9

It is perfectly fine to do such cleanups later in the patch series.

On the cases where a bug were found by the reviews, the patch that caused
the trouble got fixed.

> And with a diffstat 
> such as "130 files changed, 5237 insertions(+), 1849 deletions(-)" I think we 
> will all agree that this isn't feasible.

Actually, the changes that you late-reviewed are mainly (if not all)
on the MC core:

  drivers/media/media-device.c                       | 441 ++++++++--
  drivers/media/media-devnode.c                      |  24 -
  drivers/media/media-entity.c                       | 724 +++++++++++------
  include/media/media-device.h                       | 469 ++++++++++-
  include/media/media-devnode.h                      |  54 +-
  include/media/media-entity.h                       | 904 ++++++++++++++++--
  include/uapi/linux/media.h                         | 228 +++++-

The remaining "130 files" are either documentation and some driver
changes needed by the kABI changes (plus DVB patches). Most of those
other changes are trivial ones (like macro renames).

> I won't formally nack this pull request as I don't want to send a nuke bomb 
> and watch the bridges collapse. As someone told me recently, nuke bombs are 
> only effective if your goal is destruction and fire, and I hope to be more 
> constructive than that. I would like to restate that the offer I made of 
> helping with rebasing the series still holds.
> 
> > The following changes since commit 768acf46e1320d6c41ed1b7c4952bab41c1cde79:
> > 
> >   [media] rc: sunxi-cir: Initialize the spinlock properly (2015-12-23
> > 15:51:40 -0200)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
> > tags/media/v4.5-2
> > 
> > for you to fetch changes up to be0270ec89e6b9b49de7e533dd1f3a89ad34d205:
> > 
> >   [media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY (2016-01-11 12:35:17
> > -0200)
> > 
> > ----------------------------------------------------------------
> > media updates for v4.5-rc1
> > 
> > ----------------------------------------------------------------
> > Dan Carpenter (2):
> >       [media] media-device: copy_to/from_user() returns positive
> >       [media] v4l2-device: fix a missing error code
> > 
> > Javier Martinez Canillas (26):
> >       [media] staging: omap4iss: get entity ID using media_entity_id()
> >       [media] omap3isp: get entity ID using media_entity_id()
> >       [media] media: use entity.graph_obj.mdev instead of .parent
> >       [media] media: remove media entity .parent field
> >       [media] omap3isp: separate links creation from entities init
> >       [media] omap3isp: create links after all subdevs have been bound
> >       [media] staging: omap4iss: separate links creation from entities init
> >       [media] v4l: vsp1: create pad links after subdev registration
> >       [media] v4l: vsp1: separate links creation from entities init
> >       [media] uvcvideo: create pad links after subdev registration
> >       [media] smiapp: create pad links after subdev registration
> >       [media] media: don't try to empty links list in media_entity_cleanup()
> >       [media] media-entity: init pads on entity init if was registered
> >       before
> >       [media] omap3isp: remove per ISP module link creation functions
> >       [media] omap3isp: remove pads prefix from isp_create_pads_links()
> >       [media] omap3isp: rename single labels to just error
> >       [media] omap3isp: consistently use v4l2_dev var in complete notifier
> >       [media] staging: omap4iss: remove pads prefix from
> > *_create_pads_links()
> >       [media] v4l: vsp1: remove pads prefix from *_create_pads_links()
> >       [media] v4l: vsp1: use else if instead of continue when creating links
> >       [media] uvcvideo: remove pads prefix from uvc_mc_create_pads_links()
> >       [media] uvcvideo: register entity subdev on init
> >       [media] media-entity: remove unneded enclosing parenthesis
> >       [media] media-device: check before unregister if mdev was registered
> >       [media] media-device: split media initialization and registration
> >       [media] media-device: set topology version 0 at media registration
> > 
> > Mauro Carvalho Chehab (123):
> >       [media] au0828: Cache the decoder info at au0828 dev structure
> >       [media] media: get rid of unused "extra_links" param on
> > media_entity_init() [media] Kconfig: Re-enable Media controller support for
> > DVB
> >       [media] au0828: Fix the logic that enables the analog demoder link
> >       [media] media: create a macro to get entity ID
> >       [media] media: add a common struct to be embed on media graph objects
> >       [media] media: use media_gobj inside entities
> >       [media] media: use media_gobj inside pads
> >       [media] media: use media_gobj inside links
> >       [media] media: add messages when media device gets (un)registered
> >       [media] media: add a debug message to warn about gobj creation/removal
> >       [media] media: rename the function that create pad links
> >       [media] uapi/media.h: Declare interface types for V4L2 and DVB
> >       [media] media: add functions to allow creating interfaces
> >       [media] media: Don't accept early-created links
> >       [media] media: convert links from array to list
> >       [media] media: make add link more generic
> >       [media] media: make media_link more generic to handle interace links
> >       [media] media: make link debug printk more generic
> >       [media] media: add support to link interfaces and entities
> >       [media] media-entity: add a helper function to create interface
> >       [media] dvbdev: add support for interfaces
> >       [media] media: add a linked list to track interfaces by mdev
> >       [media] dvbdev: add support for indirect interface links
> >       [media] uapi/media.h: Fix entity namespace
> >       [media] replace all occurrences of MEDIA_ENT_T_DEVNODE_V4L
> >       [media] replace all occurrences of MEDIA_ENT_T_DEVNODE_DVB
> >       [media] media: add macros to check if subdev or V4L2 DMA
> >       [media] media: use macros to check for V4L2 subdev entities
> >       [media] omap3/omap4/davinci: get rid of MEDIA_ENT_T_V4L2_SUBDEV abuse
> >       [media] s5c73m3: fix subdev type
> >       [media] s5k5baf: fix subdev type
> >       [media] davinci_vbpe: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
> >       [media] omap4iss: change the logic that checks if an entity is a
> > subdev
> >       [media] v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs
> >       [media] media controller: get rid of entity subtype on Kernel
> >       [media] media.h: don't use legacy entity macros at Kernel
> >       [media] DocBook: update descriptions for the media controller entities
> >       [media] dvb: modify core to implement interfaces/entities at MC new
> > gen
> >       [media] media: report if a pad is sink or source at debug msg
> >       [media] uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY ioctl
> >       [media] media: Use a macro to interate between all interfaces
> >       [media] media: move mdev list init to gobj
> >       [media] media-device: add pads and links to media_device
> >       [media] media_device: add a topology version field
> >       [media] media-device: add support for MEDIA_IOC_G_TOPOLOGY ioctl
> >       [media] media-entity: unregister entity links
> >       [media] remove interface links at media_entity_unregister()
> >       [media] media-device: remove interfaces and interface links
> >       [media] media-entity: protect object creation/removal using spin lock
> >       [media] tuner-core: add an input pad
> >       [media] dvbdev: enable all interface links at init
> >       [media] au0828: postpone call to au0828_unregister_media_device()
> >       [media] media-entity: fix backlink removal on
> > __media_entity_remove_link()
> >       [media] dvbdev: returns error if graph object creation fails
> >       [media] v4l2-core: create MC interfaces for devnodes
> >       [media] media-entity.h: document all the structs
> >       [media] media.h: create connector entities for hybrid TV devices
> >       [media] au0828: add support for the connectors
> >       [media] au0828: Create connector links
> >       [media] media-device: supress backlinks at G_TOPOLOGY ioctl
> >       [media] v4l2 core: enable all interface links at init
> >       [media] dvb core: must check dvb_create_media_graph()
> >       [media] media-entity: enforce check of interface and links creation
> >       [media] cx231xx: enforce check for graph creation
> >       [media] au0828: enforce check for graph creation
> >       [media] media-entity: must check media_create_pad_link()
> >       [media] media-entity.h: rename entity.type to entity.function
> >       [media] media-device: export the entity function via new ioctl
> >       [media] uapi/media.h: Rename entities types to functions
> >       [media] DocBook: update entities documentation
> >       [media] dvbdev: move indirect links on dvr/demux to a separate
> > function 
> >       [media] dvbdev: Don't create indirect links
> >       [media] media_entity: remove gfp_flags argument
> >       [media] media-device: use unsigned ints on some places
> >       [media] media-device: put headers in alphabetic order
> >       [media] media-device: better name Kernelspace/Userspace links
> >       [media] media framework: rename pads init function to
> > media_entity_pads_init()
> >       [media] media-entity.h: get rid of revision and group_id fields
> >       [media] DocBook: Move media-framework.txt contents to media-device.h
> >       [media] media-entity.h: convert media_entity_cleanup to inline
> >       [media] media-device.h: Improve documentation and update it
> >       [media] media: remove extra blank lines
> >       [media] media-entity: get rid of forward __media_entity_remove_link()
> > declaration
> >       [media] media_entity: get rid of a unused var
> >       [media] media_entity: rename media_obj functions to *_create *_destroy
> >       [media] media-entity.h: move kernel-doc tags from media-entity.c
> >       [media] media: use unsigned for pad index
> >       [media] media-device.h: Let clearer that entity function must be
> > initialized
> >       [media] media-device: Use u64 ints for pointers
> >       [media] media: move MEDIA_LNK_FL_INTERFACE_LINK logic to link creation
> >       [media] media.h: let be clear that tuners need to use connectors
> >       [media] dvbdev: Document the new MC-related fields
> >       [media] DocBook: MC: add the concept of interfaces
> >       [media] DocBook: move data types to a separate section
> >       [media] Docbook: media-types.xml: update the existing tables
> >       [media] DocBook: add a table for Media Controller interfaces
> >       [media] DocBook: Document MEDIA_IOC_G_TOPOLOGY
> >       [media] media-entity.h: Document some ancillary functions
> >       [media] media-device.h: document the last functions
> >       [media] media-devnode: move kernel-doc documentation to the header
> >       [media] media-devnode.h: document the remaining struct/functions
> >       [media] media-entity: use mutes for link setup
> >       [media] media-entity: cache media_device on object removal
> >       [media] media-device: move media entity register/unregister functions
> >       [media] media-device: better lock media_device_unregister()
> >       [media] usb: check media device errors
> >       [media] move documentation to the header files
> >       [media] DocBook: document media_entity_graph_walk_cleanup()
> >       [media] media-entity.h fix documentation for several parameters
> >       [media] media-device.h: use just one u32 counter for object ID
> >       [media] media-entity.h: document the remaining functions
> >       [media] media-entity: increase max number of PADs
> >       [media] media-entity: don't sleep at media_device_register_entity()
> >       [media] uapi/media.h: Use u32 for the number of graph objects
> >       [media] call media_device_init() before registering the V4L2 device
> >       [media] dvbdev: remove two dead functions if
> > !CONFIG_MEDIA_CONTROLLER_DVB [media] dvbdev: Add RF connector if needed
> >       [media] dvb-usb-v2: postpone removal of media_device
> >       [media] media-entitiy: add a function to create multiple links
> >       [media] dvbdev: create links on devices with multiple frontends
> >       [media] mxl111sf: Add a tuner entity
> >       [media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY
> > 
> > Rafael Lourenço de Lima Chehab (1):
> >       [media] au0828: Add support for media controller
> > 
> > Sakari Ailus (23):
> >       [media] media: Enforce single entity->pipe in a pipeline
> >       [media] v4l2-device: Register entity before calling subdev's
> > registered ops [media] media: Introduce internal index for media entities
> >       [media] media: Add an API to manage entity enumerations
> >       [media] media: Move struct media_entity_graph definition up
> >       [media] media: Add KernelDoc documentation for struct
> > media_entity_graph
> >       [media] media: Move media graph state for streamon/off to the pipeline
> >       [media] media: Amend media graph walk API by init and cleanup
> > functions
> >       [media] media: Use the new media graph walk interface
> >       [media] v4l: omap3isp: Use the new media graph walk interface
> >       [media] v4l: exynos4-is: Use the new media graph walk interface
> >       [media] v4l: xilinx: Use the new media graph walk interface
> >       [media] v4l: vsp1: Use the new media graph walk interface
> >       [media] media: Use entity enums in graph walk
> >       [media] media: Keep using the same graph walk object for a given
> > pipeline
> >       [media] v4l: omap3isp: Use media entity enumeration interface
> >       [media] v4l: vsp1: Use media entity enumeration interface
> >       [media] staging: v4l: omap4iss: Fix sub-device power management code
> >       [media] staging: v4l: omap4iss: Use media entity enumeration interface
> >       [media] staging: v4l: omap4iss: Use the new media graph walk interface
> >       [media] staging: v4l: davinci_vpbe: Use the new media graph walk
> > interface
> >       [media] media: Remove pre-allocated entity enumeration bitmap
> >       [media] media: Move MEDIA_ENTITY_MAX_PADS from media-entity.h to
> > media-entity.c
> > 
> > Shuah Khan (2):
> >       [media] media: new media controller API for device resource support
> >       [media] media: define Media Controller API when
> > CONFIG_MEDIA_CONTROLLER enabled
> > 
> >  Documentation/DocBook/device-drivers.tmpl          |   1 +
> >  .../DocBook/media/v4l/media-controller.xml         |  44 +-
> >  .../DocBook/media/v4l/media-ioc-enum-entities.xml  | 104 +--
> >  .../DocBook/media/v4l/media-ioc-enum-links.xml     |  56 --
> >  .../DocBook/media/v4l/media-ioc-g-topology.xml     | 394 +++++++++
> >  Documentation/DocBook/media/v4l/media-types.xml    | 240 ++++++
> >  Documentation/media-framework.txt                  | 372 ---------
> >  Documentation/video4linux/v4l2-framework.txt       |  12 +-
> >  Documentation/zh_CN/video4linux/v4l2-framework.txt |   8 +-
> >  drivers/media/Kconfig                              |   1 -
> >  drivers/media/common/siano/smsdvb-main.c           |   7 +-
> >  drivers/media/dvb-core/dmxdev.c                    |   4 +-
> >  drivers/media/dvb-core/dvb_ca_en50221.c            |   2 +-
> >  drivers/media/dvb-core/dvb_frontend.c              |  11 +-
> >  drivers/media/dvb-core/dvb_net.c                   |   2 +-
> >  drivers/media/dvb-core/dvbdev.c                    | 488 +++++++++--
> >  drivers/media/dvb-core/dvbdev.h                    |  58 +-
> >  drivers/media/dvb-frontends/au8522_decoder.c       |  17 +
> >  drivers/media/dvb-frontends/au8522_priv.h          |  12 +
> >  drivers/media/firewire/firedtv-ci.c                |   2 +-
> >  drivers/media/i2c/ad9389b.c                        |   2 +-
> >  drivers/media/i2c/adp1653.c                        |   4 +-
> >  drivers/media/i2c/adv7180.c                        |   4 +-
> >  drivers/media/i2c/adv7511.c                        |   2 +-
> >  drivers/media/i2c/adv7604.c                        |   4 +-
> >  drivers/media/i2c/adv7842.c                        |   2 +-
> >  drivers/media/i2c/as3645a.c                        |   4 +-
> >  drivers/media/i2c/cx25840/cx25840-core.c           |   6 +-
> >  drivers/media/i2c/lm3560.c                         |   4 +-
> >  drivers/media/i2c/lm3646.c                         |   4 +-
> >  drivers/media/i2c/m5mols/m5mols_core.c             |   4 +-
> >  drivers/media/i2c/mt9m032.c                        |   2 +-
> >  drivers/media/i2c/mt9p031.c                        |   2 +-
> >  drivers/media/i2c/mt9t001.c                        |   2 +-
> >  drivers/media/i2c/mt9v032.c                        |   2 +-
> >  drivers/media/i2c/noon010pc30.c                    |   4 +-
> >  drivers/media/i2c/ov2659.c                         |   4 +-
> >  drivers/media/i2c/ov9650.c                         |   4 +-
> >  drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  16 +-
> >  drivers/media/i2c/s5k4ecgx.c                       |   4 +-
> >  drivers/media/i2c/s5k5baf.c                        |  12 +-
> >  drivers/media/i2c/s5k6a3.c                         |   2 +-
> >  drivers/media/i2c/s5k6aa.c                         |   4 +-
> >  drivers/media/i2c/smiapp/smiapp-core.c             |  32 +-
> >  drivers/media/i2c/tc358743.c                       |   2 +-
> >  drivers/media/i2c/tvp514x.c                        |   4 +-
> >  drivers/media/i2c/tvp7002.c                        |   4 +-
> >  drivers/media/media-device.c                       | 441 ++++++++--
> >  drivers/media/media-devnode.c                      |  24 -
> >  drivers/media/media-entity.c                       | 724 +++++++++++------
> >  drivers/media/pci/bt8xx/dst_ca.c                   |   3 +-
> >  drivers/media/pci/ddbridge/ddbridge-core.c         |   2 +-
> >  drivers/media/pci/ngene/ngene-core.c               |   2 +-
> >  drivers/media/pci/ttpci/av7110.c                   |   2 +-
> >  drivers/media/pci/ttpci/av7110_av.c                |   4 +-
> >  drivers/media/pci/ttpci/av7110_ca.c                |   2 +-
> >  drivers/media/platform/exynos4-is/common.c         |   3 +-
> >  drivers/media/platform/exynos4-is/fimc-capture.c   |  11 +-
> >  drivers/media/platform/exynos4-is/fimc-isp-video.c |  11 +-
> >  drivers/media/platform/exynos4-is/fimc-isp.c       |   4 +-
> >  drivers/media/platform/exynos4-is/fimc-lite.c      |  24 +-
> >  drivers/media/platform/exynos4-is/fimc-m2m.c       |   2 +-
> >  drivers/media/platform/exynos4-is/media-dev.c      |  73 +-
> >  drivers/media/platform/exynos4-is/media-dev.h      |   9 +-
> >  drivers/media/platform/exynos4-is/mipi-csis.c      |   4 +-
> >  drivers/media/platform/omap3isp/isp.c              | 306 ++++---
> >  drivers/media/platform/omap3isp/isp.h              |   9 +-
> >  drivers/media/platform/omap3isp/ispccdc.c          |  31 +-
> >  drivers/media/platform/omap3isp/ispccp2.c          |  27 +-
> >  drivers/media/platform/omap3isp/ispcsi2.c          |  21 +-
> >  drivers/media/platform/omap3isp/isppreview.c       |  30 +-
> >  drivers/media/platform/omap3isp/ispresizer.c       |  28 +-
> >  drivers/media/platform/omap3isp/ispstat.c          |   2 +-
> >  drivers/media/platform/omap3isp/ispvideo.c         |  49 +-
> >  drivers/media/platform/omap3isp/ispvideo.h         |   5 +-
> >  drivers/media/platform/s3c-camif/camif-capture.c   |   8 +-
> >  drivers/media/platform/s3c-camif/camif-core.c      |  21 +-
> >  drivers/media/platform/vsp1/vsp1_drv.c             |  50 +-
> >  drivers/media/platform/vsp1/vsp1_entity.c          |   4 +-
> >  drivers/media/platform/vsp1/vsp1_rpf.c             |  29 +-
> >  drivers/media/platform/vsp1/vsp1_rwpf.h            |   5 +
> >  drivers/media/platform/vsp1/vsp1_video.c           |  64 +-
> >  drivers/media/platform/vsp1/vsp1_wpf.c             |  40 +-
> >  drivers/media/platform/xilinx/xilinx-dma.c         |  21 +-
> >  drivers/media/platform/xilinx/xilinx-tpg.c         |   2 +-
> >  drivers/media/platform/xilinx/xilinx-vipp.c        |  16 +-
> >  drivers/media/usb/au0828/au0828-cards.c            |   4 +
> >  drivers/media/usb/au0828/au0828-core.c             | 171 ++++
> >  drivers/media/usb/au0828/au0828-dvb.c              |  12 +
> >  drivers/media/usb/au0828/au0828-video.c            | 126 +++
> >  drivers/media/usb/au0828/au0828.h                  |  10 +-
> >  drivers/media/usb/cx231xx/cx231xx-cards.c          |  81 +-
> >  drivers/media/usb/cx231xx/cx231xx-dvb.c            |   6 +-
> >  drivers/media/usb/cx231xx/cx231xx-video.c          |  14 +-
> >  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |  42 +-
> >  drivers/media/usb/dvb-usb-v2/mxl111sf.c            |  20 +
> >  drivers/media/usb/dvb-usb-v2/mxl111sf.h            |   5 +
> >  drivers/media/usb/dvb-usb/dvb-usb-dvb.c            |  43 +-
> >  drivers/media/usb/siano/smsusb.c                   |   5 +-
> >  drivers/media/usb/uvc/uvc_driver.c                 |  11 +-
> >  drivers/media/usb/uvc/uvc_entity.c                 |  38 +-
> >  drivers/media/v4l2-core/tuner-core.c               |  10 +-
> >  drivers/media/v4l2-core/v4l2-dev.c                 | 111 ++-
> >  drivers/media/v4l2-core/v4l2-device.c              |  39 +-
> >  drivers/media/v4l2-core/v4l2-flash-led-class.c     |   4 +-
> >  drivers/media/v4l2-core/v4l2-subdev.c              |   8 +-
> >  drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  11 +-
> >  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  17 +-
> >  drivers/staging/media/davinci_vpfe/dm365_isif.c    |  17 +-
> >  drivers/staging/media/davinci_vpfe/dm365_resizer.c |  39 +-
> >  .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  10 +-
> >  drivers/staging/media/davinci_vpfe/vpfe_video.c    |  58 +-
> >  drivers/staging/media/davinci_vpfe/vpfe_video.h    |   1 +
> >  drivers/staging/media/omap4iss/iss.c               | 199 +++--
> >  drivers/staging/media/omap4iss/iss.h               |   8 +-
> >  drivers/staging/media/omap4iss/iss_csi2.c          |  48 +-
> >  drivers/staging/media/omap4iss/iss_csi2.h          |   1 +
> >  drivers/staging/media/omap4iss/iss_ipipe.c         |  11 +-
> >  drivers/staging/media/omap4iss/iss_ipipeif.c       |  44 +-
> >  drivers/staging/media/omap4iss/iss_ipipeif.h       |   1 +
> >  drivers/staging/media/omap4iss/iss_resizer.c       |  42 +-
> >  drivers/staging/media/omap4iss/iss_resizer.h       |   1 +
> >  drivers/staging/media/omap4iss/iss_video.c         |  61 +-
> >  drivers/staging/media/omap4iss/iss_video.h         |   5 +-
> >  include/media/media-device.h                       | 469 ++++++++++-
> >  include/media/media-devnode.h                      |  54 +-
> >  include/media/media-entity.h                       | 904 ++++++++++++++++--
> >  include/media/tuner.h                              |   8 +
> >  include/media/v4l2-dev.h                           |   1 +
> >  include/uapi/linux/media.h                         | 228 +++++-
> >  130 files changed, 5237 insertions(+), 1849 deletions(-)
> >  create mode 100644 Documentation/DocBook/media/v4l/media-ioc-g-topology.xml
> > create mode 100644 Documentation/DocBook/media/v4l/media-types.xml delete
> > mode 100644 Documentation/media-framework.txt  
> 

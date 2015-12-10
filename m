Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60676 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248AbbLJUeR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 15:34:17 -0500
Date: Thu, 10 Dec 2015 18:34:11 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuah.kh@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Media Controller patches
Message-ID: <20151210183411.3d15a819@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been working during this week to address the issues pointed during
the Media Controller really long review process. We should avoid taking
so long to review patches in the future, as it is really painful to
go back to the already done work 4/5/7 months after the patchsets
(yes, there are patches here written 7 months ago that were only
very recently reviewed!). Shame on us.

Anyway, The reviewed patches are now at the media-controller topic
branch, at the main tree.

I took the care of recompiling and automatically doing runtime tests
with KASAN enabled, patch by patch, in order to be sure that the
MC is in a sane state. I also ran kmemleak, and was unable to identify
any troubles associated with the MC next gen rework.

So, the media-controller topic branch looks sane to me. It should be
noticed that there are several items on a TODO list to be addressed
before being able to merge this branch back at the master branch.

Please notice that patch 22 was removed from this series:
	Subject: [media] uapi/media.h: Declare interface types for ALSA

The idea is that this patch should be part of the patches that Shuah
will submit and that requires review from the ALSA community before
being merged.

Javier and me will start tomorrow on working on the pending items.

My goal is to have everything needed for Kernel 4.5 merge window
done up to the next week.

---

The current TODO list, based on the per-patch review is:

=================================================

PER_PATCH TODO list
===================

media: create a macro to get entity ID:

  Sailus:

    media-entity.h is a pretty widely included header file. Perhaps we should think about the naming a bit.

    All the other names in the header begin with media (or __media); I'd very much prefer not changing that pattern.


media: add a common struct to be embed on media graph objects:
  Sailus: 
     > > +struct media_gobj {
     > > +        u32                        id;
     > > +};
     > > +
     > > +  
     > 
     > Two newlines. Looks like one would be enough. A minor matter though.  
    Ok, I'll be dropping the extra line.

media: use media_gobj inside pads:
  Sailus:
    >  int __must_check media_device_register_entity(struct media_device *mdev,
    >                                                struct media_entity *entity)
    >  {
    > +        int i;  

    unsigned int?
    
    >  void media_device_unregister_entity(struct media_entity *entity)
    >  {
    > +        int i;  

    Ditto. It'd be nice to declare short temporary and counter variables as
    last (i.e. after mdev).
    
uapi/media.h: Declare interface types for ALSA:
    Add it to ALSA patch series and send it for ALSA people to review
    
omap3isp: separate links creation from entities init:
    Laurent:
        See his comments about this patch. Several minor issues to be addressed - mostly on comments
        
media] omap3isp: create links after all subdevs have been bound
    Laurent:
       We need to properly think about 
       initialization (and, for that matter, cleanup as well) order, both for the 
       media device and the entities. And, as a corollary, for subdevs too. The 
       current media entity and subdevs initialization and registration code grew in 
       an organic way without much design behind it, let's not repeat the same 
       mistake.

staging: omap4iss: separate links creation from entities init
  Laurent:
    > +/*
    > + * iss_create_pads_links() - Pads links creation for the subdevices  
    Could you please s/pads_links/links/ and s/pads links/links/ ?
    
v4l: vsp1: separate links creation from entities init:
  Laurent:
    > -                if (entity->type == VSP1_ENTITY_LIF ||
    > -                    entity->type == VSP1_ENTITY_RPF)
    > +                if (entity->type == VSP1_ENTITY_LIF) {
    > +                        ret = vsp1_wpf_create_pads_links(vsp1, entity);  
    Could you please s/pads_links/links/ ? There's no other type of links handled 
    by the driver.
    > +                        if (ret < 0)
    > +                                goto done;
    > +                        continue;  
    I would use
            } else if (...) {
    instead of a continue.
    > +                }
    > +
    > +                if (entity->type == VSP1_ENTITY_RPF) {
    > +                        ret = vsp1_rpf_create_pads_links(vsp1, entity);
    > +                        if (ret < 0)
    > +                                goto done;
    >                          continue;  
    Same here.
    
    uvcvideo: create pad links after subdev registration:

uvcvideo: create pad links after subdev registration:

Laurent:
     > +       list_for_each_entry(entity, &chain->entities, chain) {

    > +               ret = uvc_mc_create_pads_links(chain, entity);  


    You can call this uvc_mc_create_links(), there's no other type of links in the 

    driver.


    > +               if (ret < 0) {

    > +                       uvc_printk(KERN_INFO, "Failed to create pads links

    > for "  


    Same here, I'd s/pad links/links/.


    > +                                  "entity %u\n", entity->id);

    > +                       return ret;

    > +               }

    > +       }  


    This creates three loops, and I think that's one too much. The reason why init 

    and register are separate is that the latter creates links, which requires all 

    entities to be initialized. If you move link create after registration I 

    believe you can init and register in a single loop (just move the 

    v4l2_device_register_subdev() call in the appropriate location in 

    uvc_mc_init_entity()) and then create links in a second loop.


media: Don't accept early-created links
  Laurent:

    > +++ b/drivers/media/media-entity.c

    > @@ -161,6 +161,8 @@ void media_gobj_init(struct media_device *mdev,

    >                             enum media_gobj_type type,

    >                             struct media_gobj *gobj)

    >  {

    > +        BUG_ON(!mdev);

    > +  


    Please use a WARN_ON() and return (and possibly make the function return an 

    int error code), we don't want to panic completely for this.


media: convert links from array to list:
    Laurent made several comments on this one. Please see the ML.
    
media: add support to link interfaces and entities
  Sailus: rename media_obj functions to *_create *_destroy

omap3/omap4/davinci: get rid of MEDIA_ENT_T_V4L2_SUBDEV abuse
  Laurent:
    - Replace int by unsigned int on "index";
    - Do a non-hacking version of the pad/subdev switch logic.

v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs:
    - Some minor changes - mostly on comments
    - Should address on a later series the changes to remove MEDIA_ENT_T_SUBDEV_UNKNOWN
    
uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY ioctl:
    Laurent added to address some issues - discussion needed
    
media: Use a macro to interate between all interfaces
   Laurent:
          - Remove one blank line at media-device.h
          
media_device: add a topology version field:
    Laurent:

         - Zero topology version at media_device_register()


media-device: add support for MEDIA_IOC_G_TOPOLOGY ioctl:
    Hans:
         - Fix media_device_compat_ioctl()
         - move MEDIA_LNK_FL_INTERFACE_LINK to link creation code
         
media-entity: unregister entity links:
    Laurent:
           - Kerneldoc: add media_remove_intf_links()
           
media: don't try to empty links list in media_entity_cleanup()

    Laurent:

    - Does this mean that it's an invalid usage of the API to create links before 

    registering entities ? If so it should be clearly documented somewhere, such 

    as in the kerneldoc of the media_create_pad_link() function.


    - All exported API functions need kerneldoc.


    - media_entity_cleanup is now empty I'd turn it into a static inline.


v4l2-core: create MC interfaces for devnodes:
    Hans:
         - Make macro names more consistent:
               > +                intf_type = MEDIA_INTF_T_V4L_VIDEO;

    > +                vdev->entity.type = MEDIA_ENT_T_V4L2_VIDEO;

    > +                break;  


    I think I mentioned it before: V4L vs V4L2 in the macro names is inconsistent.

    I would suggest using V4L2 as well in MEDIA_INTF_. It looks really weird and

    arbitrary here.


tuner-core: add an input pad:
    Laurent:
        Additionally it should be documented somewhere that drivers instantiating 

       tuners are responsible for creating and linking a connector to the tuner 

       input.


media-entity.h: document all the structs:
    Laurent:

    > > + * @major:        Devnode major number (zero if not applicable). Kept just

    > 

    > Maybe s/@major/@dev.major/ (and the same for minor) ?


    I don't think it works. The kernel-doc script is not smart enough to

    handle this kind of things.


    > 

    > > + *                 for backward compatibility.

    > > + * @minor:        Devnode minor number (zero if not applicable). Kept just

    > > + *                 for backward compatibility.

    > 

    > As this is an internal structure I think we should clean code up sooner than 

    > later and remove the major and minor fields. It will be confusing for driver 

    > authors otherwise. Same for the revision and group_id fields.


media.h: create connector entities for hybrid TV devices:

        Laurent:

    > When later renaming types to functions you rename this type as well, and I'm 

    > still not convinced that we shouldn't have both types and functions.

    > Let's discuss these topics and the one below on the documentation patches.


media-entity: init pads on entity init if was registered:
        See the discussion at the ML. Basically, warnings should be added if the driver is not doing it on the expected way.


=================================================


And those are the remaining items that may or may not have been
already addressed, or pointed above:


TODO for next Kernel version  (goal: Kernel version 4.5):
=========================================================

- Find entities that belong to V4L2 or DVB via the interfaces,   in order to enable/disable the inteface links when the device   gets busy (Probably, Shuah's patches did this already);

media controller kernel interface:
    Rename interfaces so that the naming of the constructor and destructor match, i.e. media_create_intf_link / media_remove_intf_link is a mismatch.
    Think a bit what's in which header and whether the current hader naming still makes sense.
    

media controller user space API:
    G_TOPOLOGY IOCTL argument struct reserved fields need rework

omap3isp:
    Clean up isp_subdev_notifier_complete()
    
Apply Sakari's patch series that remove the graph traversal entity ID range dependency of the entity ID

Merge IDs for entity, interface, links into a single one

Rename the generic MEDIA_ENT_F_IO to MEDIA_ENT_F_IO_function, where function is "VIDEO", "VBI", "DVB", etc...

Turn media_entity_cleanup() into a static inline now that is an empty function.

Document that links can't be created before entities are registered with the media device.  In fact document any
constraints that may exist so drivers authors know when things have to be initialized and registered.

Update documentation to not mention that links are stored in an array.

Make sure that all exported API functions have a proper kerneldoc.

Sort all headers alphabetically

Rename all create_pads_links functions to just create_links if there is no other type of link in the driver.

Simplify uvc_mc_register_entities() to avoid having 3 loops by init and registering in the same loop.

Use "else if" instead of continue in vsp1_create_entities() loop that create links.

Revising locking

Add documentation for the uAPI.

TODO for ALSA
============

Merge Shuah patch series after being reviewed by Media and ALSA people

TODO for a next versions:
=========================

- Remove unused fields from media_entity (like major, minor, revision,  group_id, num_links, num_backlinks, num_pads)

- dynamic entity/interface/link creation and removal;

- SETUP_LINK_V2 with dynamic support;

- dynamic pad creation and removal (needed?);

- multiple function per entity support;

- indirect interface links support;

- MC properties API.

Userspace:
==========

- Create a library with v2 API;

- Use the v2 API library on qv4l2/libdvbv5/xawtv/libv4l;

- Add the libudev/libsysfs logic at mc_nextgen_test to convert  a devnode major/minor into a /dev/* name;

Other Nice things
=================

- Rename media_entity_init() to media_entity_create_pads() 
- Rename media_graph_init() to media_graph_register()


=====================================================

The diffstat when compared with the branch devel/mc_next_gen.v8.4-rebased_v2
from my experimental tree follows.

Updating 90d1f0a4cc49..fc6740cbdd99
Fast-forward
 Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml |  81 +++++++++++++---------
 Documentation/media-framework.txt                           |   2 +-
 Documentation/video4linux/v4l2-framework.txt                |   4 +-
 drivers/media/common/siano/smsdvb-main.c                    |   6 +-
 drivers/media/dvb-core/dmxdev.c                             |   4 +-
 drivers/media/dvb-core/dvb_ca_en50221.c                     |   2 +-
 drivers/media/dvb-core/dvb_frontend.c                       |  11 ++-
 drivers/media/dvb-core/dvb_net.c                            |   2 +-
 drivers/media/dvb-core/dvbdev.c                             | 412 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
 drivers/media/dvb-core/dvbdev.h                             |  17 +++--
 drivers/media/dvb-frontends/au8522_decoder.c                |   2 +-
 drivers/media/firewire/firedtv-ci.c                         |   2 +-
 drivers/media/i2c/adp1653.c                                 |   2 +-
 drivers/media/i2c/adv7180.c                                 |   2 +-
 drivers/media/i2c/as3645a.c                                 |   2 +-
 drivers/media/i2c/cx25840/cx25840-core.c                    |   2 +-
 drivers/media/i2c/lm3560.c                                  |   2 +-
 drivers/media/i2c/lm3646.c                                  |   2 +-
 drivers/media/i2c/m5mols/m5mols_core.c                      |   2 +-
 drivers/media/i2c/noon010pc30.c                             |   2 +-
 drivers/media/i2c/ov2659.c                                  |   2 +-
 drivers/media/i2c/ov9650.c                                  |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c                    |   8 +--
 drivers/media/i2c/s5k4ecgx.c                                |   2 +-
 drivers/media/i2c/s5k5baf.c                                 |   8 +--
 drivers/media/i2c/s5k6aa.c                                  |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c                      |  22 +++---
 drivers/media/i2c/tvp514x.c                                 |   2 +-
 drivers/media/i2c/tvp7002.c                                 |   2 +-
 drivers/media/media-device.c                                | 265 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/media/media-entity.c                                | 462 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 drivers/media/pci/bt8xx/dst_ca.c                            |   3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c                  |   2 +-
 drivers/media/pci/ngene/ngene-core.c                        |   2 +-
 drivers/media/pci/ttpci/av7110.c                            |   2 +-
 drivers/media/pci/ttpci/av7110_av.c                         |   4 +-
 drivers/media/pci/ttpci/av7110_ca.c                         |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c          |   9 ++-
 drivers/media/platform/exynos4-is/fimc-lite.c               |  18 +++--
 drivers/media/platform/exynos4-is/media-dev.c               |  25 ++++---
 drivers/media/platform/exynos4-is/media-dev.h               |   8 +--
 drivers/media/platform/omap3isp/isp.c                       | 202 +++++++++++++++++++++++++++++++++--------------------
 drivers/media/platform/omap3isp/ispccdc.c                   |  39 +++++++----
 drivers/media/platform/omap3isp/ispccdc.h                   |   1 +
 drivers/media/platform/omap3isp/ispccp2.c                   |  35 ++++++----
 drivers/media/platform/omap3isp/ispccp2.h                   |   1 +
 drivers/media/platform/omap3isp/ispcsi2.c                   |  33 ++++++---
 drivers/media/platform/omap3isp/ispcsi2.h                   |   1 +
 drivers/media/platform/omap3isp/isppreview.c                |  48 ++++++++-----
 drivers/media/platform/omap3isp/isppreview.h                |   1 +
 drivers/media/platform/omap3isp/ispresizer.c                |  46 ++++++++-----
 drivers/media/platform/omap3isp/ispresizer.h                |   1 +
 drivers/media/platform/omap3isp/ispvideo.c                  |  17 ++---
 drivers/media/platform/s3c-camif/camif-capture.c            |   2 +-
 drivers/media/platform/s3c-camif/camif-core.c               |   4 +-
 drivers/media/platform/vsp1/vsp1_drv.c                      |  34 +++++----
 drivers/media/platform/vsp1/vsp1_rpf.c                      |  29 +++++---
 drivers/media/platform/vsp1/vsp1_rwpf.h                     |   5 ++
 drivers/media/platform/vsp1/vsp1_video.c                    |  15 ++--
 drivers/media/platform/vsp1/vsp1_wpf.c                      |  40 +++++++----
 drivers/media/platform/xilinx/xilinx-dma.c                  |  10 ++-
 drivers/media/platform/xilinx/xilinx-vipp.c                 |   4 +-
 drivers/media/usb/au0828/au0828-core.c                      | 100 ++++++++++++++++++++++-----
 drivers/media/usb/au0828/au0828-dvb.c                       |   8 ++-
 drivers/media/usb/au0828/au0828-video.c                     |  84 ++++++++++++++++++-----
 drivers/media/usb/au0828/au0828.h                           |   3 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c                   |  46 ++++++++-----
 drivers/media/usb/cx231xx/cx231xx-dvb.c                     |   6 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                   |  10 ++-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c                 |   4 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c                     |   6 +-
 drivers/media/usb/uvc/uvc_entity.c                          |  25 +++++--
 drivers/media/v4l2-core/tuner-core.c                        |  10 +--
 drivers/media/v4l2-core/v4l2-dev.c                          | 111 +++++++++++++++++++++++++-----
 drivers/media/v4l2-core/v4l2-device.c                       |  16 ++++-
 drivers/media/v4l2-core/v4l2-flash-led-class.c              |   2 +-
 drivers/media/v4l2-core/v4l2-subdev.c                       |   8 +--
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c            |   9 ++-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c          |  15 ++--
 drivers/staging/media/davinci_vpfe/dm365_isif.c             |  15 ++--
 drivers/staging/media/davinci_vpfe/dm365_resizer.c          |  33 +++++----
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c        |  10 +--
 drivers/staging/media/davinci_vpfe/vpfe_video.c             |  17 +++--
 drivers/staging/media/omap4iss/iss.c                        | 123 +++++++++++++++++++++------------
 drivers/staging/media/omap4iss/iss_csi2.c                   |  46 ++++++++++---
 drivers/staging/media/omap4iss/iss_csi2.h                   |   1 +
 drivers/staging/media/omap4iss/iss_ipipe.c                  |   9 ++-
 drivers/staging/media/omap4iss/iss_ipipeif.c                |  42 +++++++-----
 drivers/staging/media/omap4iss/iss_ipipeif.h                |   1 +
 drivers/staging/media/omap4iss/iss_resizer.c                |  40 +++++++----
 drivers/staging/media/omap4iss/iss_resizer.h                |   1 +
 drivers/staging/media/omap4iss/iss_video.c                  |   9 ++-
 include/media/media-device.h                                |  36 +++++++++-
 include/media/media-entity.h                                | 314 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------
 include/media/tuner.h                                       |   8 +++
 include/media/v4l2-dev.h                                    |   1 +
 include/uapi/linux/media.h                                  | 213 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 99 files changed, 2539 insertions(+), 832 deletions(-)



diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index f9bfe8094d6d..27f8817e7abe 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -184,10 +184,22 @@
 	    a driver didn't initialize properly the entity, with is a Kernel bug</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_F_IO</constant></entry>
+	    <entry><constant>MEDIA_ENT_F_IO_V4L</constant></entry>
 	    <entry>Data streaming input and/or output entity.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>MEDIA_ENT_F_IO_VBI</constant></entry>
+	    <entry>V4L VBI streaming input or output entity</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_IO_SWRADIO</constant></entry>
+	    <entry>V4L Software Digital Radio (SDR) streaming input or output entity</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_IO_DTV</constant></entry>
+	    <entry>DVB Digital TV streaming input or output entity</entry>
+	  </row>
+	  <row>
 	    <entry><constant>MEDIA_ENT_F_DTV_DEMOD</constant></entry>
 	    <entry>Digital TV demodulator entity.</entry>
 	  </row>
@@ -238,7 +250,7 @@
 	    broadcast, DVD players, cameras and video cassette recorders, in
 	    either NTSC, PAL, SECAM or HD format, separating the stream
 	    into its component parts, luminance and chrominance, and output
-	    it in some digital video standard, with appropriate embedded timing
+	    it in some digital video standard, with appropriate timing
 	    signals.</entry>
 	  </row>
 	  <row>
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 60828a9537a0..1d4e35693d09 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -187,21 +187,32 @@ static void dvb_media_device_free(struct dvb_device *dvbdev)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	if (dvbdev->entity) {
+		media_device_unregister_entity(dvbdev->entity);
+		kfree(dvbdev->entity);
+		kfree(dvbdev->pads);
+		dvbdev->entity = NULL;
+		dvbdev->pads = NULL;
+	}
+
+	if (dvbdev->tsout_entity) {
 		int i;
 
 		for (i = 0; i < dvbdev->tsout_num_entities; i++) {
 			media_device_unregister_entity(&dvbdev->tsout_entity[i]);
 			kfree(dvbdev->tsout_entity[i].name);
 		}
-		media_device_unregister_entity(dvbdev->entity);
-
-		kfree(dvbdev->entity);
-		kfree(dvbdev->pads);
 		kfree(dvbdev->tsout_entity);
 		kfree(dvbdev->tsout_pads);
+		dvbdev->tsout_entity = NULL;
+		dvbdev->tsout_pads = NULL;
+
+		dvbdev->tsout_num_entities = 0;
 	}
-	if (dvbdev->intf_devnode)
+
+	if (dvbdev->intf_devnode) {
 		media_devnode_remove(dvbdev->intf_devnode);
+		dvbdev->intf_devnode = NULL;
+	}
 #endif
 }
 
@@ -221,15 +232,17 @@ static int dvb_create_tsout_entity(struct dvb_device *dvbdev,
 	if (!dvbdev->tsout_entity)
 		return -ENOMEM;
 
+	dvbdev->tsout_num_entities = npads;
+
 	for (i = 0; i < npads; i++) {
 		struct media_pad *pads = &dvbdev->tsout_pads[i];
 		struct media_entity *entity = &dvbdev->tsout_entity[i];
 
 		entity->name = kasprintf(GFP_KERNEL, "%s #%d", name, i);
 		if (!entity->name)
-			return ret;
+			return -ENOMEM;
 
-		entity->function = MEDIA_ENT_F_IO;
+		entity->function = MEDIA_ENT_F_IO_DTV;
 		pads->flags = MEDIA_PAD_FL_SINK;
 
 		ret = media_entity_init(entity, 1, pads);
@@ -307,7 +320,7 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	case DVB_DEVICE_DEMUX:
-		dvbdev->entity->function = MEDIA_ENT_F_MPEG_TS_DEMUX;
+		dvbdev->entity->function = MEDIA_ENT_F_TS_DEMUX;
 		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
 		for (i = 1; i < npads; i++)
 			dvbdev->pads[i].flags = MEDIA_PAD_FL_SOURCE;
@@ -318,9 +331,11 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	default:
+		/* Should never happen, as the first switch prevents it */
 		kfree(dvbdev->entity);
 		kfree(dvbdev->pads);
 		dvbdev->entity = NULL;
+		dvbdev->pads = NULL;
 		return 0;
 	}
 
@@ -422,7 +437,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		return -ENFILE;
 	}
 
-	*pdvbdev = dvbdev = kmalloc(sizeof(struct dvb_device), GFP_KERNEL);
+	*pdvbdev = dvbdev = kzalloc(sizeof(*dvbdev), GFP_KERNEL);
 
 	if (!dvbdev){
 		mutex_unlock(&dvbdev_register_lock);
@@ -471,6 +486,20 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	dvb_minors[minor] = dvbdev;
 	up_write(&minor_rwsem);
 
+	ret = dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
+	if (ret) {
+		printk(KERN_ERR
+		      "%s: dvb_register_media_device failed to create the mediagraph\n",
+		      __func__);
+
+		dvb_media_device_free(dvbdev);
+		kfree(dvbdevfops);
+		kfree(dvbdev);
+		up_write(&minor_rwsem);
+		mutex_unlock(&dvbdev_register_lock);
+		return ret;
+	}
+
 	mutex_unlock(&dvbdev_register_lock);
 
 	clsdev = device_create(dvb_class, adap->device,
@@ -481,17 +510,6 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
 		return PTR_ERR(clsdev);
 	}
-
-	ret = dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
-	if (ret) {
-		printk(KERN_ERR
-		      "%s: dvb_register_media_device failed to create the media graph\n",
-		      __func__);
-
-		dvb_unregister_device(dvbdev);
-		return ret;
-	}
-
 	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
 		adap->num, dnames[type], id, minor, minor);
 
@@ -531,7 +549,7 @@ static int dvb_create_io_intf_links(struct dvb_adapter *adap,
 	struct media_link *link;
 
 	media_device_for_each_entity(entity, mdev) {
-		if (entity->function == MEDIA_ENT_F_IO) {
+		if (entity->function == MEDIA_ENT_F_IO_DTV) {
 			if (strncmp(entity->name, name, strlen(name)))
 				continue;
 			link = media_create_intf_link(entity, intf,
@@ -565,7 +583,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
 		case MEDIA_ENT_F_DTV_DEMOD:
 			demod = entity;
 			break;
-		case MEDIA_ENT_F_MPEG_TS_DEMUX:
+		case MEDIA_ENT_F_TS_DEMUX:
 			demux = entity;
 			break;
 		case MEDIA_ENT_F_DTV_CA:
@@ -597,7 +615,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
 	/* Create demux links for each ringbuffer/pad */
 	if (demux) {
 		media_device_for_each_entity(entity, mdev) {
-			if (entity->function == MEDIA_ENT_F_IO) {
+			if (entity->function == MEDIA_ENT_F_IO_DTV) {
 				if (!strncmp(entity->name, DVR_TSOUT,
 				    strlen(DVR_TSOUT))) {
 					ret = media_create_pad_link(demux,
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 7a68cf055486..3d578f2ce7b2 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1704,7 +1704,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	state->oif_pads[OIF_ISP_PAD].flags = MEDIA_PAD_FL_SINK;
 	state->oif_pads[OIF_JPEG_PAD].flags = MEDIA_PAD_FL_SINK;
 	state->oif_pads[OIF_SOURCE_PAD].flags = MEDIA_PAD_FL_SOURCE;
-	oif_sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	oif_sd->entity.function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
 
 	ret = media_entity_init(&oif_sd->entity, OIF_NUM_PADS,
 							state->oif_pads);
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 3a10e50b3620..564938ab2abd 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1919,7 +1919,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
 
 	state->pads[PAD_CIS].flags = MEDIA_PAD_FL_SINK;
 	state->pads[PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	sd->entity.function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
 	ret = media_entity_init(&sd->entity, NUM_ISP_PADS, state->pads);
 
 	if (!ret)
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1312e93ebd6e..3d0a77c1c899 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -243,8 +243,8 @@ static long __media_device_get_topology(struct media_device *mdev,
 	struct media_v2_interface uintf;
 	struct media_v2_pad upad;
 	struct media_v2_link ulink;
-	int ret = 0;
 	unsigned int i;
+	int ret = 0;
 
 	topo->topology_version = mdev->topology_version;
 
@@ -579,25 +579,21 @@ void media_device_unregister(struct media_device *mdev)
 {
 	struct media_entity *entity;
 	struct media_entity *next;
-	struct media_link *link, *tmp_link;
 	struct media_interface *intf, *tmp_intf;
 
-	/* Remove interface links from the media device */
-	list_for_each_entry_safe(link, tmp_link, &mdev->links,
-				 graph_obj.list) {
-		media_gobj_remove(&link->graph_obj);
-		kfree(link);
-	}
+	/* Remove all entities from the media device */
+	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
+		media_device_unregister_entity(entity);
 
 	/* Remove all interfaces from the media device */
+	spin_lock(&mdev->lock);
 	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
 				 graph_obj.list) {
+		__media_remove_intf_links(intf);
 		media_gobj_remove(&intf->graph_obj);
 		kfree(intf);
 	}
-
-	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
-		media_device_unregister_entity(entity);
+	spin_unlock(&mdev->lock);
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	media_devnode_unregister(&mdev->devnode);
@@ -653,6 +649,7 @@ void media_device_unregister_entity(struct media_entity *entity)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_link *link, *tmp;
+	struct media_interface *intf;
 	unsigned int i;
 
 	if (mdev == NULL)
@@ -660,20 +657,16 @@ void media_device_unregister_entity(struct media_entity *entity)
 
 	spin_lock(&mdev->lock);
 
-	/* Remove interface links with this entity on it */
-	list_for_each_entry_safe(link, tmp, &mdev->links, graph_obj.list) {
-		if (media_type(link->gobj1) == MEDIA_GRAPH_ENTITY
-		    && link->entity == entity) {
-			media_gobj_remove(&link->graph_obj);
-			kfree(link);
+	/* Remove all interface links pointing to this entity */
+	list_for_each_entry(intf, &mdev->interfaces, graph_obj.list) {
+		list_for_each_entry_safe(link, tmp, &intf->links, list) {
+			if (link->entity == entity)
+				__media_remove_intf_link(link);
 		}
 	}
 
 	/* Remove all data links that belong to this entity */
-	list_for_each_entry_safe(link, tmp, &entity->links, list) {
-		media_gobj_remove(&link->graph_obj);
-		kfree(link);
-	}
+	__media_entity_remove_links(entity);
 
 	/* Remove all pads that belong to this entity */
 	for (i = 0; i < entity->num_pads; i++)
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 064020ddac94..07f2dc6c2df6 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -74,18 +74,6 @@ static inline const char *intf_type(struct media_interface *intf)
 		return "v4l2-subdev";
 	case MEDIA_INTF_T_V4L_SWRADIO:
 		return "swradio";
-	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
-		return "pcm-capture";
-	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
-		return "pcm-playback";
-	case MEDIA_INTF_T_ALSA_CONTROL:
-		return "alsa-control";
-	case MEDIA_INTF_T_ALSA_COMPRESS:
-		return "compress";
-	case MEDIA_INTF_T_ALSA_RAWMIDI:
-		return "rawmidi";
-	case MEDIA_INTF_T_ALSA_HWDEP:
-		return "hwdep";
 	default:
 		return "unknown-intf";
 	}
@@ -206,10 +194,6 @@ void media_gobj_remove(struct media_gobj *gobj)
 
 	/* Remove the object from mdev list */
 	list_del(&gobj->list);
-
-	/* Links have their own list - we need to drop them there too */
-	if (media_type(gobj) == MEDIA_GRAPH_LINK)
-		list_del(&gobj_to_link(gobj)->list);
 }
 
 /**
@@ -689,14 +673,16 @@ static void __media_entity_remove_link(struct media_entity *entity,
 		if (link->source->entity == entity)
 			remote->num_backlinks--;
 
-		if (--remote->num_links == 0)
-			break;
-
 		/* Remove the remote link */
 		list_del(&rlink->list);
+		media_gobj_remove(&rlink->graph_obj);
 		kfree(rlink);
+
+		if (--remote->num_links == 0)
+			break;
 	}
 	list_del(&link->list);
+	media_gobj_remove(&link->graph_obj);
 	kfree(link);
 }
 
@@ -718,9 +704,9 @@ void media_entity_remove_links(struct media_entity *entity)
 	if (entity->graph_obj.mdev == NULL)
 		return;
 
-	mutex_lock(&entity->graph_obj.mdev->graph_mutex);
+	spin_lock(&entity->graph_obj.mdev->lock);
 	__media_entity_remove_links(entity);
-	mutex_unlock(&entity->graph_obj.mdev->graph_mutex);
+	spin_unlock(&entity->graph_obj.mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_entity_remove_links);
 
@@ -810,9 +796,9 @@ int media_entity_setup_link(struct media_link *link, u32 flags)
 {
 	int ret;
 
-	mutex_lock(&link->source->entity->graph_obj.mdev->graph_mutex);
+	spin_lock(&link->source->entity->graph_obj.mdev->lock);
 	ret = __media_entity_setup_link(link, flags);
-	mutex_unlock(&link->source->entity->graph_obj.mdev->graph_mutex);
+	spin_unlock(&link->source->entity->graph_obj.mdev->lock);
 
 	return ret;
 }
@@ -939,17 +925,19 @@ struct media_link *media_create_intf_link(struct media_entity *entity,
 EXPORT_SYMBOL_GPL(media_create_intf_link);
 
 
-static void __media_remove_intf_link(struct media_link *link)
+void __media_remove_intf_link(struct media_link *link)
 {
+	list_del(&link->list);
 	media_gobj_remove(&link->graph_obj);
 	kfree(link);
 }
+EXPORT_SYMBOL_GPL(__media_remove_intf_link);
 
 void media_remove_intf_link(struct media_link *link)
 {
-	mutex_lock(&link->graph_obj.mdev->graph_mutex);
+	spin_lock(&link->graph_obj.mdev->lock);
 	__media_remove_intf_link(link);
-	mutex_unlock(&link->graph_obj.mdev->graph_mutex);
+	spin_unlock(&link->graph_obj.mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_link);
 
@@ -969,8 +957,8 @@ void media_remove_intf_links(struct media_interface *intf)
 	if (intf->graph_obj.mdev == NULL)
 		return;
 
-	mutex_lock(&intf->graph_obj.mdev->graph_mutex);
+	spin_lock(&intf->graph_obj.mdev->lock);
 	__media_remove_intf_links(intf);
-	mutex_unlock(&intf->graph_obj.mdev->graph_mutex);
+	spin_unlock(&intf->graph_obj.mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_links);
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index b4697519201d..06eb74344507 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -191,7 +191,7 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		struct xvip_dma *dma;
 
-		if (entity->function != MEDIA_ENT_F_IO)
+		if (entity->function != MEDIA_ENT_F_IO_V4L)
 			continue;
 
 		dma = to_xvip_dma(media_entity_to_video_device(entity));
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 71f3a9587825..1b207fa16a55 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -206,11 +206,13 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 		au0828_analog_unregister(dev);
 		v4l2_device_disconnect(&dev->v4l2_dev);
 		v4l2_device_put(&dev->v4l2_dev);
+		/*
+		 * No need to call au0828_usb_release() if V4L2 is enabled,
+		 * as this is already called via au0828_usb_v4l2_release()
+		 */
 		return;
 	}
 #endif
-	au0828_unregister_media_device(dev);
-
 	au0828_usb_release(dev);
 }
 
@@ -301,7 +303,7 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
 			break;
 
-		switch(AUVI_INPUT(i).type) {
+		switch (AUVI_INPUT(i).type) {
 		case AU0828_VMUX_CABLE:
 		case AU0828_VMUX_TELEVISION:
 		case AU0828_VMUX_DVB:
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 637e369c87d9..150824fe382a 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1802,7 +1802,7 @@ static int au0828_vb2_setup(struct au0828_dev *dev)
 static void au0828_analog_create_entities(struct au0828_dev *dev)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	static const char *inames[] = {
+	static const char * const inames[] = {
 		[AU0828_VMUX_COMPOSITE] = "Composite",
 		[AU0828_VMUX_SVIDEO] = "S-Video",
 		[AU0828_VMUX_CABLE] = "Cable TV",
@@ -1834,7 +1834,7 @@ static void au0828_analog_create_entities(struct au0828_dev *dev)
 		ent->flags = MEDIA_ENT_FL_CONNECTOR;
 		dev->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
 
-		switch(AUVI_INPUT(i).type) {
+		switch (AUVI_INPUT(i).type) {
 		case AU0828_VMUX_COMPOSITE:
 			ent->function = MEDIA_ENT_F_CONN_COMPOSITE;
 			break;
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index bcf60d412905..d8e5994cccf1 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -726,7 +726,6 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			BASE_VIDIOC_PRIVATE);
 }
 
-
 static int video_register_media_controller(struct video_device *vdev, int type)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER)
@@ -741,15 +740,15 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 	switch (type) {
 	case VFL_TYPE_GRABBER:
 		intf_type = MEDIA_INTF_T_V4L_VIDEO;
-		vdev->entity.function = MEDIA_ENT_F_IO;
+		vdev->entity.function = MEDIA_ENT_F_IO_V4L;
 		break;
 	case VFL_TYPE_VBI:
 		intf_type = MEDIA_INTF_T_V4L_VBI;
-		vdev->entity.function = MEDIA_ENT_F_IO;
+		vdev->entity.function = MEDIA_ENT_F_IO_VBI;
 		break;
 	case VFL_TYPE_SDR:
 		intf_type = MEDIA_INTF_T_V4L_SWRADIO;
-		vdev->entity.function = MEDIA_ENT_F_IO;
+		vdev->entity.function = MEDIA_ENT_F_IO_SWRADIO;
 		break;
 	case VFL_TYPE_RADIO:
 		intf_type = MEDIA_INTF_T_V4L_RADIO;
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index d70aedc75998..d63083803144 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -535,7 +535,7 @@ v4l2_subdev_link_validate_get_format(struct media_pad *pad,
 		return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
 	}
 
-	WARN(pad->entity->function != MEDIA_ENT_F_IO,
+	WARN(pad->entity->function != MEDIA_ENT_F_IO_V4L,
 	     "Driver bug! Wrong media entity type 0x%08x, entity %s\n",
 	     pad->entity->function, pad->entity->name);
 
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 1d2cc3386c66..a3925ecd0ed7 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -740,7 +740,7 @@ static int resizer_link_setup(struct media_entity *entity,
 
 		break;
 
-	case RESIZER_PAD_SOURCE_MEM :
+	case RESIZER_PAD_SOURCE_MEM:
 		/* Write to memory */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (resizer->output & ~RESIZER_OUTPUT_MEMORY)
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 1b12774a9ab4..87ff299e1265 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -88,7 +88,7 @@ struct media_device {
 	struct list_head pads;
 	struct list_head links;
 
-	/* Protects the entities list */
+	/* Protects the graph objects creation/removal */
 	spinlock_t lock;
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index a02b1bd3e45e..cd3f3a77df2d 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -61,7 +61,7 @@ enum media_gobj_type {
  *		MEDIA_BITS_PER_TYPE to store the type plus
  *		MEDIA_BITS_PER_LOCAL_ID	to store a per-type ID
  *		(called as "local ID").
- * @list:	Linked list associated to one of the per-type mdev object lists
+ * @list:	List entry stored in one of the per-type mdev object lists
  *
  * All objects on the media graph should have this struct embedded
  */
@@ -75,26 +75,26 @@ struct media_pipeline {
 };
 
 /**
- * struct media_link - Define a media link graph object.
+ * struct media_link - A link object part of a media graph.
  *
  * @graph_obj:	Embedded structure containing the media object common data
  * @list:	Linked list associated with an entity or an interface that
  *		owns the link.
- * @gobj0:	Part of an union. Used to get the pointer for the first
+ * @gobj0:	Part of a union. Used to get the pointer for the first
  *		graph_object of the link.
- * @source:	Part of an union. Used only if the first object (gobj0) is
- *		a pad. On such case, it represents the source pad.
- * @intf:	Part of an union. Used only if the first object (gobj0) is
+ * @source:	Part of a union. Used only if the first object (gobj0) is
+ *		a pad. In that case, it represents the source pad.
+ * @intf:	Part of a union. Used only if the first object (gobj0) is
  *		an interface.
- * @gobj1:	Part of an union. Used to get the pointer for the second
+ * @gobj1:	Part of a union. Used to get the pointer for the second
  *		graph_object of the link.
- * @source:	Part of an union. Used only if the second object (gobj0) is
- *		a pad. On such case, it represents the sink pad.
- * @entity:	Part of an union. Used only if the second object (gobj0) is
+ * @source:	Part of a union. Used only if the second object (gobj1) is
+ *		a pad. In that case, it represents the sink pad.
+ * @entity:	Part of a union. Used only if the second object (gobj1) is
  *		an entity.
  * @reverse:	Pointer to the link for the reverse direction of a pad to pad
  *		link.
- * @flags:	Link flags, as defined at uapi/media.h (MEDIA_LNK_FL_*)
+ * @flags:	Link flags, as defined in uapi/media.h (MEDIA_LNK_FL_*)
  * @is_backlink: Indicate if the link is a backlink.
  */
 struct media_link {
@@ -116,12 +116,12 @@ struct media_link {
 };
 
 /**
- * struct media_pad - Define a media pad graph object.
+ * struct media_pad - A media pad graph object.
  *
  * @graph_obj:	Embedded structure containing the media object common data
- * @entity:	Entity where this object belongs
+ * @entity:	Entity this pad belongs to
  * @index:	Pad index in the entity pads array, numbered from 0 to n
- * @flags:	Pad flags, as defined at uapi/media.h (MEDIA_PAD_FL_*)
+ * @flags:	Pad flags, as defined in uapi/media.h (MEDIA_PAD_FL_*)
  */
 struct media_pad {
 	struct media_gobj graph_obj;	/* must be first field in struct */
@@ -147,30 +147,30 @@ struct media_entity_operations {
 };
 
 /**
- * struct media_entity - Define a media entity graph object.
+ * struct media_entity - A media entity graph object.
  *
  * @graph_obj:	Embedded structure containing the media object common data.
  * @name:	Entity name.
- * @function:	Entity main function, as defined at uapi/media.h
+ * @function:	Entity main function, as defined in uapi/media.h
  *		(MEDIA_ENT_F_*)
  * @revision:	Entity revision - OBSOLETE - should be removed soon.
- * @flags:	Entity flags, as defined at uapi/media.h (MEDIA_ENT_FL_*)
+ * @flags:	Entity flags, as defined in uapi/media.h (MEDIA_ENT_FL_*)
  * @group_id:	Entity group ID - OBSOLETE - should be removed soon.
  * @num_pads:	Number of sink and source pads.
- * @num_links:	Number of existing links, both enabled and disabled.
+ * @num_links:	Total number of links, forward and back, enabled and disabled.
  * @num_backlinks: Number of backlinks
  * @pads:	Pads array with the size defined by @num_pads.
- * @links:	Linked list for the data links.
+ * @links:	List of data links.
  * @ops:	Entity operations.
  * @stream_count: Stream count for the entity.
  * @use_count:	Use count for the entity.
  * @pipe:	Pipeline this entity belongs to.
  * @info:	Union with devnode information.  Kept just for backward
- * 		compatibility.
+ *		compatibility.
  * @major:	Devnode major number (zero if not applicable). Kept just
- * 		for backward compatibility.
+ *		for backward compatibility.
  * @minor:	Devnode minor number (zero if not applicable). Kept just
- * 		for backward compatibility.
+ *		for backward compatibility.
  *
  * NOTE: @stream_count and @use_count reference counts must never be
  * negative, but are signed integers on purpose: a simple WARN_ON(<0) check
@@ -211,19 +211,14 @@ struct media_entity {
 };
 
 /**
- * struct media_interface - Define a media interface graph object
+ * struct media_interface - A media interface graph object.
  *
  * @graph_obj:		embedded graph object
  * @links:		List of links pointing to graph entities
- * @type:		Type of the interface as defined at the
+ * @type:		Type of the interface as defined in the
  *			uapi/media/media.h header, e. g.
  *			MEDIA_INTF_T_*
- * @flags:		Interface flags as defined at uapi/media/media.h
- *
- * NOTE: As media_device_unregister() will free the address of the
- *	 media_interface, this structure should be embedded as the first
- *	 element of the derived functions, in order for the address to be
- *	 the same.
+ * @flags:		Interface flags as defined in uapi/media/media.h
  */
 struct media_interface {
 	struct media_gobj		graph_obj;
@@ -233,18 +228,18 @@ struct media_interface {
 };
 
 /**
- * struct media_intf_devnode - Define a media interface via a device node
+ * struct media_intf_devnode - A media interface via a device node.
  *
  * @intf:	embedded interface object
  * @major:	Major number of a device node
  * @minor:	Minor number of a device node
  */
 struct media_intf_devnode {
-	struct media_interface	intf; /* must be first field in struct */
+	struct media_interface		intf;
 
 	/* Should match the fields at media_v2_intf_devnode */
-	u32			major;
-	u32			minor;
+	u32				major;
+	u32				minor;
 };
 
 static inline u32 media_entity_id(struct media_entity *entity)
@@ -278,7 +273,9 @@ static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
 		return false;
 
 	switch (entity->function) {
-	case MEDIA_ENT_F_IO:
+	case MEDIA_ENT_F_IO_V4L:
+	case MEDIA_ENT_F_IO_VBI:
+	case MEDIA_ENT_F_IO_SWRADIO:
 		return true;
 	default:
 		return false;
@@ -291,6 +288,7 @@ static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
 		return false;
 
 	switch (entity->function) {
+	case MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN:
 	case MEDIA_ENT_F_CAM_SENSOR:
 	case MEDIA_ENT_F_FLASH:
 	case MEDIA_ENT_F_LENS:
@@ -354,7 +352,7 @@ int media_entity_init(struct media_entity *entity, u16 num_pads,
 void media_entity_cleanup(struct media_entity *entity);
 
 __must_check int media_create_pad_link(struct media_entity *source,
-			u16 source_pad,	struct media_entity *sink,
+			u16 source_pad, struct media_entity *sink,
 			u16 sink_pad, u32 flags);
 void __media_entity_remove_links(struct media_entity *entity);
 void media_entity_remove_links(struct media_entity *entity);
@@ -385,6 +383,7 @@ struct media_link *
 __must_check media_create_intf_link(struct media_entity *entity,
 				    struct media_interface *intf,
 				    u32 flags);
+void __media_remove_intf_link(struct media_link *link);
 void media_remove_intf_link(struct media_link *link);
 void __media_remove_intf_links(struct media_interface *intf);
 void media_remove_intf_links(struct media_interface *intf);
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 90e90a6e62bf..ff6a8010c520 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -51,8 +51,8 @@ struct media_device_info {
 /*
  * Base number ranges for entity functions
  *
- * NOTE: those ranges and entity function number are spased just to
- * make easier to maintain this file. Userspace should not rely on
+ * NOTE: those ranges and entity function number are phased just to
+ * make it easier to maintain this file. Userspace should not rely on
  * the ranges to identify a group of function types, as newer
  * functions can be added with any name within the full u32 range.
  */
@@ -64,7 +64,7 @@ struct media_device_info {
  * DVB entities
  */
 #define MEDIA_ENT_F_DTV_DEMOD		(MEDIA_ENT_F_BASE + 1)
-#define MEDIA_ENT_F_MPEG_TS_DEMUX	(MEDIA_ENT_F_BASE + 2)
+#define MEDIA_ENT_F_TS_DEMUX		(MEDIA_ENT_F_BASE + 2)
 #define MEDIA_ENT_F_DTV_CA		(MEDIA_ENT_F_BASE + 3)
 #define MEDIA_ENT_F_DTV_NET_DECAP	(MEDIA_ENT_F_BASE + 4)
 
@@ -78,6 +78,13 @@ struct media_device_info {
 #define MEDIA_ENT_F_CONN_TEST		(MEDIA_ENT_F_BASE + 24)
 
 /*
+ * I/O entities
+ */
+#define MEDIA_ENT_F_IO_DTV  		(MEDIA_ENT_F_BASE + 31)
+#define MEDIA_ENT_F_IO_VBI  		(MEDIA_ENT_F_BASE + 32)
+#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 33)
+
+/*
  * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
  * MEDIA_ENT_F_OLD_SUBDEV_BASE are kept to keep backward compatibility
  * with the legacy v1 API.The number range is out of range by purpose:
@@ -89,7 +96,7 @@ struct media_device_info {
  * registering the entity.
  */
 
-#define MEDIA_ENT_F_IO  		(MEDIA_ENT_F_OLD_BASE + 1)
+#define MEDIA_ENT_F_IO_V4L  		(MEDIA_ENT_F_OLD_BASE + 1)
 
 #define MEDIA_ENT_F_CAM_SENSOR		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 1)
 #define MEDIA_ENT_F_FLASH		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 2)
@@ -113,13 +120,13 @@ struct media_device_info {
 #define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
 
 #define MEDIA_ENT_T_DEVNODE		MEDIA_ENT_F_OLD_BASE
-#define MEDIA_ENT_T_DEVNODE_V4L		MEDIA_ENT_F_IO
+#define MEDIA_ENT_T_DEVNODE_V4L		MEDIA_ENT_F_IO_V4L
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
 #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
 #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
 
 #define MEDIA_ENT_T_UNKNOWN		MEDIA_ENT_F_UNKNOWN
-#define MEDIA_ENT_T_V4L2_VIDEO		MEDIA_ENT_F_IO
+#define MEDIA_ENT_T_V4L2_VIDEO		MEDIA_ENT_F_IO_V4L
 #define MEDIA_ENT_T_V4L2_SUBDEV		MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
 #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	MEDIA_ENT_F_CAM_SENSOR
 #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	MEDIA_ENT_F_FLASH
@@ -237,7 +244,6 @@ struct media_links_enum {
 
 #define MEDIA_INTF_T_DVB_BASE	0x00000100
 #define MEDIA_INTF_T_V4L_BASE	0x00000200
-#define MEDIA_INTF_T_ALSA_BASE	0x00000300
 
 /* Interface types */
 
@@ -253,13 +259,6 @@ struct media_links_enum {
 #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
 #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
 
-#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
-#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
-#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
-#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
-#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
-#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
-
 /*
  * MC next gen API definitions
  *
@@ -313,11 +312,11 @@ struct media_v2_pad {
 };
 
 struct media_v2_link {
-    __u32 id;
-    __u32 source_id;
-    __u32 sink_id;
-    __u32 flags;
-    __u32 reserved[5];
+	__u32 id;
+	__u32 source_id;
+	__u32 sink_id;
+	__u32 flags;
+	__u32 reserved[5];
 };
 
 struct media_v2_topology {

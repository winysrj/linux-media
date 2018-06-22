Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55034 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933836AbeFVRqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 13:46:14 -0400
Message-ID: <31ef24be3d642ffa3e0935713d2eb7b2cdab1f02.camel@collabora.com>
Subject: Re: [PATCH v2 1/2] media: add helpers for memory-to-memory media
 controller
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com
Date: Fri, 22 Jun 2018 14:46:05 -0300
In-Reply-To: <d6d9965a-1523-53f9-137b-d5e513fa92e0@xs4all.nl>
References: <20180621203828.18173-1-ezequiel@collabora.com>
         <20180621203828.18173-2-ezequiel@collabora.com>
         <d6d9965a-1523-53f9-137b-d5e513fa92e0@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-06-22 at 08:58 +0200, Hans Verkuil wrote:
> On 06/21/2018 10:38 PM, Ezequiel Garcia wrote:
> > A memory-to-memory pipeline device consists in three
> > entities: two DMA engine and one video processing entities.
> > The DMA engine entities are linked to a V4L interface.
> > 
> > This commit add a new v4l2_m2m_{un}register_media_controller
> > API to register this topology.
> > 
> > For instance, a typical mem2mem device topology would
> > look like this:
> > 
> > Device topology
> > - entity 1: source (1 pad, 1 link)
> >             type Node subtype V4L flags 0
> > 	pad0: Source
> > 		-> "proc":1 [ENABLED,IMMUTABLE]
> > 
> > - entity 3: proc (2 pads, 2 links)
> >             type Node subtype Unknown flags 0
> > 	pad0: Source
> > 		-> "sink":0 [ENABLED,IMMUTABLE]
> > 	pad1: Sink
> > 		<- "source":0 [ENABLED,IMMUTABLE]
> > 
> > - entity 6: sink (1 pad, 1 link)
> >             type Node subtype V4L flags 0
> > 	pad0: Sink
> > 		<- "proc":0 [ENABLED,IMMUTABLE]
> > 
> > Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-dev.c     |  13 +-
> >  drivers/media/v4l2-core/v4l2-mem2mem.c | 174
> > +++++++++++++++++++++++++
> >  include/media/v4l2-mem2mem.h           |  19 +++
> >  include/uapi/linux/media.h             |   3 +
> >  4 files changed, 204 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-dev.c
> > b/drivers/media/v4l2-core/v4l2-dev.c
> > index 4ffd7d60a901..c1996d73ca74 100644
> > --- a/drivers/media/v4l2-core/v4l2-dev.c
> > +++ b/drivers/media/v4l2-core/v4l2-dev.c
> > @@ -202,7 +202,7 @@ static void v4l2_device_release(struct device
> > *cd)
> >  	mutex_unlock(&videodev_lock);
> >  
> >  #if defined(CONFIG_MEDIA_CONTROLLER)
> > -	if (v4l2_dev->mdev) {
> > +	if (v4l2_dev->mdev && vdev->vfl_dir != VFL_DIR_M2M) {
> >  		/* Remove interfaces and interface links */
> >  		media_devnode_remove(vdev->intf_devnode);
> >  		if (vdev->entity.function != MEDIA_ENT_F_UNKNOWN)
> > @@ -733,19 +733,22 @@ static void determine_valid_ioctls(struct
> > video_device *vdev)
> >  			BASE_VIDIOC_PRIVATE);
> >  }
> >  
> > -static int video_register_media_controller(struct video_device
> > *vdev, int type)
> > +static int video_register_media_controller(struct video_device
> > *vdev)
> >  {
> >  #if defined(CONFIG_MEDIA_CONTROLLER)
> >  	u32 intf_type;
> >  	int ret;
> >  
> > -	if (!vdev->v4l2_dev->mdev)
> > +	/* Memory-to-memory devices are more complex and use
> > +	 * their own function to register its mc entities.
> > +	 */
> > +	if (!vdev->v4l2_dev->mdev || vdev->vfl_dir == VFL_DIR_M2M)
> >  		return 0;
> >  
> >  	vdev->entity.obj_type = MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
> >  	vdev->entity.function = MEDIA_ENT_F_UNKNOWN;
> >  
> > -	switch (type) {
> > +	switch (vdev->vfl_type) {
> >  	case VFL_TYPE_GRABBER:
> >  		intf_type = MEDIA_INTF_T_V4L_VIDEO;
> >  		vdev->entity.function = MEDIA_ENT_F_IO_V4L;
> > @@ -993,7 +996,7 @@ int __video_register_device(struct video_device
> > *vdev,
> >  	v4l2_device_get(vdev->v4l2_dev);
> >  
> >  	/* Part 5: Register the entity. */
> > -	ret = video_register_media_controller(vdev, type);
> > +	ret = video_register_media_controller(vdev);
> >  
> >  	/* Part 6: Activate this minor. The char device can now be
> > used. */
> >  	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
> > diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c
> > b/drivers/media/v4l2-core/v4l2-mem2mem.c
> > index c4f963d96a79..e0e7262b7e75 100644
> > --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> > +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> > @@ -17,9 +17,11 @@
> >  #include <linux/sched.h>
> >  #include <linux/slab.h>
> >  
> > +#include <media/media-device.h>
> >  #include <media/videobuf2-v4l2.h>
> >  #include <media/v4l2-mem2mem.h>
> >  #include <media/v4l2-dev.h>
> > +#include <media/v4l2-device.h>
> >  #include <media/v4l2-fh.h>
> >  #include <media/v4l2-event.h>
> >  
> > @@ -50,6 +52,19 @@ module_param(debug, bool, 0644);
> >   * offsets but for different queues */
> >  #define DST_QUEUE_OFF_BASE	(1 << 30)
> >  
> > +enum v4l2_m2m_entity_type {
> > +	MEM2MEM_ENT_TYPE_SOURCE,
> > +	MEM2MEM_ENT_TYPE_SINK,
> > +	MEM2MEM_ENT_TYPE_PROC,
> > +	MEM2MEM_ENT_TYPE_MAX
> > +};
> > +
> > +static const char * const m2m_entity_name[] = {
> > +	"source",
> > +	"sink",
> > +	"proc"
> > +};
> > +
> >  
> >  /**
> >   * struct v4l2_m2m_dev - per-device context
> > @@ -60,6 +75,15 @@ module_param(debug, bool, 0644);
> >   */
> >  struct v4l2_m2m_dev {
> >  	struct v4l2_m2m_ctx	*curr_ctx;
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> > +	struct media_entity	*source;
> > +	struct media_pad	source_pad;
> > +	struct media_entity	sink;
> > +	struct media_pad	sink_pad;
> > +	struct media_entity	proc;
> > +	struct media_pad	proc_pads[2];
> > +	struct media_intf_devnode *intf_devnode;
> > +#endif
> >  
> >  	struct list_head	job_queue;
> >  	spinlock_t		job_spinlock;
> > @@ -595,6 +619,156 @@ int v4l2_m2m_mmap(struct file *file, struct
> > v4l2_m2m_ctx *m2m_ctx,
> >  }
> >  EXPORT_SYMBOL(v4l2_m2m_mmap);
> >  
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +void v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev
> > *m2m_dev)
> > +{
> > +	media_remove_intf_links(&m2m_dev->intf_devnode->intf);
> > +	media_devnode_remove(m2m_dev->intf_devnode);
> > +
> > +	media_entity_remove_links(m2m_dev->source);
> > +	media_entity_remove_links(&m2m_dev->sink);
> > +	media_entity_remove_links(&m2m_dev->proc);
> > +	media_device_unregister_entity(m2m_dev->source);
> > +	media_device_unregister_entity(&m2m_dev->sink);
> > +	media_device_unregister_entity(&m2m_dev->proc);
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_unregister_media_controller);
> > +
> > +static int v4l2_m2m_register_entity(struct media_device *mdev,
> > +	struct v4l2_m2m_dev *m2m_dev, enum v4l2_m2m_entity_type
> > type,
> > +	int function)
> > +{
> > +	struct media_entity *entity;
> > +	struct media_pad *pads;
> > +	int num_pads;
> > +	int ret;
> > +
> > +	switch (type) {
> > +	case MEM2MEM_ENT_TYPE_SOURCE:
> > +		entity = m2m_dev->source;
> > +		pads = &m2m_dev->source_pad;
> > +		entity->name = m2m_entity_name[type];
> > +		pads[0].flags = MEDIA_PAD_FL_SOURCE;
> > +		num_pads = 1;
> > +		break;
> > +	case MEM2MEM_ENT_TYPE_SINK:
> > +		entity = &m2m_dev->sink;
> > +		pads = &m2m_dev->sink_pad;
> > +		pads[0].flags = MEDIA_PAD_FL_SINK;
> > +		num_pads = 1;
> > +		break;
> > +	case MEM2MEM_ENT_TYPE_PROC:
> > +		entity = &m2m_dev->proc;
> > +		pads = m2m_dev->proc_pads;
> > +		pads[0].flags = MEDIA_PAD_FL_SOURCE;
> > +		pads[1].flags = MEDIA_PAD_FL_SINK;
> 
> Can you swap this? The v4l2-compliance test gave a "fail: v4l2-test-
> media.cpp(333): found_source"
> message which is because (I think) it expects sink pads before source
> pads.
> 

Yes, that did it.

> I'm not actually sure that this is a requirement, at least I can't
> find this in the spec,
> but for some reason I have this memory that this actually is the
> right order. It might just
> be a custom rather than a requirement.
> 
> Anyway, it doesn't matter for this code, so it is easiest to swap it
> and run v4l2-compliance -m
> again.
> 
> I am interested in the v4l2-compliance output of the topology.
> 

Here it goes:

Media Controller ioctls:
		Entity: 0x00000001 (Name: 'source', Function:
0x00010001)
		Entity: 0x00000003 (Name: 'proc', Function: 0x00004005)
		Entity: 0x00000006 (Name: 'sink', Function: 0x00010001)
		Interface: 0x0300000c (Type: 0x00000200)
		Pad: 0x01000002
		Pad: 0x01000004
		Pad: 0x01000005
		Pad: 0x01000007
		Link: 0x02000008
		Link: 0x0200000a
		Link: 0x0200000d
		Link: 0x0200000e
	test MEDIA_IOC_G_TOPOLOGY: OK
	Entities: 3 Interfaces: 1 Pads: 4 Links: 4
		Entity: 0x00000001 (Name: 'source', Type: 0x00010001)
		Entity: 0x00000003 (Name: 'proc', Type: 0x0001ffff)
		Entity: 0x00000006 (Name: 'sink', Type: 0x00010001)
		Entity Links: 0x00000001 (Name: 'source')
		Entity Links: 0x00000003 (Name: 'proc')
		Entity Links: 0x00000006 (Name: 'sink')
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
	test MEDIA_IOC_SETUP_LINK: OK

I will submit a v3 shortly with this change, and a couple other
nitpicks.

Regards,
Eze

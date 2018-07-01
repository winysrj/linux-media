Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:35495 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752153AbeGAMh6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Jul 2018 08:37:58 -0400
Subject: Re: [PATCH v4 1/2] media: add helpers for memory-to-memory media
 controller
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com
References: <20180629182244.4235-1-ezequiel@collabora.com>
 <20180629182244.4235-2-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a1c37c7a-dac1-ba4c-90ce-f4e10841427d@xs4all.nl>
Date: Sun, 1 Jul 2018 14:37:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180629182244.4235-2-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/06/18 20:22, Ezequiel Garcia wrote:
> A memory-to-memory pipeline device consists in three
> entities: two DMA engine and one video processing entities.
> The DMA engine entities are linked to a V4L interface.
> 
> This commit add a new v4l2_m2m_{un}register_media_controller
> API to register this topology.
> 
> For instance, a typical mem2mem device topology would
> look like this:
> 
> Device topology
> - entity 1: source (1 pad, 1 link)
>             type Node subtype V4L flags 0
> 	pad0: Source
> 		-> "proc":1 [ENABLED,IMMUTABLE]
> 
> - entity 3: proc (2 pads, 2 links)
>             type Node subtype Unknown flags 0
> 	pad0: Source
> 		-> "sink":0 [ENABLED,IMMUTABLE]
> 	pad1: Sink
> 		<- "source":0 [ENABLED,IMMUTABLE]
> 
> - entity 6: sink (1 pad, 1 link)
>             type Node subtype V4L flags 0
> 	pad0: Sink
> 		<- "proc":0 [ENABLED,IMMUTABLE]
> 
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c     |  13 +-
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 186 +++++++++++++++++++++++++
>  include/media/v4l2-mem2mem.h           |  19 +++
>  3 files changed, 213 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 4ffd7d60a901..c1996d73ca74 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -202,7 +202,7 @@ static void v4l2_device_release(struct device *cd)
>  	mutex_unlock(&videodev_lock);
>  
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> -	if (v4l2_dev->mdev) {
> +	if (v4l2_dev->mdev && vdev->vfl_dir != VFL_DIR_M2M) {
>  		/* Remove interfaces and interface links */
>  		media_devnode_remove(vdev->intf_devnode);
>  		if (vdev->entity.function != MEDIA_ENT_F_UNKNOWN)
> @@ -733,19 +733,22 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  			BASE_VIDIOC_PRIVATE);
>  }
>  
> -static int video_register_media_controller(struct video_device *vdev, int type)
> +static int video_register_media_controller(struct video_device *vdev)
>  {
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	u32 intf_type;
>  	int ret;
>  
> -	if (!vdev->v4l2_dev->mdev)
> +	/* Memory-to-memory devices are more complex and use
> +	 * their own function to register its mc entities.
> +	 */
> +	if (!vdev->v4l2_dev->mdev || vdev->vfl_dir == VFL_DIR_M2M)
>  		return 0;
>  
>  	vdev->entity.obj_type = MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
>  	vdev->entity.function = MEDIA_ENT_F_UNKNOWN;
>  
> -	switch (type) {
> +	switch (vdev->vfl_type) {
>  	case VFL_TYPE_GRABBER:
>  		intf_type = MEDIA_INTF_T_V4L_VIDEO;
>  		vdev->entity.function = MEDIA_ENT_F_IO_V4L;
> @@ -993,7 +996,7 @@ int __video_register_device(struct video_device *vdev,
>  	v4l2_device_get(vdev->v4l2_dev);
>  
>  	/* Part 5: Register the entity. */
> -	ret = video_register_media_controller(vdev, type);
> +	ret = video_register_media_controller(vdev);
>  
>  	/* Part 6: Activate this minor. The char device can now be used. */
>  	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index c4f963d96a79..60791f36af21 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -17,9 +17,11 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  
> +#include <media/media-device.h>
>  #include <media/videobuf2-v4l2.h>
>  #include <media/v4l2-mem2mem.h>
>  #include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-event.h>
>  
> @@ -50,6 +52,17 @@ module_param(debug, bool, 0644);
>   * offsets but for different queues */
>  #define DST_QUEUE_OFF_BASE	(1 << 30)
>  
> +enum v4l2_m2m_entity_type {
> +	MEM2MEM_ENT_TYPE_SOURCE,
> +	MEM2MEM_ENT_TYPE_SINK,
> +	MEM2MEM_ENT_TYPE_PROC
> +};
> +
> +static const char * const m2m_entity_name[] = {
> +	"source",
> +	"sink",
> +	"proc"
> +};
>  
>  /**
>   * struct v4l2_m2m_dev - per-device context
> @@ -60,6 +73,15 @@ module_param(debug, bool, 0644);
>   */
>  struct v4l2_m2m_dev {
>  	struct v4l2_m2m_ctx	*curr_ctx;
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_entity	*source;
> +	struct media_pad	source_pad;
> +	struct media_entity	sink;
> +	struct media_pad	sink_pad;
> +	struct media_entity	proc;
> +	struct media_pad	proc_pads[2];
> +	struct media_intf_devnode *intf_devnode;
> +#endif
>  
>  	struct list_head	job_queue;
>  	spinlock_t		job_spinlock;
> @@ -595,6 +617,170 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>  }
>  EXPORT_SYMBOL(v4l2_m2m_mmap);
>  
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +void v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev)
> +{
> +	media_remove_intf_links(&m2m_dev->intf_devnode->intf);
> +	media_devnode_remove(m2m_dev->intf_devnode);
> +
> +	media_entity_remove_links(m2m_dev->source);
> +	media_entity_remove_links(&m2m_dev->sink);
> +	media_entity_remove_links(&m2m_dev->proc);
> +	media_device_unregister_entity(m2m_dev->source);
> +	media_device_unregister_entity(&m2m_dev->sink);
> +	media_device_unregister_entity(&m2m_dev->proc);
> +	kfree(m2m_dev->source->name);
> +	kfree(m2m_dev->sink.name);
> +	kfree(m2m_dev->proc.name);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_m2m_unregister_media_controller);
> +
> +static int v4l2_m2m_register_entity(struct media_device *mdev,
> +	struct v4l2_m2m_dev *m2m_dev, enum v4l2_m2m_entity_type type,
> +	struct video_device *vdev, int function)
> +{
> +	struct media_entity *entity;
> +	struct media_pad *pads;
> +	char *name;
> +	unsigned int len;
> +	int num_pads;
> +	int ret;
> +
> +	switch (type) {
> +	case MEM2MEM_ENT_TYPE_SOURCE:
> +		entity = m2m_dev->source;
> +		pads = &m2m_dev->source_pad;
> +		pads[0].flags = MEDIA_PAD_FL_SOURCE;
> +		num_pads = 1;
> +		break;
> +	case MEM2MEM_ENT_TYPE_SINK:
> +		entity = &m2m_dev->sink;
> +		pads = &m2m_dev->sink_pad;
> +		pads[0].flags = MEDIA_PAD_FL_SINK;
> +		num_pads = 1;
> +		break;
> +	case MEM2MEM_ENT_TYPE_PROC:
> +		entity = &m2m_dev->proc;
> +		pads = m2m_dev->proc_pads;
> +		pads[0].flags = MEDIA_PAD_FL_SINK;
> +		pads[1].flags = MEDIA_PAD_FL_SOURCE;
> +		num_pads = 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	entity->obj_type = MEDIA_ENTITY_TYPE_BASE;
> +	entity->info.dev.major = VIDEO_MAJOR;
> +	entity->info.dev.minor = vdev->minor;

Oops, the major and minor fields should not be set for MEM2MEM_ENT_TYPE_PROC.
So change this to:

        if (type != MEM2MEM_ENT_TYPE_PROC) {
                entity->info.dev.major = VIDEO_MAJOR;
                entity->info.dev.minor = vdev->minor;
        }

With this change this all looks ready to be merged.

Regards,

	Hans

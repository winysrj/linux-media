Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60592 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752630AbdFLUfh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 16:35:37 -0400
Subject: Re: [RFC PATCH v3 09/11] [media] vimc: Subdevices as modules
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
References: <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
 <1496458714-16834-1-git-send-email-helen.koike@collabora.com>
 <1496458714-16834-10-git-send-email-helen.koike@collabora.com>
 <a8fce901-ef34-0ebc-e0b9-90b930416965@xs4all.nl>
Cc: jgebben@codeaurora.org, mchehab@osg.samsung.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <9fa2afbe-890a-7901-8980-5dcc1fbd36a7@collabora.com>
Date: Mon, 12 Jun 2017 17:35:25 -0300
MIME-Version: 1.0
In-Reply-To: <a8fce901-ef34-0ebc-e0b9-90b930416965@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for your review. Please check my comments below

On 2017-06-12 07:37 AM, Hans Verkuil wrote:
> On 06/03/2017 04:58 AM, Helen Koike wrote:
>> Change the core structure for adding subdevices in the topology.
>> Instead of calling the specific create function for each subdevice,
>> inject a child platform_device with the driver's name.
>> Each type of node in the topology (sensor, capture, debayer, scaler)
>> will register a platform_driver with the corresponding name through the
>> component subsystem.
>> Implementing a new subdevice type doesn't require vimc-core to be
>> altered.
>>
>> This facilitates future implementation of dynamic entities, where
>> hotpluging an entity in the topology is just a matter of
>> registering/unregistering a platform_device in the system.
>> It also facilitates other implementations of different nodes without
>> touching the core code and remove the need of a header file for each
>> type of node.
>>
>> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>>
>> ---
>>
>> Changes in v3:
>> [media] vimc: Subdevices as modules
>>     - This is a new patch in the series
>>
>> Changes in v2: None
>>
>>
>> ---
>>   drivers/media/platform/vimc/Makefile       |   7 +-
>>   drivers/media/platform/vimc/vimc-capture.c |  96 ++++---
>>   drivers/media/platform/vimc/vimc-capture.h |  28 --
>>   drivers/media/platform/vimc/vimc-common.c  |  37 ++-
>>   drivers/media/platform/vimc/vimc-common.h  |  14 +-
>>   drivers/media/platform/vimc/vimc-core.c    | 406
>> +++++++++++------------------
>>   drivers/media/platform/vimc/vimc-sensor.c  |  91 +++++--
>>   drivers/media/platform/vimc/vimc-sensor.h  |  28 --
>>   8 files changed, 320 insertions(+), 387 deletions(-)
>>   delete mode 100644 drivers/media/platform/vimc/vimc-capture.h
>>   delete mode 100644 drivers/media/platform/vimc/vimc-sensor.h
>>
>> diff --git a/drivers/media/platform/vimc/Makefile
>> b/drivers/media/platform/vimc/Makefile
>> index 6b6ddf4..0e5d5ce 100644
>> --- a/drivers/media/platform/vimc/Makefile
>> +++ b/drivers/media/platform/vimc/Makefile
>> @@ -1,3 +1,6 @@
>> -vimc-objs := vimc-core.o vimc-capture.o vimc-common.o vimc-sensor.o
>> +vimc-objs := vimc-core.o
>> +vimc_capture-objs := vimc-capture.o
>> +vimc_common-objs := vimc-common.o
>> +vimc_sensor-objs := vimc-sensor.o
>>   -obj-$(CONFIG_VIDEO_VIMC) += vimc.o
>> +obj-$(CONFIG_VIDEO_VIMC) += vimc.o vimc_capture.o vimc_common.o
>> vimc_sensor.o
>> diff --git a/drivers/media/platform/vimc/vimc-capture.c
>> b/drivers/media/platform/vimc/vimc-capture.c
>> index b5da0ea..633d99a 100644
>> --- a/drivers/media/platform/vimc/vimc-capture.c
>> +++ b/drivers/media/platform/vimc/vimc-capture.c
>> @@ -15,18 +15,24 @@
>>    *
>>    */
>>   +#include <linux/component.h>
>>   #include <linux/freezer.h>
>>   #include <linux/kthread.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>>   #include <media/v4l2-ioctl.h>
>>   #include <media/v4l2-tpg.h>
>>   #include <media/videobuf2-core.h>
>>   #include <media/videobuf2-vmalloc.h>
>>   -#include "vimc-capture.h"
>> +#include "vimc-common.h"
>> +
>> +#define VIMC_CAP_DRV_NAME "vimc-capture"
>>     struct vimc_cap_device {
>>       struct vimc_ent_device ved;
>>       struct video_device vdev;
>> +    struct device *dev;
>>       struct v4l2_pix_format format;
>>       struct vb2_queue queue;
>>       struct list_head buf_list;
>> @@ -150,7 +156,7 @@ static int vimc_cap_s_fmt_vid_cap(struct file
>> *file, void *priv,
>>         vimc_cap_try_fmt_vid_cap(file, priv, f);
>>   -    dev_dbg(vcap->vdev.v4l2_dev->dev, "%s: format update: "
>> +    dev_dbg(vcap->dev, "%s: format update: "
>>           "old:%dx%d (0x%x, %d, %d, %d, %d) "
>>           "new:%dx%d (0x%x, %d, %d, %d, %d)\n", vcap->vdev.name,
>>           /* old */
>> @@ -365,8 +371,7 @@ static int vimc_cap_start_streaming(struct
>> vb2_queue *vq, unsigned int count)
>>           vcap->kthread_cap = kthread_run(vimc_cap_tpg_thread, vcap,
>>                       "%s-cap", vcap->vdev.v4l2_dev->name);
>>           if (IS_ERR(vcap->kthread_cap)) {
>> -            dev_err(vcap->vdev.v4l2_dev->dev,
>> -                "%s: kernel_thread() failed\n",
>> +            dev_err(vcap->dev, "%s: kernel_thread() failed\n",
>>                   vcap->vdev.name);
>>               ret = PTR_ERR(vcap->kthread_cap);
>>               goto err_tpg_free;
>> @@ -443,8 +448,7 @@ static int vimc_cap_buffer_prepare(struct
>> vb2_buffer *vb)
>>       unsigned long size = vcap->format.sizeimage;
>>         if (vb2_plane_size(vb, 0) < size) {
>> -        dev_err(vcap->vdev.v4l2_dev->dev,
>> -            "%s: buffer too small (%lu < %lu)\n",
>> +        dev_err(vcap->dev, "%s: buffer too small (%lu < %lu)\n",
>>               vcap->vdev.name, vb2_plane_size(vb, 0), size);
>>           return -EINVAL;
>>       }
>> @@ -469,8 +473,10 @@ static const struct media_entity_operations
>> vimc_cap_mops = {
>>       .link_validate        = vimc_link_validate,
>>   };
>>   -static void vimc_cap_destroy(struct vimc_ent_device *ved)
>> +static void vimc_cap_comp_unbind(struct device *comp, struct device
>> *master,
>> +                 void *master_data)
>>   {
>> +    struct vimc_ent_device *ved = dev_get_drvdata(comp);
>>       struct vimc_cap_device *vcap = container_of(ved, struct
>> vimc_cap_device,
>>                               ved);
>>   @@ -481,32 +487,25 @@ static void vimc_cap_destroy(struct
>> vimc_ent_device *ved)
>>       kfree(vcap);
>>   }
>>   -struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
>> -                    const char *const name,
>> -                    u16 num_pads,
>> -                    const unsigned long *pads_flag)
>> +static int vimc_cap_comp_bind(struct device *comp, struct device
>> *master,
>> +                  void *master_data)
>>   {
>> +    struct v4l2_device *v4l2_dev = master_data;
>> +    char *name = comp->platform_data;
>>       const struct vimc_pix_map *vpix;
>>       struct vimc_cap_device *vcap;
>>       struct video_device *vdev;
>>       struct vb2_queue *q;
>>       int ret;
>>   -    /*
>> -     * Check entity configuration params
>> -     * NOTE: we only support a single sink pad
>> -     */
>> -    if (!name || num_pads != 1 || !pads_flag ||
>> -        !(pads_flag[0] & MEDIA_PAD_FL_SINK))
>> -        return ERR_PTR(-EINVAL);
>> -
>>       /* Allocate the vimc_cap_device struct */
>>       vcap = kzalloc(sizeof(*vcap), GFP_KERNEL);
>>       if (!vcap)
>> -        return ERR_PTR(-ENOMEM);
>> +        return -ENOMEM;
>>         /* Allocate the pads */
>> -    vcap->ved.pads = vimc_pads_init(num_pads, pads_flag);
>> +    vcap->ved.pads =
>> +        vimc_pads_init(1, (const unsigned long[1]) {MEDIA_PAD_FL_SINK});
>>       if (IS_ERR(vcap->ved.pads)) {
>>           ret = PTR_ERR(vcap->ved.pads);
>>           goto err_free_vcap;
>> @@ -516,7 +515,7 @@ struct vimc_ent_device *vimc_cap_create(struct
>> v4l2_device *v4l2_dev,
>>       vcap->vdev.entity.name = name;
>>       vcap->vdev.entity.function = MEDIA_ENT_F_IO_V4L;
>>       ret = media_entity_pads_init(&vcap->vdev.entity,
>> -                     num_pads, vcap->ved.pads);
>> +                     1, vcap->ved.pads);
>>       if (ret)
>>           goto err_clean_pads;
>>   @@ -537,8 +536,7 @@ struct vimc_ent_device *vimc_cap_create(struct
>> v4l2_device *v4l2_dev,
>>         ret = vb2_queue_init(q);
>>       if (ret) {
>> -        dev_err(vcap->vdev.v4l2_dev->dev,
>> -            "%s: vb2 queue init failed (err=%d)\n",
>> +        dev_err(comp, "%s: vb2 queue init failed (err=%d)\n",
>>               vcap->vdev.name, ret);
>>           goto err_clean_m_ent;
>>       }
>> @@ -555,10 +553,11 @@ struct vimc_ent_device *vimc_cap_create(struct
>> v4l2_device *v4l2_dev,
>>                    vcap->format.height;
>>         /* Fill the vimc_ent_device struct */
>> -    vcap->ved.destroy = vimc_cap_destroy;
>>       vcap->ved.ent = &vcap->vdev.entity;
>>       vcap->ved.process_frame = vimc_cap_process_frame;
>>       vcap->ved.vdev_get_format = vimc_cap_get_format;
>> +    dev_set_drvdata(comp, &vcap->ved);
>> +    vcap->dev = comp;
>>         /* Initialize the video_device struct */
>>       vdev = &vcap->vdev;
>> @@ -577,13 +576,12 @@ struct vimc_ent_device *vimc_cap_create(struct
>> v4l2_device *v4l2_dev,
>>       /* Register the video_device with the v4l2 and the media
>> framework */
>>       ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
>>       if (ret) {
>> -        dev_err(vcap->vdev.v4l2_dev->dev,
>> -            "%s: video register failed (err=%d)\n",
>> +        dev_err(comp, "%s: video register failed (err=%d)\n",
>>               vcap->vdev.name, ret);
>>           goto err_release_queue;
>>       }
>>   -    return &vcap->ved;
>> +    return 0;
>>     err_release_queue:
>>       vb2_queue_release(q);
>> @@ -594,5 +592,45 @@ struct vimc_ent_device *vimc_cap_create(struct
>> v4l2_device *v4l2_dev,
>>   err_free_vcap:
>>       kfree(vcap);
>>   -    return ERR_PTR(ret);
>> +    return ret;
>> +}
>> +
>> +static const struct component_ops vimc_cap_comp_ops = {
>> +    .bind = vimc_cap_comp_bind,
>> +    .unbind = vimc_cap_comp_unbind,
>> +};
>> +
>> +static int vimc_cap_probe(struct platform_device *pdev)
>> +{
>> +    return component_add(&pdev->dev, &vimc_cap_comp_ops);
>>   }
>> +
>> +static int vimc_cap_remove(struct platform_device *pdev)
>> +{
>> +    component_del(&pdev->dev, &vimc_cap_comp_ops);
>> +
>> +    return 0;
>> +}
>> +
>> +static struct platform_driver vimc_cap_pdrv = {
>> +    .probe        = vimc_cap_probe,
>> +    .remove        = vimc_cap_remove,
>> +    .driver        = {
>> +        .name    = VIMC_CAP_DRV_NAME,
>> +    },
>> +};
>> +
>> +static const struct platform_device_id vimc_cap_driver_ids[] = {
>> +    {
>> +        .name           = VIMC_CAP_DRV_NAME,
>> +    },
>> +    { }
>> +};
>> +
>> +module_platform_driver(vimc_cap_pdrv);
>> +
>> +MODULE_DEVICE_TABLE(platform, vimc_cap_driver_ids);
>> +
>> +MODULE_DESCRIPTION("Virtual Media Controller Driver (VIMC) Capture");
>> +MODULE_AUTHOR("Helen Mae Koike Fornazier <helen.fornazier@gmail.com>");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/media/platform/vimc/vimc-capture.h
>> b/drivers/media/platform/vimc/vimc-capture.h
>> deleted file mode 100644
>> index 7e5c707..0000000
>> --- a/drivers/media/platform/vimc/vimc-capture.h
>> +++ /dev/null
>> @@ -1,28 +0,0 @@
>> -/*
>> - * vimc-capture.h Virtual Media Controller Driver
>> - *
>> - * Copyright (C) 2015-2017 Helen Koike <helen.fornazier@gmail.com>
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License as published by
>> - * the Free Software Foundation; either version 2 of the License, or
>> - * (at your option) any later version.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - */
>> -
>> -#ifndef _VIMC_CAPTURE_H_
>> -#define _VIMC_CAPTURE_H_
>> -
>> -#include "vimc-common.h"
>> -
>> -struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
>> -                    const char *const name,
>> -                    u16 num_pads,
>> -                    const unsigned long *pads_flag);
>> -
>> -#endif
>> diff --git a/drivers/media/platform/vimc/vimc-common.c
>> b/drivers/media/platform/vimc/vimc-common.c
>> index ff59e09..d5ed387 100644
>> --- a/drivers/media/platform/vimc/vimc-common.c
>> +++ b/drivers/media/platform/vimc/vimc-common.c
>> @@ -15,6 +15,9 @@
>>    *
>>    */
>>   +#include <linux/init.h>
>> +#include <linux/module.h>
>> +
>>   #include "vimc-common.h"
>>     static const struct vimc_pix_map vimc_pix_map_list[] = {
>> @@ -151,6 +154,7 @@ const struct vimc_pix_map
>> *vimc_pix_map_by_index(unsigned int i)
>>         return &vimc_pix_map_list[i];
>>   }
>> +EXPORT_SYMBOL(vimc_pix_map_by_index);
>
> I would recommend using EXPORT_SYMBOL_GPL.
>
>>     const struct vimc_pix_map *vimc_pix_map_by_code(u32 code)
>>   {
>> @@ -162,6 +166,7 @@ const struct vimc_pix_map
>> *vimc_pix_map_by_code(u32 code)
>>       }
>>       return NULL;
>>   }
>> +EXPORT_SYMBOL(vimc_pix_map_by_code);
>>     const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32
>> pixelformat)
>>   {
>> @@ -173,6 +178,7 @@ const struct vimc_pix_map
>> *vimc_pix_map_by_pixelformat(u32 pixelformat)
>>       }
>>       return NULL;
>>   }
>> +EXPORT_SYMBOL(vimc_pix_map_by_pixelformat);
>>     int vimc_propagate_frame(struct media_pad *src, const void *frame)
>>   {
>> @@ -207,6 +213,7 @@ int vimc_propagate_frame(struct media_pad *src,
>> const void *frame)
>>         return 0;
>>   }
>> +EXPORT_SYMBOL(vimc_propagate_frame);
>>     /* Helper function to allocate and initialize pads */
>>   struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long
>> *pads_flag)
>> @@ -227,6 +234,7 @@ struct media_pad *vimc_pads_init(u16 num_pads,
>> const unsigned long *pads_flag)
>>         return pads;
>>   }
>> +EXPORT_SYMBOL(vimc_pads_init);
>>     int vimc_pipeline_s_stream(struct media_entity *ent, int enable)
>>   {
>> @@ -242,14 +250,8 @@ int vimc_pipeline_s_stream(struct media_entity
>> *ent, int enable)
>>           /* Start the stream in the subdevice direct connected */
>>           pad = media_entity_remote_pad(&ent->pads[i]);
>>   -        /*
>> -         * if this is a raw node from vimc-core, then there is
>> -         * nothing to activate
>> -         * TODO: remove this when there are no more raw nodes in the
>> -         * core and return error instead
>> -         */
>> -        if (pad->entity->obj_type == MEDIA_ENTITY_TYPE_BASE)
>> -            continue;
>> +        if (!is_media_entity_v4l2_subdev(pad->entity))
>> +            return -EINVAL;
>>             sd = media_entity_to_v4l2_subdev(pad->entity);
>>           ret = v4l2_subdev_call(sd, video, s_stream, enable);
>> @@ -259,6 +261,7 @@ int vimc_pipeline_s_stream(struct media_entity
>> *ent, int enable)
>>         return 0;
>>   }
>> +EXPORT_SYMBOL(vimc_pipeline_s_stream);
>>     static void vimc_fmt_pix_to_mbus(struct v4l2_mbus_framefmt *mfmt,
>>                    struct v4l2_pix_format *pfmt)
>> @@ -315,14 +318,6 @@ int vimc_link_validate(struct media_link *link)
>>       struct v4l2_subdev_format source_fmt, sink_fmt;
>>       int ret;
>>   -    /*
>> -     * if it is a raw node from vimc-core, ignore the link for now
>> -     * TODO: remove this when there are no more raw nodes in the
>> -     * core and return error instead
>> -     */
>> -    if (link->source->entity->obj_type == MEDIA_ENTITY_TYPE_BASE)
>> -        return 0;
>> -
>>       ret = vimc_get_mbus_format(link->source, &source_fmt);
>>       if (ret)
>>           return ret;
>> @@ -393,8 +388,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
>>                u32 function,
>>                u16 num_pads,
>>                const unsigned long *pads_flag,
>> -             const struct v4l2_subdev_ops *sd_ops,
>> -             void (*sd_destroy)(struct vimc_ent_device *))
>> +             const struct v4l2_subdev_ops *sd_ops)
>>   {
>>       int ret;
>>   @@ -404,7 +398,6 @@ int vimc_ent_sd_register(struct vimc_ent_device
>> *ved,
>>           return PTR_ERR(ved->pads);
>>         /* Fill the vimc_ent_device struct */
>> -    ved->destroy = sd_destroy;
>>       ved->ent = &sd->entity;
>>         /* Initialize the subdev */
>> @@ -440,6 +433,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
>>       vimc_pads_cleanup(ved->pads);
>>       return ret;
>>   }
>> +EXPORT_SYMBOL(vimc_ent_sd_register);
>>     void vimc_ent_sd_unregister(struct vimc_ent_device *ved, struct
>> v4l2_subdev *sd)
>>   {
>> @@ -447,3 +441,8 @@ void vimc_ent_sd_unregister(struct vimc_ent_device
>> *ved, struct v4l2_subdev *sd)
>>       media_entity_cleanup(ved->ent);
>>       vimc_pads_cleanup(ved->pads);
>>   }
>> +EXPORT_SYMBOL(vimc_ent_sd_unregister);
>> +
>> +MODULE_DESCRIPTION("Virtual Media Controller Driver (VIMC) Common");
>> +MODULE_AUTHOR("Helen Koike <helen.fornazier@gmail.com>");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/media/platform/vimc/vimc-common.h
>> b/drivers/media/platform/vimc/vimc-common.h
>> index 5b2691e..27c9b8c 100644
>> --- a/drivers/media/platform/vimc/vimc-common.h
>> +++ b/drivers/media/platform/vimc/vimc-common.h
>> @@ -1,5 +1,5 @@
>>   /*
>> - * vimc-ccommon.h Virtual Media Controller Driver
>> + * vimc-common.h Virtual Media Controller Driver
>>    *
>>    * Copyright (C) 2015-2017 Helen Koike <helen.fornazier@gmail.com>
>>    *
>> @@ -50,7 +50,6 @@ struct vimc_pix_map {
>>    *
>>    * @ent:        the pointer to struct media_entity for the node
>>    * @pads:        the list of pads of the node
>> - * @destroy:        callback to destroy the node
>>    * @process_frame:    callback send a frame to that node
>>    * @vdev_get_format:    callback that returns the current format a
>> pad, used
>>    *            only when is_media_entity_v4l2_video_device(ent) returns
>> @@ -67,7 +66,6 @@ struct vimc_pix_map {
>>   struct vimc_ent_device {
>>       struct media_entity *ent;
>>       struct media_pad *pads;
>> -    void (*destroy)(struct vimc_ent_device *);
>>       void (*process_frame)(struct vimc_ent_device *ved,
>>                     struct media_pad *sink, const void *frame);
>>       void (*vdev_get_format)(struct vimc_ent_device *ved,
>> @@ -152,7 +150,6 @@ const struct vimc_pix_map
>> *vimc_pix_map_by_pixelformat(u32 pixelformat);
>>    * @num_pads:    number of pads to initialize
>>    * @pads_flag:    flags to use in each pad
>>    * @sd_ops:    pointer to &struct v4l2_subdev_ops.
>> - * @sd_destroy:    callback to destroy the node
>>    *
>>    * Helper function initialize and register the struct
>> vimc_ent_device and struct
>>    * v4l2_subdev which represents a subdev node in the topology
>> @@ -164,14 +161,13 @@ int vimc_ent_sd_register(struct vimc_ent_device
>> *ved,
>>                u32 function,
>>                u16 num_pads,
>>                const unsigned long *pads_flag,
>> -             const struct v4l2_subdev_ops *sd_ops,
>> -             void (*sd_destroy)(struct vimc_ent_device *));
>> +             const struct v4l2_subdev_ops *sd_ops);
>>     /**
>> - * vimc_ent_sd_register - initialize and register a subdev node
>> + * vimc_ent_sd_unregister - cleanup and unregister a subdev node
>>    *
>> - * @ved:    the vimc_ent_device struct to be initialize
>> - * @sd:        the v4l2_subdev struct to be initialize and registered
>> + * @ved:    the vimc_ent_device struct to be cleaned up
>> + * @sd:        the v4l2_subdev struct to be unregistered
>>    *
>>    * Helper function cleanup and unregister the struct vimc_ent_device
>> and struct
>>    * v4l2_subdev which represents a subdev node in the topology
>> diff --git a/drivers/media/platform/vimc/vimc-core.c
>> b/drivers/media/platform/vimc/vimc-core.c
>> index afc79e2..6148c3e 100644
>> --- a/drivers/media/platform/vimc/vimc-core.c
>> +++ b/drivers/media/platform/vimc/vimc-core.c
>> @@ -15,15 +15,14 @@
>>    *
>>    */
>>   +#include <linux/component.h>
>>   #include <linux/init.h>
>>   #include <linux/module.h>
>>   #include <linux/platform_device.h>
>>   #include <media/media-device.h>
>>   #include <media/v4l2-device.h>
>>   -#include "vimc-capture.h"
>>   #include "vimc-common.h"
>> -#include "vimc-sensor.h"
>>     #define VIMC_PDEV_NAME "vimc"
>>   #define VIMC_MDEV_MODEL_NAME "VIMC MDEV"
>> @@ -37,10 +36,10 @@
>>   }
>>     struct vimc_device {
>> -    /*
>> -     * The pipeline configuration
>> -     * (filled before calling vimc_device_register)
>> -     */
>> +    /* The platform device */
>> +    struct platform_device pdev;
>> +
>> +    /* The pipeline configuration */
>>       const struct vimc_pipeline_config *pipe_cfg;
>>         /* The Associated media_device parent */
>> @@ -49,43 +48,14 @@ struct vimc_device {
>>       /* Internal v4l2 parent device*/
>>       struct v4l2_device v4l2_dev;
>>   -    /* Internal topology */
>> -    struct vimc_ent_device **ved;
>> -};
>> -
>> -/**
>> - * enum vimc_ent_node - Select the functionality of a node in the
>> topology
>> - * @VIMC_ENT_NODE_SENSOR:    A node of type SENSOR simulates a camera
>> sensor
>> - *                generating internal images in bayer format and
>> - *                propagating those images through the pipeline
>> - * @VIMC_ENT_NODE_CAPTURE:    A node of type CAPTURE is a v4l2
>> video_device
>> - *                that exposes the received image from the
>> - *                pipeline to the user space
>> - * @VIMC_ENT_NODE_INPUT:    A node of type INPUT is a v4l2
>> video_device that
>> - *                receives images from the user space and
>> - *                propagates them through the pipeline
>> - * @VIMC_ENT_NODE_DEBAYER:    A node type DEBAYER expects to receive
>> a frame
>> - *                in bayer format converts it to RGB
>> - * @VIMC_ENT_NODE_SCALER:    A node of type SCALER scales the
>> received image
>> - *                by a given multiplier
>> - *
>> - * This enum is used in the entity configuration struct to allow the
>> definition
>> - * of a custom topology specifying the role of each node on it.
>> - */
>> -enum vimc_ent_node {
>> -    VIMC_ENT_NODE_SENSOR,
>> -    VIMC_ENT_NODE_CAPTURE,
>> -    VIMC_ENT_NODE_INPUT,
>> -    VIMC_ENT_NODE_DEBAYER,
>> -    VIMC_ENT_NODE_SCALER,
>> +    /* Subdevices */
>> +    struct platform_device **subdevs;
>>   };
>>     /* Structure which describes individual configuration for each
>> entity */
>>   struct vimc_ent_config {
>>       const char *name;
>> -    size_t pads_qty;
>> -    const unsigned long *pads_flag;
>> -    enum vimc_ent_node node;
>> +    const char *drv;
>>   };
>>     /* Structure which describes links between entities */
>> @@ -112,60 +82,40 @@ struct vimc_pipeline_config {
>>   static const struct vimc_ent_config ent_config[] = {
>>       {
>>           .name = "Sensor A",
>> -        .pads_qty = 1,
>> -        .pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
>> -        .node = VIMC_ENT_NODE_SENSOR,
>> +        .drv = "vimc-sensor",
>>       },
>>       {
>>           .name = "Sensor B",
>> -        .pads_qty = 1,
>> -        .pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
>> -        .node = VIMC_ENT_NODE_SENSOR,
>> +        .drv = "vimc-sensor",
>>       },
>>       {
>>           .name = "Debayer A",
>> -        .pads_qty = 2,
>> -        .pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
>> -                             MEDIA_PAD_FL_SOURCE},
>> -        .node = VIMC_ENT_NODE_DEBAYER,
>> +        .drv = "vimc-debayer",
>>       },
>>       {
>>           .name = "Debayer B",
>> -        .pads_qty = 2,
>> -        .pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
>> -                             MEDIA_PAD_FL_SOURCE},
>> -        .node = VIMC_ENT_NODE_DEBAYER,
>> +        .drv = "vimc-debayer",
>>       },
>>       {
>>           .name = "Raw Capture 0",
>> -        .pads_qty = 1,
>> -        .pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
>> -        .node = VIMC_ENT_NODE_CAPTURE,
>> +        .drv = "vimc-capture",
>>       },
>>       {
>>           .name = "Raw Capture 1",
>> -        .pads_qty = 1,
>> -        .pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
>> -        .node = VIMC_ENT_NODE_CAPTURE,
>> +        .drv = "vimc-capture",
>>       },
>>       {
>>           .name = "RGB/YUV Input",
>> -        .pads_qty = 1,
>> -        .pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
>> -        .node = VIMC_ENT_NODE_INPUT,
>> +        /* TODO: change to vimc-output when output is implemented */
>> +        .drv = "vimc-sensor",
>
> This is confusing: the name indicates an input, but the TODO indicates an
> output. I assume this is supposed to emulate e.g. an HDMI input? I'm not
> sure
> the TODO text makes sense here.

You are right, I was confused about input/output in the pov of kernel or 
userspace and I was with HDMI output in mind (I even implement it, I'll 
send in the next patch series).
I'll change this comment to "change to vimc-input when input is implemented"


>
>>       },
>>       {
>>           .name = "Scaler",
>> -        .pads_qty = 2,
>> -        .pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
>> -                             MEDIA_PAD_FL_SOURCE},
>> -        .node = VIMC_ENT_NODE_SCALER,
>> +        .drv = "vimc-scaler",
>>       },
>>       {
>>           .name = "RGB/YUV Capture",
>> -        .pads_qty = 1,
>> -        .pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
>> -        .node = VIMC_ENT_NODE_CAPTURE,
>> +        .drv = "vimc-capture",
>>       },
>>   };
>>   @@ -197,111 +147,40 @@ static const struct vimc_pipeline_config
>> pipe_cfg = {
>>     /*
>> --------------------------------------------------------------------------
>> */
>>   -static void vimc_device_unregister(struct vimc_device *vimc)
>> +static int vimc_create_links(struct vimc_device *vimc)
>>   {
>>       unsigned int i;
>> -
>> -    media_device_unregister(&vimc->mdev);
>> -    /* Cleanup (only initialized) entities */
>> -    for (i = 0; i < vimc->pipe_cfg->num_ents; i++) {
>> -        if (vimc->ved[i] && vimc->ved[i]->destroy)
>> -            vimc->ved[i]->destroy(vimc->ved[i]);
>> -
>> -        vimc->ved[i] = NULL;
>> -    }
>> -    v4l2_device_unregister(&vimc->v4l2_dev);
>> -    media_device_cleanup(&vimc->mdev);
>> -}
>> -
>> -/*
>> - * TODO: remove this function when all the
>> - * entities specific code are implemented
>> - */
>> -static void vimc_raw_destroy(struct vimc_ent_device *ved)
>> -{
>> -    media_device_unregister_entity(ved->ent);
>> -
>> -    media_entity_cleanup(ved->ent);
>> -
>> -    vimc_pads_cleanup(ved->pads);
>> -
>> -    kfree(ved->ent);
>> -
>> -    kfree(ved);
>> -}
>> -
>> -/*
>> - * TODO: remove this function when all the
>> - * entities specific code are implemented
>> - */
>> -static struct vimc_ent_device *vimc_raw_create(struct v4l2_device
>> *v4l2_dev,
>> -                           const char *const name,
>> -                           u16 num_pads,
>> -                           const unsigned long *pads_flag)
>> -{
>> -    struct vimc_ent_device *ved;
>>       int ret;
>>   -    /* Allocate the main ved struct */
>> -    ved = kzalloc(sizeof(*ved), GFP_KERNEL);
>> -    if (!ved)
>> -        return ERR_PTR(-ENOMEM);
>> -
>> -    /* Allocate the media entity */
>> -    ved->ent = kzalloc(sizeof(*ved->ent), GFP_KERNEL);
>> -    if (!ved->ent) {
>> -        ret = -ENOMEM;
>> -        goto err_free_ved;
>> -    }
>> -
>> -    /* Allocate the pads */
>> -    ved->pads = vimc_pads_init(num_pads, pads_flag);
>> -    if (IS_ERR(ved->pads)) {
>> -        ret = PTR_ERR(ved->pads);
>> -        goto err_free_ent;
>> +    /* Initialize the links between entities */
>> +    for (i = 0; i < vimc->pipe_cfg->num_links; i++) {
>> +        const struct vimc_ent_link *link = &vimc->pipe_cfg->links[i];
>> +        /*
>> +         * TODO: Check another way of retrieving ved struct without
>> +         * relying on platform_get_drvdata
>> +         */
>> +        struct vimc_ent_device *ved_src =
>> +            platform_get_drvdata(vimc->subdevs[link->src_ent]);
>> +        struct vimc_ent_device *ved_sink =
>> +            platform_get_drvdata(vimc->subdevs[link->sink_ent]);
>> +
>> +        ret = media_create_pad_link(ved_src->ent, link->src_pad,
>> +                        ved_sink->ent, link->sink_pad,
>> +                        link->flags);
>> +        if (ret)
>> +            return ret;
>>       }
>>   -    /* Initialize the media entity */
>> -    ved->ent->name = name;
>> -    ved->ent->function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
>> -    ret = media_entity_pads_init(ved->ent, num_pads, ved->pads);
>> -    if (ret)
>> -        goto err_cleanup_pads;
>> -
>> -    /* Register the media entity */
>> -    ret = media_device_register_entity(v4l2_dev->mdev, ved->ent);
>> -    if (ret)
>> -        goto err_cleanup_entity;
>> -
>> -    /* Fill out the destroy function and return */
>> -    ved->destroy = vimc_raw_destroy;
>> -    return ved;
>> -
>> -err_cleanup_entity:
>> -    media_entity_cleanup(ved->ent);
>> -err_cleanup_pads:
>> -    vimc_pads_cleanup(ved->pads);
>> -err_free_ent:
>> -    kfree(ved->ent);
>> -err_free_ved:
>> -    kfree(ved);
>> -
>> -    return ERR_PTR(ret);
>> +    return 0;
>>   }
>>   -static int vimc_device_register(struct vimc_device *vimc)
>> +static int vimc_comp_bind(struct device *master)
>>   {
>> -    unsigned int i;
>> +    struct vimc_device *vimc = container_of(to_platform_device(master),
>> +                        struct vimc_device, pdev);
>>       int ret;
>>   -    /* Allocate memory for the vimc_ent_devices pointers */
>> -    vimc->ved = devm_kcalloc(vimc->mdev.dev, vimc->pipe_cfg->num_ents,
>> -                 sizeof(*vimc->ved), GFP_KERNEL);
>> -    if (!vimc->ved)
>> -        return -ENOMEM;
>> -
>> -    /* Link the media device within the v4l2_device */
>> -    vimc->v4l2_dev.mdev = &vimc->mdev;
>> +    dev_dbg(master, "bind");
>>         /* Register the v4l2 struct */
>>       ret = v4l2_device_register(vimc->mdev.dev, &vimc->v4l2_dev);
>> @@ -311,66 +190,22 @@ static int vimc_device_register(struct
>> vimc_device *vimc)
>>           return ret;
>>       }
>>   -    /* Initialize entities */
>> -    for (i = 0; i < vimc->pipe_cfg->num_ents; i++) {
>> -        struct vimc_ent_device *(*create_func)(struct v4l2_device *,
>> -                               const char *const,
>> -                               u16,
>> -                               const unsigned long *);
>> -
>> -        /* Register the specific node */
>> -        switch (vimc->pipe_cfg->ents[i].node) {
>> -        case VIMC_ENT_NODE_SENSOR:
>> -            create_func = vimc_sen_create;
>> -            break;
>> -
>> -        case VIMC_ENT_NODE_CAPTURE:
>> -            create_func = vimc_cap_create;
>> -            break;
>> -
>> -        /* TODO: Instantiate the specific topology node */
>> -        case VIMC_ENT_NODE_INPUT:
>> -        case VIMC_ENT_NODE_DEBAYER:
>> -        case VIMC_ENT_NODE_SCALER:
>> -        default:
>> -            /*
>> -             * TODO: remove this when all the entities specific
>> -             * code are implemented
>> -             */
>> -            create_func = vimc_raw_create;
>> -            break;
>> -        }
>> -
>> -        vimc->ved[i] = create_func(&vimc->v4l2_dev,
>> -                       vimc->pipe_cfg->ents[i].name,
>> -                       vimc->pipe_cfg->ents[i].pads_qty,
>> -                       vimc->pipe_cfg->ents[i].pads_flag);
>> -        if (IS_ERR(vimc->ved[i])) {
>> -            ret = PTR_ERR(vimc->ved[i]);
>> -            vimc->ved[i] = NULL;
>> -            goto err;
>> -        }
>> -    }
>> -
>> -    /* Initialize the links between entities */
>> -    for (i = 0; i < vimc->pipe_cfg->num_links; i++) {
>> -        const struct vimc_ent_link *link = &vimc->pipe_cfg->links[i];
>> +    /* Bind subdevices */
>> +    ret = component_bind_all(master, &vimc->v4l2_dev);
>> +    if (ret)
>> +        goto err_v4l2_unregister;
>>   -        ret = media_create_pad_link(vimc->ved[link->src_ent]->ent,
>> -                        link->src_pad,
>> -                        vimc->ved[link->sink_ent]->ent,
>> -                        link->sink_pad,
>> -                        link->flags);
>> -        if (ret)
>> -            goto err;
>> -    }
>> +    /* Initialize links */
>> +    ret = vimc_create_links(vimc);
>> +    if (ret)
>> +        goto err_comp_unbind_all;
>>         /* Register the media device */
>>       ret = media_device_register(&vimc->mdev);
>>       if (ret) {
>>           dev_err(vimc->mdev.dev,
>>               "media device register failed (err=%d)\n", ret);
>> -        return ret;
>> +        goto err_comp_unbind_all;
>>       }
>>         /* Expose all subdev's nodes*/
>> @@ -379,32 +214,107 @@ static int vimc_device_register(struct
>> vimc_device *vimc)
>>           dev_err(vimc->mdev.dev,
>>               "vimc subdev nodes registration failed (err=%d)\n",
>>               ret);
>> -        goto err;
>> +        goto err_mdev_unregister;
>>       }
>>         return 0;
>>   -err:
>> -    /* Destroy the so far created topology */
>> -    vimc_device_unregister(vimc);
>> +err_mdev_unregister:
>> +    media_device_unregister(&vimc->mdev);
>> +err_comp_unbind_all:
>> +    component_unbind_all(master, NULL);
>> +err_v4l2_unregister:
>> +    v4l2_device_unregister(&vimc->v4l2_dev);
>>         return ret;
>>   }
>>   +static void vimc_comp_unbind(struct device *master)
>> +{
>> +    struct vimc_device *vimc = container_of(to_platform_device(master),
>> +                        struct vimc_device, pdev);
>> +
>> +    dev_dbg(master, "unbind");
>> +
>> +    media_device_unregister(&vimc->mdev);
>> +    component_unbind_all(master, NULL);
>> +    v4l2_device_unregister(&vimc->v4l2_dev);
>> +}
>> +
>> +static int vimc_comp_compare(struct device *comp, void *data)
>> +{
>> +    const struct platform_device *pdev = to_platform_device(comp);
>> +    const char *name = data;
>> +
>> +    return !strcmp(pdev->dev.platform_data, name);
>> +}
>> +
>> +static struct component_match *vimc_add_subdevs(struct vimc_device
>> *vimc)
>> +{
>> +    struct component_match *match = NULL;
>> +    unsigned int i;
>> +
>> +    for (i = 0; i < vimc->pipe_cfg->num_ents; i++) {
>> +        dev_dbg(&vimc->pdev.dev, "new pdev for %s\n",
>> +            vimc->pipe_cfg->ents[i].drv);
>> +
>> +        /*
>> +         * TODO: check if using platform_data is indeed the best way to
>> +         * pass the name to the driver or if we should add the drv name
>> +         * in the platform_device_id table
>> +         */
>
> Didn't you set the drv name in the platform_device_id table already?

I refer to the name of the entity, there is the name that identifies the 
driver as "vimc-sensor" that is set in the platform_device_id table but 
there is also the custom name of the entity e.g. "My Sensor A" that I 
need to inform to the vimc-sensor driver.

>
> Using platform_data feels like an abuse to be honest.

Another option would be to make the vimc-sensor driver to populate the 
entity name automatically as "Sensor x", where x could be the entity 
number, but I don't think this is a good option.

>
> Creating these components here makes sense. Wouldn't it also make sense
> to use
> v4l2_async to wait until they have all been bound? It would more closely
> emulate
> standard drivers. Apologies if I misunderstand what is happening here.

I am using linux/component.h for that, when all devices are present and 
all modules are loaded, the component.h system brings up the core by 
calling vimc_comp_bind() function, which calls component_bind_all() to 
call the binding function of each module, then it finishes registering 
the topology.
If any one of the components or module is unload, the component system 
takes down the entire topology calling component_unbind_all which calls 
the unbind functions from each module.
This makes sure that the media device, subdevices and video device are 
only registered in the v4l2 system if all the modules are loaded.

I wans't familiar with v4l2-async.h, but from a quick look it seems that 
it only works with struct v4l2_subdev, but I'll also need for struct 
video_device (for the capture node for example).
And also, if a module is missing we would have vimc partially 
registered, e.g. the debayer could be registered at /dev/subdevX but the 
sensor not yet and the media wouldn't be ready, I am not sure if this is 
a problem though.

Maybe we can use component.h for now, then I can implement 
v4l2_async_{un}register_video_device and migrate to v4l2-sync.h latter. 
What do you think?


>
>> +        vimc->subdevs[i] =
>> platform_device_register_data(&vimc->pdev.dev,
>> +                vimc->pipe_cfg->ents[i].drv,
>> +                PLATFORM_DEVID_AUTO,
>> +                vimc->pipe_cfg->ents[i].name,
>> +                strlen(vimc->pipe_cfg->ents[i].name) + 1);
>> +        if (!vimc->subdevs[i]) {
>> +            while (--i >= 0)
>> +                platform_device_unregister(vimc->subdevs[i]);
>> +
>> +            return ERR_PTR(-ENOMEM);
>> +        }
>> +
>> +        component_match_add(&vimc->pdev.dev, &match, vimc_comp_compare,
>> +                    (void *)vimc->pipe_cfg->ents[i].name);
>> +    }
>> +
>> +    return match;
>> +}
>> +
>> +static void vimc_rm_subdevs(struct vimc_device *vimc)
>> +{
>> +    unsigned int i;
>> +
>> +    for (i = 0; i < vimc->pipe_cfg->num_ents; i++)
>> +        platform_device_unregister(vimc->subdevs[i]);
>> +}
>> +
>> +static const struct component_master_ops vimc_comp_ops = {
>> +    .bind = vimc_comp_bind,
>> +    .unbind = vimc_comp_unbind,
>> +};
>> +
>>   static int vimc_probe(struct platform_device *pdev)
>>   {
>> -    struct vimc_device *vimc;
>> +    struct vimc_device *vimc = container_of(pdev, struct vimc_device,
>> pdev);
>> +    struct component_match *match = NULL;
>>       int ret;
>>   -    /* Prepare the vimc topology structure */
>> +    dev_dbg(&pdev->dev, "probe");
>>   -    /* Allocate memory for the vimc structure */
>> -    vimc = kzalloc(sizeof(*vimc), GFP_KERNEL);
>> -    if (!vimc)
>> +    /* Create platform_device for each entity in the topology*/
>> +    vimc->subdevs = devm_kcalloc(&vimc->pdev.dev,
>> vimc->pipe_cfg->num_ents,
>> +                     sizeof(*vimc->subdevs), GFP_KERNEL);
>> +    if (!vimc->subdevs)
>>           return -ENOMEM;
>>   -    /* Set the pipeline configuration struct */
>> -    vimc->pipe_cfg = &pipe_cfg;
>> +    match = vimc_add_subdevs(vimc);
>> +    if (IS_ERR(match))
>> +        return PTR_ERR(match);
>> +
>> +    /* Link the media device within the v4l2_device */
>> +    vimc->v4l2_dev.mdev = &vimc->mdev;
>>         /* Initialize media device */
>>       strlcpy(vimc->mdev.model, VIMC_MDEV_MODEL_NAME,
>> @@ -412,28 +322,27 @@ static int vimc_probe(struct platform_device *pdev)
>>       vimc->mdev.dev = &pdev->dev;
>>       media_device_init(&vimc->mdev);
>>   -    /* Create vimc topology */
>> -    ret = vimc_device_register(vimc);
>> +    /* Add self to the component system */
>> +    ret = component_master_add_with_match(&pdev->dev, &vimc_comp_ops,
>> +                          match);
>>       if (ret) {
>> -        dev_err(vimc->mdev.dev,
>> -            "vimc device registration failed (err=%d)\n", ret);
>> +        media_device_cleanup(&vimc->mdev);
>> +        vimc_rm_subdevs(vimc);
>>           kfree(vimc);
>>           return ret;
>>       }
>>   -    /* Link the topology object with the platform device object */
>> -    platform_set_drvdata(pdev, vimc);
>> -
>>       return 0;
>>   }
>>     static int vimc_remove(struct platform_device *pdev)
>>   {
>> -    struct vimc_device *vimc = platform_get_drvdata(pdev);
>> +    struct vimc_device *vimc = container_of(pdev, struct vimc_device,
>> pdev);
>>   -    /* Destroy all the topology */
>> -    vimc_device_unregister(vimc);
>> -    kfree(vimc);
>> +    dev_dbg(&pdev->dev, "remove");
>> +
>> +    component_master_del(&pdev->dev, &vimc_comp_ops);
>> +    vimc_rm_subdevs(vimc);
>>         return 0;
>>   }
>> @@ -442,9 +351,12 @@ static void vimc_dev_release(struct device *dev)
>>   {
>>   }
>>   -static struct platform_device vimc_pdev = {
>> -    .name        = VIMC_PDEV_NAME,
>> -    .dev.release    = vimc_dev_release,
>> +static struct vimc_device vimc_dev = {
>> +    .pipe_cfg = &pipe_cfg,
>> +    .pdev = {
>> +        .name = VIMC_PDEV_NAME,
>> +        .dev.release = vimc_dev_release,
>> +    }
>>   };
>>     static struct platform_driver vimc_pdrv = {
>> @@ -459,29 +371,29 @@ static int __init vimc_init(void)
>>   {
>>       int ret;
>>   -    ret = platform_device_register(&vimc_pdev);
>> +    ret = platform_device_register(&vimc_dev.pdev);
>>       if (ret) {
>> -        dev_err(&vimc_pdev.dev,
>> +        dev_err(&vimc_dev.pdev.dev,
>>               "platform device registration failed (err=%d)\n", ret);
>>           return ret;
>>       }
>>         ret = platform_driver_register(&vimc_pdrv);
>>       if (ret) {
>> -        dev_err(&vimc_pdev.dev,
>> +        dev_err(&vimc_dev.pdev.dev,
>>               "platform driver registration failed (err=%d)\n", ret);
>> -
>> -        platform_device_unregister(&vimc_pdev);
>> +        platform_driver_unregister(&vimc_pdrv);
>> +        return ret;
>>       }
>>   -    return ret;
>> +    return 0;
>>   }
>>     static void __exit vimc_exit(void)
>>   {
>>       platform_driver_unregister(&vimc_pdrv);
>>   -    platform_device_unregister(&vimc_pdev);
>> +    platform_device_unregister(&vimc_dev.pdev);
>>   }
>>     module_init(vimc_init);
>> diff --git a/drivers/media/platform/vimc/vimc-sensor.c
>> b/drivers/media/platform/vimc/vimc-sensor.c
>> index df89ee7..7f16978 100644
>> --- a/drivers/media/platform/vimc/vimc-sensor.c
>> +++ b/drivers/media/platform/vimc/vimc-sensor.c
>> @@ -15,15 +15,19 @@
>>    *
>>    */
>>   -#include <linux/module.h>
>> +#include <linux/component.h>
>>   #include <linux/freezer.h>
>>   #include <linux/kthread.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>>   #include <linux/v4l2-mediabus.h>
>>   #include <linux/vmalloc.h>
>>   #include <media/v4l2-subdev.h>
>>   #include <media/v4l2-tpg.h>
>>   -#include "vimc-sensor.h"
>> +#include "vimc-common.h"
>> +
>> +#define VIMC_SEN_DRV_NAME "vimc-sensor"
>>     static bool vsen_tpg;
>>   module_param(vsen_tpg, bool, 0000);
>> @@ -35,6 +39,7 @@ MODULE_PARM_DESC(vsen_tpg, " generate image from
>> sensor node\n"
>>   struct vimc_sen_device {
>>       struct vimc_ent_device ved;
>>       struct v4l2_subdev sd;
>> +    struct device *dev;
>>       struct tpg_data tpg;
>>       struct task_struct *kthread_sen;
>>       u8 *frame;
>> @@ -189,7 +194,7 @@ static int vimc_sen_set_fmt(struct v4l2_subdev *sd,
>>       /* Set the new format */
>>       vimc_sen_adjust_fmt(&fmt->format);
>>   -    dev_dbg(vsen->sd.v4l2_dev->mdev->dev, "%s: format update: "
>> +    dev_dbg(vsen->dev, "%s: format update: "
>>           "old:%dx%d (0x%x, %d, %d, %d, %d) "
>>           "new:%dx%d (0x%x, %d, %d, %d, %d)\n", vsen->sd.name,
>>           /* old */
>> @@ -282,8 +287,8 @@ static int vimc_sen_s_stream(struct v4l2_subdev
>> *sd, int enable)
>>           vsen->kthread_sen = kthread_run(vimc_sen_tpg_thread, vsen,
>>                       "%s-sen", vsen->sd.v4l2_dev->name);
>>           if (IS_ERR(vsen->kthread_sen)) {
>> -            dev_err(vsen->sd.v4l2_dev->dev,
>> -                "%s: kernel_thread() failed\n",    vsen->sd.name);
>> +            dev_err(vsen->dev, "%s: kernel_thread() failed\n",
>> +                vsen->sd.name);
>>               vfree(vsen->frame);
>>               vsen->frame = NULL;
>>               return PTR_ERR(vsen->kthread_sen);
>> @@ -315,8 +320,10 @@ static const struct v4l2_subdev_ops vimc_sen_ops = {
>>       .video = &vimc_sen_video_ops,
>>   };
>>   -static void vimc_sen_destroy(struct vimc_ent_device *ved)
>> +static void vimc_sen_comp_unbind(struct device *comp, struct device
>> *master,
>> +                 void *master_data)
>>   {
>> +    struct vimc_ent_device *ved = dev_get_drvdata(comp);
>>       struct vimc_sen_device *vsen =
>>                   container_of(ved, struct vimc_sen_device, ved);
>>   @@ -326,36 +333,30 @@ static void vimc_sen_destroy(struct
>> vimc_ent_device *ved)
>>       kfree(vsen);
>>   }
>>   -struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
>> -                    const char *const name,
>> -                    u16 num_pads,
>> -                    const unsigned long *pads_flag)
>> +static int vimc_sen_comp_bind(struct device *comp, struct device
>> *master,
>> +                  void *master_data)
>>   {
>> +    struct v4l2_device *v4l2_dev = master_data;
>> +    char *name = comp->platform_data;
>>       struct vimc_sen_device *vsen;
>> -    unsigned int i;
>>       int ret;
>>   -    /* NOTE: a sensor node may be created with more then one pad */
>> -    if (!name || !num_pads || !pads_flag)
>> -        return ERR_PTR(-EINVAL);
>> -
>> -    /* check if all pads are sources */
>> -    for (i = 0; i < num_pads; i++)
>> -        if (!(pads_flag[i] & MEDIA_PAD_FL_SOURCE))
>> -            return ERR_PTR(-EINVAL);
>> -
>>       /* Allocate the vsen struct */
>>       vsen = kzalloc(sizeof(*vsen), GFP_KERNEL);
>>       if (!vsen)
>> -        return ERR_PTR(-ENOMEM);
>> +        return -ENOMEM;
>>         /* Initialize ved and sd */
>>       ret = vimc_ent_sd_register(&vsen->ved, &vsen->sd, v4l2_dev, name,
>> -                   MEDIA_ENT_F_CAM_SENSOR, num_pads, pads_flag,
>> -                   &vimc_sen_ops, vimc_sen_destroy);
>> +                   MEDIA_ENT_F_ATV_DECODER, 1,
>> +                   (const unsigned long[1]) {MEDIA_PAD_FL_SOURCE},
>> +                   &vimc_sen_ops);
>>       if (ret)
>>           goto err_free_vsen;
>>   +    dev_set_drvdata(comp, &vsen->ved);
>> +    vsen->dev = comp;
>> +
>>       /* Initialize the frame format */
>>       vsen->mbus_format = fmt_default;
>>   @@ -368,12 +369,52 @@ struct vimc_ent_device *vimc_sen_create(struct
>> v4l2_device *v4l2_dev,
>>               goto err_unregister_ent_sd;
>>       }
>>   -    return &vsen->ved;
>> +    return 0;
>>     err_unregister_ent_sd:
>>       vimc_ent_sd_unregister(&vsen->ved,  &vsen->sd);
>>   err_free_vsen:
>>       kfree(vsen);
>>   -    return ERR_PTR(ret);
>> +    return ret;
>> +}
>> +
>> +static const struct component_ops vimc_sen_comp_ops = {
>> +    .bind = vimc_sen_comp_bind,
>> +    .unbind = vimc_sen_comp_unbind,
>> +};
>> +
>> +static int vimc_sen_probe(struct platform_device *pdev)
>> +{
>> +    return component_add(&pdev->dev, &vimc_sen_comp_ops);
>>   }
>> +
>> +static int vimc_sen_remove(struct platform_device *pdev)
>> +{
>> +    component_del(&pdev->dev, &vimc_sen_comp_ops);
>> +
>> +    return 0;
>> +}
>> +
>> +static struct platform_driver vimc_sen_pdrv = {
>> +    .probe        = vimc_sen_probe,
>> +    .remove        = vimc_sen_remove,
>> +    .driver        = {
>> +        .name    = VIMC_SEN_DRV_NAME,
>> +    },
>> +};
>> +
>> +static const struct platform_device_id vimc_sen_driver_ids[] = {
>> +    {
>> +        .name           = VIMC_SEN_DRV_NAME,
>> +    },
>> +    { }
>> +};
>> +
>> +module_platform_driver(vimc_sen_pdrv);
>> +
>> +MODULE_DEVICE_TABLE(platform, vimc_sen_driver_ids);
>> +
>> +MODULE_DESCRIPTION("Virtual Media Controller Driver (VIMC) Sensor");
>> +MODULE_AUTHOR("Helen Mae Koike Fornazier <helen.fornazier@gmail.com>");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/media/platform/vimc/vimc-sensor.h
>> b/drivers/media/platform/vimc/vimc-sensor.h
>> deleted file mode 100644
>> index 580dcec..0000000
>> --- a/drivers/media/platform/vimc/vimc-sensor.h
>> +++ /dev/null
>> @@ -1,28 +0,0 @@
>> -/*
>> - * vimc-sensor.h Virtual Media Controller Driver
>> - *
>> - * Copyright (C) 2015-2017 Helen Koike <helen.fornazier@gmail.com>
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License as published by
>> - * the Free Software Foundation; either version 2 of the License, or
>> - * (at your option) any later version.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - */
>> -
>> -#ifndef _VIMC_SENSOR_H_
>> -#define _VIMC_SENSOR_H_
>> -
>> -#include "vimc-common.h"
>> -
>> -struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
>> -                    const char *const name,
>> -                    u16 num_pads,
>> -                    const unsigned long *pads_flag);
>> -
>> -#endif
>>
>
> Regards,
>
>     Hans

Thanks
Helen

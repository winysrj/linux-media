Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:42441 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbeBUGBn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 01:01:43 -0500
Received: by mail-io0-f195.google.com with SMTP id u84so904639iod.9
        for <linux-media@vger.kernel.org>; Tue, 20 Feb 2018 22:01:43 -0800 (PST)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id e7sm22869035ita.17.2018.02.20.22.01.41
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Feb 2018 22:01:41 -0800 (PST)
Received: by mail-io0-f174.google.com with SMTP id g21so912935ioj.5
        for <linux-media@vger.kernel.org>; Tue, 20 Feb 2018 22:01:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5fd863ad-a0fe-88d7-05bd-90c2b4096145@xs4all.nl>
References: <20180220044425.169493-1-acourbot@chromium.org>
 <20180220044425.169493-2-acourbot@chromium.org> <5fd863ad-a0fe-88d7-05bd-90c2b4096145@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 21 Feb 2018 15:01:19 +0900
Message-ID: <CAPBb6MUUuo+50zfs-XaRcVD6sV3uaownVeFKgX=A6NkTO1he1w@mail.gmail.com>
Subject: Re: [RFCv4 01/21] media: add request API core and UAPI
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Feb 20, 2018 at 7:36 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/20/18 05:44, Alexandre Courbot wrote:
>> The request API provides a way to group buffers and device parameters
>> into units of work to be queued and executed. This patch introduces the
>> UAPI and core framework.
>>
>> This patch is based on the previous work by Laurent Pinchart. The core
>> has changed considerably, but the UAPI is mostly untouched.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  drivers/media/Kconfig              |   3 +
>>  drivers/media/Makefile             |   6 +
>>  drivers/media/media-request.c      | 341 ++++++++++++++++++++++++++++
>>  include/media/media-request.h      | 349 +++++++++++++++++++++++++++++
>>  include/uapi/linux/media-request.h |  37 +++
>>  5 files changed, 736 insertions(+)
>>  create mode 100644 drivers/media/media-request.c
>>  create mode 100644 include/media/media-request.h
>>  create mode 100644 include/uapi/linux/media-request.h
>>
>> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
>> index 145e12bfb819..db30fc9547d2 100644
>> --- a/drivers/media/Kconfig
>> +++ b/drivers/media/Kconfig
>> @@ -130,6 +130,9 @@ config VIDEO_V4L2_SUBDEV_API
>>
>>         This API is mostly used by camera interfaces in embedded platforms.
>>
>> +config MEDIA_REQUEST_API
>> +     tristate
>> +
>>  source "drivers/media/v4l2-core/Kconfig"
>>
>>  #
>> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
>> index 594b462ddf0e..03c0a39ad344 100644
>> --- a/drivers/media/Makefile
>> +++ b/drivers/media/Makefile
>> @@ -5,6 +5,12 @@
>>
>>  media-objs   := media-device.o media-devnode.o media-entity.o
>>
>> +#
>> +# Request API support comes as its own module since it can be used by
>> +# both media and video devices
>> +#
>> +obj-$(CONFIG_MEDIA_REQUEST_API) += media-request.o
>> +
>>  #
>>  # I2C drivers should come before other drivers, otherwise they'll fail
>>  # when compiled as builtin drivers
>> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
>> new file mode 100644
>> index 000000000000..b88362028561
>> --- /dev/null
>> +++ b/drivers/media/media-request.c
>> @@ -0,0 +1,341 @@
>> +/*
>> + * Request base implementation
>> + *
>> + * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/anon_inodes.h>
>> +#include <linux/fs.h>
>> +#include <linux/file.h>
>> +#include <linux/list.h>
>> +#include <linux/device.h>
>> +#include <linux/media-request.h>
>> +#include <linux/module.h>
>> +#include <linux/poll.h>
>> +#include <linux/slab.h>
>> +
>> +#include <media/media-request.h>
>> +
>> +const struct file_operations request_fops;
>> +
>> +static const char * const media_request_states[] __maybe_unused = {
>
> Why 'maybe_unused'?
>
>> +     "IDLE",
>> +     "SUBMITTED",
>> +     "COMPLETED",
>> +     "INVALID",
>
> I don't like to yell. I prefer "Idle", "Submitted", etc.

Sure.

>
>> +};
>> +
>> +struct media_request *media_request_get(struct media_request *req)
>> +{
>> +     get_file(req->file);
>> +     return req;
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_get);
>> +
>> +struct media_request *media_request_get_from_fd(int fd)
>> +{
>> +     struct file *f;
>> +
>> +     f = fget(fd);
>> +     if (!f)
>> +             return NULL;
>> +
>> +     /* Not a request FD? */
>> +     if (f->f_op != &request_fops) {
>> +             fput(f);
>> +             return NULL;
>> +     }
>> +
>> +     return f->private_data;
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_get_from_fd);
>> +
>> +void media_request_put(struct media_request *req)
>> +{
>> +     if (WARN_ON(req == NULL))
>> +             return;
>> +
>> +     fput(req->file);
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_put);
>> +
>> +struct media_request_entity_data *
>> +media_request_get_entity_data(struct media_request *req,
>> +                           struct media_request_entity *entity)
>> +{
>> +     struct media_request_entity_data *data;
>> +
>> +     /* First check that this entity is valid for this request at all */
>> +     if (!req->mgr->ops->entity_valid(req, entity))
>> +             return ERR_PTR(-EINVAL);
>> +
>> +     mutex_lock(&req->lock);
>> +
>> +     /* Lookup whether we already have entity data */
>> +     list_for_each_entry(data, &req->data, list) {
>> +             if (data->entity == entity)
>> +                     goto out;
>> +     }
>> +
>> +     /* No entity data found, let's create it */
>> +     data = entity->ops->data_alloc(req, entity);
>> +     if (IS_ERR(data))
>> +             goto out;
>> +
>> +     data->entity = entity;
>> +     list_add_tail(&data->list, &req->data);
>> +
>> +out:
>> +     mutex_unlock(&req->lock);
>> +
>> +     return data;
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_get_entity_data);
>> +
>> +static unsigned int media_request_poll(struct file *file, poll_table *wait)
>> +{
>> +     struct media_request *req = file->private_data;
>> +
>> +     poll_wait(file, &req->complete_wait, wait);
>> +
>> +     if (req->state == MEDIA_REQUEST_STATE_COMPLETED)
>> +             return POLLIN | POLLRDNORM;
>> +
>> +     return 0;
>> +}
>> +
>> +static int media_request_release(struct inode *inode, struct file *filp)
>> +{
>> +     struct media_request *req = filp->private_data;
>> +
>> +     if (req == NULL)
>> +             return 0;
>> +
>> +     req->mgr->ops->release(req);
>> +     return 0;
>> +}
>> +
>> +static long media_request_ioctl_submit(struct media_request *req)
>> +{
>> +     mutex_lock(&req->lock);
>> +
>> +     if (req->state != MEDIA_REQUEST_STATE_IDLE) {
>> +             dev_warn(req->mgr->dev, "cannot submit request in state %s\n",
>> +                      media_request_states[req->state]);
>> +             mutex_unlock(&req->lock);
>> +             return -EINVAL;
>> +     }
>> +
>> +     req->state = MEDIA_REQUEST_STATE_SUBMITTED;
>> +
>> +     /*
>> +      * Nothing can change our state when we are submitted - no need to keep
>> +      * holding that lock.
>> +      */
>> +     mutex_unlock(&req->lock);
>> +
>> +     /* Keep a reference to the request until it is completed */
>> +     media_request_get(req);
>> +
>> +     return req->mgr->ops->submit(req);
>
> What happens if submit() returns an error? I would expect that the state goes
> back to IDLE and the reference is put().

Fixed.

>
>> +}
>> +
>> +static long media_request_ioctl_reinit(struct media_request *req)
>> +{
>> +     struct media_request_entity_data *data, *next;
>> +        LIST_HEAD(to_delete);
>
> Weird indentation.

Indeed, fixed.

>
>> +
>> +     mutex_lock(&req->lock);
>> +
>> +     if (req->state == MEDIA_REQUEST_STATE_SUBMITTED) {
>> +             dev_warn(req->mgr->dev,
>> +                     "%s: unable to reinit submitted request\n", __func__);
>> +             mutex_unlock(&req->lock);
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* delete all entity data */
>> +     list_for_each_entry_safe(data, next, &req->data, list) {
>> +             list_del(&data->list);
>> +                list_add(&data->list, &to_delete);
>
> Strange indentation.
>
> You can also use list_move(&data->list, &to_delete).

Fixed and used list_move().

>
>> +     }
>> +
>> +     /* reinitialize request to idle state */
>> +     req->state = MEDIA_REQUEST_STATE_IDLE;
>> +
>> +     mutex_unlock(&req->lock);
>> +
>> +        list_for_each_entry_safe(data, next, &to_delete, list)
>
> Again strange indentation. Not sure what's going on with that.
> I'll ignore it going forward.

Yeah, sorry about that. Not sure what I did wrong here, besides not
running checkpatch on this set :/.

>
>> +             data->entity->ops->data_free(data);
>> +
>> +     return 0;
>> +}
>> +
>> +#define MEDIA_REQUEST_IOC(__cmd, func)                                       \
>> +     [_IOC_NR(MEDIA_REQUEST_IOC_##__cmd) - 0x80] = {                 \
>> +             .cmd = MEDIA_REQUEST_IOC_##__cmd,                       \
>> +             .fn = func,                                             \
>> +     }
>> +
>> +struct media_request_ioctl_info {
>> +     unsigned int cmd;
>> +     long (*fn)(struct media_request *req);
>> +};
>> +
>> +static const struct media_request_ioctl_info ioctl_info[] = {
>> +     MEDIA_REQUEST_IOC(SUBMIT, media_request_ioctl_submit),
>> +     MEDIA_REQUEST_IOC(REINIT, media_request_ioctl_reinit),
>
> There are only two ioctls, so there is really no need for the
> MEDIA_REQUEST_IOC define. Just keep it simple.

The number of times it is used doesn't change the fact that it helps
with readability IMHO.

>
>> +};
>> +
>> +static long media_request_ioctl(struct file *filp, unsigned int cmd,
>> +                             unsigned long __arg)
>> +{
>> +     struct media_request *req = filp->private_data;
>> +     const struct media_request_ioctl_info *info;
>> +
>> +     if ((_IOC_NR(cmd) < 0x80) ||
>
> Why start the ioctl number at 0x80? Why not just 0?
> It avoids all this hassle with the 0x80 offset.
>
>> +          _IOC_NR(cmd) >= 0x80 + ARRAY_SIZE(ioctl_info) ||
>> +          ioctl_info[_IOC_NR(cmd) - 0x80].cmd != cmd)
>> +             return -ENOIOCTLCMD;
>> +
>> +     info = &ioctl_info[_IOC_NR(cmd) - 0x80];
>> +
>> +     return info->fn(req);
>> +}
>> +
>> +const struct file_operations request_fops = {
>> +     .owner = THIS_MODULE,
>> +     .poll = media_request_poll,
>> +     .release = media_request_release,
>> +     .unlocked_ioctl = media_request_ioctl,
>> +};
>> +
>> +static void media_request_complete(struct media_request *req)
>> +{
>> +     struct device *dev = req->mgr->dev;
>> +
>> +     mutex_lock(&req->lock);
>> +
>> +     if (WARN_ON(req->state != MEDIA_REQUEST_STATE_SUBMITTED)) {
>> +             dev_warn(dev, "can't complete request in state %s\n",
>> +                     media_request_states[req->state]);
>> +             mutex_unlock(&req->lock);
>> +             return;
>> +     }
>> +
>> +     req->state = MEDIA_REQUEST_STATE_COMPLETED;
>> +
>> +     wake_up_interruptible(&req->complete_wait);
>> +
>> +     mutex_unlock(&req->lock);
>> +
>> +     /* Release the reference acquired when we submitted the request */
>> +     media_request_put(req);
>> +}
>> +
>> +void media_request_entity_complete(struct media_request *req,
>> +                                struct media_request_entity *completed)
>> +{
>> +     struct media_request_entity_data *data;
>> +     int cpt = 0;
>> +
>> +     list_for_each_entry(data, &req->data, list) {
>> +             if (data->entity == completed)
>> +                     data->completed = true;
>> +             if (!data->completed)
>
> This can be 'else if'.

Fixed.

>
>> +                     ++cpt;
>> +     }
>> +
>> +     if (cpt == 0)
>> +             media_request_complete(req);
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_entity_complete);
>> +
>> +long media_request_ioctl_new(struct media_request_mgr *mgr,
>> +                          struct media_request_new *new)
>> +{
>> +     struct media_request *req;
>> +     int err;
>> +     int fd;
>> +
>> +     /* User only wants to check the availability of requests? */
>> +     if (new->flags & MEDIA_REQUEST_FLAG_TEST)
>> +             return 0;
>> +
>> +     fd = get_unused_fd_flags(O_CLOEXEC);
>> +     if (fd < 0)
>> +             return fd;
>> +
>> +     req = mgr->ops->alloc(mgr);
>> +     if (IS_ERR(req)) {
>> +             err = PTR_ERR(req);
>> +             goto out_fd;
>> +     }
>> +
>> +     req->file = anon_inode_getfile("request", &request_fops, req,
>> +                                    O_CLOEXEC);
>> +     if (IS_ERR(req->file)) {
>> +             err = PTR_ERR(req->file);
>> +             mgr->ops->release(req);
>> +             goto out_fd;
>> +     }
>> +
>> +     fd_install(fd, req->file);
>> +     new->fd = fd;
>> +
>> +     return 0;
>> +
>> +out_fd:
>> +     put_unused_fd(fd);
>> +     return err;
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_ioctl_new);
>> +
>> +void media_request_entity_init(struct media_request_entity *entity,
>> +                            enum media_request_entity_type type,
>> +                            const struct media_request_entity_ops *ops)
>> +{
>> +     entity->type = type;
>> +     entity->ops = ops;
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_entity_init);
>> +
>> +void media_request_mgr_init(struct media_request_mgr *mgr, struct device *dev,
>> +                         const struct media_request_ops *ops)
>> +{
>> +     mgr->dev = dev;
>> +     mutex_init(&mgr->mutex);
>> +     INIT_LIST_HEAD(&mgr->requests);
>> +     mgr->ops = ops;
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_mgr_init);
>> +
>> +void media_request_mgr_free(struct media_request_mgr *mgr)
>> +{
>> +     struct device *dev = mgr->dev;
>> +
>> +     /* Just a sanity check - we should have no remaining requests */
>> +     while (!list_empty(&mgr->requests)) {
>> +             struct media_request *req;
>> +
>> +             req = list_first_entry(&mgr->requests, typeof(*req), list);
>> +             dev_warn(dev,
>> +                     "%s: request still referenced, deleting forcibly!\n",
>> +                     __func__);
>> +             mgr->ops->release(req);
>> +     }
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_mgr_free);
>> +
>> +MODULE_AUTHOR("Alexandre Courbot <acourbot@chromium.org>");
>> +MODULE_DESCRIPTION("Core support for media request API");
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/media/media-request.h b/include/media/media-request.h
>> new file mode 100644
>> index 000000000000..110dcdc1099f
>> --- /dev/null
>> +++ b/include/media/media-request.h
>> @@ -0,0 +1,349 @@
>> +/*
>> + * Media requests.
>> + *
>> + * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _MEDIA_REQUEST_H
>> +#define _MEDIA_REQUEST_H
>> +
>> +struct media_request;
>> +struct media_request_entity;
>> +struct media_request_entity_data;
>> +struct media_request_mgr;
>> +struct media_request_new;
>> +
>> +#include <linux/kconfig.h>
>> +
>> +enum media_request_state {
>> +     MEDIA_REQUEST_STATE_IDLE,
>> +     MEDIA_REQUEST_STATE_SUBMITTED,
>> +     MEDIA_REQUEST_STATE_COMPLETED,
>> +     MEDIA_REQUEST_STATE_INVALID,
>> +};
>> +
>> +#if IS_ENABLED(CONFIG_MEDIA_REQUEST_API)
>> +
>> +#include <linux/kref.h>
>> +#include <linux/list.h>
>> +#include <linux/notifier.h>
>> +#include <linux/wait.h>
>> +
>> +/**
>> + * struct media_request_entity_ops - request entity operations
>> + *
>> + * @data_alloc:      allocate memory to store that entity's relevant state
>> + * @data_free:       free state previously allocated with data_alloc
>> + * @submit:  perform all required actions to be ready to process that request
>> + */
>> +struct media_request_entity_ops {
>> +     struct media_request_entity_data *
>> +             (*data_alloc)(struct media_request *req,
>> +                           struct media_request_entity *entity);
>> +     void (*data_free)(struct media_request_entity_data *data);
>> +     int (*submit)(struct media_request *req,
>> +                   struct media_request_entity_data *data);
>> +};
>> +
>> +/**
>> + * enum media_request_entity_type - describe type of an entity
>> + *
>> + * This type lets us know the upper kind of a struct media_request_entity
>> + * instance.
>> + *
>> + * @MEDIA_REQUEST_ENTITY_TYPE_V4L2:  instance can be upcasted to
>> + *                                   v4l2_request_entity
>> + * @MEDIA_REQUEST_ENTITY_TYPE_MC:    instance can be updated to
>> + *                                   mc_request_entity
>> + *
>> + */
>> +enum media_request_entity_type {
>> +     MEDIA_REQUEST_ENTITY_TYPE_V4L2,
>> +     MEDIA_REQUEST_ENTITY_TYPE_MC,
>> +};
>> +
>> +/**
>> + * struct media_request_entity - request entity base structure
>> + *
>> + * @type:    type of entity, indicating which upcast is safe to perform
>> + * @ops:     operations that this entity can perform
>> + *
>> + * This structure is supposed to be embedded into a larger structure
>> + * better representing the specifics of the instance (e.g. v4l2_request_entity
>> + * for controlling V4L2 devices).
>> + *
>> + */
>> +struct media_request_entity {
>> +     enum media_request_entity_type type;
>> +     const struct media_request_entity_ops *ops;
>> +};
>> +
>> +/**
>> + * media_request_entity_init() - initialize a request entity's base properties
>> + *
>> + * @entity:  entity to initialize
>> + * @type:    type of this entity
>> + * @ops:     operations that this entity will perform
>> + */
>> +void media_request_entity_init(struct media_request_entity *entity,
>> +                            enum media_request_entity_type type,
>> +                            const struct media_request_entity_ops *ops);
>> +
>> +/**
>> + * struct media_request_entity_data - per-entity request data
>> + *
>> + * @request: request instance this data belongs to
>> + * @entity:  entity that stores data here
>> + * @list:    entry in media_request::data
>> + * @completed:       whether this entity has completed its part of the request
>> + *
>> + * Base structure used to store request state data. To be extended by actual
>> + * implementation.
>> + *
>> + */
>> +struct media_request_entity_data {
>> +     struct media_request *request;
>> +     struct media_request_entity *entity;
>> +     struct list_head list;
>> +     bool completed;
>> +};
>> +
>> +/**
>> + * struct media_request - Media request base structure
>> + *
>> + * @mgr:     manager this request belongs to
>> + * @file:    used to export FDs to user-space and reference count
>> + * @list:    entry in the media_request_mgr::requests list
>> + * @lock:    protects following members against concurrent accesses
>> + * @state:   current state of the request
>> + * @data:    per-entity data list
>> + * @complete_wait:   wait queue that signals once the request has completed
>> + */
>> +struct media_request {
>> +     struct media_request_mgr *mgr;
>> +     struct file *file;
>> +     struct list_head list;
>> +
>> +     struct mutex lock;
>> +     enum media_request_state state;
>> +     struct list_head data;
>> +     wait_queue_head_t complete_wait;
>> +};
>> +
>> +/**
>> + * media_request_get() - increment the reference counter of a request
>> + *
>> + * The calling context must call media_request_put() once it does not need
>> + * the reference to the request anymore.
>> + *
>> + * Returns the request that has been passed as argument.
>> + *
>> + * @req:     request to acquire a reference of
>> + */
>> +struct media_request *media_request_get(struct media_request *req);
>> +
>> +/**
>> + * media_request_get_from_fd() - lookup request by fd and acquire a reference.
>> + *
>> + * Look a request up from its fd, acquire a reference and return a pointer to
>> + * the request. As for media_request_get(), media_request_put() must be called
>> + * once the reference is not used anymore.
>> + *
>> + * @req:     request to lookup and acquire.
>> + *
>> + */
>> +struct media_request *media_request_get_from_fd(int fd);
>> +
>> +/**
>> + * media_request_put() - decrement the reference counter of a request
>> + *
>> + * Mirror function of media_request_get() and media_request_get_from_fd(). Will
>> + * free the request if this was the last valid reference.
>> + *
>> + * @req:     request to release.
>> + */
>> +void media_request_put(struct media_request *req);
>> +
>> +/**
>> + * media_request_lock() - prevent concurrent access to that request
>> + *
>> + * @req:     request to lock
>> + */
>> +static inline void media_request_lock(struct media_request *req)
>> +{
>> +     mutex_lock(&req->lock);
>> +}
>> +
>> +/**
>> + * media_request_unlock() - release previously acquired request lock
>> + *
>> + * @req:     request to release
>> + */
>> +static inline void media_request_unlock(struct media_request *req)
>> +{
>> +     mutex_unlock(&req->lock);
>> +}
>> +
>> +/**
>> + * media_request_get_state() - get the state of a request
>> + *
>> + * @req:     request which state we are interested in
>> + *
>> + * The request lock should always be acquired when confirming this value
>> + * to avoid race conditions.
>> + *
>> + */
>> +static inline enum media_request_state
>> +media_request_get_state(struct media_request *req)
>> +{
>> +     return req->state;
>> +}
>> +
>> +/**
>> + * media_request_get_entity_data() - get per-entity data for a request
>> + * @req:     request to get entity data from
>> + * @entity:  entity to get data of
>> + *
>> + * Search and return the entity data associated associated to the request. If no
>> + * such data exists, it is allocated as per the entity operations.
>> + *
>> + * Returns the per-entity data, or an error code if a problem happened. -EINVAL
>> + * means that data for the entity already existed, but has been allocated under
>> + * a different cookie.
>> + */
>> +struct media_request_entity_data *
>> +media_request_get_entity_data(struct media_request *req,
>> +                           struct media_request_entity *entity);
>> +
>> +/**
>> + * media_request_entity_complete() - to be invoked when an entity completes its
>> + *                                part of the request
>> + *
>> + * @req:     request which has completed
>> + * @completed:       entity that has completed
>> + */
>> +void media_request_entity_complete(struct media_request *req,
>> +                                struct media_request_entity *completed);
>> +
>> +/**
>> + * media_request_ioctl_new() - process a NEW_REQUEST ioctl
>> + *
>> + * @mgr:     request manager from which to allocate the request
>> + * @new:     media_request_new structure to be passed back to user-space
>> + *
>> + * This function is a helper to be called by actual handlers of *_NEW_REQUEST
>> + * ioctls.
>> + */
>> +long media_request_ioctl_new(struct media_request_mgr *mgr,
>> +                          struct media_request_new *new);
>> +
>> +/**
>> + * struct media_request_ops - request operations
>> + *
>> + * @alloc:   allocate a request
>> + * @release: free a previously allocated request
>> + * @entity_valid:    returns whether a given entity is valid for that request
>> + * @submit:  allow the request to be processed
>> + *
>> + * This structure allows to specialize requests to a specific scope. For
>> + * instance, requests obtained from a V4L2 device node should only be able to
>> + * control that device. On the other hand, requests created from a media
>> + * controller node will be able to control all the devices managed by this
>> + * controller, and may want to implement some form of synchronization between
>> + * them.
>> + */
>> +struct media_request_ops {
>> +     struct media_request *(*alloc)(struct media_request_mgr *mgr);
>> +     void (*release)(struct media_request *req);
>> +     bool (*entity_valid)(const struct media_request *req,
>> +                          const struct media_request_entity *entity);
>> +     int (*submit)(struct media_request *req);
>> +};
>> +
>> +/**
>> + * struct media_request_mgr - requests manager
>> + *
>> + * @dev:     device owning this manager
>> + * @ops:     implementation of the manager
>> + * @mutex:   protects the requests list_head
>> + * @requests:        list of alive requests produced by this manager
>> + *
>> + * This structure is mainly responsible for allocating requests. Although it is
>> + * not strictly required for that purpose, having it allows us to account for
>> + * all requests created by a given device, and to make sure they are all
>> + * discarded by the time the device is destroyed.
>> + */
>> +struct media_request_mgr {
>> +     struct device *dev;
>> +     const struct media_request_ops *ops;
>> +
>> +     struct mutex mutex;
>> +     struct list_head requests;
>> +};
>> +
>> +/**
>> + * media_request_mgr_init() - initialize a request manager.
>> + *
>> + * @mgr:     manager to initialize
>> + */
>> +void media_request_mgr_init(struct media_request_mgr *mgr, struct device *dev,
>> +                         const struct media_request_ops *ops);
>> +
>> +/**
>> + * media_request_mgr_free() - free a media manager
>> + *
>> + * This should only be called when all requests produced by this manager
>> + * has been destroyed. Will warn if that is not the case.
>> + */
>> +void media_request_mgr_free(struct media_request_mgr *mgr);
>> +
>> +#else /* CONFIG_MEDIA_REQUEST_API */
>> +
>> +static inline void media_request_entity_complete(struct media_request *req,
>> +                                      struct media_request_entity *completed)
>> +{
>> +}
>> +
>> +static inline struct media_request_entity_data *
>> +media_request_get_entity_data(struct media_request *req,
>> +                           struct media_request_entity *entity)
>> +{
>> +     return ERR_PTR(-ENOTSUPP);
>> +}
>> +
>> +static inline long media_request_ioctl_new(struct media_request_mgr *mgr,
>> +                                        struct media_request_new *new)
>> +{
>> +     return -ENOTTY;
>> +}
>> +
>> +static inline void media_request_put(struct media_request *req)
>> +{
>> +}
>> +
>> +static inline void media_request_lock(struct media_request *req)
>> +{
>> +}
>> +
>> +static inline void media_request_unlock(struct media_request *req)
>> +{
>> +}
>> +
>> +static inline enum media_request_state
>> +media_request_get_state(struct media_request *req)
>> +{
>> +     return MEDIA_REQUEST_STATE_INVALID;
>> +}
>> +
>> +#endif /* CONFIG_MEDIA_REQUEST_API */
>> +
>> +#endif
>> diff --git a/include/uapi/linux/media-request.h b/include/uapi/linux/media-request.h
>> new file mode 100644
>> index 000000000000..5d30f731a442
>> --- /dev/null
>> +++ b/include/uapi/linux/media-request.h
>> @@ -0,0 +1,37 @@
>> +/*
>> + * Media requests UAPI
>> + *
>> + * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef __LINUX_MEDIA_REQUEST_H
>> +#define __LINUX_MEDIA_REQUEST_H
>> +
>> +#ifndef __KERNEL__
>> +#include <stdint.h>
>> +#endif
>> +#include <linux/ioctl.h>
>> +#include <linux/types.h>
>> +#include <linux/version.h>
>> +
>> +/* Only check that requests can be used, do not allocate */
>> +#define MEDIA_REQUEST_FLAG_TEST                      0x00000001
>> +
>> +struct media_request_new {
>> +     __u32 flags;
>> +     __s32 fd;
>> +} __attribute__ ((packed));
>> +
>> +#define MEDIA_REQUEST_IOC_SUBMIT       _IO('|',  128)
>> +#define MEDIA_REQUEST_IOC_REINIT       _IO('|',  129)
>> +
>> +#endif
>>
>
> I need to think a bit more on this internal API, so I might come back
> to this patch for more comments.

I think I should probably elaborate on why I think it is advantageous
to have these ioctls handled here.

One of the reasons if that it does not force user-space to keep track
of who issued the request to operate on it. Semantically, the only
device a request could be submitted to is the device that produced it
anyway, so since that argument is constant we may as well get rid of
it (and we also don't need to pass the request FD as argument
anymore).

It also gives us more freedom when designing new request-related
ioctls: before, all request-related operations were multiplexed under
a single MEDIA_IOC_REQUEST_CMD ioctl, which cmd field indicated the
actual operation to perform. With this design, all the arguments must
fit within the media_request_cmd structure, which may cause confusion
as it will have to be variable-sized. I am thinking in particular
about a future atomic-like API to set topology, controls and buffers
related to a request all at the same time. Having it as a request
ioctl seems perfectly fitting to me.

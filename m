Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:47578 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750898AbeEBMYw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 08:24:52 -0400
Subject: Re: [RFCv12 PATCH 03/29] media-request: implement media requests
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180501090051.9321-1-hverkuil@xs4all.nl>
 <20180501090051.9321-4-hverkuil@xs4all.nl>
Message-ID: <6535eaa9-4134-c897-900a-de7d73771ac4@xs4all.nl>
Date: Wed, 2 May 2018 14:24:49 +0200
MIME-Version: 1.0
In-Reply-To: <20180501090051.9321-4-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/05/18 11:00, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add initial media request support.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/Makefile        |   3 +-
>  drivers/media/media-device.c  |  13 ++
>  drivers/media/media-request.c | 418 ++++++++++++++++++++++++++++++++++
>  include/media/media-device.h  |  17 ++
>  include/media/media-request.h | 193 ++++++++++++++++
>  5 files changed, 643 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/media-request.c
>  create mode 100644 include/media/media-request.h
> 
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index 594b462ddf0e..985d35ec6b29 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -3,7 +3,8 @@
>  # Makefile for the kernel multimedia device drivers.
>  #
>  
> -media-objs	:= media-device.o media-devnode.o media-entity.o
> +media-objs	:= media-device.o media-devnode.o media-entity.o \
> +		   media-request.o
>  
>  #
>  # I2C drivers should come before other drivers, otherwise they'll fail
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 35e81f7c0d2f..25d7e2a3ee84 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -32,6 +32,7 @@
>  #include <media/media-device.h>
>  #include <media/media-devnode.h>
>  #include <media/media-entity.h>
> +#include <media/media-request.h>
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  
> @@ -366,6 +367,15 @@ static long media_device_get_topology(struct media_device *mdev,
>  	return ret;
>  }
>  
> +static long media_device_request_alloc(struct media_device *mdev,
> +				       struct media_request_alloc *alloc)
> +{
> +	if (!mdev->ops || !mdev->ops->req_validate || !mdev->ops->req_queue)
> +		return -ENOTTY;
> +
> +	return media_request_alloc(mdev, alloc);
> +}
> +
>  static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
>  {
>  	/* All media IOCTLs are _IOWR() */
> @@ -414,6 +424,7 @@ static const struct media_ioctl_info ioctl_info[] = {
>  	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC(REQUEST_ALLOC, media_device_request_alloc, 0),
>  };
>  
>  static long media_device_ioctl(struct file *filp, unsigned int cmd,
> @@ -686,6 +697,8 @@ void media_device_init(struct media_device *mdev)
>  	INIT_LIST_HEAD(&mdev->pads);
>  	INIT_LIST_HEAD(&mdev->links);
>  	INIT_LIST_HEAD(&mdev->entity_notify);
> +
> +	mutex_init(&mdev->req_queue_mutex);
>  	mutex_init(&mdev->graph_mutex);
>  	ida_init(&mdev->entity_internal_idx);
>  
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> new file mode 100644
> index 000000000000..22881d5700c8
> --- /dev/null
> +++ b/drivers/media/media-request.c
> @@ -0,0 +1,418 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Media device request objects
> + *
> + * Copyright (C) 2018 Intel Corporation
> + * Copyright (C) 2018 Google, Inc.
> + *
> + * Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> + */
> +
> +#include <linux/anon_inodes.h>
> +#include <linux/file.h>
> +
> +#include <media/media-device.h>
> +#include <media/media-request.h>
> +
> +static const char * const request_state[] = {
> +	[MEDIA_REQUEST_STATE_IDLE]	 = "idle",
> +	[MEDIA_REQUEST_STATE_VALIDATING] = "validating",
> +	[MEDIA_REQUEST_STATE_QUEUED]	 = "queued",
> +	[MEDIA_REQUEST_STATE_COMPLETE]	 = "complete",
> +	[MEDIA_REQUEST_STATE_CLEANING]	 = "cleaning",
> +};
> +
> +static const char *
> +media_request_state_str(enum media_request_state state)
> +{
> +	if (WARN_ON(state >= ARRAY_SIZE(request_state)))
> +		return "unknown";
> +	return request_state[state];
> +}
> +
> +static void media_request_clean(struct media_request *req)
> +{
> +	struct media_request_object *obj, *obj_safe;
> +
> +	WARN_ON(atomic_read(&req->state) != MEDIA_REQUEST_STATE_CLEANING);
> +
> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
> +		media_request_object_unbind(obj);
> +		media_request_object_put(obj);
> +	}
> +
> +	req->num_incomplete_objects = 0;
> +	wake_up_interruptible_all(&req->poll_wait);
> +}
> +
> +static void media_request_release(struct kref *kref)
> +{
> +	struct media_request *req =
> +		container_of(kref, struct media_request, kref);
> +	struct media_device *mdev = req->mdev;
> +
> +	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
> +
> +	atomic_set(&req->state, MEDIA_REQUEST_STATE_CLEANING);
> +
> +	media_request_clean(req);
> +
> +	if (mdev->ops->req_free)
> +		mdev->ops->req_free(req);
> +	else
> +		kfree(req);
> +}
> +
> +void media_request_put(struct media_request *req)
> +{
> +	kref_put(&req->kref, media_request_release);
> +}
> +EXPORT_SYMBOL_GPL(media_request_put);
> +
> +void media_request_cancel(struct media_request *req)
> +{
> +	struct media_request_object *obj, *obj_safe;
> +
> +	/*
> +	 * This is serialized with the req_queue_mutex and streaming
> +	 * has stopped, so there is no need to take the spinlock here.
> +	 */
> +	WARN_ON_ONCE(!mutex_is_locked(&req->mdev->req_queue_mutex));
> +	if (atomic_read(&req->state) != MEDIA_REQUEST_STATE_QUEUED)
> +		return;
> +
> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list)
> +		if (obj->ops->cancel)
> +			obj->ops->cancel(obj);
> +}
> +EXPORT_SYMBOL_GPL(media_request_cancel);

Forget about this function, while trying to document this function I realized
that this is the wrong approach. This should be done through a vb2 op instead
that drivers have to implement.

It's fixed in the upcoming v13.

Regards,

	Hans

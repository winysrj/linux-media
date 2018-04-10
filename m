Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:39000 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752210AbeDJIVi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 04:21:38 -0400
Received: by mail-vk0-f66.google.com with SMTP id n124so6485133vkd.6
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2018 01:21:38 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-5-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-5-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@google.com>
Date: Tue, 10 Apr 2018 08:21:27 +0000
Message-ID: <CAAFQd5AwZZ3EXbOdpOrVMupDY8ZvzL0j0sPYxgFCicAY3tn9mA@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 04/29] media-request: core request support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Apr 9, 2018 at 11:21 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
[snip]
> +static void media_request_clean(struct media_request *req)
> +{
> +       struct media_request_object *obj, *obj_safe;
> +
> +       WARN_ON(req->state != MEDIA_REQUEST_STATE_CLEANING);
> +
> +       list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
> +               media_request_object_unbind(obj);
> +               media_request_object_put(obj);
> +       }
> +
> +       req->num_incomplete_objects = 0;
> +       wake_up_interruptible(&req->poll_wait);

Do we intentionally wake up only one waiter here (as opposed to calling
wake_up_interruptible_all())?

> +}
> +
> +static void media_request_release(struct kref *kref)
> +{
> +       struct media_request *req =
> +               container_of(kref, struct media_request, kref);
> +       struct media_device *mdev = req->mdev;
> +       unsigned long flags;
> +
> +       dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);
> +
> +       spin_lock_irqsave(&req->lock, flags);
> +       req->state = MEDIA_REQUEST_STATE_CLEANING;
> +       spin_unlock_irqrestore(&req->lock, flags);
> +
> +       media_request_clean(req);
> +
> +       if (mdev->ops->req_free)
> +               mdev->ops->req_free(req);
> +       else
> +               kfree(req);
> +}
> +
> +void media_request_put(struct media_request *req)
> +{
> +       kref_put(&req->kref, media_request_release);
> +}
> +EXPORT_SYMBOL_GPL(media_request_put);
> +
> +void media_request_cancel(struct media_request *req)
> +{
> +       struct media_request_object *obj, *obj_safe;
> +
> +       if (req->state != MEDIA_REQUEST_STATE_QUEUED)
> +               return;

I can see that media_request_release() guards the state change with
req->lock. However we access the state here without holding the spinlock.

Also, should we perhaps have MEDIA_REQUEST_STATE_CANCELLED (or maybe just
reset to MEDIA_REQUEST_STATE_IDLE?), so that we can guard against calling
this multiple times?

Or perhaps we're expecting this to be called with req_queue_mutex held?

> +
> +       list_for_each_entry_safe(obj, obj_safe, &req->objects, list)
> +               if (obj->ops->cancel)
> +                       obj->ops->cancel(obj);
> +}
> +EXPORT_SYMBOL_GPL(media_request_cancel);
[snip]
> +void media_request_object_init(struct media_request_object *obj)
> +{
> +       obj->ops = NULL;
> +       obj->req = NULL;
> +       obj->priv = NULL;

Perhaps it could make sense to pass ops and priv as arguments here? There
is probably not much value in having a request object with both set to NULL.

> +       obj->completed = false;
> +       INIT_LIST_HEAD(&obj->list);
> +       kref_init(&obj->kref);
> +}
> +EXPORT_SYMBOL_GPL(media_request_object_init);
> +
> +void media_request_object_bind(struct media_request *req,
> +                              const struct media_request_object_ops *ops,
> +                              void *priv,
> +                              struct media_request_object *obj)
> +{
> +       unsigned long flags;
> +
> +       if (WARN_ON(!ops->release || !ops->cancel))
> +               return;
> +
> +       obj->req = req;
> +       obj->ops = ops;
> +       obj->priv = priv;

Ah, I see, they're being set here. I guess it's just the matter of how we
define the semantics.

I wonder, though, what happens with a media_request_object struct that was
allocated, initialized, but not bound to a request, because the client
terminated. We would want to call media_request_object_put(obj), but
obj->ops would be NULL.

> +       spin_lock_irqsave(&req->lock, flags);
> +       if (WARN_ON(req->state != MEDIA_REQUEST_STATE_IDLE))
> +               goto unlock;
> +       list_add_tail(&obj->list, &req->objects);
> +       req->num_incomplete_objects++;
> +unlock:
> +       spin_unlock_irqrestore(&req->lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(media_request_object_bind);
> +
> +void media_request_object_unbind(struct media_request_object *obj)
> +{
> +       struct media_request *req = obj->req;
> +       unsigned long flags;
> +       bool completed = false;
> +
> +       if (!req)
> +               return;

No need for any locking here?

> +
> +       spin_lock_irqsave(&req->lock, flags);
> +       list_del(&obj->list);
> +       obj->req = NULL;
> +
> +       if (req->state == MEDIA_REQUEST_STATE_COMPLETE ||
> +           req->state == MEDIA_REQUEST_STATE_CLEANING)
> +               goto unlock;
> +
> +       if (WARN_ON(req->state == MEDIA_REQUEST_STATE_QUEUEING))
> +               goto unlock;
> +
> +       if (WARN_ON(!req->num_incomplete_objects))
> +               goto unlock;
> +
> +       req->num_incomplete_objects--;
> +       if (req->state == MEDIA_REQUEST_STATE_QUEUED &&
> +           !req->num_incomplete_objects) {
> +               req->state = MEDIA_REQUEST_STATE_COMPLETE;
> +               completed = true;
> +               wake_up_interruptible(&req->poll_wait);

Is this intentionally waking up only 1 waiter?

> +       }
> +unlock:
> +       spin_unlock_irqrestore(&req->lock, flags);
> +       if (obj->ops->unbind)
> +               obj->ops->unbind(obj);
> +       if (completed)
> +               media_request_put(req);
> +}
> +EXPORT_SYMBOL_GPL(media_request_object_unbind);
> +
> +void media_request_object_complete(struct media_request_object *obj)
> +{
> +       struct media_request *req = obj->req;
> +       unsigned long flags;
> +       bool completed = false;
> +
> +       spin_lock_irqsave(&req->lock, flags);
> +       if (obj->completed)
> +               goto unlock;
> +       obj->completed = true;
> +       if (WARN_ON(!req->num_incomplete_objects) ||
> +           WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
> +               goto unlock;
> +
> +       if (!--req->num_incomplete_objects) {
> +               req->state = MEDIA_REQUEST_STATE_COMPLETE;
> +               wake_up_interruptible(&req->poll_wait);

Is this intentionally waking up only 1 waiter?

> +               completed = true;
> +       }
> +unlock:
> +       spin_unlock_irqrestore(&req->lock, flags);
> +       if (completed)
> +               media_request_put(req);
>   }
> +EXPORT_SYMBOL_GPL(media_request_object_complete);
> diff --git a/include/media/media-request.h b/include/media/media-request.h
> index dae3eccd9aa7..082c3cae04ac 100644
> --- a/include/media/media-request.h
> +++ b/include/media/media-request.h
> @@ -16,7 +16,163 @@

>   #include <media/media-device.h>

> +enum media_request_state {
> +       MEDIA_REQUEST_STATE_IDLE,
> +       MEDIA_REQUEST_STATE_QUEUEING,
> +       MEDIA_REQUEST_STATE_QUEUED,
> +       MEDIA_REQUEST_STATE_COMPLETE,
> +       MEDIA_REQUEST_STATE_CLEANING,
> +};
> +
> +struct media_request_object;
> +
> +/**
> + * struct media_request - Media device request
> + * @mdev: Media device this request belongs to
> + * @kref: Reference count
> + * @debug_prefix: Prefix for debug messages (process name:fd)

debug_str?

> + * @state: The state of the request
> + * @objects: List of @struct media_request_object request objects
> + * @num_objects: The number objects in the request
> + * @num_completed_objects: The number of completed objects in the request

num_incomplete_objects?

> + * @poll_wait: Wait queue for poll
> + * @lock: Serializes access to this struct

Does it have to be acquired to access any field?

> + */
> +struct media_request {
> +       struct media_device *mdev;
> +       struct kref kref;
> +       char debug_str[TASK_COMM_LEN + 11];
> +       enum media_request_state state;
> +       struct list_head objects;
> +       unsigned int num_incomplete_objects;
> +       struct wait_queue_head poll_wait;
> +       spinlock_t lock;
> +};
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +
> +static inline void media_request_get(struct media_request *req)
> +{
> +       kref_get(&req->kref);
> +}
> +
> +void media_request_put(struct media_request *req);
> +void media_request_cancel(struct media_request *req);
> +
>   int media_request_alloc(struct media_device *mdev,
>                          struct media_request_alloc *alloc);
> +#else
> +static inline void media_request_get(struct media_request *req)
> +{
> +}
> +
> +static inline void media_request_put(struct media_request *req)
> +{
> +}
> +
> +static inline void media_request_cancel(struct media_request *req)
> +{
> +}
> +
> +#endif
> +

Documentation. (Disclaimer from cover letter acknowledged, though. Just
marking.)

> +struct media_request_object_ops {
> +       int (*prepare)(struct media_request_object *object);
> +       void (*unprepare)(struct media_request_object *object);
> +       void (*queue)(struct media_request_object *object);
> +       void (*unbind)(struct media_request_object *object);
> +       void (*cancel)(struct media_request_object *object);
> +       void (*release)(struct media_request_object *object);
> +};
> +
> +/**
> + * struct media_request_object - An opaque object that belongs to a media
> + *                              request
> + *

ops

> + * @priv: object's priv pointer

req

> + * @list: List entry of the object for @struct media_request
> + * @kref: Reference count of the object, acquire before releasing
req->lock

completed

> + *
> + * An object related to the request. This struct is embedded in the
> + * larger object data.
> + */
> +struct media_request_object {
> +       const struct media_request_object_ops *ops;
> +       void *priv;
> +       struct media_request *req;
> +       struct list_head list;
> +       struct kref kref;
> +       bool completed;
> +};
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +static inline void media_request_object_get(struct media_request_object
*obj)
> +{
> +       kref_get(&obj->kref);
> +}
> +
> +/**
> + * media_request_object_put - Put a media request object
> + *
> + * @obj: The object
> + *
> + * Put a media request object. Once all references are gone, the
> + * object's memory is released.
> + */
> +void media_request_object_put(struct media_request_object *obj);
> +
> +/**
> + * media_request_object_init - Initialise a media request object
> + *
> + * Initialise a media request object. The object will be released using
the
> + * release callback of the ops once it has no references (this function
> + * initialises references to one).
> + */
> +void media_request_object_init(struct media_request_object *obj);
> +
> +/**
> + * media_request_object_bind - Bind a media request object to a request
> + */
> +void media_request_object_bind(struct media_request *req,
> +                              const struct media_request_object_ops *ops,
> +                              void *priv,
> +                              struct media_request_object *obj);
> +
> +void media_request_object_unbind(struct media_request_object *obj);
> +
> +/**
> + * media_request_object_complete - Mark the media request object as
complete
> + */
> +void media_request_object_complete(struct media_request_object *obj);
> +#else
> +static inline void media_request_object_get(struct media_request_object
*obj)
> +{
> +}
> +
> +static inline void media_request_object_put(struct media_request_object
*obj)
> +{
> +}
> +
> +static inline void media_request_object_init(struct media_request_object
*obj)
> +{
> +       obj->ops = NULL;
> +       obj->req = NULL;

Hmm. Do we need to do anything here if !defined(CONFIG_MEDIA_CONTROLLER)?

Best regards,
Tomasz

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:41191 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755110AbeDWOcf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 10:32:35 -0400
Subject: Re: [RFCv11 PATCH 07/29] media-request: add media_request_object_find
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-8-hverkuil@xs4all.nl>
 <CAPBb6MXY7uTx4QH0cRmdRNAHaU9+20QE6A9PzKNxrKBHtkkb6w@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3da09c9f-6fbb-9089-083e-7d69559ce25c@xs4all.nl>
Date: Mon, 23 Apr 2018 16:32:31 +0200
MIME-Version: 1.0
In-Reply-To: <CAPBb6MXY7uTx4QH0cRmdRNAHaU9+20QE6A9PzKNxrKBHtkkb6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2018 06:36 AM, Alexandre Courbot wrote:
> On Mon, Apr 9, 2018 at 11:21 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
>> Add media_request_object_find to find a request object inside a
>> request based on ops and/or priv values.
> 
>> Objects of the same type (vb2 buffer, control handler) will have
>> the same ops value. And objects that refer to the same 'parent'
>> object (e.g. the v4l2_ctrl_handler that has the current driver
>> state) will have the same priv value.
> 
>> The caller has to call media_request_object_put() for the returned
>> object since this function increments the refcount.
> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/media/media-request.c | 26 ++++++++++++++++++++++++++
>>   include/media/media-request.h | 25 +++++++++++++++++++++++++
>>   2 files changed, 51 insertions(+)
> 
>> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
>> index 02b620c81de5..415f7e31019d 100644
>> --- a/drivers/media/media-request.c
>> +++ b/drivers/media/media-request.c
>> @@ -322,6 +322,32 @@ static void media_request_object_release(struct kref
> *kref)
>>          obj->ops->release(obj);
>>   }
> 
>> +struct media_request_object *
>> +media_request_object_find(struct media_request *req,
>> +                         const struct media_request_object_ops *ops,
>> +                         void *priv)
>> +{
>> +       struct media_request_object *obj;
>> +       struct media_request_object *found = NULL;
>> +       unsigned long flags;
>> +
>> +       if (!ops && !priv)
>> +               return NULL;
>> +
>> +       spin_lock_irqsave(&req->lock, flags);
>> +       list_for_each_entry(obj, &req->objects, list) {
>> +               if ((!ops || obj->ops == ops) &&
>> +                   (!priv || obj->priv == priv)) {
>> +                       media_request_object_get(obj);
>> +                       found = obj;
>> +                       break;
>> +               }
>> +       }
>> +       spin_unlock_irqrestore(&req->lock, flags);
>> +       return found;
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_object_find);
>> +
>>   void media_request_object_put(struct media_request_object *obj)
>>   {
>>          kref_put(&obj->kref, media_request_object_release);
>> diff --git a/include/media/media-request.h b/include/media/media-request.h
>> index 033697d493cd..ea990c8f76bc 100644
>> --- a/include/media/media-request.h
>> +++ b/include/media/media-request.h
>> @@ -130,6 +130,23 @@ static inline void media_request_object_get(struct
> media_request_object *obj)
>>    */
>>   void media_request_object_put(struct media_request_object *obj);
> 
>> +/**
>> + * media_request_object_find - Find an object in a request
>> + *
>> + * @ops: Find an object with this ops value, may be NULL.
>> + * @priv: Find an object with this priv value, may be NULL.
>> + *
>> + * At least one of @ops and @priv must be non-NULL. If one of
>> + * these is NULL, then skip checking for that field.
>> + *
>> + * Returns NULL if not found or the object (the refcount is increased
>> + * in that case).
>> + */
>> +struct media_request_object *
>> +media_request_object_find(struct media_request *req,
>> +                         const struct media_request_object_ops *ops,
>> +                         void *priv);
> 
> Mm, that signature is weird. I don't yet know how this function is going to
> be
> called, but wouldn't priv be enough? If we look for ops, this means we are
> looking for the first object of a given class (IIUC the class/objects
> mechanism
> here), and I cannot see where we would want to do that.

This allows you to associate objects of different types with the same
priv pointer. E.g. right now only buffers objects are associated with
a vb2_queue. But what if you want to associate other objects with the vb2_queue
as well? That's what the ops is for.

This will almost certainly be needed for complex video pipelines.

If I am wrong, then this can be removed in the future.

Regards,

	Hans

> 
>> +
>>   /**
>>    * media_request_object_init - Initialise a media request object
>>    *
>> @@ -162,6 +179,14 @@ static inline void media_request_object_put(struct
> media_request_object *obj)
>>   {
>>   }
> 
>> +static inline struct media_request_object *
>> +media_request_object_find(struct media_request *req,
>> +                         const struct media_request_object_ops *ops,
>> +                         void *priv)
>> +{
>> +       return NULL;
>> +}
>> +
>>   static inline void media_request_object_init(struct media_request_object
> *obj)
>>   {
>>          obj->ops = NULL;
>> --
>> 2.16.3

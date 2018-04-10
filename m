Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:14185 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbeDJLKc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 07:10:32 -0400
Subject: Re: [RFCv11 PATCH 07/29] media-request: add media_request_object_find
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-8-hverkuil@xs4all.nl>
 <20180410080727.59e8fd7c@vento.lan>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <87616da3-0ab4-eae0-d0a8-7720e5da0ca5@cisco.com>
Date: Tue, 10 Apr 2018 13:10:29 +0200
MIME-Version: 1.0
In-Reply-To: <20180410080727.59e8fd7c@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/18 13:07, Mauro Carvalho Chehab wrote:
> Em Mon,  9 Apr 2018 16:20:04 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add media_request_object_find to find a request object inside a
>> request based on ops and/or priv values.
>>
>> Objects of the same type (vb2 buffer, control handler) will have
>> the same ops value. And objects that refer to the same 'parent'
>> object (e.g. the v4l2_ctrl_handler that has the current driver
>> state) will have the same priv value.
>>
>> The caller has to call media_request_object_put() for the returned
>> object since this function increments the refcount.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/media-request.c | 26 ++++++++++++++++++++++++++
>>  include/media/media-request.h | 25 +++++++++++++++++++++++++
>>  2 files changed, 51 insertions(+)
>>
>> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
>> index 02b620c81de5..415f7e31019d 100644
>> --- a/drivers/media/media-request.c
>> +++ b/drivers/media/media-request.c
>> @@ -322,6 +322,32 @@ static void media_request_object_release(struct kref *kref)
>>  	obj->ops->release(obj);
>>  }
>>  
>> +struct media_request_object *
>> +media_request_object_find(struct media_request *req,
>> +			  const struct media_request_object_ops *ops,
>> +			  void *priv)
>> +{
>> +	struct media_request_object *obj;
>> +	struct media_request_object *found = NULL;
>> +	unsigned long flags;
>> +
>> +	if (!ops && !priv)
>> +		return NULL;
>> +
>> +	spin_lock_irqsave(&req->lock, flags);
>> +	list_for_each_entry(obj, &req->objects, list) {
>> +		if ((!ops || obj->ops == ops) &&
>> +		    (!priv || obj->priv == priv)) {
>> +			media_request_object_get(obj);
>> +			found = obj;
>> +			break;
>> +		}
>> +	}
>> +	spin_unlock_irqrestore(&req->lock, flags);
> 
> Huh? The spin lock were used before only to protect the req->state,
> while the mutex is the one that protects the request itself.
> 
> So, here, it should be doing mutex_lock/unlock() instead.

The mutex only serializes the actual queuing operation where you queue a
request (and will likely have to sleep etc.). The spinlock is for the the
other fields of the media_request struct.

Regards,

	Hans

> 
>> +	return found;
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_object_find);
>> +
>>  void media_request_object_put(struct media_request_object *obj)
>>  {
>>  	kref_put(&obj->kref, media_request_object_release);
>> diff --git a/include/media/media-request.h b/include/media/media-request.h
>> index 033697d493cd..ea990c8f76bc 100644
>> --- a/include/media/media-request.h
>> +++ b/include/media/media-request.h
>> @@ -130,6 +130,23 @@ static inline void media_request_object_get(struct media_request_object *obj)
>>   */
>>  void media_request_object_put(struct media_request_object *obj);
>>  
>> +/**
>> + * media_request_object_find - Find an object in a request
>> + *
>> + * @ops: Find an object with this ops value, may be NULL.
>> + * @priv: Find an object with this priv value, may be NULL.
> 
> @req ?
> 
>> + *
>> + * At least one of @ops and @priv must be non-NULL. If one of
>> + * these is NULL, then skip checking for that field.
>> + *
>> + * Returns NULL if not found or the object (the refcount is increased
>> + * in that case).
>> + */
>> +struct media_request_object *
>> +media_request_object_find(struct media_request *req,
>> +			  const struct media_request_object_ops *ops,
>> +			  void *priv);
>> +
>>  /**
>>   * media_request_object_init - Initialise a media request object
>>   *
>> @@ -162,6 +179,14 @@ static inline void media_request_object_put(struct media_request_object *obj)
>>  {
>>  }
>>  
>> +static inline struct media_request_object *
>> +media_request_object_find(struct media_request *req,
>> +			  const struct media_request_object_ops *ops,
>> +			  void *priv)
>> +{
>> +	return NULL;
>> +}
>> +
>>  static inline void media_request_object_init(struct media_request_object *obj)
>>  {
>>  	obj->ops = NULL;
> 
> 
> 
> Thanks,
> Mauro
> 

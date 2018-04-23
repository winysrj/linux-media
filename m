Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41182 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755198AbeDWNzW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:55:22 -0400
Subject: Re: [RFCv11 PATCH 07/29] media-request: add media_request_object_find
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-8-hverkuil@xs4all.nl>
 <20180412122347.rogag443n5q5mvkx@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <74c82123-fe53-911d-35c1-a08cbbaec0fc@xs4all.nl>
Date: Mon, 23 Apr 2018 15:55:17 +0200
MIME-Version: 1.0
In-Reply-To: <20180412122347.rogag443n5q5mvkx@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2018 02:23 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Apr 09, 2018 at 04:20:04PM +0200, Hans Verkuil wrote:
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
> 
> I think I may have given the similar comment on an earlier version but I
> don't remember a reply to that at least --- is there a case where the
> object wouldn't be uniquely identified by req together with priv?
> 
> It'd be still prudent to check that ops match, but failing that check, I'd
> add WARN_ON() because it's a sign something is wrong.

Currently both ops and priv are always non-NULL, so I've made that the
requirement and call WARN_ON if either is NULL.

Regards,

	Hans

> 
>> +			media_request_object_get(obj);
>> +			found = obj;
>> +			break;
>> +		}
>> +	}
>> +	spin_unlock_irqrestore(&req->lock, flags);
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

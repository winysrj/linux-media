Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:51881 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727986AbeHNLcL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:32:11 -0400
Subject: Re: [PATCHv17 16/34] v4l2-ctrls: add
 v4l2_ctrl_request_hdl_find/put/ctrl_find functions
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
 <20180804124526.46206-17-hverkuil@xs4all.nl>
 <20180813080703.4ce872c1@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ef84cba0-52d4-b532-8469-ff4fdc10192d@xs4all.nl>
Date: Tue, 14 Aug 2018 10:45:57 +0200
MIME-Version: 1.0
In-Reply-To: <20180813080703.4ce872c1@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/08/18 13:07, Mauro Carvalho Chehab wrote:
> Em Sat,  4 Aug 2018 14:45:08 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> If a driver needs to find/inspect the controls set in a request then
>> it can use these functions.
>>
>> E.g. to check if a required control is set in a request use this in the
>> req_validate() implementation:
>>
>> 	int res = -EINVAL;
>>
>> 	hdl = v4l2_ctrl_request_hdl_find(req, parent_hdl);
>> 	if (hdl) {
>> 		if (v4l2_ctrl_request_hdl_ctrl_find(hdl, ctrl_id))
>> 			res = 0;
>> 		v4l2_ctrl_request_hdl_put(hdl);
>> 	}
>> 	return res;
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-ctrls.c | 25 ++++++++++++++++
>>  include/media/v4l2-ctrls.h           | 44 +++++++++++++++++++++++++++-
>>  2 files changed, 68 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 86a6ae54ccaa..2a30be824491 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -2976,6 +2976,31 @@ static const struct media_request_object_ops req_ops = {
>>  	.release = v4l2_ctrl_request_release,
>>  };
>>  
>> +struct v4l2_ctrl_handler *v4l2_ctrl_request_hdl_find(struct media_request *req,
>> +					struct v4l2_ctrl_handler *parent)
>> +{
>> +	struct media_request_object *obj;
>> +
>> +	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_VALIDATING &&
>> +		    req->state != MEDIA_REQUEST_STATE_QUEUED))
>> +		return NULL;
>> +
>> +	obj = media_request_object_find(req, &req_ops, parent);
>> +	if (obj)
>> +		return container_of(obj, struct v4l2_ctrl_handler, req_obj);
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_ctrl_request_hdl_find);
>> +
>> +struct v4l2_ctrl *
>> +v4l2_ctrl_request_hdl_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id)
>> +{
>> +	struct v4l2_ctrl_ref *ref = find_ref_lock(hdl, id);
>> +
>> +	return (ref && ref->req == ref) ? ref->ctrl : NULL;
> 
> Doesn't those helper functions (including this one) be serialized?

v4l2_ctrl_request_hdl_find() checks the request state to ensure this:
it is either VALIDATING (then the req_queue_mutex is locked) or QUEUED
and then it is under control of the driver. Of course, in that case the
driver should make sure that it doesn't complete the request in the
middle of calling this function. If a driver does that, then it is a driver
bug.

Regards,

	Hans

> 
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_ctrl_request_hdl_ctrl_find);
>> +
>>  static int v4l2_ctrl_request_bind(struct media_request *req,
>>  			   struct v4l2_ctrl_handler *hdl,
>>  			   struct v4l2_ctrl_handler *from)
>> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
>> index 98b1e70a4a46..aeb7f3c24ef7 100644
>> --- a/include/media/v4l2-ctrls.h
>> +++ b/include/media/v4l2-ctrls.h
>> @@ -1111,7 +1111,49 @@ void v4l2_ctrl_request_setup(struct media_request *req,
>>   * request object.
>>   */
>>  void v4l2_ctrl_request_complete(struct media_request *req,
>> -				struct v4l2_ctrl_handler *hdl);
>> +				struct v4l2_ctrl_handler *parent);
>> +
>> +/**
>> + * v4l2_ctrl_request_hdl_find - Find the control handler in the request
>> + *
>> + * @req: The request
>> + * @parent: The parent control handler ('priv' in media_request_object_find())
>> + *
>> + * This function finds the control handler in the request. It may return
>> + * NULL if not found. When done, you must call v4l2_ctrl_request_put_hdl()
>> + * with the returned handler pointer.
>> + *
>> + * If the request is not in state VALIDATING or QUEUED, then this function
>> + * will always return NULL.
>> + */
>> +struct v4l2_ctrl_handler *v4l2_ctrl_request_hdl_find(struct media_request *req,
>> +					struct v4l2_ctrl_handler *parent);
>> +
>> +/**
>> + * v4l2_ctrl_request_hdl_put - Put the control handler
>> + *
>> + * @hdl: Put this control handler
>> + *
>> + * This function released the control handler previously obtained from'
>> + * v4l2_ctrl_request_hdl_find().
>> + */
>> +static inline void v4l2_ctrl_request_hdl_put(struct v4l2_ctrl_handler *hdl)
>> +{
>> +	if (hdl)
>> +		media_request_object_put(&hdl->req_obj);
>> +}
>> +
>> +/**
>> + * v4l2_ctrl_request_ctrl_find() - Find a control with the given ID.
>> + *
>> + * @hdl: The control handler from the request.
>> + * @id: The ID of the control to find.
>> + *
>> + * This function returns a pointer to the control if this control is
>> + * part of the request or NULL otherwise.
>> + */
>> +struct v4l2_ctrl *
>> +v4l2_ctrl_request_hdl_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id);
>>  
>>  /* Helpers for ioctl_ops */
>>  
> 
> 
> 
> Thanks,
> Mauro
> 

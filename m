Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:51392 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728209AbeHNKFE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 06:05:04 -0400
Subject: Re: [PATCHv17 26/34] videobuf2-v4l2: add vb2_request_queue/validate
 helpers
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
 <20180804124526.46206-27-hverkuil@xs4all.nl>
 <20180813115323.1d23fd3b@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b3de2d0f-68af-aef0-af28-4317c7638311@xs4all.nl>
Date: Tue, 14 Aug 2018 09:19:08 +0200
MIME-Version: 1.0
In-Reply-To: <20180813115323.1d23fd3b@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/08/18 16:53, Mauro Carvalho Chehab wrote:
> Em Sat,  4 Aug 2018 14:45:18 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The generic vb2_request_validate helper function checks if
>> there are buffers in the request and if so, prepares (validates)
>> all objects in the request.
>>
>> The generic vb2_request_queue helper function queues all buffer
>> objects in the validated request.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  .../media/common/videobuf2/videobuf2-v4l2.c   | 44 +++++++++++++++++++
>>  include/media/videobuf2-v4l2.h                |  4 ++
>>  2 files changed, 48 insertions(+)
>>
>> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> index 9c652afa62ab..88d8f60c742b 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> @@ -1100,6 +1100,50 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
>>  
>> +int vb2_request_validate(struct media_request *req)
>> +{
>> +	struct media_request_object *obj;
>> +	int ret = 0;
>> +
>> +	if (!vb2_request_has_buffers(req))
>> +		return -ENOENT;
> 
> This holds the spinlock...

The spinlock in vb2_request_has_buffers() is not needed if vb2_request_has_buffers()
is called from this validate function. While validating no new objects can be
added to the request, and since nothing has been queued yet objects cannot be
deleted either. That's true for this whole vb2_request_validate() function.

But should vb2_request_has_buffers() ever be called from a non-validate context,
then the spinlock would be needed.

I want to keep the spinlock in that function for now as it is more robust.

Regards,

	Hans

> 
>> +
>> +	list_for_each_entry(obj, &req->objects, list) {
>> +		if (!obj->ops->prepare)
>> +			continue;
>> +
>> +		ret = obj->ops->prepare(obj);
>> +		if (ret)
>> +			break;
>> +	}
>> +
> 
> Shouldn't this logic hold it too?
> 
>> +	if (ret) {
>> +		list_for_each_entry_continue_reverse(obj, &req->objects, list)
>> +			if (obj->ops->unprepare)
>> +				obj->ops->unprepare(obj);
>> +		return ret;
>> +	}
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(vb2_request_validate);
>> +
>> +void vb2_request_queue(struct media_request *req)
>> +{
>> +	struct media_request_object *obj, *obj_safe;
>> +
>> +	/* Queue all non-buffer objects */
>> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list)
>> +		if (obj->ops->queue && !vb2_request_object_is_buffer(obj))
>> +			obj->ops->queue(obj);
>> +
>> +	/* Queue all buffer objects */
>> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
>> +		if (obj->ops->queue && vb2_request_object_is_buffer(obj))
>> +			obj->ops->queue(obj);
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(vb2_request_queue);
>> +
>>  MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
>>  MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
>>  MODULE_LICENSE("GPL");
>> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
>> index 91a2b3e1a642..727855463838 100644
>> --- a/include/media/videobuf2-v4l2.h
>> +++ b/include/media/videobuf2-v4l2.h
>> @@ -303,4 +303,8 @@ void vb2_ops_wait_prepare(struct vb2_queue *vq);
>>   */
>>  void vb2_ops_wait_finish(struct vb2_queue *vq);
>>  
>> +struct media_request;
>> +int vb2_request_validate(struct media_request *req);
>> +void vb2_request_queue(struct media_request *req);
>> +
>>  #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
> 
> 
> 
> Thanks,
> Mauro
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:55851 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751065AbeECIbc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 04:31:32 -0400
Subject: Re: [RFCv12 PATCH 05/29] media-request: add media_request_find
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180501090051.9321-1-hverkuil@xs4all.nl>
 <20180501090051.9321-6-hverkuil@xs4all.nl>
 <20180502220614.khmasp7c43swaqid@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0f6f2608-9ec5-4982-19b7-d27801e87fef@xs4all.nl>
Date: Thu, 3 May 2018 10:31:30 +0200
MIME-Version: 1.0
In-Reply-To: <20180502220614.khmasp7c43swaqid@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/05/18 00:06, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the update.
> 
> On Tue, May 01, 2018 at 11:00:27AM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add media_request_find() to find a request based on the file
>> descriptor.
> 
> What would you think of calling this media_request_get_by_fd() instead?
> 
> I think what the function does has changed over the time a bit but the name
> has stayed.

Good idea, done.

Regards,

	Hans

> 
>>
>> The caller has to call media_request_put() for the returned
>> request since this function increments the refcount.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/media-request.c | 44 +++++++++++++++++++++++++++++++++++
>>  include/media/media-request.h | 10 ++++++++
>>  2 files changed, 54 insertions(+)
>>
>> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
>> index 22881d5700c8..a186db290d51 100644
>> --- a/drivers/media/media-request.c
>> +++ b/drivers/media/media-request.c
>> @@ -234,6 +234,50 @@ static const struct file_operations request_fops = {
>>  	.release = media_request_close,
>>  };
>>  
>> +/**
>> + * media_request_find - Find a request based on the file descriptor
>> + * @mdev: The media device
>> + * @request_fd: The request file handle
>> + *
>> + * Find and return the request associated with the given file descriptor, or
>> + * an error if no such request exists.
>> + *
>> + * When the function returns a request it increases its reference count. The
>> + * caller is responsible for releasing the reference by calling
>> + * media_request_put() on the request.
>> + */
>> +struct media_request *
>> +media_request_find(struct media_device *mdev, int request_fd)
>> +{
>> +	struct file *filp;
>> +	struct media_request *req;
>> +
>> +	if (!mdev || !mdev->ops ||
>> +	    !mdev->ops->req_validate || !mdev->ops->req_queue)
>> +		return ERR_PTR(-EPERM);
>> +
>> +	filp = fget(request_fd);
>> +	if (!filp)
>> +		return ERR_PTR(-ENOENT);
>> +
>> +	if (filp->f_op != &request_fops)
>> +		goto err_fput;
>> +	req = filp->private_data;
>> +	if (req->mdev != mdev)
>> +		goto err_fput;
>> +
>> +	media_request_get(req);
>> +	fput(filp);
>> +
>> +	return req;
>> +
>> +err_fput:
>> +	fput(filp);
>> +
>> +	return ERR_PTR(-ENOENT);
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_find);
>> +
>>  int media_request_alloc(struct media_device *mdev,
>>  			struct media_request_alloc *alloc)
>>  {
>> diff --git a/include/media/media-request.h b/include/media/media-request.h
>> index 9051dfbc7d30..ce62fe74ebd6 100644
>> --- a/include/media/media-request.h
>> +++ b/include/media/media-request.h
>> @@ -70,6 +70,9 @@ static inline void media_request_get(struct media_request *req)
>>  void media_request_put(struct media_request *req);
>>  void media_request_cancel(struct media_request *req);
>>  
>> +struct media_request *
>> +media_request_find(struct media_device *mdev, int request_fd);
>> +
>>  int media_request_alloc(struct media_device *mdev,
>>  			struct media_request_alloc *alloc);
>>  #else
>> @@ -85,6 +88,12 @@ static inline void media_request_cancel(struct media_request *req)
>>  {
>>  }
>>  
>> +static inline struct media_request *
>> +media_request_find(struct media_device *mdev, int request_fd)
>> +{
>> +	return ERR_PTR(-ENOENT);
>> +}
>> +
>>  #endif
>>  
>>  struct media_request_object_ops {
>> @@ -188,6 +197,7 @@ static inline void media_request_object_unbind(struct media_request_object *obj)
>>  static inline void media_request_object_complete(struct media_request_object *obj)
>>  {
>>  }
>> +
>>  #endif
>>  
>>  #endif
>> -- 
>> 2.17.0
>>
> 

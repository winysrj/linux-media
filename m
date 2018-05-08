Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:48595 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754355AbeEHHeT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 03:34:19 -0400
Subject: Re: [PATCHv13 04/28] media-request: add media_request_get_by_fd
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
 <20180503145318.128315-5-hverkuil@xs4all.nl>
 <20180507140120.4f04b9bb@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bad8f0a4-4e78-865a-9083-6dafb03722a1@xs4all.nl>
Date: Tue, 8 May 2018 09:34:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180507140120.4f04b9bb@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/07/2018 07:01 PM, Mauro Carvalho Chehab wrote:
> Em Thu,  3 May 2018 16:52:54 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add media_request_get_by_fd() to find a request based on the file
>> descriptor.
>>
>> The caller has to call media_request_put() for the returned
>> request since this function increments the refcount.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/media-request.c | 32 ++++++++++++++++++++++++++++++++
>>  include/media/media-request.h | 24 ++++++++++++++++++++++++
>>  2 files changed, 56 insertions(+)
>>
>> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
>> index c216c4ab628b..edc1c3af1959 100644
>> --- a/drivers/media/media-request.c
>> +++ b/drivers/media/media-request.c
>> @@ -218,6 +218,38 @@ static const struct file_operations request_fops = {
>>  	.release = media_request_close,
>>  };
>>  
>> +struct media_request *
>> +media_request_get_by_fd(struct media_device *mdev, int request_fd)
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
> 
> Hmm... this function changes the req struct (by calling kref_get) without
> holding neither the mutex or the spin lock...

kref_get is atomic, so why would you need to add additional locking?

Neither can the request be 'put' by another process before media_request_get()
is called due to the fget() above: while the fd has a refcount > 0 the
request refcount is also > 0. I'll add some comments to clarify this.

> 
>> +	fput(filp);
>> +
>> +	return req;
>> +
>> +err_fput:
>> +	fput(filp);
>> +
>> +	return ERR_PTR(-ENOENT);
>> +}
>> +EXPORT_SYMBOL_GPL(media_request_get_by_fd);
>> +
>>  int media_request_alloc(struct media_device *mdev,
>>  			struct media_request_alloc *alloc)
>>  {
>> diff --git a/include/media/media-request.h b/include/media/media-request.h
>> index e39122dfd717..997e096d7128 100644
>> --- a/include/media/media-request.h
>> +++ b/include/media/media-request.h
>> @@ -86,6 +86,24 @@ static inline void media_request_get(struct media_request *req)
>>   */
>>  void media_request_put(struct media_request *req);
>>  
>> +/**
>> + * media_request_get_by_fd - Get a media request by fd
>> + *
>> + * @mdev: Media device this request belongs to
>> + * @request_fd: The file descriptor of the request
>> + *
>> + * Get the request represented by @request_fd that is owned
>> + * by the media device.
>> + *
>> + * Return a -EPERM error pointer if requests are not supported
>> + * by this driver. Return -ENOENT if the request was not found.
>> + * Return the pointer to the request if found: the caller will
>> + * have to call @media_request_put when it finished using the
>> + * request.
> 
> ... so, it should be said here how this should be serialized, in order
> to avoid it to be destroyed by a task while some other task might be
> trying to instantiate it.

This doesn't need any serialization. If the request_fd is found, then
it will return the request with the request refcount increased.

I also do not understand what you mean with "some other task might be
trying to instantiate it".

I think there is some misunderstanding here.

Regards,

	Hans


> 
>> + */
>> +struct media_request *
>> +media_request_get_by_fd(struct media_device *mdev, int request_fd);
>> +
>>  /**
>>   * media_request_alloc - Allocate the media request
>>   *
>> @@ -107,6 +125,12 @@ static inline void media_request_put(struct media_request *req)
>>  {
>>  }
>>  
>> +static inline struct media_request *
>> +media_request_get_by_fd(struct media_device *mdev, int request_fd)
>> +{
>> +	return ERR_PTR(-EPERM);
>> +}
>> +
>>  #endif
>>  
>>  /**
> 
> 
> 
> Thanks,
> Mauro
> 

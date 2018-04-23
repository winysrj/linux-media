Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:34137 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755198AbeDWNvE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:51:04 -0400
Subject: Re: [RFCv11 PATCH 06/29] media-request: add media_request_find
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-7-hverkuil@xs4all.nl>
 <20180412120800.bdwtagklz6rqopvn@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <edd62690-e5fb-06a8-b400-03c28e2cfbe2@xs4all.nl>
Date: Mon, 23 Apr 2018 15:50:59 +0200
MIME-Version: 1.0
In-Reply-To: <20180412120800.bdwtagklz6rqopvn@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2018 02:08 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Apr 09, 2018 at 04:20:03PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add media_request_find() to find a request based on the file
>> descriptor.
>>
>> The caller has to call media_request_put() for the returned
>> request since this function increments the refcount.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/media-request.c | 47 +++++++++++++++++++++++++++++++++++++++++++
>>  include/media/media-request.h | 10 +++++++++
>>  2 files changed, 57 insertions(+)
>>
>> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
>> index 27739ff7cb09..02b620c81de5 100644
>> --- a/drivers/media/media-request.c
>> +++ b/drivers/media/media-request.c
>> @@ -207,6 +207,53 @@ static const struct file_operations request_fops = {
>>  	.release = media_request_close,
>>  };
>>  
>> +/**
>> + * media_request_find - Find a request based on the file descriptor
>> + * @mdev: The media device
>> + * @request: The request file handle
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
>> +	if (!mdev || !mdev->ops || !mdev->ops->req_queue)
>> +		return ERR_PTR(-EPERM);
>> +
>> +	filp = fget(request_fd);
>> +	if (!filp)
>> +		return ERR_PTR(-ENOENT);
>> +
>> +	if (filp->f_op != &request_fops)
>> +		goto err_fput;
>> +	req = filp->private_data;
>> +	media_request_get(req);
> 
> As you're holding a reference to filp, you also indirectly have reference
> to ref --- you otherwise couldn't access file->private_data either.
> 
> Therefore you could move the check for the right mdev before getting a
> reference to req, thus simplifying error handling as a result.

True. Done.

Regards,

	Hans

> 
>> +
>> +	if (req->mdev != mdev)
>> +		goto err_kref_put;
>> +
>> +	fput(filp);
>> +
>> +	return req;
>> +
>> +err_kref_put:
>> +	media_request_put(req);
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
> 

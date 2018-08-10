Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52604 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727422AbeHJKBh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 06:01:37 -0400
Subject: Re: [PATCHv17 05/34] media-request: add media_request_get_by_fd
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
 <20180804124526.46206-6-hverkuil@xs4all.nl>
 <20180809165500.2cc89f72@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <75c40b64-077b-1187-bebe-561dc4ab1590@xs4all.nl>
Date: Fri, 10 Aug 2018 09:32:53 +0200
MIME-Version: 1.0
In-Reply-To: <20180809165500.2cc89f72@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/2018 09:55 PM, Mauro Carvalho Chehab wrote:
> Em Sat,  4 Aug 2018 14:44:57 +0200
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
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  drivers/media/media-request.c | 40 +++++++++++++++++++++++++++++++++++
>>  include/media/media-request.h | 24 +++++++++++++++++++++
>>  2 files changed, 64 insertions(+)
>>
>> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
>> index 253068f51a1f..4b523f3a03a3 100644
>> --- a/drivers/media/media-request.c
>> +++ b/drivers/media/media-request.c
>> @@ -231,6 +231,46 @@ static const struct file_operations request_fops = {
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
> 
> EPERM? I guess ENOTTY would be better.
> 
> Any reason why using EPERM?

This is called by e.g. VIDIOC_QBUF or VIDIOC_S/G/TRY_EXT_CTRLS where someone
sets request_fd. Then this function is called to obtain the corresponding
media_request struct. If requests are not supported, then EPERM is returned.

Returning ENOTTY would be wrong, since VIDIOC_QBUF etc. are definitely implemented,
instead they just do not permit the use of requests.

Let me know if I can add your Reviewed-by after this explanation.

Regards,

	Hans

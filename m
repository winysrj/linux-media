Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:52684 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754363AbeEHHtN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 03:49:13 -0400
Subject: Re: [PATCHv13 09/28] v4l2-ctrls: prepare internal structs for request
 API
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
 <20180503145318.128315-10-hverkuil@xs4all.nl>
 <20180507143512.3688897b@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <64b7f316-dd03-dc9c-0a37-15194c503b31@xs4all.nl>
Date: Tue, 8 May 2018 09:49:09 +0200
MIME-Version: 1.0
In-Reply-To: <20180507143512.3688897b@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/07/2018 07:35 PM, Mauro Carvalho Chehab wrote:
> Em Thu,  3 May 2018 16:52:59 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Embed and initialize a media_request_object in struct v4l2_ctrl_handler.
>>
>> Add a p_req field to struct v4l2_ctrl_ref that will store the
>> request value.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  drivers/media/v4l2-core/v4l2-ctrls.c | 1 +
>>  include/media/v4l2-ctrls.h           | 7 +++++++
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index aa1dd2015e84..d09f49530d9e 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -1880,6 +1880,7 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
>>  				      sizeof(hdl->buckets[0]),
>>  				      GFP_KERNEL | __GFP_ZERO);
>>  	hdl->error = hdl->buckets ? 0 : -ENOMEM;
>> +	media_request_object_init(&hdl->req_obj);
>>  	return hdl->error;
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_handler_init_class);
>> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
>> index d26b8ddebb56..76352eb59f14 100644
>> --- a/include/media/v4l2-ctrls.h
>> +++ b/include/media/v4l2-ctrls.h
>> @@ -20,6 +20,7 @@
>>  #include <linux/list.h>
>>  #include <linux/mutex.h>
>>  #include <linux/videodev2.h>
>> +#include <media/media-request.h>
>>  
>>  /* forward references */
>>  struct file;
>> @@ -249,6 +250,8 @@ struct v4l2_ctrl {
>>   *		``prepare_ext_ctrls`` function at ``v4l2-ctrl.c``.
>>   * @from_other_dev: If true, then @ctrl was defined in another
>>   *		device than the &struct v4l2_ctrl_handler.
>> + * @p_req:	The request value. Only used if the control handler
>> + *		is bound to a media request.
> 
> Could you please better elaborate the description of this field?
> 
> I read this patch dozen times to understand what you meant by
> "request value", as I would be expecting here a "media_request_"
> object or something similar. Instead, what you meant to say is that
> @p_req will be used to cache the data passed via a request API call,
> while the request is not handled yet, right?

The control handler has the request object. If the control handler is
part of a request, then the values of the controls that are owned by that
control handler are stored in p_req. When the request has been completed
p_req will contain the value at completion time.

I'll improve the documentation.

> 
> 
>>   *
>>   * Each control handler has a list of these refs. The list_head is used to
>>   * keep a sorted-by-control-ID list of all controls, while the next pointer
>> @@ -260,6 +263,7 @@ struct v4l2_ctrl_ref {
>>  	struct v4l2_ctrl *ctrl;
>>  	struct v4l2_ctrl_helper *helper;
>>  	bool from_other_dev;
>> +	union v4l2_ctrl_ptr p_req;
>>  };
>>  
>>  /**
>> @@ -283,6 +287,8 @@ struct v4l2_ctrl_ref {
>>   * @notify_priv: Passed as argument to the v4l2_ctrl notify callback.
>>   * @nr_of_buckets: Total number of buckets in the array.
>>   * @error:	The error code of the first failed control addition.
>> + * @req_obj:	The &struct media_request_object, used to link into a
>> + *		&struct media_request.
> 
> I would document that there is kref is inside @req_obj, as we can't
> add another kref here later.

OK.

Regards,

	Hans

> 
>>   */
>>  struct v4l2_ctrl_handler {
>>  	struct mutex _lock;
>> @@ -295,6 +301,7 @@ struct v4l2_ctrl_handler {
>>  	void *notify_priv;
>>  	u16 nr_of_buckets;
>>  	int error;
>> +	struct media_request_object req_obj;
>>  };
>>  
>>  /**
> 
> 
> 
> Thanks,
> Mauro
> 

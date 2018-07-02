Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41131 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965489AbeGBL0z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 07:26:55 -0400
Subject: Re: [PATCHv15 02/35] media-request: implement media requests
To: Tomasz Figa <tfiga@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
 <20180604114648.26159-3-hverkuil@xs4all.nl>
 <CAAFQd5BMjCJGdDRgF6rvRyi7FNVtvJA5sSqAsgYju1RcgkUPcA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <df0c2c76-011e-da59-044b-a69e86d4a2a3@xs4all.nl>
Date: Mon, 2 Jul 2018 13:26:50 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BMjCJGdDRgF6rvRyi7FNVtvJA5sSqAsgYju1RcgkUPcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/18 12:56, Tomasz Figa wrote:
> Hi Hans,
> 
> On Mon, Jun 4, 2018 at 8:47 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> [snip]
>> +static void media_request_object_release(struct kref *kref)
>> +{
>> +       struct media_request_object *obj =
>> +               container_of(kref, struct media_request_object, kref);
>> +       struct media_request *req = obj->req;
>> +
>> +       if (req)
>> +               media_request_object_unbind(obj);
> 
> Is it possible and fine to have a request bound here?
> media_request_clean() seems to explicitly unbind before releasing and
> this function would be only called if last reference is put, so maybe
> we should actually WARN_ON(req)?

I agree. It used to be that req could be non-NULL for valid reasons in
previous versions of the series (at least, I think so), but this is no
longer the case in the current code. Adding a WARN_ON makes a lot of
sense.

> 
>> +       obj->ops->release(obj);
>> +}
> [snip]
>> @@ -87,7 +104,12 @@ struct media_device_ops {
>>   * @enable_source: Enable Source Handler function pointer
>>   * @disable_source: Disable Source Handler function pointer
>>   *
>> + * @req_queue_mutex: Serialise validating and queueing requests in order to
>> + *                  guarantee exclusive access to the state of the device on
>> + *                  the tip of the request queue.
>>   * @ops:       Operation handler callbacks
>> + * @req_queue_mutex: Serialise the MEDIA_REQUEST_IOC_QUEUE ioctl w.r.t.
>> + *                  other operations that stop or start streaming.
> 
> Merge conflict? req_queue_mutex is documented twice.

Thanks, I'll remove that.

Regards,

	Hans

> 
> Best regards,
> Tomasz
> 

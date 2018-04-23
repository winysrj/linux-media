Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:54655 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754624AbeDWLeq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 07:34:46 -0400
Subject: Re: [RFCv11 PATCH 05/29] media-request: add request ioctls
To: Tomasz Figa <tfiga@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-6-hverkuil@xs4all.nl>
 <CAAFQd5ABOWjj9esLBxrOV_b8edv5_-VSCZNp6iZYTbUVeP9Xqw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6a5b852b-6a9d-7290-bdfa-1fcbef407b6d@xs4all.nl>
Date: Mon, 23 Apr 2018 13:34:41 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5ABOWjj9esLBxrOV_b8edv5_-VSCZNp6iZYTbUVeP9Xqw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/2018 10:59 AM, Tomasz Figa wrote:
> Hi Hans,
> 
> On Mon, Apr 9, 2018 at 11:21 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
>> Implement the MEDIA_REQUEST_IOC_QUEUE and MEDIA_REQUEST_IOC_REINIT
>> ioctls.
> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/media/media-request.c | 80
> +++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 78 insertions(+), 2 deletions(-)
> 
>> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
>> index dffc290e4ada..27739ff7cb09 100644
>> --- a/drivers/media/media-request.c
>> +++ b/drivers/media/media-request.c
>> @@ -118,10 +118,86 @@ static unsigned int media_request_poll(struct file
> *filp,
>>          return 0;
>>   }
> 
>> +static long media_request_ioctl_queue(struct media_request *req)
>> +{
>> +       struct media_device *mdev = req->mdev;
>> +       unsigned long flags;
>> +       int ret = 0;
>> +
>> +       dev_dbg(mdev->dev, "request: queue %s\n", req->debug_str);
>> +
>> +       spin_lock_irqsave(&req->lock, flags);
>> +       if (req->state != MEDIA_REQUEST_STATE_IDLE) {
>> +               dev_dbg(mdev->dev,
>> +                       "request: unable to queue %s, request in state
> %s\n",
>> +                       req->debug_str,
> media_request_state_str(req->state));
>> +               spin_unlock_irqrestore(&req->lock, flags);
>> +               return -EINVAL;
> 
> nit: Perhaps -EBUSY? (vb2 returns -EINVAL, though, but IMHO it doesn't
> really represent the real error too closely.)

I agree, also in reinit.

> 
>> +       }
>> +       req->state = MEDIA_REQUEST_STATE_QUEUEING;
>> +
>> +       spin_unlock_irqrestore(&req->lock, flags);
>> +
>> +       /*
>> +        * Ensure the request that is validated will be the one that gets
> queued
>> +        * next by serialising the queueing process.
>> +        */
>> +       mutex_lock(&mdev->req_queue_mutex);
>> +
>> +       ret = mdev->ops->req_queue(req);
>> +       spin_lock_irqsave(&req->lock, flags);
>> +       req->state = ret ? MEDIA_REQUEST_STATE_IDLE :
> MEDIA_REQUEST_STATE_QUEUED;
>> +       spin_unlock_irqrestore(&req->lock, flags);
>> +       mutex_unlock(&mdev->req_queue_mutex);
>> +
>> +       if (ret) {
>> +               dev_dbg(mdev->dev, "request: can't queue %s (%d)\n",
>> +                       req->debug_str, ret);
>> +       } else {
>> +               media_request_get(req);
> 
> I'm not convinced that this is the right place to take a reference. IMHO
> whoever saves a pointer to the request in its own internal data (the
> ->req_queue() callback?), should also grab a reference before doing so. Not
> a strong objection, though, if we clearly document this, so that whoever
> implements ->req_queue() callback can do the right thing.
No, it belongs here. The reason is that request_put is also called here when
the request is completed. And it makes no sense to move the put to drivers as
well since it is only called when the whole request is completed.

Regards,

	Hans

> 
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +static long media_request_ioctl_reinit(struct media_request *req)
>> +{
>> +       struct media_device *mdev = req->mdev;
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&req->lock, flags);
>> +       if (req->state != MEDIA_REQUEST_STATE_IDLE &&
>> +           req->state != MEDIA_REQUEST_STATE_COMPLETE) {
>> +               dev_dbg(mdev->dev,
>> +                       "request: %s not in idle or complete state,
> cannot reinit\n",
>> +                       req->debug_str);
>> +               spin_unlock_irqrestore(&req->lock, flags);
>> +               return -EINVAL;
> 
> nit: Perhaps -EBUSY? (Again vb2 would return -EINVAL...)
> 
> Best regards,
> Tomasz
> 

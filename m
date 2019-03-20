Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBE3C10F05
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 10:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 241A92184E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 10:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfCTKph (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:45:37 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:34017 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725905AbfCTKph (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 06:45:37 -0400
Received: from [IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e] ([IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 6YizhA4Im4HFn6Yj0hy27k; Wed, 20 Mar 2019 11:45:34 +0100
Subject: Re: [PATCH v5 01/23] vb2: add requires_requests bit for stateless
 codecs
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Dafna Hirschfeld <dafna3@gmail.com>
Cc:     linux-media@vger.kernel.org, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
References: <20190306211343.15302-1-dafna3@gmail.com>
 <20190306211343.15302-2-dafna3@gmail.com> <20190320072124.675fd13b@coco.lan>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d4db89fd-567d-5343-a16e-469a96be671c@xs4all.nl>
Date:   Wed, 20 Mar 2019 11:45:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190320072124.675fd13b@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEDJhI+mh+VHBJvVfYzj3gilyuXTwRM+KXrPduecBMKxausAzLrjKvTgnGVKp+bjrT4RZotA5CKTu47quzDh9yNoV1d243qlqz5lVJ4yd3xyBEnTrYQP
 r0hT2hDjJ/SfedgRsZaGo9hxzezbQLNafNLaXKesPgB+8v/7ejm/D0TNAYFWHdiJzKoi8qotL+ThgRtBjnA4CEMST0qfEvJ0A6t1UmRxocenS9zFTriFEJFp
 bb8f3zB//XzoISGsa/K7GV4KnlQP4CoSrkS6oWXeV3YF56h36B+Wv4IVHuODL1eMWpE1ShjI5Y9dD4+lt5BYmpvthzbsBCFvz8NTkW6DXAH5dUMNJWj8tagG
 AGFTyIZ0PvWdNWZYU0ql4q/jncUuQL024NjneCGApP61rAo/ifibxa91Do8lS+Ajc8lXmX4t
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/20/19 11:21 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Mar 2019 13:13:21 -0800
> Dafna Hirschfeld <dafna3@gmail.com> escreveu:
> 
>> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>
>> Stateless codecs require the use of the Request API as opposed of it
>> being optional.
>>
>> So add a bit to indicate this and let vb2 check for this.
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>>  drivers/media/common/videobuf2/videobuf2-core.c | 5 ++++-
>>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 6 ++++++
>>  include/media/videobuf2-core.h                  | 3 +++
>>  3 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
>> index 15b6b9c0a2e4..d8cf9d3ec54d 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-core.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
>> @@ -1518,7 +1518,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>>  
>>  	if ((req && q->uses_qbuf) ||
>>  	    (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
>> -	     q->uses_requests)) {
>> +	     (q->uses_requests || q->requires_requests))) {
>>  		dprintk(1, "queue in wrong mode (qbuf vs requests)\n");
>>  		return -EBUSY;
> 
> Huh? -EBUSY doesn't seem the right error code to be issued if a driver
> ignores V4L2_BUF_CAP_REQUIRES_REQUESTS.

I agree. See my next comment below.

> 
>>  	}
>> @@ -2247,6 +2247,9 @@ int vb2_core_queue_init(struct vb2_queue *q)
>>  	    WARN_ON(!q->ops->buf_queue))
>>  		return -EINVAL;
>>  
>> +	if (WARN_ON(q->requires_requests && !q->supports_requests))
>> +		return -EINVAL;
>> +
>>  	INIT_LIST_HEAD(&q->queued_list);
>>  	INIT_LIST_HEAD(&q->done_list);
>>  	spin_lock_init(&q->done_lock);
>> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> index d09dee20e421..4dc4855056f1 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> @@ -385,6 +385,10 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
>>  			dprintk(1, "%s: queue uses requests\n", opname);
>>  			return -EBUSY;
>>  		}
>> +		if (q->requires_requests) {
>> +			dprintk(1, "%s: queue requires requests\n", opname);
>> +			return -EACCES;
> 
> I also don't think that -EACCES is the right error. This is not a matter of
> wrong permissions. Running the app as root won't make it work.

I believe EPERM is returned if you have the wrong permissions.

EACCES is returned when you are in the wrong mode, e.g. when attempting
to set a read-only control, or read from a write-only control.

So I believe this is indeed the right error code. And I also agree that the
core code above should return EACCES as well in this particular case instead
of EBUSY.

Regards,

	Hans

> 
>> +		}
>>  		return 0;
>>  	} else if (!q->supports_requests) {
>>  		dprintk(1, "%s: queue does not support requests\n", opname);
>> @@ -658,6 +662,8 @@ static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
>>  #ifdef CONFIG_MEDIA_CONTROLLER_REQUEST_API
>>  	if (q->supports_requests)
>>  		*caps |= V4L2_BUF_CAP_SUPPORTS_REQUESTS;
>> +	if (q->requires_requests)
>> +		*caps |= V4L2_BUF_CAP_REQUIRES_REQUESTS;
>>  #endif
>>  }
>>  
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index 910f3d469005..fbf8dbbcbc09 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -484,6 +484,8 @@ struct vb2_buf_ops {
>>   *              has not been called. This is a vb1 idiom that has been adopted
>>   *              also by vb2.
>>   * @supports_requests: this queue supports the Request API.
>> + * @requires_requests: this queue requires the Request API. If this is set to 1,
>> + *		then supports_requests must be set to 1 as well.
>>   * @uses_qbuf:	qbuf was used directly for this queue. Set to 1 the first
>>   *		time this is called. Set to 0 when the queue is canceled.
>>   *		If this is 1, then you cannot queue buffers from a request.
>> @@ -558,6 +560,7 @@ struct vb2_queue {
>>  	unsigned			allow_zero_bytesused:1;
>>  	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
>>  	unsigned			supports_requests:1;
>> +	unsigned			requires_requests:1;
>>  	unsigned			uses_qbuf:1;
>>  	unsigned			uses_requests:1;
>>  
> 
> 
> 
> Thanks,
> Mauro
> 


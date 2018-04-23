Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:46467 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754902AbeDWMtb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:49:31 -0400
Subject: Re: [RFCv11 PATCH 19/29] videobuf2-core: integrate with media
 requests
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-20-hverkuil@xs4all.nl>
 <CAAFQd5B2Xs1Jc=DJsTYVTPC6GwMoyEdRHayVuWZQYTDStv1+Qg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <522675c0-a4f7-6e7f-f6a8-270fb9b98277@xs4all.nl>
Date: Mon, 23 Apr 2018 14:49:25 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5B2Xs1Jc=DJsTYVTPC6GwMoyEdRHayVuWZQYTDStv1+Qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2018 10:13 AM, Tomasz Figa wrote:
> Hi Hans,
> 
> On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
>> Buffers can now be prepared or queued for a request.
> 
>> A buffer is unbound from the request at vb2_buffer_done time or
>> when the queue is cancelled.
> 
> Please see my comments inline.
> 
> [snip]
>> -int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void
> *pb)
>> +static int vb2_req_prepare(struct media_request_object *obj)
>>   {
>> -       struct vb2_buffer *vb;
>> +       struct vb2_buffer *vb = container_of(obj, struct vb2_buffer,
> req_obj);
>>          int ret;
> 
>> +       if (WARN_ON(vb->state != VB2_BUF_STATE_IN_REQUEST))
>> +               return -EINVAL;
>> +
>> +       ret = __buf_prepare(vb, NULL);
>> +       if (ret)
>> +               vb->state = VB2_BUF_STATE_IN_REQUEST;
> 
> Hmm, I suppose this is here because __buf_prepare() changes the state to
> VB2_BUF_STATE_DEQUEUED on error (other than q->error)? I guess it's
> harmless, but perhaps we could have a comment explaining this?

Yes, that's the reason. But it is really ugly, so I changed __buf_prepare
instead: it now remembers the original state and restores it on error.

Much cleaner.

Regards,

	Hans

> 
> Best regards,
> Tomasz
> 

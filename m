Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB8FC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 09:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C033D20870
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 09:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfAWJ5X (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 04:57:23 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:41360 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727090AbfAWJ5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 04:57:23 -0500
Received: from [IPv6:2001:420:44c1:2579:d8f:48e2:1dc9:37b8] ([IPv6:2001:420:44c1:2579:d8f:48e2:1dc9:37b8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id mFHZg1vzHBDyImFHdgYKqS; Wed, 23 Jan 2019 10:57:21 +0100
Subject: Re: [PATCH] vb2: vb2_find_timestamp: drop restriction on buffer state
To:     Alexandre Courbot <acourbot@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
References: <c29a6f08-a450-73aa-c79d-93cdcbf416ae@xs4all.nl>
 <CAPBb6MUHJpuOGAR+v7dfaBDMT7F=hiTkKM_eZSFozOP_+gD7QQ@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57eb4ae8-c633-8e30-b65f-8c2d50bf1f17@xs4all.nl>
Date:   Wed, 23 Jan 2019 10:57:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAPBb6MUHJpuOGAR+v7dfaBDMT7F=hiTkKM_eZSFozOP_+gD7QQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGqlSylDtrrre413rq8dOajYjLHfbCmObf53QIclxkqpU6H/WlQ02lOGxFlyGppHpc/1x72njJnHHNp/Zkl1Q67b+Ci0Z1I6XoDjTY6e0O1P7jhNB9fW
 iEbRdhUspqaCidFDV4A52ORo2e2Sy+uGc8rmA9qWuhHkvdgTD5CieEeWueGubtJQ0RMTzr4m8ozfKuq2nQ3SGa+F7TpvbihHpXz+Vu0yQhKiez+9z0JRgr3s
 cKpYKIXu7WqWmy8Rw+CbEGLx1SU5mK70MHpASJASnFpSLLfJRg2c4QwJQ+4Iodhr6gt/KyOw5vyEjROYYIPB9Yi0EhapEeK9eEDn6DfPczgBxwCBX5YlFMSo
 gnAgat2utrVqy02UCXu5zvsaRI4WGDTduAR4+Sn8MahcMmtFNdA=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/23/19 10:48, Alexandre Courbot wrote:
> On Wed, Jan 23, 2019 at 5:30 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> There really is no reason why vb2_find_timestamp can't just find
>> buffers in any state. Drop that part of the test.
>>
>> This also means that vb->timestamp should only be set to 0 when a
>> capture buffer is queued AND when the driver doesn't copy timestamps.
>>
>> This change allows for more efficient pipelining (i.e. you can use
>> a buffer for a reference frame even when it is queued).
> 
> So I suppose the means the stateless codec API needs to be updated to
> reflect this? I cannot find any case where that would be a problem,
> but just out of curiosity, what triggered this change?

Two reasons, really: one was the discussion about decoding an interlaced
stream where the second field had to refer to the buffer for the first field,
requiring special code in the cedrus driver. With this change you no longer
need to do anything special.

The second was a discussion where it was pointed out that in the current
situation you cannot queue a capture buffer containing a reference frame
that is referred to by a queued, but not yet processed, output buffer.

This means you need to allocate more buffers than is strictly necessary.

The main limitation here was that the timestamp of a capture buffer was
set to 0, so you couldn't find these buffers anymore.

It's easy enough to fix in vb2 and I see no downsides to this change.

Regards,

	Hans

> 
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> index 75ea90e795d8..2a093bff0bf5 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> @@ -567,7 +567,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, struct vb2_plane *planes)
>>         struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>>         unsigned int plane;
>>
>> -       if (!vb->vb2_queue->is_output || !vb->vb2_queue->copy_timestamp)
>> +       if (!vb->vb2_queue->is_output && !vb->vb2_queue->copy_timestamp)
>>                 vb->timestamp = 0;
>>
>>         for (plane = 0; plane < vb->num_planes; ++plane) {
>> @@ -594,14 +594,9 @@ int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>>  {
>>         unsigned int i;
>>
>> -       for (i = start_idx; i < q->num_buffers; i++) {
>> -               struct vb2_buffer *vb = q->bufs[i];
>> -
>> -               if ((vb->state == VB2_BUF_STATE_DEQUEUED ||
>> -                    vb->state == VB2_BUF_STATE_DONE) &&
>> -                   vb->timestamp == timestamp)
>> +       for (i = start_idx; i < q->num_buffers; i++)
>> +               if (q->bufs[i]->timestamp == timestamp)
>>                         return i;
>> -       }
>>         return -1;
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_find_timestamp);
>> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
>> index a9961bc776dc..8a10889dc2fd 100644
>> --- a/include/media/videobuf2-v4l2.h
>> +++ b/include/media/videobuf2-v4l2.h
>> @@ -59,8 +59,7 @@ struct vb2_v4l2_buffer {
>>   * vb2_find_timestamp() - Find buffer with given timestamp in the queue
>>   *
>>   * @q:         pointer to &struct vb2_queue with videobuf2 queue.
>> - * @timestamp: the timestamp to find. Only buffers in state DEQUEUED or DONE
>> - *             are considered.
>> + * @timestamp: the timestamp to find.
>>   * @start_idx: the start index (usually 0) in the buffer array to start
>>   *             searching from. Note that there may be multiple buffers
>>   *             with the same timestamp value, so you can restart the search


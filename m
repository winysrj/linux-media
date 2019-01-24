Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1775CC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 07:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD3E621855
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 07:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbfAXHfe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 02:35:34 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:35820 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725931AbfAXHfe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 02:35:34 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id mZXsgVPYcNR5ymZXvgoaBQ; Thu, 24 Jan 2019 08:35:32 +0100
Subject: Re: [PATCH] vb2: vb2_find_timestamp: drop restriction on buffer state
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>
References: <c29a6f08-a450-73aa-c79d-93cdcbf416ae@xs4all.nl>
 <CAAFQd5BZnH_fuAVOf9cNWroKqDSYHUJ2HAFoebiqf9duDdrOYg@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e4c810ba-836d-0b41-efe4-15f044cb663e@xs4all.nl>
Date:   Thu, 24 Jan 2019 08:35:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BZnH_fuAVOf9cNWroKqDSYHUJ2HAFoebiqf9duDdrOYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKCG8UHolfpCZ8efwi85Xh6RAjLIlb/mDeoD7ofrYwR0TADcUVeue+q8dtxeoHmggPKT1PIrkAeGRUgoDyGJfYUPb0MAQ7QhcfliGoPhM3A6yML5EETv
 4xj7lnlot93fUw8JTpfYpp/pm3JHA7QjcXv7Cua7YOoIScs/uA0s2yZh5qWkYoT/eKdO36AZcOP815eu3mrKdTxgax34S8bd0khxIEh//BPiTPAYPBrbNtiH
 hYw3qSAIuAOf7TbUIQ/ZInOl7YADRZgUgQUfIOSRX4syuObHeyyPgOwdbP2huDVp
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/24/19 6:49 AM, Tomasz Figa wrote:
> Hi Hans,
> 
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
> 
> Is the change fully as expected?
> 
> Current behavior:
> 
>       COPY   !COPY
> CAP   0      0
> OUT   keep   0
> 
> New behavior:
> 
>       COPY   !COPY
> CAP   keep   0
> OUT   keep   keep
> 
> Don't we still want to zero OUT if !COPY? I suppose that would make
> the condition as simple as if (!vb->vb2_queue->copy_timestamp).

Ouch. Yes, you are completely correct. I'll make a new patch for this.

Regards,

	Hans

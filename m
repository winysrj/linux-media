Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:29513 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965034Ab3DRCxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 22:53:30 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MLF00H8JK0JTT90@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 18 Apr 2013 11:53:28 +0900 (KST)
Content-transfer-encoding: 8BIT
Message-id: <516F6024.3020806@samsung.com>
Date: Thu, 18 Apr 2013 11:53:24 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com, pawel@osciak.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH] media: vb2: add length check for mmap
References: <1365739077-8740-1-git-send-email-sw0312.kim@samsung.com>
 <5167A3A3.5090200@samsung.com>
In-reply-to: <5167A3A3.5090200@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oops, there is a issue.

vb2-core does not PAGE_ALIGN to length of buffer, but mmap() always do
PAGE_ALIGN to its length.

So non PAGE_ALIGN length of buffer from driver side can not mmaped with
this patch.

On 2013년 04월 12일 15:03, Marek Szyprowski wrote:
> 
> On 4/12/2013 5:57 AM, Seung-Woo Kim wrote:
>> The length of mmap() can be bigger than length of vb2 buffer, so
>> it should be checked.
>>
>> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> 
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c |    5 +++++
>>   1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>> b/drivers/media/v4l2-core/videobuf2-core.c
>> index db1235d..2c6ff2d 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1886,6 +1886,11 @@ int vb2_mmap(struct vb2_queue *q, struct
>> vm_area_struct *vma)
>>         vb = q->bufs[buffer];
>>   +    if (vb->v4l2_planes[plane].length < (vma->vm_end -
>> vma->vm_start)) {
>> +        dprintk(1, "Invalid length\n");
>> +        return -EINVAL;
>> +    }
>> +
>>       ret = call_memop(q, mmap, vb->planes[plane].mem_priv, vma);
>>       if (ret)
>>           return ret;
> 
> Best regards

-- 
Seung-Woo Kim
Samsung Software R&D Center
--


Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:35241 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbeKMVyL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 16:54:11 -0500
Subject: Re: [PATCH] media: videobuf2-core: Fix error handling when fileio is
 deallocated
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Myungho Jung <mhjungk@gmail.com>, pawel@osciak.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20181112005053epcas4p1c674759797b4a930cfcce3abc7edd9ad@epcas4p1.samsung.com>
 <20181112004951.GA3948@myunghoj-Precision-5530>
 <9402424d-6e0c-b628-c6c2-8f87b5276a36@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <636c6ed7-25ef-fd51-4555-3aeb28e96f89@xs4all.nl>
Date: Tue, 13 Nov 2018 12:56:18 +0100
MIME-Version: 1.0
In-Reply-To: <9402424d-6e0c-b628-c6c2-8f87b5276a36@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/13/18 11:27, Marek Szyprowski wrote:
> Hi Myungho,
> 
> On 2018-11-12 01:49, Myungho Jung wrote:
>> The mutex that is held from vb2_fop_read() can be unlocked while waiting
>> for a buffer if the queue is streaming and blocking. Meanwhile, fileio
>> can be released. So, it should return an error if the fileio address is
>> changed.
>>
>> Signed-off-by: Myungho Jung <mhjungk@gmail.com>
>> Reported-by: syzbot+4180ff9ca6810b06c1e9@syzkaller.appspotmail.com
> 
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Sorry:

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

This addresses the symptom, not the underlying cause.

I have a patch that fixes the actual cause that I plan to post soon
after I review it a bit more.

Regards,

	Hans

> 
> Thanks for analyzing the code and fixing this issue!
> 
>> ---
>>  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
>> index 975ff5669f72..bff94752eb27 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-core.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
>> @@ -2564,6 +2564,10 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>>  		dprintk(5, "vb2_dqbuf result: %d\n", ret);
>>  		if (ret)
>>  			return ret;
>> +		if (fileio != q->fileio) {
>> +			dprintk(3, "fileio deallocated\n");
>> +			return -EFAULT;
>> +		}
>>  		fileio->dq_count += 1;
>>  
>>  		fileio->cur_index = index;
> 
> Best regards
> 

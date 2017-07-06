Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46193 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752019AbdGFJnl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 05:43:41 -0400
Subject: Re: [PATCH 03/12] [media] vb2: add in-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-4-gustavo@padovan.org>
 <20170630085354.2a76bb4a@vento.lan> <20170703181627.GA3337@jade>
Cc: linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3e403e98-c9f0-1020-87c3-36aff44d5354@xs4all.nl>
Date: Thu, 6 Jul 2017 11:43:20 +0200
MIME-Version: 1.0
In-Reply-To: <20170703181627.GA3337@jade>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/17 20:16, Gustavo Padovan wrote:
>>> @@ -1436,6 +1481,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>>>  	if (pb)
>>>  		call_void_bufop(q, fill_user_buffer, vb, pb);
>>>  
>>> +	vb->in_fence = fence;
>>> +	if (fence && !dma_fence_add_callback(fence, &vb->fence_cb,
>>> +					     vb2_qbuf_fence_cb))
>>> +		return 0;
>>
>> Maybe we should provide some error or debug log here or a WARN_ON(), if 
>> dma_fence_add_callback() fails instead of silently ignore any errors.
> 
> This is not an error. If the if succeeds it mean we have installed a
> callback for the fence. If not, it means the fence signaled already and
> we don't can call __vb2_core_qbuf right away.

I had the same question as Mauro. After looking at the dma_fence_add_callback
code I see what you mean, but a comment would certainly be helpful.

Also, should you set vb->in_fence to NULL if the fence signaled already?
I'm not sure if you need to call 'dma_fence_put(vb->in_fence);' as well.
You would know that better than I do.

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:33898 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116AbbKAVsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Nov 2015 16:48:39 -0500
Message-ID: <563688B2.1080006@xs4all.nl>
Date: Sun, 01 Nov 2015 22:48:34 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ran Shalit <ranshalit@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: videobuf & read/write operation
References: <CAJ2oMhJOu8Ltra-bbb6FW3gLrCab1yKKu_zdSTNmqT5ecMkELQ@mail.gmail.com>	<56366A80.5090001@xs4all.nl> <CAJ2oMhJ9st3-Wcuv_Q69wf_cr6eoB4q_b5=1n2OgZmP9WTvdng@mail.gmail.com>
In-Reply-To: <CAJ2oMhJ9st3-Wcuv_Q69wf_cr6eoB4q_b5=1n2OgZmP9WTvdng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/01/2015 09:13 PM, Ran Shalit wrote:
>> Don't use videobuf! Use videobuf2, just like the skeleton driver.
>>
>> The old videobuf framework is deprecated and you shouldn't use it as it is
>> horrible.
>>
>> Why on earth are you trying to use videobuf if the skeleton driver clearly
>> uses vb2?
>>
> 
> Right,
> I now see that I was examining code which is quite old (2.6.37 from
> SDK I'm using).
> 
> In case we only need read/write operation, do we still need to
> implement all videobuf2 APIs ?

vb2 only got merged in 2.6.39. For what kernel are you doing this? 2.6.37 is ancient.

Anyway, for read/write you implement exactly the same vb2 callbacks as for stream I/O.
Read/write is implemented in the vb2 framework on top of stream I/O.

Typically drivers will have to implement queue_setup, buf_queue and start/stop_streaming
at minimum. The wait_prepare/finish callbacks are also needed, but you can typically use
the vb2_ops_wait_prepare/finish helper functions for that. Again, follow what the skeleton
driver does.

Regards,

	Hans

> 
> 
> Regards,
> Ran
> 
> 
>>
>>> When the documentation refers to " I/O stream" , does it also include
>>> the read/write operation or only streaming I/O method ?
>>>
>>> In case I am using only read/write, do I need to implement all these 4  APIs:
>>>
>>> struct videobuf_queue_ops {
>>>  int (*buf_setup)(struct videobuf_queue *q,
>>>  unsigned int *count, unsigned int *size);
>>>  int (*buf_prepare)(struct videobuf_queue *q,
>>>  struct videobuf_buffer *vb,
>>> enum v4l2_field field);
>>>  void (*buf_queue)(struct videobuf_queue *q,
>>>  struct videobuf_buffer *vb);
>>>  void (*buf_release)(struct videobuf_queue *q,
>>>  struct videobuf_buffer *vb);
>>> };
>>>
>>> Are these APIs relevant for both read/write and streaminf I/O ?
>>>
>>> Best Regards,
>>> Ran
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>


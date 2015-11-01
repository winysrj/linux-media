Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36105 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbKAUOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2015 15:14:00 -0500
Received: by ioll68 with SMTP id l68so126960359iol.3
        for <linux-media@vger.kernel.org>; Sun, 01 Nov 2015 12:13:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56366A80.5090001@xs4all.nl>
References: <CAJ2oMhJOu8Ltra-bbb6FW3gLrCab1yKKu_zdSTNmqT5ecMkELQ@mail.gmail.com>
	<56366A80.5090001@xs4all.nl>
Date: Sun, 1 Nov 2015 22:13:59 +0200
Message-ID: <CAJ2oMhJ9st3-Wcuv_Q69wf_cr6eoB4q_b5=1n2OgZmP9WTvdng@mail.gmail.com>
Subject: Re: videobuf & read/write operation
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Don't use videobuf! Use videobuf2, just like the skeleton driver.
>
> The old videobuf framework is deprecated and you shouldn't use it as it is
> horrible.
>
> Why on earth are you trying to use videobuf if the skeleton driver clearly
> uses vb2?
>

Right,
I now see that I was examining code which is quite old (2.6.37 from
SDK I'm using).

In case we only need read/write operation, do we still need to
implement all videobuf2 APIs ?


Regards,
Ran


>
>> When the documentation refers to " I/O stream" , does it also include
>> the read/write operation or only streaming I/O method ?
>>
>> In case I am using only read/write, do I need to implement all these 4  APIs:
>>
>> struct videobuf_queue_ops {
>>  int (*buf_setup)(struct videobuf_queue *q,
>>  unsigned int *count, unsigned int *size);
>>  int (*buf_prepare)(struct videobuf_queue *q,
>>  struct videobuf_buffer *vb,
>> enum v4l2_field field);
>>  void (*buf_queue)(struct videobuf_queue *q,
>>  struct videobuf_buffer *vb);
>>  void (*buf_release)(struct videobuf_queue *q,
>>  struct videobuf_buffer *vb);
>> };
>>
>> Are these APIs relevant for both read/write and streaminf I/O ?
>>
>> Best Regards,
>> Ran
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59288 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896AbaD2R13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Apr 2014 13:27:29 -0400
Received: by mail-wi0-f176.google.com with SMTP id f8so1588445wiw.9
        for <linux-media@vger.kernel.org>; Tue, 29 Apr 2014 10:27:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53576AC4.8090303@xs4all.nl>
References: <CAKZjMP3B5k8MByhVrn=vsWOwnZLDL+YS48VvAWQ+z4=RKduV-Q@mail.gmail.com>
	<53576AC4.8090303@xs4all.nl>
Date: Tue, 29 Apr 2014 10:27:27 -0700
Message-ID: <CAKZjMP14q0YTu11hJuQoRoOYihWw5Y63qGAoMUfGpL=2=ouG4g@mail.gmail.com>
Subject: Re: Question about implementation of __qbuf_dmabuf() in videobuf2-core.c
From: n179911 <n179911@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Is there a work around for this bug without upgrading to 3.16 kernel?

Is it safe to manually set the length to be data_offset + size + 1 to make sure

planes[plane].length is greater than planes[plane].data_offset +
                    q->plane_sizes[plane]?

Thank you.

On Wed, Apr 23, 2014 at 12:24 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 04/23/2014 02:18 AM, n179911 wrote:
>> In __qbuf_dmabuf(), it check the length and size of the buffer being
>> queued, like this:
>> http://lxr.free-electrons.com/source/drivers/media/v4l2-core/videobuf2-core.c#L1158
>>
>> My question is why the range check is liked this:
>>
>> 1158  if (planes[plane].length < planes[plane].data_offset +
>> 1159                     q->plane_sizes[plane]) {
>
> It's a bug. It should be:
>
>         if (planes[plane].length < q->plane_sizes[plane]) {
>
> This has been fixed in our upstream code and will appear in 3.16.
>
> Regards,
>
>         Hans
>
>>         .....
>>
>> Isn't  planes[plane].length + planes[plane].data_offset equals to
>> q->plane_sizes[plane]?
>>
>> So the check should be?
>>  if (planes[plane].length < q->plane_sizes[plane] - planes[plane].data_offset)
>>
>> Please tell me what am I missing?
>>
>> Thank you
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

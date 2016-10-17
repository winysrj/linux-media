Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:33308 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934068AbcJQQQp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 12:16:45 -0400
Received: by mail-vk0-f50.google.com with SMTP id 83so158845335vkd.0
        for <linux-media@vger.kernel.org>; Mon, 17 Oct 2016 09:16:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476711990.4684.75.camel@ndufresne.ca>
References: <CAOMLVLj9zwMCOCRawKZKDDtLkwHUN3VpLhpy2Qovn7Bv1X5SgA@mail.gmail.com>
 <1476469229.4684.70.camel@gmail.com> <CAOMLVLhM006pYiP7xEmZoVFzwV4Zzw25wS1e1EPDDLXps873Mw@mail.gmail.com>
 <1476711990.4684.75.camel@ndufresne.ca>
From: =?UTF-8?B?V3UtQ2hlbmcgTGkgKOadjuWLmeiqoCk=?= <wuchengli@google.com>
Date: Tue, 18 Oct 2016 00:16:14 +0800
Message-ID: <CAOMLVLj9wZvzQ_CxMKSey1FM2jE3LkvX+8F-cnBCrSDzWnxLqA@mail.gmail.com>
Subject: Re: V4L2_DEC_CMD_STOP and last_buffer_dequeued
To: nicolas@ndufresne.ca
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        pawel@osciak.com, Tiffany Lin <tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We found videobuf2-core.h has a function
vb2_clear_last_buffer_dequeued to clear last_buffer_dequeued. We call
vb2_clear_last_buffer_dequeued in the driver when it gets CMD_START.
Everything works now.

On Mon, Oct 17, 2016 at 9:46 PM, Nicolas Dufresne <nicolas@ndufresne.ca> wr=
ote:
> Le samedi 15 octobre 2016 =C3=A0 08:16 +0800, Wu-Cheng Li (=E6=9D=8E=E5=
=8B=99=E8=AA=A0) a =C3=A9crit :
>> last_buffer_dequeued is only cleared to false when CAPTURE queue is
>> STREAMOFF (#1). Queuing a header to OUTPUT queue won't clear
>> last_buffer_dequeued of CAPTURE queue. It looks to me that v4l2 core
>> needs to intercept CMD_START and clear last_buffer_dequeued. What do
>> you think?
We found
>>
>> http://lxr.free-electrons.com/source/drivers/media/v4l2-core/videobuf2-c=
ore.c#L1951
>
> That sounds reasonable, assuming it does not break drivers.
>
>> >
>> >
>> > Note that for many a flush is the action of getting rid of the pending
>> > images and achieve by using STREAMOFF. While the effect of CMD_STOP is
>> > to signal the decoder that no more encoded image will be queued, hence
>> > remaining images should be delivered to userspace. They will
>> > differentiate as a flush operation vs as drain operation. This is no
>> > rocket science of course.
>>
>> I see. What I want is drain operation. In Chromium terms, CMD_STOP
>> maps to flush and STREAMOFF maps to reset.
>
> Yes, that's the reason I was mentioning. This was a great source of
> confusion during a workshop with some Google/Chromium folks.
>
> A question on top of this, what are the use cases for you to drain
> without flushing afteward ? Is it really needed ?
>
> regards,
> Nicolas

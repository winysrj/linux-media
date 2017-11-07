Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:47921 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755020AbdKGXHn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Nov 2017 18:07:43 -0500
Subject: Re: HDMI field order
To: Carlos Rafael Giani <dv@pseudoterminal.org>,
        linux-media <linux-media@vger.kernel.org>
References: <CAJ+vNU3=GCFUgo0DYufyeisHYFuRwsY1qUeuQ29Y9J+mdjR57g@mail.gmail.com>
 <d865b201-c4d8-5907-832a-5b098891c994@pseudoterminal.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b056104d-06c2-55b4-4ce8-95dbca47fc97@xs4all.nl>
Date: Wed, 8 Nov 2017 00:07:37 +0100
MIME-Version: 1.0
In-Reply-To: <d865b201-c4d8-5907-832a-5b098891c994@pseudoterminal.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/2017 11:35 PM, Carlos Rafael Giani wrote:
> I was discussing this with Tim earlier, and there was a little 
> confusion. He meant V4L2_FIELD_SEQ_TB/BT, not V4L2_FIELD_INTERLACED.
> 
> When I tried out 1080i50 with HDMI in and the i.MX6, I got something 
> that looks like V4L2_FIELD_SEQ_TB. The question though is: are the field 
> rows always arranged like this with interlaced HDMI? Or does this depend 
> on the source? Could it for example be possible that 2 HDMI cameras 
> deliver both interlaced video, but the first one delivers 
> V4L2_FIELD_INTERLACED, and the second delivers V4L2_FIELD_SEQ_TB? Could 
> this happen?

HDMI doesn't deliver any of the V4L2_FIELD_* formats, those are a property
of the DMA engine and/or possible processing blocks earlier in the video
pipeline.

Interlaced formats as transmitted over HDMI are sent as a sequence of fields.
All defined interlaced formats except for one send the top field first, then
the bottom field. The exception (I'm 99% certain of that) is 720x480i (aka NTSC)
which sends the bottom field before the top field.

The video pipeline will typically DMA each field in a separate buffer (i.e.
FIELD_ALTERNATE) or concatenate two fields in one buffer (SEQ_TB or SEQ_BT for
720x480i), although the latter is less common. There is little point to it
since it would just increase the latency with little benefit.

If the video pipeline contains a deinterlacer, then FIELD_NONE is also an
option.

Regards,

	Hans

> 
> 
> On 2017-11-07 19:40, Tim Harvey wrote:
>> Greetings,
>>
>> I'm trying to understand the various field orders supported by v4l2
>> [1]. Do HDMI sources always use V4L2_FIELD_INTERLACED or can they
>> support alternate modes as well?
>>
>> Regards,
>>
>> Tim
>>
>> [1] - https://www.linuxtv.org/downloads/legacy/video4linux/API/V4L2_API/spec/ch03s06.html
> 

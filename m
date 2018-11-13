Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:49403 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728943AbeKMRpv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 12:45:51 -0500
Subject: Re: [RFC PATCHv2 0/5] vb2/cedrus: add tag support
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, tfiga@chromium.org
References: <20181112083305.22618-1-hverkuil@xs4all.nl>
 <3240ae26669480fa33c2e4d44e608cccdbfd5626.camel@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0758f871-a210-9e5c-462b-57390ac5a930@xs4all.nl>
Date: Tue, 13 Nov 2018 08:48:52 +0100
MIME-Version: 1.0
In-Reply-To: <3240ae26669480fa33c2e4d44e608cccdbfd5626.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2018 05:32 PM, Paul Kocialkowski wrote:
> Hi,
> 
> On Mon, 2018-11-12 at 09:33 +0100, Hans Verkuil wrote:
>> As was discussed here (among other places):
>>
>> https://lkml.org/lkml/2018/10/19/440
>>
>> using capture queue buffer indices to refer to reference frames is
>> not a good idea. A better idea is to use a 'tag' (thanks to Alexandre
>> for the excellent name; it's much better than 'cookie') where the 
>> application can assign a u64 tag to an output buffer, which is then 
>> copied to the capture buffer(s) derived from the output buffer.
>>
>> A u64 is chosen since this allows userspace to also use pointers to
>> internal structures as 'tag'.
> 
> As I mentionned in the dedicated patch, this approach is troublesome on
> 32-bit platforms. Do we really need this equivalency?

It's just a bug in the header that I need to fix. I just need to use
the right cast. I think it is a desirable feature.

>> The first two patches add core tag support, the next two patches
>> add tag support to vim2m and vicodec, and the final patch (compile
>> tested only!) adds support to the cedrus driver.
>>
>> I also removed the 'pad' fields from the mpeg2 control structs (it
>> should never been added in the first place) and aligned the structs
>> to a u32 boundary (u64 for the tag values).
>>
>> The cedrus code now also copies the timestamps (didn't happen before)
>> but the sequence counter is still not set, that's something that should
>> still be added.
>>
>> Note: if no buffer is found for a certain tag, then the dma address
>> is just set to 0. That happened before as well with invalid buffer
>> indices. This should be checked in the driver!
> 
> Thanks for making these changes!
> 
>> Also missing in this series are documentation updates, which is why
>> it is marked RFC.
>>
>> I would very much appreciate it if someone can test the cedrus driver
>> with these changes. If it works, then I can prepare a real patch series
>> for 4.20. It would be really good if the API is as stable as we can make
>> it before 4.20 is released.
> 
> I just had a go at testing the patches on cedrus with minimal userspace
> adaptation to deal with the tags and everything looks good!

Great!

> I only set the tag when queing each OUTPUT buffer and the driver
> properly matched the CAPTURE reference buffer.
> 
> I think we should make it clear in the stateless spec that multiple
> OUTPUT buffers can be allowed for the same tag, but that a single
> CAPTURE buffer should be used. Otherwise, the hardware can't use
> different partly-decoded buffers as references (and the tag API doesn't
> allow that either, since a single buffer index is returned for a tag).

Actually, the tag API allows for multiple buffers for the same tag: that's
what the last argument of vb2_find_tag() is for: you can continue looking
for buffers with the given tag from where you left off:

	second_idx = -1;

	first_idx = vb2_find_tag(q, tag, 0);
	if (first_idx >= 0)
		second_idx = vb2_find_tag(q, tag, first_idx + 1);

I think how OUTPUT buffers relate to CAPTURE buffers is really a property
of the codec that's used (I mean H.264 vs MPEG vs VP8 etc). The tag API
supports any combination.

For the stateless MPEG codec it is simple: one OUTPUT frame produces one
CAPTURE frame. So this can be documented for the control that has the
buffer references.

Thank you very much for testing this. I'll prepare a new patch series this
week which will hopefully be the final version.

Regards,

	Hans

> 
> What do you think?
> 
> Cheers,
> 
> Paul
> 
>> Regards,
>>
>>         Hans
>>
>> Changes since v1:
>>
>> - cookie -> tag
>> - renamed v4l2_tag to v4l2_buffer_tag
>> - dropped spurious 'to' in the commit log of patch 1
>>
>> Hans Verkuil (5):
>>   videodev2.h: add tag support
>>   vb2: add tag support
>>   vim2m: add tag support
>>   vicodec: add tag support
>>   cedrus: add tag support
>>
>>  .../media/common/videobuf2/videobuf2-v4l2.c   | 43 ++++++++++++++++---
>>  drivers/media/platform/vicodec/vicodec-core.c |  3 ++
>>  drivers/media/platform/vim2m.c                |  3 ++
>>  drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ----
>>  drivers/staging/media/sunxi/cedrus/cedrus.h   |  8 ++--
>>  .../staging/media/sunxi/cedrus/cedrus_dec.c   | 10 +++++
>>  .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++-----
>>  include/media/videobuf2-v4l2.h                | 18 ++++++++
>>  include/uapi/linux/v4l2-controls.h            | 14 +++---
>>  include/uapi/linux/videodev2.h                | 37 +++++++++++++++-
>>  10 files changed, 127 insertions(+), 39 deletions(-)
>>

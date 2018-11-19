Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:49270 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728258AbeKTAZj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 19:25:39 -0500
Subject: Re: [PATCHv2 0/9] vb2/cedrus: add tag support
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        maxime.ripard@bootlin.com, tfiga@chromium.org,
        Nicolas Dufresne <nicolas@ndufresne.ca>
References: <20181114134743.18993-1-hverkuil@xs4all.nl>
 <93b53779-2218-e69a-5f2b-bdf5d76d6d15@xs4all.nl>
 <4e517aa9f91b006ddcf2cd9631cee101a66470b8.camel@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e481bba5-2ed3-5cf9-a28a-6e8d7cfa3881@xs4all.nl>
Date: Mon, 19 Nov 2018 15:01:53 +0100
MIME-Version: 1.0
In-Reply-To: <4e517aa9f91b006ddcf2cd9631cee101a66470b8.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/19/2018 02:53 PM, Paul Kocialkowski wrote:
> Hi,
> 
> On Mon, 2018-11-19 at 12:18 +0100, Hans Verkuil wrote:
>> On 11/14/2018 02:47 PM, Hans Verkuil wrote:
>>> From: Hans Verkuil <hansverk@cisco.com>
>>>
>>> As was discussed here (among other places):
>>>
>>> https://lkml.org/lkml/2018/10/19/440
>>>
>>> using capture queue buffer indices to refer to reference frames is
>>> not a good idea. A better idea is to use a 'tag' where the
>>> application can assign a u64 tag to an output buffer, which is then 
>>> copied to the capture buffer(s) derived from the output buffer.
>>>
>>> A u64 is chosen since this allows userspace to also use pointers to
>>> internal structures as 'tag'.
>>>
>>> The first three patches add core tag support, the next patch document
>>> the tag support, then a new helper function is added to v4l2-mem2mem.c
>>> to easily copy data from a source to a destination buffer that drivers
>>> can use.
>>>
>>> Next a new supports_tags vb2_queue flag is added to indicate that
>>> the driver supports tags. Ideally this should not be necessary, but
>>> that would require that all m2m drivers are converted to using the
>>> new helper function introduced in the previous patch. That takes more
>>> time then I have now since we want to get this in for 4.20.
>>>
>>> Finally the vim2m, vicodec and cedrus drivers are converted to support
>>> tags.
>>>
>>> I also removed the 'pad' fields from the mpeg2 control structs (it
>>> should never been added in the first place) and aligned the structs
>>> to a u32 boundary (u64 for the tag values).
>>>
>>> Note that this might change further (Paul suggested using bitfields).
>>>
>>> Also note that the cedrus code doesn't set the sequence counter, that's
>>> something that should still be added before this driver can be moved
>>> out of staging.
>>>
>>> Note: if no buffer is found for a certain tag, then the dma address
>>> is just set to 0. That happened before as well with invalid buffer
>>> indices. This should be checked in the driver!
>>>
>>> The previous RFC series was tested successfully with the cedrus driver.
>>>
>>> Regards,
>>>
>>>         Hans
>>
>> I'd like to get some Acked-by or Reviewed-by replies for this series.
>> Or comments if you don't like something.
> 
> The series looks good to me, so consider it:
> Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> 
> Also, I'm glad you made the v4l2_m2m_buf_copy_data helper function,
> since all drivers will need to do these same operations anyway.
> 
>> I would really like to get this in for 4.20 so the cedrus API is stable
>> (hopefully), since this is a last outstanding API item.
> 
> I see a few more items that we need to tackle before we can consider the
> MPEG-2 stateless API as stable.
> 
> * I mentionned using flags in the mpeg2 structures to solve the
> alignment issues, but I failed to provide a patch implementing it at
> this point. This would make the MPEG-2 controls more similar to the
> proposed H.264 ones and generally makes more sense than using a u8 for a
> binary value.

I think it will be good to have this done. If you can make a patch that I can
rebase my tag series on, then that would be best.

> 
> * Some time ago, we also discussed adding extra fields to the structures
> for later use. Do you think that is still relevant? Adding a flags
> elements (with unused bits) would certainly help in this direction
> anyway.

If you switch to bitfields, then there might be enough room anyway for
addition flags in the future.

> 
> * During the discussions on the spec, the concensus was also to use one
> slice_params per-slice (instead of per-picture) which requires splitting
> the per-picture and the per-slice parameters. On this as well, I fell
> behind and didn't send a proposal yet.
> 
> So my question is: does it need to be done for 4.20 or can we affoard
> going through another version cycle for these changes?
> 
> It was my impression that we wanted to wait for another driver to use
> the API to declare it stable (and move the driver out of staging).

Good question, I would like to hear what Mauro says.

I would prefer to postpone this to 4.21, since I don't feel comfortable
with such large changes for an rcX (esp. splitting the per-picture/slice
parameters).

Regards,

	Hans

> 
> Cheers,
> 
> Paul
> 
>> Tomasz: you commented that the text still referred to the tag as a u64,
>> but that was only in the cover letter, not the patches themselves. So
>> I don't plan to post a v3 just for that.
>>
>> Regards,
>>
>> 	Hans
>>
>>> Changes since v1:
>>>
>>> - changed to a u32 tag. Using a 64 bit tag was overly complicated due
>>>   to the bad layout of the v4l2_buffer struct, and there is no real
>>>   need for it by applications.
>>>
>>> Main changes since the RFC:
>>>
>>> - Added new buffer capability flag
>>> - Added m2m helper to copy data between buffers
>>> - Added documentation
>>> - Added tag logging in v4l2-ioctl.c
>>>
>>> Hans Verkuil (9):
>>>   videodev2.h: add tag support
>>>   vb2: add tag support
>>>   v4l2-ioctl.c: log v4l2_buffer tag
>>>   buffer.rst: document the new buffer tag feature.
>>>   v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
>>>   vb2: add new supports_tags queue flag
>>>   vim2m: add tag support
>>>   vicodec: add tag support
>>>   cedrus: add tag support
>>>
>>>  Documentation/media/uapi/v4l/buffer.rst       | 32 +++++++++----
>>>  .../media/uapi/v4l/vidioc-reqbufs.rst         |  4 ++
>>>  .../media/common/videobuf2/videobuf2-v4l2.c   | 45 ++++++++++++++++---
>>>  drivers/media/platform/vicodec/vicodec-core.c | 14 ++----
>>>  drivers/media/platform/vim2m.c                | 14 ++----
>>>  drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ----
>>>  drivers/media/v4l2-core/v4l2-ioctl.c          |  9 ++--
>>>  drivers/media/v4l2-core/v4l2-mem2mem.c        | 23 ++++++++++
>>>  drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 ++--
>>>  .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 +
>>>  .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++-----
>>>  .../staging/media/sunxi/cedrus/cedrus_video.c |  2 +
>>>  include/media/v4l2-mem2mem.h                  | 21 +++++++++
>>>  include/media/videobuf2-core.h                |  2 +
>>>  include/media/videobuf2-v4l2.h                | 21 ++++++++-
>>>  include/uapi/linux/v4l2-controls.h            | 14 +++---
>>>  include/uapi/linux/videodev2.h                |  9 +++-
>>>  17 files changed, 178 insertions(+), 73 deletions(-)
>>>

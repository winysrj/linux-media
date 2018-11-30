Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:42744 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbeK3SoK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 13:44:10 -0500
Subject: Re: [PATCH] media: videodev2: add V4L2_FMT_FLAG_NO_SOURCE_CHANGE
To: Tomasz Figa <tfiga@chromium.org>
Cc: mjourdan@baylibre.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20181004133739.19086-1-mjourdan@baylibre.com>
 <491c3f33-b51b-89cb-09f0-b48949d61efb@xs4all.nl>
 <CAAFQd5DqY7zRR9SePWDCL0erB4x0pkBP7x2enuVvdjmyX+ASBw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b8904bae-ff56-bec5-89dd-aa4139b93324@xs4all.nl>
Date: Fri, 30 Nov 2018 08:35:41 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DqY7zRR9SePWDCL0erB4x0pkBP7x2enuVvdjmyX+ASBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29/2018 08:35 PM, Tomasz Figa wrote:
> On Thu, Nov 29, 2018 at 1:01 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 10/04/2018 03:37 PM, Maxime Jourdan wrote:
>>> When a v4l2 driver exposes V4L2_EVENT_SOURCE_CHANGE, some (usually
>>> OUTPUT) formats may not be able to trigger this event.
>>>
>>> Add a enum_fmt format flag to tag those specific formats.
>>
>> I think I missed (or forgot) some discussion about this since I have no
>> idea why this flag is needed. What's the use-case?
> 
> As far as I remember, the hardware/firmware Maxime has been working
> with can't handle resolution changes for some coded formats. Perhaps
> we should explain that better in the commit message and documentation
> of the flag, though. Maxime, could you refresh my memory with the
> details?

So basically it describes if a compressed format can handle resolution
changes for the given hardware?

If that's the case, then NO_SOURCE_CHANGE is not a good name as it
describes the symptom, not the real reason.

Perhaps _FIXED_RESOLUTION might be a better name.

Regards,

	Hans

> 
> Best regards,
> Tomasz
> 
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>> Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
>>> ---
>>>  Documentation/media/uapi/v4l/vidioc-enum-fmt.rst | 5 +++++
>>>  include/uapi/linux/videodev2.h                   | 5 +++--
>>>  2 files changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
>>> index 019c513df217..e0040b36ac43 100644
>>> --- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
>>> +++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
>>> @@ -116,6 +116,11 @@ one until ``EINVAL`` is returned.
>>>        - This format is not native to the device but emulated through
>>>       software (usually libv4l2), where possible try to use a native
>>>       format instead for better performance.
>>> +    * - ``V4L2_FMT_FLAG_NO_SOURCE_CHANGE``
>>> +      - 0x0004
>>> +      - The event ``V4L2_EVENT_SOURCE_CHANGE`` is not supported
>>> +     for this format.
>>> +
>>>
>>>
>>>  Return Value
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 3a65951ca51e..a28acee1cb52 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -723,8 +723,9 @@ struct v4l2_fmtdesc {
>>>       __u32               reserved[4];
>>>  };
>>>
>>> -#define V4L2_FMT_FLAG_COMPRESSED 0x0001
>>> -#define V4L2_FMT_FLAG_EMULATED   0x0002
>>> +#define V4L2_FMT_FLAG_COMPRESSED     0x0001
>>> +#define V4L2_FMT_FLAG_EMULATED               0x0002
>>> +#define V4L2_FMT_FLAG_NO_SOURCE_CHANGE       0x0004
>>>
>>>       /* Frame Size and frame rate enumeration */
>>>  /*
>>>
>>

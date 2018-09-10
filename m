Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36556 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727695AbeIJQDb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 12:03:31 -0400
Subject: Re: [Xen-devel][PATCH 1/1] cameraif: add ABI for para-virtual camera
To: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
References: <20180731093142.3828-1-andr2000@gmail.com>
 <20180731093142.3828-2-andr2000@gmail.com>
 <73b69e31-d36d-d89f-20d6-d59dbefe395e@xs4all.nl>
 <fc78ee17-412f-8a74-ecc8-b8ab55189e1b@gmail.com>
 <7134b3ad-9fcf-0139-41b3-67a3dbc8224d@xs4all.nl>
 <51f97715-454a-0242-b381-29944d77d5b5@gmail.com>
 <3c6bb5c8-eeb4-fd09-407a-5a77b29b56c3@xs4all.nl>
 <2a39c994-118f-a17e-c40a-f5fbbad1cb03@epam.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <30d7c91a-4515-157b-fc29-90c2e6f0008b@xs4all.nl>
Date: Mon, 10 Sep 2018 13:09:54 +0200
MIME-Version: 1.0
In-Reply-To: <2a39c994-118f-a17e-c40a-f5fbbad1cb03@epam.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2018 11:52 AM, Oleksandr Andrushchenko wrote:
> On 09/10/2018 12:04 PM, Hans Verkuil wrote:
>> On 09/10/2018 10:24 AM, Oleksandr Andrushchenko wrote:
>>> On 09/10/2018 10:53 AM, Hans Verkuil wrote:
>>>> Hi Oleksandr,
>>>>
>>>> On 09/10/2018 09:16 AM, Oleksandr Andrushchenko wrote:
>> <snip>
>>
>>>>>> I suspect that you likely will want to support such sources eventually, so
>>>>>> it pays to design this with that in mind.
>>>>> Again, I think that this is the backend to hide these
>>>>> use-cases from the frontend.
>>>> I'm not sure you can: say you are playing a bluray connected to the system
>>>> with HDMI, then if there is a resolution change, what do you do? You can tear
>>>> everything down and build it up again, or you can just tell frontends that
>>>> something changed and that they have to look at the new vcamera configuration.
>>>>
>>>> The latter seems to be more sensible to me. It is really not much that you
>>>> need to do: all you really need is an event signalling that something changed.
>>>> In V4L2 that's the V4L2_EVENT_SOURCE_CHANGE.
>>> well, this complicates things a lot as I'll have to
>>> re-allocate buffers - right?
>> Right. Different resolutions means different sized buffers and usually lots of
>> changes throughout the whole video pipeline, which in this case can even
>> go into multiple VMs.
>>
>> One additional thing to keep in mind for the future: V4L2_EVENT_SOURCE_CHANGE
>> has a flags field that tells userspace what changed. Right now that is just the
>> resolution, but in the future you can expect flags for cases where just the
>> colorspace information changes, but not the resolution.
>>
>> Which reminds me of two important missing pieces of information in your protocol:
>>
>> 1) You need to communicate the colorspace data:
>>
>> - colorspace
>> - xfer_func
>> - ycbcr_enc/hsv_enc (unlikely you ever want to support HSV pixelformats, so I
>>    think you can ignore hsv_enc)
>> - quantization
>>
>> See https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-v4l2.html#c.v4l2_pix_format
>> and the links to the colorspace sections in the V4L2 spec for details).
>>
>> This information is part of the format, it is reported by the driver.
> I'll take a look and think what can be put and how into the protocol,
> do you think I'll have to implement all the above for
> this stage?

Yes. Without it VMs will have no way of knowing how to reproduce the right colors.
They don't *have* to use this information, but it should be there. For cameras
this isn't all that important, for SDTV/HDTV sources this becomes more relevant
(esp. the quantization and ycbcr_enc information) and for sources with BT.2020/HDR
formats this is critical.

The vivid driver can actually reproduce all combinations, so that's a good driver
to test this with.

> 
>>
>> 2) If you support interlaced formats and V4L2_FIELD_ALTERNATE (i.e.
>>     each buffer contains a single field), then you need to be able to tell
>>     userspace whether the dequeued buffer contains a top or bottom field.
> I think at the first stage we can assume that interlaced
> formats are not supported and add such support later if need be.

Frankly I consider that a smart move :-) Interlaced formats are awful...

You just have to keep this in mind if you ever have to add support for this.

>>
>> Also, what to do with dropped frames/fields: V4L2 has a sequence counter and
>> timestamp that can help detecting that. You probably need something similar.
> Ok, this can be reported as part of XENCAMERA_EVT_FRAME_AVAIL event
>>
>>> But anyways, I can add
>>> #define XENCAMERA_EVT_CFG_CHANGE       0x01
>>> in the protocol, so we can address this use-case
>> <snip>
>>
>>>>> 1. set format command:
>>>>>     * pixel_format - uint32_t, pixel format to be used, FOURCC code.
>>>>>     * width - uint32_t, width in pixels.
>>>>>     * height - uint32_t, height in pixels.
>>>>>
>>>>> 2. Set frame rate command:
>>>>>     + * frame_rate_numer - uint32_t, numerator of the frame rate.
>>>>>     + * frame_rate_denom - uint32_t, denominator of the frame rate.
>>>>>
>>>>> 3. Set/request num bufs:
>>>>>     * num_bufs - uint8_t, desired number of buffers to be used.
>>>> I like this much better. 1+2 could be combined, but 3 should definitely remain
>>>> separate.
>>> ok, then 1+2 combined + 3 separate.
>>> Do you think we can still name 1+2 as "set_format" or "set_config"
>>> will fit better?
>> set_format is closer to S_FMT as used in V4L2, so I have a slight preference
>> for that, but it is really up to you.
> I'll probably stick to SET_CONFIG here
>>
>>>>>>> + *
>>>>>>> + * See response format for this request.
>>>>>>> + *
>>>>>>> + * Notes:
>>>>>>> + *  - frontend must check the corresponding response in order to see
>>>>>>> + *    if the values reported back by the backend do match the desired ones
>>>>>>> + *    and can be accepted.
>>>>>>> + *  - frontend may send multiple XENCAMERA_OP_SET_CONFIG requests before
>>>>>>> + *    sending XENCAMERA_OP_STREAM_START request to update or tune the
>>>>>>> + *    configuration.
>>>>>>> + */
>>>>>>> +struct xencamera_config {
>>>>>>> +    uint32_t pixel_format;
>>>>>>> +    uint32_t width;
>>>>>>> +    uint32_t height;
>>>>>>> +    uint32_t frame_rate_nom;
>>>>>>> +    uint32_t frame_rate_denom;
>>>>>>> +    uint8_t num_bufs;
>>>>>>> +};
>>>>>>> +
>>>>>>> +/*
>>>>>>> + * Request buffer details - request camera buffer's memory layout.
>>>>>>> + * detailed description:
>>>>>>> + *         0                1                 2               3        octet
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |               id                |_GET_BUF_DETAILS|   reserved     | 4
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |                              reserved                             | 8
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |                              reserved                             | 64
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + *
>>>>>>> + * See response format for this request.
>>>>>>> + *
>>>>>>> + *
>>>>>>> + * Request camera buffer creation:
>>>>>>> + *         0                1                 2               3        octet
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |               id                | _OP_BUF_CREATE |   reserved     | 4
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |                             reserved                              | 8
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |      index     |                     reserved                     | 12
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |                           gref_directory                          | 16
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |                             reserved                              | 20
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |                             reserved                              | 64
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + *
>>>>>>> + * An attempt to create multiple buffers with the same index is an error.
>>>>>>> + * index can be re-used after destroying the corresponding camera buffer.
>>>>>>> + *
>>>>>>> + * index - uint8_t, index of the buffer to be created.
>>>>>>> + * gref_directory - grant_ref_t, a reference to the first shared page
>>>>>>> + *   describing shared buffer references. The size of the buffer is equal to
>>>>>>> + *   XENCAMERA_OP_GET_BUF_DETAILS.size response. At least one page exists. If
>>>>>>> + *   shared buffer size exceeds what can be addressed by this single page,
>>>>>>> + *   then reference to the next shared page must be supplied (see
>>>>>>> + *   gref_dir_next_page below).
>>>>>> It might be better to allocate all buffers in one go, i.e. what VIDIOC_REQBUFS
>>>>>> does.
>>>>> Well, I still think it is better to have a per buffer interface
>>>>> in the protocol as it is done for other Xen virtual devices.
>>>>> So, I'll keep this as is for now: VIDIOC_REQBUFS can still do
>>>>> what it does internally in the frontend driver
>>>> I may have misunderstood the original API. The newly proposed XENCAMERA_OP_BUF_REQUEST
>>>> maps to REQBUFS, right? And then BUF_CREATE/DESTROY just set up the shared buffer
>>>> mappings for the buffers created by REQBUFS. If that's the sequence, then it makes
>>>> sense. I'm not sure about the naming.
>>>>
>>>> You might want to make it clear that XENCAMERA_OP_BUF_REQUEST allocates the buffers
>>>> on the backend, and so can fail. Also, the actual number of allocated buffers in
>>>> case of success can be more or less than what was requested.
>>> The buffers can be allocated and shared by either backend or frontend: see
>>> "be-alloc" configuration option telling which domain (VM) shares
>>> the Xen grant references to the pages of the buffer: either frontend
>>> or backend.
>> If you want to do zero-copy video capture,
> this is the goal
>>   then you need to know which
>> device in your video pipeline (which now covers both actual hardware and
>> multiple VMs) has the strictest memory layout requirements. Often the
>> video HW requires contiguous physical memory for the buffers, which means
>> you can't just give it a piece of non-contig memory allocated elsewhere.
> We have already implemented zero copying use-cases for
> virtual display, please see [1] and [2] which are dma-buf
> based which can cope with real HW restrictions you mention.
> And in that case we can implement zero-copying both ways,
> e.g. when the Xen grant references are shared by either
> backend or frontend. This is different from camera use-cases:
> a single buffer needs to be shared with multiple frontends,
> so zero-copying is only possible when backend allocates the references
> and shares those with frontends. The way when frontend allocates
> the buffers and still we can implement zero-copying is when
> there is a single frontend in the system, otherwise we
> need to copy the images from backend's buffers into frontend's
> ones.

OK. The important thing is that you thought about this :-)

>> In practice you have two possible memory models you can use with V4L2 drivers:
>> MMAP (i.e. allocated by the driver and the buffers can, if needed, be exported
>> as dmabuf handles with VIDIOC_EXPBUF), or DMABUF where buffers are allocated
>> elsewhere and imported to V4L2, which may fail if it doesn't match the HW
>> requirements.
> For the frontend it is possible to work with both MMAP/DMABUF
> and the rest is on the backend's side - this was proven by
> virtual display implementation, so I see no problem here
> for virtual camera.
>>
>>> So, I was more thinking that in case of V4L2 based frontend driver:
>>> 1. Frontend serves REQBUFS ioctl and asks the backend with
>>> XENCAMERA_OP_BUF_REQUEST
>>> if it can handle that many buffers and gets number of buffers to be used
>>> and buffer structure (number of planes, sizes, offsets etc.) as the reply
>>> to that request
>>> 2. Frontend creates n buffers with XENCAMERA_OP_BUF_CREATE
>>> 3. Frontend returns from REQBUFS ioctl with actual number of buffers
>>> allocated

Regards,

	Hans

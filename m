Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54829 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726398AbeIKMuq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 08:50:46 -0400
Subject: Re: [Xen-devel][PATCH 1/1] cameraif: add ABI for para-virtual camera
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
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
 <30d7c91a-4515-157b-fc29-90c2e6f0008b@xs4all.nl>
 <ae111e1d-4ac2-9e68-a4a5-6513650ae37f@gmail.com>
 <c980f6b7-ffe1-c5f5-5506-b9fb1a37498b@xs4all.nl>
 <f53218ac-f704-b260-543f-72ccb33c7a1f@gmail.com>
 <cb233d78-9634-749e-f6a4-6e8692ea6ddd@xs4all.nl>
 <abd78f44-96ea-b706-378a-14f32fdd77d7@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c7ad3c0f-61f9-3124-f270-f87826a68700@xs4all.nl>
Date: Tue, 11 Sep 2018 09:52:36 +0200
MIME-Version: 1.0
In-Reply-To: <abd78f44-96ea-b706-378a-14f32fdd77d7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/18 09:14, Oleksandr Andrushchenko wrote:
> On 09/11/2018 10:04 AM, Hans Verkuil wrote:
>> On 09/11/2018 08:52 AM, Oleksandr Andrushchenko wrote:
>>> Hi, Hans!
>>>
>>> On 09/10/2018 03:26 PM, Hans Verkuil wrote:
>>>> On 09/10/2018 01:49 PM, Oleksandr Andrushchenko wrote:
>>>>> On 09/10/2018 02:09 PM, Hans Verkuil wrote:
>>>>>> On 09/10/2018 11:52 AM, Oleksandr Andrushchenko wrote:
>>>>>>> On 09/10/2018 12:04 PM, Hans Verkuil wrote:
>>>>>>>> On 09/10/2018 10:24 AM, Oleksandr Andrushchenko wrote:
>>>>>>>>> On 09/10/2018 10:53 AM, Hans Verkuil wrote:
>>>>>>>>>> Hi Oleksandr,
>>>>>>>>>>
>>>>>>>>>> On 09/10/2018 09:16 AM, Oleksandr Andrushchenko wrote:
>>>>>>>> <snip>
>>>>>>>>
>>>>>>>>>>>> I suspect that you likely will want to support such sources eventually, so
>>>>>>>>>>>> it pays to design this with that in mind.
>>>>>>>>>>> Again, I think that this is the backend to hide these
>>>>>>>>>>> use-cases from the frontend.
>>>>>>>>>> I'm not sure you can: say you are playing a bluray connected to the system
>>>>>>>>>> with HDMI, then if there is a resolution change, what do you do? You can tear
>>>>>>>>>> everything down and build it up again, or you can just tell frontends that
>>>>>>>>>> something changed and that they have to look at the new vcamera configuration.
>>>>>>>>>>
>>>>>>>>>> The latter seems to be more sensible to me. It is really not much that you
>>>>>>>>>> need to do: all you really need is an event signalling that something changed.
>>>>>>>>>> In V4L2 that's the V4L2_EVENT_SOURCE_CHANGE.
>>>>>>>>> well, this complicates things a lot as I'll have to
>>>>>>>>> re-allocate buffers - right?
>>>>>>>> Right. Different resolutions means different sized buffers and usually lots of
>>>>>>>> changes throughout the whole video pipeline, which in this case can even
>>>>>>>> go into multiple VMs.
>>>>>>>>
>>>>>>>> One additional thing to keep in mind for the future: V4L2_EVENT_SOURCE_CHANGE
>>>>>>>> has a flags field that tells userspace what changed. Right now that is just the
>>>>>>>> resolution, but in the future you can expect flags for cases where just the
>>>>>>>> colorspace information changes, but not the resolution.
>>>>>>>>
>>>>>>>> Which reminds me of two important missing pieces of information in your protocol:
>>>>>>>>
>>>>>>>> 1) You need to communicate the colorspace data:
>>>>>>>>
>>>>>>>> - colorspace
>>>>>>>> - xfer_func
>>>>>>>> - ycbcr_enc/hsv_enc (unlikely you ever want to support HSV pixelformats, so I
>>>>>>>>       think you can ignore hsv_enc)
>>>>>>>> - quantization
>>>>>>>>
>>>>>>>> See https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-v4l2.html#c.v4l2_pix_format
>>>>>>>> and the links to the colorspace sections in the V4L2 spec for details).
>>>>>>>>
>>>>>>>> This information is part of the format, it is reported by the driver.
>>>>>>> I'll take a look and think what can be put and how into the protocol,
>>>>>>> do you think I'll have to implement all the above for
>>>>>>> this stage?
>>>>>> Yes. Without it VMs will have no way of knowing how to reproduce the right colors.
>>>>>> They don't *have* to use this information, but it should be there. For cameras
>>>>>> this isn't all that important, for SDTV/HDTV sources this becomes more relevant
>>>>>> (esp. the quantization and ycbcr_enc information) and for sources with BT.2020/HDR
>>>>>> formats this is critical.
>>>>> ok, then I'll add the following to the set_config request/response:
>>>>>
>>>>>        uint32_t colorspace;
>>>>>        uint32_t xfer_func;
>>>>>        uint32_t ycbcr_enc;
>>>>>        uint32_t quantization;
>>> Yet another question here: are the above (color space, xfer etc.) and
>>> display aspect ratio defined per pixel_format or per pixel_format +
>>> resolution?
>>>
>>> If per pixel_format then
>>>
>>> .../vcamera/1/formats/YUYV/display-aspect-ratio = "59/58"
>>>
>>> or if per resolution
>>>
>>> .../vcamera/1/formats/YUYV/640x480/display-aspect-ratio = "59/58"
>> They are totally independent of resolution or pixelformat, with the
>> exception of ycbcr_enc which is of course ignored for RGB pixelformats.
>>
>> They are set by the driver, never by the application.
>>
>> For HDMI sources these values can change depending on what source is
>> connected, so they are not fixed and you need to query them whenever
>> a new source is connected. In fact, then can change midstream, but we
>> do not have good support for that at the moment.
> Ah, great, then I'll define colorspace, xfer_func, quantization
> and display aspect ratio as part of virtual camera device configuration
> (as vcamera represents a single source) and ycbcr_enc as a part
> of pixel format configuration (one ycbcr_enc per each
> pixel format)
> 
> Does this sound ok?

Uh, no :-)

ycbcr_enc is not tied to specific pixel formats. The Y'CbCr encoding tells
you how the Y'CbCr values were derived from the R'G'B' values. So this only
makes sense if you are in fact receiving Y'CbCr pixels, otherwise you just
ignore it.

It's up to you what value to assign to ycbcr_enc in that case: V4L2 doesn't
have any hard requirements for that AFAIK, although it will most likely be
set to 0 (V4L2_YCBCR_ENC_DEFAULT).

Regards,

	Hans

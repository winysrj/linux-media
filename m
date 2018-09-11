Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41792 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbeIKLuW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 07:50:22 -0400
Received: by mail-lf1-f65.google.com with SMTP id l26-v6so19458593lfc.8
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 23:52:30 -0700 (PDT)
Subject: Re: [Xen-devel][PATCH 1/1] cameraif: add ABI for para-virtual camera
To: Hans Verkuil <hverkuil@xs4all.nl>,
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
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <f53218ac-f704-b260-543f-72ccb33c7a1f@gmail.com>
Date: Tue, 11 Sep 2018 09:52:27 +0300
MIME-Version: 1.0
In-Reply-To: <c980f6b7-ffe1-c5f5-5506-b9fb1a37498b@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Hans!

On 09/10/2018 03:26 PM, Hans Verkuil wrote:
> On 09/10/2018 01:49 PM, Oleksandr Andrushchenko wrote:
>> On 09/10/2018 02:09 PM, Hans Verkuil wrote:
>>> On 09/10/2018 11:52 AM, Oleksandr Andrushchenko wrote:
>>>> On 09/10/2018 12:04 PM, Hans Verkuil wrote:
>>>>> On 09/10/2018 10:24 AM, Oleksandr Andrushchenko wrote:
>>>>>> On 09/10/2018 10:53 AM, Hans Verkuil wrote:
>>>>>>> Hi Oleksandr,
>>>>>>>
>>>>>>> On 09/10/2018 09:16 AM, Oleksandr Andrushchenko wrote:
>>>>> <snip>
>>>>>
>>>>>>>>> I suspect that you likely will want to support such sources eventually, so
>>>>>>>>> it pays to design this with that in mind.
>>>>>>>> Again, I think that this is the backend to hide these
>>>>>>>> use-cases from the frontend.
>>>>>>> I'm not sure you can: say you are playing a bluray connected to the system
>>>>>>> with HDMI, then if there is a resolution change, what do you do? You can tear
>>>>>>> everything down and build it up again, or you can just tell frontends that
>>>>>>> something changed and that they have to look at the new vcamera configuration.
>>>>>>>
>>>>>>> The latter seems to be more sensible to me. It is really not much that you
>>>>>>> need to do: all you really need is an event signalling that something changed.
>>>>>>> In V4L2 that's the V4L2_EVENT_SOURCE_CHANGE.
>>>>>> well, this complicates things a lot as I'll have to
>>>>>> re-allocate buffers - right?
>>>>> Right. Different resolutions means different sized buffers and usually lots of
>>>>> changes throughout the whole video pipeline, which in this case can even
>>>>> go into multiple VMs.
>>>>>
>>>>> One additional thing to keep in mind for the future: V4L2_EVENT_SOURCE_CHANGE
>>>>> has a flags field that tells userspace what changed. Right now that is just the
>>>>> resolution, but in the future you can expect flags for cases where just the
>>>>> colorspace information changes, but not the resolution.
>>>>>
>>>>> Which reminds me of two important missing pieces of information in your protocol:
>>>>>
>>>>> 1) You need to communicate the colorspace data:
>>>>>
>>>>> - colorspace
>>>>> - xfer_func
>>>>> - ycbcr_enc/hsv_enc (unlikely you ever want to support HSV pixelformats, so I
>>>>>      think you can ignore hsv_enc)
>>>>> - quantization
>>>>>
>>>>> See https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-v4l2.html#c.v4l2_pix_format
>>>>> and the links to the colorspace sections in the V4L2 spec for details).
>>>>>
>>>>> This information is part of the format, it is reported by the driver.
>>>> I'll take a look and think what can be put and how into the protocol,
>>>> do you think I'll have to implement all the above for
>>>> this stage?
>>> Yes. Without it VMs will have no way of knowing how to reproduce the right colors.
>>> They don't *have* to use this information, but it should be there. For cameras
>>> this isn't all that important, for SDTV/HDTV sources this becomes more relevant
>>> (esp. the quantization and ycbcr_enc information) and for sources with BT.2020/HDR
>>> formats this is critical.
>> ok, then I'll add the following to the set_config request/response:
>>
>>       uint32_t colorspace;
>>       uint32_t xfer_func;
>>       uint32_t ycbcr_enc;
>>       uint32_t quantization;
Yet another question here: are the above (color space, xfer etc.) and
display aspect ratio defined per pixel_format or per pixel_format + 
resolution?

If per pixel_format then

.../vcamera/1/formats/YUYV/display-aspect-ratio = "59/58"

or if per resolution

.../vcamera/1/formats/YUYV/640x480/display-aspect-ratio = "59/58"

>>
>> With this respect, I will need to put some OS agnostic constants
>> into the protocol, so if backend and frontend are not Linux/V4L2
>> based they can still talk to each other.
>> I see that V4L2 already defines constants for the above: [1], [2], [3], [4].
>>
>> Do you think I can define the same replacing V4L2_ prefix
>> with XENCAMERA_, e.g. V4L2_XFER_FUNC_SRGB -> XENCAMERA_XFER_FUNC_SRGB?
> Yes.
>
>> Do I need to define all those or there can be some subset of the
>> above for my simpler use-case?
> Most of these defines directly map to standards. I would skip the following
> defines:
>
> V4L2_COLORSPACE_DEFAULT (not applicable)
> V4L2_COLORSPACE_470_SYSTEM_*  (rarely used, if received by the HW the Xen backend
> 			should map this to V4L2_COLORSPACE_SMPTE170M)
> V4L2_COLORSPACE_JPEG (historical V4L2 artifact, see here how to map:
> 	 https://hverkuil.home.xs4all.nl/spec/uapi/v4l/colorspaces-details.html#col-jpeg)
>
> V4L2_COLORSPACE_SMPTE240M (rarely used, map to V4L2_COLORSPACE_SMPTE170M if seen in backend)
>
> V4L2_XFER_FUNC_SMPTE240M (rarely used, map to V4L2_XFER_FUNC_709)
>
> V4L2_YCBCR_ENC_SMPTE240M (rarely used, map to V4L2_YCBCR_ENC_709)
>
> While V4L2 allows 0 (DEFAULT) values for xfer_func, ycbcr_enc and quantization, and
> provides macros to map default values to the actual values (for legacy reasons),
> the Xen backend should always fill this in explicitly, using those same mapping
> macros (see e.g. V4L2_MAP_XFER_FUNC_DEFAULT).
>
> The V4L2 spec has extensive information on colorspaces (sections 2.14-2.17).
>
>>> The vivid driver can actually reproduce all combinations, so that's a good driver
>>> to test this with.
>> You mean I can use it on backend side instead of real HW camera and
>> test all the configurations possible/those of interest?
> Right.
>
> Regards,
>
> 	Hans
Thank you,
Oleksandr

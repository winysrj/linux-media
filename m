Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46044
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754984AbdBVUIm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 15:08:42 -0500
Subject: Re: [PATCH v5 1/3] [media] exynos-gsc: Use user configured colorspace
 if provided
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
References: <20170221192059.29745-1-thibault.saunier@osg.samsung.com>
 <20170221192059.29745-2-thibault.saunier@osg.samsung.com>
 <329a892b-eb57-26a5-d048-cfe4efc331b6@xs4all.nl>
 <58ee4eb5-981d-175f-52a9-445bbc265af0@osg.samsung.com>
 <02a38e14-052b-faf2-a7a1-ef2f968f6d35@xs4all.nl>
 <4fc7b224-b167-51f0-e60b-c4dff35a8986@osg.samsung.com>
 <1487793793.5907.25.camel@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Thibault Saunier <thibault.saunier@osg.samsung.com>
Message-ID: <a424de74-2fe9-08d5-c95e-3cf9a9ea7b62@osg.samsung.com>
Date: Wed, 22 Feb 2017 17:08:32 -0300
MIME-Version: 1.0
In-Reply-To: <1487793793.5907.25.camel@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/22/2017 05:03 PM, Nicolas Dufresne wrote:
> Le mercredi 22 février 2017 à 15:57 -0300, Thibault Saunier a écrit :
>> On 02/22/2017 03:06 PM, Hans Verkuil wrote:
>>> On 02/22/2017 05:05 AM, Thibault Saunier wrote:
>>>> Hello,
>>>>
>>>>
>>>> On 02/21/2017 11:19 PM, Hans Verkuil wrote:
>>>>> On 02/21/2017 11:20 AM, Thibault Saunier wrote:
>>>>>> Use colorspace provided by the user as we are only doing
>>>>>> scaling and
>>>>>> color encoding conversion, we won't be able to transform the
>>>>>> colorspace
>>>>>> itself and the colorspace won't mater in that operation.
>>>>>>
>>>>>> Also always use output colorspace on the capture side.
>>>>>>
>>>>>> Start using 576p as a threashold to compute the colorspace.
>>>>>> The media documentation says that the
>>>>>> V4L2_COLORSPACE_SMPTE170M colorspace
>>>>>> should be used for SDTV and V4L2_COLORSPACE_REC709 for HDTV.
>>>>>> But drivers
>>>>>> don't agree on the display resolution that should be used as
>>>>>> a threshold.
>>>>>>
>>>>>>    From EIA CEA 861B about colorimetry for various
>>>>>> resolutions:
>>>>>>
>>>>>>      - 5.1 480p, 480i, 576p, 576i, 240p, and 288p
>>>>>>        The color space used by the 480-line, 576-line, 240-
>>>>>> line, and 288-line
>>>>>>        formats will likely be based on SMPTE 170M [1].
>>>>>>      - 5.2 1080i, 1080p, and 720p
>>>>>>        The color space used by the high definition formats
>>>>>> will likely be
>>>>>>        based on ITU-R BT.709-4
>>>>>>
>>>>>> This indicates that in the case that userspace does not
>>>>>> specify what
>>>>>> colorspace should be used, we should use 576p  as a threshold
>>>>>> to set
>>>>>> V4L2_COLORSPACE_REC709 instead of V4L2_COLORSPACE_SMPTE170M.
>>>>>> Even if it is
>>>>>> only 'likely' and not a requirement it is the best guess we
>>>>>> can make.
>>>>>>
>>>>>> The stream should have been encoded with the information and
>>>>>> userspace
>>>>>> has to pass it to the driver if it is not the case, otherwise
>>>>>> we won't be
>>>>>> able to handle it properly anyhow.
>>>>>>
>>>>>> Also, check for the resolution in G_FMT instead
>>>>>> unconditionally setting
>>>>>> the V4L2_COLORSPACE_REC709 colorspace.
>>>>>>
>>>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.c
>>>>>> om>
>>>>>> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung
>>>>>> .com>
>>>>>> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
>>>>>>
>>>>>> ---
>>>>>>
>>>>>> Changes in v5:
>>>>>> - Squash commit to always use output colorspace on the
>>>>>> capture side
>>>>>>      inside this one
>>>>>> - Fix typo in commit message
>>>>>>
>>>>>> Changes in v4:
>>>>>> - Reword commit message to better back our assumptions on
>>>>>> specifications
>>>>>>
>>>>>> Changes in v3:
>>>>>> - Do not check values in the g_fmt functions as Andrzej
>>>>>> explained in previous review
>>>>>> - Added 'Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>'
>>>>>>
>>>>>> Changes in v2: None
>>>>>>
>>>>>>     drivers/media/platform/exynos-gsc/gsc-core.c | 20
>>>>>> +++++++++++++++-----
>>>>>>     drivers/media/platform/exynos-gsc/gsc-core.h |  1 +
>>>>>>     2 files changed, 16 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c
>>>>>> b/drivers/media/platform/exynos-gsc/gsc-core.c
>>>>>> index 59a634201830..772599de8c13 100644
>>>>>> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
>>>>>> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
>>>>>> @@ -454,6 +454,7 @@ int gsc_try_fmt_mplane(struct gsc_ctx
>>>>>> *ctx, struct v4l2_format *f)
>>>>>>         } else {
>>>>>>             min_w = variant->pix_min->target_rot_dis_w;
>>>>>>             min_h = variant->pix_min->target_rot_dis_h;
>>>>>> +        pix_mp->colorspace = ctx->out_colorspace;
>>>>>>         }
>>>>>>           pr_debug("mod_x: %d, mod_y: %d, max_w: %d, max_h =
>>>>>> %d",
>>>>>> @@ -472,10 +473,15 @@ int gsc_try_fmt_mplane(struct gsc_ctx
>>>>>> *ctx, struct v4l2_format *f)
>>>>>>           pix_mp->num_planes = fmt->num_planes;
>>>>>>     -    if (pix_mp->width >= 1280) /* HD */
>>>>>> -        pix_mp->colorspace = V4L2_COLORSPACE_REC709;
>>>>>> -    else /* SD */
>>>>>> -        pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
>>>>>> +    if (pix_mp->colorspace == V4L2_COLORSPACE_DEFAULT) {
>>>>>> +        if (pix_mp->width > 720 && pix_mp->height > 576) /*
>>>>>> HD */
>>>>> I'd use || instead of && here. Ditto for the next patch.
>>>>>
>>>>>> +            pix_mp->colorspace = V4L2_COLORSPACE_REC709;
>>>>>> +        else /* SD */
>>>>>> +            pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
>>>>>> +    }
>>>>> Are you sure this is in fact how it is used? If the source of
>>>>> the video
>>>>> is the sensor (camera), then the colorspace is typically SRGB.
>>>>> I'm not
>>>>> really sure you should guess here. All a mem2mem driver should
>>>>> do is to
>>>>> pass the colorspace etc. information from the output to the
>>>>> capture side,
>>>>> and not invent things. That simply makes no sense.
>>>> This is not a camera device but a colorspace conversion device,
>>>> in many
>>> Not really, this is a color encoding conversion device. I.e. it
>>> only affects
>>> the Y'CbCr encoding and quantization range. The colorspace (aka
>>> chromaticities)
>>> and transfer function remain unchanged.
>> Well, right, sorry I am talking in GStreamer terminlogy where what
>> you call
>> colorspace is called colorimetry, and colorspace is what I am
>> talking
>> about here.
>>
>>> In fact, I suspect (correct me if I am wrong) that it only converts
>>> between
>>> RGB, Y'CbCr 601 and Y'CbCr 709 encodings, where RGB is full range
>>> and the Y'CbCr
>>> formats are limited range.
>> That sounds correct.
>>
>>> If you pass in limited range RGB it will probably do the wrong
>>> thing as I don't
>>> seen any quantization checks in the code.
>>>
>>> So the colorspace and xfer_func fields remain unchanged by this
>>> driver.
>>>
>>> If you want to do this really correctly, then you need to do more.
>>> I don't have
>>> time right now to go into this in-depth, but I will try to get back
>>> to this on
>>> Monday. I am thinking of documenting this as part of the V4L2
>>> colorspace
>>> documentation. This stuff is complex and if you don't know the
>>> rules then it
>>> can be hard to implement correctly.
>> Here I am just making sure that we set the colorspace (v4l2
>> terminology)
>> if the case the user is passing DEFAULT (meaning he does not know
>> what
>> it should be and lets the driver set it, this will happen in the
>> case
>> where the
>> information was not contain in the source, which means the value has
>> to be
>> guessed, and here I am simply doing an educated guess relying on what
>> the
>> previously named standard suggests.
>>
>> I would be happy to read more information about that subject and will
>> try to fix remaining suggested points once I have a better
>> understanding
>> of the whole concepts and problems in that driver, but I still think
>> that this
>> patch is correct for what it is aiming at fixing.
>>
>> Regards,
>>
>> Thibault Saunier
>>
>>>> cases the info will not be passed by the userspace, basically
>>>> because the info
>>>> is not encoded in the media stream (this often happens). I am not
>>>> inventing here,
>>>> just making sure we use the most likely value in case none was
>>>> provided (and if none
>>>> was provided it should always be correct given that the encoded
>>>> stream was not broken).
>>>>
>>>> In the case the source is a camera and then we use the colorspace
>>>> converter then the info
>>>> should copied from the camera to the transcoding node (by
>>>> userspace) so there should be
>>>> no problem.
>>>>
>>>> What I am doing here is what is done in other drivers.
>>> Most (all?) other mem2mem drivers do not do color encoding
>>> conversion, they just copy
>>> all the colorspace info from output to capture.
>>>
>>> If there are other m2m drivers that do this, then I doubt they do
>>> the right thing.
>>> They are probably right for most cases, but not all.
>>>
>>> Regards,
>>>
>>> 	Hans
> I think Hans is right about the colorspace here. Unlike the field for
> interlace modes, there it is no mandatory requirement in the spec for
> the driver to change DEFAULT into something else. If you don't know the
> input colorspace, then you don't known the output. Even in GStreamer,
> this would be best, since the only guessing will happen at the display,
> or in some conversion to RGB. Though, if you don't support a specific
> value, then the driver should change it.

Well the documentation, even if not really precise states:

    V4L2_COLORSPACE_DEFAULT: The default colorspace. This can be used by 
applications to let the driver fill in the colorspace.

Which is why I supposed the driver should fill it in, also this is what 
other drivers do too.

Regards,

Thibault
> Where I don't agree though, is that an m2m color converter will always
> copy blindly that colorspace. Even though the support is limited,
> sometime it may change, this need to be sorted case by case. I have
> rarely seen such a driver keep the limited range when turning buffers
> into RGB data.
>
> But changing the colorspace is complicated, since it's slightly vague
> concept. It will in fact imply a specific set of v4l2_xfer_func,
> v4l2_ycbcr_encoding and v4l2_quantization (ignoring hsv, as it does not
> apply). If you have a limited driver, that only target one of these 3
> items, you will likely keep the colorspace as-is, and override the
> specific functions.

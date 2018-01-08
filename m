Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52509 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933647AbeAHQ6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 11:58:39 -0500
Subject: Re: [PATCH] v4l: doc: clarify v4l2_mbus_fmt height definition
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Archit Taneja <architt@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1515422746-5971-1-git-send-email-kieran.bingham@ideasonboard.com>
 <20180108151353.zn2ee2tbdq2yragp@valkosipuli.retiisi.org.uk>
 <20180108153247.GA23075@bigcity.dyn.berto.se>
 <7c5ad9a4-c218-45f4-e21e-7aa9935cfd41@xs4all.nl>
 <20180108161149.GB23075@bigcity.dyn.berto.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9034ede0-e7e5-9f54-16c9-91876fe1d21d@xs4all.nl>
Date: Mon, 8 Jan 2018 17:58:25 +0100
MIME-Version: 1.0
In-Reply-To: <20180108161149.GB23075@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/08/2018 05:11 PM, Niklas Söderlund wrote:
> On 2018-01-08 16:48:35 +0100, Hans Verkuil wrote:
>> On 01/08/2018 04:32 PM, Niklas Söderlund wrote:
>>> Hi,
>>>
>>> Thanks for your patch.
>>>
>>> On 2018-01-08 17:13:53 +0200, Sakari Ailus wrote:
>>>> Hi Kieran,
>>>>
>>>> On Mon, Jan 08, 2018 at 02:45:49PM +0000, Kieran Bingham wrote:
>>>>> The v4l2_mbus_fmt width and height corresponds directly with the
>>>>> v4l2_pix_format definitions, yet the differences in documentation make
>>>>> it ambiguous what to do in the event of field heights.
>>>>>
>>>>> Clarify this by referencing the v4l2_pix_format which is explicit on the
>>>>> matter, and by matching the terminology of 'image height' rather than
>>>>> the misleading 'frame height'.
>>>
>>> Nice that this relationship is documented as it have contributed to some 
>>> confusion on my side in the past!
>>>
>>>>>
>>>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>>> ---
>>>>>  Documentation/media/uapi/v4l/subdev-formats.rst | 6 ++++--
>>>>>  include/uapi/linux/v4l2-mediabus.h              | 4 ++--
>>>>>  2 files changed, 6 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
>>>>> index b1eea44550e1..a2a00202b430 100644
>>>>> --- a/Documentation/media/uapi/v4l/subdev-formats.rst
>>>>> +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
>>>>> @@ -16,10 +16,12 @@ Media Bus Formats
>>>>>  
>>>>>      * - __u32
>>>>>        - ``width``
>>>>> -      - Image width, in pixels.
>>>>> +      - Image width in pixels. See struct
>>>>> +	:c:type:`v4l2_pix_format`.
>>>>>      * - __u32
>>>>>        - ``height``
>>>>> -      - Image height, in pixels.
>>>>> +      - Image height in pixels. See struct
>>>>> +	:c:type:`v4l2_pix_format`.
>>>>>      * - __u32
>>>>>        - ``code``
>>>>>        - Format code, from enum
>>>>> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
>>>>> index 6e20de63ec59..6b34108d0338 100644
>>>>> --- a/include/uapi/linux/v4l2-mediabus.h
>>>>> +++ b/include/uapi/linux/v4l2-mediabus.h
>>>>> @@ -18,8 +18,8 @@
>>>>>  
>>>>>  /**
>>>>>   * struct v4l2_mbus_framefmt - frame format on the media bus
>>>>> - * @width:	frame width
>>>>> - * @height:	frame height
>>>>> + * @width:	image width
>>>>> + * @height:	image height (see struct v4l2_pix_format)
>>>>
>>>> Hmm. This is the media bus format and it has no direct relation to
>>>> v4l2_pix_format. So no, I can't see what would be the point in making such
>>>> a reference.
>>>
>>> Well we have functions like v4l2_fill_pix_format() that do
>>>
>>>     pix_fmt->width = mbus_fmt->width;
>>>     pix_fmt->height = mbus_fmt->height;
>>>
>>> So I think there at least is an implicit relation between the two 
>>> structs. The issue I think Kieran is trying to address is in the case of 
>>> TOP, BOTTOM and ALTERNATE field formats. From the v4l2_pix_format 
>>> documentation on the height field:
>>>
>>>    "Image height in pixels. If field is one of V4L2_FIELD_TOP, 
>>>    V4L2_FIELD_BOTTOM or V4L2_FIELD_ALTERNATE then height refers to the 
>>>    number of lines in the field, otherwise it refers to the number of 
>>>    lines in the frame (which is twice the field height for interlaced 
>>>    formats)."
>>
>> Right, and I'd just copy this text to subdev-formats.rst rather than referring
>> to it.
>>
>>>
>>> But there are no such clear definition of the height field for 
>>> v4l2_mbus_framefmt. This have cased some confusion for us which would be 
>>> nice to clarify. I think it would be a good thing to add to the 
>>> documentation if the height in v4l2_mbus_framefmt should describe the 
>>> height of a frame or field. And if it should represent the frame height 
>>> then v4l2_fill_pix_format() and v4l2_fill_mbus_format() should be 
>>> updated to support converting from the two different formats for height.
>>
>> And that makes no sense as it would make things even more difficult.
>>
>> So I believe it's best to be clear about it and talk about image height
>> instead of frame height.
> 
> And to be clear, image height for ALTERNATE should be half the frame 
> height?

Right.

> 
>>
>> Just double check first in the code if there are any subdevs that support
>> TOP/BOTTOM/ALTERNATE and how they fill in the height, I don't think we
>> have any at the moment, but I'm not 100% certain.
> 
> A quick look and I find no subdevs which supports TOP or BOTTOM but two 
> who supports ALTERNATE, adv748x and tvp5150. And of course they handle 
> this differently.
> 
> * adv748x - adv748x_afe_fill_format()
> 
>   fmt->field = V4L2_FIELD_ALTERNATE;
>   fmt->height = afe->curr_norm & V4L2_STD_525_60 ? 480 : 576;
>   fmt->height /= 2;
> 
> * tvp5150 - tvp5150_fill_fmt()
> 
>   f->height = decoder->rect.height;
>   f->field = V4L2_FIELD_ALTERNATE;
> 
>   Where rect is from tvp5150_probe() and tvp5150_s_std()
> 
>   #define TVP5150_V_MAX_525_60    480U
>   #define TVP5150_V_MAX_OTHERS    576U
> 
>   if (tvp5150_read_std(sd) & V4L2_STD_525_60)
>           core->rect.height = TVP5150_V_MAX_525_60;
>   else
>           core->rect.height = TVP5150_V_MAX_OTHERS
> 
>   But it can be changed to any value < TVP5150_V_MAX_OTHERS in 
>   tvp5150_set_selection(). And interestingly enough it is reported as 
>   half size in .enum_frame_size() - tvp5150_enum_frame_size():
> 
>   fse->min_height = decoder->rect.height / 2;
>   fse->max_height = decoder->rect.height / 2;
> 
> Not sure how this two different solutions best should be handled and 
> which one is correct.

The first (adv748x) is correct.

The tvp5150.c should divide the height by 2in fill_fmt.

Luckily, nobody is using either get_fmt or set_fmt ops from this driver,
so the changes shouldn't affect anything.

Note that the rectangle used by the crop selection API uses *frame* coordinates,
not image coordinates. This driver handles that correctly already.

tvp5150_enum_frame_size should be removed: it is not used and in general
it makes no sense for video receivers. I think it is broken as well since
this initial check makes no sense:

       if (fse->index >= 8 || fse->code != MEDIA_BUS_FMT_UYVY8_2X8)
                return -EINVAL;

No idea where 'fse->index >= 8' comes from. It appears it just enumerates
8 identical formats!

Talking about removing functions: tvp5150_g_mbus_config should also be
dropped. It's unused by em28xx and I want to get rid of that callback since
this belongs in the device tree or usb/pci card information.

Regards,

	Hans

> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>>>
>>>>>   * @code:	data format code (from enum v4l2_mbus_pixelcode)
>>>>>   * @field:	used interlacing type (from enum v4l2_field)
>>>>>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
>>>>
>>>> -- 
>>>> Regards,
>>>>
>>>> Sakari Ailus
>>>> e-mail: sakari.ailus@iki.fi
>>>
>>
> 

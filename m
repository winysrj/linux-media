Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:59238 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751297AbdCaM3y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 08:29:54 -0400
Subject: Re: [PATCH] [media] docs-rst: clarify field vs frame height in the
 subdev API
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <20170330153820.14853-1-p.zabel@pengutronix.de>
 <1790355.cli1gBmIc5@avalon> <1490950514.2371.21.camel@pengutronix.de>
 <9fe503ab-fcf1-c56a-5acd-b1350a317d6f@xs4all.nl>
 <1490963040.2371.55.camel@pengutronix.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d75ca572-38cb-bf9b-d6b2-65dcead400ff@xs4all.nl>
Date: Fri, 31 Mar 2017 14:29:51 +0200
MIME-Version: 1.0
In-Reply-To: <1490963040.2371.55.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/03/17 14:24, Philipp Zabel wrote:
> On Fri, 2017-03-31 at 13:08 +0200, Hans Verkuil wrote:
> [...]
>>>>>  Applications are responsible for configuring coherent parameters on the
>>>>>  whole pipeline and making sure that connected pads have compatible
>>>>> @@ -379,7 +382,10 @@ is supported by the hardware.
>>>>>     pad for further processing.
>>>>>
>>>>>  2. Sink pad actual crop selection. The sink pad crop defines the crop
>>>>> -   performed to the sink pad format.
>>>>> +   performed to the sink pad format. The crop rectangle always refers to
>>>>> +   the frame size, even if the sink pad format has field order set to
>>>>> +   ``V4L2_FIELD_ALTERNATE`` and the actual processed images are only
>>>>> +   field sized.
>>>>
>>>> I'm not sure to agree with this. I think all selection rectangle coordinates 
>>>> should be expressed relative to the format of the pad they refer to.
>>>
>>> But that's not how I understood Hans yesterday, and it shows that you
>>> were quite on point with your suggestion to extend the docs.
>>
>> Actually, it is a bit different from what I said yesterday. Sorry about that.
>>
>> Whether the top and height fields in struct v4l2_rect are for fields or
>> frames depends on whether it describes memory or video. Historically
>> VIDIOC_CROPCAP and VIDIOC_G/S_CROP used frame coordinates for video
>> capture (crop rectangle) and video output (compose rectangle, i.e. what is
>> composed into the video transmitter).
> 
> Ok.
> 
>> When the selection API was added we could also describe how video is
>> composed into a memory buffer (for capture) or cropped from a memory buffer
>> (for output). Since this deals with memory the v4l2_rect struct contains
>> field coordinates, for the same reason that G/S/TRY_FMT does.
> 
> Ok. This would not apply to subdevices that only handle video streams,
> so that would mean that the v4l2_mbus_framefmt passed to
> VIDIOC_SUBDEV_G/S_FMT also should always contain the frame size, never
> the field size.
> 
>> The vivid driver *should* do all of this correctly. Since this driver
>> supports any combination of cropping/composing/scaler features it gets
>> quite complicated, so it is always possible that there are bugs, but I
>> did a lot of testing at the time.
> 
> I haven't played much with vivid in this regard yet, I've only looked at
> the capture device, and that behaved as I expected after your
> explanation.
> 
>>>> For sink pad crop rectangles, if the sink pad receives alternate (or
>>>> top or bottom only) fields, the rectangle coordinates should be
>>>> relative to the field size. Similarly, if the source pad produces
>>>> alternate/top/bottom fields, the rectangle coordinates should also be
>>>> relative to the field size.
>>>
>>> That's also not how TVP5150 currently implements it. The crop rectangle
>>> is frame sized even though the pad format reports alternating fields,
>>
>> It is undefined today what the subdev selection rectangles should use.
>> I am inclined to *always* use frame coordinates while dealing with hardware
>> (receivers, transmitters, busses) and only use field coordinates when dealing
>> with actual memory buffers.
>>
>> This will avoid having to change any subdev drivers as well, which is a nice
>> bonus. It also is consistent with the way the original API was designed:
>> frame coordinates everywhere, except when dealing with buffers in memory.
> 
> Ok, I'll revise this patch accordingly.
> 
>> For the record: the DV_TIMINGS ioctls also define the height as frame height,
>> not field height. And the height in struct v4l2_mbus_framefmt is also defined
>> as a frame height.
> 
> The v4l2_mbus_framefmt height is defined as "image height", and it
> wasn't clear to me what image meant in this context.

I looked at the header: include/uapi/linux/v4l2-mediabus.h.

There it says "frame height".

> 
>>> the same is true for vivid capture, even though that is not using the
>>> subdev selection API.
>>
>> ??? vivid uses frame height for crop coordinates when FIELD_ALTERNATE is
>> selected. Where did you see a field height when using vivid?
> 
> That's what I meant with "the same": "The crop rectangle is frame sized
> even though the [pad^W] format reports alternating fields".
> 
>> Note: by default vivid implements a scaler and composer. So switching to
>> field_alternate would still show a height of 576.
>>
>> After disabling the scaler and composer:
>>
>> v4l2-ctl -c enable_capture_scaler=0
>> v4l2-ctl -c enable_capture_composing=0
>>
>> it will now be 288.
> 
> So in this case the field size is used because S/G_FMT refer to memory.

Right.

> 
> [...]
>>> Actually, this is exactly the case I want to handle. The CSI receives
>>> FIELD_ALTERNATE frames from the TVP5150 with BT.656 synchronisation, but
>>> it produces SEQ_TB or SEQ_BT (depending on standard) at its output pad.
>>> If the input pad height is 288 lines for example, the output pad height
>>> is 576 lines (in case of no cropping or scaling), and there's a sink
>>> crop and a sink compose rectangle. Should those refer to the 288 lines
>>> per field, or to the 576 lines per frame?
>>
>> The output pad of the tvp5150 would say FIELD_ALTERNATE and height 576.
> 
> Aha, this didn't occur to me at all. This is not what happens currently.
> Commit 4f57d27be2a5 ("[media] tvp5150: fix tvp5150_fill_fmt()") reduced
> the height to half when switching to FIELD_ALTERNATE:
> 
> ----------8<----------
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 437f1a7ecb96e..c277caaad8be8 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -852,10 +852,10 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
>         tvp5150_reset(sd, 0);
>  
>         f->width = decoder->rect.width;
> -       f->height = decoder->rect.height;
> +       f->height = decoder->rect.height / 2;
>  
>         f->code = MEDIA_BUS_FMT_UYVY8_2X8;
> -       f->field = V4L2_FIELD_SEQ_TB;
> +       f->field = V4L2_FIELD_ALTERNATE;
>         f->colorspace = V4L2_COLORSPACE_SMPTE170M;
>  
>         v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", f->width,
> ---------->8----------
> 
> So this should be partially reverted to say:
>         f->height = decoder->rect.height;
> again.
> 
>> The CSI output pad would be FIELD_SEQ_BT/TB and height 576.
> 
> That I understood.
> 
>> The sink crop and sink compose rectangles should all use frame heights.
> 
> But I wasn't clear about what height those and the CSI sink pad should
> have. I now understand it should be all frame heights, both pads formats
> and selection rectangles, regardless of the field setting, as none of
> those refer to memory.

That's why I think should happen, yes.

Note: interlaced formats over subdevs are rare, the use of TOP, BOTTOM
and ALTERNATE is even rarer. Seeing inconsistent behavior in drivers is
to be expected given how seldom it is used. And everyone I know of tries
to avoid interlaced formats like the plague :-)

Regards,

	Hans

> 
>> Of course, at the low level the driver will have to check the 'field'
>> value and program the hardware accordingly by dividing the top/height by
>> two when dealing with top/bottom/alternate formats.
> 
> thanks
> Philipp
> 

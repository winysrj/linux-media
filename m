Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:48608 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932823AbdCaLIT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 07:08:19 -0400
Subject: Re: [PATCH] [media] docs-rst: clarify field vs frame height in the
 subdev API
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170330153820.14853-1-p.zabel@pengutronix.de>
 <1790355.cli1gBmIc5@avalon> <1490950514.2371.21.camel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9fe503ab-fcf1-c56a-5acd-b1350a317d6f@xs4all.nl>
Date: Fri, 31 Mar 2017 13:08:16 +0200
MIME-Version: 1.0
In-Reply-To: <1490950514.2371.21.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/03/17 10:55, Philipp Zabel wrote:
> Hi Laurent,
> 
> On Fri, 2017-03-31 at 11:09 +0300, Laurent Pinchart wrote:
>> Hi Philipp,
>>
>> Thank you for the patch.
>>
>> On Thursday 30 Mar 2017 17:38:20 Philipp Zabel wrote:
>>> VIDIOC_SUBDEV_G/S_FMT take the field size if V4L2_FIELD_ALTERNATE field
>>> order is set, but the VIDIOC_SUBDEV_G/S_SELECTION rectangles still refer
>>> to frame size, regardless of the field order setting.
>>> VIDIOC_SUBDEV_ENUM_FRAME_SIZES always returns frame sizes as opposed to
>>> field sizes.
>>>
>>> This was not immediately clear to me when reading the documentation, so
>>> this patch adds some clarifications in the relevant places.
>>>
>>> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>> ---
>>>  Documentation/media/uapi/v4l/dev-subdev.rst              | 16 +++++++++----
>>>  Documentation/media/uapi/v4l/subdev-formats.rst          |  3 ++-
>>>  .../media/uapi/v4l/vidioc-subdev-enum-frame-size.rst     |  4 ++++
>>>  .../media/uapi/v4l/vidioc-subdev-g-selection.rst         |  2 ++
>>>  4 files changed, 20 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst
>>> b/Documentation/media/uapi/v4l/dev-subdev.rst index
>>> cd28701802086..2f0a41f3796f0 100644
>>> --- a/Documentation/media/uapi/v4l/dev-subdev.rst
>>> +++ b/Documentation/media/uapi/v4l/dev-subdev.rst
>>> @@ -82,7 +82,8 @@ Pad-level Formats
>>>  .. note::
>>>
>>>      For the purpose of this section, the term *format* means the
>>> -    combination of media bus data format, frame width and frame height.
>>> +    combination of media bus data format, frame width and frame height,
>>> +    unless otherwise noted.
>>>
>>>  Image formats are typically negotiated on video capture and output
>>>  devices using the format and
>>> @@ -120,7 +121,9 @@ can expose pad-level image format configuration to
>>> applications. When they do, applications can use the
>>>
>>>  :ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` and
>>>  :ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctls. to
>>>
>>> -negotiate formats on a per-pad basis.
>>> +negotiate formats on a per-pad basis. Note that when those ioctls are
>>> +called with or return the field order set to ``V4L2_FIELD_ALTERNATE``,
>>> +the format contains the field height, which is half the frame height.
>>
>> Isn't that also the case for the TOP and BOTTOM field orders ?
> 
> Oh, those exist, too. I'll change all occurences to list ALTERNATE, TOP,
> and BOTTOM. I hope this is not going to be too verbose for people that
> don't have to care about interlacing.
> 
>>>  Applications are responsible for configuring coherent parameters on the
>>>  whole pipeline and making sure that connected pads have compatible
>>> @@ -379,7 +382,10 @@ is supported by the hardware.
>>>     pad for further processing.
>>>
>>>  2. Sink pad actual crop selection. The sink pad crop defines the crop
>>> -   performed to the sink pad format.
>>> +   performed to the sink pad format. The crop rectangle always refers to
>>> +   the frame size, even if the sink pad format has field order set to
>>> +   ``V4L2_FIELD_ALTERNATE`` and the actual processed images are only
>>> +   field sized.
>>
>> I'm not sure to agree with this. I think all selection rectangle coordinates 
>> should be expressed relative to the format of the pad they refer to.
> 
> But that's not how I understood Hans yesterday, and it shows that you
> were quite on point with your suggestion to extend the docs.

Actually, it is a bit different from what I said yesterday. Sorry about that.

Whether the top and height fields in struct v4l2_rect are for fields or
frames depends on whether it describes memory or video. Historically
VIDIOC_CROPCAP and VIDIOC_G/S_CROP used frame coordinates for video
capture (crop rectangle) and video output (compose rectangle, i.e. what is
composed into the video transmitter).

When the selection API was added we could also describe how video is
composed into a memory buffer (for capture) or cropped from a memory buffer
(for output). Since this deals with memory the v4l2_rect struct contains
field coordinates, for the same reason that G/S/TRY_FMT does.

The vivid driver *should* do all of this correctly. Since this driver
supports any combination of cropping/composing/scaler features it gets
quite complicated, so it is always possible that there are bugs, but I
did a lot of testing at the time.

>> For sink pad crop rectangles, if the sink pad receives alternate (or
>> top or bottom only) fields, the rectangle coordinates should be
>> relative to the field size. Similarly, if the source pad produces
>> alternate/top/bottom fields, the rectangle coordinates should also be
>> relative to the field size.
> 
> That's also not how TVP5150 currently implements it. The crop rectangle
> is frame sized even though the pad format reports alternating fields,

It is undefined today what the subdev selection rectangles should use.
I am inclined to *always* use frame coordinates while dealing with hardware
(receivers, transmitters, busses) and only use field coordinates when dealing
with actual memory buffers.

This will avoid having to change any subdev drivers as well, which is a nice
bonus. It also is consistent with the way the original API was designed:
frame coordinates everywhere, except when dealing with buffers in memory.

For the record: the DV_TIMINGS ioctls also define the height as frame height,
not field height. And the height in struct v4l2_mbus_framefmt is also defined
as a frame height.

> the same is true for vivid capture, even though that is not using the
> subdev selection API.

??? vivid uses frame height for crop coordinates when FIELD_ALTERNATE is
selected. Where did you see a field height when using vivid?

Note: by default vivid implements a scaler and composer. So switching to
field_alternate would still show a height of 576.

After disabling the scaler and composer:

v4l2-ctl -c enable_capture_scaler=0
v4l2-ctl -c enable_capture_composing=0

it will now be 288.

> 
> Personally, I don't care whether the selection rectangles refer to frame
> size or to the field size depending on the respective pad's field order
> setting, but I'd really like to have it clearly spelled out in the
> places this patch modifies.

Right.

>> If the subdev transforms alternate fields to progressive or interlaced
>> frames, then the sink crop rectangle should be relative to the frame
>> size.
> 
> I'm confused. The sink pad is set to alternate fields in this case,
> didn't you just argue that the sink crop/compose rectangles should refer
> to field size?
> 
> Actually, this is exactly the case I want to handle. The CSI receives
> FIELD_ALTERNATE frames from the TVP5150 with BT.656 synchronisation, but
> it produces SEQ_TB or SEQ_BT (depending on standard) at its output pad.
> If the input pad height is 288 lines for example, the output pad height
> is 576 lines (in case of no cropping or scaling), and there's a sink
> crop and a sink compose rectangle. Should those refer to the 288 lines
> per field, or to the 576 lines per frame?

The output pad of the tvp5150 would say FIELD_ALTERNATE and height 576.

The CSI output pad would be FIELD_SEQ_BT/TB and height 576.

The sink crop and sink compose rectangles should all use frame heights.
Of course, at the low level the driver will have to check the 'field'
value and program the hardware accordingly by dividing the top/height by
two when dealing with top/bottom/alternate formats.

Regards,

	Hans

>> The rationale behind this is that a subdev that receives and outputs alternate 
>> fields should only care about fields and shouldn't be aware about the full 
>> frame size.
> 
> regards
> Philipp
> 

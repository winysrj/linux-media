Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:48305 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727810AbeIJP1W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 11:27:22 -0400
Subject: Re: [PATCH v9 2/9] media: v4l: Add definitions for MPEG-2 slice
 format and metadata
To: Paul Kocialkowski <contact@paulk.fr>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180906222442.14825-1-contact@paulk.fr>
 <20180906222442.14825-3-contact@paulk.fr>
 <9a7fd34d-50e3-4db6-4752-9e62bb160655@xs4all.nl>
 <2409ba6607e85acf3dbbaed394487fa8e92d93df.camel@paulk.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bd6dd135-1719-2e25-051b-d15b1fe52d61@xs4all.nl>
Date: Mon, 10 Sep 2018 12:33:52 +0200
MIME-Version: 1.0
In-Reply-To: <2409ba6607e85acf3dbbaed394487fa8e92d93df.camel@paulk.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2018 11:47 AM, Paul Kocialkowski wrote:
> Hi,
> 
> Le lundi 10 septembre 2018 à 11:41 +0200, Hans Verkuil a écrit :
>> On 09/07/2018 12:24 AM, Paul Kocialkowski wrote:
>>> From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>>>
>>> Stateless video decoding engines require both the MPEG-2 slices and
>>> associated metadata from the video stream in order to decode frames.
>>>
>>> This introduces definitions for a new pixel format, describing buffers
>>> with MPEG-2 slice data, as well as control structure sfor passing the
>>> frame metadata to drivers.
>>>
>>> This is based on work from both Florent Revest and Hugues Fruchet.
>>>
>>> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>>> ---
>>>  .../media/uapi/v4l/extended-controls.rst      | 176 ++++++++++++++++++
>>>  .../media/uapi/v4l/pixfmt-compressed.rst      |  16 ++
>>>  .../media/uapi/v4l/vidioc-queryctrl.rst       |  14 +-
>>>  .../media/videodev2.h.rst.exceptions          |   2 +
>>>  drivers/media/v4l2-core/v4l2-ctrls.c          |  63 +++++++
>>>  drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
>>>  include/media/v4l2-ctrls.h                    |  18 +-
>>>  include/uapi/linux/v4l2-controls.h            |  65 +++++++
>>>  include/uapi/linux/videodev2.h                |   5 +
>>>  9 files changed, 351 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
>>> index 9f7312bf3365..f1951236266a 100644
>>> --- a/Documentation/media/uapi/v4l/extended-controls.rst
>>> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
>>> @@ -1497,6 +1497,182 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
>>>  
>>>  
>>>  
>>> +.. _v4l2-mpeg-mpeg2:
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS (struct)``
>>> +    Specifies the slice parameters (as extracted from the bitstream) for the
>>> +    associated MPEG-2 slice data. This includes the necessary parameters for
>>> +    configuring a stateless hardware decoding pipeline for MPEG-2.
>>> +    The bitstream parameters are defined according to :ref:`mpeg2part2`.
>>> +
>>> +.. c:type:: v4l2_ctrl_mpeg2_slice_params
>>> +
>>> +.. cssclass:: longtable
>>> +
>>> +.. flat-table:: struct v4l2_ctrl_mpeg2_slice_params
>>> +    :header-rows:  0
>>> +    :stub-columns: 0
>>> +    :widths:       1 1 2
>>> +
>>> +    * - __u32
>>> +      - ``bit_size``
>>> +      - Size (in bits) of the current slice data.
>>> +    * - __u32
>>> +      - ``data_bit_offset``
>>> +      - Offset (in bits) to the video data in the current slice data.
>>> +    * - struct :c:type:`v4l2_mpeg2_sequence`
>>> +      - ``sequence``
>>> +      - Structure with MPEG-2 sequence metadata, merging relevant fields from
>>> +	the sequence header and sequence extension parts of the bitstream.
>>> +    * - struct :c:type:`v4l2_mpeg2_picture`
>>> +      - ``picture``
>>> +      - Structure with MPEG-2 picture metadata, merging relevant fields from
>>> +	the picture header and picture coding extension parts of the bitstream.
>>> +    * - __u8
>>> +      - ``quantiser_scale_code``
>>> +      - Code used to determine the quantization scale to use for the IDCT.
>>> +    * - __u8
>>> +      - ``backward_ref_index``
>>> +      - Index for the V4L2 buffer to use as backward reference, used with
>>> +	B-coded and P-coded frames.
>>> +    * - __u8
>>> +      - ``forward_ref_index``
>>> +      - Index for the V4L2 buffer to use as forward reference, used with
>>> +	P-coded frames.
>>
>> Should this be "B-coded frames"?
> 
> Oops, that's right, B-coded frames.
> 
> Should I make a follow-up patch for that (maybe gathered with other
> changes if required)?

Follow-up patches, please. All on top of my last pull request that adds the
cedrus driver.

Regards,

	Hans

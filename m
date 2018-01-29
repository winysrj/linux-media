Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:48975 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751256AbeA2N1y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 08:27:54 -0500
Subject: Re: [Patch v7 12/12] Documention: v4l: Documentation for HEVC CIDs
To: Smitha T Murthy <smitha.t@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
References: <1516791584-7980-1-git-send-email-smitha.t@samsung.com>
 <CGME20180124112406epcas2p3820cea581731825c7ad72ebbb1ca060c@epcas2p3.samsung.com>
 <1516791584-7980-13-git-send-email-smitha.t@samsung.com>
 <127cfd7f-113f-6724-297c-6f3c3746a8ff@xs4all.nl>
 <1517229778.29374.9.camel@smitha-fedora>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f1ea8bcc-30b9-06b5-b815-e76fecc22a8a@xs4all.nl>
Date: Mon, 29 Jan 2018 14:27:46 +0100
MIME-Version: 1.0
In-Reply-To: <1517229778.29374.9.camel@smitha-fedora>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/29/2018 01:42 PM, Smitha T Murthy wrote:
> On Wed, 2018-01-24 at 15:16 +0100, Hans Verkuil wrote:
>> On 24/01/18 11:59, Smitha T Murthy wrote:
>>> Added V4l2 controls for HEVC encoder
>>>
>>> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
>>> ---
>>>  Documentation/media/uapi/v4l/extended-controls.rst | 400 +++++++++++++++++++++
>>>  1 file changed, 400 insertions(+)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
>>> index dfe49ae..46ee2bf 100644
>>> --- a/Documentation/media/uapi/v4l/extended-controls.rst
>>> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
>>> @@ -1960,6 +1960,406 @@ enum v4l2_vp8_golden_frame_sel -
>>>      1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.
>>>  
>>>  
>>> +High Efficiency Video Coding (HEVC/H.265) Control Reference
>>> +-----------------------------------------------------------
>>> +
>>> +The HEVC/H.265 controls include controls for encoding parameters of HEVC/H.265
>>> +video codec.
>>> +
>>> +
>>> +.. _hevc-control-id:
>>> +
>>> +HEVC/H.265 Control IDs
>>> +^^^^^^^^^^^^^^^^^^^^^^
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP (integer)``
>>> +    Minimum quantization parameter for HEVC.
>>> +    Valid range: from 0 to 51.
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP (integer)``
>>> +    Maximum quantization parameter for HEVC.
>>> +    Valid range: from 0 to 51.
>>
>> You probably should mention the default values for MIN_QP and MAX_QP
>> (I assume those are 0 and 51 and are not driver specific).
>>
> Yes these values are not driver specific.
> I followed the way MAX_QP and MIN_QP are defined for other codecs like
> H264, H263, MPEG4 where only valid range is mentioned.
> 
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP (integer)``
>>> +    Quantization parameter for an I frame for HEVC.
>>> +    Valid range: from 0 to 51.
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP (integer)``
>>> +    Quantization parameter for a P frame for HEVC.
>>> +    Valid range: from 0 to 51.
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP (integer)``
>>> +    Quantization parameter for a B frame for HEVC.
>>> +    Valid range: from 0 to 51.
>>
>> Sorry, this still isn't clear to me.
>>
>> If I set V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP to 50, can I then still set
>> V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP to 51? Or is 50 then the maximum?
>>
>> In other words, what is the relationship between these three controls
>> and the MIN_QP/MAX_QP controls.
>>
> If we set V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP as 50 then
> V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP or
> 4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP or
> V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP will have maximum as 50.
> Similarly for minimum as well, the above three controls will adhere to
> the V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP set.
> These controls have similar in relation as seen with
> V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP and V4L2_CID_MPEG_VIDEO_H264_MAX_QP 
> 
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP (boolean)``
>>> +    HIERARCHICAL_QP allows the host to specify the quantization parameter
>>> +    values for each temporal layer through HIERARCHICAL_QP_LAYER. This is
>>> +    valid only if HIERARCHICAL_CODING_LAYER is greater than 1. Setting the
>>> +    control value to 1 enables setting of the QP values for the layers.
>>> +
>>> +.. _v4l2-hevc-hier-coding-type:
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE``
>>> +    (enum)
>>> +
>>> +enum v4l2_mpeg_video_hevc_hier_coding_type -
>>> +    Selects the hierarchical coding type for encoding. Possible values are:
>>> +
>>> +.. raw:: latex
>>> +
>>> +    \begin{adjustbox}{width=\columnwidth}
>>> +
>>> +.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
>>> +
>>> +.. flat-table::
>>> +    :header-rows:  0
>>> +    :stub-columns: 0
>>> +
>>> +    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B``
>>> +      - Use the B frame for hierarchical coding.
>>> +    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P``
>>> +      - Use the P frame for hierarchical coding.
>>> +
>>> +.. raw:: latex
>>> +
>>> +    \end{adjustbox}
>>> +
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER (integer)``
>>> +    Selects the hierarchical coding layer. In normal encoding
>>> +    (non-hierarchial coding), it should be zero. Possible values are [0, 6].
>>> +    0 indicates HIERARCHICAL CODING LAYER 0, 1 indicates HIERARCHICAL CODING
>>> +    LAYER 1 and so on.
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP (integer)``
>>> +    Indicates quantization parameter for hierarchical coding layer 0.
>>> +    For HEVC it can have a value of 0-51.
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP (integer)``
>>> +    Indicates quantization parameter for hierarchical coding layer 1.
>>> +    For HEVC it can have a value of 0-51.
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP (integer)``
>>> +    Indicates quantization parameter for hierarchical coding layer 2.
>>> +    For HEVC it can have a value of 0-51.
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP (integer)``
>>> +    Indicates quantization parameter for hierarchical coding layer 3.
>>> +    For HEVC it can have a value of 0-51.
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP (integer)``
>>> +    Indicates quantization parameter for hierarchical coding layer 4.
>>> +    For HEVC it can have a value of 0-51.
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP (integer)``
>>> +    Indicates quantization parameter for hierarchical coding layer 5.
>>> +    For HEVC it can have a value of 0-51.
>>> +
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP (integer)``
>>> +    Indicates quantization parameter for hierarchical coding layer 6.
>>> +    For HEVC it can have a value of 0-51.
>>
>> Same here: how does MIN_QP/MAX_QP influence these controls, if at all.
>>
>> Regards,
>>
>> 	Hans
>>
>>
> The values set in V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP and
> V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP will give the limits for the L0-L6 QP
> values that can be set.

OK. If you can clarify this in the documentation, then I can Ack this.

Note: if userspace changes MIN_QP or MAX_QP, then the driver should call
v4l2_ctrl_modify_range() to update the ranges of the controls that are
impacted by QP range changes. I'm not sure if that's done at the moment.

Regards,

	Hans
